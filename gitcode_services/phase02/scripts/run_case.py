#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
run_case.py — Phase 02 原生执行驱动（通用、确定性）

取代已废弃的 run-case.sh（bash，取 runs[0] 抓错 run + 用 404 的 download_log）。
本驱动**只读契约 YAML**，不内联任何用例内容（弃用 execute_*.py 的糊弄式内联）。

原生链路（边界对齐后）：
    Phase01 契约 YAML 的 workflow: 字段  ← workflow 由 Phase 01 编写，本驱动原样使用、不改写
        │  (可选) compiled/<id>.asserts.json  ← Phase02 执行前的断言绑定 sidecar（非编写 workflow）
        ▼
    preflight_validate(契约字段 + workflow 语法 + API 校验) → 不合规判 COMPILE_ERROR（不 push，回报 Phase01）
        ▼
    workflow_runner(部署+触发+采集+teardown) ──▶ assertion_engine(§11 判定) ──▶ results/<id>.json + .md

用法：
    python run_case.py <contract-yaml> <run-id> [--no-logs]
    例：python run_case.py \\
          phase01/runs/2026-07-21-01/cases/yaml/SEC-MASK-03-001.yaml 2026-07-21-06

约定：
  - workflow 来源 = **Phase 01 契约的 `workflow:` 字段**（编写归 Phase 01；Phase 02 检查+执行，不编译）。
  - 断言绑定 sidecar（可选）= `runs/<run-id>/compiled/<case-id>.asserts.json`（rubric→engine kind
    + 夹具明文，属执行前准备）；缺失则退化为状态型断言。
  - 契约无 workflow 字段 → NOT_CONFIGURED；workflow 不合规 → COMPILE_ERROR（不 push）。
  - pass/fail 只由 assertion_engine 裁决（rules.md §1）。判定词见 rules.md §11。
"""
import os
import sys
import json
import time
import hashlib

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import workflow_runner as wr        # noqa
import assertion_engine as ae       # noqa
import log_fetcher                  # noqa

PHASE02 = os.path.dirname(HERE)     # phase02/


def load_contract(path):
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def load_execution_inputs(contract, run_dir, case_id):
    """执行输入（边界对齐后）：
    - workflow 来源 = **Phase 01 契约的 `workflow:` 字段**（编写归 Phase 01，Phase 02 原样使用、不改写）。
      Phase 02 只在 push 前用 preflight 检查其是否合规（不合规→COMPILE_ERROR，回报 Phase 01）。
    - 断言绑定（可选）= `runs/<id>/compiled/<id>.asserts.json`（rubric→engine kind + 夹具明文绑定，
      属**执行前准备**，非编写 workflow；缺失则退化）。
    """
    wf = contract.get("workflow")
    as_path = os.path.join(run_dir, "compiled", f"{case_id}.asserts.json")
    asserts = None
    if os.path.exists(as_path):
        asserts = json.load(open(as_path, encoding="utf-8")).get("assertions", [])
    return wf, asserts


def _log_fingerprint(rr):
    return hashlib.sha256((rr.get("logs") or "").encode("utf-8")).hexdigest()[:16]


def write_result(run_dir, contract, verdict, rr):
    cid = contract["id"]
    rec = {
        "case_id": cid,
        "title": contract.get("title", ""),
        "dimension": contract.get("dimension", ""),
        "priority": contract.get("priority", ""),
        "intent_ref": contract.get("intent_ref", ""),
        "phase02_run": os.path.basename(run_dir),
        "verdict": verdict["verdict"],
        "verdict_flags": verdict.get("verdict_flags", []),
        "reason": verdict.get("reason", ""),
        "gitcode_run_id": rr.get("gitcode_run_id", ""),
        "run_status": rr.get("status"),
        "head_sha": rr.get("head_sha", ""),
        "job_count": len(rr.get("jobs", [])),
        "duration_seconds": rr.get("duration_seconds", 0),
        "log_fingerprint": _log_fingerprint(rr),
        "run_url": rr.get("run_url", ""),
        "assertion_results": verdict.get("assertion_results", []),
    }
    results_dir = os.path.join(run_dir, "results")
    os.makedirs(results_dir, exist_ok=True)
    json.dump(rec, open(os.path.join(results_dir, f"{cid}.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=2)

    # 人可读 markdown（对齐 templates/run-result.md 精简版）
    icon = {"PASS": "✅ PASS", "FAIL": "❌ FAIL"}.get(
        rec["verdict"], f"⚪ {rec['verdict']}")
    flags = f" ({', '.join(rec['verdict_flags'])})" if rec["verdict_flags"] else ""
    rows = "\n".join(
        f"| {a.get('kind')} | {'✅' if a['pass'] else '❌'} | {a.get('expected','')} | {a.get('actual','')} |"
        for a in rec["assertion_results"]) or "| — | — | — | — |"
    md = f"""# 执行结果 · {cid}

| 项目 | 值 |
|---|---|
| 用例 ID | {cid} |
| 标题 | {rec['title']} |
| 维度 / 优先级 | {rec['dimension']} / {rec['priority']} |
| 溯源意图 | {rec['intent_ref']} |
| Phase 02 Run | {rec['phase02_run']}（原生 harness · run_case.py）|
| GitCode Run ID | {rec['gitcode_run_id']} |
| head_sha | {rec['head_sha']} |
| Run 状态 / Job 数 | {rec['run_status']} / {rec['job_count']} |
| 日志指纹 | {rec['log_fingerprint']} |
| **Run 页面** | {rec.get('run_url', '') or '（无 run_id）'} |
| 耗时 | {rec['duration_seconds']}s |

## 判定: {icon}{flags}

> 判定由 assertion_engine 确定性做出（rules.md §1/§11）。LLM 不参与裁决。
> {rec['reason']}

## 断言详情
| kind | 结果 | 预期 | 实际 |
|---|---|---|---|
{rows}
"""
    open(os.path.join(results_dir, f"{cid}.md"), "w", encoding="utf-8").write(md)

    # 日志正文落盘（failure-analyst 归因用）
    logs = rr.get("logs") or ""
    v = verdict.get("verdict", "?")
    if logs.strip():
        log_text = logs
    else:
        log_text = f"<no logs: verdict={v}, case not executed>\n"
    log_path = os.path.join(results_dir, f"{cid}.log.txt")
    open(log_path, "w", encoding="utf-8", newline="\n").write(log_text)

    return rec


def update_summary(run_dir, rec):
    """合并式更新 summary.json（部分重跑覆盖同 id）。"""
    sp = os.path.join(run_dir, "summary.json")
    records = []
    if os.path.exists(sp):
        records = json.load(open(sp, encoding="utf-8")).get("records", [])
    records = [r for r in records if r["case_id"] != rec["case_id"]] + [rec]
    def count(v):
        return sum(1 for r in records if r["verdict"] == v)
    summary = {
        "run_id": os.path.basename(run_dir),
        "mode": "native-harness",
        "total": len(records),
        "pass": count("PASS"), "fail": count("FAIL"),
        "not_configured": count("NOT_CONFIGURED"),
        "inconclusive": count("INCONCLUSIVE"),
        "compile_error": count("COMPILE_ERROR"),
        "no_run": count("NO_RUN"), "timeout": count("TIMEOUT"),
        "env_error": count("ENV_ERROR"),
        "records": records,
    }
    json.dump(summary, open(sp, "w", encoding="utf-8"), ensure_ascii=False, indent=2)


def main():
    if len(sys.argv) < 3:
        print("usage: run_case.py <contract-yaml> <run-id> [--no-logs]")
        sys.exit(2)
    contract_path, run_id = sys.argv[1], sys.argv[2]
    fetch_logs = "--no-logs" not in sys.argv[3:]

    contract = load_contract(contract_path)
    cid = contract["id"]
    run_dir = os.path.join(PHASE02, "runs", run_id)
    os.makedirs(run_dir, exist_ok=True)

    cfg = wr.RunnerConfig(branch=None)  # branch 从 env / 默认 main

    # 预检：契约字段 + workflow 本地语法 + GitCode API 校验（合并 schema_check + preflight + validate_workflow）
    ok, verr = wr.preflight_validate(contract, cfg=cfg)
    if not ok:
        wr.log(f"{cid}: 预检不通过（{len(verr)} 项）→ COMPILE_ERROR，不 push")
        for e in verr:
            wr.log(f"    - {e}")
        verdict = {"verdict": "COMPILE_ERROR", "verdict_flags": [],
                   "reason": "; ".join(verr), "assertion_results": []}
        rec = write_result(run_dir, contract, verdict, {"status": "COMPILE_ERROR"})
        update_summary(run_dir, rec)
        return

    wf, asserts = load_execution_inputs(contract, run_dir, cid)
    if not wf:
        wr.log(f"{cid}: 契约无 workflow 字段 → NOT_CONFIGURED（纯配置/非运行类，无可执行 workflow）")
        verdict = {"verdict": "NOT_CONFIGURED", "verdict_flags": [],
                   "reason": "Phase 01 契约无 workflow 字段", "assertion_results": []}
        rec = write_result(run_dir, contract, verdict, {"status": "NOT_CONFIGURED"})
        update_summary(run_dir, rec)
        return

    # 触发方式支持性由 workflow_runner.TRIGGER_STATUS 统一裁定
    ev = (contract.get("trigger") or {}).get("event", "push")
    trig_as = (contract.get("trigger") or {}).get("as", "maintainer")
    if trig_as == "untrusted_contributor":
        cp = os.path.expanduser("~/.gitcode-contributor-token")
        if ev in ("issue_comment", "pull_request_comment") and os.path.exists(cp):
            pass  # 有 contributor token + issue_comment → 放行
        else:
            wr.log(f"{cid}: trigger.as=untrusted_contributor → INCONCLUSIVE（执行路径未实现，拒绝以 maintainer 假验证）")
            verdict = {"verdict": "INCONCLUSIVE", "verdict_flags": [],
                       "reason": "untrusted_contributor 执行路径未实现，拒绝以 maintainer 假验证", "assertion_results": []}
            rec = write_result(run_dir, contract, verdict, {"status": "INCONCLUSIVE", "case_id": cid})
            update_summary(run_dir, rec)
            return

    reset = (contract.get("teardown") or {}).get("reset", "fixture")
    wr.log(f"=== 原生执行 {cid} → {cfg.owner}/{cfg.repo}@{cfg.branch} (teardown={reset}) ===")
    with wr.Workspace(cfg) as ws:
        rr = wr.run_case(ws, cfg, cid, wf, fetch_logs=fetch_logs, teardown_reset=reset,
                         trigger_event=ev)
    rr["case_id"] = cid

    # 无编译断言时退化：用契约 assertions 数量提示（这里只做状态型兜底）
    engine_asserts = asserts if asserts else [{"kind": "status"}]
    verdict = ae.evaluate(rr, engine_asserts)

    rec = write_result(run_dir, contract, verdict, rr)
    update_summary(run_dir, rec)
    wr.log(f"→ {rec['verdict']} {rec['verdict_flags']} "
           f"run={rec['gitcode_run_id'][:10]} ({rec['duration_seconds']}s)")


if __name__ == "__main__":
    main()
