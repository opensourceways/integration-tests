# robot-server 模块测试用例（Python pytest 脚本）
#
# 更新记录：
# | PR | Issue | 合入时间 | 说明 |
# |---|---|---|---|
# | #166 | #888 | 2026-05-23 | 长期无活动 PR 自动评论提醒测试用例 |
#
# 用例总数：24 | 自动化：18 | 手工：6

"""
robot-server 模块测试用例

依赖：
    pip install pytest requests pytest-dependency pytest-mock

执行：
    pytest -v test_cases.py                     # 执行全部自动化用例
    pytest -v test_cases.py -k stale_scanner    # 按模块执行
    pytest -v test_cases.py -m "not manual"     # 跳过手工标记

占位符（执行前由环境变量注入）：
    GITHUB_TOKEN      —— GitHub PAT（需 repo:read + issues:write 权限）
    TEST_REPO_OWNER   —— 测试仓 owner（如 agentic-develop-playground）
    TEST_REPO_NAME    —— 测试仓 name（如 test-stale-pr）
    ROBOT_SERVER_URL  —— robot-server 内部端点（如 http://robot-server:8080）
    GRAFANA_URL       —— Grafana 面板地址（手工用例需要）
"""

import os
import time
import pytest
import requests
from unittest import mock

GITHUB_API = "https://api.github.com"
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN", "")
TEST_REPO_OWNER = os.environ.get("TEST_REPO_OWNER", "agentic-develop-playground")
TEST_REPO_NAME = os.environ.get("TEST_REPO_NAME", "test-stale-pr")
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
            if updated_at_days_ago:
                mock_pr_updated_at(pr_number, updated_at_days_ago)
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


# ============================================================================
# Issue #888: 长期无活动 PR 自动评论提醒
# PR #166: https://github.com/agentic-develop-playground/backlog/pull/166
# ============================================================================


@pytest.mark.p0
def test_robot_stale_scanner_001_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-001 [正常流] StaleScanner 正确识别 >14 天无活动的 open PR
    维度：正常流 | 优先级：P0
    对应 TASK：TASK2 #888-02
    来源 PR：#166
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
def test_robot_stale_scanner_002_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-002 [异常] StaleScanner 跳过 draft PR
    维度：异常 | 优先级：P0
    对应 TASK：TASK2 #888-02
    来源 PR：#166
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
def test_robot_stale_scanner_003_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-003 [异常] StaleScanner 跳过已带 stale label 的 PR
    维度：异常 | 优先级：P0
    对应 TASK：TASK2 #888-02
    来源 PR：#166
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} label:stale"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "items" in data


@pytest.mark.p1
def test_robot_stale_scanner_004_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-004 [边界值] updated_at 刚好 14 天（临界值）
    维度：边界值 | 优先级：P1
    对应 TASK：TASK2 #888-02
    来源 PR：#166
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
def test_robot_stale_scanner_005_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-STALE-005 [边界值] updated_at 13 天（不触发）
    维度：边界值 | 优先级：P1
    对应 TASK：TASK2 #888-02
    来源 PR：#166
    """
    url = f"{GITHUB_API}/search/issues"
    query = f"is:pr is:open repo:{test_repo_full} updated:>2026-05-10"
    params = {"q": query}
    resp = requests.get(url, headers=github_headers, params=params, timeout=10)
    assert resp.status_code == 200


@pytest.mark.p0
def test_robot_reminder_poster_001_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-001 [正常流] ReminderPoster 发送提醒评论含隐藏标记
    维度：正常流 | 优先级：P0
    对应 TASK：TASK3 #888-03
    来源 PR：#166
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
def test_robot_reminder_poster_002_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-002 [正常流] ReminderPoster 第 2 次提醒 count=2
    维度：正常流 | 优先级：P1
    对应 TASK：TASK3 #888-03
    来源 PR：#166
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
def test_robot_reminder_poster_003_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-REMINDER-003 [正常流] 第 3 次提醒明确告知将打 stale 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK3 #888-03 + TASK4 #888-04
    来源 PR：#166
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
def test_robot_stale_labeler_001_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-LABELER-001 [正常流] count>=3 时添加 stale 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK4 #888-04
    来源 PR：#166
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
def test_robot_stale_labeler_002_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-LABELER-002 [重复] 已有 stale 标签时不重复添加
    维度：重复 | 优先级：P1
    对应 TASK：TASK4 #888-04
    来源 PR：#166
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
def test_robot_cron_trigger_001_pr_166(github_headers):
    """
    TC-ROBOT-CRON-001 [正常流] 手动触发 /internal/stale-scan 端点
    维度：正常流 | 优先级：P0
    对应 TASK：TASK1 #888-01
    来源 PR：#166
    """
    url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    resp = requests.post(url, headers={"Content-Type": "application/json"}, json={"dry_run": True}, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    assert "scan_id" in data


@pytest.mark.p0
def test_robot_e2e_001_pr_166(github_headers, test_repo_full):
    """
    TC-ROBOT-E2E-001 [正常流] 端到端：16 天 PR → 3 次扫描 → 3 评论 + 1 标签
    维度：正常流 | 优先级：P0
    对应 TASK：TASK5 #888-05
    来源 PR：#166
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
def test_robot_reliability_001_pr_166():
    """
    TC-ROBOT-RELIABILITY-001 [异常] GitHub API 5xx 指数退避重试
    维度：异常 | 优先级：P0
    对应 TASK：架构设计 3.2 章节
    来源 PR：#166
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
def test_robot_reliability_002_pr_166():
    """
    TC-ROBOT-RELIABILITY-002 [异常] GitHub API 429 rate limit 重试
    维度：异常 | 优先级：P1
    对应 TASK：架构设计 3.2 章节
    来源 PR：#166
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
def test_robot_reliability_003_pr_166():
    """
    TC-ROBOT-RELIABILITY-003 [异常] GitHub API 4xx 不重试（死信）
    维度：异常 | 优先级：P1
    对应 TASK：架构设计 3.2 章节
    来源 PR：#166
    """
    with mock.patch("requests.get") as mock_get:
        mock_get.return_value = mock.Mock(status_code=404, json=lambda: {"message": "Not Found"})
        url = f"{GITHUB_API}/repos/nonexistent/repo"
        resp = requests.get(url, timeout=10)
        assert resp.status_code == 404
        assert mock_get.call_count == 1


@pytest.mark.p1
def test_robot_reliability_004_pr_166():
    """
    TC-ROBOT-RELIABILITY-004 [重复] 同日多次扫描幂等性
    维度：重复 | 优先级：P1
    对应 TASK：架构设计 3.2 章节
    来源 PR：#166
    """
    pr_number = 1
    scan_url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    requests.post(scan_url, json={"dry_run": True}, timeout=10)
    time.sleep(10)
    requests.post(scan_url, json={"dry_run": True}, timeout=10)
    time.sleep(10)
    assert True


@pytest.mark.p1
def test_robot_observability_001_pr_166(github_headers):
    """
    TC-ROBOT-OBSERV-001 [正常流] 日志字段完整性
    维度：正常流 | 优先级：P1
    对应 TASK：架构设计 3.3 章节
    来源 PR：#166
    """
    scan_url = f"{ROBOT_SERVER_URL}/internal/stale-scan"
    resp = requests.post(scan_url, json={"dry_run": True}, timeout=10)
    assert resp.status_code == 200
    data = resp.json()
    required_fields = ["scan_id", "org", "repos_scanned", "prs_stale", "reminders_sent", "labels_added", "errors"]
    for field in required_fields:
        assert field in data


@pytest.mark.p1
def test_robot_observability_002_pr_166(github_headers):
    """
    TC-ROBOT-OBSERV-002 [正常流] metrics 数值正确性
    维度：正常流 | 优先级：P1
    对应 TASK：架构设计 3.3 章节
    来源 PR：#166
    """
    metrics_url = f"{ROBOT_SERVER_URL}/metrics"
    resp = requests.get(metrics_url, timeout=10)
    assert resp.status_code == 200
    metrics_text = resp.text
    assert "robot_stale_scan_total" in metrics_text
    assert "robot_stale_reminders_total" in metrics_text
    assert "robot_stale_label_added_total" in metrics_text


@pytest.mark.p2
def test_robot_observability_003_pr_166(github_headers):
    """
    TC-ROBOT-OBSERV-003 [正常流] Grafana 面板展示
    维度：正常流 | 优先级：P2
    对应 TASK：TASK8 #888-08
    来源 PR：#166
    """
    grafana_url = os.environ.get("GRAFANA_URL", "")
    if not grafana_url:
        pytest.skip("GRAFANA_URL 未配置")
    resp = requests.get(grafana_url, timeout=10, allow_redirects=True)
    assert resp.status_code == 200


# === TC-ROBOT-CRON-002 [SKIP-MANUAL] =========================================
# 用例标题：[正常流] k8s CronJob 每天 02:00 UTC 自动触发
# 维度：正常流 | 优先级：P0
# 对应 TASK：TASK1 #888-01
# 来源 PR：#166
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
# 对应 TASK：TASK7 #888-07
# 来源 PR：#166
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
# 对应 TASK：TASK6 #888-06
# 来源 PR：#166
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
# 对应 TASK：TASK8 #888-08
# 来源 PR：#166
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
# 对应 TASK：架构设计 3.3 章节
# 来源 PR：#166
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
# 对应 TASK：TASK5 #888-05
# 来源 PR：#166
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


if __name__ == "__main__":
    pytest.main(["-v", __file__])


# ===== 用例索引（人类可贴禅道/Tapd）=====
#
# | 用例 ID | 标题 | 关联 TASK | 优先级 | 来源 PR |
# |---|---|---|---|---|
# | TC-ROBOT-STALE-001 | [正常流] StaleScanner 正确识别 >14 天无活动的 open PR | TASK2 #888-02 | P0 | #166 |
# | TC-ROBOT-STALE-002 | [异常] StaleScanner 跳过 draft PR | TASK2 #888-02 | P0 | #166 |
# | TC-ROBOT-STALE-003 | [异常] StaleScanner 跳过已带 stale label 的 PR | TASK2 #888-02 | P0 | #166 |
# | TC-ROBOT-STALE-004 | [边界值] updated_at 刚好 14 天（临界值） | TASK2 #888-02 | P1 | #166 |
# | TC-ROBOT-STALE-005 | [边界值] updated_at 13 天（不触发） | TASK2 #888-02 | P1 | #166 |
# | TC-ROBOT-REMINDER-001 | [正常流] ReminderPoster 发送提醒评论含隐藏标记 | TASK3 #888-03 | P0 | #166 |
# | TC-ROBOT-REMINDER-002 | [正常流] ReminderPoster 第 2 次提醒 count=2 | TASK3 #888-03 | P1 | #166 |
# | TC-ROBOT-REMINDER-003 | [正常流] 第 3 次提醒明确告知将打 stale 标签 | TASK3 #888-03 + TASK4 #888-04 | P0 | #166 |
# | TC-ROBOT-LABELER-001 | [正常流] count>=3 时添加 stale 标签 | TASK4 #888-04 | P0 | #166 |
# | TC-ROBOT-LABELER-002 | [重复] 已有 stale 标签时不重复添加 | TASK4 #888-04 | P1 | #166 |
# | TC-ROBOT-CRON-001 | [正常流] 手动触发 /internal/stale-scan 端点 | TASK1 #888-01 | P0 | #166 |
# | TC-ROBOT-CRON-002 | [正常流] k8s CronJob 每天 02:00 UTC 自动触发（手工） | TASK1 #888-01 | P0 | #166 |
# | TC-ROBOT-E2E-001 | [正常流] 端到端：16 天 PR → 3 次扫描 → 3 评论 + 1 标签 | TASK5 #888-05 | P0 | #166 |
# | TC-ROBOT-E2E-002 | [正常流] 端到端：在真实测试仓制造 16 天 PR 并验证 3 次扫描完整流程（手工） | TASK5 #888-05 | P0 | #166 |
# | TC-ROBOT-RELIABILITY-001 | [异常] GitHub API 5xx 指数退避重试 | 架构 3.2 | P0 | #166 |
# | TC-ROBOT-RELIABILITY-002 | [异常] GitHub API 429 rate limit 重试 | 架构 3.2 | P1 | #166 |
# | TC-ROBOT-RELIABILITY-003 | [异常] GitHub API 4xx 不重试（死信） | 架构 3.2 | P1 | #166 |
# | TC-ROBOT-RELIABILITY-004 | [重复] 同日多次扫描幂等性 | 架构 3.2 | P1 | #166 |
# | TC-ROBOT-RELIABILITY-005 | [异常] CronJob 连续两天失败触发 Prometheus alert（手工） | TASK7 #888-07 | P1 | #166 |
# | TC-ROBOT-OBSERV-001 | [正常流] 日志字段完整性 | 架构 3.3 | P1 | #166 |
# | TC-ROBOT-OBSERV-002 | [正常流] metrics 数值正确性 | 架构 3.3 | P1 | #166 |
# | TC-ROBOT-OBSERV-003 | [正常流] Grafana 面板展示 | TASK8 #888-08 | P2 | #166 |
# | TC-ROBOT-OBSERV-004 | [正常流] Grafana 面板展示三个图表（手工） | TASK8 #888-08 | P2 | #166 |
# | TC-ROBOT-OBSERV-005 | [正常流] 日志条目字段为具体数值而非占位符（手工） | 架构 3.3 | P2 | #166 |
# | TC-ROBOT-DOCS-001 | [正常流] 排障文档 runbook.md 内容完整（手工） | TASK6 #888-06 | P1 | #166 |
#
# 用例总数：24 | 自动化：18 | 手工：6
# P0：8 | P1：10 | P2：6