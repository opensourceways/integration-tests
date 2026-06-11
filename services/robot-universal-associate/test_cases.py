# -*- coding: utf-8 -*-
"""
测试脚本：PR 关联检查机器人（robot-universal-associate）
被测对象：openeuler-ci-bot
用例数：8（自动化 8 / 手工 0）

平台实测事实：
    - PR 创建时未关联 Issue → 自动添加 needs-issue 标签
    - Bot 发布 "### Linking Issue Notice" 评论 @提及 PR 作者
    - /check-issue 命令重新检查关联（未关联则保留标签+重发评论）
    - /remove-needs-issue 命令移除标签（需仓库成员权限）
    - 评论含: "must be linked to at least one issue"
    - 评论含: "/check-issue" 提示

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-associate/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    _bot_pr_comments,
    _close_pr,
    _create_pr,
    _get_pr,
    _post_pr_comment,
    _pr_labels,
)


WAIT_ASSOCIATE_ROBOT = 12
NEEDS_ISSUE_LABEL = "needs-issue"
LINKING_ISSUE_NOTICE = "### Linking Issue Notice"


# ============================================================================
# 八、PR 关联检查机器人（robot-universal-associate）
# ============================================================================


def test_tc_associate_001_pr_no_issue_gets_label():
    """
    TC-ASSOCIATE-001 [正常流] 未关联Issue的PR自动添加needs-issue标签
    模块：关联检查/自动标签 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 未关联任何 Issue
    操作步骤：GET /pulls/78 检查 labels
    预期结果：labels 包含 "needs-issue"
    """
    detail = _get_pr(78)
    labels = _pr_labels(detail)
    assert NEEDS_ISSUE_LABEL in labels, \
        f"未关联 Issue 的 PR 应有 {NEEDS_ISSUE_LABEL}; 实际={labels}"


def test_tc_associate_002_linking_issue_notice_comment():
    """
    TC-ASSOCIATE-002 [正常流] 未关联Issue时Bot发布Linking Issue Notice评论
    模块：关联检查/反馈评论 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 未关联 Issue
    操作步骤：GET /pulls/78/comments 检查 Bot 评论
    预期结果：Bot 发布包含 "Linking Issue Notice" 的评论
    """
    bot_msgs = _bot_pr_comments(78)
    notice = [m for m in bot_msgs if LINKING_ISSUE_NOTICE in m]
    assert len(notice) >= 1, \
        f"Bot 应发布 Linking Issue Notice; Bot评论数={len(bot_msgs)}"


def test_tc_associate_003_notice_mentions_author():
    """
    TC-ASSOCIATE-003 [正常流] Linking Issue Notice @提及PR作者
    模块：关联检查/评论内容 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 作者为 Coopermassaki
    操作步骤：检查 Linking Issue Notice 评论
    预期结果：评论包含 @Coopermassaki
    """
    bot_msgs = _bot_pr_comments(78)
    notice = [m for m in bot_msgs if LINKING_ISSUE_NOTICE in m]
    assert len(notice) >= 1

    text = notice[-1]
    assert "Coopermassaki" in text, \
        "Linking Issue Notice 应 @提及 PR 作者 Coopermassaki"


def test_tc_associate_004_notice_contains_check_issue_tip():
    """
    TC-ASSOCIATE-004 [正常流] 评论包含/check-issue使用提示
    模块：关联检查/评论内容 | 优先级：P1 | 重要等级：中

    操作步骤：检查 PR#78 的 Linking Issue Notice
    预期结果：评论包含 "/check-issue" 命令提示
    """
    bot_msgs = _bot_pr_comments(78)
    notice = [m for m in bot_msgs if LINKING_ISSUE_NOTICE in m]
    assert len(notice) >= 1

    text = notice[-1]
    assert "/check-issue" in text, \
        "评论应含 /check-issue 命令提示"


def test_tc_associate_005_check_issue_keeps_label_when_no_link():
    """
    TC-ASSOCIATE-005 [正常流] /check-issue 复检未关联PR保留needs-issue
    模块：关联检查/check命令 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 未关联 Issue
    操作步骤：
        1. POST /pulls/78/comments body="/check-issue"
        2. 等待 12s
        3. GET /pulls/78 检查 labels
    预期结果：needs-issue 标签仍在
    """
    _post_pr_comment(78, "/check-issue")
    time.sleep(WAIT_ASSOCIATE_ROBOT)

    detail = _get_pr(78)
    labels = _pr_labels(detail)
    assert NEEDS_ISSUE_LABEL in labels, \
        f"/check-issue 后未关联 Issue 应保留 {NEEDS_ISSUE_LABEL}; 实际={labels}"


def test_tc_associate_006_non_command_no_trigger():
    """
    TC-ASSOCIATE-006 [反向] 非命令评论不触发关联检查
    模块：关联检查/反向 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. 记录 PR#78 Bot Linking Issue 评论数
        2. POST 普通评论
        3. 等待 12s
        4. 检查评论数未增加
    预期结果：Bot 未发布新的 Linking Issue Notice
    """
    bot_msgs = _bot_pr_comments(78)
    count_before = len([m for m in bot_msgs if LINKING_ISSUE_NOTICE in m])

    _post_pr_comment(78, "这个PR我来看看")
    time.sleep(WAIT_ASSOCIATE_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    count_after = len([m for m in bot_msgs if LINKING_ISSUE_NOTICE in m])
    assert count_after == count_before, \
        f"普通评论不应触发新 Notice; before={count_before}, after={count_after}"


def test_tc_associate_007_notice_must_link_text():
    """
    TC-ASSOCIATE-007 [正常流] 评论包含"must be linked to at least one issue"
    模块：关联检查/评论内容 | 优先级：P1 | 重要等级：中

    操作步骤：检查 PR#78 的 Linking Issue Notice
    预期结果：评论含 "must be linked to at least one issue"
    """
    bot_msgs = _bot_pr_comments(78)
    notice = [m for m in bot_msgs if LINKING_ISSUE_NOTICE in m]
    assert len(notice) >= 1

    text = notice[-1]
    assert "must be linked to at least one issue" in text, \
        "评论应含 'must be linked to at least one issue'"


def test_tc_associate_008_new_pr_auto_needs_issue():
    """
    TC-ASSOCIATE-008 [正常流] 新建PR未关联Issue自动添加needs-issue
    模块：关联检查/PR创建 | 优先级：P0 | 重要等级：高

    操作步骤：
        1. 创建 PR（不关联 Issue）
        2. 等待 12s
        3. 检查 labels
    预期结果：labels 包含 "needs-issue"
    """
    resp = _create_pr(
        "TC-ASSOCIATE-008 自动 needs-issue",
        head="test-1",
        body="associate robot test - no linked issue",
    )
    if resp.status_code != 200:
        pytest.skip(f"无法创建 PR: status={resp.status_code}")
    number = resp.json().get("number")

    time.sleep(WAIT_ASSOCIATE_ROBOT)

    detail = _get_pr(number)
    labels = _pr_labels(detail)
    assert NEEDS_ISSUE_LABEL in labels, \
        f"新 PR 未关联 Issue 应有 {NEEDS_ISSUE_LABEL}; 实际={labels}"

    _close_pr(number)


if __name__ == "__main__":
    pytest.main(["-v", __file__])
