# -*- coding: utf-8 -*-
"""
测试脚本：Universal Issue Assign Robot
被测对象：openeuler-ci-bot（评论命令管理负责人 /assign /unassign）
用例数：7（自动化 7 / 手工 0）

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-assign/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    DEFAULT_ASSIGNEE,
    WAIT_AFTER_WEBHOOK,
    _assignee_login,
    _bot_comments_since,
    _create_issue,
    _get_issue,
    _list_comments,
    _patch_issue,
    _post_comment,
)
from common import BOT_LOGIN


# ============================================================================
# 一、评论命令管理负责人（/assign /unassign）
# ============================================================================


def test_tc_api_assign_001_already_assigned_no_overwrite(my_login):
    """
    TC-API-ASSIGN-002 [反向] 创建时 body 已含 assignee 时不覆盖
    模块：自动分配/POST /issues | 优先级：P0 | 重要等级：高

    前置条件：
        1. repoConfig.default_assignee=Guangyue-Xu（实测）
        2. weixin_55883847 与 Guangyue-Xu 均为协作者
    操作步骤：
        1. POST issues，body 已含 assignee=<self>
        2. 等待 15s
        3. GET issues/{number}
        4. GET issues/{number}/comments
    预期结果：
        1. 创建 HTTP 200，body.number 非空
        2. 详情 assignee.login=<self>，未被覆盖
        3. 评论列表无机器人默认分配评论
    """
    resp = _create_issue(
        "TC-API-ASSIGN-002 已指派不覆盖",
        body="接口自动化用例，验证 Robot 不覆盖已指派 assignee",
        assignee=my_login,
    )
    assert resp.status_code == 200
    number = resp.json().get("number")
    assert number, "未拿到 issue number"
    assert _assignee_login(resp) == my_login

    time.sleep(WAIT_AFTER_WEBHOOK + 3)

    detail = _get_issue(number)
    assert detail.status_code == 200
    assert _assignee_login(detail) == my_login, \
        f"创建时已指派的 assignee 被 Robot 覆盖：{_assignee_login(detail)}"

    bot_msgs = _bot_comments_since(number)
    # 不应出现"默认分配通知"（核心子串 default assignee）
    assert not any("default assignee" in m.lower() for m in bot_msgs), \
        f"Robot 不应对已指派 Issue 发默认分配通知；Bot 评论={bot_msgs}"


def test_tc_api_assign_002_patch_not_trigger(my_login):
    """
    TC-API-ASSIGN-006 [反向][联动] PATCH 更新 Issue 不触发默认分配
    模块：自动分配/PATCH /issues | 优先级：P1 | 重要等级：中

    前置：已存在 Issue，assignee=<self>
    步骤：PATCH 更新 title/body → 等 12s → GET 详情 + 评论列表
    预期：assignee 不变 + 评论列表中无新增 Bot 评论
    """
    # 准备已指派的 Issue
    prep = _create_issue(
        "TC-API-ASSIGN-006 准备 Issue",
        body="prepare",
        assignee=my_login,
    )
    assert prep.status_code == 200
    number = prep.json().get("number")
    time.sleep(5)  # 等潜在 robot 处理稳定

    # 记录 PATCH 前 Bot 评论数与最后时间戳
    list_before = _list_comments(number).json()
    bot_count_before = len([
        c for c in list_before if isinstance(c, dict)
        and (c.get("user") or {}).get("login") == BOT_LOGIN
    ])
    last_ts_before = max(
        (c.get("created_at", "") for c in list_before
         if isinstance(c, dict) and (c.get("user") or {}).get("login") == BOT_LOGIN),
        default="",
    )

    # PATCH 更新
    patch = _patch_issue(number, title="TC-API-ASSIGN-006 更新触发", body="updated body")
    assert patch.status_code == 200

    time.sleep(WAIT_AFTER_WEBHOOK)

    detail = _get_issue(number)
    assert _assignee_login(detail) == my_login, \
        f"PATCH 更新意外触发了 assignee 变化：{_assignee_login(detail)}"

    bot_msgs_after = _bot_comments_since(number, since_iso=last_ts_before)
    assign_related = [m for m in bot_msgs_after if "assign" in m.lower()]
    assert len(assign_related) == 0, \
        f"PATCH 更新触发了 assign 相关 Bot 评论：{assign_related}"


def test_tc_api_cmd_001_assign_self(my_login):
    """
    TC-API-CMD-001 [正常流] /assign 无参时将评论者自身设为负责人
    模块：评论命令/POST /comments | 优先级：P0 | 重要等级：高

    前置：enable_issue_assign=true，已创建 Issue，PAT 持有人为协作者
    步骤：POST /comments body=/assign → 等 12s → GET 详情 + 评论
    预期：
        1. 评论 HTTP 200，body.id 非空
        2. assignee.login=<self>
        3. 本次 /assign 之后无 Bot 附加评论
    """
    create = _create_issue("TC-API-CMD-001 /assign 自身")
    assert create.status_code == 200
    number = create.json().get("number")
    time.sleep(5)  # 等默认分配先发生

    cmt = _post_comment(number, "/assign")
    assert cmt.status_code == 200, f"评论创建失败 status={cmt.status_code}"
    assert cmt.json().get("id"), "评论 body.id 为空"
    cmt_created_at = cmt.json().get("created_at", "")

    time.sleep(WAIT_AFTER_WEBHOOK)

    detail = _get_issue(number)
    assert _assignee_login(detail) == my_login, \
        f"/assign 自身后 assignee={_assignee_login(detail)} 不等于 {my_login}"

    # 本次 /assign 之后不应有 assign 相关 Bot 新评论
    bot_after = _bot_comments_since(number, since_iso=cmt_created_at)
    assign_related = [m for m in bot_after if "assign" in m.lower()]
    assert len(assign_related) == 0, f"/assign 自身触发了 assign Bot 评论：{assign_related}"


def test_tc_api_cmd_002_assign_repeat(my_login):
    """
    TC-API-CMD-004 [反向][唯一性] 重复分配同一负责人返回 msg_assign_repeatedly
    模块：评论命令/POST /comments | 优先级：P1 | 重要等级：中

    前置：Issue.assignee=<self>
    步骤：POST /comments body=/assign @<self> → 等 12s
    预期：Bot 评论含 "already assigned to" + "<self>" + "do not assign repeatedly"
    """
    create = _create_issue("TC-API-CMD-004 重复分配")
    number = create.json().get("number")
    time.sleep(5)

    # 先把 assignee 设为自己
    _post_comment(number, "/assign")
    time.sleep(WAIT_AFTER_WEBHOOK)
    assert _assignee_login(_get_issue(number)) == my_login

    # 再次分配同一人
    cmt = _post_comment(number, f"/assign @{my_login}")
    assert cmt.status_code == 200
    cmt_created_at = cmt.json().get("created_at", "")
    time.sleep(WAIT_AFTER_WEBHOOK)

    assert _assignee_login(_get_issue(number)) == my_login, \
        "重复分配后 assignee 变化了"

    bot_msgs = _bot_comments_since(number, since_iso=cmt_created_at)
    text = "\n".join(bot_msgs)
    assert "already assigned to" in text, f"未找到重复分配提示；Bot={bot_msgs}"
    assert my_login in text, f"重复分配提示未含用户名 {my_login}"
    assert "do not assign repeatedly" in text, \
        f"未找到 do not assign repeatedly 子串；Bot={bot_msgs}"


def test_tc_api_cmd_003_assign_non_member():
    """
    TC-API-CMD-005 [权限][反向] /assign 指定非协作者返回 msg_not_allow_assign
    模块：评论命令/POST /comments | 优先级：P1 | 重要等级：高

    前置：xiaoguozhi34 用户存在但非该仓库协作者（实测确认）
    步骤：POST /comments body=/assign @xiaoguozhi34
    预期：
        1. Bot 评论含 "can not be assigned to ***xiaoguozhi34***"
        2. assignee 未被设为 xiaoguozhi34
    """
    create = _create_issue("TC-API-CMD-005 /assign 非协作者")
    number = create.json().get("number")
    time.sleep(5)
    assignee_before = _assignee_login(_get_issue(create.json().get("number")))

    cmt = _post_comment(number, "/assign @xiaoguozhi34")
    assert cmt.status_code == 200
    cmt_created_at = cmt.json().get("created_at", "")
    time.sleep(WAIT_AFTER_WEBHOOK)

    detail = _get_issue(number)
    assert _assignee_login(detail) != "xiaoguozhi34", \
        "非协作者 xiaoguozhi34 不应被分配为 assignee"
    assert _assignee_login(detail) == assignee_before, \
        f"assignee 不应变化：before={assignee_before}, after={_assignee_login(detail)}"

    bot_msgs = _bot_comments_since(number, since_iso=cmt_created_at)
    text = "\n".join(bot_msgs)
    assert "can not be assigned to" in text, \
        f"未找到 msg_not_allow_assign 提示；Bot={bot_msgs}"
    assert "xiaoguozhi34" in text, "拒绝提示未含目标用户名 xiaoguozhi34"
    assert "Please try to assign to the repository members" in text, \
        f"未找到完整提示文案；Bot={bot_msgs}"


def test_tc_api_cmd_004_non_command_text():
    """
    TC-API-CMD-009 [反向] 评论非命令格式时不触发分配
    模块：评论命令/POST /comments | 优先级：P1 | 重要等级：中

    步骤：POST 评论 body=`请 @<self> 处理一下，谢谢` → 等 12s
    预期：assignee 不变 + 评论列表中无 Bot 新评论
    """
    create = _create_issue("TC-API-CMD-009 非命令文本")
    number = create.json().get("number")
    time.sleep(5)
    assignee_before = _assignee_login(_get_issue(number))

    cmt = _post_comment(number, "请 @weixin_55883847 处理一下，谢谢")
    assert cmt.status_code == 200
    cmt_created_at = cmt.json().get("created_at", "")
    time.sleep(WAIT_AFTER_WEBHOOK)

    detail = _get_issue(number)
    assert _assignee_login(detail) == assignee_before, \
        f"非命令文本意外触发 assignee 变化：{assignee_before} → {_assignee_login(detail)}"

    bot_msgs = _bot_comments_since(number, since_iso=cmt_created_at)
    assign_related = [m for m in bot_msgs if "assign" in m.lower()]
    assert len(assign_related) == 0, f"非命令文本触发了 assign Bot 评论：{assign_related}"


def test_tc_api_cmd_005_unassign_self(my_login):
    """
    TC-API-CMD-014 [正常流] /unassign 取消评论者自身负责人身份
    模块：评论命令/POST /comments | 优先级：P0 | 重要等级:高

    前置：Issue.assignee=<self>
    步骤：POST 评论 body=/unassign → 等 12s
    预期：assignee 不再是 <self>（可能为 null，也可能因默认分配联动变为 DEFAULT_ASSIGNEE）
    """
    create = _create_issue("TC-API-CMD-014 /unassign 自身")
    number = create.json().get("number")
    time.sleep(5)

    # 把 assignee 设为自己
    _post_comment(number, "/assign")
    time.sleep(WAIT_AFTER_WEBHOOK)
    assert _assignee_login(_get_issue(number)) == my_login

    # /unassign
    cmt = _post_comment(number, "/unassign")
    assert cmt.status_code == 200
    time.sleep(WAIT_AFTER_WEBHOOK)

    after = _assignee_login(_get_issue(number))
    assert after != my_login, f"/unassign 后 assignee 仍为 {my_login}"
    # 设计联动：unassign 后 assignee 为 null 或被默认分配填充为 DEFAULT_ASSIGNEE
    assert after in (None, DEFAULT_ASSIGNEE), \
        f"unassign 后 assignee 非 null 也非 {DEFAULT_ASSIGNEE}：{after}"


def test_tc_api_cmd_006_unassign_not_current(my_login):
    """
    TC-API-CMD-016 [反向] /unassign @非当前负责人时回复 msg_not_allow_unassign
    模块：评论命令/POST /comments | 优先级：P1 | 重要等级：高

    前置：Issue.assignee=<self>
    步骤：POST 评论 body=/unassign @Guangyue-Xu → 等 12s
    预期：
        1. assignee 仍为 <self>
        2. Bot 评论含 "***Guangyue-Xu*** can not be unassigned from this issue"
           + "Please try to unassign the assignee of this issue"
    """
    create = _create_issue("TC-API-CMD-016 /unassign 非当前负责人")
    number = create.json().get("number")
    time.sleep(5)

    # 设 assignee=<self>
    _post_comment(number, "/assign")
    time.sleep(WAIT_AFTER_WEBHOOK)
    assert _assignee_login(_get_issue(number)) == my_login

    cmt = _post_comment(number, f"/unassign @{DEFAULT_ASSIGNEE}")
    assert cmt.status_code == 200
    cmt_created_at = cmt.json().get("created_at", "")
    time.sleep(WAIT_AFTER_WEBHOOK)

    assert _assignee_login(_get_issue(number)) == my_login, \
        f"/unassign 他人却改变了 assignee：{_assignee_login(_get_issue(number))}"

    bot_msgs = _bot_comments_since(number, since_iso=cmt_created_at)
    text = "\n".join(bot_msgs)
    assert "can not be unassigned from this issue" in text, \
        f"未找到 msg_not_allow_unassign 提示；Bot={bot_msgs}"
    assert DEFAULT_ASSIGNEE in text, \
        f"提示未含被取消的用户名 {DEFAULT_ASSIGNEE}"
    assert "Please try to unassign the assignee of this issue" in text, \
        f"未找到完整提示文案；Bot={bot_msgs}"


if __name__ == "__main__":
    pytest.main(["-v", __file__])
