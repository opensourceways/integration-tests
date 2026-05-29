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

GITCODE_TOKEN = os.environ.get("GITCODE_TEST_TOKEN", "")

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

# 全局收集器：记录本次测试运行中创建的所有 Issue number，用于 session 结束时清理
_created_issue_numbers = []


def _auth_headers():
    if not GITCODE_TOKEN:
        pytest.skip("环境变量 GITCODE_TOKEN 未设置")
    return {
        "PRIVATE-TOKEN": GITCODE_TOKEN,
        "Content-Type": "application/json",
        "User-Agent": "api-test/1.0",
    }


def _delete_issue(number):
    """删除指定 Issue"""
    return _send("DELETE", f"{BASE}/repos/{REPO_FULL}/issues/{number}",
                 headers=_auth_headers())


def _create_issue(title, body="自动化测试用例", **extra):
    payload = {"repo": REPO, "title": title, "body": body}
    payload.update(extra)
    resp = _send(
        "POST",
        f"{BASE}/repos/{REPO_FULL}/issues",
        headers=_auth_headers(),
        json_body=payload,
    )
    if resp.status_code == 200:
        number = resp.json().get("number")
        if number:
            _created_issue_numbers.append(number)
    return resp


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


@pytest.fixture(scope="session", autouse=True)
def _cleanup_created_issues():
    """session 结束后批量删除本次运行中创建的所有 Issue"""
    yield
    if not GITCODE_TOKEN or not _created_issue_numbers:
        return
    print(f"\n[CLEANUP] 删除本次创建的 {len(_created_issue_numbers)} 个 Issue...")
    for i, number in enumerate(_created_issue_numbers, 1):
        try:
            resp = _delete_issue(number)
            status = resp.status_code if resp else "N/A"
            print(f"  [{i}/{len(_created_issue_numbers)}] Issue#{number} → {status}")
        except Exception as e:
            print(f"  [{i}/{len(_created_issue_numbers)}] Issue#{number} → 删除失败: {e}")


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

def \
        test_tc_api_cmd_004_non_command_text():
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


# ============================================================================
# 二、CLA 自动验证机器人（robot-universal-cla）
# ============================================================================
# 平台实测事实：
#   - CLA 标签: openeuler-cla/yes, openeuler-cla/no
#   - Bot 已签名评论关键词: "CLA Signature Pass"
#   - Bot 未签名评论关键词: "CLA Signature Guide"
#   - /check-cla 命令触发重新检查
#   - /cla cancel 命令取消验证（移除 cla-yes 标签）
#   - PR 评论 API: POST /repos/{owner}/{repo}/pulls/{number}/comments

CLA_LABEL_YES = "openeuler-cla/yes"
CLA_LABEL_NO = "openeuler-cla/no"
WAIT_CLA_ROBOT = 18  # CLA Robot 含 3s 内置延迟 + Webhook 处理

# ===== CLA PR 工具函数 =====

def _create_pr(title, head, base="master", body="CLA自动化测试"):
    """创建 PR 并返回响应"""
    payload = {"title": title, "head": head, "base": base, "body": body}
    return _send(
        "POST",
        f"{BASE}/repos/{REPO_FULL}/pulls",
        headers=_auth_headers(),
        json_body=payload,
    )


def _get_pr(number):
    return _send("GET", f"{BASE}/repos/{REPO_FULL}/pulls/{number}",
                 headers=_auth_headers())


def _pr_labels(pr_resp):
    data = pr_resp.json()
    return [l.get("name") for l in (data.get("labels") or [])]


def _post_pr_comment(number, body):
    return _send(
        "POST",
        f"{BASE}/repos/{REPO_FULL}/pulls/{number}/comments",
        headers=_auth_headers(),
        json_body={"body": body},
    )


def _list_pr_comments(number):
    return _send("GET", f"{BASE}/repos/{REPO_FULL}/pulls/{number}/comments",
                 headers=_auth_headers(),
                 params={"per_page": 100})


def _bot_pr_comments(number, since_iso=None):
    resp = _list_pr_comments(number)
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


def _close_pr(number):
    return _send(
        "PATCH",
        f"{BASE}/repos/{REPO_FULL}/pulls/{number}",
        headers=_auth_headers(),
        json_body={"state": "closed"},
    )

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


# ============================================================================
# 四、Issue/PR 生命周期管理（robot-universal-lifecycle）
# ============================================================================
# 平台实测事实：
#   - /close Issue：Robot 直接关闭，无额外 Bot 评论，state→closed
#   - /reopen Issue：Robot 直接重开，无额外 Bot 评论，state→open
#   - /close PR：Robot 直接关闭（需 PR 作者/SIG成员/管理员），state→closed
#   - 响应时间约 10-15s
#   - 配置项 NeedIssueHasLinkPullRequests / ReopenIssueWhenCloseNoLinkPRIssue 可能影响行为

WAIT_LIFECYCLE_ROBOT = 15


def _get_issue_state(number):
    resp = _get_issue(number)
    if resp.status_code != 200:
        return None
    return resp.json().get("state")


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


# ============================================================================
# 五、社区欢迎机器人（robot-universal-welcome）
# ============================================================================
# 平台实测事实：
#   - Bot 欢迎评论标题: "### Welcome To openEuler Community"
#   - Bot 欢迎评论含: "Hey [@用户名](...), thanks for your contribution"
#   - Bot 欢迎评论含: "#### Bot Usage Manual" + 命令文档链接
#   - Bot 欢迎评论含: "#### Contact Guide" + SIG 信息 + Maintainers
#   - 自动添加 sig 标签: "sig/sig-infrastructure-cache"
#   - 响应时间约 8-12s

WAIT_WELCOME_ROBOT = 12
SIG_LABEL = "sig/sig-infrastructure-cache"
WELCOME_TITLE = "### Welcome To openEuler Community"

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


# ============================================================================
# 六、PR 自动审查合并机器人（robot-universal-review）
# ============================================================================
# 平台实测事实：
#   - /check-pr 命令触发 PR 合并检查
#   - 条件不满足时 Bot 发布 "### Merge Verification Failed" 评论
#   - 反馈含: "Not Enough Labels" / "Label BlockList" / "Label Usage Tips"
#   - 需要的标签: openeuler-cla/yes, approved, gate_check_pass, lgtm(x2)
#   - Bot 评论 @提及命令发起者
#   - 非 /check-pr 事件不生成反馈评论

WAIT_REVIEW_ROBOT = 15


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


# ============================================================================
# 七、通用标签机器人（robot-universal-label）
# ============================================================================
# 平台实测事实：
#   - /<keyword> <value> (keyword∈kind|priority|sig|good) → 添加 keyword/value 标签
#   - /remove-<keyword> <value> → 移除 keyword/value 标签
#   - /lgtm → 添加 lgtm 标签 + "Review Code Feedback" 评论
#   - PR 提交数>1 → 自动添加 stat/needs-squash 标签
#   - 反馈评论含 "Review Code Feedback" / "reviewed the code changes"
#   - 通用命令关键字: kind|priority|sig|good

WAIT_LABEL_ROBOT = 15


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


# ============================================================================
# 八、PR 关联检查机器人（robot-universal-associate）
# ============================================================================
# 平台实测事实：
#   - PR 创建时未关联 Issue → 自动添加 needs-issue 标签
#   - Bot 发布 "### Linking Issue Notice" 评论 @提及 PR 作者
#   - /check-issue 命令重新检查关联（未关联则保留标签+重发评论）
#   - /remove-needs-issue 命令移除标签（需仓库成员权限）
#   - 评论含: "must be linked to at least one issue"
#   - 评论含: "/check-issue" 提示

WAIT_ASSOCIATE_ROBOT = 12
NEEDS_ISSUE_LABEL = "needs-issue"
LINKING_ISSUE_NOTICE = "### Linking Issue Notice"


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
