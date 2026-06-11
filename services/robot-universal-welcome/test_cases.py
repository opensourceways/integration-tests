# -*- coding: utf-8 -*-
"""
测试脚本：社区欢迎机器人（robot-universal-welcome）
被测对象：openeuler-ci-bot
用例数：8（自动化 8 / 手工 0）

平台实测事实：
    - Bot 欢迎评论标题: "### Welcome To openEuler Community"
    - Bot 欢迎评论含: "Hey [@用户名](...), thanks for your contribution"
    - Bot 欢迎评论含: "#### Bot Usage Manual" + 命令文档链接
    - Bot 欢迎评论含: "#### Contact Guide" + SIG 信息 + Maintainers
    - 自动添加 sig 标签: "sig/sig-infrastructure-cache"
    - 响应时间约 8-12s

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-welcome/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    _bot_comments_since,
    _bot_pr_comments,
    _close_pr,
    _create_issue,
    _create_pr,
    _get_issue,
    _get_pr,
    _post_comment,
    _pr_labels,
)


WAIT_WELCOME_ROBOT = 12
SIG_LABEL = "sig/sig-infrastructure-cache"
WELCOME_TITLE = "### Welcome To openEuler Community"


# ============================================================================
# 五、社区欢迎机器人（robot-universal-welcome）
# ============================================================================


def test_tc_welcome_001_issue_welcome_comment():
    """
    TC-WELCOME-001 [正常流] 创建Issue时Bot自动发送欢迎评论
    模块：欢迎机器人/Issue欢迎 | 优先级：P0 | 重要等级：高

    前置条件：用户为仓库贡献者
    操作步骤：
        1. POST 创建 Issue
        2. 等待 12s
        3. GET /issues/{number}/comments 过滤 Bot 评论
    预期结果：Bot 发布包含 "Welcome To openEuler Community" 的欢迎评论
    """
    resp = _create_issue("TC-WELCOME-001 欢迎评论验证")
    assert resp.status_code == 200
    number = resp.json().get("number")
    assert number

    time.sleep(WAIT_WELCOME_ROBOT)

    bot_msgs = _bot_comments_since(number)
    welcome_msgs = [m for m in bot_msgs if WELCOME_TITLE in m]
    assert len(welcome_msgs) >= 1, \
        f"Bot 未发布欢迎评论; Bot 评论数={len(bot_msgs)}"


def test_tc_welcome_002_welcome_mentions_user(my_login):
    """
    TC-WELCOME-002 [正常流] 欢迎评论中@提及Issue作者
    模块：欢迎机器人/评论内容 | 优先级：P0 | 重要等级：高

    前置条件：用户创建 Issue
    操作步骤：
        1. 创建 Issue
        2. 等待 12s
        3. 检查欢迎评论中是否含 @用户名
    预期结果：评论包含 @weixin_55883847
    """
    resp = _create_issue("TC-WELCOME-002 用户提及验证")
    assert resp.status_code == 200
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    bot_msgs = _bot_comments_since(number)
    welcome_msgs = [m for m in bot_msgs if WELCOME_TITLE in m]
    assert len(welcome_msgs) >= 1
    assert my_login in welcome_msgs[0], \
        f"欢迎评论未 @提及用户 {my_login}"


def test_tc_welcome_003_welcome_contains_bot_manual():
    """
    TC-WELCOME-003 [正常流] 欢迎评论包含Bot使用手册链接
    模块：欢迎机器人/评论内容 | 优先级：P1 | 重要等级：中

    操作步骤：创建 Issue → 检查欢迎评论
    预期结果：评论包含 "Bot Usage Manual" 和命令文档链接
    """
    resp = _create_issue("TC-WELCOME-003 Bot手册验证")
    assert resp.status_code == 200
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    bot_msgs = _bot_comments_since(number)
    welcome_msgs = [m for m in bot_msgs if WELCOME_TITLE in m]
    assert len(welcome_msgs) >= 1

    text = welcome_msgs[0]
    assert "Bot Usage Manual" in text, \
        "欢迎评论应含 'Bot Usage Manual'"
    assert "command" in text.lower(), \
        "欢迎评论应含命令文档链接"


def test_tc_welcome_004_welcome_contains_contact_guide():
    """
    TC-WELCOME-004 [正常流] 欢迎评论包含联系指南（SIG+Maintainers）
    模块：欢迎机器人/评论内容 | 优先级：P1 | 重要等级：中

    操作步骤：创建 Issue → 检查欢迎评论
    预期结果：评论包含 SIG名称或联系人信息
    """
    resp = _create_issue("TC-WELCOME-004 联系指南验证")
    assert resp.status_code == 200
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT + 3)

    bot_msgs = _bot_comments_since(number)
    welcome_msgs = [m for m in bot_msgs if WELCOME_TITLE in m]
    assert len(welcome_msgs) >= 1

    text = welcome_msgs[0]
    assert "sig-infrastructure-cache" in text or "Contact" in text, \
        "欢迎评论应含 SIG 名称或联系信息"


def test_tc_welcome_005_auto_sig_label():
    """
    TC-WELCOME-005 [正常流] 创建Issue时自动添加sig标签
    模块：欢迎机器人/自动标签 | 优先级：P0 | 重要等级：高

    操作步骤：创建 Issue → 等待 → 检查 labels
    预期结果：labels 包含 "sig/sig-infrastructure-cache"
    """
    resp = _create_issue("TC-WELCOME-005 sig标签验证")
    assert resp.status_code == 200
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    detail = _get_issue(number)
    labels = [l.get("name") for l in (detail.json().get("labels") or [])]
    assert SIG_LABEL in labels, \
        f"Issue 应自动添加 {SIG_LABEL}; 实际 labels={labels}"


def test_tc_welcome_006_no_duplicate_welcome():
    """
    TC-WELCOME-006 [反向] 对同一Issue评论不会重复发送欢迎
    模块：欢迎机器人/去重 | 优先级：P1 | 重要等级：中

    操作步骤：
        1. 创建 Issue → 等待欢迎评论
        2. 再次评论触发事件
        3. 检查欢迎评论数量
    预期结果：仅有 1 条欢迎评论（不重复）
    """
    resp = _create_issue("TC-WELCOME-006 不重复欢迎")
    assert resp.status_code == 200
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    # 用户再发一条评论
    _post_comment(number, "这是一条普通评论")
    time.sleep(WAIT_WELCOME_ROBOT)

    bot_msgs = _bot_comments_since(number)
    welcome_count = len([m for m in bot_msgs if WELCOME_TITLE in m])
    assert welcome_count == 1, \
        f"欢迎评论应仅 1 条; 实际={welcome_count}"


def test_tc_welcome_007_pr_welcome_comment():
    """
    TC-WELCOME-007 [正常流] 创建PR时Bot自动发送欢迎评论
    模块：欢迎机器人/PR欢迎 | 优先级：P0 | 重要等级：高

    操作步骤：
        1. 创建 PR（head=test-3, base=master）
        2. 等待 12s
        3. GET /pulls/{number}/comments 过滤 Bot 评论
    预期结果：Bot 发布包含 "Welcome To openEuler Community" 的欢迎评论
    """
    resp = _create_pr(
        "TC-WELCOME-007 PR欢迎评论",
        head="test-3",
        body="welcome robot PR test",
    )
    if resp.status_code != 200:
        pytest.skip(f"无法创建 PR: status={resp.status_code}")
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    bot_msgs = _bot_pr_comments(number)
    welcome_msgs = [m for m in bot_msgs if WELCOME_TITLE in m]
    assert len(welcome_msgs) >= 1, \
        f"PR 未收到欢迎评论; Bot 评论数={len(bot_msgs)}"

    _close_pr(number)


def test_tc_welcome_008_pr_auto_sig_label():
    """
    TC-WELCOME-008 [正常流] 创建PR时自动添加sig标签
    模块：欢迎机器人/PR自动标签 | 优先级：P0 | 重要等级：高

    操作步骤：
        1. 创建 PR
        2. 等待 12s
        3. GET /pulls/{number} 检查 labels
    预期结果：labels 包含 "sig/sig-infrastructure-cache"
    """
    resp = _create_pr(
        "TC-WELCOME-008 PR sig标签",
        head="test-2",
        body="welcome robot PR label test",
    )
    if resp.status_code != 200:
        pytest.skip(f"无法创建 PR: status={resp.status_code}")
    number = resp.json().get("number")

    time.sleep(WAIT_WELCOME_ROBOT)

    detail = _get_pr(number)
    labels = _pr_labels(detail)
    assert SIG_LABEL in labels, \
        f"PR 应自动添加 {SIG_LABEL}; 实际 labels={labels}"

    _close_pr(number)


if __name__ == "__main__":
    pytest.main(["-v", __file__])
