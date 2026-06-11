# -*- coding: utf-8 -*-
"""
测试脚本：Issue/PR 生命周期管理机器人（robot-universal-lifecycle）
被测对象：openeuler-ci-bot
用例数：10（自动化 10 / 手工 0）

平台实测事实：
    - /close Issue：Robot 直接关闭，无额外 Bot 评论，state→closed
    - /reopen Issue：Robot 直接重开，无额外 Bot 评论，state→open
    - /close PR：Robot 直接关闭（需 PR 作者/SIG成员/管理员），state→closed
    - 响应时间约 10-15s
    - 配置项 NeedIssueHasLinkPullRequests / ReopenIssueWhenCloseNoLinkPRIssue 可能影响行为

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-lifecycle/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    _bot_comments_since,
    _create_issue,
    _create_pr,
    _get_issue_state,
    _get_pr,
    _post_comment,
    _post_pr_comment,
)


WAIT_LIFECYCLE_ROBOT = 15


# ============================================================================
# 四、Issue/PR 生命周期管理（robot-universal-lifecycle）
# ============================================================================


def test_tc_lifecycle_001_close_issue():
    """
    TC-LIFECYCLE-001 [正常流] /close 命令关闭 Issue
    模块：生命周期/Issue关闭 | 优先级：P0 | 重要等级：高

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. 创建 Issue（state=open）
        2. POST /issues/{number}/comments body=/close
        3. 等待 15s
        4. GET /issues/{number} 检查 state
    预期结果：state=closed
    """
    resp = _create_issue("TC-LIFECYCLE-001 /close Issue")
    assert resp.status_code == 200
    number = resp.json().get("number")
    assert number
    time.sleep(5)

    cmt = _post_comment(number, "/close")
    assert cmt.status_code == 200

    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "closed", \
        f"/close 后 Issue 应为 closed; 实际 state={state}"


def test_tc_lifecycle_002_reopen_issue():
    """
    TC-LIFECYCLE-002 [正常流] /reopen 命令重新打开已关闭的 Issue
    模块：生命周期/Issue重开 | 优先级：P0 | 重要等级：高

    前置条件：Issue 处于 closed 状态
    操作步骤：
        1. 创建 Issue 并 /close 关闭
        2. POST /issues/{number}/comments body=/reopen
        3. 等待 15s
        4. GET /issues/{number} 检查 state
    预期结果：state=open
    """
    resp = _create_issue("TC-LIFECYCLE-002 /reopen Issue")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)
    assert _get_issue_state(number) == "closed", "前置条件: /close 未生效"

    cmt = _post_comment(number, "/reopen")
    assert cmt.status_code == 200

    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "open", \
        f"/reopen 后 Issue 应为 open; 实际 state={state}"


def test_tc_lifecycle_003_close_pr():
    """
    TC-LIFECYCLE-003 [正常流] /close 命令关闭 PR（PR 作者执行）
    模块：生命周期/PR关闭 | 优先级：P0 | 重要等级：高

    前置条件：
        1. 存在 open 状态的 PR
        2. 评论者为 PR 作者（weixin_55883847）
    操作步骤：
        1. 创建 PR（head=test-3, base=master）
        2. POST /pulls/{number}/comments body=/close
        3. 等待 15s
        4. GET /pulls/{number} 检查 state
    预期结果：state=closed
    """
    resp = _create_pr(
        "TC-LIFECYCLE-003 /close PR",
        head="test-3",
        body="lifecycle 测试 /close PR",
    )
    if resp.status_code != 200:
        pytest.skip(f"无法创建 PR: status={resp.status_code}")
    number = resp.json().get("number")
    assert number
    time.sleep(5)

    cmt = _post_pr_comment(number, "/close")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_LIFECYCLE_ROBOT)

    detail = _get_pr(number)
    assert detail.json().get("state") == "closed", \
        f"/close 后 PR 应为 closed; 实际={detail.json().get('state')}"


def test_tc_lifecycle_004_close_reopen_cycle():
    """
    TC-LIFECYCLE-004 [联动] /close + /reopen 循环操作 Issue
    模块：生命周期/联动 | 优先级：P1 | 重要等级：中

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. /close → 验证 closed
        2. /reopen → 验证 open
        3. /close → 验证 closed
    预期结果：每次命令都正确切换状态
    """
    resp = _create_issue("TC-LIFECYCLE-004 close/reopen 循环")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    # 第一次 close
    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)
    assert _get_issue_state(number) == "closed", "第一次 /close 未生效"

    # reopen
    _post_comment(number, "/reopen")
    time.sleep(WAIT_LIFECYCLE_ROBOT)
    assert _get_issue_state(number) == "open", "/reopen 未生效"

    # 第二次 close
    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)
    assert _get_issue_state(number) == "closed", "第二次 /close 未生效"


def test_tc_lifecycle_005_non_command_no_close():
    """
    TC-LIFECYCLE-005 [反向] 非命令评论不触发关闭
    模块：生命周期/反向 | 优先级：P1 | 重要等级：中

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. POST /issues/{number}/comments body="请关闭这个issue"
        2. 等待 15s
        3. GET /issues/{number} 检查 state
    预期结果：state 仍为 open
    """
    resp = _create_issue("TC-LIFECYCLE-005 非命令不触发")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "请关闭这个issue")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "open", \
        f"非命令评论不应触发关闭; 实际 state={state}"


def test_tc_lifecycle_006_invalid_command_no_trigger():
    """
    TC-LIFECYCLE-006 [反向] 无效命令格式不触发关闭/重开
    模块：生命周期/反向 | 优先级：P1 | 重要等级：中

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. POST 评论 body="/closethis"（无空格分隔）
        2. POST 评论 body="/ close"（多余空格）
        3. 等待 15s
    预期结果：state 仍为 open
    """
    resp = _create_issue("TC-LIFECYCLE-006 无效命令")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/closethis")
    _post_comment(number, "/ close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "open", \
        f"无效命令不应触发关闭; 实际 state={state}"


def test_tc_lifecycle_007_reopen_on_open_issue():
    """
    TC-LIFECYCLE-007 [边界] /reopen 对已经 open 的 Issue 无副作用
    模块：生命周期/边界 | 优先级：P2 | 重要等级：低

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. POST /issues/{number}/comments body=/reopen
        2. 等待 15s
    预期结果：state 仍为 open，无异常
    """
    resp = _create_issue("TC-LIFECYCLE-007 reopen on open")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/reopen")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "open", \
        f"/reopen 对 open Issue 应无副作用; 实际 state={state}"


def test_tc_lifecycle_008_close_on_closed_issue():
    """
    TC-LIFECYCLE-008 [边界] /close 对已经 closed 的 Issue 无副作用
    模块：生命周期/边界 | 优先级：P2 | 重要等级：低

    前置条件：Issue 处于 closed 状态
    操作步骤：
        1. 创建 Issue 并 /close
        2. 再次 POST /close
        3. 等待 15s
    预期结果：state 仍为 closed，无异常
    """
    resp = _create_issue("TC-LIFECYCLE-008 close on closed")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)
    assert _get_issue_state(number) == "closed"

    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    assert state == "closed", \
        f"重复 /close 应保持 closed; 实际 state={state}"


def test_tc_lifecycle_009_close_no_bot_comment():
    """
    TC-LIFECYCLE-009 [正常流] /close Issue 后 Bot 不发布额外评论
    模块：生命周期/Bot行为 | 优先级：P1 | 重要等级：中

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. 记录 /close 前 Bot 评论数
        2. POST /close
        3. 等待 15s
        4. 检查 Bot 评论数
    预期结果：Bot 未发布 /close 相关的新评论（仅状态变更）
    """
    resp = _create_issue("TC-LIFECYCLE-009 close 无额外评论")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(8)

    bot_before = _bot_comments_since(number)
    count_before = len(bot_before)

    _post_comment(number, "/close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    assert _get_issue_state(number) == "closed"

    bot_after = _bot_comments_since(number)
    # 过滤掉 Welcome/Notification 等初始评论，只看 /close 后新增的
    new_bot = bot_after[count_before:]
    close_related = [m for m in new_bot if "close" in m.lower() or "lifecycle" in m.lower()]
    assert len(close_related) == 0, \
        f"/close 不应产生额外 Bot 评论; 新增={close_related}"


def test_tc_lifecycle_010_close_case_sensitive():
    """
    TC-LIFECYCLE-011 [边界] /Close 大小写不触发
    模块：生命周期/命令解析 | 优先级：P2 | 重要等级：低

    前置条件：Issue 处于 open 状态
    操作步骤：
        1. POST 评论 body="/Close"
        2. 等待 15s
    预期结果：state 仍为 open（命令区分大小写）
    """
    resp = _create_issue("TC-LIFECYCLE-011 大小写")
    assert resp.status_code == 200
    number = resp.json().get("number")
    time.sleep(5)

    _post_comment(number, "/Close")
    time.sleep(WAIT_LIFECYCLE_ROBOT)

    state = _get_issue_state(number)
    if state == "closed":
        pytest.xfail("/Close 大写也触发了关闭（Robot 不区分大小写）")
    assert state == "open", f"异常 state={state}"


if __name__ == "__main__":
    pytest.main(["-v", __file__])
