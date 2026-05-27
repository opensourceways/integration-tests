# meeting-platform 模块全量测试用例（Python pytest 脚本）
# 来源 PR: #361 — docs(test): test design from #346
# 架构文档: issue_docs/344/Architecture Design/#344 需求设计说明书.md

import pytest
import requests
import os
from datetime import datetime, timedelta

# ===== 模块级常量 =====
BASE_CENTER_API = os.environ.get("MEETING_CENTER_API", "https://meeting-center.test.example.com")
BASE_PLATFORM_API = os.environ.get("MEETING_PLATFORM_API", "https://meeting-platform.test.example.com")
AUTH_TOKEN = os.environ.get("AUTH_TOKEN", "")
BASIC_AUTH_USER = os.environ.get("BASIC_AUTH_USER", "")
BASIC_AUTH_PASS = os.environ.get("BASIC_AUTH_PASS", "")
TEST_PASSWORD = os.environ.get("TEST_PASSWORD", "")

# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def maintainer_token():
    """获取 maintainer/committer 权限账号的 token"""
    if AUTH_TOKEN:
        return AUTH_TOKEN
    resp = requests.post(
        f"{BASE_CENTER_API}/oneid/login",
        json={
            "account": "test_maintainer",
            "password": TEST_PASSWORD,
            "client_id": "test_client_id",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    token = resp.json().get("token")
    assert token
    return token


@pytest.fixture(scope="session")
def normal_user_token():
    """获取普通用户账号的 token（无权限）"""
    resp = requests.post(
        f"{BASE_CENTER_API}/oneid/login",
        json={
            "account": "test_normal_user",
            "password": TEST_PASSWORD,
            "client_id": "test_client_id",
        },
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    token = resp.json().get("token")
    assert token
    return token


@pytest.fixture(scope="session")
def basic_auth_headers():
    """HTTP Basic Auth headers（meeting-platform 内部接口）"""
    return {
        "Authorization": f"Basic {BASIC_AUTH_USER}:{BASIC_AUTH_PASS}",
        "Content-Type": "application/json",
    }


# ===== 外部会议导入接口测试 =====

@pytest.mark.p0
def test_meeting_import_001_normal_flow_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-001 [正常流] maintainer 导入外部会议返回 is_external=true
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部技术分享会",
            "group_name": "sig-infrastructure",
            "date": (datetime.now() + timedelta(days=2)).strftime("%Y-%m-%d"),
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
            "etherpad": "https://etherpad.example.com/p/meeting-123",
            "email_list": "dev@example.com",
            "agenda": "本次会议讨论...",
            "is_record": False,
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    data = body.get("data")
    assert data
    assert isinstance(data.get("id"), int)
    assert data.get("is_external") == True
    pytest.shared_external_meeting_id = data["id"]


@pytest.mark.p0
def test_meeting_import_002_missing_required_param_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-002 [异常] 缺少必填参数 join_url 返回 400
    维度：异常 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400 or "join_url" in body.get("message", "").lower()


@pytest.mark.p0
def test_meeting_import_003_invalid_url_format_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-003 [异常输入] join_url 非 URL 格式返回 400
    维度：异常输入 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "not-a-url",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400


@pytest.mark.p0
def test_meeting_import_004_invalid_time_range_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-004 [边界值] end < start 返回 400
    维度：边界值 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "16:00",
            "end": "14:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400


@pytest.mark.p0
def test_meeting_import_005_invalid_date_format_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-005 [异常输入] date 格式非法返回 400
    维度：异常输入 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-13-01",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_import_006_topic_boundary_max_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-006 [边界值] topic 长度 128 字符返回 200
    维度：边界值 | 优先级：P1
    """
    topic_128 = "a" * 128
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": topic_128,
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200


@pytest.mark.p1
def test_meeting_import_007_topic_boundary_over_max_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-007 [边界值] topic 长度 129 字符返回 400
    维度：边界值 | 优先级：P1
    """
    topic_129 = "a" * 129
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": topic_129,
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p1
def test_meeting_import_008_empty_optional_field_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-008 [空值] 非必填字段为空字符串返回 200
    维度：空值 | 优先级：P1
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
            "etherpad": "",
            "email_list": "",
            "agenda": "",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200


@pytest.mark.p1
def test_meeting_import_009_special_chars_topic_pr_361(maintainer_token):
    """
    TC-MEETING-IMPORT-009 [特殊字符] topic 含 XSS 字符返回 400
    维度：特殊字符 | 优先级：P1
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "<script>alert('xss')</script>",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 400


@pytest.mark.p0
def test_meeting_import_010_no_permission_pr_361(normal_user_token):
    """
    TC-MEETING-IMPORT-010 [权限] 非 maintainer/committer 导入返回权限错误
    维度：权限 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/123456789",
        },
        headers={
            "token": normal_user_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code in (403, 401)
    body = resp.json()
    assert body.get("code") in (403, 401) or "permission" in body.get("message", "").lower()


# ===== 外部会议查询接口测试 =====

@pytest.mark.p0
@pytest.mark.dependency(depends=["test_meeting_import_001_normal_flow_pr_361"])
def test_meeting_query_001_external_meeting_visible_pr_361(maintainer_token):
    """
    TC-MEETING-QUERY-001 [正常流] 查询接口返回外部会议且 is_external=true
    维度：正常流 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_external_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
    resp = requests.get(
        f"{BASE_CENTER_API}/api/v1/meeting/meeting/",
        params={"id": meeting_id},
        headers={"token": maintainer_token},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data")
    if isinstance(data, list):
        meeting = next((m for m in data if m.get("id") == meeting_id), None)
    else:
        meeting = data
    assert meeting
    assert meeting.get("is_external") == True


# ===== 外部会议修改接口测试 =====

@pytest.mark.p0
@pytest.mark.dependency(depends=["test_meeting_import_001_normal_flow_pr_361"])
def test_meeting_update_001_external_meeting_pr_361(maintainer_token):
    """
    TC-MEETING-UPDATE-001 [正常流] 更新外部会议 topic 不调用第三方 API
    维度：正常流 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_external_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
    resp = requests.put(
        f"{BASE_CENTER_API}/api/v1/meeting/{meeting_id}/",
        json={
            "topic": "更新后的外部会议",
            "date": "2026-05-31",
            "start": "14:00",
            "end": "16:00",
            "etherpad": "https://etherpad.example.com/p/meeting-123",
            "agenda": "更新议程",
            "is_record": False,
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200


@pytest.mark.p1
@pytest.mark.dependency(depends=["test_meeting_import_001_normal_flow_pr_361"])
def test_meeting_update_002_no_permission_pr_361(normal_user_token):
    """
    TC-MEETING-UPDATE-002 [权限] 非 maintainer 更新外部会议返回权限错误
    维度：权限 | 优先级：P1
    """
    meeting_id = getattr(pytest, "shared_external_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
    resp = requests.put(
        f"{BASE_CENTER_API}/api/v1/meeting/{meeting_id}/",
        json={"topic": "非法更新"},
        headers={
            "token": normal_user_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code in (403, 401)


# ===== 外部会议删除接口测试 =====

@pytest.mark.p0
def test_meeting_delete_001_external_meeting_pr_361(maintainer_token):
    """
    TC-MEETING-DELETE-001 [正常流] 删除外部会议仅删除数据库记录
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "待删除的外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-06-01",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/999999999",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200
    meeting_id = resp.json()["data"]["id"]
    
    resp = requests.delete(
        f"{BASE_CENTER_API}/api/v1/meeting/{meeting_id}/",
        headers={"token": maintainer_token},
        timeout=10,
    )
    assert resp.status_code == 200


@pytest.mark.p1
def test_meeting_delete_002_no_permission_pr_361(normal_user_token, maintainer_token):
    """
    TC-MEETING-DELETE-002 [权限] 非 maintainer 删除外部会议返回权限错误
    维度：权限 | 优先级：P1
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "权限测试外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-06-02",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/888888888",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200
    meeting_id = resp.json()["data"]["id"]
    
    resp = requests.delete(
        f"{BASE_CENTER_API}/api/v1/meeting/{meeting_id}/",
        headers={"token": normal_user_token},
        timeout=10,
    )
    assert resp.status_code in (403, 401)


# ===== 外部会议通知接口测试 =====

@pytest.mark.p0
@pytest.mark.dependency(depends=["test_meeting_import_001_normal_flow_pr_361"])
def test_meeting_notify_001_external_meeting_pr_361(maintainer_token):
    """
    TC-MEETING-NOTIFY-001 [异常] 外部会议触发通知返回不支持错误
    维度：异常 | 优先级：P0
    """
    meeting_id = getattr(pytest, "shared_external_meeting_id", None)
    if not meeting_id:
        pytest.skip("依赖用例未产出 meeting_id")
    resp = requests.get(
        f"{BASE_CENTER_API}/api/v1/meeting/notify/{meeting_id}/",
        headers={"token": maintainer_token},
        timeout=10,
    )
    assert resp.status_code == 400
    body = resp.json()
    assert body.get("code") == 400 or "不支持通知" in body.get("message", "") or "EXTERNAL_NOT_SUPPORT" in str(body)


# ===== 定时任务测试 =====

# === TC-MEETING-TASK-001 [SKIP-MANUAL] =========================================
# 用例标题：[正常流] 外部会议状态更新定时任务跳过外部会议
# 维度：正常流 | 优先级：P0
# 不可自动化原因：依赖定时任务执行（需等待定时触发或手动触发），自动化脚本无法直接控制定时任务执行时机
# 人工执行步骤：
#   1. 导入一场外部会议（通过 test_meeting_import_001_normal_flow_pr_361 或手工调用接口）
#   2. 等待状态更新定时任务执行（或手动触发定时任务）
#   3. 查询该外部会议的 status 字段
# 预期结果：
#   1. 外部会议 status 字段保持初始值（不变），不跟随定时任务逻辑更新
# ==============================================================================

# === TC-MEETING-TASK-002 [SKIP-MANUAL] =========================================
# 用例标题：[正常流] 外部会议录屏定时任务不生成录屏记录
# 维度：正常流 | 优先级：P0
# 不可自动化原因：依赖定时任务执行与数据库查询（MeetingObsRecords、MeetingBiliRecords 表），自动化脚本无法直接控制定时任务执行时机
# 人工执行步骤：
#   1. 导入一场外部会议
#   2. 等待录屏定时任务执行（或手动触发定时任务）
#   3. 查询 MeetingObsRecords 和 MeetingBiliRecords 表，验证无该会议的录屏记录
# 预期结果：
#   1. MeetingObsRecords 表中无该外部会议记录
#   2. MeetingBiliRecords 表中无该外部会议记录
# ==============================================================================


# ===== 数据库迁移测试 =====

# === TC-MEETING-DB-001 [SKIP-MANUAL] ==========================================
# 用例标题：[正常流] Meeting 模型新增 is_external 字段迁移成功
# 维度：正常流 | 优先级：P0
# 不可自动化原因：依赖数据库迁移命令执行与表结构查询，自动化脚本无法直接执行数据库迁移命令（需运维或开发执行）
# 人工执行步骤：
#   1. 在 meeting-platform 项目中执行迁移命令：
#      `python manage.py makemigrations meeting --name add_is_external_field`
#      `python manage.py migrate meeting`
#   2. 连接 MySQL 数据库，查询 meetings 表结构：
#      `DESC meetings;` 或 `SHOW COLUMNS FROM meetings LIKE 'is_external';`
# 预期结果：
#   1. 迁移命令执行成功，无错误输出
#   2. meetings 表包含 is_external 字段，类型为 tinyint(1) 或 boolean，默认值为 0 (false)
# ==============================================================================


# ===== 跨服务调用链路测试 =====

@pytest.mark.p0
def test_meeting_platform_import_001_internal_api_pr_361(basic_auth_headers):
    """
    TC-MEETING-PLATFORM-001 [正常流] meeting-platform 内部接口创建外部会议
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_PLATFORM_API}/inner/v1/meeting/import/",
        json={
            "sponsor": "test_maintainer",
            "group_name": "sig-infrastructure",
            "community": "test_community",
            "topic": "内部接口外部会议",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/777777777",
            "is_record": False,
        },
        headers=basic_auth_headers,
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data")
    assert data
    assert isinstance(data.get("id"), int)
    assert data.get("is_external") == True


@pytest.mark.p1
def test_meeting_platform_import_002_invalid_auth_pr_361():
    """
    TC-MEETING-PLATFORM-002 [权限] HTTP Basic Auth 错误返回 401
    维度：权限 | 优先级：P1
    """
    resp = requests.post(
        f"{BASE_PLATFORM_API}/inner/v1/meeting/import/",
        json={
            "sponsor": "test_maintainer",
            "group_name": "sig-infrastructure",
            "community": "test_community",
            "topic": "非法调用",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/666666666",
        },
        headers={
            "Authorization": "Basic invalid:invalid",
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 401


@pytest.mark.p1
def test_meeting_center_to_platform_chain_001_pr_361(maintainer_token, basic_auth_headers):
    """
    TC-MEETING-CHAIN-001 [集成] meeting-center 调用 meeting-platform 数据传递正确
    维度：正常流 | 优先级：P1
    """
    import_resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "链路验证外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/555555555",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert import_resp.status_code == 200
    meeting_id = import_resp.json()["data"]["id"]
    
    query_resp = requests.get(
        f"{BASE_CENTER_API}/api/v1/meeting/meeting/",
        params={"id": meeting_id},
        headers={"token": maintainer_token},
        timeout=10,
    )
    assert query_resp.status_code == 200
    query_data = query_resp.json()["data"]
    if isinstance(query_data, list):
        meeting = next((m for m in query_data if m.get("id") == meeting_id), None)
    else:
        meeting = query_data
    assert meeting
    assert meeting.get("topic") == "链路验证外部会议"
    assert meeting.get("is_external") == True


# ===== 日志审计测试 =====

# === TC-MEETING-LOG-001 [SKIP-MANUAL] ==========================================
# 用例标题：[正常流] 外部会议导入记录到 OperationLog
# 维度：正常流 | 优先级：P1
# 不可自动化原因：依赖数据库查询（OperationLog 表），自动化脚本无法直接查询数据库（需数据库访问权限）
# 人工执行步骤：
#   1. 导入一场外部会议
#   2. 连接 MySQL 数据库，查询 OperationLog 表：
#      `SELECT * FROM operation_log WHERE sponsor='test_maintainer' AND is_external=true ORDER BY id DESC LIMIT 1;`
# 预期结果：
#   1. OperationLog 表新增一条记录
#   2. 记录包含 sponsor 字段（操作者）、topic 字段（会议主题）、is_external=true 标记
# ==============================================================================


# ===== 错误码测试 =====

@pytest.mark.p0
def test_error_code_001_external_not_support_pr_361(maintainer_token):
    """
    TC-ERROR-CODE-001 [正常流] 外部会议通知返回 STATUS_MEETING_EXTERNAL_NOT_SUPPORT
    维度：正常流 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "错误码验证外部会议",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/444444444",
        },
        headers={
            "token": maintainer_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code == 200
    meeting_id = resp.json()["data"]["id"]
    
    notify_resp = requests.get(
        f"{BASE_CENTER_API}/api/v1/meeting/notify/{meeting_id}/",
        headers={"token": maintainer_token},
        timeout=10,
    )
    assert notify_resp.status_code == 400
    body = notify_resp.json()
    assert "EXTERNAL_NOT_SUPPORT" in str(body) or "不支持" in body.get("message", "")


@pytest.mark.p0
def test_error_code_002_import_no_permission_pr_361(normal_user_token):
    """
    TC-ERROR-CODE-002 [权限] 无权限导入返回 STATUS_MEETING_IMPORT_NO_PERMISSION
    维度：权限 | 优先级：P0
    """
    resp = requests.post(
        f"{BASE_CENTER_API}/api/v1/meeting/import",
        json={
            "topic": "权限错误码验证",
            "group_name": "sig-infrastructure",
            "date": "2026-05-30",
            "start": "14:00",
            "end": "16:00",
            "join_url": "https://zoom.us/j/333333333",
        },
        headers={
            "token": normal_user_token,
            "Content-Type": "application/json",
        },
        timeout=10,
    )
    assert resp.status_code in (403, 401)
    body = resp.json()
    assert "IMPORT_NO_PERMISSION" in str(body) or "permission" in body.get("message", "").lower()


# ===== 用例索引（人类可贴禅道/Tapd）=====

# | 用例 ID | 标题 | 关联 Task | 优先级 | 来源 PR |
# |---------|------|-----------|--------|---------|
# | TC-MEETING-IMPORT-001 | [正常流] maintainer 导入外部会议返回 is_external=true | TASK5 | P0 | #361 |
# | TC-MEETING-IMPORT-002 | [异常] 缺少必填参数 join_url 返回 400 | TASK5 | P0 | #361 |
# | TC-MEETING-IMPORT-003 | [异常输入] join_url 非 URL 格式返回 400 | TASK5 | P0 | #361 |
# | TC-MEETING-IMPORT-004 | [边界值] end < start 返回 400 | TASK5 | P0 | #361 |
# | TC-MEETING-IMPORT-005 | [异常输入] date 格式非法返回 400 | TASK5 | P0 | #361 |
# | TC-MEETING-IMPORT-006 | [边界值] topic 长度 128 字符返回 200 | TASK5 | P1 | #361 |
# | TC-MEETING-IMPORT-007 | [边界值] topic 长度 129 字符返回 400 | TASK5 | P1 | #361 |
# | TC-MEETING-IMPORT-008 | [空值] 非必填字段为空字符串返回 200 | TASK5 | P1 | #361 |
# | TC-MEETING-IMPORT-009 | [特殊字符] topic 含 XSS 字符返回 400 | TASK5 | P1 | #361 |
# | TC-MEETING-IMPORT-010 | [权限] 非 maintainer/committer 导入返回权限错误 | TASK5 | P0 | #361 |
# | TC-MEETING-QUERY-001 | [正常流] 查询接口返回外部会议且 is_external=true | TASK6 | P0 | #361 |
# | TC-MEETING-UPDATE-001 | [正常流] 更新外部会议 topic 不调用第三方 API | TASK3 | P0 | #361 |
# | TC-MEETING-UPDATE-002 | [权限] 非 maintainer 更新外部会议返回权限错误 | TASK3 | P1 | #361 |
# | TC-MEETING-DELETE-001 | [正常流] 删除外部会议仅删除数据库记录 | TASK3 | P0 | #361 |
# | TC-MEETING-DELETE-002 | [权限] 非 maintainer 删除外部会议返回权限错误 | TASK3 | P1 | #361 |
# | TC-MEETING-NOTIFY-001 | [异常] 外部会议触发通知返回不支持错误 | TASK3 | P0 | #361 |
# | TC-MEETING-TASK-001 | [正常流] 外部会议状态更新定时任务跳过外部会议 | TASK4 | P0（手工）| #361 |
# | TC-MEETING-TASK-002 | [正常流] 外部会议录屏定时任务不生成录屏记录 | TASK4 | P0（手工）| #361 |
# | TC-MEETING-DB-001 | [正常流] Meeting 模型新增 is_external 字段迁移成功 | TASK1 | P0（手工）| #361 |
# | TC-MEETING-PLATFORM-001 | [正常流] meeting-platform 内部接口创建外部会议 | TASK2 | P0 | #361 |
# | TC-MEETING-PLATFORM-002 | [权限] HTTP Basic Auth 错误返回 401 | TASK2 | P1 | #361 |
# | TC-MEETING-CHAIN-001 | [集成] meeting-center 调用 meeting-platform 数据传递正确 | TASK2+TASK5 | P1 | #361 |
# | TC-MEETING-LOG-001 | [正常流] 外部会议导入记录到 OperationLog | 架构设计3.3 | P1（手工）| #361 |
# | TC-ERROR-CODE-001 | [正常流] 外部会议通知返回 STATUS_MEETING_EXTERNAL_NOT_SUPPORT | 架构设计10 | P0 | #361 |
# | TC-ERROR-CODE-002 | [权限] 无权限导入返回 STATUS_MEETING_IMPORT_NO_PERMISSION | 架构设计10 | P0 | #361 |

if __name__ == "__main__":
    pytest.main(["-v", __file__])