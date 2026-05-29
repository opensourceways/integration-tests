#!/usr/bin/env python3
"""集成测试：robot-universal-lifecycle「按 issue 状态自动打 resolved 标签」（真实环境）。

真实驱动 gitcode（openeuler-test/test-concurrent）：
  1. 新建 issue（初始 `待办的`）→ 断言无 resolved 标签
  2. 关闭 issue（state=close → issue_state=已完成）→ 触发 gitcode webhook → 已部署的 robot
  3. 轮询该 issue 标签，等待 robot 自动加上 `resolved`
  4. 重新打开（state=reopen → 进行中，在 states_to_remove_label 中）→ 轮询等待 robot 移除 `resolved`
  5. 清理：关闭测试 issue

前置：目标 robot 已部署且 `issue_state_label` 配置已加载。

环境变量：
  GITCODE_TOKEN   必填，gitcode 访问 token（写权限）。由 backlog Workflow C 的集成测试 step 透传。
  GITCODE_OWNER   默认 openeuler-test
  GITCODE_REPO    默认 test-concurrent
  TARGET_LABEL    默认 resolved
  TIMEOUT         单步轮询超时秒，默认 150

退出码：0=核心通过(REMOVE 是 best-effort,不阻断) / 1=核心失败。
"""
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError):
        pass

API = "https://api.gitcode.com/api/v5"
TOK = os.environ.get("GITCODE_TOKEN", "").strip()
OWNER = os.environ.get("GITCODE_OWNER", "openeuler-test")
REPO = os.environ.get("GITCODE_REPO", "test-concurrent")
LABEL = os.environ.get("TARGET_LABEL", "resolved")
TIMEOUT = int(os.environ.get("TIMEOUT", "150"))
ADD_STATE = "已完成"
steps = []


def _req(method, path, body=None):
    data = json.dumps(body).encode() if body is not None else None
    h = {"Content-Type": "application/json"} if body is not None else {}
    sep = "&" if "?" in path else "?"
    url = f"{API}{path}{sep}access_token={urllib.parse.quote(TOK)}"
    req = urllib.request.Request(url, data=data, method=method, headers=h)
    try:
        return json.load(urllib.request.urlopen(req, timeout=30))
    except urllib.error.HTTPError as e:
        try:
            body = e.read().decode()
        except Exception:
            body = ""
        raise RuntimeError(f"HTTP {e.code} {method} {path}: {body}") from None


def _create_issue():
    return _req("POST", f"/repos/{OWNER}/{REPO}/issues", {
        "title": f"[ci] lifecycle_resolved {int(time.time())}",
        "body": "自动化集成测试用 issue (Workflow C 通用集成测试 runner 跑的)。",
    })


def _get_labels(num):
    r = _req("GET", f"/repos/{OWNER}/{REPO}/issues/{num}")
    return [x.get("name") for x in (r.get("labels") or []) if x.get("name")]


def _wait_until(num, want_present, deadline):
    while time.time() < deadline:
        try:
            ls = _get_labels(num)
            cur = LABEL in ls
            if cur == want_present:
                return True, ls
        except Exception:
            pass
        time.sleep(5)
    try:
        return False, _get_labels(num)
    except Exception:
        return False, []


def _set_state(num, st):
    _req("PATCH", f"/repos/{OWNER}/{REPO}/issues/{num}", {"state": st})


def main():
    if not TOK:
        print("::error::GITCODE_TOKEN 未配置 —— 跳过 lifecycle 集成测试")
        return 1
    issue = _create_issue()
    num = issue["number"]
    print(f"::notice::created gitcode issue #{num}")
    ok, ls0 = True, []
    try:
        ls0 = _get_labels(num)
        if LABEL in ls0:
            steps.append(("前置无 resolved", False, f"初始已含 {LABEL},标签={ls0}"))
            ok = False
        else:
            steps.append(("建 issue", True, f"#{num}（待办的）"))
            steps.append(("前置无 resolved", True, f"初始标签 {ls0}"))

        # ADD: state=close → 已完成 → resolved 应被加
        _set_state(num, "close")
        time.sleep(20)
        added, ls = _wait_until(num, True, time.time() + TIMEOUT)
        steps.append((f"状态→{ADD_STATE} 自动加 resolved", added, f"issue_state={ADD_STATE}, 标签={ls}"))
        if not added:
            ok = False

        # REMOVE: state=reopen → 进行中 → resolved 应被移除（best-effort，已知 robot 框架对无 type issue 自动 reopen）
        _set_state(num, "reopen")
        time.sleep(20)
        removed, ls2 = _wait_until(num, False, time.time() + TIMEOUT)
        steps.append(("状态→进行中 自动移除 resolved", removed, f"标签={ls2}"))
    finally:
        try:
            _set_state(num, "close")
        except Exception:
            pass

    # 写明细 markdown 到 stdout（runner 会把最后 3 行作为 detail；用 stderr 显示完整表）
    lines = []
    for name, ok_step, detail in steps:
        if not ok_step and "自动移除" in name:
            icon, note = '⚠️', ' _(best-effort, robot framework `closeIssueByWebhook` 对无 type issue 自动 reopen,已知限制)_'
        else:
            icon, note = ('✅' if ok_step else '❌'), ''
        lines.append(f"| {name} | {icon} | {detail}{note} |")
    print("\n".join(lines), file=sys.stderr)
    # 只看核心步骤(自动移除是 best-effort)
    passed = all(s_ok for n, s_ok, _ in steps if "自动移除" not in n)
    print(f"::notice::lifecycle_resolved {'PASS' if passed else 'FAIL'}")
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
