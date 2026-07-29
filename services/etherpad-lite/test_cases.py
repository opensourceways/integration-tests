# -*- coding: utf-8 -*-
"""
etherpad 接口测试用例（对应 etherpad.jmx 的 4 个 HTTP 请求步骤）
执行顺序依赖通过 fixture 注入保证：token / token_auth 为 session 级，只执行一次
"""

from conftest import ETHERPAD_BASE, USERCENTER_BASE


class TestLogin:
    """1-登录"""

    def test_login_get_token(self, token):
        assert token, "token 为空"
        assert token.startswith("eyJ"), f"token 格式异常: {token[:30]}"


class TestVersion:
    """2-version：查询隐私协议版本"""

    def test_privacy_version(self, http_session, token):
        headers = {"token": token, "Content-Type": "application/json"}
        resp = http_session.get(f"{USERCENTER_BASE}/oneid/privacy/version", headers=headers)
        assert resp.status_code == 200, f"version 请求失败: {resp.status_code}"

        body = resp.json()
        assert body.get("code") == 200, f"version 响应异常: {body}"
        assert body.get("msg") == "success", f"version 响应异常: {body}"


class TestAuth:
    """3-auth：消息中心鉴权，获取 _U_T_ cookie"""

    def test_auth_get_ut_cookie(self, token_auth):
        assert token_auth, "_U_T_ 为空"
        assert token_auth.startswith("eyJ"), f"_U_T_ 格式异常: {token_auth[:30]}"


class TestEtherpad:
    """4-获取etherpad：socket.io polling 握手"""

    def test_socketio_handshake(self, http_session, token_auth):
        headers = {"Content-Type": "application/json", "token": token_auth}
        params = {"padId": "111", "EIO": "4", "transport": "polling", "t": "PJp1U8x"}
        resp = http_session.get(f"{ETHERPAD_BASE}/socket.io/", params=params, headers=headers)
        assert resp.status_code == 200, f"socket.io 请求失败: {resp.status_code}"

        # 响应形如: 0{"sid":"...","upgrades":["websocket"],...}
        assert resp.text.startswith("0{"), f"socket.io 握手响应异常: {resp.text[:200]}"
        assert '"sid"' in resp.text, f"响应中缺少 sid: {resp.text[:200]}"
