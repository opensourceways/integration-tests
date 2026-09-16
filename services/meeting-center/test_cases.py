"""
测试用例脚本：meeting-center

来源：Issue #736 - 会议系统支持自动发送纪要到邮件列表（meeting-center 门户层集成测试）
用例总数：10 | 自动化：10 | 手工：0

依赖：
    pip install pytest requests

执行：
    pytest -v test_cases.py                        # 执行全部自动化用例
    pytest -v test_cases.py -m p0                 # 仅执行 P0 用例（smoke）
    pytest -v test_cases.py -m p1                 # 仅执行 P1 用例（集成代理链路）
    pytest -v test_cases.py -k "smoke"            # 执行 smoke 模块

占位符（执行前由环境变量注入）：
    MEETING_CENTER_HOST  —— meeting-center 服务地址
    COMMUNITY            —— 测试社区名（如 openEuler / CANN）
    AUTH_TOKEN           —— OneID 登录后的 Cookie/Token（meeting-center 用 OneID 会话认证，非 BasicAuth）

待人工执行：
    无（本批次全部可自动化）
"""

import pytest
import requests
import os


# ===== 模块级常量 =====
BASE = os.environ.get("MEETING_CENTER_HOST", "http://meeting-center.test.osinfra.cn")
COMMUNITY = os.environ.get("COMMUNITY", "openEuler")
AUTH_TOKEN = os.environ.get("AUTH_TOKEN", "")
TIMEOUT = 30  # 秒（meeting-center 代理 meeting-platform，可能较慢）


# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def base_url():
    return BASE.rstrip("/")


@pytest.fixture(scope="session")
def auth_headers():
    """OneID 会话认证 header（Cookie 方式）"""
    if not AUTH_TOKEN:
        pytest.skip("AUTH_TOKEN 未配置（OneID 登录 Cookie/Token）")
    return {"Cookie": AUTH_TOKEN, "Content-Type": "application/json;charset=UTF-8"}


@pytest.fixture(scope="session")
def no_auth_headers():
    """无认证 header（用于 ping 等公开端点）"""
    return {"Content-Type": "application/json;charset=UTF-8"}


# ===== P0: Smoke Test（核心读取链路） =====


@pytest.mark.p0
class TestSmoke:
    """P0 smoke：验证 meeting-center 核心端点可用"""

    def test_ping(self, base_url, no_auth_headers):
        """健康检查"""
        resp = requests.get(f"{base_url}/ping/", timeout=TIMEOUT, headers=no_auth_headers)
        assert resp.status_code == 200

    def test_meeting_date_list(self, base_url, auth_headers):
        """获取会议日期列表（官网日历）"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/meeting_date/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("code") == 200
        dates = data.get("data", [])
        assert isinstance(dates, list)

    def test_meeting_list(self, base_url, auth_headers):
        """获取会议列表（官网展示）"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/meeting/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("code") == 200

    def test_group_name_list(self, base_url, auth_headers):
        """获取 SIG 组名列表"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/group_name/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("code") == 200

    def test_platform_list(self, base_url, auth_headers):
        """获取会议平台类型"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/platform/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("code") == 200

    def test_roles_list(self, base_url, auth_headers):
        """获取会议角色列表"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/roles/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data.get("code") == 200


# ===== P1: 集成测试（meeting-center → meeting-platform 代理链路） =====


@pytest.mark.p1
class TestProxyChain:
    """P1 集成：验证 meeting-center 正确代理 meeting-platform 的数据"""

    def test_meeting_list_has_platform_fields(self, base_url, auth_headers):
        """会议列表响应含 meeting-platform 的核心字段（代理数据结构一致）"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/meeting/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code == 200
        data = resp.json().get("data", [])
        if isinstance(data, list) and len(data) > 0:
            meeting = data[0]
            # meeting-center 代理 meeting-platform 返回的会议应含这些核心字段
            for field in ("community", "topic", "date", "start", "end"):
                assert field in meeting, f"缺失字段 {field}"

    def test_meeting_date_matches_meeting_list(self, base_url, auth_headers):
        """日期列表与会议列表的日期一致（同源代理链路）"""
        resp_dates = requests.get(
            f"{base_url}/api/v1/meeting/meeting_date/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        dates = resp_dates.json().get("data", [])

        resp_meetings = requests.get(
            f"{base_url}/api/v1/meeting/meeting/",
            params={"community": COMMUNITY},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        meetings = resp_meetings.json().get("data", [])

        if dates and isinstance(meetings, list) and meetings:
            meeting_dates = {m.get("date") for m in meetings if m.get("date")}
            # 至少一个会议列表里的日期应出现在日期列表中
            assert meeting_dates & set(dates), "会议列表的日期未出现在日期列表中"


# ===== P2: 错误处理 =====


@pytest.mark.p2
class TestErrorHandling:
    """P2 错误处理：验证异常输入不 500"""

    def test_invalid_community_returns_graceful(self, base_url, auth_headers):
        """无效 community → 不 500（空列表或 400）"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/meeting/",
            params={"community": "NONEXISTENT_COMMUNITY_XYZ"},
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code != 500, "无效 community 不应 500"

    def test_nonexistent_meeting_returns_graceful(self, base_url, auth_headers):
        """不存在的 meeting id → 400/404（不 500）"""
        resp = requests.get(
            f"{base_url}/api/v1/meeting/99999999/",
            timeout=TIMEOUT,
            headers=auth_headers,
        )
        assert resp.status_code in (400, 404), f"期望 400/404，实际 {resp.status_code}"
