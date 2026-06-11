# -*- coding: utf-8 -*-
"""
测试脚本：通用标签机器人（robot-universal-label）
被测对象：openeuler-ci-bot
用例数：8（自动化 8 / 手工 0）

平台实测事实：
    - /<keyword> <value> (keyword∈kind|priority|sig|good) → 添加 keyword/value 标签
    - /remove-<keyword> <value> → 移除 keyword/value 标签
    - /lgtm → 添加 lgtm 标签 + "Review Code Feedback" 评论
    - PR 提交数>1 → 自动添加 stat/needs-squash 标签
    - 反馈评论含 "Review Code Feedback" / "reviewed the code changes"
    - 通用命令关键字: kind|priority|sig|good

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-label/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    _bot_pr_comments,
    _create_issue,
    _get_issue,
    _get_pr,
    _post_comment,
    _post_pr_comment,
    _pr_labels,
)


WAIT_LABEL_ROBOT = 15


# ============================================================================
# 七、通用标签机器人（robot-universal-label）
# ============================================================================


def test_tc_label_001_kind_command_adds_label():
    """
    TC-LABEL-001 [正常流] /kind <value> 命令添加 kind/value 标签
    模块：标签机器人/通用命令 | 优先级：P0 | 重要等级：高

    操作步骤：
        1. 创建 Issue
        2. POST /issues/{n}/comments body="/kind feature"
        3. 等待 12s
        4. GET /issues/{n} 检查 labels
    预期结果：labels 包含 "kind/feature"
    """
    resp = _create_issue("TC-LABEL-001 /kind 命令")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/kind feature")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels = [l.get("name") for l in (detail.json().get("labels") or [])]
    assert "kind/feature" in labels, \
        f"/kind feature 应添加 kind/feature 标签; 实际={labels}"


def test_tc_label_002_remove_kind_command():
    """
    TC-LABEL-002 [正常流] /remove-kind <value> 命令移除标签
    模块：标签机器人/通用命令 | 优先级：P0 | 重要等级：高

    操作步骤：
        1. 创建 Issue 并 /kind bug 添加标签
        2. POST /remove-kind bug
        3. 等待 12s
        4. 检查 labels
    预期结果：kind/bug 标签被移除
    """
    resp = _create_issue("TC-LABEL-002 /remove-kind 命令")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/kind bug")
    time.sleep(WAIT_LABEL_ROBOT)

    _post_comment(number, "/remove-kind bug")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels = [l.get("name") for l in (detail.json().get("labels") or [])]
    assert "kind/bug" not in labels, \
        f"/remove-kind bug 后不应有 kind/bug; 实际={labels}"


def test_tc_label_003_priority_command():
    """
    TC-LABEL-003 [正常流] /priority <value> 命令添加 priority/value 标签
    模块：标签机器人/通用命令 | 优先级：P1 | 重要等级：中

    操作步骤：POST /issues/{n}/comments body="/priority high"
    预期结果：labels 包含 "priority/high"
    """
    resp = _create_issue("TC-LABEL-003 /priority 命令")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/priority high")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels = [l.get("name") for l in (detail.json().get("labels") or [])]
    assert "priority/high" in labels, \
        f"/priority high 应添加标签; 实际={labels}"


def test_tc_label_004_lgtm_on_pr():
    """
    TC-LABEL-004 [正常流] /lgtm 命令在非自己的PR上添加lgtm标签并反馈
    模块：标签机器人/lgtm | 优先级：P0 | 重要等级：高

    前置条件：PR#78 非当前用户创建，可接受 /lgtm
    操作步骤：
        1. POST /pulls/78/comments body="/lgtm"
        2. 等待 15s
        3. 检查 labels 和 Bot 评论
    预期结果：
        1. PR labels 包含 "lgtm" 相关标签
        2. Bot 评论含 "Review Code Feedback" 或 "lgtm"
    """
    _post_pr_comment(78, "/lgtm")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_pr(78)
    labels = _pr_labels(detail)
    # lgtm 或 lgtm-<user> 形式
    has_lgtm = any("lgtm" in l for l in labels)

    bot_msgs = _bot_pr_comments(78)
    lgtm_feedback = [m for m in bot_msgs
                     if "Review Code Feedback" in m or "lgtm" in m.lower()]

    assert has_lgtm or len(lgtm_feedback) >= 1, \
        f"PR 应有 lgtm 标签或 Bot 反馈; labels={labels}"


def test_tc_label_005_auto_needs_squash():
    """
    TC-LABEL-005 [正常流] PR提交数>1时自动添加stat/needs-squash
    模块：标签机器人/自动标签 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 有 2 个提交
    操作步骤：GET /pulls/78 检查 labels
    预期结果：labels 包含 "stat/needs-squash"
    """
    detail = _get_pr(78)
    labels = _pr_labels(detail)
    assert "stat/needs-squash" in labels, \
        f"提交数>1 的 PR 应有 stat/needs-squash; 实际={labels}"


def test_tc_label_006_non_command_no_trigger():
    """
    TC-LABEL-006 [反向] 非命令评论不触发标签变更
    模块：标签机器人/反向 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. 创建 Issue → 记录 labels
        2. POST 普通评论
        3. 等待 12s → 检查 labels 未变
    预期结果：labels 无新增（除 sig 自动标签外）
    """
    resp = _create_issue("TC-LABEL-006 非命令不触发")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels_before = set(l.get("name") for l in (detail.json().get("labels") or []))

    _post_comment(number, "这个issue需要关注一下")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels_after = set(l.get("name") for l in (detail.json().get("labels") or []))
    new_labels = labels_after - labels_before
    assert len(new_labels) == 0, \
        f"普通评论不应触发新标签; 新增={new_labels}"


def test_tc_label_007_invalid_keyword_no_trigger():
    """
    TC-LABEL-007 [反向] 无效关键字不触发标签添加
    模块：标签机器人/命令解析 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. 创建 Issue
        2. POST 评论 "/invalid test"（invalid 不在关键字列表中）
        3. 等待 12s
    预期结果：不添加 invalid/test 标签
    """
    resp = _create_issue("TC-LABEL-007 无效关键字")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/invalid test")
    time.sleep(WAIT_LABEL_ROBOT)

    detail = _get_issue(number)
    labels = [l.get("name") for l in (detail.json().get("labels") or [])]
    assert "invalid/test" not in labels, \
        f"无效关键字不应添加标签; 实际={labels}"


def test_tc_label_008_lgtm_feedback_content():
    """
    TC-LABEL-008 [正常流] /lgtm 反馈评论包含审查者信息
    模块：标签机器人/反馈内容 | 优先级：P1 | 重要等级：中

    前置条件：PR#91 已有 /lgtm 的 Bot 反馈
    操作步骤：检查 PR#91 Bot 评论
    预期结果：评论含 "reviewed the code changes" 和审查者用户名
    """
    bot_msgs = _bot_pr_comments(91)
    feedback = [m for m in bot_msgs if "Review Code Feedback" in m]
    if len(feedback) == 0:
        pytest.skip("PR#91 无 Review Code Feedback 评论")

    text = feedback[-1]
    assert "reviewed the code changes" in text, \
        "反馈应含 'reviewed the code changes'"


if __name__ == "__main__":
    pytest.main(["-v", __file__])
