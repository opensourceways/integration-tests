#!/usr/bin/env python3
"""git_runner.py — git 类用例执行器（**本包独有**，上游无此文件）

5 条 git 用例：clone(3) / push(2)。契约字段 action / args / local_path。

支持的断言 target:
  git_exit_code(equals, 受 type: negative 取反) / git_output(contains|must_not_contain)
  latency(le, 秒)

安全与稳态设计:
  1) push 是对真实仓的写操作，默认跳过（GIT_ALLOW_PUSH=1 开启）。
  2) push 的 local_path 未预置时判 ENV_ERROR 而非硬跑 —— 否则 git 报
     "not a git repository"，会让「期望 denied」的用例假失败。
  3) GIT_TERMINAL_PROMPT=0 + ssh BatchMode=yes：凭证缺失时快速失败，不挂起等输入。
  4) ${SECRET} 展开后的真实值在落盘前一律替换为 ***，不写进 results/。

环境变量:
  git.allow_push     true=执行 push 用例（默认 false=跳过记 INCONCLUSIVE）
  git.case_timeout   单条命令超时秒数（默认 900，大仓 clone 用例需要）
  （均来自 config.yaml，对应环境变量 GIT_ALLOW_PUSH / GIT_CASE_TIMEOUT）
"""
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import config_loader  # noqa: E402,F401  自动加载 config.yaml

ALLOW_PUSH = os.environ.get("GIT_ALLOW_PUSH", "0") == "1"
TIMEOUT = int(os.environ.get("GIT_CASE_TIMEOUT", 900))
_SECRET_RE = re.compile(r"\$\{(\w+)\}")

# 「前置条件缺失」而非「平台缺陷」的失败特征。命中后判 ENV_ERROR，
# 否则 SSH 无密钥、夹具仓不存在这类环境问题会进报告的「问题发现」变成假缺陷。
_ENV_PATTERNS = [
    (r"Permission denied \(publickey\)", "SSH 密钥未配置"),
    (r"could not be found|Repository not found|returned error: 40[34]",
     "目标仓不存在或无访问权限（夹具未预置）"),
    (r"Could not resolve host|Failed to connect|Connection timed out",
     "网络不可达"),
    (r"not a git repository", "本地仓未预置"),
    (r"git-lfs.*not (a git command|found)|'lfs' is not a git command",
     "git-lfs 未安装"),
]


def _env_failure(out):
    for pat, why in _ENV_PATTERNS:
        if re.search(pat, out or "", re.I):
            return why
    return None


def _expects_failure(assertions):
    """用例是否本就在验「操作应当失败」（如期望 push 被拒）。

    这类用例的非零退出是被测行为本身，绝不能被 _env_failure 改判成环境问题。
    """
    for a in assertions or []:
        if a.get("target") == "git_exit_code" and a.get("type") == "negative":
            return True
        if a.get("target") == "git_output" and a.get("contains"):
            if re.search(r"denied|reject|forbidden|fatal", str(a["contains"]), re.I):
                return True
    return False


def resolve_secrets(text):
    """展开 ${NAME}。返回 (展开后文本, 缺失的变量名, 真实值列表)。"""
    missing, values = [], []

    def _sub(m):
        name = m.group(1)
        val = os.environ.get(name, "")
        if not val:
            missing.append(name)
            return m.group(0)
        values.append(val)
        return val

    return _SECRET_RE.sub(_sub, text or ""), missing, values


def mask(text, secrets):
    """把真实凭证值从输出里抹掉，避免写进 results/*.log.txt。"""
    out = text or ""
    for s in secrets:
        if s:
            out = out.replace(s, "***")
    return out


def _git_env():
    env = dict(os.environ)
    env["GIT_TERMINAL_PROMPT"] = "0"          # 不弹交互式凭证提示
    env["GIT_ASKPASS"] = "echo"
    env.setdefault("GIT_SSH_COMMAND",
                   "ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new")
    env["GIT_LFS_SKIP_SMUDGE"] = env.get("GIT_LFS_SKIP_SMUDGE", "0")
    return env


def plan(doc):
    """编译成 (cmd 列表, cwd 策略, 缺失变量, 真实凭证值)。不执行。"""
    g = doc.get("git") or {}
    action = g.get("action")
    args = g.get("args") or {}
    local_path = g.get("local_path") or "."

    if action == "clone":
        url, missing, secrets = resolve_secrets(str(args.get("url") or ""))
        if not url:
            return {"error": "git.args.url 缺失"}
        return {"cmd": ["git", "clone", url, os.path.basename(local_path.rstrip("/"))],
                "mode": "clone", "local_path": local_path,
                "missing": missing, "secrets": secrets}
    if action == "push":
        remote = str(args.get("remote") or "origin")
        branch = str(args.get("branch") or "HEAD")
        return {"cmd": ["git", "push", remote, branch], "mode": "push",
                "local_path": local_path, "missing": [], "secrets": []}
    return {"error": f"未实现的 git.action: {action}"}


def execute(doc, cfg=None, dry_run=False):
    """执行一条 git 用例，返回 run_case.write_result 可消费的 rr。"""
    rr = {"case_id": doc.get("id", ""), "jobs": [], "gitcode_run_id": "",
          "head_sha": "", "duration_seconds": 0, "logs": "", "run_url": ""}
    p = plan(doc)
    if p.get("error"):
        rr.update(status="ENV_ERROR", error=p["error"])
        return rr

    # 命令行里可能含真实凭证，展示用版本一律脱敏
    rr["command"] = mask(" ".join(p["cmd"]), p["secrets"])
    rr["run_url"] = rr["command"]

    gate = None
    if p["mode"] == "push" and not ALLOW_PUSH:
        gate = ("SKIPPED_UNSAFE", "push 会写入真实仓，默认跳过；"
                                  "确认目标是专用测试仓后设 GIT_ALLOW_PUSH=1")
    elif p["missing"]:
        gate = ("ENV_ERROR", f"缺少凭证环境变量: {', '.join(p['missing'])}")
    elif p["mode"] == "push" and not os.path.isdir(
            os.path.join(p["local_path"], ".git")):
        gate = ("ENV_ERROR",
                f"本地仓未预置: {p['local_path']}（push 用例需先备好可推送的工作区，"
                f"否则 git 报 not a git repository，会掩盖用例真正要验的行为）")

    if dry_run:
        rr.update(status="DRY_RUN", would_skip=(gate[0] if gate else None))
        return rr
    if gate:
        rr.update(status=gate[0], error=gate[1])
        return rr

    tmp = tempfile.mkdtemp(prefix="gitcase-") if p["mode"] == "clone" else None
    cwd = tmp if p["mode"] == "clone" else p["local_path"]
    t0 = time.time()
    try:
        proc = subprocess.run(p["cmd"], cwd=cwd, env=_git_env(), timeout=TIMEOUT,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                              text=True, errors="replace")
        out = proc.stdout or ""
        rr.update(status=proc.returncode, exit_code=proc.returncode,
                  logs=mask(out, p["secrets"])[:20000])
    except subprocess.TimeoutExpired:
        rr.update(status="TIMEOUT", error=f"命令超时（>{TIMEOUT}s）")
    except (OSError, ValueError) as e:
        rr.update(status="ENV_ERROR", error=f"无法执行 git: {type(e).__name__}: {e}")
    finally:
        rr["duration_seconds"] = round(time.time() - t0, 2)
        if tmp:
            shutil.rmtree(tmp, ignore_errors=True)
    return rr


def evaluate(rr, assertions):
    """纯函数判定。git_exit_code 的极性由断言的 type 决定。"""
    status = rr.get("status")
    if status == "TIMEOUT":
        return {"verdict": "TIMEOUT", "verdict_flags": [],
                "reason": rr.get("error", "超时"), "assertion_results": []}
    if status == "ENV_ERROR":
        return {"verdict": "ENV_ERROR", "verdict_flags": ["env"],
                "reason": rr.get("error", "环境不可用"), "assertion_results": []}
    if status == "SKIPPED_UNSAFE":
        return {"verdict": "INCONCLUSIVE", "verdict_flags": ["skipped_unsafe_push"],
                "reason": rr.get("error", "push 默认跳过"), "assertion_results": []}

    code = rr.get("exit_code")
    out = rr.get("logs") or ""
    dur = rr.get("duration_seconds") or 0

    # 前置条件缺失 → ENV_ERROR（不可测试），而非 FAIL（问题发现）。
    # 但「期望失败」的用例例外：它的非零退出就是被测行为。
    if code not in (0, None) and not _expects_failure(assertions):
        why = _env_failure(out)
        if why:
            first = next((ln for ln in out.splitlines() if ln.strip()), "")
            return {"verdict": "ENV_ERROR", "verdict_flags": ["env_precondition"],
                    "reason": f"{why}（exit {code}）: {first[:120]}",
                    "assertion_results": []}

    results = []
    for a in assertions or []:
        tgt, neg = a.get("target"), a.get("type") == "negative"
        if tgt == "git_exit_code" and "equals" in a:
            exp = a["equals"]
            ok = (code != exp) if neg else (code == exp)
            results.append({"kind": f"exit_code {'!=' if neg else '=='}",
                            "pass": ok, "expected": exp, "actual": code,
                            "unsupported": False})
        elif tgt == "git_output" and "contains" in a:
            exp = str(a["contains"])
            results.append({"kind": "output contains", "pass": exp in out,
                            "expected": exp, "actual": f"len={len(out)}",
                            "unsupported": False})
        elif tgt == "git_output" and "must_not_contain" in a:
            exp = str(a["must_not_contain"])
            results.append({"kind": "output must_not_contain", "pass": exp not in out,
                            "expected": f"不含 {exp}", "actual": f"len={len(out)}",
                            "unsupported": False})
        elif tgt == "latency" and "le" in a:
            exp = float(a["le"])
            results.append({"kind": "latency <=", "pass": dur <= exp,
                            "expected": f"{exp}s", "actual": f"{dur}s",
                            "unsupported": False})
        else:
            results.append({"kind": f"{tgt} (未实现的谓词)", "pass": False,
                            "expected": str({k: v for k, v in a.items()
                                             if k not in ("type", "target")}),
                            "actual": "—", "unsupported": True})

    failed = [r for r in results if not r["pass"] and not r["unsupported"]]
    unsupported = [r for r in results if r["unsupported"]]
    if failed:
        verdict = "FAIL"
        reason = "; ".join(f"{r['kind']} 期望 {r['expected']} 实际 {r['actual']}"
                           for r in failed[:3])
    elif unsupported:
        verdict, reason = "INCONCLUSIVE", f"{len(unsupported)} 条断言谓词未实现"
    elif not results:
        verdict, reason = "INCONCLUSIVE", "用例无断言"
    else:
        verdict, reason = "PASS", f"{len(results)} 条断言全部通过（exit {code}）"
    return {"verdict": verdict, "verdict_flags": [], "reason": reason,
            "assertion_results": results}
