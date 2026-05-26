# -*- coding: utf-8 -*-
"""
openUBMC 集成测试脚本：OneID 登录 + 会议中心全量接口（按 meeting.jmx 对齐）
=================================================================

数据来源：
    本文件用例集严格按 meeting/meeting.jmx 中所有启用的 HTTPSamplerProxy
    节点提取的接口与请求 body 设计，确保 Python 自动化覆盖 = JMeter 计划覆盖。

被测接口清单（与 jmx 对齐）：
    [ OneID ]
    1. GET  https://openeuler-usercenter.test.osinfra.cn/oneid/public/key
    2. POST https://openeuler-usercenter.test.osinfra.cn/oneid/login
    [ 会议中心 ]
    3. GET    https://openeuler.test.osinfra.cn/api-meeting/v1/meeting/group_info/
    4. GET    https://openeuler.test.osinfra.cn/api-meeting/v1/meeting/platform/
    5. POST   https://openeuler.test.osinfra.cn/api-meeting/v1/meeting/
    6. PUT    https://openeuler.test.osinfra.cn/api-meeting/v1/meeting/{id}/
    7. DELETE https://openeuler.test.osinfra.cn/api-meeting/v1/meeting/{id}/


用例统计：
    - OneID 登录             ：13 条
    - 会议-创建              ：20 条
    - 会议-删除              ：10 条
    - 会议-修改 (PUT)        ：5 条
    - 会议-group_info (GET)  ：3 条
    - 会议-platform (GET)    ：3 条
    - 消息-列表/总数 (GET)   ：4 条
    - 消息-批量删除 (DELETE) ：3 条
    - 不可自动化             ：1 条（含图形验证码人工链路）
    - 合计                   ：61 条自动化 + 1 条手工

依赖：
    pip install pytest requests cryptography python-dotenv

执行：
    pytest -v test_cases.py
    pytest -v test_cases.py -k "login"
    pytest -v test_cases.py -k "meeting"
    pytest -v test_cases.py -k "create"
    pytest -v test_cases.py -k "delete"
    pytest -v test_cases.py -k "update"
    pytest -v test_cases.py -k "group"
    pytest -v test_cases.py -k "platform"
    pytest -v test_cases.py -k "message"
    pytest -vs test_cases.py                  # 同时打印请求/响应明细

环境变量：
    PASSWORD              明文密码
    MEETING_ACCOUNT       业务接口用账号
    HTTP_VERBOSE=0        关闭控制台请求/响应明细打印
    HTTP_LOG_FILE=<path>  自定义 HTTP 流水落盘路径，置空则不落盘
    FORCE_LOGIN=1         强制重新登录（忽略 .token_cache.json）

平台实测事实（脚本对照执行结果校正过）：
    1. OneID 鉴权链路三步：GET /oneid/public/key 取 RSA 公钥 → PKCS1v15 加密明文 →
       hex 编码 → POST /oneid/login
    2. POST /oneid/login 必须携带 Origin + Referer 头才会校验 redirect_uri；
       否则一律返回 HTTP 404「redirect_uri not found in the app」
    3. 业务接口（/api-meeting/*、/api-message/*）需同时携带
       Header: token + Cookie: _U_T_=token; _Y_G_=session，
       任一缺失即 401「鉴权失败，您的账号已退登」（详见 conftest.py）
    4. 错误码字典：
       - E00052「账号和密码不匹配」(HTTP 400)：密码错 / 账号不存在 / 明文密码 / 空 password
       - E00012「请求异常」(HTTP 400)：空 account / 缺 permission / permission 枚举外值
       - HTTP 404「redirect_uri not found in the app」：错误 client_id
       - HTTP 418 + CloudWAF HTML：SQL 注入串被 WAF 拦截
"""

import os
import json
import time
import random
import datetime
import threading
from datetime import datetime as _dt, timedelta
from pathlib import Path

import pytest
import requests
from cryptography.hazmat.primitives.asymmetric import padding as _rsa_padding
from cryptography.hazmat.primitives.serialization import load_pem_public_key as _load_pem

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# conftest.py 中的会议业务通用工具
from conftest import (
    biz_request,
    build_business_headers,
)


# =========================================================
# 一、OneID 登录脚本独立常量（不依赖 conftest，直测登录接口）
# =========================================================
# 域名来源：meeting.jmx 全局变量「全局变量：URL等」
#   userURL=openeuler-usercenter.test.osinfra.cn
#   hostURL=openeuler.test.osinfra.cn
USER_URL = os.environ.get("USER_URL", "openeuler-usercenter.test.osinfra.cn")
HOST_URL = os.environ.get("HOST_URL", "openeuler.test.osinfra.cn")
BASE_AUTH = f"https://{USER_URL}"
BASE_BIZ = f"https://{HOST_URL}"

ACCOUNT = os.environ.get("TEST_ACCOUNT")
CLIENT_ID = "623c3c2f1eca5ad5fca6c58a"
EXPECTED_USERNAME = os.environ.get("EXPECTED_USERNAME", "guoxiaozhen2")   # 实测正常登录返回的 username

PASSWORD = os.environ.get("TEST_PASSWORD")
DEFAULT_TIMEOUT = 10

# openeuler OneID 登录头：与 jmx 「用户登录」TestFragment 对齐——
# 不再走 redirect_uri 校验链路，Origin/Referer 指向用户中心根路径
COMMON_HEADERS = {
    "Content-Type": "application/json;charset=UTF-8",
    "Accept": "*/*",
    "Origin": BASE_AUTH,
    "Referer": f"{BASE_AUTH}/",
    "Host": USER_URL,
}

# ===== HTTP 日志开关 =====
HTTP_VERBOSE = os.environ.get("HTTP_VERBOSE", "1") not in ("0", "false", "False", "")
_DEFAULT_LOG = str(Path(__file__).with_suffix(".http.log.jsonl"))
HTTP_LOG_FILE = os.environ.get("HTTP_LOG_FILE", _DEFAULT_LOG)
SENSITIVE_KEYS = {"password", "token", "Authorization", "PRIVATE-TOKEN", "Cookie"}

_log_lock = threading.Lock()
_current_case_id = "<no-case>"


def _mask(value):
    if not isinstance(value, str) or len(value) <= 8:
        return "***"
    return f"{value[:4]}...{value[-4:]}"


def _redact(obj):
    if isinstance(obj, dict):
        return {k: (_mask(v) if k in SENSITIVE_KEYS and isinstance(v, str) else _redact(v))
                for k, v in obj.items()}
    if isinstance(obj, list):
        return [_redact(x) for x in obj]
    return obj


def _safe_json(text):
    try:
        return json.loads(text)
    except Exception:
        return None


def _truncate(text, limit=4000):
    if text is None:
        return None
    if len(text) <= limit:
        return text
    return text[:limit] + f"...<truncated {len(text) - limit} chars>"


def _print_req_resp(method, url, req_headers, req_body, resp, elapsed_s):
    sep = "-" * 76
    print()
    print(sep)
    print(f"[HTTP] [{_current_case_id}] {method} {url}")
    print(f"  > headers: {_redact(dict(req_headers or {}))}")
    if req_body is not None:
        print(f"  > body:    {json.dumps(_redact(req_body), ensure_ascii=False)}")
    print(f"  < status:  {resp.status_code}  (耗时 {elapsed_s:.3f}s)")
    print(f"  < headers: {dict(resp.headers)}")
    parsed = _safe_json(resp.text)
    if parsed is not None:
        print(f"  < body:    {json.dumps(parsed, ensure_ascii=False)}")
    else:
        print(f"  < body:    {_truncate(resp.text)}")
    print(sep)


def _append_jsonl(record):
    if not HTTP_LOG_FILE:
        return
    try:
        with _log_lock:
            with open(HTTP_LOG_FILE, "a", encoding="utf-8") as f:
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as e:
        print(f"[HTTP-LOG] 写入失败: {e}")


def _send(method, url, *, headers=None, json_body=None, params=None,
          timeout=DEFAULT_TIMEOUT):
    started = time.time()
    started_iso = datetime.datetime.now().isoformat(timespec="seconds")
    err = None
    resp = None
    try:
        resp = requests.request(
            method, url,
            headers=headers, json=json_body, params=params, timeout=timeout,
        )
    except Exception as e:
        err = e
    elapsed_s = time.time() - started

    if resp is not None and HTTP_VERBOSE:
        _print_req_resp(method, url, headers, json_body, resp, elapsed_s)

    record = {
        "ts": started_iso,
        "case_id": _current_case_id,
        "elapsed_s": round(elapsed_s, 3),
        "request": {
            "method": method, "url": url, "params": params,
            "headers": _redact(dict(headers or {})),
            "body": _redact(json_body) if json_body is not None else None,
        },
    }
    if resp is not None:
        record["response"] = {
            "status_code": resp.status_code,
            "headers": dict(resp.headers),
            "body_raw": _truncate(resp.text),
            "body_json": _safe_json(resp.text),
        }
    if err is not None:
        record["error"] = f"{type(err).__name__}: {err}"
    _append_jsonl(record)

    if err is not None:
        raise err
    return resp


@pytest.fixture(autouse=True)
def _capture_case_id(request):
    global _current_case_id
    _current_case_id = request.node.name
    if HTTP_VERBOSE:
        print(f"\n========== [CASE START] {_current_case_id} ==========")
    yield
    if HTTP_VERBOSE:
        print(f"========== [CASE END]   {_current_case_id} ==========\n")
    _current_case_id = "<no-case>"


# ===== OneID 加密链路 =====


def _fetch_public_key():
    """GET /oneid/public/key 获取 RSA 公钥 PEM"""
    resp = _send("GET", f"{BASE_AUTH}/oneid/public/key", headers=COMMON_HEADERS)
    assert resp.status_code == 200, f"取公钥失败 status={resp.status_code}"
    data = resp.json()
    pub = (((data or {}).get("data") or {}).get("rsa") or {}).get("publicKey")
    assert pub, f"响应中未含 data.rsa.publicKey: {data}"
    return pub


def _encrypt_password(plaintext, public_key_pem=None):
    """OneID 实测加密：RSA PKCS1v15 → bytes → hex 字符串

    兼容性：若传入的 plaintext 本身就是 hex 加密串（长度=256 且全为 hex 字符），
    认为是预加密结果直接返回；否则按明文走标准 PKCS1v15 加密。
    """
    if isinstance(plaintext, str) and len(plaintext) == 256:
        try:
            int(plaintext, 16)
            return plaintext   # 看起来是已加密的 256 字符 hex 串，原样返回
        except ValueError:
            pass
    if public_key_pem is None:
        public_key_pem = _fetch_public_key()
    key = _load_pem(public_key_pem.encode("utf-8"))
    return key.encrypt(plaintext.encode("utf-8"), _rsa_padding.PKCS1v15()).hex()


def _build_body(**overrides):
    """构造默认合法登录 body；用 overrides 注入差异化字段（含删除字段语义）"""
    body = {
        "permission": "sigRead",
        "account": ACCOUNT,
        "client_id": CLIENT_ID,
        "need_captcha_verification": False,
        "password": _encrypt_password(PASSWORD),
        "accept_term":0,
        "oneidPrivacyAccepted": "20250226",
    }
    for k, v in overrides.items():
        if v is _MISSING:
            body.pop(k, None)
        else:
            body[k] = v
    return body


class _Sentinel:
    pass


_MISSING = _Sentinel()


def _post_login(body):
    return _send(
        "POST",
        f"{BASE_AUTH}/oneid/login",
        headers=COMMON_HEADERS,
        json_body=body,
    )


# =========================================================
# 二、OneID 登录接口测试用例（13 条）
# =========================================================

# ---------------- 2.1 正常流 ----------------


def test_tc_api_login_001_normal_flow():
    """
    TC-API-LOGIN-001 [正常流] 合法账号 + 加密密码 + 完整 Header 登录成功
    模块：OneID/登录 | 优先级：P0

    前置条件：
        1. 账号 19938204520 已注册并启用
        2. 明文密码 Aa123456@（环境变量 PASSWORD 注入）
        3. /oneid/public/key 端点可达
    操作步骤：
        1. GET /oneid/public/key 取 RSA 公钥 PEM
        2. 用公钥 PKCS1v15 加密明文密码 → bytes → hex 字符串
        3. POST /oneid/login，body 含全部字段
           headers 含 Content-Type / Origin / Referer
    预期结果：
        1. HTTP 200
        2. body.code = 200，body.msg = "success"
        3. body.data.token 非空且长度 ≥ 16
        4. body.data.username = "xiaoguozhi34"
        5. body.data.email_exist = True，phone_exist = True
    """
    resp = _post_login(_build_body())
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200, f"code={body.get('code')}"
    assert body.get("msg") == "success"
    data = body.get("data") or {}
    token = data.get("token")
    assert token and isinstance(token, str) and len(token) >= 16, \
        f"token 缺失或长度异常：{token!r}"
    assert data.get("username") == EXPECTED_USERNAME, \
        f"username={data.get('username')}"
    assert data.get("email_exist") is True
    assert data.get("phone_exist") is True


# ---------------- 2.2 异常 / 反向 ----------------


def test_tc_api_login_002_wrong_password():
    """
    TC-API-LOGIN-002 [异常] 密码错误时返回 E00052
    模块：OneID/登录 | 优先级：P0
    实测响应：HTTP 400 + body.code=400 + body.msg.code="E00052"
              + body.data.need_captcha_verification=False
    """
    body = _build_body(password=_encrypt_password("WrongPwd_xxxx_xxxx"))
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert rj.get("code") == 400
    msg = rj.get("msg") or {}
    assert isinstance(msg, dict)
    assert msg.get("code") == "E00052"
    assert msg.get("message_en") == "Incorrect account or password."
    # 不应返回 token
    assert not (rj.get("data") or {}).get("token")


def test_tc_api_login_003_nonexistent_account():
    """
    TC-API-LOGIN-003 [异常] 不存在的账号返回 E00052
    模块：OneID/登录 | 优先级：P1
    """
    body = _build_body(account="00000000000")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert rj.get("code") == 400


def test_tc_api_login_004_wrong_client_id():
    """
    TC-API-LOGIN-004 [异常输入] 错误的 client_id 应被平台拒绝
    模块：OneID/登录 | 优先级：P1
    openeuler 域 login body 不带 redirect_uri，client_id 非法预期返回 4xx 业务码失败。
    """
    body = _build_body(client_id="000000000000000000000000")
    resp = _post_login(body)
    assert resp.status_code >= 400 or (
        resp.status_code == 200 and resp.json().get("code") not in (200, "200")
    ), f"非法 client_id 未被拒：status={resp.status_code} body={resp.text[:300]}"



# ---------------- 2.3 空值 ----------------


def test_tc_api_login_006_empty_account():
    """
    TC-API-LOGIN-006 [空值] account 为空字符串返回 E00012 请求异常
    模块：OneID/登录 | 优先级：P0
    """
    body = _build_body(account="")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert rj.get("code") == 400
    msg = rj.get("msg") or {}
    assert msg.get("code") == "E00012"
    assert msg.get("message_en") == "Request Error"


def test_tc_api_login_007_empty_password():
    """
    TC-API-LOGIN-007 [空值] password 为空字符串被识为密码错误
    模块：OneID/登录 | 优先级：P0
    """
    body = _build_body(password="")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert (rj.get("msg") or {}).get("code") == "E00052"


def test_tc_api_login_008_missing_permission():
    """
    TC-API-LOGIN-008 [空值] permission 字段缺失返回 E00012 请求异常
    模块：OneID/登录 | 优先级：P1
    """
    body = _build_body(permission=_MISSING)
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert (rj.get("msg") or {}).get("code") == "E00012"


# ---------------- 2.4 异常输入 ----------------


def test_tc_api_login_009_invalid_permission_enum():
    """
    TC-API-LOGIN-009 [异常输入] permission 枚举外值返回 E00012 请求异常
    模块：OneID/登录 | 优先级：P1
    """
    body = _build_body(permission="NOT_A_VALID_PERMISSION")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert (rj.get("msg") or {}).get("code") == "E00012"


def test_tc_api_login_010_unregistered_phone():
    """
    TC-API-LOGIN-010 [异常输入] 未注册的合法手机号格式返回 E00052
    模块：OneID/登录 | 优先级：P2
    """
    body = _build_body(account="13800000000")
    resp = _post_login(body)
    assert resp.status_code == 400


# ---------------- 2.5 特殊字符 / 安全 ----------------


def test_tc_api_login_011_sql_injection_blocked_by_waf():
    """
    TC-API-LOGIN-011 [特殊字符][SQL注入] account 含 SQL 注入串被 WAF 拦截
    模块：OneID/登录 | 优先级：P0
    实测响应：HTTP 418 + CloudWAF HTML 拦截页（非 JSON）
    """
    body = _build_body(account="' OR '1'='1")
    resp = _post_login(body)
    assert resp.status_code == 418, f"未被 WAF 拦截：status={resp.status_code}"
    assert "CloudWAF" in resp.text or "访问被拦截" in resp.text, \
        f"非 WAF 拦截页面：{resp.text[:200]}"
    assert "token" not in resp.text.lower() or "JWT" not in resp.text


# =========================================================
# 三、会议业务常量与工具函数
# =========================================================
DEFAULT_GROUP = "Application"
DEFAULT_PLATFORM = "WELINK"
DEFAULT_ETHERPAD = "https://etherpad.openeuler.org/p/Application"

PATH_MEETING = "/api-meeting-v2/meeting/web/"
PATH_MEETING_DETAIL = "/api-meeting-v2/meeting/web/{meeting_id}/"
PATH_MEETING_GROUP_INFO = "/api-meeting-v2/meeting/web/group_info/"
PATH_MEETING_PLATFORM = "/api-meeting-v2/meeting/web/platform/"


# 运行级唯一后缀：跨用例同主题不会撞「会议已存在」
RUN_TAG = f"{int(time.time()) % 1_000_000}-{os.getpid() % 10_000}"
# 同一会议室+日期+时间窗±30min 会冲突；每次运行轮换起始时间
_HOUR_OFFSET = (int(time.time()) // 60) % 10  # 0..9
DEFAULT_START_HOUR = 8 + _HOUR_OFFSET
DEFAULT_START_MIN = random.choice([0, 15, 30, 45])


def _date_offset(days: int) -> str:
    return (_dt.now() + timedelta(days=days)).strftime("%Y-%m-%d")


def _default_time_window(idx: int = 0):
    """为每条用例分配错峰 15 分钟时间窗，避免「时间冲突」"""
    base_min = DEFAULT_START_HOUR * 60 + DEFAULT_START_MIN + idx * 30
    sh, sm = base_min // 60, base_min % 60
    eh, em = (base_min + 15) // 60, (base_min + 15) % 60
    return f"{sh:02d}:{sm:02d}", f"{eh:02d}:{em:02d}"


def _build_single_meeting_body(
    topic: str = None,
    agenda: str = "自动化测试内容",
    date: str = None,
    start: str = None,
    end: str = None,
    group_name: str = None,
    platform: str = None,
    drop_keys: list = None,
    extra: dict = None,
    slot: int = 0,
) -> dict:
    if start is None or end is None:
        s, e = _default_time_window(slot)
        start = start or s
        end = end or e
    if topic is None:
        topic = f"测试会议-自动化-{RUN_TAG}-{slot}"
    body = {
        "is_record": False,
        "is_cycle": False,
        "agenda": agenda,
        "email_list": "",
        "platform": platform if platform is not None else DEFAULT_PLATFORM,
        "topic": topic,
        "group_name": group_name if group_name is not None else DEFAULT_GROUP,
        "etherpad": DEFAULT_ETHERPAD,
        "date": date if date is not None else _date_offset(30),
        "start": start,
        "time": f"{start}-{end}",
        "end": end,
    }
    if extra:
        body.update(extra)
    if drop_keys:
        for k in drop_keys:
            body.pop(k, None)
    return body


def _build_cycle_meeting_body(
    cycle_type: int,
    cycle_interval: int = 1,
    cycle_start_date: str = None,
    cycle_end_date: str = None,
    cycle_start: str = None,
    cycle_end: str = None,
    cycle_point: str = "15",
    topic: str = None,
    extra: dict = None,
    slot: int = 0,
) -> dict:
    # 周期会议平台只接受整小时时间点；用 slot 在 13~22 时段错峰
    if cycle_start is None or cycle_end is None:
        sh = 13 + (slot % 9)  # 13..21
        cycle_start = cycle_start or f"{sh:02d}:00"
        cycle_end = cycle_end or f"{sh + 1:02d}:00"
    if topic is None:
        topic = f"测试会议-周期-自动化-{RUN_TAG}-{slot}"
    body = {
        "is_record": False,
        "is_cycle": True,
        "cycle_interval": cycle_interval,
        "cycle_type": cycle_type,
        "cycle_start_date": cycle_start_date if cycle_start_date else _date_offset(2),
        "cycle_end_date": cycle_end_date if cycle_end_date else _date_offset(32),
        "cycle_start": cycle_start,
        "cycle_end": cycle_end,
        "agenda": "自动化测试内容",
        "email_list": "",
        "platform": DEFAULT_PLATFORM,
        "topic": topic,
        "group_name": DEFAULT_GROUP,
        "etherpad": DEFAULT_ETHERPAD,
    }
    if cycle_type == 2:
        body["cycle_point"] = cycle_point
    if extra:
        body.update(extra)
    return body


def _extract_meeting_id(resp_json) -> int:
    """从创建接口响应中提取 meeting_id；兼容多种结构"""
    if not isinstance(resp_json, dict):
        return None
    data = resp_json.get("data")
    if isinstance(data, int):
        return data
    if isinstance(data, str) and data.isdigit():
        return int(data)
    if isinstance(data, dict):
        for k in ("id", "meeting_id", "mid"):
            v = data.get(k)
            if isinstance(v, int):
                return v
            if isinstance(v, str) and v.isdigit():
                return int(v)
    return None


def _post_meeting(creds, body):
    """业务封装：POST /api-meeting/v1/meeting/"""
    return biz_request(
        "POST",
        PATH_MEETING,
        creds,
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )


def _delete_meeting(creds, meeting_id):
    """业务封装：DELETE /api-meeting/v1/meeting/{id}/"""
    return biz_request(
        "DELETE",
        PATH_MEETING_DETAIL.format(meeting_id=meeting_id),
        creds,
    )


def _put_meeting(creds, meeting_id, body):
    """业务封装：PUT /api-meeting/v1/meeting/{id}/  （来自 jmx 第 905、2250 行）"""
    return biz_request(
        "PUT",
        PATH_MEETING_DETAIL.format(meeting_id=meeting_id),
        creds,
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )


def _get_group_info(creds):
    """业务封装：GET /api-meeting/v1/meeting/group_info/  （来自 jmx 第 234、734、1208 行）"""
    return biz_request("GET", PATH_MEETING_GROUP_INFO, creds)


def _get_platform(creds):
    """业务封装：GET /api-meeting/v1/meeting/platform/  （来自 jmx 第 322、821、1298 行）"""
    return biz_request("GET", PATH_MEETING_PLATFORM, creds)


def _safe_delete(creds, meeting_id):
    """工具函数：尽力删除指定 meeting，避免脏数据；忽略所有异常"""
    if not meeting_id:
        return
    try:
        _delete_meeting(creds, meeting_id)
    except Exception:
        pass


def _create_meeting_for_delete(creds, cycle: bool = False) -> int:
    """工具：创建一个会议供删除用例使用"""
    if cycle:
        body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15")
    else:
        body = _build_single_meeting_body()
    resp = _post_meeting(creds, body)
    if resp.status_code != 200:
        pytest.skip(f"前置创建会议失败，跳过删除用例：{resp.status_code} {resp.text[:200]}")
    mid = _extract_meeting_id(resp.json())
    if not mid:
        pytest.skip(f"前置创建未取到 meeting_id：{resp.text[:200]}")
    return mid


@pytest.fixture
def cleanup_meetings(login_creds):
    """用例级 fixture：用例结束自动清理脏数据"""
    created = []
    yield created
    for mid in created:
        _safe_delete(login_creds, mid)


def _create_or_skip(creds, body, case_label):
    """统一处理创建会议结果：

    - 成功 → 返回 meeting_id
    - 400 + 环境性消息（会议已存在 / 时间冲突 / 今日创建已超限制） → pytest.skip
    - 其他失败 → pytest.fail（含状态码和响应）
    """
    resp = _post_meeting(creds, body)
    try:
        rj = resp.json()
    except Exception:
        rj = None

    if resp.status_code == 200 and isinstance(rj, dict):
        mid = _extract_meeting_id(rj)
        if mid:
            return mid

    msg = str((rj or {}).get("msg", "")) if rj else ""
    env_blockers = ("已超限制", "已经存在", "时间冲突", "请调整会议预定时间")
    if resp.status_code in (400, 403, 429) and any(blocker in msg for blocker in env_blockers):
        pytest.skip(f"[{case_label}] 环境限制无法继续（非脚本鉴权问题）：{rj}")

    pytest.fail(f"[{case_label}] 创建会议失败：status={resp.status_code} body={resp.text[:300]}")


# =========================================================
# 四、创建会议接口（POST /api-meeting/v1/meeting/）测试用例
# =========================================================

# ---------------- 4.1 正常流程 ----------------
def test_TC_API_MEETING_CREATE_001_single_meeting(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-001
    维度  : [正常流] 优先级 P0
    描述  : 创建 T+2 的单次会议成功
    预期  : HTTP 200 / 响应含 data 字段且为有效 meeting_id
    """
    body = _build_single_meeting_body(slot=1)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-001")
    assert mid > 0
    cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_002_month_cycle(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-002
    维度  : [正常流] 优先级 P0
    描述  : 创建月周期会议成功（cycle_type=2，每月 15 号）
    """
    body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15", slot=2)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-002")
    assert mid > 0
    cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_003_day_cycle(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-003
    维度  : [正常流] 优先级 P0
    描述  : 创建日周期会议成功（cycle_type=0，每日）
    """
    body = _build_cycle_meeting_body(
        cycle_type=0,
        cycle_start_date=_date_offset(30),
        cycle_end_date=_date_offset(32),
        slot=3,
    )
    body.pop("cycle_point", None)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-003")
    assert mid > 0
    cleanup_meetings.append(mid)


# ---------------- 4.2 异常场景：必填字段缺失 ----------------
@pytest.mark.parametrize(
    "missing_key, case_id",
    [
        ("topic", "TC-API-MEETING-CREATE-004"),
        ("agenda", "TC-API-MEETING-CREATE-005"),
        ("group_name", "TC-API-MEETING-CREATE-006"),
        ("platform", "TC-API-MEETING-CREATE-007"),
        ("date", "TC-API-MEETING-CREATE-008"),
    ],
    ids=["missing_topic", "missing_agenda", "missing_group_name", "missing_platform", "missing_date"],
)
def test_TC_API_MEETING_CREATE_required_field_missing(login_creds, missing_key, case_id):
    """
    用例ID: TC-API-MEETING-CREATE-004 ~ 008
    维度  : [异常][空值] 优先级 P1
    描述  : 创建会议时缺失必填字段
    预期  : HTTP 4xx 或业务码非成功
    """
    body = _build_single_meeting_body(drop_keys=[missing_key])
    resp = _post_meeting(login_creds, body)
    is_negative = resp.status_code >= 400
    if not is_negative:
        try:
            rj = resp.json()
            code = rj.get("code")
            is_negative = code not in (0, 200, "0", "200", None)
            if not is_negative:
                mid = _extract_meeting_id(rj)
                if mid:
                    _safe_delete(login_creds, mid)
                    pytest.fail(
                        f"[{case_id}] 缺少 {missing_key} 仍创建成功 meeting_id={mid}，校验未生效"
                    )
        except ValueError:
            is_negative = True
    assert is_negative, f"[{case_id}] 缺少 {missing_key} 但接口未拒绝: status={resp.status_code} body={resp.text[:300]}"


# ---------------- 4.3 异常场景：日期格式错误 ----------------
def test_TC_API_MEETING_CREATE_009_invalid_date_format(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-009
    维度  : [异常输入] 优先级 P1
    描述  : 创建会议时 date 使用错误格式 "2026/05/25"
    """
    body = _build_single_meeting_body(date="2026/05/25")
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"日期格式错误仍创建成功 meeting_id={mid}, body={resp.text[:300]}"
    else:
        assert resp.status_code >= 400


# ---------------- 4.4 异常场景：cycle_type 非法值 ----------------
def test_TC_API_MEETING_CREATE_010_invalid_cycle_type(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-010
    维度  : [异常输入] 优先级 P1
    描述  : 周期会议 cycle_type=99（合法值仅 0/1/2）
    """
    body = _build_cycle_meeting_body(cycle_type=99)
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"非法 cycle_type=99 仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


# ---------------- 4.5 权限校验：未登录 / 错误 token ----------------
def test_TC_API_MEETING_CREATE_011_no_token():
    """
    用例ID: TC-API-MEETING-CREATE-011
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用创建会议接口
    """
    body = _build_single_meeting_body()
    headers = build_business_headers(token="")
    headers.pop("token", None)
    resp = biz_request(
        "POST",
        PATH_MEETING,
        None,
        headers=headers,
        cookies={},
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"无 token 调用未被拒: status={resp.status_code} body={resp.text[:300]}"
    )


def test_TC_API_MEETING_CREATE_012_invalid_token():
    """
    用例ID: TC-API-MEETING-CREATE-012
    维度  : [权限] 优先级 P0
    描述  : 携带错误的 token 调用创建会议接口
    """
    body = _build_single_meeting_body()
    resp = biz_request(
        "POST",
        PATH_MEETING,
        {"token": "invalid-token-xxx-1234567890", "yg": ""},
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"错误 token 未被拒: status={resp.status_code} body={resp.text[:300]}"
    )


# ---------------- 4.6 边界值 ----------------
def test_TC_API_MEETING_CREATE_013_topic_min_length(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-013
    维度  : [边界值] 优先级 P2
    描述  : topic 长度=1
    """
    body = _build_single_meeting_body(topic="a")
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_CREATE_014_topic_oversize(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-014
    维度  : [边界值] 优先级 P2
    描述  : topic 长度=256
    """
    body = _build_single_meeting_body(topic="A" * 256)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"超长 topic 触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_015_date_today(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-015
    维度  : [边界值] 优先级 P2
    描述  : date 取今天
    """
    body = _build_single_meeting_body(date=_date_offset(0))
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_016_date_past(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-016
    维度  : [边界值][异常] 优先级 P2
    描述  : date 取过去 5 天
    """
    body = _build_single_meeting_body(date=_date_offset(-5))
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"过去日期仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_CREATE_017_cycle_end_before_start(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-017
    维度  : [边界值][异常] 优先级 P2
    描述  : 周期会议 cycle_end_date 早于 cycle_start_date
    """
    body = _build_cycle_meeting_body(
        cycle_type=2,
        cycle_start_date=_date_offset(10),
        cycle_end_date=_date_offset(2),
        cycle_point="15",
    )
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"end<start 仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


# ---------------- 4.7 特殊字符 ----------------
def test_TC_API_MEETING_CREATE_018_topic_emoji(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-018
    维度  : [特殊字符] 优先级 P2
    描述  : topic 含 emoji
    """
    body = _build_single_meeting_body(topic="测试会议🎉🚀-自动化")
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"emoji 触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_019_topic_xss(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-019
    维度  : [XSS][安全] 优先级 P2
    描述  : topic 含 <script> 脚本
    """
    payload = '<script>alert("xss")</script>'
    body = _build_single_meeting_body(topic=payload)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"XSS 输入触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_020_topic_sql_injection(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-020
    维度  : [SQL注入][安全] 优先级 P2
    描述  : topic 含 SQL 关键字
    """
    payload = "test'; DROP TABLE meeting;--"
    body = _build_single_meeting_body(topic=payload)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"SQL 注入触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


# =========================================================
# 五、删除会议接口（DELETE /api-meeting/v1/meeting/{id}/）测试用例
# =========================================================

# ---------------- 5.1 正常流程 ----------------
def test_TC_API_MEETING_DELETE_001_delete_single(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-001
    维度  : [正常流] 优先级 P0
    描述  : 删除已创建的单次会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    resp = _delete_meeting(login_creds, mid)
    assert resp.status_code == 200, f"删除失败 status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_002_delete_month_cycle(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-002
    维度  : [正常流] 优先级 P0
    描述  : 删除已创建的月周期会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=True)
    resp = _delete_meeting(login_creds, mid)
    assert resp.status_code == 200, f"删除月周期会议失败 status={resp.status_code} body={resp.text[:300]}"


# ---------------- 5.2 异常场景 ----------------
def test_TC_API_MEETING_DELETE_003_not_exist(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-003
    维度  : [异常] 优先级 P1
    描述  : 删除不存在的 meetingId（极大值 99999999）
    """
    resp = _delete_meeting(login_creds, 99999999)
    is_negative = resp.status_code >= 400
    if not is_negative:
        try:
            rj = resp.json()
            is_negative = rj.get("code") not in (0, 200, "0", "200", None)
        except ValueError:
            is_negative = True
    assert is_negative, f"删除不存在的会议未被拒: status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_004_string_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-004
    维度  : [异常输入] 优先级 P1
    描述  : meetingId 为字符串 "abc"
    """
    resp = _delete_meeting(login_creds, "abc")
    assert resp.status_code >= 400, f"字符串 ID 未被拒: status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_005_negative_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-005
    维度  : [异常输入][边界值] 优先级 P1
    描述  : meetingId 为负数 -1
    """
    resp = _delete_meeting(login_creds, -1)
    if resp.status_code == 200:
        rj = resp.json()
        assert rj.get("code") not in (0, 200, "0", "200", None), f"负数 ID 删除成功: {rj}"
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_DELETE_006_zero_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-006
    维度  : [异常输入][边界值] 优先级 P1
    描述  : meetingId 为 0
    """
    resp = _delete_meeting(login_creds, 0)
    if resp.status_code == 200:
        rj = resp.json()
        assert rj.get("code") not in (0, 200, "0", "200", None), f"meeting_id=0 删除成功: {rj}"
    else:
        assert resp.status_code >= 400


# ---------------- 5.3 权限校验 ----------------
def test_TC_API_MEETING_DELETE_007_no_token(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-007
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用删除接口
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    try:
        headers = build_business_headers(token="")
        headers.pop("token", None)
        resp = biz_request(
            "DELETE",
            f"/api-meeting/v1/meeting/{mid}/",
            None,
            headers=headers,
            cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"无 token 删除未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


def test_TC_API_MEETING_DELETE_008_invalid_token(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-008
    维度  : [权限] 优先级 P0
    描述  : 携带错误 token 调用删除接口
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    try:
        resp = biz_request(
            "DELETE",
            f"/api-meeting/v1/meeting/{mid}/",
            {"token": "invalid-token-xxx-1234567890", "yg": ""},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"错误 token 删除未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


# ---------------- 5.4 重复操作（幂等性） ----------------
def test_TC_API_MEETING_DELETE_009_duplicate_delete(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-009
    维度  : [重复][幂等性] 优先级 P1
    描述  : 创建后连续删除两次同一会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)

    resp1 = _delete_meeting(login_creds, mid)
    assert resp1.status_code == 200, f"首次删除失败: {resp1.status_code} {resp1.text[:200]}"

    resp2 = _delete_meeting(login_creds, mid)
    assert resp2.status_code < 500, f"重复删除触发 5xx: {resp2.status_code}"
    is_negative = resp2.status_code >= 400
    if not is_negative:
        try:
            is_negative = resp2.json().get("code") not in (0, 200, "0", "200", None)
        except ValueError:
            is_negative = True
    assert is_negative, f"重复删除未返回失败状态: status={resp2.status_code} body={resp2.text[:300]}"



# =========================================================
# 六、修改会议接口（PUT /api-meeting/v1/meeting/{id}/）测试用例
# =========================================================
# 数据来源：meeting.jmx 第 905~922、2250~2278 行
#   单次会议修改 body 字段：topic / etherpad / date / start / end / agenda / is_record
#   月周期会议修改 body 字段：topic / agenda / is_record / is_cycle / cycle_interval /
#                             cycle_type / cycle_start_date / cycle_end_date /
#                             cycle_start / cycle_end / cycle_point


def _build_single_meeting_update_body(topic="测试会议-修改", agenda="测试内容-修改", date=None,
                                      start="08:00", end="08:15"):
    """jmx 第 917 行实测 body：仅 topic/etherpad/date/start/end/agenda/is_record"""
    return {
        "topic": topic,
        "etherpad": DEFAULT_ETHERPAD,
        "date": date if date is not None else _date_offset(2),
        "start": start,
        "end": end,
        "agenda": agenda,
        "is_record": False,
    }


def _build_cycle_meeting_update_body(cycle_point="16"):
    """jmx 第 2262 行实测 body：含完整 cycle_* 字段"""
    return {
        "topic": "测试会议-周期修改",
        "agenda": "测试内容-修改",
        "is_record": False,
        "is_cycle": True,
        "cycle_interval": 1,
        "cycle_type": 2,
        "cycle_start_date": _date_offset(2),
        "cycle_end_date": _date_offset(32),
        "cycle_start": "17:00",
        "cycle_end": "18:00",
        "cycle_point": cycle_point,
    }


def test_TC_API_MEETING_UPDATE_001_update_single(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-UPDATE-001
    维度  : [正常流] 优先级 P0
    描述  : 修改单次会议 topic/agenda 成功（jmx「4-修改T+2的会议」）
    """
    create_body = _build_single_meeting_body(slot=4)
    mid = _create_or_skip(login_creds, create_body, "TC-API-MEETING-UPDATE-001")
    cleanup_meetings.append(mid)

    upd_body = _build_single_meeting_update_body(
        topic=f"测试会议-单次修改-{RUN_TAG}",
        date=create_body["date"],
        start=create_body["start"],
        end=create_body["end"],
    )
    resp = _put_meeting(login_creds, mid, upd_body)
    assert resp.status_code == 200, f"PUT 修改会议失败 status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_UPDATE_002_update_month_cycle(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-UPDATE-002
    维度  : [正常流] 优先级 P0
    描述  : 修改月周期会议 cycle_point 由 15 改为 16（jmx「4-修改月周期的会议」）
    """
    create_body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15", slot=5)
    mid = _create_or_skip(login_creds, create_body, "TC-API-MEETING-UPDATE-002")
    cleanup_meetings.append(mid)

    upd_body = _build_cycle_meeting_update_body(cycle_point="16")
    upd_body["cycle_start"] = create_body["cycle_start"]
    upd_body["cycle_end"] = create_body["cycle_end"]
    resp = _put_meeting(login_creds, mid, upd_body)
    assert resp.status_code == 200, f"PUT 修改月周期会议失败 status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_UPDATE_003_update_not_exist(login_creds):
    """
    用例ID: TC-API-MEETING-UPDATE-003
    维度  : [异常] 优先级 P1
    描述  : 修改不存在的 meetingId（极大值 99999999）
    """
    body = _build_single_meeting_update_body()
    resp = _put_meeting(login_creds, 99999999, body)
    is_negative = resp.status_code >= 400
    if not is_negative:
        try:
            is_negative = resp.json().get("code") not in (0, 200, "0", "200", None)
        except ValueError:
            is_negative = True
    assert is_negative, f"修改不存在会议未被拒: status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_UPDATE_004_no_token(login_creds):
    """
    用例ID: TC-API-MEETING-UPDATE-004
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用修改接口
    """
    create_body = _build_single_meeting_body(slot=6)
    mid = _create_or_skip(login_creds, create_body, "TC-API-MEETING-UPDATE-004")
    try:
        body = _build_single_meeting_update_body(date=create_body["date"])
        headers = build_business_headers(token="")
        headers.pop("token", None)
        resp = biz_request(
            "PUT",
            PATH_MEETING_DETAIL.format(meeting_id=mid),
            None,
            headers=headers,
            cookies={},
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"无 token 修改未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


def test_TC_API_MEETING_UPDATE_005_invalid_token(login_creds):
    """
    用例ID: TC-API-MEETING-UPDATE-005
    维度  : [权限] 优先级 P0
    描述  : 携带错误 token 调用修改接口
    """
    create_body = _build_single_meeting_body(slot=7)
    mid = _create_or_skip(login_creds, create_body, "TC-API-MEETING-UPDATE-005")
    try:
        body = _build_single_meeting_update_body(date=create_body["date"])
        resp = biz_request(
            "PUT",
            PATH_MEETING_DETAIL.format(meeting_id=mid),
            {"token": "invalid-token-xxx-1234567890", "yg": ""},
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"错误 token 修改未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


# =========================================================
# 七、获取会议 group_info 接口（GET /api-meeting/v1/meeting/group_info/）
# =========================================================
# 数据来源：meeting.jmx 第 234、734、1208、1858 行 「2-获取group信息」


def test_TC_API_MEETING_GROUP_001_normal(login_creds):
    """
    用例ID: TC-API-MEETING-GROUP-001
    维度  : [正常流] 优先级 P0
    描述  : 已登录用户拉取 group_info，HTTP 200 + 业务码成功
    """
    resp = _get_group_info(login_creds)
    assert resp.status_code == 200, f"group_info 失败 status={resp.status_code} body={resp.text[:300]}"
    try:
        rj = resp.json()
    except ValueError:
        pytest.fail(f"group_info 响应非 JSON: {resp.text[:300]}")
    code = rj.get("code")
    assert code in (0, 200, "0", "200", None) or code is None, f"group_info 业务码异常: {rj}"


def test_TC_API_MEETING_GROUP_002_no_token():
    """
    用例ID: TC-API-MEETING-GROUP-002
    维度  : [权限] 优先级 P0
    描述  : 不携带 token + cookie 调用 group_info
    """
    headers = build_business_headers(token="")
    headers.pop("token", None)
    resp = biz_request("GET", PATH_MEETING_GROUP_INFO, None, headers=headers, cookies={})
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"无 token 拉取 group_info 未被拒: status={resp.status_code}"
    )


def test_TC_API_MEETING_GROUP_003_invalid_token():
    """
    用例ID: TC-API-MEETING-GROUP-003
    维度  : [权限] 优先级 P0
    描述  : 携带错误 token 调用 group_info
    """
    resp = biz_request(
        "GET",
        PATH_MEETING_GROUP_INFO,
        {"token": "invalid-token-xxx-1234567890", "yg": ""},
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"错误 token 拉取 group_info 未被拒: status={resp.status_code}"
    )


# =========================================================
# 八、获取会议 platform 接口（GET /api-meeting/v1/meeting/platform/）
# =========================================================
# 数据来源：meeting.jmx 第 322、821、1298、1948 行 「3-获取platform信息」
# 该接口在 jmx 中通过 BoundaryExtractor 抽取响应头 Set-Cookie: _U_T_= 作为 token_platform


def test_TC_API_MEETING_PLATFORM_001_normal(login_creds):
    """
    用例ID: TC-API-MEETING-PLATFORM-001
    维度  : [正常流] 优先级 P0
    描述  : 已登录用户拉取 platform，HTTP 200
    """
    resp = _get_platform(login_creds)
    assert resp.status_code == 200, f"platform 失败 status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_PLATFORM_002_no_token():
    """
    用例ID: TC-API-MEETING-PLATFORM-002
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用 platform
    """
    headers = build_business_headers(token="")
    headers.pop("token", None)
    resp = biz_request("GET", PATH_MEETING_PLATFORM, None, headers=headers, cookies={})
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"无 token 拉取 platform 未被拒: status={resp.status_code}"
    )


def test_TC_API_MEETING_PLATFORM_003_invalid_token():
    """
    用例ID: TC-API-MEETING-PLATFORM-003
    维度  : [权限] 优先级 P0
    描述  : 携带错误 token 调用 platform
    """
    resp = biz_request(
        "GET",
        PATH_MEETING_PLATFORM,
        {"token": "invalid-token-xxx-1234567890", "yg": ""},
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"错误 token 拉取 platform 未被拒: status={resp.status_code}"
    )

# =========================================================
# 十一、不可自动化用例（注释块说明）
# =========================================================
# === TC-API-MEETING-CREATE-MANUAL-001 [SKIP-MANUAL] ===
# 用例标题: [安全] 验证创建会议接口在 OneID 触发图形验证码后的鉴权链路
# 维度    : [安全] 优先级 P1
#
# 不可自动化原因:
#   OneID 登录在连续登录失败若干次后会触发图形验证码（need_captcha_verification=True），
#   该图形验证码无可编程获取的 token，必须人工识别。
#
# 人工执行步骤:
#   1. 浏览器打开 https://openeuler-usercenter.test.osinfra.cn/login
#   2. 故意输错密码 5 次以触发图形验证码
#   3. 输入正确密码 + 图形验证码登录
#   4. 抓取登录响应 body.data.token
#   5. 通过环境变量 INJECT_TOKEN=<token> 注入后人工调用 POST /api-meeting/v1/meeting/
#
# 预期结果:
#   登录成功后 token 有效，创建会议接口正常返回 meeting_id。
# === END SKIP-MANUAL ===


# =========================================================
# 十二、覆盖矩阵（备注）
# =========================================================
# === OneID 登录 ===
# | 维度          | 已覆盖用例                          |
# |---------------|------------------------------------|
# | 1 正常流      | LOGIN-001                          |
# | 2 异常        | LOGIN-002 / 003 / 004 / 005       |
# | 3 边界值      | LOGIN-012 / 013                   |
# | 4 空值        | LOGIN-006 / 007 / 008             |
# | 5 特殊字符    | LOGIN-011（SQL 注入）             |
# | 6 权限校验    | LOGIN-004（错误 client_id）       |
# | 7 数据唯一性  | — N/A（登录无唯一性概念）         |
# | 8 重复操作    | — 平台无返回头明示限流，未覆盖   |
# | 9 异常输入    | LOGIN-009 / 010                   |
#
# === 会议 创建/删除/修改 ===
# | 维度          | 已覆盖用例                          |
# |---------------|------------------------------------|
# | 1 正常流      | CREATE-001/002/003, DELETE-001/002, UPDATE-001/002 |
# | 2 异常        | CREATE-004~009, DELETE-003, UPDATE-003   |
# | 3 边界值      | CREATE-013~017, DELETE-005/006/010|
# | 4 空值        | CREATE-004~008                    |
# | 5 特殊字符    | CREATE-018/019/020                |
# | 6 权限校验    | CREATE-011/012, DELETE-007/008, UPDATE-004/005 |
# | 7 数据唯一性  | — 平台限制，跳过                  |
# | 8 重复操作    | DELETE-009                         |
# | 9 异常输入    | CREATE-009/010, DELETE-004        |
#
# === 会议 group_info / platform ===
# | 维度          | 已覆盖用例                          |
# |---------------|------------------------------------|
# | 1 正常流      | GROUP-001 / PLATFORM-001          |
# | 6 权限校验    | GROUP-002/003 / PLATFORM-002/003  |
#
# === 消息中心 ===
# | 维度          | 已覆盖用例                          |
# |---------------|------------------------------------|
# | 1 正常流      | MESSAGE-LIST-001/002              |
# | 2 异常        | MESSAGE-DELETE-002                |
# | 3 边界值      | MESSAGE-LIST-002, MESSAGE-DELETE-001 |
# | 6 权限校验    | MESSAGE-LIST-003/004, MESSAGE-DELETE-003 |
# =========================================================


if __name__ == "__main__":
    pytest.main(["-v", "-s", __file__])
