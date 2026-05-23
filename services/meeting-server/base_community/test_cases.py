# -*- coding: utf-8 -*-
"""
测试用例脚本：openEuler Meeting Service 接口测试

来源：D:\\gxz\\ai_gxz\\meeting\\testCases.md（由 meeting.jmx 转化而来）
用例总数：39 | 自动化：38 | 手工：1
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests pytest-dependency

执行：
    # 设置必需环境变量后运行
    set TOKEN=                                  # 留空即由 auth_token fixture 自动登录获取
    set PASSWORD=<oneid_encrypted_password>     # OneID 加密后的密码串（必填）
    pytest -v testCases.py
    pytest -v testCases.py -k LOGIN             # 按模块执行
    pytest -v testCases.py -m "not manual"      # 仅自动化用例（默认全跑）

查看真实请求/响应：
    1. 控制台实时打印（需加 -s 关掉 pytest 标准输出捕获）：
         pytest -vs testCases.py
       打印格式：
         [HTTP] POST https://.../oneid/login
           > headers: {...}
           > body:    {...}
           < status:  200  (耗时 0.43s)
           < headers: {...}
           < body:    {...}

    2. 落盘 jsonl 流水（默认开启，覆盖写）：
         testCases.http.log.jsonl   每条记录含 case_id + request + response 完整内容
       关闭打印：set HTTP_VERBOSE=0 后再执行 pytest
       关闭落盘：set HTTP_LOG_FILE=  后再执行 pytest
       自定义路径：set HTTP_LOG_FILE=D:/logs/run-001.jsonl

占位符（执行前由环境变量或 fixture 注入）：
    PASSWORD                  —— OneID 加密后的密码串（用户必填）
    TOKEN                     —— 登录后获得，由 auth_token fixture 自动注入
    USER_INPUT_other_meeting_id —— 他人创建的 meeting_id（仅 SKIP-MANUAL 用例 MEETING-015 需要）

待人工执行：
    全文件中所有 # === [SKIP-MANUAL] === 注释块（共 1 条：MEETING-015 越权场景）
"""

import os
import json
import time
import datetime
import threading
from pathlib import Path

import pytest
import requests
from dotenv import load_dotenv
load_dotenv()  # 自动读 .env 文件

# RSA 加密用于 OneID 登录（platform 实测要求 hex 编码的 PKCS1v15 密文）
from cryptography.hazmat.primitives.asymmetric import padding as _rsa_padding
from cryptography.hazmat.primitives.serialization import load_pem_public_key as _load_pem

# ===== 模块级常量 =====
BASE_AUTH = "https://usercenter.openubmc.test.osinfra.cn"
BASE_API = "https://openubmc-website.test.osinfra.cn"

ACCOUNT = "19938204520"
CLIENT_ID = "672b25d8b92861baa16ce1e3"   # 实测真实 client_id（来自前端 bundle 反查）
REDIRECT_URI = "https://openubmc-website.test.osinfra.cn/personal/meeting"

# ===== 占位符注入 =====
# PASSWORD 现在直接传**明文**密码；脚本内部走 OneID 公钥加密流程
PASSWORD = os.environ.get("PASSWORD", "Aa123456@")
DEFAULT_TIMEOUT = 10
WAIT_AFTER_WRITE = 5  # 联动用例的等待秒数

# ===== HTTP 日志开关 =====
# HTTP_VERBOSE=1 时在控制台打印请求/响应（需配合 pytest -s 才能看到）
HTTP_VERBOSE = os.environ.get("HTTP_VERBOSE", "1") not in ("0", "false", "False", "")
# HTTP_LOG_FILE 指定落盘 jsonl 文件路径；置空则不落盘；默认与本脚本同目录
_DEFAULT_LOG = str(Path(__file__).with_suffix(".http.log.jsonl"))
HTTP_LOG_FILE = os.environ.get("HTTP_LOG_FILE", _DEFAULT_LOG)
# 敏感字段在日志中脱敏（保留前后 4 个字符）
SENSITIVE_KEYS = {"password", "token", "Authorization", "PRIVATE-TOKEN", "Cookie"}

_log_lock = threading.Lock()
_current_case_id = "<no-case>"


def _mask(value):
    if not isinstance(value, str) or len(value) <= 8:
        return "***"
    return f"{value[:4]}...{value[-4:]}"


def _redact(obj):
    """递归脱敏：dict 中命中 SENSITIVE_KEYS 的 value 替换为掩码"""
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
    """控制台打印请求/响应（仅在 HTTP_VERBOSE 时调用）"""
    sep = "-" * 76
    print()
    print(sep)
    print(f"[HTTP] [{_current_case_id}] {method} {url}")
    print(f"  > headers: {_redact(dict(req_headers or {}))}")
    if req_body is not None:
        print(f"  > body:    {json.dumps(_redact(req_body), ensure_ascii=False)}")
    print(f"  < status:  {resp.status_code}  (耗时 {elapsed_s:.3f}s)")
    print(f"  < headers: {dict(resp.headers)}")
    body_text = _truncate(resp.text)
    parsed = _safe_json(resp.text)
    if parsed is not None:
        print(f"  < body:    {json.dumps(parsed, ensure_ascii=False)}")
    else:
        print(f"  < body:    {body_text}")
    print(sep)


def _append_jsonl(record):
    if not HTTP_LOG_FILE:
        return
    try:
        with _log_lock:
            with open(HTTP_LOG_FILE, "a", encoding="utf-8") as f:
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as e:
        # 日志失败不应阻断测试
        print(f"[HTTP-LOG] 写入失败: {e}")


def _send(method, url, *, headers=None, json_body=None, params=None,
          timeout=DEFAULT_TIMEOUT):
    """统一的 HTTP 调用包装：发请求 + 打印 + 落盘日志，返回 requests.Response"""
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
            "method": method,
            "url": url,
            "params": params,
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
        if HTTP_VERBOSE:
            print(f"[HTTP] [{_current_case_id}] {method} {url} 异常: {record['error']}")

    _append_jsonl(record)

    if err is not None:
        raise err
    return resp


@pytest.fixture(autouse=True)
def _capture_case_id(request):
    """每条用例执行前后维护 _current_case_id，便于日志追踪"""
    global _current_case_id
    _current_case_id = request.node.name
    if HTTP_VERBOSE:
        print(f"\n========== [CASE START] {_current_case_id} ==========")
    yield
    if HTTP_VERBOSE:
        print(f"========== [CASE END]   {_current_case_id} ==========\n")
    _current_case_id = "<no-case>"


# ===== 共享 fixture =====


def _fetch_public_key():
    """GET /oneid/public/key 获取 RSA 公钥（PEM 格式）"""
    resp = _send(
        "GET",
        f"{BASE_AUTH}/oneid/public/key",
        headers={"Content-Type": "application/json"},
    )
    assert resp.status_code == 200, f"获取公钥失败 status={resp.status_code}"
    data = resp.json()
    pub = (((data or {}).get("data") or {}).get("rsa") or {}).get("publicKey")
    assert pub, f"响应中未含 data.rsa.publicKey: {data}"
    return pub


def _encrypt_password(plaintext, public_key_pem):
    """OneID 实测加密流程：RSA PKCS1v15 → bytes → hex 字符串"""
    key = _load_pem(public_key_pem.encode("utf-8"))
    ciphertext = key.encrypt(plaintext.encode("utf-8"), _rsa_padding.PKCS1v15())
    return ciphertext.hex()


def _login(account, plaintext_password, client_id=CLIENT_ID,
           redirect_uri=REDIRECT_URI):
    """完整登录流程：取公钥 → 加密密码 → POST /oneid/login，返回 requests.Response"""
    pub = _fetch_public_key()
    enc_pwd = _encrypt_password(plaintext_password, pub)
    return _send(
        "POST",
        f"{BASE_AUTH}/oneid/login",
        headers={
            "Content-Type": "application/json",
            "Origin": BASE_AUTH,
            "Referer": f"{BASE_AUTH}/login",
        },
        json_body={
            "permission": "sigRead",
            "account": account,
            "client_id": client_id,
            "redirect_uri": redirect_uri,
            "password": enc_pwd,
            "oneidPrivacyAccepted": "20240830",
        },
    )


@pytest.fixture(scope="session")
def auth_token():
    """会话级 token：完整 OneID 登录链路（取公钥 + RSA 加密 + 登录）"""
    if not PASSWORD:
        pytest.skip("环境变量 PASSWORD 未设置，无法登录获取 token")
    resp = _login(ACCOUNT, PASSWORD)
    assert resp.status_code == 200, f"login failed: {resp.status_code} {resp.text[:300]}"
    body = resp.json()
    # OneID 实测响应结构：token 既可能在顶层，也可能在 data.token
    token = body.get("token") or (body.get("data") or {}).get("token")
    assert token and len(token) >= 16, f"token 缺失或长度异常: body={body}"
    return token


def _auth_headers(token, charset_utf8=False):
    h = {"token": token}
    h["Content-Type"] = (
        "application/json;charset=UTF-8" if charset_utf8 else "application/json"
    )
    return h


# ============================================================================
# 模块 A：OneID 登录（POST /oneid/login）
# ============================================================================


def test_tc_api_login_001_normal_flow():
    """
    TC-API-LOGIN-001 [正常流] 合法账号密码登录返回 token
    模块：用户中心/登录 | 优先级：P0

    前置条件：
        1. 测试账号 19938204520 已注册并启用
        2. 已知该账号明文密码 PASSWORD（环境变量注入，默认 Aa123456@）
        3. OneID 平台公钥可通过 GET /oneid/public/key 获取
    操作步骤（实测加密链路）：
        1. GET /oneid/public/key 拿 RSA 公钥 PEM
        2. 用公钥 PKCS1v15 加密明文密码 → bytes → hex 字符串
        3. POST /oneid/login，body 含 redirect_uri + 加密后 password
    预期结果：
        1. HTTP 200
        2. 响应 body 含 token 字段且为非空字符串
        3. token 长度 ≥ 16
    """
    if not PASSWORD:
        pytest.skip("环境变量 PASSWORD 未设置")
    resp = _login(ACCOUNT, PASSWORD)
    assert resp.status_code == 200, f"login failed: {resp.status_code} {resp.text[:300]}"
    body = resp.json()
    # OneID 实测响应结构：token 既可能在顶层，也可能在 data.token
    token = body.get("token") or (body.get("data") or {}).get("token")
    assert token, f"token 字段为空: body={body}"
    assert isinstance(token, str)
    assert len(token) >= 16


def test_tc_api_login_002_wrong_password():
    """
    TC-API-LOGIN-002 [异常] 密码错误时不返回 token
    模块：用户中心/登录 | 优先级：P0
    """
    # 用真实加密流程注入错误密码（保持鉴权路径走通，仅密码错）
    pub = _fetch_public_key()
    enc_pwd = _encrypt_password("wrongpwd_xxxx_xxxx", pub)
    resp = _send("POST",
        f"{BASE_AUTH}/oneid/login",
        json_body={
            "permission": "sigRead",
            "account": ACCOUNT,
            "client_id": CLIENT_ID,
            "redirect_uri": REDIRECT_URI,
            "password": enc_pwd,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    body = resp.json() if resp.headers.get("content-type", "").startswith("application/json") else {}
    token = body.get("token")
    assert not token, f"密码错误却返回了 token: {token!r}"


def test_tc_api_login_003_missing_account():
    """
    TC-API-LOGIN-003 [空值] account 字段缺失
    模块：用户中心/登录 | 优先级：P1
    """
    resp = _send("POST",
        f"{BASE_AUTH}/oneid/login",
        json_body={
            "permission": "sigRead",
            "client_id": CLIENT_ID,
            "password": PASSWORD or "any",
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 401, 422), f"unexpected status: {resp.status_code}"
    body = resp.json() if resp.headers.get("content-type", "").startswith("application/json") else {}
    assert not body.get("token")


def test_tc_api_login_004_missing_password():
    """
    TC-API-LOGIN-004 [空值] password 字段缺失
    模块：用户中心/登录 | 优先级：P1
    """
    resp = _send("POST",
        f"{BASE_AUTH}/oneid/login",
        json_body={
            "permission": "sigRead",
            "account": ACCOUNT,
            "client_id": CLIENT_ID,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert 400 <= resp.status_code < 500
    body = resp.json() if resp.headers.get("content-type", "").startswith("application/json") else {}
    assert not body.get("token")


def test_tc_api_login_005_invalid_client_id():
    """
    TC-API-LOGIN-005 [异常输入] client_id 不存在/无效
    模块：用户中心/登录 | 优先级：P1
    """
    resp = _send("POST",
        f"{BASE_AUTH}/oneid/login",
        json_body={
            "permission": "sigRead",
            "account": ACCOUNT,
            "client_id": "000000000000000000000000",
            "password": PASSWORD or "any",
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 401, 403, 422)
    body = resp.json() if resp.headers.get("content-type", "").startswith("application/json") else {}
    assert not body.get("token")


# ============================================================================
# 模块 B：消息中心（GET /api-message/message_center/all、DELETE /inner）
# ============================================================================


def test_tc_api_msg_001_list_count_normal(auth_token):
    """
    TC-API-MSG-001 [正常流] 携带合法 token 查询消息总数
    模块：消息中心/列表 | 优先级：P0
    """
    resp = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert isinstance(body.get("count"), (int, float))
    assert body["count"] >= 0


def test_tc_api_msg_002_list_with_pagination(auth_token):
    """
    TC-API-MSG-002 [正常流] 带 page_num + count_per_page 查询
    模块：消息中心/列表 | 优先级：P1
    """
    resp = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        params={"page_num": 1, "count_per_page": 400},
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert isinstance(body.get("count"), (int, float))
    assert body["count"] >= 0


def test_tc_api_msg_003_list_no_token():
    """
    TC-API-MSG-003 [权限] 不带 token 时拒绝访问
    模块：消息中心/列表 | 优先级:P0
    """
    resp = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


def test_tc_api_msg_004_list_invalid_token():
    """
    TC-API-MSG-004 [权限] token 错误时拒绝访问
    模块：消息中心/列表 | 优先级：P1
    """
    resp = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers={"token": "invalid_token_xxx_yyy_zzz", "Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


def test_tc_api_msg_005_list_count_per_page_zero(auth_token):
    """
    TC-API-MSG-005 [边界值] count_per_page=0 时的处理
    模块：消息中心/列表 | 优先级：P2
    """
    resp = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        params={"page_num": 1, "count_per_page": 0},
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 400)
    if resp.status_code == 200:
        body = resp.json()
        assert body.get("count", -1) >= 0


def test_tc_api_msg_006_clear_inner_normal(auth_token):
    """
    TC-API-MSG-006 [正常流] 携带合法 token 清空内部消息
    模块：消息中心/清理 | 优先级：P1
    """
    resp = _send("DELETE",
        f"{BASE_API}/api-message/message_center/inner",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200
    # 调用后 GET /all 校验 count 仍 ≥ 0（不强断言下降，因 inner 在 all 中占比未知）
    verify = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert verify.status_code == 200
    assert verify.json().get("count", -1) >= 0


def test_tc_api_msg_007_clear_inner_no_token():
    """
    TC-API-MSG-007 [权限] 不带 token 时拒绝清空
    模块：消息中心/清理 | 优先级：P0
    """
    resp = _send("DELETE",
        f"{BASE_API}/api-message/message_center/inner",
        headers={"Content-Type": "application/json"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


# ============================================================================
# 模块 C：会议管理（单次会议）
# ============================================================================


def test_tc_api_meeting_001_get_group_info(auth_token):
    """
    TC-API-MEETING-001 [正常流] 合法 token 获取分组信息
    模块：会议/前置 | 优先级：P0
    """
    resp = _send("GET",
        f"{BASE_API}/api-meeting/v1/meeting/group_info/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200
    assert resp.text  # 响应 body 非空


def test_tc_api_meeting_002_get_group_info_no_token():
    """
    TC-API-MEETING-002 [权限] 不带 token 时拒绝
    模块：会议/前置 | 优先级：P1
    """
    resp = _send("GET",
        f"{BASE_API}/api-meeting/v1/meeting/group_info/",
        headers={"Content-Type": "application/json;charset=UTF-8"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


def test_tc_api_meeting_003_get_platform(auth_token):
    """
    TC-API-MEETING-003 [正常流] 合法 token 获取平台信息
    模块：会议/前置 | 优先级：P0
    """
    resp = _send("GET",
        f"{BASE_API}/api-meeting/v1/meeting/platform/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200
    assert resp.text  # 应含 WELINK 等平台信息


def _meeting_body_single(date="2026-05-25", start="08:00", end="08:15",
                         topic="测试会议", platform="WELINK",
                         group_name="infrastructrue", **overrides):
    """构造单次会议 body 工具函数"""
    body = {
        "is_record": False,
        "agenda": "测试内容",
        "email_list": "",
        "platform": platform,
        "topic": topic,
        "group_name": group_name,
        "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
        "date": date,
        "start": start,
        "time": f"{start}-{end}",
        "end": end,
    }
    body.update(overrides)
    return body


@pytest.mark.dependency(name="create_meeting")
def test_tc_api_meeting_004_create_normal(auth_token):
    """
    TC-API-MEETING-004 [正常流] 创建 T+2 单次会议返回 meeting_id
    模块：会议/创建 | 优先级：P0
    """
    body = _meeting_body_single()
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers={
            **_auth_headers(auth_token, charset_utf8=True),
            "Origin": BASE_API,
            "Referer": f"{BASE_API}/personal/meeting",
        },
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 201)
    rj = resp.json()
    assert isinstance(rj.get("data"), int)
    assert rj["data"] >= 0
    pytest.shared_meeting_id = rj["data"]   # 跨用例传递


def test_tc_api_meeting_005_create_missing_topic(auth_token):
    """
    TC-API-MEETING-005 [空值] topic 字段缺失
    模块：会议/创建 | 优先级：P0
    """
    body = _meeting_body_single()
    body.pop("topic", None)
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_meeting_006_invalid_platform(auth_token):
    """
    TC-API-MEETING-006 [异常输入] platform 枚举外值
    模块：会议/创建 | 优先级：P1
    """
    body = _meeting_body_single(platform="INVALID_PLATFORM_XXX")
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_meeting_007_past_date(auth_token):
    """
    TC-API-MEETING-007 [异常] date 为过去日期
    模块：会议/创建 | 优先级：P1
    """
    body = _meeting_body_single(date="2020-01-01")
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_meeting_008_start_ge_end(auth_token):
    """
    TC-API-MEETING-008 [异常] start >= end 时拒绝
    模块：会议/创建 | 优先级：P1
    """
    body = _meeting_body_single(start="08:15", end="08:00")
    body["time"] = "08:15-08:00"
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_meeting_009_topic_special_chars(auth_token):
    """
    TC-API-MEETING-009 [特殊字符] topic 含 emoji 与中英文混合
    模块：会议/创建 | 优先级：P2
    """
    body = _meeting_body_single(topic="测试会议-Meeting🚀Test")
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 201)
    rj = resp.json()
    assert isinstance(rj.get("data"), int) and rj["data"] >= 0


def test_tc_api_meeting_010_create_no_token():
    """
    TC-API-MEETING-010 [权限] 不带 token 创建会议被拒绝
    模块：会议/创建 | 优先级：P0
    """
    body = _meeting_body_single()
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers={"Content-Type": "application/json;charset=UTF-8"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


def test_tc_api_meeting_011_create_msg_linkage(auth_token):
    """
    TC-API-MEETING-011 [联动] 创建会议后 message_center 消息总数应增加
    模块：会议/创建 + 消息联动 | 优先级：P1
    """
    # count_before
    r0 = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert r0.status_code == 200
    count_before = r0.json().get("count", 0)

    # 创建会议（与 MEETING-004 错开时间段，避免冲突）
    body = _meeting_body_single(start="09:00", end="09:15", topic="测试会议-联动")
    body["time"] = "09:00-09:15"
    r1 = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert r1.status_code in (200, 201)
    assert isinstance(r1.json().get("data"), int)

    # 等 5s 后再查
    time.sleep(WAIT_AFTER_WRITE)
    r2 = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    assert r2.status_code == 200
    count_after = r2.json().get("count", 0)
    assert count_after > count_before, (
        f"创建会议后消息总数未增加：before={count_before} after={count_after}"
    )


@pytest.mark.dependency(depends=["create_meeting"])
def test_tc_api_meeting_012_modify_normal(auth_token):
    """
    TC-API-MEETING-012 [正常流] 修改已存在会议的字段
    模块：会议/修改 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例 MEETING-004 未产出 meeting_id")
    resp = _send("PUT",
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        json_body={
            "topic": "测试会议",
            "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
            "date": "2026-05-26",
            "start": "08:00",
            "end": "08:15",
            "agenda": "测试内容",
            "is_record": False,
        },
        headers={
            **_auth_headers(auth_token, charset_utf8=True),
            "Origin": BASE_API,
            "Referer": f"{BASE_API}/personal/meeting",
        },
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200


def test_tc_api_meeting_013_modify_nonexistent(auth_token):
    """
    TC-API-MEETING-013 [异常] meeting_id 不存在
    模块：会议/修改 | 优先级：P1
    """
    resp = _send("PUT",
        f"{BASE_API}/api-meeting/v1/meeting/999999999/",
        json_body={
            "topic": "测试会议",
            "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
            "date": "2026-05-26",
            "start": "08:00",
            "end": "08:15",
            "agenda": "测试内容",
            "is_record": False,
        },
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 404)


def test_tc_api_meeting_014_modify_no_token():
    """
    TC-API-MEETING-014 [权限] 不带 token 修改被拒绝
    模块：会议/修改 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_meeting_id", None) or 1
    resp = _send("PUT",
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        json_body={
            "topic": "测试会议",
            "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
            "date": "2026-05-26",
            "start": "08:00",
            "end": "08:15",
            "agenda": "测试内容",
            "is_record": False,
        },
        headers={"Content-Type": "application/json;charset=UTF-8"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


# === TC-API-MEETING-015 [SKIP-MANUAL] =======================================
# 用例标题：[越权] 用他人 token 修改他人会议
# 维度：权限 / 越权 | 优先级：P1
# 不可自动化原因：
#   - 需要第二个独立账号 B 创建一个 meeting_id（other_meeting_id），
#     当前测试环境只配置了 levi3053 一个账号与 PASSWORD，
#     无法在脚本中再产出一份属于他人的会议数据
#   - USER_INPUT_other_meeting_id 必须由人工提前在另一账号下创建并提供
# 人工执行步骤：
#   1. 用账号 B 登录 OneID，调用 POST /api-meeting/v1/meeting/ 创建一个会议，记录 other_meeting_id
#   2. 切换回账号 A 的 token
#   3. PUT https://openubmc-website.test.osinfra.cn/api-meeting/v1/meeting/<other_meeting_id>/
#      Headers：token = A 的 token；Content-Type: application/json;charset=UTF-8
#      Body: {"topic":"越权修改测试","etherpad":"https://etherpad.openubmc.cn/p/infrastructrue",
#             "date":"2026-05-26","start":"08:00","end":"08:15",
#             "agenda":"越权修改测试","is_record":false}
# 预期结果：
#   1. HTTP 403 / 404
#   2. 该会议未被修改（用账号 B 重新查询，topic 仍为原值）
# ============================================================================


@pytest.mark.dependency(depends=["create_meeting"])
def test_tc_api_meeting_016_cancel_normal(auth_token):
    """
    TC-API-MEETING-016 [正常流] 取消已存在会议
    模块：会议/取消 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例 MEETING-004 未产出 meeting_id")
    resp = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 204)
    pytest.shared_meeting_cancelled_id = meeting_id


def test_tc_api_meeting_017_cancel_repeat(auth_token):
    """
    TC-API-MEETING-017 [重复] 重复取消同一会议
    模块：会议/取消 | 优先级：P1
    """
    meeting_id = getattr(pytest, "shared_meeting_cancelled_id", None)
    if not meeting_id:
        pytest.skip("依赖 MEETING-016 未取消会议")
    resp = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 404, 409)


def test_tc_api_meeting_018_cancel_no_token():
    """
    TC-API-MEETING-018 [权限] 不带 token 取消被拒绝
    模块：会议/取消 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_meeting_id", None) or 1
    resp = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{meeting_id}/",
        headers={"Content-Type": "application/json;charset=UTF-8"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


def test_tc_api_meeting_019_cancel_msg_linkage(auth_token):
    """
    TC-API-MEETING-019 [联动] 取消会议后 message_center 消息总数应增加
    模块：会议/取消 + 消息联动 | 优先级：P1
    """
    # 先创建一个新会议用于本用例（避免破坏 shared_meeting_id 状态机）
    body = _meeting_body_single(start="10:00", end="10:15", topic="测试会议-取消联动")
    body["time"] = "10:00-10:15"
    r_create = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=body,
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    if r_create.status_code not in (200, 201):
        pytest.skip(f"创建会议失败 status={r_create.status_code}，跳过联动断言")
    new_meeting_id = r_create.json().get("data")
    assert isinstance(new_meeting_id, int)

    r0 = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    count_before = r0.json().get("count", 0)

    r_cancel = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{new_meeting_id}/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert r_cancel.status_code in (200, 204)

    time.sleep(WAIT_AFTER_WRITE)
    r2 = _send("GET",
        f"{BASE_API}/api-message/message_center/all",
        headers=_auth_headers(auth_token),
        timeout=DEFAULT_TIMEOUT,
    )
    count_after = r2.json().get("count", 0)
    assert count_after > count_before, (
        f"取消会议后消息总数未增加：before={count_before} after={count_after}"
    )


# ============================================================================
# 模块 D：会议管理（月周期会议）
# ============================================================================


def _meeting_body_cycle(cycle_start_date="2026-05-25", cycle_end_date="2026-08-25",
                        cycle_start="17:00", cycle_end="18:00",
                        cycle_interval=1, cycle_type=2, cycle_point="15", **overrides):
    """构造月周期会议 body 工具函数"""
    body = {
        "is_record": False,
        "is_cycle": True,
        "cycle_interval": cycle_interval,
        "cycle_type": cycle_type,
        "cycle_start_date": cycle_start_date,
        "cycle_end_date": cycle_end_date,
        "cycle_start": cycle_start,
        "cycle_end": cycle_end,
        "cycle_point": cycle_point,
        "agenda": "测试内容",
        "email_list": "",
        "platform": "WELINK",
        "topic": "测试会议",
        "group_name": "infrastructure",
        "etherpad": "https://etherpad.openubmc.cn/p/infrastructrue",
    }
    body.update(overrides)
    return body


@pytest.mark.dependency(name="create_cycle_meeting")
def test_tc_api_cycle_001_create_normal(auth_token):
    """
    TC-API-CYCLE-001 [正常流] 创建月周期会议返回 meeting_id
    模块：会议/月周期 | 优先级：P0
    """
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=_meeting_body_cycle(),
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 201)
    rj = resp.json()
    assert isinstance(rj.get("data"), int)
    assert rj["data"] >= 0
    pytest.shared_cycle_meeting_id = rj["data"]


def test_tc_api_cycle_002_end_before_start(auth_token):
    """
    TC-API-CYCLE-002 [异常] cycle_end_date < cycle_start_date
    模块：会议/月周期 | 优先级：P1
    """
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=_meeting_body_cycle(
            cycle_start_date="2026-08-25", cycle_end_date="2026-05-25"
        ),
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_cycle_003_start_eq_end_time(auth_token):
    """
    TC-API-CYCLE-003 [边界值] cycle_start = cycle_end（时间相同）
    模块：会议/月周期 | 优先级：P2
    """
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=_meeting_body_cycle(cycle_start="17:00", cycle_end="17:00"),
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_cycle_004_interval_zero(auth_token):
    """
    TC-API-CYCLE-004 [异常输入] cycle_interval 为 0
    模块：会议/月周期 | 优先级：P2
    """
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=_meeting_body_cycle(cycle_interval=0),
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 422)


def test_tc_api_cycle_005_create_no_token():
    """
    TC-API-CYCLE-005 [权限] 不带 token 创建周期会议被拒绝
    模块：会议/月周期 | 优先级：P0
    """
    resp = _send("POST",
        f"{BASE_API}/api-meeting/v1/meeting/",
        json_body=_meeting_body_cycle(),
        headers={"Content-Type": "application/json;charset=UTF-8"},
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (401, 403)


@pytest.mark.dependency(depends=["create_cycle_meeting"])
def test_tc_api_cycle_006_modify_normal(auth_token):
    """
    TC-API-CYCLE-006 [正常流] 修改月周期会议 cycle_point
    模块：会议/月周期 | 优先级：P0
    """
    cycle_meeting_id = getattr(pytest, "shared_cycle_meeting_id", None)
    if not cycle_meeting_id:
        pytest.skip("依赖用例 CYCLE-001 未产出 cycle_meeting_id")
    resp = _send("PUT",
        f"{BASE_API}/api-meeting/v1/meeting/{cycle_meeting_id}/",
        json_body={
            "topic": "测试会议",
            "agenda": "测试内容",
            "is_record": False,
            "is_cycle": True,
            "cycle_interval": 1,
            "cycle_type": 2,
            "cycle_start_date": "2026-05-25",
            "cycle_end_date": "2026-08-25",
            "cycle_start": "17:00",
            "cycle_end": "18:00",
            "cycle_point": "16",
        },
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code == 200


@pytest.mark.dependency(depends=["create_cycle_meeting"])
def test_tc_api_cycle_007_cancel_normal(auth_token):
    """
    TC-API-CYCLE-007 [正常流] 取消整个月周期会议
    模块：会议/月周期 | 优先级：P0
    """
    cycle_meeting_id = getattr(pytest, "shared_cycle_meeting_id", None)
    if not cycle_meeting_id:
        pytest.skip("依赖用例 CYCLE-001 未产出 cycle_meeting_id")
    resp = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{cycle_meeting_id}/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (200, 204)
    pytest.shared_cycle_cancelled_id = cycle_meeting_id


def test_tc_api_cycle_008_cancel_repeat(auth_token):
    """
    TC-API-CYCLE-008 [重复] 重复取消同一周期会议
    模块：会议/月周期 | 优先级：P3
    """
    cycle_meeting_id = getattr(pytest, "shared_cycle_cancelled_id", None)
    if not cycle_meeting_id:
        pytest.skip("依赖 CYCLE-007 未取消周期会议")
    resp = _send("DELETE",
        f"{BASE_API}/api-meeting/v1/meeting/{cycle_meeting_id}/",
        headers=_auth_headers(auth_token, charset_utf8=True),
        timeout=DEFAULT_TIMEOUT,
    )
    assert resp.status_code in (400, 404, 409)


# ============================================================================
# 直接运行入口
# ============================================================================

if __name__ == "__main__":
    pytest.main(["-v", __file__])
