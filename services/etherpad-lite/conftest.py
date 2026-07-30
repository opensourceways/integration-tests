# -*- coding: utf-8 -*-
"""
pytest 公共配置与 fixtures
对应原 etherpad.jmx 的测试计划层：Cookie 管理器（Session）、登录提取 token、鉴权提取 _U_T_
"""

import re

import pytest
import requests

# ============ 全局配置 ============
USERCENTER_BASE = "https://usercenter.openubmc.cn"
ETHERPAD_BASE = "https://etherpad.openubmc.cn"

LOGIN_PAYLOAD = {
    "permission": "sigRead",
    "account": "19938204520",
    "client_id": "6758f36c329a60ac4b25403c",
    "password": "84521ebc3587af625c971042b97d20ffdd2cd63073e808a699cc4a752d37ab03889d24e4db93e6baab90e6cb506f5a7f0b4821ab19c6a67ba7e29c182ce4865fb33dffdbc6eff3156506a7486fb6bf098ef4849683271d2992003c5366f7bfa00801f71cf498a1fc7bc296202762fd9d8b3ba16e99927b998a775ae605951876",
}

CLIENT_ID = "6758f36c329a60ac4b25403c"
REDIRECT_URI = "https://etherpad.openubmc.cn/ep_openid_connect/callback"
STATE = "s6yuo0J1yG8ATP9iIuMYCzzs4pNQXXFQfHtPLw9F760"

LOGIN_HEADERS = {
    "Accept": "*/*",
    "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
    "Content-Type": "application/json;charset=UTF-8",
    "Origin": USERCENTER_BASE,
    "Referer": USERCENTER_BASE + "/login?redirect_uri=https%3A%2F%2Fwww.openubmc.cn%2Fzh&lang=zh",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                  "(KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0",
    "sec-ch-ua": '"Not(A:Brand";v="8", "Chromium";v="144", "Microsoft Edge";v="144"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"Windows"',
}


@pytest.fixture(scope="session")
def http_session():
    """对应 JMX 的 HTTP Cookie 管理器：自动保存/携带 Cookie，整个测试会话复用"""
    session = requests.Session()
    yield session
    session.close()


@pytest.fixture(scope="session")
def token(http_session):
    """1-登录：POST /oneid/login，正则提取 token（对应 RegexExtractor）"""
    resp = http_session.post(f"{USERCENTER_BASE}/oneid/login",
                             json=LOGIN_PAYLOAD, headers=LOGIN_HEADERS)
    assert resp.status_code == 200, f"登录请求失败: {resp.status_code}"

    match = re.search(r'"token":"(.+?)"', resp.text)
    assert match, f"登录响应中未提取到 token: {resp.text[:500]}"
    return match.group(1)


@pytest.fixture(scope="session")
def token_auth(http_session, token):
    """3-auth：GET /api-message/message_center/all，从 Set-Cookie 提取 _U_T_（对应 BoundaryExtractor）"""
    headers = {"token": token, "Content-Type": "application/json"}
    params = {
        "client_id": CLIENT_ID,
        "redirect_uri": REDIRECT_URI,
        "response_type": "code",
        "scope": "openid profile id_token",
        "state": STATE,
    }
    resp = http_session.get(f"{USERCENTER_BASE}/api-message/message_center/all",
                            params=params, headers=headers)
    assert resp.status_code == 200, f"auth 请求失败: {resp.status_code}"

    match = re.search(r"_U_T_=(.+?);\s*Max-Age=1800", resp.headers.get("Set-Cookie", ""))
    if match:
        return match.group(1)
    # 兜底：session 已自动保存该 cookie
    token_auth = http_session.cookies.get("_U_T_")
    assert token_auth, "未提取到 _U_T_ cookie"
    return token_auth
