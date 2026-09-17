#!/usr/bin/env python3
"""
log_fetcher.py — GitCode job 日志抓取器（harness 组件）

正解（2026-07-21 实测确认）: 官方 v8 **download_log(下划线)** 端点可用!
  GET /api/v8/repos/:owner/:repo/actions/runs/:run_id/jobs/:job_id/download_log?access_token=...
  → 302 重定向到 raw.gitcode.com → 200 application/zip
  → 解压: 每个 step 一个 `{seq}_{step_name}.log`（UTF-8 无 BOM）

  * 用 **OAuth token**（?access_token=），不需要浏览器 cookie/WAF——比旧的
    web-api 浏览器会话方案更稳，不会几天过期。
  * 端点名坑: `download-log`(连字符) 恒 404；`download_log`(下划线) 才对。
    且必须**跟随 302 重定向**（curl -L）。
  * job id 坑: `/actions/runs/{run}/jobs` 返回的 jobs[].id 在某些场景为空串；
    以 **run detail 的 stages.jobs[].id** 为准更可靠。

凭据: 仅需 OAuth token（~/.gitcode-token 或环境变量 GITCODE_ACCESS_TOKEN）。
      不再需要浏览器会话（旧的 ~/.gitcode-web-curl.txt 已弃用）。

用法:
  import log_fetcher
  jobs = log_fetcher.list_jobs(owner, repo, run_id)      # [{'id','name','steps':[...]}]
  raw  = log_fetcher.fetch_job_logs(None, owner, repo, run_id, job_meta)  # 纯正文(供扫描)
  text = log_fetcher.render_job_logs(None, owner, repo, run_id, job_meta) # 带 step 名(供人读)
"""
import os, io, json, zipfile, tempfile, urllib.request, urllib.error

API = "https://api.gitcode.com"


def _token():
    t = os.environ.get("GITCODE_ACCESS_TOKEN")
    if t:
        return t.strip()
    p = os.path.expanduser("~/.gitcode-token")
    if os.path.exists(p):
        return open(p, encoding="utf-8").read().strip()
    raise RuntimeError("未找到 OAuth token: 设 GITCODE_ACCESS_TOKEN 或 ~/.gitcode-token")


def load_creds(*a, **k):
    """兼容旧接口：zip 方案只需 OAuth token，返回占位 creds。"""
    return {"token": _token()}


def _get(url, binary=False):
    req = urllib.request.Request(url, headers={"User-Agent": "phase02-harness"})
    with urllib.request.urlopen(req, timeout=60) as r:  # urllib 默认跟随 302
        data = r.read()
        return data if binary else data.decode("utf-8", errors="replace")


def list_jobs(owner, repo, run_id):
    """取 job 元信息。优先 run detail 的 stages.jobs[].id（更可靠），
    回退到 /jobs 接口。返回 [{'id','name','status','steps':[{'id','name','status'}]}]。"""
    tok = _token()
    # 1) run detail → stages.jobs
    try:
        d = json.loads(_get(f"{API}/api/v8/repos/{owner}/{repo}/actions/runs/{run_id}?access_token={tok}"))
    except Exception:
        d = {}
    jobs = []
    for st in (d.get("stages") or []):
        for j in (st.get("jobs") or []):
            if j.get("id"):
                jobs.append(j)
    # 2) 回退 /jobs（补 steps 明细；有些字段只在这里）
    try:
        jd = json.loads(_get(f"{API}/api/v8/repos/{owner}/{repo}/actions/runs/{run_id}/jobs?access_token={tok}"))
        jobs_api = jd.get("jobs", [])
    except Exception:
        jobs_api = []
    if not jobs:  # stages 拿不到就用 /jobs
        jobs = [j for j in jobs_api if j.get("id")]
    # 用 /jobs 的 steps 补齐（按 name 对齐；download_log 只需 job id）
    by_name = {j.get("name"): j for j in jobs_api}
    out = []
    for j in jobs:
        merged = dict(j)
        alt = by_name.get(j.get("name"))
        if alt and alt.get("steps"):
            merged.setdefault("steps", alt["steps"])
        out.append(merged)
    return out


def download_job_log_zip(owner, repo, run_id, job_id):
    """下载并解压 job 日志 zip。返回 OrderedDict {logfile_name: text}。

    走 download_log(下划线) → 302 → raw.gitcode.com → application/zip。
    """
    tok = _token()
    url = (f"{API}/api/v8/repos/{owner}/{repo}/actions/runs/{run_id}"
           f"/jobs/{job_id}/download_log?access_token={tok}")
    raw = _get(url, binary=True)
    out = {}
    try:
        zf = zipfile.ZipFile(io.BytesIO(raw))
    except zipfile.BadZipFile:
        # 不是 zip（可能空 job / 无日志），返回空
        return out
    for name in zf.namelist():
        out[name] = zf.read(name).decode("utf-8", errors="replace")
    return out


def fetch_job_logs(creds, owner, repo, run_id, job_meta) -> str:
    """一个 job 全部 step 的**纯正文**拼接（供负向断言全文扫描）。

    ★ 不注入 step 名（step 名可能含被扫描的 secret 占位词，会污染扫描）。
    creds 参数保留以兼容旧调用签名，实际不使用。
    """
    job_id = job_meta.get("id")
    logs = download_job_log_zip(owner, repo, run_id, job_id)
    return "\n".join(logs.values())


def render_job_logs(creds, owner, repo, run_id, job_meta) -> str:
    """人类可读渲染：带 job/step 名。仅供 .md 展示，**不用于断言扫描**。"""
    job_id = job_meta.get("id")
    logs = download_job_log_zip(owner, repo, run_id, job_id)
    lines = [f"########## JOB {job_meta.get('name','')} "
             f"[{job_meta.get('status','')}] ##########"]
    for fname, text in logs.items():
        lines.append(f"\n----- {fname} -----\n{text}")
    return "\n".join(lines)


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 4:
        print("usage: log_fetcher.py <owner> <repo> <run_id> [job_id]")
        sys.exit(2)
    owner, repo, run_id = sys.argv[1:4]
    if len(sys.argv) > 4:
        for n, t in download_job_log_zip(owner, repo, run_id, sys.argv[4]).items():
            print(f"===== {n} =====\n{t}")
    else:
        for j in list_jobs(owner, repo, run_id):
            print(render_job_logs(None, owner, repo, run_id, j))
