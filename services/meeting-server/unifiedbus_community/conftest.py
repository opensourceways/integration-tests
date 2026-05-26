# -*- coding: utf-8 -*-
"""
pytest 共享配置：openUBMC 测试套件通用 fixture 与登录链路
=========================================================

提供给同目录下所有 test_*.py 共享：
    - 全局常量：HOST_URL / USER_URL / CLIENT_ID / 鉴权头
    - 工具函数：user_url / host_url / build_business_headers / biz_request
    - 登录链路：fetch_public_key / encrypt_password / do_login
    - 鉴权凭据缓存：跨 pytest 运行复用 token + _U_T_ + _Y_G_
    - Session 级 fixture：login_token / login_creds（30 个用例只触发 0~1 次真实登录）

平台鉴权机制（实测校正）：
    业务接口（/api-meeting/*、/api-message/*）真正需要的鉴权是：
        Header: token: <body.data.token 的值>
        Cookie: _U_T_=<同 token>; _Y_G_=<会话 cookie>
    只带 token header（不带 cookie）→ 401 "鉴权失败，您的账号已退登"
    只带 _Y_G_（不带 _U_T_）       → 401
    缺其一即被业务侧拒绝。

历史误区（已废弃）：
    旧版 build_business_headers 注释里写"不要带 cookie"是误判，
    实测仅依赖 token header 100% 会被拒。

凭据缓存机制：
    OneID 同 client_id 单设备会话——重复登录会让上一次取到的 token 失效。
    本模块将 token + _U_T_ + _Y_G_ 落盘到 meeting/.token_cache.json，
    跨 pytest 运行复用，每次启动先轻量校验缓存是否仍有效
    （GET /platform/，401/403 才算失效），有效则直接复用。
    强制重新登录：set FORCE_LOGIN=1
    手动清缓存  ：删除 meeting/.token_cache.json
"""

import os
import json
import time
import urllib3

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
# 一、全局常量
# =========================================================
# 域名来源：unifiedbus 社区
#   userURL=id.unifiedbus.test.osinfra.cn
#   hostURL=unifiedbus.test.osinfra.cn
HOST_URL = os.environ.get("HOST_URL", "unifiedbus.test.osinfra.cn")
USER_URL = os.environ.get("USER_URL", "id.unifiedbus.test.osinfra.cn")
CLIENT_ID = "68a5825f4f008658ee22e148"
PROTOCOL = "https"

BASE_AUTH = f"{PROTOCOL}://{USER_URL}"
BASE_BIZ = f"{PROTOCOL}://{HOST_URL}"

ACCOUNT = os.environ.get("TEST_ACCOUNT_UNIFIEDBUS")
PASSWORD = os.environ.get("TEST_PASSWORD")

PATH_PUBLIC_KEY = "/oneid/public/key"
PATH_LOGIN = "/oneid/login"
# 用于轻量校验登录凭据是否仍有效的探针接口（unifiedbus 路径前缀 /api-meeting/）
PATH_TOKEN_PROBE = os.environ.get(
    "PATH_TOKEN_PROBE", "/api-meeting/platform/"
)

REQ_TIMEOUT = 30

TOKEN_CACHE_FILE = os.path.join(os.path.dirname(__file__), ".token_cache.json")

# unifiedbus 域 OneID 登录无需 redirect_uri 字段；保留常量供调用侧引用，但 body 不带
REDIRECT_URI = f"{BASE_BIZ}/auth/callback"
LOGIN_HEADERS = {
    "Content-Type": "application/json;charset=UTF-8",
    "Accept": "*/*",
    "Origin": BASE_AUTH,
    "Referer": f"{BASE_AUTH}/",
    "Host": USER_URL,
}


# =========================================================
# 二、通用工具函数
# =========================================================
def user_url(path: str) -> str:
    return f"{BASE_AUTH}{path}"


def host_url(path: str) -> str:
    return f"{BASE_BIZ}{path}"


def build_business_headers(token: str) -> dict:
    """业务接口（/api-meeting 等）通用 Header

    Header 仅放 token；_U_T_ / _Y_G_ Cookie 必须通过 cookies 参数同时下发，
    缺其一接口会返回 401「鉴权失败，您的账号已退登」。
    实际请求请走 biz_request()，它会自动注入完整 cookie。
    """
    return {
        "token": token if token is not None else "",
        "Content-Type": "application/json;charset=UTF-8",
        "Accept": "*/*",
        "Origin": BASE_BIZ,
        "Referer": f"{BASE_BIZ}/personal/meeting",
        "Host": HOST_URL,
    }


def build_business_cookies(token: str, yg: str = None) -> dict:
    """业务接口必备 Cookie：_U_T_ + _Y_G_ 缺一不可"""
    cookies = {}
    if token:
        cookies["_U_T_"] = token
    if yg:
        cookies["_Y_G_"] = yg
    return cookies


def _is_unauth_response(resp) -> bool:
    """判断响应是否属于「账号已退登 / token 失效」类的鉴权失败。

    平台特征：HTTP 401 + body 含「账号已退登」/「鉴权失败」/code=401。
    """
    if resp is None:
        return False
    if resp.status_code != 401:
        return False
    txt = (resp.text or "")[:300]
    if "账号已退登" in txt or "鉴权失败" in txt:
        return True
    try:
        rj = resp.json()
        if isinstance(rj, dict) and rj.get("code") in (401, "401"):
            return True
    except Exception:
        pass
    return True  # 401 一律视为鉴权失败


def biz_request(method: str, path: str, creds, **kwargs):
    """业务接口请求统一入口。

    Args:
        method: HTTP 方法
        path  : 业务路径，自动拼 BASE_BIZ
        creds : 登录凭据，三种取值：
            - dict {"token":..., "yg":...} —— 正常带完整鉴权；
              首次响应 401「账号已退登」时会自动重新登录并重试一次，
              新 token/yg 会**原地写回 creds dict**，后续用例继承新凭据。
            - str token —— 兼容旧调用，仅带 token header（用例可显式触发未登录场景），
              此模式不会触发自动续签。
            - None / "" —— 不带任何鉴权（权限校验用例用），不会触发自动续签。
        **kwargs: 透传 requests.request
    """
    headers = kwargs.pop("headers", None)
    cookies = kwargs.pop("cookies", None)
    # 调用方可显式关闭自动续签（如「权限校验」类用例本就期望 401）
    auto_relogin = kwargs.pop("auto_relogin", True)

    def _send(token_, yg_, _headers, _cookies):
        if _headers is None:
            _headers = build_business_headers(token_)
        if _cookies is None:
            _cookies = build_business_cookies(token_, yg_) if isinstance(creds, dict) else {}
        kw = dict(kwargs)
        kw.setdefault("verify", False)
        kw.setdefault("timeout", REQ_TIMEOUT)
        return requests.request(method, host_url(path), headers=_headers, cookies=_cookies, **kw)

    if isinstance(creds, dict):
        token = creds.get("token") or ""
        yg = creds.get("yg") or ""
        resp = _send(token, yg, headers, cookies)

        # token 仍有效——绝大多数情况：直接返回
        if not auto_relogin or not _is_unauth_response(resp):
            return resp

        # 命中「账号已退登」：重新登录、原地续签、重发一次
        print(f"[biz_request] 检测到 401「账号已退登」，自动重新登录续签 token …")
        try:
            new_creds = _do_login()
        except Exception as e:
            print(f"[biz_request] 自动续签失败：{e}，返回原始 401 响应")
            return resp
        creds["token"] = new_creds["token"]
        creds["yg"] = new_creds["yg"]
        try:
            _save_cached_creds(new_creds)
        except Exception:
            pass
        # 用调用方原本传入的 headers/cookies（None 时让 _send 用新 token 重建）
        return _send(creds["token"], creds["yg"], None, None)

    # 字符串 token / None：兼容老路径，不参与自动续签
    token = creds or ""
    if headers is None:
        headers = build_business_headers(token)
    if cookies is None:
        cookies = {}
    kwargs.setdefault("verify", False)
    kwargs.setdefault("timeout", REQ_TIMEOUT)
    return requests.request(method, host_url(path), headers=headers, cookies=cookies, **kwargs)


# =========================================================
# 三、登录链路：取公钥 + RSA 加密密码
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
    """OneID 实测加密：RSA PKCS1v15 → bytes → hex 字符串

    若传入字符串本身就是 256 字符 hex 串（疑似预加密），原样返回。
    """
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


# =========================================================
# 四、登录凭据本地缓存
# =========================================================
def _load_cached_creds() -> dict:
    """从本地缓存读取凭据；不存在/损坏/账号不匹配返回 None"""
    if not os.path.exists(TOKEN_CACHE_FILE):
        return None
    try:
        with open(TOKEN_CACHE_FILE, "r", encoding="utf-8") as f:
            cache = json.load(f)
        if cache.get("account") != ACCOUNT:
            return None
        if not cache.get("token") or not cache.get("yg"):
            return None
        return {"token": cache["token"], "yg": cache["yg"]}
    except Exception:
        return None


def _save_cached_creds(creds: dict):
    try:
        with open(TOKEN_CACHE_FILE, "w", encoding="utf-8") as f:
            json.dump(
                {
                    "account": ACCOUNT,
                    "token": creds["token"],
                    "yg": creds["yg"],
                    "ts": int(time.time()),
                },
                f,
                ensure_ascii=False,
            )
    except Exception as e:
        print(f"[Warn] 写入凭据缓存失败：{e}")


def _verify_creds(creds: dict) -> bool:
    """轻量校验凭据是否仍有效：GET /platform/

    - 2xx → 有效
    - 401/403 → 失效
    - 5xx → 后端故障，按"有效"处理（避免误判）
    """
    if not creds or not creds.get("token") or not creds.get("yg"):
        return False
    try:
        resp = biz_request("GET", PATH_TOKEN_PROBE, creds)
    except Exception:
        return True
    if resp.status_code in (401, 403):
        return False
    if 500 <= resp.status_code < 600:
        return True
    return True


def _do_login() -> dict:
    """执行完整登录链路，返回 {'token':..., 'yg':...}；失败抛 pytest.skip

    平台实测：调用 /oneid/login 后 Set-Cookie 同时下发 _U_T_ 和 _Y_G_，
    其中 _U_T_ 的值与 body.data.token 完全一致；_Y_G_ 是另一段独立会话标识。
    业务接口同时需要两者。
    """
    print(f"[Setup] 调用 /oneid/login 登录账号: {ACCOUNT}")
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
        pytest.skip(f"登录响应非 JSON status={resp.status_code} body={resp.text[:300]}")

    if resp.status_code != 200 or rj.get("code") != 200:
        msg = rj.get("msg")
        pytest.skip(
            f"登录失败 status={resp.status_code} code={rj.get('code')} msg={msg}；"
            "若密码错请通过 PASSWORD 环境变量传入正确明文。"
        )

    data = rj.get("data") or {}
    token = data.get("token")
    yg = sess.cookies.get("_Y_G_")
    ut = sess.cookies.get("_U_T_")

    if not token:
        pytest.skip(f"登录成功但 body.data.token 为空：{rj}")
    if not yg:
        pytest.skip(f"登录成功但 Set-Cookie 未下发 _Y_G_，业务鉴权将失败：headers={dict(resp.headers)}")
    if ut and ut != token:
        print(f"[Setup][Warn] _U_T_ 与 body.token 不一致，采用 _U_T_：ut={ut[:20]}... token={token[:20]}...")
        token = ut

    print(f"[Setup] 登录成功 username={data.get('username')} token长度={len(token)} _Y_G_长度={len(yg)}")
    return {"token": token, "yg": yg}


# =========================================================
# 五、Session 级 Fixture
# =========================================================
@pytest.fixture(scope="session")
def login_creds():
    """登录并返回完整鉴权凭据 dict：{'token':..., 'yg':...}

    优化策略（彻底解决"账号已退登"问题）：
        1. 优先读取本地缓存 .token_cache.json（含 token + _Y_G_）
        2. 调用 /platform/ 轻量校验缓存凭据是否仍有效
        3. 缓存有效 → 直接复用，绝不重复登录
        4. 缓存无效/不存在 → 调用一次 /oneid/login，落盘缓存
        5. 用 fixture 内置一次首跑探针，登录后立刻 GET /platform/，
           确认凭据已被业务侧激活；若 401 抛 skip，避免后续 30 条用例全 FAIL。

    强制刷新登录（忽略缓存）：FORCE_LOGIN=1
    手动清缓存  ：删除同目录下 .token_cache.json
    """
    force_login = os.environ.get("FORCE_LOGIN", "0") in ("1", "true", "True", "yes")

    if not force_login:
        cached = _load_cached_creds()
        if cached and _verify_creds(cached):
            print(f"\n[Setup] 复用本地缓存凭据（账号 {ACCOUNT}，token 长度 {len(cached['token'])}）")
            return cached
        if cached:
            print(f"\n[Setup] 缓存凭据已失效，重新登录")

    creds = _do_login()
    # 登录后立刻探针校验，确保凭据已被业务侧接受
    if not _verify_creds(creds):
        pytest.skip(
            "登录成功但业务接口仍 401「账号已退登」。"
            "可能原因：1) 浏览器/其他客户端已用同账号登录挤掉当前会话；"
            "2) 平台 OAuth 状态同步延迟；请稍后重试或先 logout 其他设备。"
        )
    _save_cached_creds(creds)
    return creds


@pytest.fixture(scope="session")
def login_token(login_creds):
    """向后兼容的 fixture：仅返回 token 字符串

    新用例请优先使用 login_creds 拿到完整凭据 + biz_request；
    旧用例直接传 login_token 给 biz_request 时也支持（按 str 走兼容分支）。
    """
    return login_creds["token"]
