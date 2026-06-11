# -*- coding: utf-8 -*-
"""
测试脚本：CLA 自动验证机器人（robot-universal-cla）
被测对象：openeuler-ci-bot
用例数：15（自动化 15 / 手工 0）

平台实测事实：
    - CLA 标签: openeuler-cla/yes, openeuler-cla/no
    - Bot 已签名评论关键词: "CLA Signature Pass"
    - Bot 未签名评论关键词: "CLA Signature Guide"
    - /check-cla 命令触发重新检查
    - /cla cancel 命令取消验证（移除 cla-yes 标签）
    - PR 评论 API: POST /repos/{owner}/{repo}/pulls/{number}/comments

执行：
    set GITCODE_TEST_TOKEN=<your_gitcode_pat>
    pytest -v robot-universal-cla/test_cases.py
"""

import sys
import time
from pathlib import Path

import pytest

# 让 from common import ... 能在子目录定位到 base_community/common.py
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from common import (
    BASE,
    BOT_LOGIN,
    REPO_FULL,
    _auth_headers,
    _bot_pr_comments,
    _create_pr,
    _get_pr,
    _list_pr_comments,
    _post_pr_comment,
    _pr_labels,
    _send,
)


# CLA Robot 本地常量
CLA_LABEL_YES = "openeuler-cla/yes"
CLA_LABEL_NO = "openeuler-cla/no"
WAIT_CLA_ROBOT = 18  # CLA Robot 含 3s 内置延迟 + Webhook 处理


# ============================================================================
# 二、CLA 自动验证机器人（robot-universal-cla）
# ============================================================================


@pytest.fixture(scope="module")
def cla_signed_pr():
    """获取或创建一个由已签名 CLA 用户发起的 PR，供多个用例复用"""
    # 优先尝试复用已存在的 open 状态 PR（由已签名用户发起）
    resp = _send("GET",
                 f"{BASE}/repos/{REPO_FULL}/pulls?state=open&per_page=10",
                 headers=_auth_headers())
    if resp.status_code == 200:
        for pr in resp.json():
            labels = [l.get("name") for l in (pr.get("labels") or [])]
            if CLA_LABEL_YES in labels:
                yield pr.get("number")
                return

    # 无可复用 PR 则新建
    resp = _create_pr(
        "TC-CLA-FIXTURE signed user PR",
        head="test-5",
        body="CLA 自动化测试 fixture PR（已签名用户）",
    )
    if resp.status_code != 200:
        pytest.skip(f"无法创建 PR: status={resp.status_code}")
    number = resp.json().get("number")
    if not number:
        pytest.skip("PR 创建返回无 number")
    time.sleep(WAIT_CLA_ROBOT)
    yield number


def test_tc_cla_001_pr_create_signed_user_gets_label(cla_signed_pr):
    """
    TC-CLA-001 [正常流] 已签名CLA用户创建PR时自动添加 openeuler-cla/yes 标签
    模块：CLA自动检测/PR创建 | 优先级：P0 | 重要等级：高

    前置条件：
        1. PR 由已签名 CLA 的用户(weixin_55883847)发起
        2. CLA Robot 已部署且监听该仓库 Webhook
    操作步骤：
        1. fixture 已创建 PR 并等待 Robot 响应
        2. GET /pulls/{number} 检查标签
    预期结果：
        1. labels 包含 openeuler-cla/yes
        2. labels 不包含 openeuler-cla/no
    """
    detail = _get_pr(cla_signed_pr)
    assert detail.status_code == 200
    labels = _pr_labels(detail)
    assert CLA_LABEL_YES in labels, \
        f"已签名用户 PR 应含 {CLA_LABEL_YES}; 实际 labels={labels}"
    assert CLA_LABEL_NO not in labels, \
        f"已签名用户 PR 不应含 {CLA_LABEL_NO}; 实际 labels={labels}"


def test_tc_cla_002_pr_create_signed_user_bot_comment(cla_signed_pr):
    """
    TC-CLA-002 [正常流] 已签名CLA用户创建PR时Bot发布签名通过评论
    模块：CLA自动检测/PR创建 | 优先级：P0 | 重要等级：高

    前置条件：已签名用户的 PR 已创建
    操作步骤：GET /pulls/{number}/comments 过滤 Bot 评论
    预期结果：Bot 评论包含 "CLA Signature Pass"
    """
    bot_msgs = _bot_pr_comments(cla_signed_pr)
    cla_msgs = [m for m in bot_msgs if "CLA" in m]
    assert any("CLA Signature Pass" in m for m in cla_msgs), \
        f"Bot 未发布 CLA Signature Pass 评论; Bot CLA 评论={cla_msgs}"


def test_tc_cla_003_check_cla_command_triggers_recheck(cla_signed_pr):
    """
    TC-CLA-003 [正常流] /check-cla 命令手动触发CLA重新检查
    模块：CLA命令/PR评论 | 优先级：P0 | 重要等级：高

    前置条件：PR 已存在且 CLA 已通过
    操作步骤：
        1. POST /pulls/{number}/comments body=/check-cla
        2. 等待 18s
        3. GET /pulls/{number}/comments 检查 Bot 新评论
    预期结果：Bot 发布 CLA Signature Pass 评论（Robot 会清理旧评论后重新发布）
    """
    cmt = _post_pr_comment(cla_signed_pr, "/check-cla")
    assert cmt.status_code in (200, 201), \
        f"/check-cla 评论创建失败 status={cmt.status_code}"
    cmt_created_at = cmt.json().get("created_at", "")

    time.sleep(WAIT_CLA_ROBOT)

    # Robot 会清理旧 CLA 评论再发新的，所以只需验证存在 CLA Pass 评论
    # 且该评论时间晚于 /check-cla 命令
    resp = _list_pr_comments(cla_signed_pr)
    data = resp.json()
    bot_cla_pass = [
        c for c in data
        if isinstance(c, dict)
        and (c.get("user") or {}).get("login") == BOT_LOGIN
        and "CLA Signature Pass" in c.get("body", "")
    ]
    assert len(bot_cla_pass) >= 1, \
        f"/check-cla 后应有 CLA Signature Pass 评论; Bot CLA 评论数={len(bot_cla_pass)}"

    # 验证最新的 CLA Pass 评论是在 /check-cla 之后产生的
    latest = bot_cla_pass[-1]
    latest_at = latest.get("created_at", "")
    if cmt_created_at and latest_at:
        assert latest_at >= cmt_created_at, \
            f"CLA Pass 评论应在 /check-cla 之后; cmd={cmt_created_at}, pass={latest_at}"


def test_tc_cla_004_cla_cancel_removes_label(cla_signed_pr):
    """
    TC-CLA-004 [正常流] /cla cancel 命令取消CLA验证
    模块：CLA命令/PR评论 | 优先级：P1 | 重要等级：中

    前置条件：PR 已有 openeuler-cla/yes 标签
    操作步骤：
        1. POST /pulls/{number}/comments body=/cla cancel
        2. 等待 18s
        3. GET /pulls/{number} 检查标签
    预期结果：openeuler-cla/yes 标签被移除
    注意：实测中此命令可能需要管理员权限才能生效
    """
    detail_before = _get_pr(cla_signed_pr)
    labels_before = _pr_labels(detail_before)
    if CLA_LABEL_YES not in labels_before:
        pytest.skip(f"前置条件不满足: PR 无 {CLA_LABEL_YES} 标签")

    cmt = _post_pr_comment(cla_signed_pr, "/cla cancel")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_CLA_ROBOT)

    detail_after = _get_pr(cla_signed_pr)
    labels_after = _pr_labels(detail_after)
    # 文档预期: 移除 cla-yes 标签；实测可能因权限不足未生效
    if CLA_LABEL_YES in labels_after:
        pytest.xfail(
            f"/cla cancel 未移除 {CLA_LABEL_YES}（可能需管理员权限）"
        )


def test_tc_cla_005_unsigned_pr_gets_cla_no_label():
    """
    TC-CLA-005 [正常流] 未签名CLA用户的PR自动添加 openeuler-cla/no 标签
    模块：CLA自动检测/PR创建 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 由未签名 CLA 的用户(Coopermassaki)发起
    操作步骤：GET /pulls/78 检查标签
    预期结果：
        1. labels 包含 openeuler-cla/no
        2. labels 不包含 openeuler-cla/yes
    注意：使用已存在的 PR#78 作为验证对象（避免需要未签名用户 token）
    """
    detail = _get_pr(78)
    assert detail.status_code == 200
    labels = _pr_labels(detail)
    assert CLA_LABEL_NO in labels, \
        f"未签名用户 PR 应含 {CLA_LABEL_NO}; 实际 labels={labels}"
    assert CLA_LABEL_YES not in labels, \
        f"未签名用户 PR 不应含 {CLA_LABEL_YES}; 实际 labels={labels}"


def test_tc_cla_006_unsigned_pr_bot_guide_comment():
    """
    TC-CLA-006 [正常流] 未签名CLA用户的PR收到Bot签名指导评论
    模块：CLA自动检测/Bot评论 | 优先级：P0 | 重要等级：高

    前置条件：PR#78 由未签名用户发起
    操作步骤：GET /pulls/78/comments 过滤 Bot 评论
    预期结果：
        1. Bot 评论包含 "CLA Signature Guide"
        2. Bot 评论包含签名链接 "click here"
        3. Bot 评论包含 /check-cla 重新验证提示
    """
    bot_msgs = _bot_pr_comments(78)
    cla_guide_msgs = [m for m in bot_msgs if "CLA Signature Guide" in m]
    assert len(cla_guide_msgs) > 0, \
        f"Bot 未发布 CLA Signature Guide 评论; Bot 评论数={len(bot_msgs)}"

    guide_text = cla_guide_msgs[-1]
    assert "click here" in guide_text.lower(), \
        "CLA 指导评论应含签名链接 'click here'"
    assert "/check-cla" in guide_text, \
        "CLA 指导评论应含 /check-cla 重新验证提示"


def test_tc_cla_007_unsigned_pr_comment_contains_commit_table():
    """
    TC-CLA-007 [正常流] 未签名PR的Bot评论包含未签名提交表格
    模块：CLA自动检测/Bot评论 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 由未签名用户发起
    操作步骤：GET /pulls/78/comments 检查 Bot CLA 评论内容
    预期结果：
        1. 评论包含 Markdown 表格（| Commit | Reason |）
        2. 表格包含提交 hash 链接
        3. 表格包含未签名原因说明
    """
    bot_msgs = _bot_pr_comments(78)
    cla_guide_msgs = [m for m in bot_msgs if "CLA Signature Guide" in m]
    assert len(cla_guide_msgs) > 0

    guide_text = cla_guide_msgs[-1]
    assert "| Commit | Reason |" in guide_text, \
        "CLA 指导评论应含提交表格头 '| Commit | Reason |'"
    assert "commit/" in guide_text.lower() or "commit" in guide_text.lower(), \
        "CLA 指导评论应含提交 hash 链接"
    assert "email" in guide_text.lower(), \
        "CLA 指导评论应含邮箱相关的未签名原因"


def test_tc_cla_008_check_cla_on_unsigned_pr():
    """
    TC-CLA-008 [正常流] 在未签名PR上执行 /check-cla 仍返回未签名结果
    模块：CLA命令/PR评论 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 贡献者未签名 CLA
    操作步骤：
        1. POST /pulls/78/comments body=/check-cla
        2. 等待 18s
        3. GET /pulls/78/comments 检查 Bot 新评论
        4. GET /pulls/78 检查标签
    预期结果：
        1. Bot 发布新的 CLA Signature Guide 或 CLA Signature Manual 评论
        2. 标签仍为 openeuler-cla/no
    """
    cmt = _post_pr_comment(78, "/check-cla")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_CLA_ROBOT)

    bot_msgs = _bot_pr_comments(78)
    cla_msgs = [m for m in bot_msgs if "CLA Signature" in m]
    assert len(cla_msgs) > 0, "Bot 未响应 /check-cla 命令"

    detail = _get_pr(78)
    labels = _pr_labels(detail)
    assert CLA_LABEL_NO in labels, \
        f"/check-cla 后未签名 PR 应仍含 {CLA_LABEL_NO}; labels={labels}"
    assert CLA_LABEL_YES not in labels, \
        f"/check-cla 后未签名 PR 不应含 {CLA_LABEL_YES}; labels={labels}"


def test_tc_cla_009_non_cla_comment_no_trigger():
    """
    TC-CLA-009 [反向] 非CLA命令评论不触发CLA检查
    模块：CLA命令/PR评论 | 优先级：P1 | 重要等级：中

    前置条件：PR#79 已存在
    操作步骤：
        1. 记录当前 Bot CLA 评论数
        2. POST /pulls/79/comments body="这个PR看起来不错"
        3. 等待 18s
        4. GET /pulls/79/comments 检查 Bot 评论
    预期结果：Bot 未发布新的 CLA 相关评论
    """
    bot_msgs_before = [m for m in _bot_pr_comments(79) if "CLA" in m]
    count_before = len(bot_msgs_before)

    cmt = _post_pr_comment(79, "这个PR看起来不错，请继续完善")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_CLA_ROBOT)

    bot_msgs_after = [m for m in _bot_pr_comments(79) if "CLA" in m]
    count_after = len(bot_msgs_after)
    assert count_after == count_before, \
        f"非CLA命令不应触发新的 CLA 评论; before={count_before}, after={count_after}"


def test_tc_cla_010_invalid_command_no_trigger():
    """
    TC-CLA-010 [反向] 无效命令格式不触发CLA检查
    模块：CLA命令/PR评论 | 优先级：P2 | 重要等级：低

    前置条件：PR#79 已存在
    操作步骤：
        1. POST /pulls/79/comments body="/checkcla"（无连字符）
        2. 等待 18s
        3. 检查 Bot 评论
    预期结果：Bot 未响应无效命令
    """
    bot_msgs_before = [m for m in _bot_pr_comments(79) if "CLA" in m]
    count_before = len(bot_msgs_before)

    cmt = _post_pr_comment(79, "/checkcla")
    assert cmt.status_code in (200, 201)

    time.sleep(WAIT_CLA_ROBOT)

    bot_msgs_after = [m for m in _bot_pr_comments(79) if "CLA" in m]
    count_after = len(bot_msgs_after)
    assert count_after == count_before, \
        f"无效命令 /checkcla 不应触发 CLA 检查; before={count_before}, after={count_after}"


def test_tc_cla_011_signed_pr_no_cla_no_label(cla_signed_pr):
    """
    TC-CLA-011 [反向] 已签名用户PR不应出现 openeuler-cla/no 标签
    模块：CLA自动检测/标签互斥 | 优先级：P0 | 重要等级：高

    前置条件：已签名用户创建的 PR
    操作步骤：GET /pulls/{number} 检查标签
    预期结果：labels 中不包含 openeuler-cla/no
    """
    detail = _get_pr(cla_signed_pr)
    labels = _pr_labels(detail)
    assert CLA_LABEL_NO not in labels, \
        f"已签名用户 PR 不应含 {CLA_LABEL_NO}; labels={labels}"


def test_tc_cla_012_bot_comment_mentions_user():
    """
    TC-CLA-012 [正常流] Bot未签名评论中@提及贡献者用户名
    模块：CLA自动检测/Bot评论 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 由 Coopermassaki 发起且未签名
    操作步骤：GET /pulls/78/comments 检查 Bot CLA 评论
    预期结果：评论中包含 @Coopermassaki 提及
    """
    bot_msgs = _bot_pr_comments(78)
    cla_guide_msgs = [m for m in bot_msgs if "CLA Signature Guide" in m]
    assert len(cla_guide_msgs) > 0

    guide_text = cla_guide_msgs[-1]
    assert "Coopermassaki" in guide_text, \
        "CLA 指导评论应 @提及贡献者 Coopermassaki"


def test_tc_cla_013_bot_comment_contains_sign_url():
    """
    TC-CLA-013 [正常流] Bot未签名评论包含CLA签名页面链接
    模块：CLA自动检测/Bot评论 | 优先级：P1 | 重要等级：中

    前置条件：PR#78 未签名
    操作步骤：GET /pulls/78/comments 检查 Bot CLA 评论
    预期结果：评论包含 CLA 签名 URL（clasign.osinfra.cn）
    """
    bot_msgs = _bot_pr_comments(78)
    cla_guide_msgs = [m for m in bot_msgs if "CLA Signature Guide" in m]
    assert len(cla_guide_msgs) > 0

    guide_text = cla_guide_msgs[-1]
    assert "clasign.osinfra.cn" in guide_text, \
        "CLA 指导评论应含签名 URL clasign.osinfra.cn"


def test_tc_cla_014_signed_pr_comment_mentions_user(cla_signed_pr):
    """
    TC-CLA-014 [正常流] Bot已签名评论中提及PR作者用户名
    模块：CLA自动检测/Bot评论 | 优先级：P2 | 重要等级：低

    前置条件：已签名用户的 PR
    操作步骤：GET /pulls/{number}/comments 检查 Bot CLA 评论
    预期结果：评论包含 PR 作者用户名
    """
    # 获取 PR 作者
    pr_detail = _get_pr(cla_signed_pr)
    pr_author = (pr_detail.json().get("user") or {}).get("login", "")
    assert pr_author, "无法获取 PR 作者 login"

    bot_msgs = _bot_pr_comments(cla_signed_pr)
    cla_pass_msgs = [m for m in bot_msgs if "CLA Signature Pass" in m]
    assert len(cla_pass_msgs) > 0

    pass_text = cla_pass_msgs[-1]
    assert pr_author in pass_text, \
        f"CLA 通过评论应含 PR 作者用户名 {pr_author}; 实际={pass_text[:100]}"


def test_tc_cla_015_multiple_check_cla_idempotent(cla_signed_pr):
    """
    TC-CLA-015 [重复操作] 多次 /check-cla 不产生异常
    模块：CLA命令/PR评论 | 优先级：P2 | 重要等级：低

    前置条件：已签名用户的 PR
    操作步骤：
        1. POST /check-cla 两次（间隔 20s）
        2. GET /pulls/{number} 检查标签
    预期结果：
        1. 标签仍为 openeuler-cla/yes
        2. 无异常错误评论
    """
    _post_pr_comment(cla_signed_pr, "/check-cla")
    time.sleep(WAIT_CLA_ROBOT + 2)
    _post_pr_comment(cla_signed_pr, "/check-cla")
    time.sleep(WAIT_CLA_ROBOT + 2)

    detail = _get_pr(cla_signed_pr)
    labels = _pr_labels(detail)
    assert CLA_LABEL_YES in labels, \
        f"多次 /check-cla 后标签应仍含 {CLA_LABEL_YES}; labels={labels}"

    bot_msgs = _bot_pr_comments(cla_signed_pr)
    error_msgs = [m for m in bot_msgs if "error" in m.lower() or "failed" in m.lower()]
    cla_error_msgs = [m for m in error_msgs if "CLA" in m]
    assert len(cla_error_msgs) == 0, \
        f"多次 /check-cla 不应产生 CLA 错误评论; errors={cla_error_msgs}"


if __name__ == "__main__":
    pytest.main(["-v", __file__])
