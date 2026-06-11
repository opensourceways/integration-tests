# -*- coding: utf-8 -*-
"""
共享工具模块：被各 Robot 测试脚本复用

包含：
    - 模块级常量（BASE / ORG / REPO / BOT_LOGIN / DEFAULT_ASSIGNEE 等）
    - HTTP 日志机制（_send + 控制台打印 + jsonl 落盘）
    - 鉴权头构造（_auth_headers，gitcode PRIVATE-TOKEN）
    - Issue CRUD 工具（_create_issue / _get_issue / _patch_issue / _delete_issue 等）
    - PR CRUD 工具（_create_pr / _get_pr / _pr_labels / _post_pr_comment 等）
    - 评论过滤工具（_bot_comments_since / _bot_pr_comments）
    - pytest fixtures：_capture_case_id / _cleanup_created_issues / my_login

依赖：
    pip install pytest requests python-dotenv

环境变量：
    GITCODE_TEST_TOKEN  必填，gitcode Personal Access Token
    HTTP_VERBOSE        可选，默认 1，控制台打印请求/响应
    HTTP_LOG_FILE       可选，jsonl 落盘路径
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
REPO = "issue-test"
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


def set_current_case_id(case_id):
    """供 conftest.py 中的 fixture 调用，更新当前用例 ID 以便 HTTP 日志关联"""
    global _current_case_id
    _current_case_id = case_id


# ===== 共享工具 =====

# 全局收集器：记录本次测试运行中创建的所有 Issue number，用于 session 结束时清理
_created_issue_numbers = []


def get_created_issue_numbers():
    return _created_issue_numbers


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


def _get_issue_state(number):
    resp = _get_issue(number)
    if resp.status_code != 200:
        return None
    return resp.json().get("state")


# ===== PR 工具函数 =====

def _create_pr(title, head, base="master", body="自动化测试"):
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


# 注意：
#   pytest fixture（_capture_case_id / _cleanup_created_issues / my_login）
#   位于同目录 conftest.py，pytest 会自动加载，跨所有 test_*.py 共享。
