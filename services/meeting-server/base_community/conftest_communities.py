# -*- coding: utf-8 -*-
"""
pytest 共享配置：多社区会议服务测试套件
======================================

支持五个社区：openeuler / openUBMC / mindspore / ascend / unifiedbus
社区配置从 communities_config.json 读取，通过环境变量 COMMUNITY 切换。

环境变量：
    COMMUNITY         社区标识（默认 openeuler）
    TEST_ACCOUNT      登录账号（必填）
    TEST_PASSWORD     登录密码（必填）
    FORCE_LOGIN=1     强制重新登录（忽略缓存）

执行示例：
    COMMUNITY=openeuler TEST_ACCOUNT=xxx TEST_PASSWORD=yyy pytest -v test_meeting_api.py
    COMMUNITY=openUBMC TEST_ACCOUNT=xxx TEST_PASSWORD=yyy pytest -v test_meeting_api.py
"""

import os
import json
import time
import urllib3
from datetime import date
from pathlib import Path
from dotenv import load_dotenv
load_dotenv()

import pytest
import requests
from cryptography.hazmat.primitives.asymmetric import padding as _rsa_padding
from cryptography.hazmat.primitives.serialization import load_pem_public_key as _load_pem

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# =========================================================
# 一、社区配置加载
# =========================================================
CONFIG_FILE = Path(__file__).parent / "communities_config.json"
COMMUNITY = os.environ.get("COMMUNITY", "openeuler")

with open(CONFIG_FILE, "r", encoding="utf-8") as _f:
    _all_config = json.load(_f)

_community_cfg = _all_config["communities"].get(COMMUNITY)
if not _community_cfg:
    raise ValueError(
        f"未知社区 '{COMMUNITY}'，可选值: {list(_all_config['communities'].keys())}"
    )

HOST_URL = os.environ.get("HOST_URL", _community_cfg["host_url"])
USER_URL = os.environ.get("USER_URL", _community_cfg["user_url"])
CLIENT_ID = os.environ.get("CLIENT_ID", _community_cfg["client_id"])
PROTOCOL = _community_cfg["protocol"]
API_PREFIX = _community_cfg["api_prefix"]
PATH_TOKEN_PROBE = _community_cfg["path_token_probe"]


BASE_AUTH = f"{PROTOCOL}://{USER_URL}"
BASE_BIZ = f"{PROTOCOL}://{HOST_URL}"


if COMMUNITY == "unifiedbus":
    ACCOUNT = os.environ.get("UNIFIEDBUS_TEST_ACCOUNT")
else:
    ACCOUNT = os.environ.get("TEST_ACCOUNT")
PASSWORD = os.environ.get("TEST_PASSWORD")

if not ACCOUNT or not PASSWORD:
    raise ValueError("必须设置环境变量 TEST_ACCOUNT 和 TEST_PASSWORD")

PATH_PUBLIC_KEY = "/oneid/public/key"
PATH_LOGIN = "/oneid/login"
REQ_TIMEOUT = 30

TOKEN_CACHE_FILE = Path(__file__).parent / f".token_cache_{COMMUNITY}.json"

LOGIN_HEADERS = {
    "Content-Type": "application/json;charset=UTF-8",
    "Accept": "*/*",
    "Origin": BASE_AUTH,
    "Referer": f"{BASE_AUTH}/",
    "Host": USER_URL,
}


# =========================================================
# 二、日期工具
# =========================================================
def next_month_first_day() -> str:
    today = date.today()
    year = today.year + (1 if today.month == 12 else 0)
    month = 1 if today.month == 12 else today.month + 1
    return date(year, month, 1).strftime("%Y-%m-%d")


def next_month_first_day_plus(days: int) -> str:
    from datetime import timedelta
    today = date.today()
    year = today.year + (1 if today.month == 12 else 0)
    month = 1 if today.month == 12 else today.month + 1
    base = date(year, month, 1)
    return (base + timedelta(days=days)).strftime("%Y-%m-%d")


# =========================================================
# 三、通用工具函数
# =========================================================
def user_url(path: str) -> str:
    return f"{BASE_AUTH}{path}"


def host_url(path: str) -> str:
    return f"{BASE_BIZ}{path}"


def build_business_headers(token: str) -> dict:
    return {
        "token": token if token else "",
        "Content-Type": "application/json;charset=UTF-8",
        "Accept": "*/*",
        "Origin": BASE_BIZ,
        "Referer": f"{BASE_BIZ}/personal/meeting",
        "Host": HOST_URL,
    }


def build_business_cookies(token: str, yg: str = None) -> dict:
    cookies = {}
    if token:
        cookies["_U_T_"] = token
    if yg:
        cookies["_Y_G_"] = yg
    return cookies


# =========================================================
# HTTP 日志工具
# =========================================================
HTTP_VERBOSE = os.environ.get("HTTP_VERBOSE", "1") not in ("0", "false", "False", "")
SENSITIVE_KEYS = {"password", "token", "Authorization", "Cookie", "_U_T_", "_Y_G_"}


def _mask(value):
    if not isinstance(value, str) or len(value) <= 8:
        return "***"
    return f"{value[:4]}...{value[-4:]}"


def _redact(obj):
    if isinstance(obj, dict):
        return {
            k: (_mask(v) if k in SENSITIVE_KEYS and isinstance(v, str) else _redact(v))
            for k, v in obj.items()
        }
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
    print(f"[HTTP] {method} {url}")
    print(f"  > headers: {_redact(dict(req_headers or {}))}")
    if req_body is not None:
        print(f"  > body:    {json.dumps(_redact(req_body) if isinstance(req_body, dict) else req_body, ensure_ascii=False)}")
    print(f"  < status:  {resp.status_code}  ({elapsed_s:.3f}s)")
    print(f"  < headers: {dict(resp.headers)}")
    parsed = _safe_json(resp.text)
    if parsed is not None:
        print(f"  < body:    {json.dumps(parsed, ensure_ascii=False)}")
    else:
        print(f"  < body:    {_truncate(resp.text)}")
    print(sep)


def biz_request(method: str, path: str, creds, **kwargs):
    headers = kwargs.pop("headers", None)
    cookies = kwargs.pop("cookies", None)

    if isinstance(creds, dict):
        token = creds.get("token") or ""
        yg = creds.get("yg") or ""
        if headers is None:
            headers = build_business_headers(token)
        if cookies is None:
            cookies = build_business_cookies(token, yg)
    else:
        token = creds or ""
        if headers is None:
            headers = build_business_headers(token)
        if cookies is None:
            cookies = {}

    kwargs.setdefault("verify", False)
    kwargs.setdefault("timeout", REQ_TIMEOUT)

    url = host_url(path)
    req_body = kwargs.get("data") or kwargs.get("json")
    if isinstance(req_body, bytes):
        try:
            req_body = json.loads(req_body.decode("utf-8"))
        except Exception:
            pass

    started = time.time()
    resp = requests.request(method, url, headers=headers, cookies=cookies, **kwargs)
    elapsed_s = time.time() - started

    if HTTP_VERBOSE:
        _print_req_resp(method, url, headers, req_body, resp, elapsed_s)

    # 检测"账号已退登"，自动重新登录并重试
    if isinstance(creds, dict) and _is_session_expired(resp):
        print(f"\n[Retry] 检测到「账号已退登」，重新登录...")
        new_creds = _do_login()
        if new_creds:
            creds.update(new_creds)
            _save_cached_creds(new_creds)
            headers = build_business_headers(new_creds["token"])
            cookies = build_business_cookies(new_creds["token"], new_creds["yg"])
            started = time.time()
            resp = requests.request(method, url, headers=headers, cookies=cookies, **kwargs)
            elapsed_s = time.time() - started
            if HTTP_VERBOSE:
                _print_req_resp(method, url, headers, req_body, resp, elapsed_s)

    return resp


def _is_session_expired(resp) -> bool:
    """判断响应是否为「账号已退登」"""
    if resp.status_code != 401:
        return False
    try:
        rj = resp.json()
        msg = rj.get("msg", "")
        if isinstance(msg, str) and "退登" in msg:
            return True
    except Exception:
        pass
    return False


# =========================================================
# 四、登录链路
# =========================================================
def fetch_public_key() -> str:
    resp = requests.get(
        user_url(PATH_PUBLIC_KEY),
        headers=LOGIN_HEADERS,
        verify=False,
        timeout=REQ_TIMEOUT,
    )
    if resp.status_code != 200:
        raise RuntimeError(f"取公钥失败 status={resp.status_code} body={resp.text[:200]}")
    data = resp.json()
    pub = (((data or {}).get("data") or {}).get("rsa") or {}).get("publicKey")
    if not pub:
        raise RuntimeError(f"响应中未含 data.rsa.publicKey: {data}")
    return pub


def encrypt_password(plaintext: str, public_key_pem: str = None) -> str:
    if isinstance(plaintext, str) and len(plaintext) == 256:
        try:
            int(plaintext, 16)
            return plaintext
        except ValueError:
            pass
    if public_key_pem is None:
        public_key_pem = fetch_public_key()
    key = _load_pem(public_key_pem.encode("utf-8"))
    return key.encrypt(plaintext.encode("utf-8"), _rsa_padding.PKCS1v15()).hex()


def _load_cached_creds() -> dict:
    if not TOKEN_CACHE_FILE.exists():
        return None
    try:
        cache = json.loads(TOKEN_CACHE_FILE.read_text(encoding="utf-8"))
        if cache.get("account") != ACCOUNT or cache.get("community") != COMMUNITY:
            return None
        if not cache.get("token") or not cache.get("yg"):
            return None
        return {"token": cache["token"], "yg": cache["yg"]}
    except Exception:
        return None


def _save_cached_creds(creds: dict):
    try:
        TOKEN_CACHE_FILE.write_text(
            json.dumps({
                "account": ACCOUNT,
                "community": COMMUNITY,
                "token": creds["token"],
                "yg": creds["yg"],
                "ts": int(time.time()),
            }, ensure_ascii=False),
            encoding="utf-8",
        )
    except Exception as e:
        print(f"[Warn] 写入凭据缓存失败：{e}")


def _verify_creds(creds: dict) -> bool:
    if not creds or not creds.get("token") or not creds.get("yg"):
        return False
    try:
        resp = biz_request("GET", PATH_TOKEN_PROBE, creds)
    except Exception:
        return True
    if resp.status_code in (401, 403):
        return False
    return True


def _do_login() -> dict:
    """根据社区类型选择登录方式：ascend 走华为 ID，其他走 OneID"""
    if COMMUNITY == "ascend":
        return _do_login_huawei()
    return _do_login_oneid()


def _do_login_oneid() -> dict:
    """OneID 登录链路（openeuler/openUBMC/mindspore/unifiedbus）"""
    print(f"[Setup] [{COMMUNITY}] OneID 登录账号: {ACCOUNT}")
    try:
        encrypted = encrypt_password(PASSWORD)
    except Exception as e:
        pytest.skip(f"取公钥/加密密码失败：{e}")

    body = {
        "permission": "sigRead",
        "account": ACCOUNT,
        "client_id": CLIENT_ID,
        "password": encrypted,
        "need_captcha_verification": False,
        "accept_term": 0,
        "oneidPrivacyAccepted": "20250226",
    }

    sess = requests.Session()
    try:
        resp = sess.post(
            user_url(PATH_LOGIN),
            headers=LOGIN_HEADERS,
            data=json.dumps(body),
            verify=False,
            timeout=REQ_TIMEOUT,
        )
    except Exception as e:
        pytest.skip(f"登录接口请求异常：{e}")

    try:
        rj = resp.json()
    except Exception:
        pytest.skip(f"登录响应非 JSON status={resp.status_code}")

    if resp.status_code != 200 or rj.get("code") != 200:
        pytest.skip(f"登录失败 status={resp.status_code} code={rj.get('code')} msg={rj.get('msg')}")

    data = rj.get("data") or {}
    token = data.get("token")
    yg = sess.cookies.get("_Y_G_")
    ut = sess.cookies.get("_U_T_")

    if not token:
        pytest.skip(f"登录成功但 body.data.token 为空")
    if not yg:
        pytest.skip(f"登录成功但 Set-Cookie 未下发 _Y_G_")
    if ut and ut != token:
        token = ut

    print(f"[Setup] [{COMMUNITY}] 登录成功 token长度={len(token)}")
    return {"token": token, "yg": yg}


CAPTCHA_CODE = "1111"


def _do_login_huawei() -> dict:
    """Ascend 社区华为 ID SDK 浏览器登录。

    华为 ID 使用嵌入式 JS SDK 登录组件，无法用 requests.post 模拟，
    必须通过 Playwright 浏览器自动化完成。
    流程：打开登录页 → 填账号/密码/图形验证码(1111) → 点登录 →
    等跳转 → 从 cookie 提取 _U_T_ + _Y_G_。

    提示：若出现滑块验证码等人机验证，需要操作人手动完成。
    """
    print(f"[Setup] [ascend] Playwright 浏览器登录华为账号: {ACCOUNT}")
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        pytest.skip(
            "ascend 登录需要 playwright，请执行: "
            "pip install playwright && playwright install chromium"
        )

    login_url = f"{BASE_AUTH}/login"
    token = None
    yg = None

    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=False,
            args=["--disable-blink-features=AutomationControlled"],
        )
        context = browser.new_context(ignore_https_errors=True)
        page = context.new_page()
        page.add_init_script(
            'Object.defineProperty(navigator, "webdriver", {get: () => undefined})'
        )
        try:
            page.goto(login_url, wait_until="networkidle", timeout=30000)

            acct = page.query_selector('input.hwid-input.userAccount')
            acct.click()
            acct.type(ACCOUNT, delay=50)

            pwd = page.query_selector('input.hwid-input.hwid-input-pwd')
            pwd.click()
            pwd.type(PASSWORD, delay=50)

            captcha_el = page.query_selector('input[placeholder*="验证码"]')
            if captcha_el:
                captcha_el.click()
                captcha_el.type(CAPTCHA_CODE, delay=50)

            import time as _time
            _time.sleep(1)
            page.query_selector('div.hwid-login-btn').dispatch_event('click')

            # 等待 _U_T_ cookie 出现（华为 SDK 登录成功标志）
            for _ in range(20):
                _time.sleep(2)
                cookies = context.cookies()
                for c in cookies:
                    if c["name"] == "_U_T_":
                        token = c["value"]
                    elif c["name"] == "_Y_G_":
                        yg = c["value"]
                if token and yg:
                    break
        except Exception as e:
            pytest.skip(f"Playwright 登录失败：{e}")
        finally:
            browser.close()

    if not token:
        pytest.skip("华为登录成功但未获取到 _U_T_ cookie")
    if not yg:
        pytest.skip("华为登录成功但未获取到 _Y_G_ cookie")

    print(f"[Setup] [ascend] 登录成功 token长度={len(token)} _Y_G_长度={len(yg)}")
    return {"token": token, "yg": yg}


# =========================================================
# 五、Session 级 Fixture
# =========================================================
@pytest.fixture(scope="session")
def login_creds():
    """登录并返回完整鉴权凭据 {'token':..., 'yg':...}"""
    force_login = os.environ.get("FORCE_LOGIN", "0") in ("1", "true", "yes")

    if not force_login:
        cached = _load_cached_creds()
        if cached and _verify_creds(cached):
            print(f"\n[Setup] [{COMMUNITY}] 复用缓存凭据")
            return cached

    creds = _do_login()
    if not _verify_creds(creds):
        pytest.skip("登录成功但业务接口仍 401")
    _save_cached_creds(creds)
    return creds


@pytest.fixture(scope="session")
def login_token(login_creds):
    """向后兼容：仅返回 token 字符串"""
    return login_creds["token"]


@pytest.fixture
def created_meeting(login_creds):
    """创建一个测试会议供用例使用，yield 后强制删除"""
    from test_meeting_api import _post_meeting, _build_single_meeting_body, _extract_meeting_id

    body = _build_single_meeting_body(
        topic=f"fixture-setup-{int(time.time())}",
        date=next_month_first_day(),
    )
    resp = _post_meeting(login_creds, body)
    if resp.status_code != 200:
        pytest.skip(f"fixture 创建会议失败: {resp.status_code} {resp.text[:200]}")
    mid = _extract_meeting_id(resp.json())
    if not mid:
        pytest.skip(f"fixture 未取到 meeting_id: {resp.text[:200]}")

    yield mid

    try:
        biz_request(
            "DELETE",
            f"{API_PREFIX}/{mid}/",
            login_creds,
        )
    except Exception:
        pass
