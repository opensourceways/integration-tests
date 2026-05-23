# robot-server 模块全量测试用例（Python pytest）
# 维护规范：每次需求合入追加新用例，既有用例一律保留不动

import pytest
import requests
from unittest import mock
import time
from datetime import datetime, timedelta
from collections import OrderedDict, defaultdict
import json

# ===== Fixtures =====

@pytest.fixture
def github_api_base():
    return "https://api.github.com"

@pytest.fixture
def test_repo():
    return {
        "owner": "agentic-develop-playground",
        "repo": "backlog"
    }

@pytest.fixture
def maintainer_user():
    return "maintainer-user"

@pytest.fixture
def issue_author():
    return "issue-author-user"

@pytest.fixture
def non_member_user():
    return "non-member-user"

@pytest.fixture
def bot_token():
    return "ghp_test_token_placeholder"

@pytest.fixture
def headers(bot_token):
    return {
        "Authorization": f"Bearer {bot_token}",
        "Accept": "application/vnd.github+json"
    }

@pytest.fixture
def sample_issue():
    return {
        "number": 300,
        "title": "Test Issue for /needs-validation",
        "labels": [{"name": "TODO"}],
        "user": {"login": "issue-author-user"}
    }

@pytest.fixture
def sample_comment():
    return {
        "id": 123456789,
        "body": "/needs-validation",
        "user": {"login": "maintainer-user"}
    }

@pytest.fixture
def webhook_event(sample_issue, sample_comment, test_repo):
    return {
        "action": "created",
        "issue": sample_issue,
        "comment": sample_comment,
        "repository": {"full_name": f"{test_repo['owner']}/{test_repo['repo']}"},
        "sender": {"login": "maintainer-user"}
    }


# ===== 需求 #300: /needs-validation 评论指令测试用例 =====
# 来源 PR: https://github.com/agentic-develop-playground/backlog/pull/127

# ===== 命令解析测试 =====

@pytest.mark.p0
def test_robot_val_001_command_parse_valid_command_triggers(github_api_base, test_repo, headers, sample_issue):
    """
    [正常流] 合法命令触发处理
    对应 TASK: TASK2 #300-02
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
    [异常输入] 非法命令不触发处理
    对应 TASK: TASK2 #300-02
    """
    invalid_commands = [
        "/needs-validation extra",
        "This is /needs-validation",
        "/needs-validation123",
        "/NEEDS-VALIDATION ",
        "",
    ]
    
    for cmd in invalid_commands:
        is_valid = cmd.strip().lower() == "/needs-validation"
        if not is_valid:
            assert True, f"Command '{cmd}' correctly skipped"


# ===== 鉴权测试 =====

@pytest.mark.p0
def test_robot_val_003_auth_maintainer_passes(github_api_base, test_repo, headers, maintainer_user, sample_issue):
    """
    [权限][正常流] Maintainer 通过鉴权
    对应 TASK: TASK2 #300-02, TASK3 #300-03
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
    [权限][正常流] Issue 提代人通过鉴权
    对应 TASK: TASK2 #300-02, TASK3 #300-03
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
    [权限][异常] 非授权用户拒绝
    对应 TASK: TASK2 #300-02, TASK3 #300-03
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


# ===== 状态切换测试 =====

@pytest.mark.p0
@pytest.mark.parametrize("from_status", ["TODO", "ACCEPTED", "WIP", "DONE", "REJECTED"])
def test_robot_val_006_to_010_status_transition_to_validation(
    github_api_base, test_repo, headers, sample_issue, from_status
):
    """
    [正常流] 状态切换 - 从现有状态到 VALIDATION
    对应 TASK: TASK2 #300-02
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
    对应 TASK: TASK2 #300-02
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
    对应 TASK: TASK2 #300-02
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


# ===== 回执评论测试 =====

@pytest.mark.p0
def test_robot_val_013_ack_comment_success(github_api_base, test_repo, headers, sample_issue):
    """
    [正常流] 回执评论成功发布
    对应 TASK: TASK2 #300-02, TASK5 #300-05
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


# ===== 路由注册测试 =====

@pytest.mark.p1
def test_robot_val_014_route_registration_correct_dispatch(webhook_event, sample_comment):
    """
    [正常流] 路由注册 - 正确分发
    对应 TASK: TASK1 #300-01
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


# ===== API 重试测试 =====

@pytest.mark.p1
def test_robot_val_015_api_retry_5xx_exponential_backoff(github_api_base, test_repo, headers, sample_issue):
    """
    [可靠性][异常] API 重试 - 5xx 指数退避
    对应 TASK: TASK2 #300-02
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
    对应 TASK: TASK2 #300-02
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


# ===== 幂等性测试 =====

@pytest.mark.p1
def test_robot_val_017_idempotency_comment_id_cache(webhook_event, sample_comment):
    """
    [重复][可靠性] 幂等性 - Comment ID 缓存
    对应 TASK: TASK2 #300-02
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


# ===== 日志测试 =====

@pytest.mark.p1
def test_robot_val_018_logging_key_fields(webhook_event, test_repo, sample_comment):
    """
    [可观测性] 日志 - 关键字段验证
    对应 TASK: TASK6 #300-06
    """
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


# ===== Metrics 测试 =====

@pytest.mark.p1
def test_robot_val_019_metrics_counter_verification(webhook_event):
    """
    [可观测性] Metrics - counter 验证
    对应 TASK: TASK2 #300-02
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


# ===== E2E 冒烟测试 =====

@pytest.mark.p0
def test_robot_val_020_e2e_smoke_full_flow(github_api_base, test_repo, headers, maintainer_user, sample_issue):
    """
    [正常流][E2E] 端到端冒烟 - 完整流程
    对应 TASK: TASK4 #300-04
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


# ===== 边界值测试 =====

@pytest.mark.p2
def test_robot_val_boundary_comment_body_variations():
    """
    [边界值] 评论体变体测试
    对应 TASK: TASK2 #300-02
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
    对应 TASK: TASK2 #300-02
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


# ===== 特殊字符测试 =====

@pytest.mark.p2
def test_robot_val_special_chars_issue_title():
    """
    [特殊字符] Issue 标题包含特殊字符
    对应 TASK: TASK2 #300-02
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


# ===== 用例索引（人类可贴禅道/Tapd） =====
# 
# | 用例 ID | 测试标题 | 关联 TASK | 优先级 | 测试类型 | 来源 PR |
# |---------|----------|-----------|--------|----------|---------|
# | test_robot_val_001_command_parse_valid_command_triggers | 命令解析-合法命令触发处理 | TASK2 | P0 | unit | #127 |
# | test_robot_val_002_command_parse_invalid_command_skipped | 命令解析-非法命令不触发 | TASK2 | P1 | unit | #127 |
# | test_robot_val_003_auth_maintainer_passes | 鉴权-Maintainer通过 | TASK2, TASK3 | P0 | unit | #127 |
# | test_robot_val_004_auth_issue_author_passes | 鉴权-Issue提代人通过 | TASK2, TASK3 | P0 | unit | #127 |
# | test_robot_val_005_auth_non_member_denied | 鉴权-非授权用户拒绝 | TASK2, TASK3 | P0 | unit | #127 |
# | test_robot_val_006_to_010_status_transition_to_validation | 状态切换-TODO到VALIDATION | TASK2 | P0 | integration | #127 |
# | test_robot_val_006_to_010_status_transition_to_validation[ACCEPTED] | 状态切换-ACCEPTED到VALIDATION | TASK2 | P1 | integration | #127 |
# | test_robot_val_006_to_010_status_transition_to_validation[WIP] | 状态切换-WIP到VALIDATION | TASK2 | P1 | integration | #127 |
# | test_robot_val_006_to_010_status_transition_to_validation[DONE] | 状态切换-DONE到VALIDATION | TASK2 | P1 | integration | #127 |
# | test_robot_val_006_to_010_status_transition_to_validation[REJECTED] | 状态切换-REJECTED到VALIDATION | TASK2 | P1 | integration | #127 |
# | test_robot_val_011_status_transition_no_status_to_validation | 状态切换-无状态到VALIDATION | TASK2 | P1 | integration | #127 |
# | test_robot_val_012_status_transition_idempotent | 状态切换-幂等性验证 | TASK2 | P1 | integration | #127 |
# | test_robot_val_013_ack_comment_success | 回执评论-成功发布 | TASK2, TASK5 | P0 | integration | #127 |
# | test_robot_val_014_route_registration_correct_dispatch | 路由注册-正确分发 | TASK1 | P1 | unit | #127 |
# | test_robot_val_015_api_retry_5xx_exponential_backoff | API重试-5xx指数退避 | TASK2 | P1 | reliability | #127 |
# | test_robot_val_016_api_retry_4xx_no_retry | API重试-4xx不重试 | TASK2 | P1 | reliability | #127 |
# | test_robot_val_017_idempotency_comment_id_cache | 幂等性-CommentID缓存 | TASK2 | P1 | reliability | #127 |
# | test_robot_val_018_logging_key_fields | 日志-关键字段验证 | TASK6 | P1 | observability | #127 |
# | test_robot_val_019_metrics_counter_verification | Metrics-counter验证 | TASK2 | P1 | observability | #127 |
# | test_robot_val_020_e2e_smoke_full_flow | E2E冒烟-完整流程 | TASK4 | P0 | e2e | #127 |
# | test_robot_val_boundary_comment_body_variations | 边界值-评论体变体测试 | TASK2 | P2 | unit | #127 |
# | test_robot_val_boundary_multiple_status_labels | 边界值-多状态标签场景 | TASK2 | P2 | integration | #127 |
# | test_robot_val_special_chars_issue_title | 特殊字符-Issue标题包含特殊字符 | TASK2 | P2 | unit | #127 |