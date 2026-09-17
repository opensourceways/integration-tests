#!/usr/bin/env python3
"""api_runner.py — api 类用例执行器（**本包独有**，上游 phase02 无此文件）

上游引擎只跑 workflow 类用例；本模块补上 test_type: api 的 86 条。
配套 api_assertions.py（判定）与 run_api_batch.py（批量编排）。

安全模型（重要）:
  86 条中 77 条是写操作（POST/PUT/PATCH/DELETE），且用例的 `api` 块**没有 body 字段**
  —— 它们本质是「端点可用性探测」，expected_status 普遍含 4xx。两道防线：

  1) 占位符探测值：endpoint 里除 {owner}/{repo} 外的占位符一律替换为**刻意不存在**
     的值（见 _PROBE_*），使这 44 条写请求命中 404 而非真实对象。
  2) 真实资源写请求默认跳过：另有 32 条写请求的路径完全由真实夹具构成
     （如 `POST /repos/o/r/pulls/1/merge`、`POST /repos/o/r/transfer`），
     无 body 时多数会被 400/422 挡回，但 merge 这类仅凭路径即可生效的会**真的执行**。
     故默认记 INCONCLUSIVE 不发送，确认目标是专用测试仓后再开
     API_ALLOW_UNSAFE_WRITE=1。

环境变量:
  API_CASE_TIMEOUT         单请求超时秒数（默认 30）
  API_ALLOW_WRITE          0=跳过所有写方法（默认 1）
  API_ALLOW_UNSAFE_WRITE   1=允许直打真实资源的写请求（默认 0=跳过）
  其余 token / api_base / owner / repo 复用上游 RunnerConfig 的解析顺序
"""
import os
import re
import sys
import time

import requests

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

TIMEOUT = int(os.environ.get("API_CASE_TIMEOUT", 30))
ALLOW_WRITE = os.environ.get("API_ALLOW_WRITE", "1") != "0"
# 直打真实资源的写请求默认不发（见模块文档「安全模型」第 2 条）
ALLOW_UNSAFE_WRITE = os.environ.get("API_ALLOW_UNSAFE_WRITE", "0") == "1"
WRITE_METHODS = {"POST", "PUT", "PATCH", "DELETE"}

# 刻意不存在的占位符取值：保证写操作打不到真实资源
_NUMERIC_PH = {"number", "id", "artifact_id", "discussion_id", "workflow_id"}
_PROBE_INT = "999999999"
_PROBE_SHA = "0" * 40
_PROBE_STR = "zzz-nonexistent-probe"


def load_config():
    """复用上游 RunnerConfig 的 token / api_base / owner / repo 解析。

    token 缺失时 RunnerConfig 会抛 FileNotFoundError，由调用方转 ENV_ERROR。
    """
    import workflow_runner as wr
    return wr.RunnerConfig(branch=None)


def resolve_fixture(doc, cfg):
    """夹具 → (owner, repo)。形如 `empty-repo` 的无斜杠夹具无法解析，返回 None。"""
    fixture = (doc.get("setup") or {}).get("repo_fixture") or ""
    if "/" in fixture:
        owner, repo = fixture.split("/", 1)
        return owner.strip(), repo.strip()
    return None


def resolve_endpoint(endpoint, owner, repo):
    """占位符替换。owner/repo 用真实夹具，其余用刻意不存在的值。

    返回 (path, substituted) —— substituted 记录被替换成探测值的占位符名，
    供报告说明「该请求预期 404」。
    """
    substituted = []

    def _sub(m):
        key = m.group(1)
        if key == "owner":
            return owner
        if key == "repo":
            return repo
        substituted.append(key)
        if key in _NUMERIC_PH:
            return _PROBE_INT
        if key == "sha":
            return _PROBE_SHA
        return _PROBE_STR

    return re.sub(r"\{(\w+)\}", _sub, endpoint), substituted


def plan(doc, cfg):
    """把用例编译成一次 HTTP 请求描述（不发送）。夹具不可解析时返回 error。"""
    api = doc.get("api") or {}
    target = resolve_fixture(doc, cfg)
    if target is None:
        fixture = (doc.get("setup") or {}).get("repo_fixture") or "(空)"
        return {"error": f"夹具未定义或不含 owner/repo: {fixture}"}
    owner, repo = target
    path, substituted = resolve_endpoint(api.get("endpoint") or "", owner, repo)
    return {
        "method": (api.get("method") or "GET").upper(),
        "url": f"{cfg.api_base}{path}",
        "params": api.get("params") or None,
        "content_type": api.get("content_type"),
        "substituted": substituted,
    }


def execute(doc, cfg, dry_run=False):
    """发送请求，返回 run_case.write_result 可消费的 rr 字典。

    rr.status 语义与 workflow 侧保持一致：正常为 HTTP 状态码，
    异常为 TIMEOUT / ENV_ERROR / SKIPPED_WRITE 字符串。
    """
    cid = doc.get("id", "")
    p = plan(doc, cfg)
    rr = {"case_id": cid, "jobs": [], "gitcode_run_id": "", "head_sha": "",
          "duration_seconds": 0, "logs": "", "run_url": ""}
    if p.get("error"):
        rr.update(status="ENV_ERROR", error=p["error"])
        return rr

    rr.update(method=p["method"], url=p["url"], run_url=p["url"],
              substituted=p["substituted"])

    # 门禁先行，使 dry-run 也能显示哪些请求实际不会发出
    gate = None
    if p["method"] in WRITE_METHODS and not ALLOW_WRITE:
        gate = ("SKIPPED_WRITE", "API_ALLOW_WRITE=0，跳过写方法")
    elif (p["method"] in WRITE_METHODS and not p["substituted"]
            and not ALLOW_UNSAFE_WRITE):
        # 路径全部由真实夹具构成 ⇒ 会打到真实资源。该子集含不可逆操作
        # （如 POST /pulls/<n>/merge、POST /transfer），默认不发。
        gate = ("SKIPPED_UNSAFE",
                "写请求直打真实资源，默认跳过；"
                "确认目标是专用测试仓后设 API_ALLOW_UNSAFE_WRITE=1 执行")

    if dry_run:
        rr.update(status="DRY_RUN", would_skip=(gate[0] if gate else None))
        return rr

    if gate:
        rr.update(status=gate[0], error=gate[1])
        return rr

    headers = {"Authorization": f"Bearer {cfg.token}",
               "Accept": "application/json"}
    if p["content_type"]:
        headers["Content-Type"] = p["content_type"]

    t0 = time.time()
    try:
        resp = requests.request(p["method"], p["url"], headers=headers,
                                params=p["params"], timeout=TIMEOUT)
    except requests.Timeout:
        rr.update(status="TIMEOUT", duration_seconds=round(time.time() - t0, 2),
                  error=f"请求超时（>{TIMEOUT}s）")
        return rr
    except requests.RequestException as e:
        rr.update(status="ENV_ERROR", duration_seconds=round(time.time() - t0, 2),
                  error=f"请求失败: {type(e).__name__}: {e}")
        return rr

    rr.update(status=resp.status_code, status_code=resp.status_code,
              resp_headers=dict(resp.headers),
              logs=(resp.text or "")[:20000],
              duration_seconds=round(time.time() - t0, 2))
    return rr
