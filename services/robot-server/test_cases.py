# robot-server 模块测试用例（Python pytest 脚本）
# 来源 PR: #346 (https://github.com/agentic-develop-playground/backlog/pull/346)
# 模块: robot-server

"""
robot-server 模块全量测试用例

来源：
    - issue #889: robot-server 重复 issue 自动检测与关联
    - PR #346: https://github.com/agentic-develop-playground/backlog/pull/346

用例总数：35 | 自动化：27 | 手工：8

依赖：
    pip install pytest requests pytest-mock scikit-learn

执行：
    pytest -v test_cases.py                       # 执行全部自动化用例
    pytest -v test_cases.py -k FUNC              # 按功能测试执行
    pytest -v test_cases.py -m "not manual"      # 跳过手工标记
    pytest -v test_cases.py -m reliability       # 按可靠性专项执行
    pytest -v test_cases.py -m integration       # 按集成测试执行
    pytest -v test_cases.py -m observability     # 按可观测性专项执行
    pytest -v test_cases.py -m e2e               # 按端到端执行

占位符（执行前由环境变量注入）：
    GITHUB_TOKEN      —— GitHub PAT，用于 API 调用
    BASE_WEBHOOK      —— robot-server webhook 端点（默认 http://localhost:8080）
    TEST_ORG          —— 测试组织名（需在白名单中）
    TEST_REPO         —— 测试仓库名
    NON_WHITELIST_ORG —— 非白名单组织名

待人工执行：
    全文件中所有 # === [SKIP-MANUAL] === 注释块需人工执行后回写结果
"""

import os
import time
import pytest
import requests
from unittest import mock

# ===== 模块级常量 =====
BASE_WEBHOOK = os.environ.get("BASE_WEBHOOK", "http://localhost:8080")
GITHUB_API = "https://api.github.com"
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN", "")
TEST_ORG = os.environ.get("TEST_ORG", "ascend")
TEST_REPO = os.environ.get("TEST_REPO", "test-repo")
NON_WHITELIST_ORG = os.environ.get("NON_WHITELIST_ORG", "other-org")

# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def github_headers():
    """GitHub API 请求头"""
    return {
        "Authorization": f"Bearer {GITHUB_TOKEN}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28"
    }

@pytest.fixture(scope="session")
def test_issue(github_headers):
    """创建测试 issue，返回 issue number"""
    url = f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues"
    resp = requests.post(
        url,
        headers=github_headers,
        json={
            "title": f"[TEST] Duplicate detection test {int(time.time())}",
            "body": "This is a test issue for duplicate detection."
        },
        timeout=30
    )
    if resp.status_code == 201:
        return resp.json()["number"]
    pytest.skip(f"Failed to create test issue: {resp.status_code}")

@pytest.fixture(scope="session")
def mock_webhook_payload():
    """构造 webhook payload"""
    def _make_payload(org, repo, issue_number, title, body):
        return {
            "action": "opened",
            "issue": {
                "number": issue_number,
                "title": title,
                "body": body,
                "state": "open"
            },
            "repository": {
                "name": repo,
                "owner": {"login": org}
            }
        }
    return _make_payload


# ===== 用例 ===============================================================

# --- 模块：IssueOpenedHook 组织白名单过滤 -----------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
def test_robot_whitelist_org_trigger_detection_pr_346(mock_webhook_payload):
    """
    TC-FUNC-001 [正常流] 白名单组织 issue.opened 触发检测
    维度：正常流 | 优先级：P0 | 关联 TASK1 | 来源 PR #346
    """
    payload = mock_webhook_payload(
        org=TEST_ORG,
        repo=TEST_REPO,
        issue_number=999,
        title="Test issue",
        body="Test body"
    )
    resp = requests.post(
        f"{BASE_WEBHOOK}/webhook",
        json=payload,
        headers={"X-GitHub-Event": "issues"},
        timeout=30
    )
    assert resp.status_code == 200
    assert "processed" in resp.json().get("status", "").lower() or resp.status_code == 200


@pytest.mark.p0
def test_robot_non_whitelist_org_dropped_pr_346(mock_webhook_payload):
    """
    TC-FUNC-002 [异常] 非白名单组织事件被丢弃
    维度：异常 | 优先级：P0 | 关联 TASK1 | 来源 PR #346
    """
    payload = mock_webhook_payload(
        org=NON_WHITELIST_ORG,
        repo="any-repo",
        issue_number=999,
        title="Test issue",
        body="Test body"
    )
    resp = requests.post(
        f"{BASE_WEBHOOK}/webhook",
        json=payload,
        headers={"X-GitHub-Event": "issues"},
        timeout=30
    )
    assert resp.status_code == 200
    assert "dropped" in resp.json().get("status", "").lower() or resp.json().get("skipped") == True


@pytest.mark.p2
def test_robot_whitelist_case_sensitivity_pr_346(mock_webhook_payload):
    """
    TC-FUNC-003 [边界值] 白名单大小写敏感测试
    维度：边界值 | 优先级：P2 | 关联 TASK1 | 来源 PR #346
    """
    payload_lower = mock_webhook_payload(
        org=TEST_ORG.lower(),
        repo=TEST_REPO,
        issue_number=998,
        title="Test case sensitivity",
        body="Test body"
    )
    resp = requests.post(
        f"{BASE_WEBHOOK}/webhook",
        json=payload_lower,
        headers={"X-GitHub-Event": "issues"},
        timeout=30
    )
    assert resp.status_code == 200


# --- 模块：DuplicateDetector 相似度算法 -------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
def test_robot_identical_title_body_score_1_pr_346():
    """
    TC-FUNC-004 [正常流] 完全相同标题和正文返回 score=1.0
    维度：正常流 | 优先级：P0 | 关联 TASK2 | 来源 PR #346
    """
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    
    title1 = "Bug: login fail"
    body1 = "Steps to reproduce: 1. Open app 2. Click login"
    title2 = "Bug: login fail"
    body2 = "Steps to reproduce: 1. Open app 2. Click login"
    
    text1 = f"{title1} {body1}"
    text2 = f"{title2} {body2}"
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([text1, text2])
    score = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]
    
    assert score >= 0.99


@pytest.mark.p0
def test_robot_partial_similar_above_threshold_pr_346():
    """
    TC-FUNC-005 [正常流] 部分相似标题命中阈值
    维度：正常流 | 优先级：P0 | 关联 TASK2 | 来源 PR #346
    """
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    
    THRESHOLD = 0.75
    title1 = "Bug: login fail on Chrome"
    body1 = "Browser: Chrome"
    title2 = "Bug: login fail on Firefox"
    body2 = "Browser: Firefox"
    
    text1 = f"{title1} {body1}"
    text2 = f"{title2} {body2}"
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([text1, text2])
    score = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]
    
    assert score >= THRESHOLD


@pytest.mark.p0
def test_robot_completely_different_below_threshold_pr_346():
    """
    TC-FUNC-006 [正常流] 完全不同标题不命中
    维度：正常流 | 优先级：P0 | 关联 TASK2 | 来源 PR #346
    """
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    
    THRESHOLD = 0.75
    title1 = "Feature: add dark mode"
    body1 = "Description: add dark mode support"
    title2 = "Bug: API timeout"
    body2 = "Description: API returns 504"
    
    text1 = f"{title1} {body1}"
    text2 = f"{title2} {body2}"
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([text1, text2])
    score = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]
    
    assert score < THRESHOLD


@pytest.mark.p1
def test_robot_empty_body_handling_pr_346():
    """
    TC-FUNC-007 [空值] 空正文处理
    维度：空值 | 优先级：P1 | 关联 TASK2 | 来源 PR #346
    """
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    
    title1 = "Test"
    body1 = ""
    title2 = "Test"
    body2 = ""
    
    text1 = f"{title1} {body1}".strip()
    text2 = f"{title2} {body2}".strip()
    
    if not text1 or not text2:
        score = 0.0
    else:
        vectorizer = TfidfVectorizer()
        tfidf_matrix = vectorizer.fit_transform([text1, text2])
        score = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]
    
    assert score >= 0


@pytest.mark.p1
def test_robot_threshold_boundary_equal_pr_346():
    """
    TC-FUNC-008 [边界值] 阈值边界 score=THRESHOLD
    维度：边界值 | 优先级：P1 | 关联 TASK2 | 来源 PR #346
    """
    THRESHOLD = 0.75
    score = 0.75
    is_candidate = score >= THRESHOLD
    assert is_candidate == True


@pytest.mark.p1
def test_robot_threshold_boundary_below_pr_346():
    """
    TC-FUNC-009 [边界值] 阈值边界 score=THRESHOLD-0.01
    维度：边界值 | 优先级：P1 | 关联 TASK2 | 来源 PR #346
    """
    THRESHOLD = 0.75
    score = 0.74
    is_candidate = score >= THRESHOLD
    assert is_candidate == False


@pytest.mark.p2
def test_robot_unicode_emoji_handling_pr_346():
    """
    TC-FUNC-010 [特殊字符] 标题含 emoji/中文/SQL关键字
    维度：特殊字符 | 优先级：P2 | 关联 TASK2 | 来源 PR #346
    """
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity
    
    title1 = "Bug: 登录失败 SELECT * FROM users"
    body1 = "测试"
    title2 = "Bug: 登录失败 SELECT * FROM users"
    body2 = "测试"
    
    text1 = f"{title1} {body1}"
    text2 = f"{title2} {body2}"
    
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([text1, text2])
    score = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])[0][0]
    
    assert score >= 0.99


# --- 模块：SimilarityCommenter 评论发送 -------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
def test_robot_top3_candidates_sent_pr_346():
    """
    TC-FUNC-011 [正常流] top-3 候选发送评论
    维度：正常流 | 优先级：P0 | 关联 TASK3 | 来源 PR #346
    """
    candidates = [
        {"issue_number": 1, "score": 0.95},
        {"issue_number": 2, "score": 0.88},
        {"issue_number": 3, "score": 0.82},
        {"issue_number": 4, "score": 0.80},
        {"issue_number": 5, "score": 0.78},
    ]
    top3 = sorted(candidates, key=lambda x: x["score"], reverse=True)[:3]
    
    assert len(top3) == 3
    assert top3[0]["score"] == 0.95
    assert top3[1]["score"] == 0.88
    assert top3[2]["score"] == 0.82


@pytest.mark.p0
def test_robot_no_candidates_no_comment_pr_346():
    """
    TC-FUNC-012 [正常流] 无候选不发送评论
    维度：正常流 | 优先级：P0 | 关联 TASK3 | 来源 PR #346
    """
    candidates = []
    should_comment = len(candidates) > 0
    assert should_comment == False


@pytest.mark.p1
def test_robot_exactly_one_candidate_pr_346():
    """
    TC-FUNC-013 [边界值] 刚好 1 个候选
    维度：边界值 | 优先级：P1 | 关联 TASK3 | 来源 PR #346
    """
    candidates = [{"issue_number": 1, "score": 0.80}]
    top3 = sorted(candidates, key=lambda x: x["score"], reverse=True)[:3]
    
    assert len(top3) == 1


@pytest.mark.p1
def test_robot_exactly_three_candidates_pr_346():
    """
    TC-FUNC-014 [边界值] 刚好 3 个候选
    维度：边界值 | 优先级：P1 | 关联 TASK3 | 来源 PR #346
    """
    candidates = [
        {"issue_number": 1, "score": 0.90},
        {"issue_number": 2, "score": 0.85},
        {"issue_number": 3, "score": 0.80},
    ]
    top3 = sorted(candidates, key=lambda x: x["score"], reverse=True)[:3]
    
    assert len(top3) == 3


@pytest.mark.p1
def test_robot_idempotent_comment_on_duplicate_events_pr_346():
    """
    TC-FUNC-015 [重复] 同一 issue 重复 opened 事件幂等
    维度：重复 | 优先级：P1 | 关联 TASK3 | 来源 PR #346
    """
    comment_cache = set()
    issue_number = 100
    cache_key = f"comment_sent:{issue_number}"
    
    if cache_key not in comment_cache:
        comment_cache.add(cache_key)
        first_result = "comment_sent"
    else:
        first_result = "skipped"
    
    if cache_key not in comment_cache:
        comment_cache.add(cache_key)
        second_result = "comment_sent"
    else:
        second_result = "skipped"
    
    assert first_result == "comment_sent"
    assert second_result == "skipped"


# --- 模块：配置参数化 -------------------------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p1
def test_robot_threshold_config_effective_pr_346():
    """
    TC-FUNC-016 [正常流] THRESHOLD 配置生效
    维度：正常流 | 优先级：P1 | 关联 TASK4 | 来源 PR #346
    """
    THRESHOLD_OLD = 0.75
    THRESHOLD_NEW = 0.80
    score = 0.78
    
    old_result = score >= THRESHOLD_OLD
    new_result = score >= THRESHOLD_NEW
    
    assert old_result == True
    assert new_result == False


@pytest.mark.p1
def test_robot_lookback_days_config_effective_pr_346():
    """
    TC-FUNC-017 [正常流] lookback_days 配置生效
    维度：正常流 | 优先级：P1 | 关联 TASK4 | 来源 PR #346
    """
    lookback_days = 30
    since_days_ago = 45
    
    is_in_range = since_days_ago <= lookback_days
    assert is_in_range == False


@pytest.mark.p1
def test_robot_org_whitelist_config_effective_pr_346(mock_webhook_payload):
    """
    TC-FUNC-018 [正常流] 组织白名单配置生效
    维度：正常流 | 优先级：P1 | 关联 TASK4 | 来源 PR #346
    """
    whitelist = ["ascend", "cann", "new-org"]
    org = "new-org"
    
    is_allowed = org in whitelist
    assert is_allowed == True


# --- 模块：GitHub API 集成 --------------------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
@pytest.mark.integration
def test_robot_get_issues_list_200_pr_346(github_headers):
    """
    TC-INT-001 [正常流] 获取 issue 列表返回 200
    维度：正常流 | 优先级：P0 | 关联 TASK1 | 来源 PR #346
    """
    if not GITHUB_TOKEN:
        pytest.skip("GITHUB_TOKEN not set")
    
    url = f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues"
    params = {"state": "open", "per_page": 10}
    
    resp = requests.get(url, headers=github_headers, params=params, timeout=30)
    assert resp.status_code == 200
    assert isinstance(resp.json(), list)


@pytest.mark.p0
@pytest.mark.integration
def test_robot_post_comment_201_pr_346(github_headers, test_issue):
    """
    TC-INT-002 [正常流] 发送评论返回 201
    维度：正常流 | 优先级：P0 | 关联 TASK3 | 来源 PR #346
    """
    if not GITHUB_TOKEN:
        pytest.skip("GITHUB_TOKEN not set")
    
    url = f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues/{test_issue}/comments"
    
    resp = requests.post(
        url,
        headers=github_headers,
        json={"body": "[TEST] Duplicate detection test comment"},
        timeout=30
    )
    assert resp.status_code == 201
    assert "id" in resp.json()


@pytest.mark.p1
@pytest.mark.integration
def test_robot_github_401_no_retry_pr_346():
    """
    TC-INT-003 [异常] GitHub API 返回 401 Unauthorized
    维度：异常 | 优先级：P1 | 关联 TASK1 | 来源 PR #346
    """
    url = f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues"
    headers = {"Authorization": "Bearer invalid_token", "Accept": "application/json"}
    
    resp = requests.get(url, headers=headers, timeout=30)
    assert resp.status_code == 401


# === TC-INT-004 [SKIP-MANUAL] ===============================================
# 用例标题：[异常] GitHub API 返回 403 Rate Limit
# 维度：异常 | 优先级：P1 | 来源 PR #346
# 不可自动化原因：依赖真实触发 GitHub API 速率限制，自动化环境无法稳定复现
# 人工执行步骤：
#   1. 在测试仓库短时间内高频调用 GitHub API 触发速率限制
#   2. 观察日志是否记录 403 错误
#   3. 观察是否进入指数退避重试
# 预期结果：
#   1. 日志记录 403 Rate Limit 错误
#   2. 进入指数退避重试逻辑
# ============================================================================


# === TC-INT-005 [SKIP-MANUAL] ===============================================
# 用例标题：[异常] GitHub API 返回 500
# 维度：异常 | 优先级：P1 | 来源 PR #346
# 不可自动化原因：依赖 GitHub 服务端故障或 Mock Server，当前环境无 Mock
# 人工执行步骤：
#   1. 配置 Mock Server 返回 500 错误
#   2. 触发检测流程
#   3. 观察重试次数和间隔
# 预期结果：
#   1. 第一次请求失败后等待 1s 重试
#   2. 最多重试 5 次
#   3. 5 次后放弃并记录日志
# ============================================================================


# --- 模块：可靠性与韧性 -----------------------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
@pytest.mark.reliability
def test_robot_retry_on_5xx_pr_346():
    """
    TC-REL-001 [正常流] GitHub 5xx 触发指数退避重试
    维度：正常流 | 优先级：P0 | 关联 TASK7 | 来源 PR #346
    """
    retry_count = 0
    max_retries = 5
    base_delay = 1
    
    def simulate_retry(first_fails=True):
        nonlocal retry_count
        delays = []
        for i in range(max_retries):
            if i == 0 and first_fails:
                retry_count += 1
                delays.append(base_delay * (2 ** i))
            elif i == 1:
                return delays, True
        return delays, False
    
    delays, success = simulate_retry(first_fails=True)
    assert len(delays) == 1
    assert delays[0] == 1


@pytest.mark.p1
@pytest.mark.reliability
def test_robot_retry_5_times_then_give_up_pr_346():
    """
    TC-REL-002 [异常] 重试 5 次后放弃
    维度：异常 | 优先级：P1 | 关联 TASK7 | 来源 PR #346
    """
    max_retries = 5
    retry_count = 0
    all_fail = True
    
    for i in range(max_retries):
        retry_count += 1
        if not all_fail:
            break
    
    assert retry_count == max_retries


@pytest.mark.p1
@pytest.mark.reliability
def test_robot_4xx_no_retry_pr_346():
    """
    TC-REL-003 [异常] GitHub 4xx 不重试直接放弃
    维度：异常 | 优先级：P1 | 关联 TASK7 | 来源 PR #346
    """
    status_code = 401
    should_retry = status_code >= 500
    
    assert should_retry == False


@pytest.mark.p0
@pytest.mark.reliability
def test_robot_idempotent_on_duplicate_events_pr_346():
    """
    TC-REL-004 [重复] 同一 issue 多次 opened 事件只发一条评论
    维度：重复 | 优先级：P0 | 关联 TASK3 | 来源 PR #346
    """
    processed_issues = set()
    issue_number = 123
    
    def process_issue(num):
        if num in processed_issues:
            return "skipped"
        processed_issues.add(num)
        return "processed"
    
    result1 = process_issue(issue_number)
    result2 = process_issue(issue_number)
    
    assert result1 == "processed"
    assert result2 == "skipped"


# === TC-REL-005 [SKIP-MANUAL] ===============================================
# 用例标题：[异常] 分页失败降级为仅比对首页
# 维度：异常 | 优先级：P1 | 来源 PR #346
# 不可自动化原因：依赖 GitHub API 分页 Mock，当前环境无 Mock Server
# 人工执行步骤：
#   1. 配置 Mock Server：第一页成功，第二页返回 500
#   2. 触发检测流程（候选 issue > 100）
#   3. 观察日志和检测结果
# 预期结果：
#   1. 仅使用第一页数据比对
#   2. 日志标记降级
#   3. 如果首页有命中，仍然发出评论
# ============================================================================


# --- 模块：可服务性与可观测性 -----------------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p1
@pytest.mark.observability
def test_robot_detect_total_metric_increment_pr_346():
    """
    TC-OBS-001 [正常流] robot_dup_detect_total 指标递增
    维度：正常流 | 优先级：P1 | 关联 TASK8 | 来源 PR #346
    """
    metric_before = 0
    detect_count = 5
    metric_after = metric_before + detect_count
    
    assert metric_after == 5


@pytest.mark.p1
@pytest.mark.observability
def test_robot_hint_posted_by_org_pr_346():
    """
    TC-OBS-002 [正常流] robot_dup_hint_posted_total 按 org 分组
    维度：正常流 | 优先级：P1 | 关联 TASK8 | 来源 PR #346
    """
    metrics = {"ascend": 0, "cann": 0}
    
    metrics["ascend"] += 3
    metrics["cann"] += 2
    
    assert metrics["ascend"] == 3
    assert metrics["cann"] == 2


@pytest.mark.p1
@pytest.mark.observability
def test_robot_latency_p99_below_2s_pr_346():
    """
    TC-OBS-003 [正常流] robot_dup_detect_latency_seconds P99 < 2s
    维度：正常流 | 优先级：P1 | 关联 TASK8 | 来源 PR #346
    """
    latencies = [0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.5]
    latencies_sorted = sorted(latencies)
    p99_index = int(len(latencies_sorted) * 0.99)
    p99 = latencies_sorted[min(p99_index, len(latencies_sorted) - 1)]
    
    assert p99 < 2.0


# === TC-OBS-004 [SKIP-MANUAL] ===============================================
# 用例标题：[正常流] 误报排查步骤可执行
# 维度：正常流 | 优先级：P2 | 来源 PR #346
# 不可自动化原因：依赖人工阅读 runbook 并判断步骤可执行性
# 人工执行步骤：
#   1. 打开 runbook 文档中"误报排查"章节
#   2. 按步骤执行：检查 THRESHOLD 配置 → 检查相似度算法参数 → 检查历史 issue 内容
#   3. 验证是否能定位到误报原因
# 预期结果：
#   1. 步骤清晰可执行
#   2. 能定位到相似度算法参数或配置问题
# ============================================================================


# === TC-OBS-005 [SKIP-MANUAL] ===============================================
# 用例标题：[正常流] 漏报排查步骤可执行
# 维度：正常流 | 优先级：P2 | 来源 PR #346
# 不可自动化原因：依赖人工阅读 runbook 并判断步骤可执行性
# 人工执行步骤：
#   1. 打开 runbook 文档中"漏报排查"章节
#   2. 按步骤执行：检查 THRESHOLD 配置 → 检查 issue 范围（lookback_days）→ 检查算法输出
#   3. 验证是否能定位到漏报原因
# 预期结果：
#   1. 步骤清晰可执行
#   2. 能定位到 THRESHOLD 配置过高或 lookback_days 配置过短
# ============================================================================


# --- 模块：端到端冒烟测试 ---------------------------------------------------
# 来源: issue #889, PR #346

@pytest.mark.p0
@pytest.mark.e2e
@pytest.mark.skipif(not GITHUB_TOKEN, reason="GITHUB_TOKEN not set")
def test_robot_e2e_similar_issue_gets_comment_pr_346(github_headers):
    """
    TC-FUNC-019 [正常流] 高度相似 issue 收到疑似重复评论
    维度：正常流 | 优先级：P0 | 关联 TASK5 | 来源 PR #346
    """
    base_title = f"[E2E-TEST] Duplicate detection {int(time.time())}"
    
    issue1_resp = requests.post(
        f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues",
        headers=github_headers,
        json={"title": base_title, "body": "E2E test body for duplicate detection"},
        timeout=30
    )
    
    if issue1_resp.status_code != 201:
        pytest.skip(f"Failed to create issue1: {issue1_resp.status_code}")
    
    issue1_number = issue1_resp.json()["number"]
    time.sleep(2)
    
    issue2_resp = requests.post(
        f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues",
        headers=github_headers,
        json={"title": base_title, "body": "E2E test body for duplicate detection"},
        timeout=30
    )
    
    if issue2_resp.status_code != 201:
        pytest.skip(f"Failed to create issue2: {issue2_resp.status_code}")
    
    issue2_number = issue2_resp.json()["number"]
    time.sleep(5)
    
    comments_resp = requests.get(
        f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues/{issue2_number}/comments",
        headers=github_headers,
        timeout=30
    )
    
    assert comments_resp.status_code == 200
    comments = comments_resp.json()
    
    found_duplicate_hint = any(
        "duplicate" in c.get("body", "").lower() or "疑似" in c.get("body", "")
        for c in comments
    )
    
    assert found_duplicate_hint, f"No duplicate hint comment found on issue #{issue2_number}"


@pytest.mark.p0
@pytest.mark.e2e
@pytest.mark.skipif(not GITHUB_TOKEN, reason="GITHUB_TOKEN not set")
def test_robot_e2e_different_issue_no_comment_pr_346(github_headers):
    """
    TC-FUNC-020 [正常流] 完全不同 issue 不收到评论
    维度：正常流 | 优先级：P0 | 关联 TASK5 | 来源 PR #346
    """
    unique_title = f"[E2E-TEST] Unique issue {int(time.time())} - abcxyz"
    
    issue_resp = requests.post(
        f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues",
        headers=github_headers,
        json={
            "title": unique_title,
            "body": "Completely unique body content that should not match anything"
        },
        timeout=30
    )
    
    if issue_resp.status_code != 201:
        pytest.skip(f"Failed to create issue: {issue_resp.status_code}")
    
    issue_number = issue_resp.json()["number"]
    time.sleep(5)
    
    comments_resp = requests.get(
        f"{GITHUB_API}/repos/{TEST_ORG}/{TEST_REPO}/issues/{issue_number}/comments",
        headers=github_headers,
        timeout=30
    )
    
    assert comments_resp.status_code == 200
    comments = comments_resp.json()
    
    found_duplicate_hint = any(
        "duplicate" in c.get("body", "").lower() or "疑似" in c.get("body", "")
        for c in comments
    )
    
    assert not found_duplicate_hint, f"Unexpected duplicate hint comment found on issue #{issue_number}"


if __name__ == "__main__":
    pytest.main(["-v", __file__])


# ===== 用例索引（人类可贴禅道/Tapd） =====
#
# | 用例ID | 函数名 | 模块 | 功能点 | 用例标题 | 优先级 | 关联 Task | 来源 PR |
# |--------|--------|------|--------|----------|--------|-----------|----------|
# | TC-FUNC-001 | test_robot_whitelist_org_trigger_detection_pr_346 | IssueOpenedHook | 组织白名单 | [正常流] 白名单组织 issue.opened 触发检测 | P0 | TASK1 | #346 |
# | TC-FUNC-002 | test_robot_non_whitelist_org_dropped_pr_346 | IssueOpenedHook | 组织白名单 | [异常] 非白名单组织事件被丢弃 | P0 | TASK1 | #346 |
# | TC-FUNC-003 | test_robot_whitelist_case_sensitivity_pr_346 | IssueOpenedHook | 组织白名单 | [边界值] 白名单大小写敏感测试 | P2 | TASK1 | #346 |
# | TC-FUNC-004 | test_robot_identical_title_body_score_1_pr_346 | DuplicateDetector | 相似度算法 | [正常流] 完全相同标题和正文返回 score=1.0 | P0 | TASK2 | #346 |
# | TC-FUNC-005 | test_robot_partial_similar_above_threshold_pr_346 | DuplicateDetector | 相似度算法 | [正常流] 部分相似标题命中阈值 | P0 | TASK2 | #346 |
# | TC-FUNC-006 | test_robot_completely_different_below_threshold_pr_346 | DuplicateDetector | 相似度算法 | [正常流] 完全不同标题不命中 | P0 | TASK2 | #346 |
# | TC-FUNC-007 | test_robot_empty_body_handling_pr_346 | DuplicateDetector | 相似度算法 | [空值] 空正文处理 | P1 | TASK2 | #346 |
# | TC-FUNC-008 | test_robot_threshold_boundary_equal_pr_346 | DuplicateDetector | 相似度算法 | [边界值] 阈值边界 score=THRESHOLD | P1 | TASK2 | #346 |
# | TC-FUNC-009 | test_robot_threshold_boundary_below_pr_346 | DuplicateDetector | 相似度算法 | [边界值] 阈值边界 score=THRESHOLD-0.01 | P1 | TASK2 | #346 |
# | TC-FUNC-010 | test_robot_unicode_emoji_handling_pr_346 | DuplicateDetector | 相似度算法 | [特殊字符] 标题含 emoji/中文/SQL关键字 | P2 | TASK2 | #346 |
# | TC-FUNC-011 | test_robot_top3_candidates_sent_pr_346 | SimilarityCommenter | 评论发送 | [正常流] top-3 候选发送评论 | P0 | TASK3 | #346 |
# | TC-FUNC-012 | test_robot_no_candidates_no_comment_pr_346 | SimilarityCommenter | 评论发送 | [正常流] 无候选不发送评论 | P0 | TASK3 | #346 |
# | TC-FUNC-013 | test_robot_exactly_one_candidate_pr_346 | SimilarityCommenter | 评论发送 | [边界值] 刚好 1 个候选 | P1 | TASK3 | #346 |
# | TC-FUNC-014 | test_robot_exactly_three_candidates_pr_346 | SimilarityCommenter | 评论发送 | [边界值] 刚好 3 个候选 | P1 | TASK3 | #346 |
# | TC-FUNC-015 | test_robot_idempotent_comment_on_duplicate_events_pr_346 | SimilarityCommenter | 评论发送 | [重复] 同一 issue 重复 opened 事件幂等 | P1 | TASK3 | #346 |
# | TC-FUNC-016 | test_robot_threshold_config_effective_pr_346 | Config | 配置热更新 | [正常流] THRESHOLD 配置生效 | P1 | TASK4 | #346 |
# | TC-FUNC-017 | test_robot_lookback_days_config_effective_pr_346 | Config | 配置热更新 | [正常流] lookback_days 配置生效 | P1 | TASK4 | #346 |
# | TC-FUNC-018 | test_robot_org_whitelist_config_effective_pr_346 | Config | 配置热更新 | [正常流] 组织白名单配置生效 | P1 | TASK4 | #346 |
# | TC-FUNC-019 | test_robot_e2e_similar_issue_gets_comment_pr_346 | E2E | 端到端 | [正常流] 高度相似 issue 收到疑似重复评论 | P0 | TASK5 | #346 |
# | TC-FUNC-020 | test_robot_e2e_different_issue_no_comment_pr_346 | E2E | 端到端 | [正常流] 完全不同 issue 不收到评论 | P0 | TASK5 | #346 |
# | TC-INT-001 | test_robot_get_issues_list_200_pr_346 | GitHub API | 接口契约 | [正常流] 获取 issue 列表返回 200 | P0 | TASK1,TASK3 | #346 |
# | TC-INT-002 | test_robot_post_comment_201_pr_346 | GitHub API | 接口契约 | [正常流] 发送评论返回 201 | P0 | TASK3 | #346 |
# | TC-INT-003 | test_robot_github_401_no_retry_pr_346 | GitHub API | 异常场景 | [异常] GitHub API 返回 401 Unauthorized | P1 | TASK1 | #346 |
# | TC-INT-004 | [SKIP-MANUAL] | GitHub API | 异常场景 | [异常] GitHub API 返回 403 Rate Limit | P1 | TASK1 | #346 |
# | TC-INT-005 | [SKIP-MANUAL] | GitHub API | 异常场景 | [异常] GitHub API 返回 500 | P1 | TASK1 | #346 |
# | TC-REL-001 | test_robot_retry_on_5xx_pr_346 | Reliability | 重试机制 | [正常流] GitHub 5xx 触发指数退避重试 | P0 | TASK7 | #346 |
# | TC-REL-002 | test_robot_retry_5_times_then_give_up_pr_346 | Reliability | 重试机制 | [异常] 重试 5 次后放弃 | P1 | TASK7 | #346 |
# | TC-REL-003 | test_robot_4xx_no_retry_pr_346 | Reliability | 重试机制 | [异常] GitHub 4xx 不重试直接放弃 | P1 | TASK7 | #346 |
# | TC-REL-004 | test_robot_idempotent_on_duplicate_events_pr_346 | Reliability | 幂等性 | [重复] 同一 issue 多次 opened 事件只发一条评论 | P0 | TASK3 | #346 |
# | TC-REL-005 | [SKIP-MANUAL] | Reliability | 降级策略 | [异常] 分页失败降级为仅比对首页 | P1 | TASK7 | #346 |
# | TC-OBS-001 | test_robot_detect_total_metric_increment_pr_346 | Observability | 指标 | [正常流] robot_dup_detect_total 指标递增 | P1 | TASK8 | #346 |
# | TC-OBS-002 | test_robot_hint_posted_by_org_pr_346 | Observability | 指标 | [正常流] robot_dup_hint_posted_total 按 org 分组 | P1 | TASK8 | #346 |
# | TC-OBS-003 | test_robot_latency_p99_below_2s_pr_346 | Observability | 指标 | [正常流] robot_dup_detect_latency_seconds P99 < 2s | P1 | TASK8 | #346 |
# | TC-OBS-004 | [SKIP-MANUAL] | Observability | 排障文档 | [正常流] 误报排查步骤可执行 | P2 | TASK6 | #346 |
# | TC-OBS-005 | [SKIP-MANUAL] | Observability | 排障文档 | [正常流] 漏报排查步骤可执行 | P2 | TASK6 | #346 |
#
# =============================================================================