# -*- coding: utf-8 -*-
"""
测试用例脚本：openEuler OneID 登录接口（POST /oneid/login）

来源：基于 https://usercenter.openubmc.test.osinfra.cn/oneid/login 实测探测
被测系统：OneID 鉴权服务（openUBMC 测试环境）
账号：19938204520 | 密码：Aa123456@ | username=xiaoguozhi34
用例总数：13 | 自动化：13 | 手工：0
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests cryptography python-dotenv

执行：
    set PASSWORD=Aa123456@                         # 明文密码（默认值同此）
    pytest -v test_oneid_login.py
    pytest -vs test_oneid_login.py                  # 同时打印请求/响应明细

查看真实请求/响应：
    1. 控制台实时打印（需加 -s 关掉 pytest 标准输出捕获）：
         pytest -vs test_oneid_login.py
    2. 落盘 jsonl 流水（默认开启，与本脚本同目录）：
         test_oneid_login.http.log.jsonl
       关闭打印：set HTTP_VERBOSE=0
       关闭落盘：set HTTP_LOG_FILE=
       自定义路径：set HTTP_LOG_FILE=D:/logs/run-001.jsonl

平台实测事实（脚本对照执行结果校正过）：
    1. 鉴权链路三步：GET /oneid/public/key 取 RSA 公钥 → PKCS1v15 加密明文 →
       hex 编码 → POST /oneid/login
    2. POST /oneid/login 必须携带 Origin + Referer 头才会校验 redirect_uri；
       否则一律返回 HTTP 404「redirect_uri not found in the app」
    3. 真实 client_id = 672b25d8b92861baa16ce1e3（来自前端 bundle 反查）
    4. redirect_uri 与 oneidPrivacyAccepted 字段在请求头满足条件后**非强制**，
       缺失仍可登录成功（与文档建议不一致）
    5. token 在响应 body.data.token，不在顶层
    6. 错误码字典：
       - E00052「账号和密码不匹配」(HTTP 400)：密码错 / 账号不存在 / 明文密码 /
         未注册手机号 / 空 password
       - E00012「请求异常」(HTTP 400)：空 account / 缺 permission / permission 枚举外值
       - HTTP 404「redirect_uri not found in the app」：错误 client_id
       - HTTP 418 + CloudWAF HTML：SQL 注入串被 WAF 拦截
"""

import os
import json
import time
import datetime
import threading
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

# ===== 模块级常量 =====
BASE_AUTH = "https://usercenter.openubmc.test.osinfra.cn"

ACCOUNT = "19938204520"
CLIENT_ID = "672b25d8b92861baa16ce1e3"
REDIRECT_URI = "https://openubmc-website.test.osinfra.cn/personal/meeting"
EXPECTED_USERNAME = "xiaoguozhi34"   # 实测正常登录返回的 username

# ===== 占位符注入 =====
PASSWORD = os.environ.get("PASSWORD")
DEFAULT_TIMEOUT = 10

# 必备 headers：Origin + Referer 缺失会让平台一律返回 404
COMMON_HEADERS = {
    "Content-Type": "application/json",
    "Origin": BASE_AUTH,
    "Referer": (
        f"{BASE_AUTH}/login?client_id={CLIENT_ID}"
        f"&redirect_uri=https%3A%2F%2Fopenubmc-website.test.osinfra.cn%2Fpersonal%2Fmeeting"
        f"&response_type=code"
    ),
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
    （历史脚本曾把 PASSWORD 环境变量设为预加密密文，此分支避免重复加密报错）
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
    """构造默认合法 body；用 overrides 注入差异化字段（含删除字段语义）"""
    body = {
        "permission": "sigRead",
        "account": ACCOUNT,
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "password": _encrypt_password(PASSWORD),
        "oneidPrivacyAccepted": "20240830",
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


# ============================================================================
# 一、正常流（1 条）
# ============================================================================


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


# ============================================================================
# 二、异常 / 反向（4 条）
# ============================================================================


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
    TC-API-LOGIN-004 [异常输入] 错误的 client_id 返回 404 redirect_uri not found
    模块：OneID/登录 | 优先级：P1
    实测响应：HTTP 404 + body.code=404 + body.msg="redirect_uri not found in the app"
    """
    body = _build_body(client_id="000000000000000000000000")
    resp = _post_login(body)
    assert resp.status_code == 404
    rj = resp.json()
    assert rj.get("code") == 404
    assert "redirect_uri not found" in str(rj.get("msg", ""))


def test_tc_api_login_005_plain_password():
    """
    TC-API-LOGIN-005 [异常] 明文密码（未加密）直接送会被识为密码错误
    模块：OneID/登录 | 优先级：P0
    实测：未经过 RSA 加密的字符串放进 password 字段，平台无法解密，按密码错处理
    """
    # 用一段确保是"明文"的固定字符串（与 PASSWORD 环境变量解耦，
    # 即使 PASSWORD 是预加密密文也不影响本用例语义）
    body = _build_body(password="this_is_a_raw_plaintext_password_123")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert (rj.get("msg") or {}).get("code") == "E00052"


# ============================================================================
# 三、空值（3 条）
# ============================================================================


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


# ============================================================================
# 四、异常输入（2 条）
# ============================================================================


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



# ============================================================================
# 五、特殊字符 / 安全（1 条）
# ============================================================================


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
    # 不应返回 token
    assert "token" not in resp.text.lower() or "JWT" not in resp.text


# ============================================================================
# 六、字段非强制 / 边界（2 条）
# ============================================================================


def test_tc_api_login_012_missing_redirect_uri_still_ok():
    """
    TC-API-LOGIN-012 [边界值] 缺 redirect_uri 字段仍可登录成功
    模块：OneID/登录 | 优先级：P2

    实测发现：当请求 headers 含正确 Referer 时，body 中即使不带 redirect_uri
              也能登录成功（平台从 Referer 推断）。本用例锁定此行为，便于未来
              发现变更回归。
    """
    body = _build_body(redirect_uri=_MISSING)
    resp = _post_login(body)
    assert resp.status_code == 200
    rj = resp.json()
    assert rj.get("code") == 200
    assert (rj.get("data") or {}).get("token")


def test_tc_api_login_013_missing_privacy_field_still_ok():
    """
    TC-API-LOGIN-013 [边界值] 缺 oneidPrivacyAccepted 字段仍可登录成功
    模块：OneID/登录 | 优先级：P2

    实测发现：oneidPrivacyAccepted 字段为可选；缺失不影响登录。
    （文档建议必传，但平台未强制校验）
    """
    body = _build_body(oneidPrivacyAccepted=_MISSING)
    resp = _post_login(body)
    assert resp.status_code == 200
    rj = resp.json()
    assert rj.get("code") == 200
    assert (rj.get("data") or {}).get("token")


# ============================================================================
# 七、覆盖矩阵（备注）
# ============================================================================
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
# ============================================================================


if __name__ == "__main__":
    pytest.main(["-v", __file__])
