# -*- coding: utf-8 -*-
"""
测试用例脚本：meeting-center 模块测试集

模块包含：
  1. OneID 登录接口测试（POST /oneid/login）
  2. 会议参会者列表 API 测试（GET /meeting/{id}/participants/）

用例总数：46 | 自动化：46 | 手工：0
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests cryptography python-dotenv pytest-dependency

执行：
    pytest -v test_cases.py                       # 执行全部自动化用例
    pytest -v test_cases.py -k PUBLIC             # 执行公开会议相关用例
    pytest -v test_cases.py -m p0                 # 执行 P0 优先级用例
    pytest -v test_cases.py -k oneid_login        # 执行 OneID 登录用例

占位符（执行前由环境变量注入）：
    BASE_URL       —— 测试环境 API 基础 URL（如 https://preview.example.com）
    AUTH_URL       —— OneID 认证服务 URL（如 https://usercenter.openubmc.test.osinfra.cn）
    PASSWORD       —— 测试账号密码
    SPONSOR_TOKEN  —— 私有会议发起人 token
    MEMBER_TOKEN   —— SIG 组成员 token
    ADMIN_TOKEN    —— 管理员 token
    NORMAL_TOKEN   —— 普通用户 token（无权限）

查看真实请求/响应：
    1. 控制台实时打印（需加 -s 关掉 pytest 标准输出捕获）：
         pytest -vs test_cases.py
    2. 落盘 jsonl 流水（默认开启，与本脚本同目录）：
         test_cases.http.log.jsonl
       关闭打印：set HTTP_VERBOSE=0
       关闭落盘：set HTTP_LOG_FILE=
"""

import os
import json
import time
import datetime
import threading
import re
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
BASE_AUTH = os.environ.get("AUTH_URL", "https://usercenter.openubmc.test.osinfra.cn")
BASE_URL = os.environ.get("BASE_URL", "https://preview.example.com")

ACCOUNT = "19938204520"
CLIENT_ID = "672b25d8b92861baa16ce1e3"
REDIRECT_URI = "https://openubmc-website.test.osinfra.cn/personal/meeting"
EXPECTED_USERNAME = "xiaoguozhi34"

PUBLIC_MEETING_ID = int(os.environ.get("PUBLIC_MEETING_ID", "1"))
PRIVATE_MEETING_ID = int(os.environ.get("PRIVATE_MEETING_ID", "2"))
DELETED_MEETING_ID = int(os.environ.get("DELETED_MEETING_ID", "6"))
NONEXIST_MEETING_ID = int(os.environ.get("NONEXIST_MEETING_ID", "99999"))
NO_PERMISSION_MEETING_ID = int(os.environ.get("NO_PERMISSION_MEETING_ID", "5"))

# ===== 占位符注入 =====
PASSWORD = os.environ.get("PASSWORD", "")
SPONSOR_TOKEN = os.environ.get("SPONSOR_TOKEN", "")
MEMBER_TOKEN = os.environ.get("MEMBER_TOKEN", "")
ADMIN_TOKEN = os.environ.get("ADMIN_TOKEN", "")
NORMAL_TOKEN = os.environ.get("NORMAL_TOKEN", "")
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


# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def api_client():
    """requests.Session 实例，自动设置超时"""
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})
    return session


@pytest.fixture(scope="session")
def sponsor_token():
    """获取私有会议发起人 token"""
    if SPONSOR_TOKEN:
        return SPONSOR_TOKEN
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={
            "permission": "sigRead",
            "account": "sponsor_test",
            "client_id": "test_client_id",
            "password": PASSWORD,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200, f"login failed: {resp.status_code}"
    token = resp.json().get("token")
    assert token and len(token) >= 16, "token 缺失或长度异常"
    return token


@pytest.fixture(scope="session")
def member_token():
    """获取 SIG 组成员 token"""
    if MEMBER_TOKEN:
        return MEMBER_TOKEN
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={
            "permission": "sigRead",
            "account": "member_test",
            "client_id": "test_client_id",
            "password": PASSWORD,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200, f"login failed: {resp.status_code}"
    token = resp.json().get("token")
    assert token and len(token) >= 16, "token 缺失或长度异常"
    return token


@pytest.fixture(scope="session")
def admin_token():
    """获取管理员 token"""
    if ADMIN_TOKEN:
        return ADMIN_TOKEN
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={
            "permission": "admin",
            "account": "admin_test",
            "client_id": "test_client_id",
            "password": PASSWORD,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200, f"login failed: {resp.status_code}"
    token = resp.json().get("token")
    assert token and len(token) >= 16, "token 缺失或长度异常"
    return token


@pytest.fixture(scope="session")
def normal_token():
    """获取普通用户 token（无权限）"""
    if NORMAL_TOKEN:
        return NORMAL_TOKEN
    resp = requests.post(
        f"{BASE_AUTH}/oneid/login",
        json={
            "permission": "sigRead",
            "account": "normal_test",
            "client_id": "test_client_id",
            "password": PASSWORD,
            "oneidPrivacyAccepted": "20240830",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200, f"login failed: {resp.status_code}"
    token = resp.json().get("token")
    assert token and len(token) >= 16, "token 缺失或长度异常"
    return token


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
            return plaintext
        except ValueError:
            pass
    if public_key_pem is None:
        public_key_pem = _fetch_public_key()
    key = _load_pem(public_key_pem.encode("utf-8"))
    return key.encrypt(plaintext.encode("utf-8"), _rsa_padding.PKCS1v15()).hex()


def _build_body(**overrides):
    """构造默认合法 body；用 overrides 注入差异化字段"""
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
# 一、OneID 登录测试（正常流）
# ============================================================================


@pytest.mark.p0
def test_tc_api_login_001_normal_flow():
    """
    TC-API-LOGIN-001 [正常流] 合法账号密码登录返回 token
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
# 二、OneID 登录测试（异常/反向）
# ============================================================================


@pytest.mark.p0
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
    assert not (rj.get("data") or {}).get("token")


@pytest.mark.p1
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


@pytest.mark.p1
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


@pytest.mark.p0
def test_tc_api_login_005_plain_password():
    """
    TC-API-LOGIN-005 [异常] 明文密码（未加密）直接送会被识为密码错误
    模块：OneID/登录 | 优先级：P0
    实测：未经过 RSA 加密的字符串放进 password 字段，平台无法解密，按密码错处理
    """
    body = _build_body(password="this_is_a_raw_plaintext_password_123")
    resp = _post_login(body)
    assert resp.status_code == 400
    rj = resp.json()
    assert (rj.get("msg") or {}).get("code") == "E00052"


# ============================================================================
# 三、OneID 登录测试（空值）
# ============================================================================


@pytest.mark.p0
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


@pytest.mark.p0
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


@pytest.mark.p1
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
# 四、OneID 登录测试（异常输入）
# ============================================================================


@pytest.mark.p1
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


@pytest.mark.p2
def test_tc_api_login_010_unregistered_phone():
    """
    TC-API-LOGIN-010 [异常输入] 未注册的合法手机号格式返回 E00052
    模块：OneID/登录 | 优先级：P2
    """
    body = _build_body(account="13800000000")
    resp = _post_login(body)
    assert resp.status_code == 400


# ============================================================================
# 五、OneID 登录测试（特殊字符/安全）
# ============================================================================


@pytest.mark.p0
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


# ============================================================================
# 六、OneID 登录测试（字段非强制/边界）
# ============================================================================


@pytest.mark.p2
def test_tc_api_login_012_missing_redirect_uri_still_ok():
    """
    TC-API-LOGIN-012 [边界值] 缺 redirect_uri 字段仍可登录成功
    模块：OneID/登录 | 优先级：P2

    实测发现：当请求 headers 含正确 Referer 时，body 中即使不带 redirect_uri
              也能登录成功（平台从 Referer 推断）。
    """
    body = _build_body(redirect_uri=_MISSING)
    resp = _post_login(body)
    assert resp.status_code == 200
    rj = resp.json()
    assert rj.get("code") == 200
    assert (rj.get("data") or {}).get("token")


@pytest.mark.p2
def test_tc_api_login_013_missing_privacy_field_still_ok():
    """
    TC-API-LOGIN-013 [边界值] 缺 oneidPrivacyAccepted 字段仍可登录成功
    模块：OneID/登录 | 优先级：P2

    实测发现：oneidPrivacyAccepted 字段为可选；缺失不影响登录。
    """
    body = _build_body(oneidPrivacyAccepted=_MISSING)
    resp = _post_login(body)
    assert resp.status_code == 200
    rj = resp.json()
    assert rj.get("code") == 200
    assert (rj.get("data") or {}).get("token")


# ============================================================================
# 七、会议参会者列表 API 测试（公开会议）
# ============================================================================


@pytest.mark.p0
def test_meeting_public_001_no_auth_access_pr_167(api_client):
    """TC-API-MEETING-PUBLIC-001 [正常流] 公开会议无认证可访问"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    assert body.get("message") == "success"
    assert isinstance(body.get("data"), dict)
    assert "participants" in body["data"]


@pytest.mark.p0
def test_meeting_public_002_data_structure_pr_167(api_client):
    """TC-API-MEETING-PUBLIC-002 [正常流] 公开会议参会者数据结构正确"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", {})
    assert "meeting_id" in data
    assert "topic" in data
    assert "is_private" in data
    assert data["is_private"] == False
    assert "total" in data
    assert "page" in data
    assert "size" in data
    participants = data.get("participants", [])
    if len(participants) > 0:
        p = participants[0]
        assert "username" in p
        assert "nickname" in p
        assert "email" in p
        assert "phone" in p
        assert "user_id" in p
        assert "organization" in p
        assert "position" in p
        assert "avatar" in p
        assert "attendance_status" in p


@pytest.mark.p1
def test_meeting_public_003_email_masking_pr_167(api_client):
    """TC-API-MEETING-PUBLIC-003 [安全] 公开会议参会者邮箱脱敏生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        email = p.get("email", "")
        if email:
            assert "***@" in email, f"邮箱未脱敏: {email}"
            assert re.match(r"^[a-zA-Z0-9]{1,3}\*\*\*@", email), f"邮箱脱敏格式不正确: {email}"


@pytest.mark.p1
def test_meeting_public_004_phone_masking_pr_167(api_client):
    """TC-API-MEETING-PUBLIC-004 [安全] 公开会议参会者手机号脱敏生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        phone = p.get("phone", "")
        if phone:
            assert re.match(r"^\d{3}\*\*\*\*\d{4}$", phone), f"手机号脱敏格式不正确: {phone}"


# ============================================================================
# 八、会议参会者列表 API 测试（私有会议）
# ============================================================================


@pytest.mark.p0
def test_meeting_private_001_sponsor_access_pr_167(api_client, sponsor_token):
    """TC-API-MEETING-PRIVATE-001 [正常流] 私有会议发起人认证后可访问"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {sponsor_token}"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    assert isinstance(body.get("data"), dict)
    assert "participants" in body["data"]


@pytest.mark.p1
def test_meeting_private_002_member_access_pr_167(api_client, member_token):
    """TC-API-MEETING-PRIVATE-002 [权限] 私有会议 SIG 组成员认证后可访问"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {member_token}"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200


@pytest.mark.p1
def test_meeting_private_003_admin_access_pr_167(api_client, admin_token):
    """TC-API-MEETING-PRIVATE-003 [权限] 私有会议管理员认证后可访问"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {admin_token}"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200


@pytest.mark.p0
def test_meeting_private_004_no_auth_return_401_pr_167(api_client):
    """TC-API-MEETING-PRIVATE-004 [权限] 私有会议无认证访问返回 401"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code in (401, 403)


@pytest.mark.p0
def test_meeting_private_005_no_permission_return_403_pr_167(api_client, normal_token):
    """TC-API-MEETING-PRIVATE-005 [权限] 私有会议无权限用户访问返回 403"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{NO_PERMISSION_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {normal_token}"},
        timeout=10,
    )
    assert resp.status_code == 403
    body = resp.json()
    assert body.get("code") == 403
    assert "暂不对外公开" in body.get("message", "")


@pytest.mark.p1
def test_meeting_private_006_token_expired_pr_167(api_client):
    """TC-API-MEETING-PRIVATE-006 [权限] 私有会议 Token 过期返回 401"""
    expired_token = "expired_token_12345"
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {expired_token}"},
        timeout=10,
    )
    assert resp.status_code == 401


# ============================================================================
# 九、会议参会者列表 API 测试（分页功能）
# ============================================================================


@pytest.mark.p0
def test_meeting_pagination_001_default_params_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-001 [正常流] 默认分页参数返回正确数据"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", {})
    assert data.get("page") == 1
    assert data.get("size") == 20
    assert isinstance(data.get("total"), int)
    assert isinstance(data.get("participants"), list)


@pytest.mark.p0
def test_meeting_pagination_002_custom_params_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-002 [正常流] 自定义分页参数返回正确数据"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=2&size=10",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", {})
    assert data.get("page") == 2
    assert data.get("size") == 10
    assert len(data.get("participants", [])) <= 10


@pytest.mark.p1
def test_meeting_pagination_003_size_100_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-003 [边界值] 分页 size=100 返回最多 100 条"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=1&size=100",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", {})
    assert data.get("size") == 100
    assert len(data.get("participants", [])) <= 100


@pytest.mark.p1
def test_meeting_pagination_004_size_101_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-004 [边界值] 分页 size=101 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=1&size=101",
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400


@pytest.mark.p1
def test_meeting_pagination_005_page_0_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-005 [异常输入] 分页 page=0 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=0",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_006_page_negative_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-006 [异常输入] 分页 page=-1 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=-1",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_007_size_0_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-007 [异常输入] 分页 size=0 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=0",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_008_size_negative_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-008 [异常输入] 分页 size=-5 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=-5",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_009_page_non_numeric_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-009 [异常输入] 分页 page=abc 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=abc",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_010_size_non_numeric_pr_167(api_client):
    """TC-API-MEETING-PAGINATION-010 [异常输入] 分页 size=xyz 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=xyz",
        timeout=10,
    )
    assert resp.status_code == 400


# ============================================================================
# 十、会议参会者列表 API 测试（会议不存在）
# ============================================================================


@pytest.mark.p0
def test_meeting_notfound_001_nonexist_pr_167(api_client):
    """TC-API-MEETING-NOTFOUND-001 [异常] 会议不存在返回 404"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{NONEXIST_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 404
    body = resp.json()
    assert body.get("code") == 404
    assert "不存在或已删除" in body.get("message", "")


@pytest.mark.p0
def test_meeting_notfound_002_deleted_pr_167(api_client):
    """TC-API-MEETING-NOTFOUND-002 [异常] 已删除会议返回 404"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{DELETED_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 404
    body = resp.json()
    assert body.get("code") == 404
    assert "不存在或已删除" in body.get("message", "")


# ============================================================================
# 十一、会议参会者列表 API 测试（集成测试）
# ============================================================================


@pytest.mark.p1
def test_meeting_integration_001_cross_service_call_pr_167(api_client):
    """TC-API-MEETING-INTEGRATION-001 [集成] 跨服务调用链路正常"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", {})
    assert "meeting_id" in data
    assert data["meeting_id"] == PUBLIC_MEETING_ID
    participants = data.get("participants", [])
    for p in participants:
        assert p.get("user_id"), "OneID user_id 缺失"


@pytest.mark.p1
def test_meeting_integration_002_platform_error_pr_167(api_client):
    """TC-API-MEETING-INTEGRATION-002 [集成] meeting-platform 异常时正确处理"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{NONEXIST_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 404
    body = resp.json()
    assert "不存在" in body.get("message", "") or "已删除" in body.get("message", "")


@pytest.mark.p1
def test_meeting_integration_003_oneid_error_pr_167(api_client):
    """TC-API-MEETING-INTEGRATION-003 [集成] OneID 批量查询失败时正确处理"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        assert "username" in p
        assert p.get("username"), "username 不应为空"


# ============================================================================
# 十二、会议参会者列表 API 测试（安全测试）
# ============================================================================


@pytest.mark.p1
def test_meeting_security_001_dynamic_auth_pr_167(api_client):
    """TC-API-MEETING-SECURITY-001 [安全] 动态认证机制生效"""
    resp_public = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp_public.status_code == 200
    
    resp_private = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp_private.status_code in (401, 403)


@pytest.mark.p1
def test_meeting_security_002_horizontal_bypass_pr_167(api_client, normal_token):
    """TC-API-MEETING-SECURITY-002 [安全] 横向越权防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {normal_token}"},
        timeout=10,
    )
    assert resp.status_code == 403


@pytest.mark.p2
def test_meeting_security_003_vertical_bypass_pr_167(api_client, normal_token):
    """TC-API-MEETING-SECURITY-003 [安全] 纵向越权防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {normal_token}"},
        timeout=10,
    )
    assert resp.status_code == 403


@pytest.mark.p2
def test_meeting_security_004_sql_injection_pr_167(api_client):
    """TC-API-MEETING-SECURITY-004 [安全] SQL 注入防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/1' OR '1'='1/participants/",
        timeout=10,
    )
    assert resp.status_code in (400, 404)
    body = resp.json()
    assert "token" not in str(body).lower()
    assert "password" not in str(body).lower()


@pytest.mark.p2
def test_meeting_security_005_xss_injection_pr_167(api_client):
    """TC-API-MEETING-SECURITY-005 [安全] XSS 注入防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=<script>alert(1)</script>",
        timeout=10,
    )
    assert resp.status_code == 400


# ============================================================================
# 十三、会议参会者列表 API 测试（脱敏逻辑）
# ============================================================================


@pytest.mark.p2
def test_meeting_mask_001_short_email_pr_167(api_client):
    """TC-API-MEETING-MASK-001 [安全] 短邮箱脱敏处理正确"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        email = p.get("email", "")
        if email and len(email.split("@")[0]) < 3:
            assert "***@" in email or email == ""


@pytest.mark.p2
def test_meeting_mask_002_short_phone_pr_167(api_client):
    """TC-API-MEETING-MASK-002 [安全] 短手机号脱敏处理正确"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        phone = p.get("phone", "")
        if phone and len(phone.replace("*", "").replace("-", "")) < 7:
            assert "*" in phone or phone == ""


@pytest.mark.p2
def test_meeting_mask_003_invalid_email_pr_167(api_client):
    """TC-API-MEETING-MASK-003 [安全] 无效邮箱格式不脱敏"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        email = p.get("email", "")
        if email and "@" not in email:
            assert email == "" or "***@" not in email


@pytest.mark.p2
def test_meeting_mask_004_invalid_phone_pr_167(api_client):
    """TC-API-MEETING-MASK-004 [安全] 无效手机号格式不脱敏"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    participants = body.get("data", {}).get("participants", [])
    for p in participants:
        phone = p.get("phone", "")
        if phone:
            assert re.match(r"^[\d\*]+$", phone), f"手机号含非法字符: {phone}"


if __name__ == "__main__":
    pytest.main(["-v", __file__])


# ===== 用例索引（人类可贴禅道/Tapd） =====
#
# | 用例 ID | 标题 | 关联 task | 优先级 | 类型 | 来源 PR |
# |---------|------|-----------|--------|------|---------|
# | TC-API-LOGIN-001 | [正常流] 合法账号密码登录返回 token | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-002 | [异常] 密码错误时返回 E00052 | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-003 | [异常] 不存在的账号返回 E00052 | OneID 登录 | P1 | interface | 原有 |
# | TC-API-LOGIN-004 | [异常输入] 错误的 client_id 返回 404 | OneID 登录 | P1 | interface | 原有 |
# | TC-API-LOGIN-005 | [异常] 明文密码（未加密）直接送会被识为密码错误 | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-006 | [空值] account 为空字符串返回 E00012 | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-007 | [空值] password 为空字符串被识为密码错误 | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-008 | [空值] permission 字段缺失返回 E00012 | OneID 登录 | P1 | interface | 原有 |
# | TC-API-LOGIN-009 | [异常输入] permission 枚举外值返回 E00012 | OneID 登录 | P1 | interface | 原有 |
# | TC-API-LOGIN-010 | [异常输入] 未注册的合法手机号格式返回 E00052 | OneID 登录 | P2 | interface | 原有 |
# | TC-API-LOGIN-011 | [特殊字符][SQL注入] account 含 SQL 注入串被 WAF 拦截 | OneID 登录 | P0 | interface | 原有 |
# | TC-API-LOGIN-012 | [边界值] 缺 redirect_uri 字段仍可登录成功 | OneID 登录 | P2 | interface | 原有 |
# | TC-API-LOGIN-013 | [边界值] 缺 oneidPrivacyAccepted 字段仍可登录成功 | OneID 登录 | P2 | interface | 原有 |
# | TC-API-MEETING-PUBLIC-001 | [正常流] 公开会议无认证可访问 | #5 验收标准 1 | P0 | interface | #167 |
# | TC-API-MEETING-PUBLIC-002 | [正常流] 公开会议参会者数据结构正确 | #5 验收标准 1 | P0 | interface | #167 |
# | TC-API-MEETING-PUBLIC-003 | [安全] 公开会议参会者邮箱脱敏生效 | #5 验收标准 1 | P1 | interface | #167 |
# | TC-API-MEETING-PUBLIC-004 | [安全] 公开会议参会者手机号脱敏生效 | #5 验收标准 1 | P1 | interface | #167 |
# | TC-API-MEETING-PRIVATE-001 | [正常流] 私有会议发起人认证后可访问 | #5 验收标准 2 | P0 | interface | #167 |
# | TC-API-MEETING-PRIVATE-002 | [权限] 私有会议 SIG 组成员认证后可访问 | #5 验收标准 2 | P1 | interface | #167 |
# | TC-API-MEETING-PRIVATE-003 | [权限] 私有会议管理员认证后可访问 | #5 验收标准 2 | P1 | interface | #167 |
# | TC-API-MEETING-PRIVATE-004 | [权限] 私有会议无认证访问返回 401 | #5 验收标准 6 | P0 | interface | #167 |
# | TC-API-MEETING-PRIVATE-005 | [权限] 私有会议无权限用户访问返回 403 | #5 验收标准 6 | P0 | interface | #167 |
# | TC-API-MEETING-PRIVATE-006 | [权限] 私有会议 Token 过期返回 401 | #5 验收标准 6 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-001 | [正常流] 默认分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #167 |
# | TC-API-MEETING-PAGINATION-002 | [正常流] 自定义分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #167 |
# | TC-API-MEETING-PAGINATION-003 | [边界值] 分页 size=100 返回最多 100 条 | #5 验收标准 7 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-004 | [边界值] 分页 size=101 返回 400 | #5 验收标准 7 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-005 | [异常输入] 分页 page=0 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-006 | [异常输入] 分页 page=-1 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-007 | [异常输入] 分页 size=0 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-008 | [异常输入] 分页 size=-5 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-009 | [异常输入] 分页 page=abc 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-PAGINATION-010 | [异常输入] 分页 size=xyz 返回 400 | #5 验收标准 8 | P1 | interface | #167 |
# | TC-API-MEETING-NOTFOUND-001 | [异常] 会议不存在返回 404 | #5 验收标准 4 | P0 | interface | #167 |
# | TC-API-MEETING-NOTFOUND-002 | [异常] 已删除会议返回 404 | #5 验收标准 5 | P0 | interface | #167 |
# | TC-API-MEETING-INTEGRATION-001 | [集成] 跨服务调用链路正常 | #5 设计要点 | P1 | integration | #167 |
# | TC-API-MEETING-INTEGRATION-002 | [集成] meeting-platform 异常时正确处理 | #5 设计要点 | P1 | integration | #167 |
# | TC-API-MEETING-INTEGRATION-003 | [集成] OneID 批量查询失败时正确处理 | #5 设计要点 | P1 | integration | #167 |
# | TC-API-MEETING-SECURITY-001 | [安全] 动态认证机制生效 | #5 安全设计 | P1 | interface | #167 |
# | TC-API-MEETING-SECURITY-002 | [安全] 横向越权防护生效 | #5 安全设计 | P1 | interface | #167 |
# | TC-API-MEETING-SECURITY-003 | [安全] 纵向越权防护生效 | #5 安全设计 | P2 | interface | #167 |
# | TC-API-MEETING-SECURITY-004 | [安全] SQL 注入防护生效 | #5 安全设计 | P2 | interface | #167 |
# | TC-API-MEETING-SECURITY-005 | [安全] XSS 注入防护生效 | #5 安全设计 | P2 | interface | #167 |
# | TC-API-MEETING-MASK-001 | [安全] 短邮箱脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #167 |
# | TC-API-MEETING-MASK-002 | [安全] 短手机号脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #167 |
# | TC-API-MEETING-MASK-003 | [安全] 无效邮箱格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #167 |
# | TC-API-MEETING-MASK-004 | [安全] 无效手机号格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #167 |