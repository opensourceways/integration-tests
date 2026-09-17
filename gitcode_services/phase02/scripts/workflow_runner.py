#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
workflow_runner.py — Phase 02 原生组件：部署 + 触发 + 采集（确定性、可复用）

实现 `phase02/scripts/workflow-runner.md` 规格。**只负责把 workflow 部署到测试仓、
触发、等待、采集证据**——不判 pass/fail（那是 assertion_engine 的职责，rules.md §1）。

设计立场（炼钢：吸收 execute_serial/logassert/masking 的实战经验，弃用一次性脚本）：
  1. 按 (file_path) **精确匹配 run**。共享仓一次 push 会触发所有
     `on:push` 的 workflow → 同 SHA 多个 run；只按"我这次推的文件名"过滤。
     若 API 返回 head_sha 非空则额外校验。
  2. 日志正文走 v8 `download_log`(下划线，跟随 302 → zip)，仅需 OAuth token，
     封装在 log_fetcher.py。（早期误判 `download-log` 连字符"平台缺陷"是端点名错，已更正。）
  3. 只产出"执行层"结果。判定词以 `phase02/rules.md` §11 为准，本组件只输出：
     采集成功 → RunResult(status=平台终态)；触发无 run → NO_RUN；
     超时 → TIMEOUT；API/网络错误(重试后仍失败) → ENV_ERROR。

用法（一次 clone、多条复用）：
    import workflow_runner as wr
    cfg = wr.RunnerConfig(owner="ComputingActionTest", repo="bingo", branch="main")
    with wr.Workspace(cfg) as ws:
        rr = wr.run_case(ws, cfg, case_id="SEC-MASK-SECRET-H-001",
                         workflow_yaml="<GitCode 原生 workflow 正文>",
                         fetch_logs=True)
    # rr 交给 assertion_engine.evaluate(rr, assertions)

凭据：
    ~/.gitcode-token         git push + v8 OAuth（query token）
    ~/.gitcode-web-curl.txt  web-api 取日志（浏览器会话，见 WEB-LOG-CREDENTIALS.md）
"""
import os
import re
import json
import time
import shutil
import tempfile
import subprocess
import urllib.request
import urllib.error

import yaml

# log_fetcher / validate_workflow 与本文件同目录（phase02/scripts/）
try:
    import log_fetcher
    import validate_workflow as _vwf
except ImportError:  # 允许从别处 import 时按路径补齐
    import sys
    _here = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, _here)
    import log_fetcher  # noqa
    import validate_workflow as _vwf  # noqa


# ── 配置 ──────────────────────────────────────────────────────────
def _load_dotenv_cookie():
    """从工程根目录 .env 文件读取 GITCODE_COOKIE。遍历4级目录。"""
    here = os.path.dirname(os.path.abspath(__file__))
    for _ in range(4):
        candidate = os.path.join(here, ".env")
        if os.path.exists(candidate):
            env_vars = {}
            with open(candidate, encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith("#"):
                        continue
                    if "=" in line:
                        k, _, v = line.partition("=")
                        env_vars[k.strip()] = v.strip().strip('"').strip("'")
            return env_vars.get("GITCODE_COOKIE", "")
        here = os.path.dirname(here)
    return ""


def _extract_jwt(raw):
    """从整串 cookie 中提取 GITCODE_ACCESS_TOKEN 的 JWT 值。

    "GITCODE_ACCESS_TOKEN=eyJ...; k=v" → "eyJ..."
    纯 JWT 串（不含 "=" 前缀）直接返回原值。
    """
    if not raw:
        return raw
    m = re.search(r"GITCODE_ACCESS_TOKEN=([^;]+)", raw)
    if m:
        return m.group(1)
    return raw


class RunnerConfig:
    """执行器配置。默认对齐当前被测实例（bingo），可由环境变量覆盖。"""

    def __init__(self, owner=None, repo=None, branch=None,
                 api_base=None, token=None,
                 timeout=None, poll_interval=None, executor=None,
                 cookie=None, workflow_id=None):
        self.owner = owner or os.environ.get("GITCODE_OWNER", "ComputingActionTest")
        self.repo = repo or os.environ.get("GITCODE_REPO", "bingo")
        self.branch = branch or os.environ.get("GITCODE_BRANCH", "main")
        self.api_base = (api_base or os.environ.get("GITCODE_API_BASE_URL",
                                                    "https://api.gitcode.com")).rstrip("/")
        self.token = token or self._load_token()
        self.timeout = int(timeout or os.environ.get("PHASE02_CASE_TIMEOUT", 300))
        self.poll_interval = int(poll_interval or os.environ.get("PHASE02_POLL_INTERVAL", 12))
        self.executor = executor or os.environ.get("GITCODE_EXECUTOR", "")
        self.cookie = cookie or self._load_cookie()
        self.workflow_id = workflow_id or os.environ.get("GITCODE_WORKFLOW_ID", "b03a4b84cd784ddea00c5270eba62c7f")

    @staticmethod
    def _load_token():
        path = os.path.expanduser(os.environ.get("GITCODE_TOKEN_FILE", "~/.gitcode-token"))
        if os.path.exists(path):
            return open(path, encoding="utf-8").read().strip()
        env = os.environ.get("GITCODE_ACCESS_TOKEN", "")
        if env:
            return env
        raise FileNotFoundError(
            "未找到 GitCode token：既无 ~/.gitcode-token 也无 GITCODE_ACCESS_TOKEN")

    @staticmethod
    def _load_cookie():
        cookie = os.environ.get("GITCODE_COOKIE", "")
        if not cookie:
            cookie = _load_dotenv_cookie()
        if not cookie:
            path = os.path.expanduser("~/.gitcode-cookie")
            if os.path.exists(path):
                cookie = open(path, encoding="utf-8").read().strip()
        if not cookie:
            log("  (警告) GITCODE_COOKIE 未配置 — dispatch 触发不可用")
            return ""
        return _extract_jwt(cookie)

    @staticmethod
    def _load_token():
        path = os.path.expanduser(os.environ.get("GITCODE_TOKEN_FILE", "~/.gitcode-token"))
        if os.path.exists(path):
            return open(path, encoding="utf-8").read().strip()
        env = os.environ.get("GITCODE_ACCESS_TOKEN", "")
        if env:
            return env
        raise FileNotFoundError(
            "未找到 GitCode token：既无 ~/.gitcode-token 也无 GITCODE_ACCESS_TOKEN")


def log(msg):
    print(f"[{time.strftime('%H:%M:%S')}] {msg}", flush=True)


# ── HTTP（带重试；失败抛 ApiError → 上层落 ENV_ERROR）────────────────
class ApiError(RuntimeError):
    pass


def api_get(cfg, path, retries=2):
    """GET {api_base}/api/v8/repos/{owner}/{repo}{path}。重试 retries 次。"""
    base = f"{cfg.api_base}/api/v8/repos/{cfg.owner}/{cfg.repo}{path}"
    sep = "&" if "?" in base else "?"
    url = f"{base}{sep}access_token={cfg.token}"
    if cfg.executor:
        url += f"&executor={cfg.executor}"
    last = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, method="GET")
            with urllib.request.urlopen(req, timeout=30) as r:
                return json.loads(r.read().decode("utf-8", errors="replace"))
        except urllib.error.HTTPError as e:
            # 4xx 不重试（token/资源问题），5xx 重试
            if 400 <= e.code < 500:
                raise ApiError(f"HTTP {e.code} on {path}")
            last = ApiError(f"HTTP {e.code} on {path}")
        except Exception as e:  # 网络/超时
            last = ApiError(f"{type(e).__name__}: {e} on {path}")
        if attempt < retries:
            time.sleep(2)
    raise last or ApiError(f"unknown error on {path}")


def api_post(cfg, path, body, retries=1, token_override=None):
    """POST {api_base}/api/v5/repos/{owner}/{repo}{path}。用 access_token 认证。
    token_override: 非空时替换 cfg.token（如 contributor token 场景）。
    """
    token = token_override or cfg.token
    url = f"{cfg.api_base}/api/v5/repos/{cfg.owner}/{cfg.repo}{path}?access_token={token}"
    data = json.dumps(body).encode("utf-8")
    last = None
    for attempt in range(retries + 1):
        try:
            req = urllib.request.Request(url, data=data, method="POST")
            req.add_header("Content-Type", "application/json")
            with urllib.request.urlopen(req, timeout=30) as r:
                return r.status, json.loads(r.read().decode("utf-8", errors="replace"))
        except urllib.error.HTTPError as e:
            try:
                err_body = json.loads(e.read().decode("utf-8", errors="replace"))
            except Exception:
                err_body = {}
            if 400 <= e.code < 500:
                raise ApiError(f"HTTP {e.code} on POST {path}: {err_body}")
            last = ApiError(f"HTTP {e.code} on POST {path}")
        except Exception as e:
            last = ApiError(f"{type(e).__name__}: {e} on POST {path}")
        if attempt < retries:
            time.sleep(2)
    raise last or ApiError(f"unknown error on POST {path}")


# ── Web-API（web-api.gitcode.com，cookie 认证，用于 dispatch/list）─────
_WEB_HOST = "web-api.gitcode.com"


def _enc(project_path):
    return project_path.replace("/", "%2F")


def _build_web_headers(cookie):
    return {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {cookie}",
        "Origin": "https://gitcode.com",
        "Referer": "https://gitcode.com/",
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
        "X-App-Channel": "gitcode-fe",
        "X-App-Version": "0",
        "X-Device-ID": "unknown",
        "X-Device-Type": "Linux",
        "X-Platform": "web",
        "Cookie": f"GITCODE_ACCESS_TOKEN={cookie}; GitCodeUserName=ccijunk",
    }


def list_workflows(cookie, project_path):
    """列出项目的所有 workflow。返回 workflow 列表 [{workflow_id, file_path, name}, ...]。
    接口: POST web-api.gitcode.com/api/v2/projects/{enc}/actions/workflows/list
    """
    headers = _build_web_headers(cookie)
    url = f"https://{_WEB_HOST}/api/v2/projects/{_enc(project_path)}/actions/workflows/list"
    data = json.dumps({}).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=30) as r:
        body = json.loads(r.read().decode("utf-8", errors="replace"))
    return body.get("content", [])


def dispatch_workflow(cookie, project_path, workflow_id, file_path,
                      ref, branch, repo_https_url, inputs=None):
    """手动触发一次 workflow 运行。返回 (status_code, workflow_run_id_or_None, err_msg)。
    接口: POST web-api.gitcode.com/api/v2/projects/{enc}/actions/workflows/{wf_id}/dispatch
    """
    headers = _build_web_headers(cookie)
    url = f"https://{_WEB_HOST}/api/v2/projects/{_enc(project_path)}/actions/workflows/{workflow_id}/dispatch"
    payload = {
        "ref": ref,
        "branch": branch,
        "branch_commit_id": "",
        "repo_https_url": repo_https_url,
        "file_path": file_path,
        "inputs": inputs or {},
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            body = json.loads(r.read().decode("utf-8", errors="replace"))
        return r.status, body.get("workflow_run_id"), ""
    except urllib.error.HTTPError as e:
        try:
            body = json.loads(e.read().decode("utf-8", errors="replace"))
        except Exception:
            body = {}
        err = body.get("message") or body.get("error") or body.get("msg") or body.get("detail") or ""
        if not err:
            err = json.dumps(body, ensure_ascii=False)[:300]
        return e.code, body.get("workflow_run_id"), str(err)
    except Exception as ex:
        return -1, None, f"{type(ex).__name__}: {ex}"


# ── git shell ─────────────────────────────────────────────────────
def _sh(cmd, cwd=None):
    r = subprocess.run(cmd, cwd=cwd, shell=True, capture_output=True,
                       text=True, encoding="utf-8")
    return r.returncode, (r.stdout or "") + (r.stderr or "")


HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)

# ── 工作区（持久化缓存，跨 batch 复用；首次 clone，后续 git pull）──
_CACHE_ROOT = os.path.join(PHASE02, ".cache", "repos")


class Workspace:
    """clone 一次测试仓到持久缓存目录，退出时保留以备下个 batch 复用。"""

    def __init__(self, cfg):
        self.cfg = cfg
        self.repo_dir = os.path.join(_CACHE_ROOT, cfg.owner, cfg.repo)

    def __enter__(self):
        url = (f"https://oauth2:{self.cfg.token}@gitcode.com/"
               f"{self.cfg.owner}/{self.cfg.repo}.git")
        if os.path.isdir(os.path.join(self.repo_dir, ".git")):
            # 缓存存在：拉取最新、强制对齐远程（抹掉上次 batch 的 teardown 残留）
            rc, out = _sh("git fetch --depth 1 origin", cwd=self.repo_dir)
            if rc == 0:
                _sh(f"git checkout -q {self.cfg.branch}", cwd=self.repo_dir)
                _sh(f"git reset --hard origin/{self.cfg.branch}", cwd=self.repo_dir)
            else:
                # fetch 失败则重新 clone
                shutil.rmtree(self.repo_dir, ignore_errors=True)
        if not os.path.isdir(os.path.join(self.repo_dir, ".git")):
            os.makedirs(os.path.dirname(self.repo_dir), exist_ok=True)
            rc, out = _sh(f'git clone --depth 1 "{url}" "{self.repo_dir}"')
            if rc != 0:
                raise ApiError(f"git clone 失败: {out[-200:]}")
        return self

    def __exit__(self, *exc):
        pass  # 持久化缓存，不删除


# ── 0. 预检（push 前本地校验，拦编译错误，零 API 依赖）─────────────
# GitCode step name 禁止字符（VALIDATION-RULES §3b）
_STEP_NAME_FORBIDDEN = set('[]|!>&#?*=<\'"@${}+')

# Phase 01 可执行用例契约 schema 校验常量（来自 schema_check.py + executable-case.schema.yaml）
_CASE_ID_RE = re.compile(r"^(COMP|COMPAT|REL|SEC|USE)-[A-Z0-9]+(?:-[A-Z0-9]+)*-\d{2}-\d{3}(-V\d+)?$")
_CASE_DIMS = {"completeness", "compatibility", "reliability", "security", "usability"}
_CASE_PRIOS = {"P0", "P1", "P2"}
_CASE_ATYPES = {"positive", "negative", "nonfunctional"}
_CASE_INTENT_RE = re.compile(r"^(INTENT-(COMP|COMPAT|REL|SEC|USE|ACT)(-NEW)?-[0-9]+|KEEP-TC-[0-9~]+)$")
_CASE_TRIGGER_EVENTS = {"push", "pr", "pull_request", "fork_pr", "pull_request_target",
                        "pull_request_comment", "manual", "schedule", "tag",
                        "workflow_dispatch", "issue_comment"}
_CASE_TRIGGER_AS = {"maintainer", "untrusted_contributor"}
_CASE_RESETS = {"fixture", "full_instance", "none"}
_CASE_FI_AT = {"pre_job", "mid_job", "post_job"}
_CASE_FI_ACTION = {"kill_runner", "network_partition", "disk_full", "cpu_saturate", "concurrent_flood"}
# 破坏性 action（会改宿主持久状态，reset=none 不可接受）
_DESTRUCTIVE_FI_ACTIONS = {"kill_runner", "network_partition", "disk_full", "cpu_saturate"}
# concurrent_flood：瞬态并发注入、进程退出即恢复，reset=none 可接受


def _validate_case_contract(contract):
    """校验 Phase 01 契约 YAML 结构（来自 schema_check.py / executable-case.schema.yaml）。

    返回 errors 列表（空=通过）。不涉及 workflow 内容——那是 _validate_workflow_syntax 的职责。
    """
    errs = []
    if not isinstance(contract, dict):
        return ["契约顶层非映射"]

    # 必填字段
    for k in ("id", "dimension", "priority", "title", "intent_ref",
              "setup", "trigger", "assertions", "teardown"):
        if k not in contract:
            errs.append(f"缺必填字段 {k}")

    # id 格式
    cid = contract.get("id")
    if cid and not _CASE_ID_RE.match(str(cid)):
        errs.append(f"id 格式不合规（{_CASE_ID_RE.pattern}）: {cid}")

    # dimension 枚举
    dim = contract.get("dimension")
    if dim and dim not in _CASE_DIMS:
        errs.append(f"dimension 非法: {dim}（合法值: {sorted(_CASE_DIMS)}）")

    # priority 枚举
    prio = contract.get("priority")
    if prio and prio not in _CASE_PRIOS:
        errs.append(f"priority 非法: {prio}（合法值: {sorted(_CASE_PRIOS)}）")

    # intent_ref 格式
    iref = contract.get("intent_ref")
    if iref and not _CASE_INTENT_RE.match(str(iref)):
        errs.append(f"intent_ref 格式不合规: {iref}（须匹配 {_CASE_INTENT_RE.pattern}）")

    # setup
    setup = contract.get("setup")
    if isinstance(setup, dict) and "repo_fixture" not in setup:
        errs.append("setup 缺 repo_fixture")

    # trigger
    trigger = contract.get("trigger")
    if isinstance(trigger, dict):
        if isinstance(trigger.get("event"), str) and trigger["event"] not in _CASE_TRIGGER_EVENTS:
            errs.append(f"trigger.event 非法: {trigger['event']}（合法值: {sorted(_CASE_TRIGGER_EVENTS)}）")
        if isinstance(trigger.get("as"), str) and trigger["as"] not in _CASE_TRIGGER_AS:
            errs.append(f"trigger.as 非法: {trigger['as']}（合法值: {sorted(_CASE_TRIGGER_AS)}）")

    # assertions
    asserts = contract.get("assertions")
    if not isinstance(asserts, list) or not asserts:
        errs.append("assertions 必须为非空数组")
    else:
        for i, a in enumerate(asserts):
            if not isinstance(a, dict):
                errs.append(f"assertions[{i}] 非映射")
                continue
            if a.get("type") not in _CASE_ATYPES:
                errs.append(f"assertions[{i}].type 非法: {a.get('type')}（合法值: {sorted(_CASE_ATYPES)}）")
            if "target" not in a:
                errs.append(f"assertions[{i}] 缺 target")

    # 安全用例至少一条 negative 断言
    if dim == "security" and isinstance(asserts, list):
        if not any(isinstance(a, dict) and a.get("type") == "negative" for a in asserts):
            errs.append("security 用例至少需一条 type=negative 断言")

    # teardown
    td = contract.get("teardown")
    if isinstance(td, dict):
        if td.get("reset") not in _CASE_RESETS:
            errs.append(f"teardown.reset 非法: {td.get('reset')}（合法值: {sorted(_CASE_RESETS)}）")

    # fault_injection 校验：仅破坏性 action 不得 reset=none
    fi = contract.get("fault_injection")
    if isinstance(fi, dict):
        if isinstance(td, dict) and td.get("reset") == "none":
            if fi.get("action") in _DESTRUCTIVE_FI_ACTIONS:
                errs.append(f"fault_injection action={fi['action']} 为破坏性注入，teardown.reset 不得为 none")
            # concurrent_flood 等瞬态注入：reset=none 放行
        if fi.get("at") not in _CASE_FI_AT:
            errs.append(f"fault_injection.at 非法: {fi.get('at')}（合法值: {sorted(_CASE_FI_AT)}）")
        if fi.get("action") not in _CASE_FI_ACTION:
            errs.append(f"fault_injection.action 非法: {fi.get('action')}（合法值: {sorted(_CASE_FI_ACTION)}）")
        if not fi.get("recovery_expectation"):
            errs.append("fault_injection 缺 recovery_expectation")

    return errs


def _validate_workflow_syntax(workflow_yaml):
    """校验 GitCode workflow YAML 语法合规性（内部辅助，被 preflight_validate 调用）。

    返回 errors 列表（空=通过）。依据 phase01/schema/VALIDATION-RULES.md（平台实测 12 条）
    + PyYAML 语法解析。纯本地、零 API/凭据依赖。
    """
    errors = []

    # 1) YAML 语法
    try:
        doc = yaml.safe_load(workflow_yaml)
    except yaml.YAMLError as e:
        mark = getattr(e, "problem_mark", None)
        loc = f"（第 {mark.line + 1} 行）" if mark else ""
        return [f"workflow YAML 语法错误{loc}: {getattr(e, 'problem', e)}"]
    if not isinstance(doc, dict):
        return ["workflow 顶层不是映射"]

    # 2) on 触发器：必须映射形式，不能列表（平台拒绝 §3.3）
    trigger = doc.get("on", doc.get(True))
    if trigger is None:
        errors.append("缺 on 触发器")
    elif isinstance(trigger, list):
        errors.append("on 用了列表形式（on: [push]），平台会拒绝；须用映射 on:\\n  push:\\n    branches: [...]")

    # 3) jobs
    jobs = doc.get("jobs")
    if (not jobs or not isinstance(jobs, dict)) and isinstance(doc.get("stages"), dict):
        return errors  # stages: 合法替代结构，跳过 jobs 检查
    if not isinstance(jobs, dict) or not jobs:
        return errors + ["缺 jobs 或 jobs 非映射"]

    for jid, job in jobs.items():
        if not isinstance(job, dict):
            errors.append(f"job '{jid}' 非映射"); continue
        if not job.get("name"):
            errors.append(f"job '{jid}' 缺 name（平台报 name cannot be empty）")
        if job.get("uses"):
            continue  # workflow_call 调用 job：不需要 runs-on/steps，跳过后续检查
        ro = job.get("runs-on")
        if not isinstance(ro, list):
            errors.append(f"job '{jid}' runs-on 须用数组格式 [ubuntu-latest, x64, small]，实得 {type(ro).__name__}")
        steps = job.get("steps") or []
        if len(steps) > 16:
            errors.append(f"job '{jid}' steps={len(steps)} 超过 16，须拆 job（§5）")
        for i, st in enumerate(steps):
            if not isinstance(st, dict):
                errors.append(f"job '{jid}' step[{i}] 非映射"); continue
            nm = st.get("name")
            if not nm:
                errors.append(f"job '{jid}' step[{i}] 缺 name（含 bare uses step）")
            else:
                bad = _STEP_NAME_FORBIDDEN & set(str(nm))
                if bad:
                    errors.append(f"job '{jid}' step name 含非法字符 {sorted(bad)}: {nm!r}")
                if len(str(nm)) > 128:
                    errors.append(f"job '{jid}' step name 超 128 字符")

    return errors


def _validate_workflow_via_api(workflow_yaml, cfg=None):
    """调用 GitCode v2 API 校验 workflow YAML 语法（server-side validation）。

    使用 validate_workflow.py 的 validate_workflow() 函数，走 web-api.gitcode.com 的
    /api/v2/projects/.../actions/valid 端点。需 GITCODE_COOKIE（浏览器会话 token）；
    无 cookie 则跳过（返回空 errors + 日志提示）。

    返回 (errors: list[str], api_result: dict|None)。
    """
    cookie = (cfg.cookie if cfg else "") or os.environ.get("GITCODE_COOKIE", "")
    if not cookie:
        log("  (preflight: 跳过 API 校验 — 无 GITCODE_COOKIE)")
        return [], None

    try:
        from validate_workflow import validate_workflow as _vwf_call
    except ImportError:
        log("  (preflight: 跳过 API 校验 — validate_workflow 模块不可用)")
        return [], None

    owner = cfg.owner if cfg else os.environ.get("GITCODE_OWNER", "ComputingActionTest")
    repo = cfg.repo if cfg else os.environ.get("GITCODE_REPO", "bingo")
    wfid = cfg.workflow_id if cfg else os.environ.get("GITCODE_WORKFLOW_ID", "b03a4b84cd784ddea00c5270eba62c7f")

    try:
        result = _vwf_call(
            file_content=workflow_yaml,
            cookie=cookie,
            workflow_id=wfid,
            project_path=f"{owner}/{repo}",
            file_path=".gitcode/workflows/_preflight_check.yml",
        )
    except Exception as e:
        log(f"  (preflight: API 校验调用失败: {e})")
        return [], None

    errors = []
    if result.get("valid") is True:
        return errors, result
    if result.get("diagnostics"):
        for d in result["diagnostics"]:
            sev = d.get("severity", "?")
            msg = d.get("message") or "(no detail)"
            rng = d.get("range", {})
            s = rng.get("start", {})
            errors.append(f"[API/{sev}] L{s.get('line','?')}:C{s.get('column','?')} — {msg}")
    elif result.get("error"):
        log(f"  (preflight: API 校验异常: {result['error']})")
    return errors, result


def preflight_validate(contract, cfg=None):
    """push 前校验——先校验用例契约字段，再本地 workflow 语法，最后 GitCode API 语法校验。

    接受 Phase 01 契约 dict + 可选 RunnerConfig（用于 API 校验的 cookie/project 等信息）。
    返回 (ok: bool, errors: list[str])。ok=False → run_case 应判 COMPILE_ERROR，
    **不 push**（省一次真跑）。

    三步校验：
      1. 用例契约字段 schema（id/dimension/priority/assertions…依据 executable-case.schema.yaml）
      2. 内联 workflow YAML 本地语法校验（依据 VALIDATION-RULES.md 平台实测规则）
      3. GitCode v2 API 服务器端 workflow 语法校验（调用 validate_workflow.py；需 GITCODE_COOKIE）
    """
    errors = []

    errors.extend(_validate_case_contract(contract))

    wf = contract.get("workflow")
    if wf:
        errors.extend(_validate_workflow_syntax(wf))
        # API 校验（需 cookie，无 cookie 时跳过不阻断）
        api_errs, _ = _validate_workflow_via_api(wf, cfg)
        errors.extend(api_errs)

    return (len(errors) == 0), errors


# ── 1. 部署（写 workflow、commit、push）→ (sha, wf_filename, {})────
def _push_with_retry(branch, cwd):
    """git push 失败时 pull --rebase 后重试，最多4次，指数退避（1s/2s/4s）。

    返回 (rc, output)。重试仍失败返回最后一次 push 的 (rc, output)。
    """
    for attempt in range(4):
        rc, out = _sh(f"git push origin {branch}", cwd=cwd)
        if rc == 0:
            return rc, out
        if attempt < 3:
            log(f"  push 失败（第{attempt+1}次），pull --rebase 后重试...")
            _sh(f"git pull --rebase origin {branch}", cwd=cwd)
            time.sleep(2 ** attempt)  # 1s, 2s, 4s
    return rc, out


def deploy(ws, cfg, case_id, workflow_yaml):
    """把 workflow 正文写入 .gitcode/workflows/<case-id>.yml 并 push。

    返回 (head_sha, wf_filename, {})。push 失败返回 (None, wf_filename, {})。
    """
    wf_filename = case_id.lower().replace("_", "-") + ".yml"
    dst = os.path.join(ws.repo_dir, ".gitcode", "workflows", wf_filename)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    with open(dst, "w", encoding="utf-8", newline="\n") as f:
        f.write(workflow_yaml)
    _sh("git add .gitcode/workflows/", cwd=ws.repo_dir)
    # 无变更时用 --allow-empty 强制触发一次
    rc_nodiff, _ = _sh("git diff --cached --quiet", cwd=ws.repo_dir)
    allow = "--allow-empty " if rc_nodiff == 0 else ""
    _sh(f'git commit {allow}-m "test: {case_id}"', cwd=ws.repo_dir)
    rc, out = _push_with_retry(cfg.branch, ws.repo_dir)
    if rc != 0:
        log(f"  push 失败（重试后仍失败）: {out[-200:]}")
        return None, wf_filename, {}
    rc, sha = _sh("git rev-parse HEAD", cwd=ws.repo_dir)
    return sha.strip(), wf_filename, {}


# ── 2. 轮询（head_sha AND file_path 精确匹配）→ run dict | None ─────
_TERMINAL = ("COMPLETED", "FAILED", "CANCELED", "IGNORED")


def poll_run(cfg, sha, wf_filename, match_event=None):
    """轮询到匹配的 run 抵达终态。

    match_event: 非 push 触发时用于辅助匹配的 event 类型（tag→CreateTag, pr→MR）。
                提供时去掉 branch 过滤 + 跳过 head_sha 检查（PR/tag 的 sha 与 deploy sha 不同）。
    """
    elapsed, pending = 0, None
    target_path = f".gitcode/workflows/{wf_filename}"
    is_non_push = match_event is not None
    while elapsed < cfg.timeout:
        if is_non_push:
            url = f"/actions/runs?per_page=30&event={match_event}"
        else:
            url = f"/actions/runs?branch={cfg.branch}&per_page=30"
        d = api_get(cfg, url)
        runs = d.get("workflow_runs", []) if isinstance(d, dict) else []
        for r in runs:
            fp = r.get("file_path") or ""
            if fp == target_path or fp.endswith(f"/{wf_filename}"):
                if not is_non_push:
                    hs = r.get("head_sha") or ""
                    if hs and hs != sha:
                        continue
                if r.get("status") in _TERMINAL:
                    return r
                pending = r
        time.sleep(cfg.poll_interval)
        elapsed += cfg.poll_interval
    return pending


# ── 3. 采集 → RunResult ───────────────────────────────────────────
def collect(cfg, run, fetch_logs=False):
    """采集 run/job/step 状态（+可选日志正文）→ RunResult dict。

    job 元信息用 log_fetcher.list_jobs（以 run detail stages.jobs[].id 为准，
    比 /jobs 接口的 id 更可靠——后者某些场景返回空串，见 log_fetcher 说明）。
    日志用 log_fetcher.fetch_job_logs 走 v8 download_log(zip)，抓**原始正文
    （不含 step 名）**，供负向断言全文扫描而不被污染。仅需 OAuth token。
    """
    rid = run.get("workflow_run_id", "") or run.get("id", "")
    try:
        jobs_meta = log_fetcher.list_jobs(cfg.owner, cfg.repo, rid)
    except Exception as e:
        raise ApiError(f"list_jobs 失败: {e}")

    jobs, logs_parts = [], []
    for j in jobs_meta:
        steps = [{"name": s.get("name"), "status": s.get("status")}
                 for s in (j.get("steps") or []) if isinstance(s, dict)]
        jobs.append({"id": j.get("id"), "name": j.get("name"),
                     "status": j.get("status"), "steps": steps})
        if fetch_logs:
            try:
                logs_parts.append(
                    log_fetcher.fetch_job_logs(None, cfg.owner, cfg.repo, rid, j))
            except Exception as e:
                logs_parts.append(f"<log-fetch-error: {e}>")

    return {
        "status": run.get("status"),
        "gitcode_run_id": rid,
        "conclusion": run.get("conclusion") or run.get("status"),
        "event": run.get("event"),
        "head_sha": run.get("head_sha"),
        "jobs": jobs,
        "logs": "\n".join(logs_parts),
        "logs_available": bool(fetch_logs),
        "artifacts": [],  # v8 artifacts 采集按需补
        "run_url": f"https://gitcode.com/{cfg.owner}/{cfg.repo}/actions/runs/{rid}" if rid else "",
    }


# ── 高层：一条用例 部署→轮询→采集 ─────────────────────────────────
# ── 触发适配器（确定性；把 trigger.event 翻译成对 GitCode 的操作）──────
# ★ 架构：所有"触发前置操作"（建 PR / 建 tag / dispatch）都是**确定性**的，归属本模块，
#   不交给任何 LLM agent（LLM 只做只读的检查/归因）。push 已实现；其余为可确定性实现的
#   扩展点——需先验证 GitCode 对应 API/语义，未实现前如实返回 unsupported 原因（→ INCONCLUSIVE）。
TRIGGER_STATUS = {
    "push":                 {"supported": True},
    "tag":                  {"supported": True},
    "manual":               {"supported": True},
    "workflow_dispatch":    {"supported": True},
    "pr":                   {"supported": True},
    "pull_request":         {"supported": True},
    "pull_request_target":  {"supported": True},
    "pull_request_comment": {"supported": True},
    "issue_comment":        {"supported": True},
    "fork_pr":              {"supported": False,
                             "reason": "fork_pr：需第二 GitCode 账号/token 模拟 untrusted 外部贡献者（基础设施依赖）"},
    "schedule":             {"supported": True},
}


def trigger_supported(event):
    """返回 (supported: bool, reason: str)。未知事件视为不支持。"""
    info = TRIGGER_STATUS.get(event)
    if info is None:
        return False, f"未知触发事件 '{event}'"
    return info["supported"], info.get("reason", "")


def teardown(ws, cfg, wf_filename):
    """删除本次部署的 workflow 文件并 push（fixture 级清理，防仓库污染）。

    ★ 为什么需要：共享仓里每个 on:push 的 workflow 文件都会被后续任何 push 连带触发，
    不清理会越积越多、互相污染、淹没结果（曾积累 45 个遗留文件）。best-effort，失败不阻断。
    """
    path = f".gitcode/workflows/{wf_filename}"
    rc, _ = _sh(f"git rm -q {path}", cwd=ws.repo_dir)
    if rc != 0:
        return False
    _sh('git commit -q -m "chore: teardown test workflow"', cwd=ws.repo_dir)
    rc, out = _push_with_retry(cfg.branch, ws.repo_dir)
    if rc != 0:
        log(f"  teardown push 失败（重试后仍失败）: {out[-150:]}")
    return rc == 0


# ── Dispatch 触发（workflow_dispatch）───────────────────────────────
def _poll_run_by_id(cfg, run_id):
    """按 run_id 轮询到终态。返回 run dict 或 None。"""
    elapsed = 0
    while elapsed < cfg.timeout:
        try:
            d = api_get(cfg, f"/actions/runs/{run_id}")
        except ApiError:
            time.sleep(cfg.poll_interval)
            elapsed += cfg.poll_interval
            continue
        if d.get("status") in _TERMINAL:
            return d
        time.sleep(cfg.poll_interval)
        elapsed += cfg.poll_interval
    return None


def trigger_dispatch(ws, cfg, case_id, workflow_yaml, fetch_logs=False):
    """workflow_dispatch 触发链路：deploy → dispatch → poll → collect。

    cookie 不可用时返回 INCONCLUSIVE。
    """
    t0 = time.time()
    if not cfg.cookie:
        return _exec_result("INCONCLUSIVE", case_id,
                            reason="GITCODE_COOKIE 未配置，dispatch 触发不可用", t0=t0)
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, workflow_yaml)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        project_path = f"{cfg.owner}/{cfg.repo}"
        wf_id = None
        wf_file_path = None
        for retry in range(6):
            if retry > 0:
                time.sleep(5)
            try:
                wfs = list_workflows(cfg.cookie, project_path)
            except Exception:
                continue
            for w in wfs:
                fp = w.get("file_path") or ""
                if fp.endswith(wf_filename):
                    wf_id = w.get("workflow_id")
                    wf_file_path = fp
                    break
            if wf_id:
                break
        if not wf_id:
            return _exec_result("INCONCLUSIVE", case_id,
                                reason=f"list_workflows 未找到匹配 {wf_filename} 的 workflow_id", t0=t0)
        repo_https_url = f"https://gitcode.com/{cfg.owner}/{cfg.repo}.git"
        code, run_id, err_msg = dispatch_workflow(cfg.cookie, project_path, wf_id,
                                         wf_file_path, cfg.branch, cfg.branch,
                                         repo_https_url)
        if code != 200 or not run_id:
            reason = f"dispatch_workflow 返回 HTTP {code}: {err_msg}" if err_msg else f"dispatch_workflow 返回 HTTP {code}, run_id={run_id}"
            return _exec_result("ENV_ERROR", case_id, reason=reason, t0=t0)
        log(f"  dispatch: workflow_run_id={run_id}")
        run = _poll_run_by_id(cfg, run_id)
        if run is None:
            return _exec_result("TIMEOUT", case_id, gitcode_run_id=run_id, t0=t0)
        rr = collect(cfg, run, fetch_logs=fetch_logs)
        rr["duration_seconds"] = round(time.time() - t0)
        if rr.get("status") == "FAILED" and not rr.get("jobs"):
            rr["workflow_rejected"] = True
            rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝"
        return rr
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)
    except Exception as e:
        return _exec_result("ENV_ERROR", case_id, reason=f"dispatch 异常: {e}", t0=t0)


def trigger_tag(ws, cfg, case_id, workflow_yaml, fetch_logs=False):
    """tag 触发链路：deploy → git tag + push → poll_run（确定性，纯 git，零 API）。

    push 一个 tag 触发 workflow，按 sha+file_path 轮询匹配。
    """
    t0 = time.time()
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, workflow_yaml)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        tag = f"test-{case_id.lower().replace('_','-')}"
        rc, out = _sh(f"git tag {tag}", cwd=ws.repo_dir)
        if rc != 0:
            return _exec_result("ENV_ERROR", case_id, reason=f"git tag 失败: {out[-200:]}", t0=t0)
        rc, out = _sh(f"git push origin {tag}", cwd=ws.repo_dir)
        if rc != 0:
            return _exec_result("ENV_ERROR", case_id, reason=f"git push tag 失败: {out[-200:]}", t0=t0)
        log(f"  tag pushed: {tag}")
        run = poll_run(cfg, sha, wf_filename, match_event="CreateTag")
        if run is None:
            return _exec_result("NO_RUN", case_id, head_sha=sha, t0=t0)
        if run.get("status") not in _TERMINAL:
            return _exec_result("TIMEOUT", case_id, head_sha=sha,
                                gitcode_run_id=run.get("workflow_run_id", ""), t0=t0)
        rr = collect(cfg, run, fetch_logs=fetch_logs)
        rr["duration_seconds"] = round(time.time() - t0)
        if rr.get("status") == "FAILED" and not rr.get("jobs"):
            rr["workflow_rejected"] = True
            rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝"
        return rr
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)


def trigger_pr(ws, cfg, case_id, workflow_yaml, fetch_logs=False):
    """PR 触发链路：deploy → 建分支+push → 开 PR（v5 API）→ 轮询 match PR run。

    pr 和 pull_request 共用此实现。PR 创建端点使用 v5 API：
    POST /api/v5/repos/{owner}/{repo}/pulls  body: {title, head, base}
    """
    t0 = time.time()
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, workflow_yaml)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        pr_branch = f"pr-{case_id.lower().replace('_','-')}"
        rc, out = _sh(f"git checkout -b {pr_branch}", cwd=ws.repo_dir)
        rc, out = _sh(f"git push origin {pr_branch}", cwd=ws.repo_dir)
        if rc != 0:
            return _exec_result("ENV_ERROR", case_id, reason=f"git push pr branch 失败: {out[-200:]}", t0=t0)
        log(f"  pr branch pushed: {pr_branch}")
        code, pr_resp = api_post(cfg, "/pulls",
                                 {"title": f"test: {case_id}", "head": pr_branch, "base": cfg.branch})
        if code not in (200, 201):
            return _exec_result("ENV_ERROR", case_id,
                                reason=f"创建 PR 失败 HTTP {code}", t0=t0)
        pr_id = pr_resp.get("id") or pr_resp.get("number") or pr_resp.get("iid")
        log(f"  PR created: id={pr_id}, branch={pr_branch}")
        run = poll_run(cfg, sha, wf_filename, match_event="MR")
        if run is None:
            return _exec_result("NO_RUN", case_id, head_sha=sha, t0=t0)
        if run.get("status") not in _TERMINAL:
            return _exec_result("TIMEOUT", case_id, head_sha=sha,
                                gitcode_run_id=run.get("workflow_run_id", ""), t0=t0)
        rr = collect(cfg, run, fetch_logs=fetch_logs)
        rr["duration_seconds"] = round(time.time() - t0)
        if rr.get("status") == "FAILED" and not rr.get("jobs"):
            rr["workflow_rejected"] = True
            rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝"
        return rr
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)


def trigger_comment(ws, cfg, case_id, workflow_yaml, fetch_logs=False,
                    contributor_token=None):
    """评论触发链路：deploy → 建 Issue → 发评论 → 轮询 run。

    issue_comment / pull_request_comment 共用此实现。
    contributor_token：非空时用此 token 发评论（模拟 untrusted_contributor）。
    ★event 名未知：match_event=None 不过滤 event，只按 file_path 匹配。
    """
    t0 = time.time()
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, workflow_yaml)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        # 建 Issue
        code, issue_resp = api_post(cfg, "/issues",
                                    {"title": f"test: {case_id}", "body": "trigger"})
        if code not in (200, 201):
            return _exec_result("ENV_ERROR", case_id, reason=f"创建 issue 失败 HTTP {code}", t0=t0)
        issue_id = issue_resp.get("number") or issue_resp.get("id") or issue_resp.get("iid")
        log(f"  issue #{issue_id} created")
        # 发评论（untrusted 用 contributor_token）
        cmt_token = contributor_token or None
        code, _ = api_post(cfg, f"/issues/{issue_id}/comments",
                           {"body": f"trigger: {case_id}"},
                           token_override=cmt_token)
        if code not in (200, 201):
            return _exec_result("ENV_ERROR", case_id, reason=f"发 issue 评论失败 HTTP {code}", t0=t0)
        log(f"  issue comment posted on #{issue_id}")
        run = poll_run(cfg, sha, wf_filename, match_event=None)
        if run is None:
            return _exec_result("NO_RUN", case_id, head_sha=sha, t0=t0)
        if run.get("status") not in _TERMINAL:
            return _exec_result("TIMEOUT", case_id, head_sha=sha,
                                gitcode_run_id=run.get("workflow_run_id", ""), t0=t0)
        rr = collect(cfg, run, fetch_logs=fetch_logs)
        rr["duration_seconds"] = round(time.time() - t0)
        if rr.get("status") == "FAILED" and not rr.get("jobs"):
            rr["workflow_rejected"] = True
            rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝"
        return rr
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)


def trigger_schedule(ws, cfg, case_id, workflow_yaml, fetch_logs=False):
    """schedule 触发链路：replace cron(* * * * *) → deploy → poll(Schedule) → collect → ★强制teardown。

    ★污染红线：schedule 不删会永久每分钟触发→跑完必须删 workflow 文件并验证。
    """
    t0 = time.time()
    # 正则替换 cron 值为每分钟（字符串替换，不 yaml.dump 往返）
    import re as _re
    wf_replaced = _re.sub(r'(-?\s*cron\s*:\s*")[^"]*(")', r'\g<1>0 * * * * ?\2', workflow_yaml)
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, wf_replaced)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        log(f"  schedule deployed (cron→0 * * * * ?), waiting for trigger...")
        run = poll_run(cfg, sha, wf_filename, match_event="Schedule")
        if run is None:
            return _exec_result("NO_RUN", case_id, head_sha=sha, t0=t0)
        if run.get("status") not in _TERMINAL:
            return _exec_result("TIMEOUT", case_id, head_sha=sha,
                                gitcode_run_id=run.get("workflow_run_id", ""), t0=t0)
        rr = collect(cfg, run, fetch_logs=fetch_logs)
        rr["duration_seconds"] = round(time.time() - t0)
        if rr.get("status") == "FAILED" and not rr.get("jobs"):
            rr["workflow_rejected"] = True
            rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝"
        return rr
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)
    finally:
        # ★ schedule 强制 teardown：必须删 workflow 文件，防永久污染
        if wf_filename:
            ok = teardown(ws, cfg, wf_filename)
            wf_path = f".gitcode/workflows/{wf_filename}"
            full = os.path.join(ws.repo_dir, wf_path)
            deleted = not os.path.exists(full)
            if not ok or not deleted:
                log(f"  ⚠️ SCHEDULE TEARDOWN FAILED: {wf_filename} 残留！需手工清理 {cfg.repo} 仓！")
            else:
                log(f"  schedule teardown OK: {wf_filename} 已删除")


def run_case(ws, cfg, case_id, workflow_yaml, fetch_logs=False, teardown_reset="fixture",
             trigger_event="push"):
    """执行单条用例的"执行层"链路。返回 RunResult（含执行层异常状态）。

    执行层状态（映射 rules.md §11 的执行类判定）：
      NO_RUN       触发后没等到对应 run
      TIMEOUT      轮询超时且从未见到终态
      ENV_ERROR    API/网络错误（重试后仍失败）
      INCONCLUSIVE 触发方式尚未实现（见 TRIGGER_STATUS）
      其余         平台终态（COMPLETED/FAILED/...），交 assertion_engine 判定

    trigger_event：触发方式；push 已实现，其余（见 TRIGGER_STATUS）未实现 → INCONCLUSIVE + 具体原因。
    teardown_reset：`fixture`/`full_instance` → 跑完删除本次 push 的 workflow 文件（防污染）；`none` → 保留。
    注：workflow 合法性应在 push 前经 preflight_validate 拦截。
    """
    t0 = time.time()
    wf_filename = None
    # 触发适配：workflow_dispatch / manual 走 dispatch 链路
    if trigger_event in ("workflow_dispatch", "manual"):
        return trigger_dispatch(ws, cfg, case_id, workflow_yaml, fetch_logs=fetch_logs)
    # tag 走独立 tag 链路
    if trigger_event == "tag":
        return trigger_tag(ws, cfg, case_id, workflow_yaml, fetch_logs=fetch_logs)
    # issue_comment / pull_request_comment 走评论触发链路
    if trigger_event in ("issue_comment", "pull_request_comment"):
        return trigger_comment(ws, cfg, case_id, workflow_yaml, fetch_logs=fetch_logs)
    # schedule 走独立链路（cron替换 + 强制teardown）
    if trigger_event == "schedule":
        return trigger_schedule(ws, cfg, case_id, workflow_yaml, fetch_logs=fetch_logs)
    # pr / pull_request / pull_request_target 走 PR 链路
    if trigger_event in ("pr", "pull_request", "pull_request_target"):
        return trigger_pr(ws, cfg, case_id, workflow_yaml, fetch_logs=fetch_logs)
    ok, reason = trigger_supported(trigger_event)
    if not ok:
        return _exec_result("INCONCLUSIVE", case_id, reason=reason, t0=t0)
    try:
        sha, wf_filename, _ = deploy(ws, cfg, case_id, workflow_yaml)
        if not sha:
            return _exec_result("ENV_ERROR", case_id, reason="git push 失败", t0=t0)
        try:
            run = poll_run(cfg, sha, wf_filename)
            if run is None:
                return _exec_result("NO_RUN", case_id, head_sha=sha, t0=t0)
            if run.get("status") not in _TERMINAL:
                return _exec_result("TIMEOUT", case_id, head_sha=sha,
                                    gitcode_run_id=run.get("workflow_run_id", ""), t0=t0)
            rr = collect(cfg, run, fetch_logs=fetch_logs)
            rr["duration_seconds"] = round(time.time() - t0)
            # 平台终态 FAILED 但 0 job：极可能 workflow 被平台拒绝（SYNTAX_ERROR 类）。
            if rr.get("status") == "FAILED" and not rr.get("jobs"):
                rr["workflow_rejected"] = True
                rr["reason"] = "run FAILED 且 0 job：workflow 可能被平台拒绝（预检未覆盖的规则）"
            return rr
        finally:
            # 只对 push 触发执行 teardown（删 workflow 防共享仓污染），
            # 非 push 触发保留文件（可查 GitCode 界面工作流详情）
            if wf_filename and teardown_reset != "none" and trigger_event == "push":
                try:
                    teardown(ws, cfg, wf_filename)
                except Exception as e:
                    log(f"  teardown 异常（忽略）: {e}")
    except ApiError as e:
        return _exec_result("ENV_ERROR", case_id, reason=str(e), t0=t0)


def _exec_result(status, case_id, reason="", head_sha="", gitcode_run_id="", t0=None):
    return {
        "status": status,
        "case_id": case_id,
        "gitcode_run_id": gitcode_run_id,
        "conclusion": status,
        "head_sha": head_sha,
        "jobs": [],
        "logs": "",
        "logs_available": False,
        "artifacts": [],
        "reason": reason,
        "duration_seconds": round(time.time() - t0) if t0 else 0,
    }


# ── 5. 多仓批量轮询函数（拆解 poll_run，供 pool_scheduler 使用）───────────
def list_runs(cfg, per_page=30, event_filter=None):
    """拉 cfg.repo 最近 per_page 条 run（不阻塞、不匹配）。供调度器批量轮询。
    event_filter: 非 push 时用于过滤事件类型，此时不按 branch 过滤。
    """
    if event_filter:
        url = f"/actions/runs?per_page={per_page}&event={event_filter}"
    else:
        url = f"/actions/runs?branch={cfg.branch}&per_page={per_page}"
    d = api_get(cfg, url)
    return d.get("workflow_runs", []) if isinstance(d, dict) else []


def match_run(runs, sha, wf_filename, require_sha=True):
    """在 runs 里找匹配的 run。require_sha=False 时只按 file_path 匹配（非push用）。"""
    for r in runs:
        fp = (r.get("file_path") or "")
        if not fp.endswith(wf_filename):
            continue
        if not require_sha:
            return r
        if r.get("head_sha") == sha:
            return r
    return None


# ── 6. batch_end teardown + 孤儿清理 ────────────────────────────────────────
def teardown_batch(ws, cfg, wf_filenames):
    """整批结束后，一次性删除本仓本批 push 的所有 workflow 文件，单次 commit+push。"""
    if not wf_filenames:
        return
    for fn in wf_filenames:
        path = f".gitcode/workflows/{fn}"
        _sh(f"git rm -q {path}", cwd=ws.repo_dir)
    _sh('git commit -q -m "chore: batch teardown workflows"', cwd=ws.repo_dir)
    rc, out = _push_with_retry(cfg.branch, ws.repo_dir)
    if rc != 0:
        log(f"  teardown_batch push 失败（重试后仍失败）: {out[-150:]}")


def sweep_orphans(ws, cfg, keep=None):
    """启动时清理孤儿 workflow 文件（不属于本批基线的 <case-id>.yml）。
    扫描 .gitcode/workflows/，删掉不属于 keep 列表的文件，一次 commit+push。"""
    keep = keep or []
    wf_dir = os.path.join(ws.repo_dir, ".gitcode", "workflows")
    if not os.path.isdir(wf_dir):
        return
    orphaned = []
    for fn in os.listdir(wf_dir):
        if fn.endswith(".yml") and fn not in keep:
            orphaned.append(fn)
    if not orphaned:
        return
    log(f"  sweep_orphans({cfg.repo}): 清理 {len(orphaned)} 个孤儿文件")
    for fn in orphaned:
        _sh(f"git rm -q .gitcode/workflows/{fn}", cwd=ws.repo_dir)
    _sh('git commit -q -m "chore: sweep orphan workflows"', cwd=ws.repo_dir)
    rc_push, out_push = _sh(f"git pull --rebase origin {cfg.branch}", cwd=ws.repo_dir)
    rc_push, out_push = _sh(f"git push origin {cfg.branch}", cwd=ws.repo_dir)
    if rc_push != 0:
        log(f"  sweep_orphans push 失败: {out_push[-150:]}")


if __name__ == "__main__":
    # 自检：仅验证可 import 与配置装载，不触网。
    print("workflow_runner self-check: imports OK")
    try:
        cfg = RunnerConfig()
        print(f"  config: {cfg.owner}/{cfg.repo}@{cfg.branch} api={cfg.api_base} "
              f"executor={'set' if cfg.executor else '(none)'}")
    except Exception as e:
        print(f"  config load: {type(e).__name__}: {e}")
