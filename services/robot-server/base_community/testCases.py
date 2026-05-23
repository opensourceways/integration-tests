# -*- coding: utf-8 -*-
"""
测试用例脚本：Universal Issue Assign Robot（已通过用例子集）

来源：D:\\gxz\\ai_gxz\\robot\\testCases_assign.md
被测仓库：https://gitcode.com/openeuler-test/test-feature
被测对象：Universal Issue Assign Robot（实际部署账号 openeuler-ci-bot）
用例总数：9 | 自动化：9 | 手工：0
生成工具：test-case-generator skill（Python 模式）

特点：
    本脚本对应 testCases.md 的"已通过用例子集"——所有断言都是基于实测平台行为
    校正过的版本（gitcode PRIVATE-TOKEN 鉴权、HTTP 200 创建、英文 Bot 文案、
    Guangyue-Xu 默认负责人等），因此在 robot 部署不变更的前提下，9 条应全部通过。

依赖：
    pip install pytest requests python-dotenv

执行：
    set GITCODE_TOKEN=<your_gitcode_pat>
    pytest -v testCases_assign.py
    pytest -vs testCases_assign.py             # 看请求/响应明细

查看真实请求/响应：
    1. 控制台实时打印（需加 -s 关掉 pytest 标准输出捕获）：
         pytest -vs testCases_assign.py
    2. 落盘 jsonl 流水（默认开启，与本脚本同目录）：
         testCases_assign.http.log.jsonl
       关闭打印：set HTTP_VERBOSE=0
       关闭落盘：set HTTP_LOG_FILE=
       自定义路径：set HTTP_LOG_FILE=D:/logs/run-001.jsonl

平台实测事实（脚本已对齐）：
    1. gitcode 鉴权头：PRIVATE-TOKEN（不是 Authorization: token）
    2. 创建 Issue 实际返回 HTTP 200
    3. POST /issues body 必须含 repo 字段（值=test-feature）
    4. Bot 账号：openeuler-ci-bot；评论文案为英文核心子串
    5. 默认负责人（实测）：Guangyue-Xu
"""

import os
import json
import time
import datetime
import threading
from pathlib import Path

import pytest
import requests

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# ===== 模块级常量 =====
BASE = "https://api.gitcode.com/api/v5"
ORG = "openeuler-test"
REPO = "test-feature"
REPO_FULL = f"{ORG}/{REPO}"
BOT_LOGIN = "openeuler-ci-bot"
DEFAULT_ASSIGNEE = "Guangyue-Xu"     # 实测仓库默认负责人
DEFAULT_TIMEOUT = 15
WAIT_AFTER_WEBHOOK = 12              # Robot 处理 Webhook 的等待秒数

GITCODE_TOKEN = os.environ.get("GITCODE_TOKEN", "")

# ===== HTTP 日志开关 =====
HTTP_VERBOSE = os.environ.get("HTTP_VERBOSE", "1") not in ("0", "false", "False", "")
_DEFAULT_LOG = str(Path(__file__).with_suffix(".http.log.jsonl"))
HTTP_LOG_FILE = os.environ.get("HTTP_LOG_FILE", _DEFAULT_LOG)
SENSITIVE_KEYS = {"password", "token", "Authorization", "PRIVATE-TOKEN", "Cookie"}

_log_lock = threading.Lock()
_current_case_id = "<no-case>"


def _mask(value):
    if not isinstance(value, str) or len(value) <= 8:
        return "***"
    return f"{value[:4]}...{value[-4:]}"


def _redact(obj):
    if isinstance(obj, dict):
        return {k: (_mask(v) if k in SENSITIVE_KEYS and isinstance(v, str) else _redact(v))
                for k, v in obj.items()}
    if isinstance(obj, list):
        return [_redact(x) for x in obj]
    return obj


def _safe_json(text):
    try:
        return json.loads(text)
    except Exception:
        return None


def _truncate(text, limit=4000):
    if text is None:
        return None
    if len(text) <= limit:
        return text
    return text[:limit] + f"...<truncated {len(text) - limit} chars>"


def _print_req_resp(method, url, req_headers, req_body, resp, elapsed_s):
    sep = "-" * 76
    print()
    print(sep)
    print(f"[HTTP] [{_current_case_id}] {method} {url}")
    print(f"  > headers: {_redact(dict(req_headers or {}))}")
    if req_body is not None:
        print(f"  > body:    {json.dumps(_redact(req_body), ensure_ascii=False)}")
    print(f"  < status:  {resp.status_code}  (耗时 {elapsed_s:.3f}s)")
    print(f"  < headers: {dict(resp.headers)}")
    parsed = _safe_json(resp.text)
    if parsed is not None:
        print(f"  < body:    {json.dumps(parsed, ensure_ascii=False)}")
    else:
        print(f"  < body:    {_truncate(resp.text)}")
    print(sep)


def _append_jsonl(record):
    if not HTTP_LOG_FILE:
        return
    try:
        with _log_lock:
            with open(HTTP_LOG_FILE, "a", encoding="utf-8") as f:
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as e:
        print(f"[HTTP-LOG] 写入失败: {e}")


def _send(method, url, *, headers=None, json_body=None, params=None,
          timeout=DEFAULT_TIMEOUT):
    started = time.time()
    started_iso = datetime.datetime.now().isoformat(timespec="seconds")
    err = None
    resp = None
    try:
        resp = requests.request(
            method, url,
            headers=headers, json=json_body, params=params, timeout=timeout,
        )
    except Exception as e:
        err = e
    elapsed_s = time.time() - started

    if resp is not None and HTTP_VERBOSE:
        _print_req_resp(method, url, headers, json_body, resp, elapsed_s)

    record = {
        "ts": started_iso,
        "case_id": _current_case_id,
        "elapsed_s": round(elapsed_s, 3),
        "request": {
            "method": method, "url": url, "params": params,
            "headers": _redact(dict(headers or {})),
            "body": _redact(json_body) if json_body is not None else None,
        },
    }
    if resp is not None:
        record["response"] = {
            "status_code": resp.status_code,
            "headers": dict(resp.headers),
            "body_raw": _truncate(resp.text),
            "body_json": _safe_json(resp.text),
        }
    if err is not None:
        record["error"] = f"{type(err).__name__}: {err}"
    _append_jsonl(record)

    if err is not None:
        raise err
    return resp


@pytest.fixture(autouse=True)
def _capture_case_id(request):
    global _current_case_id
    _current_case_id = request.node.name
    if HTTP_VERBOSE:
        print(f"\n========== [CASE START] {_current_case_id} ==========")
    yield
    if HTTP_VERBOSE:
        print(f"========== [CASE END]   {_current_case_id} ==========\n")
    _current_case_id = "<no-case>"


# ===== 共享工具 =====


def _auth_headers():
    if not GITCODE_TOKEN:
        pytest.skip("环境变量 GITCODE_TOKEN 未设置")
    return {
        "PRIVATE-TOKEN": GITCODE_TOKEN,
        "Content-Type": "application/json",
        "User-Agent": "api-test/1.0",
    }


def _create_issue(title, body="自动化测试用例", **extra):
    payload = {"repo": REPO, "title": title, "body": body}
    payload.update(extra)
    return _send(
        "POST",
        f"{BASE}/repos/{REPO_FULL}/issues",
        headers=_auth_headers(),
        json_body=payload,
    )


def _get_issue(number):
    return _send("GET", f"{BASE}/repos/{REPO_FULL}/issues/{number}",
                 headers=_auth_headers())


def _patch_issue(number, **fields):
    payload = {"repo": REPO}
    payload.update(fields)
    return _send("PATCH", f"{BASE}/repos/{REPO_FULL}/issues/{number}",
                 headers=_auth_headers(), json_body=payload)


def _post_comment(number, body):
    return _send(
        "POST",
        f"{BASE}/repos/{REPO_FULL}/issues/{number}/comments",
        headers=_auth_headers(),
        json_body={"body": body},
    )


def _list_comments(number):
    return _send("GET", f"{BASE}/repos/{REPO_FULL}/issues/{number}/comments",
                 headers=_auth_headers())


def _assignee_login(issue_resp):
    data = issue_resp.json()
    a = data.get("assignee") if isinstance(data, dict) else None
    return a.get("login") if isinstance(a, dict) else None


def _bot_comments_since(number, since_iso=None):
    """获取 BOT_LOGIN 的评论 body 列表；可选只取 since_iso 之后的"""
    resp = _list_comments(number)
    data = resp.json()
    if not isinstance(data, list):
        return []
    result = []
    for c in data:
        if not isinstance(c, dict):
            continue
        if (c.get("user") or {}).get("login") != BOT_LOGIN:
            continue
        if since_iso and c.get("created_at", "") <= since_iso:
            continue
        result.append(c.get("body", ""))
    return result


@pytest.fixture(scope="session")
def my_login():
    """取当前 token 持有者 login，用于多个用例验证"""
    if not GITCODE_TOKEN:
        pytest.skip("环境变量 GITCODE_TOKEN 未设置")
    resp = _send("GET", f"{BASE}/user", headers=_auth_headers())
    assert resp.status_code == 200, f"获取当前用户失败 status={resp.status_code}"
    login = resp.json().get("login")
    assert login, "无法获取 token 持有者 login"
    return login


# ============================================================================
# 一、自动分配默认负责人（创建 / 更新 Issue）
# ============================================================================


def test_tc_api_assign_002_already_assigned_no_overwrite(my_login):
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


def test_tc_api_assign_006_patch_not_trigger(my_login):
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
    assert len(bot_msgs_after) == 0, \
        f"PATCH 更新触发了新的 Bot 评论：{bot_msgs_after}"


# ============================================================================
# 二、评论命令管理负责人（/assign /unassign）
# ============================================================================


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

    # 本次 /assign 之后不应有 Bot 新评论
    bot_after = _bot_comments_since(number, since_iso=cmt_created_at)
    assert len(bot_after) == 0, f"/assign 自身触发了 Bot 评论：{bot_after}"


def test_tc_api_cmd_004_assign_repeat(my_login):
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


def test_tc_api_cmd_005_assign_non_member():
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


def test_tc_api_cmd_008_assign_with_spaces_and_newlines(my_login):
    """
    TC-API-CMD-008 [参数合法性] /assign 命令前后含空格与换行可被正确解析
    模块：评论命令/POST /comments | 优先级：P2 | 重要等级：中

    步骤：
        1. POST 评论 body=`    /assign @<self>    `（前后各 4 空格）
        2. 等 12s → GET 详情：assignee=<self>
        3. /unassign 重置
        4. POST 评论 body=`\n/assign @<self>\n`
        5. 等 12s → GET 详情：assignee=<self>
    """
    create = _create_issue("TC-API-CMD-008 空格与换行")
    number = create.json().get("number")
    time.sleep(5)

    # 1. 前后空格
    cmt1 = _post_comment(number, f"    /assign @{my_login}    ")
    assert cmt1.status_code == 200
    time.sleep(WAIT_AFTER_WEBHOOK)
    assert _assignee_login(_get_issue(number)) == my_login, \
        "前后空格 /assign 未生效"

    # 2. 重置：/unassign
    _post_comment(number, "/unassign")
    time.sleep(WAIT_AFTER_WEBHOOK)

    # 3. 换行
    cmt2 = _post_comment(number, f"\n/assign @{my_login}\n")
    assert cmt2.status_code == 200
    time.sleep(WAIT_AFTER_WEBHOOK)
    assert _assignee_login(_get_issue(number)) == my_login, \
        "首尾换行的 /assign 未生效"


def test_tc_api_cmd_009_non_command_text():
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
    assert len(bot_msgs) == 0, f"非命令文本触发了 Bot 评论：{bot_msgs}"


def test_tc_api_cmd_014_unassign_self(my_login):
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


def test_tc_api_cmd_016_unassign_not_current(my_login):
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


# ============================================================================
# 直接运行入口
# ============================================================================

if __name__ == "__main__":
    pytest.main(["-v", __file__])
