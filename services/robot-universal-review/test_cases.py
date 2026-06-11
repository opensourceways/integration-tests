# -*- coding: utf-8 -*-
"""
测试脚本：PR 自动审查合并机器人（robot-universal-review）
被测对象：openeuler-ci-bot
用例数：8（自动化 8 / 手工 0）

平台实测事实：
    - /check-pr 命令触发 PR 合并检查
    - 条件不满足时 Bot 发布 "### Merge Verification Failed" 评论
    - 反馈含: "Not Enough Labels" / "Label BlockList" / "Label Usage Tips"
    - 需要的标签: openeuler-cla/yes, approved, gate_check_pass, lgtm(x2)
    - Bot 评论 @提及命令发起者
    - 非 /check-pr 事件不生成反馈评论

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-review/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    _bot_pr_comments,
    _get_pr,
    _post_pr_comment,
    _pr_labels,
)


WAIT_REVIEW_ROBOT = 15


# ============================================================================
# 六、PR 自动审查合并机器人（robot-universal-review）
# ============================================================================


def test_tc_review_001_check_pr_feedback_comment():
    """
    TC-REVIEW-001 [正常流] /check-pr 命令触发合并检查并返回反馈
    模块：PR审查/check-pr命令 | 优先级：P0 | 重要等级：高

    前置条件：PR 缺少必需标签（不满足合并条件）
    操作步骤：
        1. POST /pulls/78/comments body=/check-pr
        2. 等待 15s
        3. GET /pulls/78/comments 检查 Bot 评论
    预期结果：Bot 发布 "Merge Verification Failed" 反馈评论
    """
    cmt = _post_pr_comment(78, "/check-pr")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_REVIEW_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    feedback = [m for m in bot_msgs if "Merge Verification Failed" in m]
    assert len(feedback) >= 1, \
        f"/check-pr 后应有 Merge Verification Failed 评论; Bot评论数={len(bot_msgs)}"


def test_tc_review_002_feedback_mentions_commenter(my_login):
    """
    TC-REVIEW-002 [正常流] 反馈评论@提及命令发起者
    模块：PR审查/反馈内容 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 不满足合并条件
    操作步骤：检查最新的 Merge Verification Failed 评论
    预期结果：评论包含 @weixin_55883847
    """
    bot_msgs = _bot_pr_comments(78)
    feedback = [m for m in bot_msgs if "Merge Verification Failed" in m]
    assert len(feedback) >= 1

    latest = feedback[-1]
    assert my_login in latest, \
        f"反馈评论应 @提及 {my_login}"


def test_tc_review_003_feedback_not_enough_labels():
    """
    TC-REVIEW-003 [正常流] 反馈评论包含 Not Enough Labels 信息
    模块：PR审查/标签检查 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 缺少 openeuler-cla/yes 等标签
    操作步骤：检查 Merge Verification Failed 评论内容
    预期结果：包含 "Not Enough Labels" 和缺少的标签名
    """
    bot_msgs = _bot_pr_comments(78)
    feedback = [m for m in bot_msgs if "Merge Verification Failed" in m]
    assert len(feedback) >= 1

    text = feedback[-1]
    assert "Not Enough Labels" in text, \
        "反馈应含 'Not Enough Labels'"
    assert "openeuler-cla/yes" in text, \
        "反馈应列出缺少的 openeuler-cla/yes 标签"


def test_tc_review_004_feedback_label_usage_tips():
    """
    TC-REVIEW-004 [正常流] 反馈评论包含 Label Usage Tips
    模块：PR审查/标签提示 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 有缺少的标签
    操作步骤：检查 Merge Verification Failed 评论
    预期结果：包含 "Label Usage Tips" 和标签说明
    """
    bot_msgs = _bot_pr_comments(78)
    feedback = [m for m in bot_msgs if "Merge Verification Failed" in m]
    assert len(feedback) >= 1

    text = feedback[-1]
    assert "Label Usage Tips" in text, \
        "反馈应含 'Label Usage Tips'"


def test_tc_review_005_non_check_pr_no_feedback():
    """
    TC-REVIEW-005 [反向] 非/check-pr评论不触发审查反馈
    模块：PR审查/命令识别 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. 记录当前 Merge Verification 评论数
        2. POST 普通评论
        3. 等待 15s
        4. 检查评论数未增加
    预期结果：Bot 未发布新的审查反馈
    """
    bot_msgs = _bot_pr_comments(78)
    count_before = len([m for m in bot_msgs if "Merge Verification" in m])

    _post_pr_comment(78, "这个PR还需要改进一下")
    time.sleep(WAIT_REVIEW_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    count_after = len([m for m in bot_msgs if "Merge Verification" in m])
    assert count_after == count_before, \
        f"普通评论不应触发审查反馈; before={count_before}, after={count_after}"


def test_tc_review_006_invalid_command_no_trigger():
    """
    TC-REVIEW-006 [反向] 无效命令格式不触发审查
    模块：PR审查/命令解析 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. POST 评论 "/checkpr"（无连字符）
        2. 等待 15s
    预期结果：Bot 未发布新审查反馈
    """
    bot_msgs = _bot_pr_comments(78)
    count_before = len([m for m in bot_msgs if "Merge Verification" in m])

    _post_pr_comment(78, "/checkpr")
    time.sleep(WAIT_REVIEW_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    count_after = len([m for m in bot_msgs if "Merge Verification" in m])
    assert count_after == count_before, \
        f"/checkpr 不应触发审查; before={count_before}, after={count_after}"


def test_tc_review_007_check_pr_multiline():
    """
    TC-REVIEW-007 [正常流] 多行评论中包含/check-pr仍触发
    模块：PR审查/命令解析 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 不满足合并条件
    操作步骤：
        1. POST 评论含多行文本，其中一行为 /check-pr
        2. 等待 15s
        3. 检查 Bot 反馈
    预期结果：Bot 发布 Merge Verification Failed 评论
    """
    bot_msgs = _bot_pr_comments(78)
    count_before = len([m for m in bot_msgs if "Merge Verification" in m])

    _post_pr_comment(78, "请帮忙检查一下\n/check-pr\n谢谢")
    time.sleep(WAIT_REVIEW_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    count_after = len([m for m in bot_msgs if "Merge Verification" in m])
    assert count_after > count_before, \
        f"多行评论含 /check-pr 应触发审查; before={count_before}, after={count_after}"


def test_tc_review_008_check_pr_on_satisfied_pr():
    """
    TC-REVIEW-008 [正常流] /check-pr 反馈仅列出实际缺失的标签
    模块：PR审查/部分满足 | 优先级：P1 | 重要等级：中

    前置条件：PR#62 有部分标签
    操作步骤：
        1. GET PR#62 当前 labels
        2. POST /check-pr on PR#62
        3. 等待 15s
        4. 检查反馈中不包含已有标签的缺失提示
    预期结果：已有的标签不出现在 "Not Enough Labels" 中
    """
    # 先获取当前标签
    detail = _get_pr(62)
    current_labels = _pr_labels(detail)

    cmt = _post_pr_comment(62, "/check-pr")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_REVIEW_ROBOT)

    bot_msgs = _bot_pr_comments(62)
    feedback = [m for m in bot_msgs if "Merge Verification" in m]
    if len(feedback) == 0:
        pytest.skip("PR#62 可能已满足所有条件（无反馈）")

    text = feedback[-1]
    # 已有的标签不应出现在 "needs ... labels, but now gets 0" 中
    for label in current_labels:
        not_enough = [l for l in text.split("\n")
                      if label in l and "needs" in l and "gets **0**" in l]
        assert len(not_enough) == 0, \
            f"已有标签 {label} 不应出现在缺失列表中"


if __name__ == "__main__":
    pytest.main(["-v", __file__])
