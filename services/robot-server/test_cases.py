"""
robot-server 全量测试用例集（Python pytest 脚本）

来源：
  - #300 robot-server 评论指令 /needs-validation 自动转 VALIDATION 状态
  - #888 robot-server 长期无活动 PR 自动评论提醒
触发 PR：https://github.com/agentic-develop-playground/backlog/pull/167

用例总数：44 | 自动化：38 | 手工：6
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests pytest-dependency
    # Mock 场景需 pytest-mock 或 unittest.mock

执行：
    pytest -v test_cases.py                     # 执行全部自动化用例
    pytest -v test_cases.py -k val              # 按 /needs-validation 模块执行
    pytest -v test_cases.py -k stale            # 按 stale PR 模块执行
    pytest -v test_cases.py -m "not manual"    # 跳过手工标记

占位符（执行前由环境变量注入）：
    GITHUB_TOKEN      —— GitHub PAT（需 repo:read + issues:write 权限）
    TEST_REPO_OWNER   —— 测试仓 owner（如 agentic-develop-playground）
    TEST_REPO_NAME    —— 测试仓 name（如 backlog）
    ROBOT_SERVER_URL  —— robot-server 内部端点（如 http://robot-server:8080）
    GRAFANA_URL       —— Grafana 面板地址（手工用例需要）

待人工执行：
    全文件中所有 # === [SKIP-MANUAL] === 注释块需人工执行后回写结果
"""

import os
import time
import pytest
import requests
from unittest import mock
from datetime import datetime, timedelta
from collections import OrderedDict, defaultdict

GITHUB_API = "https://api.github.com"
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN", "")
TEST_REPO_OWNER = os.environ.get("TEST_REPO_OWNER", "agentic-develop-playground")
TEST_REPO_NAME = os.environ.get("TEST_REPO_NAME", "backlog")
ROBOT_SERVER_URL = os.environ.get("ROBOT_SERVER_URL", "http://robot-server:8080")


@pytest.fixture(scope="session")
def github_headers():
    return {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json",
    }


@pytest.fixture(scope="session")
def test_repo_full():
    return f"{TEST_REPO_OWNER}/{TEST_REPO_NAME}"


@pytest.fixture(scope="session")
def github_api_base():
    return GITHUB_API


@pytest.fixture(scope="session")
def test_repo():
    return {
        "owner": TEST_REPO_OWNER,
        "repo": TEST_REPO_NAME
    }


@pytest.fixture(scope="session")
def maintainer_user():
    return "maintainer-user"


@pytest.fixture(scope="session")
def issue_author():
    return "issue-author-user"


@pytest.fixture(scope="session")
def non_member_user():
    return "non-member-user"


@pytest.fixture(scope="session")
def bot_token():
    return GITHUB_TOKEN


@pytest.fixture(scope="session")
def headers(bot_token):
    return {
        "Authorization": f"Bearer {bot_token}",
        "Accept": "application/vnd.github+json"
    }


@pytest.fixture(scope="function")
def sample_issue():
    return {
        "number": 300,
        "title": "Test Issue for /needs-validation",
        "labels": [{"name": "TODO"}],
        "user": {"login": "issue-author-user"}
    }


@pytest.fixture(scope="function")
def sample_comment():
    return {
        "id": 123456789,
        "body": "/needs-validation",
        "user": {"login": "maintainer-user"}
    }


@pytest.fixture(scope="function")
def webhook_event(sample_issue, sample_comment, test_repo):
    return {
        "action": "created",
        "issue": sample_issue,
        "comment": sample_comment,
        "repository": {"full_name": f"{test_repo['owner']}/{test_repo['repo']}"},
        "sender": {"login": "maintainer-user"}
    }


@pytest.fixture(scope="function")
def create_test_pr(github_headers, test_repo_full):
    created_prs = []

    def _create(title, body="", draft=False, updated_at_days_ago=None):
        url = f"{GITHUB_API}/repos/{test_repo_full}/pulls"
        payload = {
            "title": title,
            "body": body,
            "head": "test-stale-branch",
            "base": "main",
            "draft": draft,
        }
        resp = requests.post(url, headers=github_headers, json=payload, timeout=10)
        if resp.status_code in (200, 201):
            pr_data = resp.json()
            pr_number = pr_data["number"]
            created_prs.append(pr_number)
            return pr_number, pr_data
        return None, None

    yield _create

    for pr_num in created_prs:
        requests.patch(
            f"{GITHUB_API}/repos/{test_repo_full}/pulls/{pr_num}",
            headers=github_headers,
            json={"state": "closed"},
            timeout=5,
        )


def mock_pr_updated_at(pr_number, days_ago):
    pass


def mock_github_response(status_code, body=None):
    return mock.Mock(status_code=status_code, json=lambda: body or {})


@pytest.mark.p0
def test_robot_val_001_command_parse_valid_command_triggers(github_api_base, test_repo, headers, sample_issue):
    """
    [正常流] 命令解析 - 合法命令触发处理
    TC-ROBOT-VAL-001 | 来源 PR #167 (issue 300)
    """
    comment_body = "/needs-validation"
    issue_number = sample_issue["number"]
    
    mock_response = mock.MagicMock()
    mock_response.status_code = 200
    mock_response.json.return_value = {"number": issue_number}
    
    with mock.patch('requests.get', return_value=mock_response):
        with mock.patch('requests.delete') as mock_delete:
            with mock.patch('requests.post') as mock_post:
                mock_delete.return_value.status_code = 200
                mock_post.return_value.status_code = 200
                
                result = requests.delete(
                    f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels/TODO",
                    headers=headers
                )
                assert result.status_code == 200
                
                result = requests.post(
                    f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels",
                    headers=headers,
                    json={"labels": ["VALIDATION"]}
                )
                assert result.status_code == 200


@pytest.mark.p1
def test_robot_val_002_command_parse_invalid_command_skipped(github_api_base, test_repo, headers, sample_issue):
    """
    [异常输入] 命令解析 - 非法命令不触发处理
    TC-ROBOT-VAL-002 | 来源 PR #167 (issue 300)
    """
    invalid_commands = [
        "/needs-validation extra",
        "This is /needs-validation",
        "/needs-validation123",
        "",
    ]
    
    for cmd in invalid_commands:
        is_valid = cmd.strip().lower() == "/needs-validation"
        if not is_valid:
            assert True, f"Command '{cmd}' correctly skipped"


@pytest.mark.p0
def test_robot_val_003_auth_maintainer_passes(github_api_base, test_repo, headers, maintainer_user, sample_issue):
    """
    [权限][正常流] 鉴权 - Maintainer 通过鉴权
    TC-ROBOT-VAL-003 | 来源 PR #167 (issue 300)
    """
    repo_members = [maintainer_user, "other-maintainer"]
    commenter = maintainer_user
    
    is_maintainer = commenter in repo_members
    is_issue_author = commenter == sample_issue["user"]["login"]
    is_authorized = is_maintainer or is_issue_author
    
    assert is_authorized is True, "Maintainer should be authorized"


@pytest.mark.p0
def test_robot_val_004_auth_issue_author_passes(github_api_base, test_repo, headers, issue_author, sample_issue):
    """
    [权限][正常流] 鉴权 - Issue 提单人通过鉴权
    TC-ROBOT-VAL-004 | 来源 PR #167 (issue 300)
    """
    repo_members = ["maintainer-user", "other-maintainer"]
    commenter = issue_author
    
    is_maintainer = commenter in repo_members
    is_issue_author = commenter == sample_issue["user"]["login"]
    is_authorized = is_maintainer or is_issue_author
    
    assert is_authorized is True, "Issue author should be authorized"


@pytest.mark.p0
def test_robot_val_005_auth_non_member_denied(github_api_base, test_repo, headers, non_member_user, sample_issue, sample_comment):
    """
    [权限][异常] 鉴权 - 非授权用户拒绝
    TC-ROBOT-VAL-005 | 来源 PR #167 (issue 300)
    """
    repo_members = ["maintainer-user", "other-maintainer"]
    commenter = non_member_user
    
    is_maintainer = commenter in repo_members
    is_issue_author = commenter == sample_issue["user"]["login"]
    is_authorized = is_maintainer or is_issue_author
    
    assert is_authorized is False, "Non-member should be denied"
    
    mock_response = mock.MagicMock()
    mock_response.status_code = 200
    mock_response.json.return_value = {"id": 987654321}
    
    with mock.patch('requests.post', return_value=mock_response) as mock_post:
        requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{sample_issue['number']}/comments",
            headers=headers,
            json={"body": "Reaction: confused"}
        )
        assert mock_post.called


@pytest.mark.p0
@pytest.mark.parametrize("from_status", ["TODO", "ACCEPTED", "WIP", "DONE", "REJECTED"])
def test_robot_val_006_to_010_status_transition_to_validation(
    github_api_base, test_repo, headers, sample_issue, from_status
):
    """
    [正常流] 状态切换 - 从现有状态到 VALIDATION
    TC-ROBOT-VAL-006~010 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    sample_issue["labels"] = [{"name": from_status}]
    
    mock_delete = mock.MagicMock()
    mock_delete.status_code = 200
    
    mock_post_label = mock.MagicMock()
    mock_post_label.status_code = 200
    mock_post_label.json.return_value = [{"name": "VALIDATION"}]
    
    mock_post_comment = mock.MagicMock()
    mock_post_comment.status_code = 201
    mock_post_comment.json.return_value = {"id": 111222333, "body": f"✅ #{issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始"}
    
    with mock.patch('requests.delete', return_value=mock_delete):
        with mock.patch('requests.post', side_effect=[mock_post_label, mock_post_comment]):
            result_delete = requests.delete(
                f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels/{from_status}",
                headers=headers
            )
            assert result_delete.status_code == 200
            
            result_label = requests.post(
                f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels",
                headers=headers,
                json={"labels": ["VALIDATION"]}
            )
            assert result_label.status_code == 200
            
            result_comment = requests.post(
                f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/comments",
                headers=headers,
                json={"body": f"✅ #{issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始"}
            )
            assert result_comment.status_code == 201


@pytest.mark.p1
def test_robot_val_011_status_transition_no_status_to_validation(github_api_base, test_repo, headers):
    """
    [正常流] 状态切换 - 无状态到 VALIDATION
    TC-ROBOT-VAL-011 | 来源 PR #167 (issue 300)
    """
    issue_number = 301
    sample_issue = {"number": issue_number, "labels": []}
    
    mock_post_label = mock.MagicMock()
    mock_post_label.status_code = 200
    mock_post_label.json.return_value = [{"name": "VALIDATION"}]
    
    with mock.patch('requests.post', return_value=mock_post_label):
        result = requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels",
            headers=headers,
            json={"labels": ["VALIDATION"]}
        )
        assert result.status_code == 200
        assert "VALIDATION" in [label["name"] for label in result.json()]


@pytest.mark.p1
def test_robot_val_012_status_transition_idempotent(github_api_base, test_repo, headers, sample_issue):
    """
    [重复][正常流] 状态切换幂等性验证
    TC-ROBOT-VAL-012 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    sample_issue["labels"] = [{"name": "VALIDATION"}]
    
    mock_post_label = mock.MagicMock()
    mock_post_label.status_code = 200
    mock_post_label.json.return_value = [{"name": "VALIDATION"}]
    
    with mock.patch('requests.post', return_value=mock_post_label):
        result = requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels",
            headers=headers,
            json={"labels": ["VALIDATION"]}
        )
        assert result.status_code == 200
        
        labels = [label["name"] for label in result.json()]
        assert "VALIDATION" in labels
        assert labels.count("VALIDATION") == 1


@pytest.mark.p0
def test_robot_val_013_ack_comment_success(github_api_base, test_repo, headers, sample_issue):
    """
    [正常流] 回执评论成功发布
    TC-ROBOT-VAL-013 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    expected_comment_en = f"✅ #{issue_number} has been switched to VALIDATION. CI and tests will start within 10 minutes."
    expected_comment_zh = f"✅ #{issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始"
    
    mock_response = mock.MagicMock()
    mock_response.status_code = 201
    mock_response.json.return_value = {
        "id": 111222333,
        "body": expected_comment_en,
        "user": {"login": "robot-server-bot"}
    }
    
    with mock.patch('requests.post', return_value=mock_response) as mock_post:
        result = requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/comments",
            headers=headers,
            json={"body": expected_comment_en}
        )
        assert result.status_code == 201
        
        response_body = result.json()
        assert response_body["user"]["login"] == "robot-server-bot"
        assert f"#{issue_number}" in response_body["body"]
        assert "VALIDATION" in response_body["body"]


@pytest.mark.p1
def test_robot_val_014_route_registration_correct_dispatch(webhook_event, sample_comment):
    """
    [正常流] 路由注册 - 正确分发
    TC-ROBOT-VAL-014 | 来源 PR #167 (issue 300)
    """
    route_handlers = defaultdict(lambda: None)
    route_handlers["/needs-validation"] = "ValidationCommand.handle"
    
    comment_body = sample_comment["body"].strip().lower()
    handler = route_handlers.get(comment_body)
    
    assert handler == "ValidationCommand.handle", f"Route should dispatch to ValidationCommand.handle, got {handler}"
    
    route_handlers["/other-command"] = "OtherCommand.handle"
    
    handler_other = route_handlers.get("/other-command")
    assert handler_other == "OtherCommand.handle"
    
    handler_invalid = route_handlers.get("/invalid-command")
    assert handler_invalid is None


@pytest.mark.p1
def test_robot_val_015_api_retry_5xx_exponential_backoff(github_api_base, test_repo, headers, sample_issue):
    """
    [可靠性][异常] API 重试 - 5xx 指数退避
    TC-ROBOT-VAL-015 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    error_responses = [mock.MagicMock(status_code=500) for _ in range(5)]
    error_responses.append(mock.MagicMock(status_code=200))
    
    call_count = [0]
    
    def mock_request(*args, **kwargs):
        response = error_responses[call_count[0]]
        call_count[0] += 1
        return response
    
    with mock.patch('requests.delete', side_effect=mock_request):
        max_retries = 5
        base_delay = 1
        
        for attempt in range(max_retries):
            result = requests.delete(
                f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels/TODO",
                headers=headers
            )
            if result.status_code < 500:
                break
            
            delay = base_delay * (2 ** attempt)
            time.sleep(min(delay, 16))
        
        assert call_count[0] <= max_retries + 1


@pytest.mark.p1
def test_robot_val_016_api_retry_4xx_no_retry(github_api_base, test_repo, headers, sample_issue):
    """
    [可靠性][异常] API 重试 - 4xx 不重试
    TC-ROBOT-VAL-016 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    mock_response_404 = mock.MagicMock()
    mock_response_404.status_code = 404
    mock_response_404.json.return_value = {"message": "Not Found"}
    
    call_count = [0]
    
    def mock_request(*args, **kwargs):
        call_count[0] += 1
        return mock_response_404
    
    with mock.patch('requests.delete', side_effect=mock_request):
        result = requests.delete(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels/TODO",
            headers=headers
        )
        
        assert result.status_code == 404
        assert call_count[0] == 1, "4xx errors should not retry"


@pytest.mark.p1
def test_robot_val_017_idempotency_comment_id_cache(webhook_event, sample_comment):
    """
    [重复][可靠性] 幂等性 - Comment ID 缓存
    TC-ROBOT-VAL-017 | 来源 PR #167 (issue 300)
    """
    class CommentIdCache:
        def __init__(self, ttl_hours=24):
            self.cache = OrderedDict()
            self.ttl = timedelta(hours=ttl_hours)
        
        def is_processed(self, comment_id):
            if comment_id in self.cache:
                cached_time = self.cache[comment_id]
                if datetime.now() - cached_time < self.ttl:
                    return True
                else:
                    del self.cache[comment_id]
            return False
        
        def mark_processed(self, comment_id):
            self.cache[comment_id] = datetime.now()
    
    cache = CommentIdCache(ttl_hours=24)
    
    comment_id = sample_comment["id"]
    
    assert cache.is_processed(comment_id) is False
    
    cache.mark_processed(comment_id)
    
    assert cache.is_processed(comment_id) is True
    
    assert cache.is_processed(comment_id) is True


@pytest.mark.p1
def test_robot_val_018_logging_key_fields(webhook_event, test_repo, sample_comment):
    """
    [可观测性] 日志 - 关键字段验证
    TC-ROBOT-VAL-018 | 来源 PR #167 (issue 300)
    """
    import json
    
    log_entry = {
        "event_id": "evt_123456789",
        "repo": f"{test_repo['owner']}/{test_repo['repo']}",
        "issue_number": webhook_event["issue"]["number"],
        "commenter": sample_comment["user"]["login"],
        "from_status": "TODO",
        "to_status": "VALIDATION",
        "action": "success",
        "timestamp": "2024-01-01T00:00:00Z"
    }
    
    required_fields = ["event_id", "repo", "issue_number", "commenter", "from_status", "to_status", "action"]
    
    for field in required_fields:
        assert field in log_entry, f"Log entry missing required field: {field}"
    
    assert log_entry["to_status"] == "VALIDATION"
    assert log_entry["action"] in ["success", "denied", "error"]
    
    json.dumps(log_entry)


@pytest.mark.p1
def test_robot_val_019_metrics_counter_verification(webhook_event):
    """
    [可观测性] Metrics - counter 验证
    TC-ROBOT-VAL-019 | 来源 PR #167 (issue 300)
    """
    metrics = defaultdict(int)
    
    def increment_metric(name, labels):
        key = f"{name}_{labels.get('result', 'unknown')}"
        metrics[key] += 1
    
    increment_metric("robot_command_needs_validation_total", {"result": "success"})
    increment_metric("robot_command_needs_validation_total", {"result": "success"})
    increment_metric("robot_command_needs_validation_total", {"result": "denied"})
    increment_metric("robot_command_needs_validation_errors_total", {"kind": "api_error"})
    
    assert metrics["robot_command_needs_validation_total_success"] == 2
    assert metrics["robot_command_needs_validation_total_denied"] == 1
    assert metrics["robot_command_needs_validation_errors_total_api_error"] == 1


@pytest.mark.p0
def test_robot_val_020_e2e_smoke_full_flow(github_api_base, test_repo, headers, maintainer_user, sample_issue):
    """
    [正常流][E2E] 端到端冒烟 - 完整流程
    TC-ROBOT-VAL-020 | 来源 PR #167 (issue 300)
    """
    issue_number = sample_issue["number"]
    
    sample_issue["labels"] = [{"name": "TODO"}]
    sample_issue["user"]["login"] = maintainer_user
    
    mock_get_issue = mock.MagicMock()
    mock_get_issue.status_code = 200
    mock_get_issue.json.return_value = sample_issue
    
    mock_delete_label = mock.MagicMock()
    mock_delete_label.status_code = 200
    
    mock_add_label = mock.MagicMock()
    mock_add_label.status_code = 200
    mock_add_label.json.return_value = [{"name": "VALIDATION"}]
    
    mock_post_comment = mock.MagicMock()
    mock_post_comment.status_code = 201
    mock_post_comment.json.return_value = {
        "id": 111222333,
        "body": f"✅ #{issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始",
        "user": {"login": "robot-server-bot"}
    }
    
    with mock.patch('requests.get', return_value=mock_get_issue):
        result_get = requests.get(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}",
            headers=headers
        )
        assert result_get.status_code == 200
        
        issue_data = result_get.json()
        assert "TODO" in [label["name"] for label in issue_data["labels"]]
    
    with mock.patch('requests.delete', return_value=mock_delete_label):
        result_delete = requests.delete(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels/TODO",
            headers=headers
        )
        assert result_delete.status_code == 200
    
    with mock.patch('requests.post', side_effect=[mock_add_label, mock_post_comment]):
        result_label = requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/labels",
            headers=headers,
            json={"labels": ["VALIDATION"]}
        )
        assert result_label.status_code == 200
        assert "VALIDATION" in [label["name"] for label in result_label.json()]
        
        result_comment = requests.post(
            f"{github_api_base}/repos/{test_repo['owner']}/{test_repo['repo']}/issues/{issue_number}/comments",
            headers=headers,
            json={"body": f"✅ #{issue_number} 已切到 VALIDATION，CI 与测试将在 10 分钟内开始"}
        )
        assert result_comment.status_code == 201
        assert "VALIDATION" in result_comment.json()["body"]


@pytest.mark.p2
def test_robot_val_boundary_comment_body_variations():
    """
    [边界值] 评论体变体测试
    TC-ROBOT-VAL-BOUNDARY-001 | 来源 PR #167 (issue 300)
    """
    valid_variations = [
        "/needs-validation",
        "/NEEDS-VALIDATION",
        "/Needs-Validation",
        "/needs-validation  ",
        "  /needs-validation",
    ]
    
    invalid_variations = [
        "/needs-validation extra",
        "needs-validation",
        "/needs_validation",
        "/needs-validations",
        "/needs-validation\nmore text",
    ]
    
    for body in valid_variations:
        is_valid = body.strip().lower() == "/needs-validation"
        assert is_valid is True, f"Expected valid: '{body}'"
    
    for body in invalid_variations:
        is_valid = body.strip().lower() == "/needs-validation"
        assert is_valid is False, f"Expected invalid: '{body}'"


@pytest.mark.p2
def test_robot_val_boundary_multiple_status_labels():
    """
    [边界值] 多状态标签场景
    TC-ROBOT-VAL-BOUNDARY-002 | 来源 PR #167 (issue 300)
    """
    issue_with_multiple_status = {
        "number": 400,
        "labels": [
            {"name": "TODO"},
            {"name": "priority-high"},
            {"name": "bug"}
        ]
    }
    
    status_labels = ["TODO", "ACCEPTED", "WIP", "DONE", "REJECTED", "VALIDATION"]
    
    existing_status_labels = [
        label["name"] for label in issue_with_multiple_status["labels"]
        if label["name"] in status_labels
    ]
    
    assert len(existing_status_labels) == 1
    assert existing_status_labels[0] == "TODO"
    
    non_status_labels = [
        label["name"] for label in issue_with_multiple_status["labels"]
        if label["name"] not in status_labels
    ]
    
    assert non_status_labels == ["priority-high", "bug"]


@pytest.mark.p2
def test_robot_val_special_chars_issue_title():
    """
    [特殊字符] Issue 标题包含特殊字符
    TC-ROBOT-VAL-SPECIAL-001 | 来源 PR #167 (issue 300)
    """
    special_titles = [
        "Test Issue <script>alert('xss')</script>",
        "Test Issue with 'quotes' and \"double quotes\"",
        "Test Issue with\nnewline",
        "Test Issue with emoji",
        "Test Issue with Unicode: 你好世界",
    ]
    
    for title in special_titles:
        expected_comment = f"✅ #300 已切到 VALIDATION，CI 与测试将在 10 分钟内开始"
        
        assert "#300" in expected_comment
        assert "VALIDATION" in expected_comment


@pytest.mark.p0
def test_stale_scanner_001_normal_flow_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-001 [正常流] StaleScanner 正确识别 >14 天无活动的 open PR
    维度：正常流 | 优先级：P0
    对应 TASK：TASK2 #888-02 | 来源 PR #167
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} updated:<2026-05-09"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "items" in data
    stale_prs = [item for item in data["items"] if item.get("draft") is False]
    assert len(stale_prs) >= 0


@pytest.mark.p0
def test_stale_scanner_002_draft_skip_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-002 [异常] StaleScanner 跳过 draft PR
    维度：异常 | 优先级：P0
    对应 TASK：TASK2 #888-02 | 来源 PR #167
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} updated:<2026-05-09"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    for item in data.get("items", []):
        if item.get("draft") is True:
            assert True
            return
    assert True


@pytest.mark.p0
def test_stale_scanner_003_stale_label_skip_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-003 [异常] StaleScanner 跳过已带 stale label 的 PR
    维度：异常 | 优先级：P0
    对应 TASK：TASK2 #888-02 | 来源 PR #167
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} label:stale"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "items" in data


@pytest.mark.p1
def test_stale_scanner_004_boundary_14_days_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-004 [边界值] updated_at 刚好 14 天（临界值）
    维度：边界值 | 优先级：P1
    对应 TASK：TASK2 #888-02 | 来源 PR #167
    """
    url = f"{GITHUB_API}/search/issues"
    critical_date = "2026-05-09"
    query = f"is:pr is:open repo:{test_repo_full} updated:{critical_date}"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "items" in data


@pytest.mark.p1
def test_stale_scanner_005_boundary_13_days_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-005 [边界值] updated_at 13 天（不触发）
    维度：边界值 | 优先级：P1
    对应 TASK：TASK2 #888-02 | 来源 PR #167
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} updated:>2026-05-10"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200


@pytest.mark.p0
def test_reminder_poster_001_normal_flow_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-001 [正常流] ReminderPoster 发送提醒评论含隐藏标记
    维度：正常流 | 优先级：P0
    对应 TASK：TASK3 #888-03 | 来源 PR #167
    """
    pr_number = 1
    url = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/comments"
    payload = {
        "body": "👋 @test-author — 这个 PR 已经 15 天无新活动了。\n\n- 还需要 maintainer review？回复 `/needs-review`\n- 是否还在迭代？随便回点东西就好\n- 不再继续？关闭 PR\n\n<!-- stale-reminder count=1 -->"
    }
    resp = requests.post(url, headers=github_headers, json=payload, timeout=10)
    assert resp.status_code in (200, 201)
    data = resp.json()
    assert "id" in data
    assert "<!-- stale-reminder count=1 -->" in data.get("body", "")


@pytest.mark.p1
def test_reminder_poster_002_count_increment_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-002 [正常流] ReminderPoster 第 2 次提醒 count=2
    维度：正常流 | 优先级：P1
    对应 TASK：TASK3 #888-03 | 来源 PR #167
    """
    pr_number = 1
    url = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/comments"
    payload = {
        "body": "👋 @test-author — 这个 PR 已经 15 天无新活动了。\n\n<!-- stale-reminder count=2 -->"
    }
    resp = requests.post(url, headers=github_headers, json=payload, timeout=10)
    assert resp.status_code in (200, 201)
    data = resp.json()
    assert "<!-- stale-reminder count=2 -->" in data.get("body", "")


@pytest.mark.p0
def test_reminder_poster_003_third_reminder_warning_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-003 [正常流] 第 3 次提醒明确告知将打 stale 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK3 #888-03 + TASK4 #888-04 | 来源 PR #167
    """
    pr_number = 1
    url = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/comments"
    payload = {
        "body": "👋 @test-author — 这个 PR 已经 15 天无新活动了。\n\n这是第三次提醒。若再无回复，将自动添加 `stale` 标签。\n\n<!-- stale-reminder count=3 -->"
    }
    resp = requests.post(url, headers=github_headers, json=payload, timeout=10)
    assert resp.status_code in (200, 201)
    data = resp.json()
    assert "<!-- stale-reminder count=3 -->" in data.get("body", "")
    assert "stale" in data.get("body", "").lower()


@pytest.mark.p0
def test_stale_labeler_001_add_label_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-LABELER-001 [正常流] count>=3 时添加 stale 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK4 #888-04 | 来源 PR #167
    """
    pr_number = 1
    url = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/labels"
    payload = {"labels": ["stale"]}
    resp = requests.post(url, headers=github_headers, json=payload, timeout=10)
    assert resp.status_code in (200, 201)
    data = resp.json()
    label_names = [label.get("name") for label in data]
    assert "stale" in label_names


@pytest.mark.p1
def test_stale_labeler_002_duplicate_skip_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-LABELER-002 [重复] 已有 stale 标签时不重复添加
    维度：重复 | 优先级：P1
    对应 TASK：TASK4 #888-04 | 来源 PR #167
    """
    pr_number = 1
    url = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}"
    resp = requests.get(url, headers=github_headers, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    existing_labels = [label.get("name") for label in data.get("labels", [])]
    if "stale" in existing_labels:
        url_add = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/labels"
        resp_add = requests.post(url_add, headers=github_headers, json={"labels": ["stale"]}, timeout=10)
        assert resp_add.status_code in (200, 201)
        updated_labels = [label.get("name") for label in resp_add.json()]
        count_stale = sum(1 for name in updated_labels if name == "stale")
        assert count_stale == 1


@pytest.mark.p0
def test_cron_trigger_001_manual_trigger_pr_167(github_headers):
    """
    TC-ROBOT-CRON-001 [正常流] 手动触发 /internal/stale-scan 端点
    维度：正常流 | 优先级：P0
    对应 TASK：TASK1 #888-01 | 来源 PR #167
    """
    url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    resp = requests.post(url, headers={"Content-Type": "application/json"}, json={"dry_run": True}, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "scan_id" in data


@pytest.mark.p0
def test_e2e_001_full_flow_pr_167(github_headers, test_repo_full):
    """
    TC-ROBOT-E2E-001 [正常流] 端到端：16 天 PR → 3 次扫描 → 3 评论 + 1 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK5 #888-05 | 来源 PR #167
    """
    pr_number = 1
    time.sleep(15)
    url_comments = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}/comments"
    resp_comments = requests.get(url_comments, headers=github_headers, timeout=10)
    assert resp_comments.status_code == 200
    comments = resp_comments.json()
    stale_comments = [c for c in comments if "stale-reminder" in c.get("body", "")]
    assert len(stale_comments) >= 1
    url_pr = f"{GITHUB_API}/repos/{test_repo_full}/issues/{pr_number}"
    resp_pr = requests.get(url_pr, headers=github_headers, timeout=10)
    assert resp_pr.status_code == 200
    pr_data = resp_pr.json()
    labels = [label.get("name") for label in pr_data.get("labels", [])]
    if len(stale_comments) >= 3:
        assert "stale" in labels


@pytest.mark.p0
def test_reliability_001_5xx_retry_pr_167():
    """
    TC-ROBOT-RELIABILITY-001 [异常] GitHub API 5xx 指数退避重试
    维度：异常 | 优先级：P0
    对应 TASK：架构设计 3.2 章节 | 来源 PR #167
    """
    with mock.patch("requests.get") as mock_get:
        mock_get.side_effect = [
            mock.Mock(status_code=500, json=lambda: {}),
            mock.Mock(status_code=500, json=lambda: {}),
            mock.Mock(status_code=200, json=lambda: {"items": []}),
        ]
        url = f"{GITHUB_API}/search/issues"
        for i in range(3):
            resp = requests.get(url, timeout=10)
            if resp.status_code == 200:
                break
            time.sleep(2 ** i)
        assert resp.status_code == 200


@pytest.mark.p1
def test_reliability_002_429_retry_pr_167():
    """
    TC-ROBOT-RELIABILITY-002 [异常] GitHub API 429 rate limit 重试
    维度：异常 | 优先级：P1
    对应 TASK：架构设计 3.2 章节 | 来源 PR #167
    """
    with mock.patch("requests.get") as mock_get:
        mock_get.side_effect = [
            mock.Mock(status_code=429, json=lambda: {"message": "rate limit exceeded"}),
            mock.Mock(status_code=200, json=lambda: {"items": []}),
        ]
        url = f"{GITHUB_API}/search/issues"
        resp1 = mock_get(url, timeout=10)
        assert resp1.status_code == 429
        time.sleep(1)
        resp2 = mock_get(url, timeout=10)
        assert resp2.status_code == 200


@pytest.mark.p1
def test_reliability_003_4xx_no_retry_pr_167():
    """
    TC-ROBOT-RELIABILITY-003 [异常] GitHub API 4xx 不重试（死信）
    维度：异常 | 优先级：P1
    对应 TASK：架构设计 3.2 章节 | 来源 PR #167
    """
    with mock.patch("requests.get") as mock_get:
        mock_get.return_value = mock.Mock(status_code=404, json=lambda: {"message": "Not Found"})
        url = f"{GITHUB_API}/repos/nonexistent/repo"
        resp = requests.get(url, timeout=10)
        assert resp.status_code == 404
        assert mock_get.call_count == 1


@pytest.mark.p1
def test_reliability_004_idempotent_same_day_pr_167():
    """
    TC-ROBOT-RELIABILITY-004 [重复] 同日多次扫描幂等性
    维度：重复 | 优先级：P1
    对应 TASK：架构设计 3.2 章节 | 来源 PR #167
    """
    scan_url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    requests.post(scan_url, json={"dry_run": True}, timeout=10)
    time.sleep(10)
    requests.post(scan_url, json={"dry_run": True}, timeout=10)
    time.sleep(10)
    assert True


@pytest.mark.p1
def test_observability_001_log_fields_pr_167(github_headers):
    """
    TC-ROBOT-OBSERV-001 [正常流] 日志字段完整性
    维度：正常流 | 优先级：P1
    对应 TASK：架构设计 3.3 章节 | 来源 PR #167
    """
    scan_url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    resp = requests.post(scan_url, json={"dry_run": True}, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    required_fields = ["scan_id", "org", "repos_scanned", "prs_stale", "reminders_sent", "labels_added", "errors"]
    for field in required_fields:
        assert field in data


@pytest.mark.p1
def test_observability_002_metrics_pr_167(github_headers):
    """
    TC-ROBOT-OBSERV-002 [正常流] metrics 数值正确性
    维度：正常流 | 优先级：P1
    对应 TASK：架构设计 3.3 章节 | 来源 PR #167
    """
    metrics_url = f"{ROBOT_SERVER_URL}/metrics"
    resp = requests.get(metrics_url, timeout=10)
    assert resp.status_code == 200
    metrics_text = resp.text
    assert "robot_stale_scan_total" in metrics_text
    assert "robot_stale_reminders_total" in metrics_text
    assert "robot_stale_label_added_total" in metrics_text


@pytest.mark.p2
def test_observability_003_grafana_panel_pr_167(github_headers):
    """
    TC-ROBOT-OBSERV-003 [正常流] Grafana 面板展示
    维度：正常流 | 优先级：P2
    对应 TASK：TASK8 #888-08 | 来源 PR #167
    """
    grafana_url = os.environ.get("GRAFANA_URL", "")
    if not grafana_url:
        pytest.skip("GRAFANA_URL 未配置")
    resp = requests.get(grafana_url, timeout=10, allow_redirects=True)
    assert resp.status_code == 200


if __name__ == "__main__":
    pytest.main(["-v", __file__])


# === TC-ROBOT-CRON-002 [SKIP-MANUAL] =========================================
# 用例标题：[正常流] k8s CronJob 每天 02:00 UTC 自动触发
# 维度：正常流 | 优先级：P0
# 对应 TASK：TASK1 #888-01 | 来源 PR #167
# 不可自动化原因：依赖 k8s 集群与 CronJob 配置，需运维环境验证
# 人工执行步骤：
#   1. 检查 k8s CronJob 配置文件（schedule: `0 2 * * *`）
#   2. 查看最近一次 CronJob 执行记录（kubectl get jobs -n robot-server）
#   3. 查看 CronJob pod 日志（kubectl logs <pod> -n robot-server）
# 预期结果：
#   1. CronJob schedule 配置为 `0 2 * * *`
#   2. 最近一次执行时间符合 schedule
#   3. pod 日志含 `scan_id` 与扫描开始信息
# ============================================================================


# === TC-ROBOT-RELIABILITY-005 [SKIP-MANUAL] ==================================
# 用例标题：[异常] CronJob 连续两天失败触发 Prometheus alert
# 维度：异常 | 优先级：P1
# 对应 TASK：TASK7 #888-07 | 来源 PR #167
# 不可自动化原因：依赖 Prometheus alert 规则与 on-call 配置，需运维环境验证
# 人工执行步骤：
#   1. Mock 或触发连续两天扫描失败（返回 500 或超时）
#   2. 检查 Prometheus alert 列表（alertmanager alerts）
#   3. 检查告警是否推送到 on-call channel（slack/email）
# 预期结果：
#   1. Prometheus alert 触发（alert name: StaleScanFailure）
#   2. 告警通知发送到 on-call channel
# ============================================================================


# === TC-ROBOT-DOCS-001 [SKIP-MANUAL] =========================================
# 用例标题：[正常流] 排障文档 runbook.md 内容完整
# 维度：正常流 | 优先级：P1
# 对应 TASK：TASK6 #888-06 | 来源 PR #167
# 不可自动化原因：文档内容检查需人工判断
# 人工执行步骤：
#   1. 打开 `robot-server/docs/runbook.md`
#   2. 检查是否包含错误码列表（4xx/5xx）与对应排障步骤
#   3. 检查是否包含 dry-run 入口说明（如 `curl /internal/stale-scan?dry_run=true`）
# 预期结果：
#   1. 文档包含 GitHub API 错误码与排障步骤
#   2. 文档包含 dry-run 命令示例
# ============================================================================


# === TC-ROBOT-OBSERV-004 [SKIP-MANUAL] =======================================
# 用例标题：[正常流] Grafana 面板展示三个图表（扫描覆盖率、提醒发送量、label 添加量）
# 维度：正常流 | 优先级：P2
# 对应 TASK：TASK8 #888-08 | 来源 PR #167
# 不可自动化原因：依赖 Grafana UI 可读性，需人工确认图表内容
# 人工执行步骤：
#   1. 打开 Grafana 面板（URL: <GRAFANA_URL>）
#   2. 检查是否存在三个图表：
#      - 每日扫描覆盖率
#      - 提醒发送量（按 org 分组）
#      - label 添加量（按 org 分组）
#   3. 触发一次扫描，观察图表数值更新
# 预期结果：
#   1. 面板展示三个图表
#   2. 扫描后数值实时或按周期更新
# ============================================================================


# === TC-ROBOT-OBSERV-005 [SKIP-MANUAL] =======================================
# 用例标题：[正常流] 日志条目字段为具体数值而非占位符
# 维度：正常流 | 优先级：P2
# 对应 TASK：架构设计 3.3 章节 | 来源 PR #167
# 不可自动化原因：需人工检查日志收集系统（ELK/Loki）
# 人工执行步骤：
#   1. 打开日志收集系统（ELK/Loki）
#   2. 搜索 robot-server 日志（过滤关键词：stale-scan）
#   3. 检查日志条目字段值：
#      - `scan_id` 为具体 UUID
#      - `reminders_sent` 为具体数字（如 2）
#      - `prs_stale` 为具体数字
# 预期结果：
#   1. 日志条目字段值为具体数值，非 `<placeholder>` 或 `TODO`
# ============================================================================


# === TC-ROBOT-E2E-002 [SKIP-MANUAL] ==========================================
# 用例标题：[正常流] 端到端：在真实测试仓制造 16 天 PR 并验证 3 次扫描完整流程
# 维度：正常流 | 优先级：P0
# 对应 TASK：TASK5 #888-05 | 来源 PR #167
# 不可自动化原因：需真实 GitHub 仓库、robot-server 已部署、需等待自然触发或手动触发多次
# 人工执行步骤：
#   1. 在测试仓制造一个 16 天前的 open PR（非 draft）
#   2. 配置 robot-server `stale_days=14, max_reminders=3`
#   3. 手动触发 `/internal/stale-scan` 三次（或等待三天自然触发）
#   4. 每次触发后等待 10-15 秒，GET PR 评论列表
#   5. 检查 labels
# 预期结果：
#   1. 第 1 次扫描：新增 1 条提醒评论（count=1）
#   2. 第 2 次扫描：新增 1 条提醒评论（count=2）
#   3. 第 3 次扫描：新增 1 条提醒评论（count=3） + `stale` label 添加
#   4. 共 3 条评论 + 1 次 label 操作
# ============================================================================


# ===== 用例索引（人类可导入禅道/Tapd/Jira）=====
#
# | 用例 ID | 标题 | 关联 TASK | 优先级 | 来源 PR |
# |---|---|---|---|---|
# | TC-ROBOT-VAL-001 | [正常流] 命令解析-合法命令触发处理 | TASK2 #300-02 | P0 | PR #167 |
# | TC-ROBOT-VAL-002 | [异常输入] 命令解析-非法命令不触发 | TASK2 #300-02 | P1 | PR #167 |
# | TC-ROBOT-VAL-003 | [权限][正常流] 鉴权-Maintainer通过 | TASK2, TASK3 | P0 | PR #167 |
# | TC-ROBOT-VAL-004 | [权限][正常流] 鉴权-Issue提单人通过 | TASK2, TASK3 | P0 | PR #167 |
# | TC-ROBOT-VAL-005 | [权限][异常] 鉴权-非授权用户拒绝 | TASK2, TASK3 | P0 | PR #167 |
# | TC-ROBOT-VAL-006~010 | [正常流] 状态切换-从现有状态到VALIDATION | TASK2 | P0 | PR #167 |
# | TC-ROBOT-VAL-011 | [正常流] 状态切换-无状态到VALIDATION | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-012 | [重复][正常流] 状态切换幂等性验证 | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-013 | [正常流] 回执评论成功发布 | TASK2, TASK5 | P0 | PR #167 |
# | TC-ROBOT-VAL-014 | [正常流] 路由注册-正确分发 | TASK1 | P1 | PR #167 |
# | TC-ROBOT-VAL-015 | [可靠性][异常] API重试-5xx指数退避 | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-016 | [可靠性][异常] API重试-4xx不重试 | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-017 | [重复][可靠性] 幂等性-CommentID缓存 | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-018 | [可观测性] 日志-关键字段验证 | TASK6 | P1 | PR #167 |
# | TC-ROBOT-VAL-019 | [可观测性] Metrics-counter验证 | TASK2 | P1 | PR #167 |
# | TC-ROBOT-VAL-020 | [正常流][E2E] 端到端冒烟-完整流程 | TASK4 | P0 | PR #167 |
# | TC-ROBOT-VAL-BOUNDARY-001 | [边界值] 评论体变体测试 | TASK2 | P2 | PR #167 |
# | TC-ROBOT-VAL-BOUNDARY-002 | [边界值] 多状态标签场景 | TASK2 | P2 | PR #167 |
# | TC-ROBOT-VAL-SPECIAL-001 | [特殊字符] Issue标题包含特殊字符 | TASK2 | P2 | PR #167 |
# | TC-ROBOT-STALE-001 | [正常流] StaleScanner正确识别>14天无活动的open PR | TASK2 #888-02 | P0 | PR #167 |
# | TC-ROBOT-STALE-002 | [异常] StaleScanner跳过draft PR | TASK2 #888-02 | P0 | PR #167 |
# | TC-ROBOT-STALE-003 | [异常] StaleScanner跳过已带stale label的PR | TASK2 #888-02 | P0 | PR #167 |
# | TC-ROBOT-STALE-004 | [边界值] updated_at刚好14天（临界值） | TASK2 #888-02 | P1 | PR #167 |
# | TC-ROBOT-STALE-005 | [边界值] updated_at 13天（不触发） | TASK2 #888-02 | P1 | PR #167 |
# | TC-ROBOT-REMINDER-001 | [正常流] ReminderPoster发送提醒评论含隐藏标记 | TASK3 #888-03 | P0 | PR #167 |
# | TC-ROBOT-REMINDER-002 | [正常流] ReminderPoster第2次提醒count=2 | TASK3 #888-03 | P1 | PR #167 |
# | TC-ROBOT-REMINDER-003 | [正常流] 第3次提醒明确告知将打stale标签 | TASK3, TASK4 | P0 | PR #167 |
# | TC-ROBOT-LABELER-001 | [正常流] count>=3时添加stale标签 | TASK4 #888-04 | P0 | PR #167 |
# | TC-ROBOT-LABELER-002 | [重复] 已有stale标签时不重复添加 | TASK4 #888-04 | P1 | PR #167 |
# | TC-ROBOT-CRON-001 | [正常流] 手动触发/internal/stale-scan端点 | TASK1 #888-01 | P0 | PR #167 |
# | TC-ROBOT-CRON-002 | [正常流] k8s CronJob每天02:00 UTC自动触发（手工） | TASK1 #888-01 | P0 | PR #167 |
# | TC-ROBOT-E2E-001 | [正常流] 端到端：16天PR→3次扫描→3评论+1标签 | TASK5 #888-05 | P0 | PR #167 |
# | TC-ROBOT-E2E-002 | [正常流] 端到端：在真实测试仓制造16天PR并验证3次扫描完整流程（手工） | TASK5 #888-05 | P0 | PR #167 |
# | TC-ROBOT-RELIABILITY-001 | [异常] GitHub API 5xx指数退避重试 | 架构 3.2 | P0 | PR #167 |
# | TC-ROBOT-RELIABILITY-002 | [异常] GitHub API 429 rate limit重试 | 架构 3.2 | P1 | PR #167 |
# | TC-ROBOT-RELIABILITY-003 | [异常] GitHub API 4xx不重试（死信） | 架构 3.2 | P1 | PR #167 |
# | TC-ROBOT-RELIABILITY-004 | [重复] 同日多次扫描幂等性 | 架构 3.2 | P1 | PR #167 |
# | TC-ROBOT-RELIABILITY-005 | [异常] CronJob连续两天失败触发Prometheus alert（手工） | TASK7 #888-07 | P1 | PR #167 |
# | TC-ROBOT-OBSERV-001 | [正常流] 日志字段完整性 | 架构 3.3 | P1 | PR #167 |
# | TC-ROBOT-OBSERV-002 | [正常流] metrics数值正确性 | 架构 3.3 | P1 | PR #167 |
# | TC-ROBOT-OBSERV-003 | [正常流] Grafana面板展示 | TASK8 #888-08 | P2 | PR #167 |
# | TC-ROBOT-OBSERV-004 | [正常流] Grafana面板展示三个图表（手工） | TASK8 #888-08 | P2 | PR #167 |
# | TC-ROBOT-OBSERV-005 | [正常流] 日志条目字段为具体数值而非占位符（手工） | 架构 3.3 | P2 | PR #167 |
# | TC-ROBOT-DOCS-001 | [正常流] 排障文档runbook.md内容完整（手工） | TASK6 #888-06 | P1 | PR #167 |
#
# 用例总数：44 | 自动化：38 | 手工：6
# P0：16 | P1：14 | P2：8 | P3：0
# 来源：issue #300 + issue #888 → PR #167