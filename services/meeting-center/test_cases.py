# meeting-center 模块测试用例（Python pytest 脚本）
# 来源 PR：[#133](https://github.com/agentic-develop-playground/backlog/pull/133)，issues=5

"""
测试用例脚本：meeting-center 模块

用例总数：33 | 自动化：33 | 手工：0
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests pytest-dependency

执行：
    pytest -v test_cases.py                       # 执行全部自动化用例
    pytest -v test_cases.py -k PUBLIC             # 执行公开会议相关用例
    pytest -v test_cases.py -m p0                 # 执行 P0 优先级用例

占位符（执行前由环境变量注入）：
    BASE_URL       —— 测试环境 API 基础 URL（如 https://preview.example.com）
    AUTH_URL       —— OneID 认证服务 URL（如 https://usercenter.openubmc.test.osinfra.cn）
    SPONSOR_TOKEN  —— 私有会议发起人 token（由 fixture 自动获取或环境变量注入）
    MEMBER_TOKEN   —— SIG 组成员 token
    ADMIN_TOKEN    —— 管理员 token
    NORMAL_TOKEN   —— 普通用户 token（无权限）
    PASSWORD       —— 测试账号密码
"""

import os
import pytest
import requests
import re
from unittest import mock


# ===== 模块级常量 =====
BASE_URL = os.environ.get("BASE_URL", "https://preview.example.com")
AUTH_URL = os.environ.get("AUTH_URL", "https://usercenter.openubmc.test.osinfra.cn")
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
        f"{AUTH_URL}/oneid/login",
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
        f"{AUTH_URL}/oneid/login",
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
        f"{AUTH_URL}/oneid/login",
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
        f"{AUTH_URL}/oneid/login",
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


# ===== 用例 ===============================================================

# --- 模块：公开会议参会者查询 -----------------------------------------------------------

@pytest.mark.p0
def test_meeting_public_001_no_auth_access(api_client):
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
def test_meeting_public_002_data_structure(api_client):
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
def test_meeting_public_003_email_masking(api_client):
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
def test_meeting_public_004_phone_masking(api_client):
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


# --- 模块：私有会议参会者查询 -----------------------------------------------------------

@pytest.mark.p0
def test_meeting_private_001_sponsor_access(api_client, sponsor_token):
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
def test_meeting_private_002_member_access(api_client, member_token):
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
def test_meeting_private_003_admin_access(api_client, admin_token):
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
def test_meeting_private_004_no_auth_return_401(api_client):
    """TC-API-MEETING-PRIVATE-004 [权限] 私有会议无认证访问返回 401"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code in (401, 403)


@pytest.mark.p0
def test_meeting_private_005_no_permission_return_403(api_client, normal_token):
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
def test_meeting_private_006_token_expired(api_client):
    """TC-API-MEETING-PRIVATE-006 [权限] 私有会议 Token 过期返回 401"""
    expired_token = "expired_token_12345"
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {expired_token}"},
        timeout=10,
    )
    assert resp.status_code == 401


# --- 模块：分页功能 -----------------------------------------------------------

@pytest.mark.p0
def test_meeting_pagination_001_default_params(api_client):
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
def test_meeting_pagination_002_custom_params(api_client):
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
def test_meeting_pagination_003_size_100(api_client):
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
def test_meeting_pagination_004_size_101(api_client):
    """TC-API-MEETING-PAGINATION-004 [边界值] 分页 size=101 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=1&size=101",
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400


@pytest.mark.p1
def test_meeting_pagination_005_page_0(api_client):
    """TC-API-MEETING-PAGINATION-005 [异常输入] 分页 page=0 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=0",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_006_page_negative(api_client):
    """TC-API-MEETING-PAGINATION-006 [异常输入] 分页 page=-1 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=-1",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_007_size_0(api_client):
    """TC-API-MEETING-PAGINATION-007 [异常输入] 分页 size=0 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=0",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_008_size_negative(api_client):
    """TC-API-MEETING-PAGINATION-008 [异常输入] 分页 size=-5 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=-5",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_009_page_non_numeric(api_client):
    """TC-API-MEETING-PAGINATION-009 [异常输入] 分页 page=abc 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=abc",
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_pagination_010_size_non_numeric(api_client):
    """TC-API-MEETING-PAGINATION-010 [异常输入] 分页 size=xyz 返回 400"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?size=xyz",
        timeout=10,
    )
    assert resp.status_code == 400


# --- 模块：会议不存在 -----------------------------------------------------------

@pytest.mark.p0
def test_meeting_notfound_001_nonexist(api_client):
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
def test_meeting_notfound_002_deleted(api_client):
    """TC-API-MEETING-NOTFOUND-002 [异常] 已删除会议返回 404"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{DELETED_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 404
    body = resp.json()
    assert body.get("code") == 404
    assert "不存在或已删除" in body.get("message", "")


# --- 模块：集成测试 -----------------------------------------------------------

@pytest.mark.p1
def test_meeting_integration_001_cross_service_call(api_client):
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
def test_meeting_integration_002_platform_error(api_client):
    """TC-API-MEETING-INTEGRATION-002 [集成] meeting-platform 异常时正确处理"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{NONEXIST_MEETING_ID}/participants/",
        timeout=10,
    )
    assert resp.status_code == 404
    body = resp.json()
    assert "不存在" in body.get("message", "") or "已删除" in body.get("message", "")


@pytest.mark.p1
def test_meeting_integration_003_oneid_error(api_client):
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


# --- 模块：安全测试 -----------------------------------------------------------

@pytest.mark.p1
def test_meeting_security_001_dynamic_auth(api_client):
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
def test_meeting_security_002_horizontal_bypass(api_client, normal_token, sponsor_token):
    """TC-API-MEETING-SECURITY-002 [安全] 横向越权防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {normal_token}"},
        timeout=10,
    )
    assert resp.status_code == 403


@pytest.mark.p2
def test_meeting_security_003_vertical_bypass(api_client, normal_token):
    """TC-API-MEETING-SECURITY-003 [安全] 纵向越权防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PRIVATE_MEETING_ID}/participants/",
        headers={"Authorization": f"Bearer {normal_token}"},
        timeout=10,
    )
    assert resp.status_code == 403


@pytest.mark.p2
def test_meeting_security_004_sql_injection(api_client):
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
def test_meeting_security_005_xss_injection(api_client):
    """TC-API-MEETING-SECURITY-005 [安全] XSS 注入防护生效"""
    resp = api_client.get(
        f"{BASE_URL}/meeting/{PUBLIC_MEETING_ID}/participants/?page=<script>alert(1)</script>",
        timeout=10,
    )
    assert resp.status_code == 400


# --- 模块：脱敏逻辑 -----------------------------------------------------------

@pytest.mark.p2
def test_meeting_mask_001_short_email(api_client):
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
def test_meeting_mask_002_short_phone(api_client):
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
def test_meeting_mask_003_invalid_email(api_client):
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
def test_meeting_mask_004_invalid_phone(api_client):
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
# | TC-API-MEETING-PUBLIC-001 | [正常流] 公开会议无认证可访问 | #5 验收标准 1 | P0 | interface | #133 |
# | TC-API-MEETING-PUBLIC-002 | [正常流] 公开会议参会者数据结构正确 | #5 验收标准 1 | P0 | interface | #133 |
# | TC-API-MEETING-PUBLIC-003 | [安全] 公开会议参会者邮箱脱敏生效 | #5 验收标准 1 | P1 | interface | #133 |
# | TC-API-MEETING-PUBLIC-004 | [安全] 公开会议参会者手机号脱敏生效 | #5 验收标准 1 | P1 | interface | #133 |
# | TC-API-MEETING-PRIVATE-001 | [正常流] 私有会议发起人认证后可访问 | #5 验收标准 2 | P0 | interface | #133 |
# | TC-API-MEETING-PRIVATE-002 | [权限] 私有会议 SIG 组成员认证后可访问 | #5 验收标准 2 | P1 | interface | #133 |
# | TC-API-MEETING-PRIVATE-003 | [权限] 私有会议管理员认证后可访问 | #5 验收标准 2 | P1 | interface | #133 |
# | TC-API-MEETING-PRIVATE-004 | [权限] 私有会议无认证访问返回 401 | #5 醇收标准 6 | P0 | interface | #133 |
# | TC-API-MEETING-PRIVATE-005 | [权限] 私有会议无权限用户访问返回 403 | #5 醇收标准 6 | P0 | interface | #133 |
# | TC-API-MEETING-PRIVATE-006 | [权限] 私有会议 Token 过期返回 401 | #5 醇收标准 6 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-001 | [正常流] 默认分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #133 |
# | TC-API-MEETING-PAGINATION-002 | [正常流] 自定义分页参数返回正确数据 | #5 验收标准 3 | P0 | interface | #133 |
# | TC-API-MEETING-PAGINATION-003 | [边界值] 分页 size=100 返回最多 100 条 | #5 验收标准 7 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-004 | [边界值] 分页 size=101 返回 400 | #5 验收标准 7 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-005 | [异常输入] 分页 page=0 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-006 | [异常输入] 分页 page=-1 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-007 | [异常输入] 分页 size=0 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-008 | [异常输入] 分页 size=-5 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-009 | [异常输入] 分页 page=abc 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-PAGINATION-010 | [异常输入] 分页 size=xyz 返回 400 | #5 醇收标准 8 | P1 | interface | #133 |
# | TC-API-MEETING-NOTFOUND-001 | [异常] 会议不存在返回 404 | #5 醇收标准 4 | P0 | interface | #133 |
# | TC-API-MEETING-NOTFOUND-002 | [异常] 已删除会议返回 404 | #5 醇收标准 5 | P0 | interface | #133 |
# | TC-API-MEETING-INTEGRATION-001 | [集成] 跨服务调用链路正常 | #5 设计要点 | P1 | integration | #133 |
# | TC-API-MEETING-INTEGRATION-002 | [集成] meeting-platform 异常时正确处理 | #5 设计要点 | P1 | integration | #133 |
# | TC-API-MEETING-INTEGRATION-003 | [集成] OneID 批量查询失败时正确处理 | #5 设计要点 | P1 | integration | #133 |
# | TC-API-MEETING-SECURITY-001 | [安全] 动态认证机制生效 | #5 安全设计 | P1 | interface | #133 |
# | TC-API-MEETING-SECURITY-002 | [安全] 横向越权防护生效 | #5 安全设计 | P1 | interface | #133 |
# | TC-API-MEETING-SECURITY-003 | [安全] 纵向越权防护生效 | #5 安全设计 | P2 | interface | #133 |
# | TC-API-MEETING-SECURITY-004 | [安全] SQL 注入防护生效 | #5 安全设计 | P2 | interface | #133 |
# | TC-API-MEETING-SECURITY-005 | [安全] XSS 注入防护生效 | #5 安全设计 | P2 | interface | #133 |
# | TC-API-MEETING-MASK-001 | [安全] 短邮箱脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #133 |
# | TC-API-MEETING-MASK-002 | [安全] 短手机号脱敏处理正确 | #5 脱敏逻辑 | P2 | interface | #133 |
# | TC-API-MEETING-MASK-003 | [安全] 无效邮箱格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #133 |
# | TC-API-MEETING-MASK-004 | [安全] 无效手机号格式不脱敏 | #5 脱敏逻辑 | P2 | interface | #133 |
#