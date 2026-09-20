#!/usr/bin/env python3
"""run_api_batch.py — api 类用例批量执行（**本包独有**，上游无此文件）

读 phase02/runs/<run-id>/queue_api.json（由 schema_check_ext.py 产出），
逐条执行并复用 run_case.write_result / update_summary 落盘，
因此 junit_export.py 与 report_builder.py 无需任何改动即可消费结果。

用法:
  python phase02/scripts/run_api_batch.py <run-id> [--dry-run] [--only A,B]

  --dry-run  只打印将要发出的请求（含占位符替换结果），不发网络请求
  --only     只跑指定 case_id（逗号分隔）

环境变量: 见 api_runner.py。API_REQUEST_DELAY 控制请求间隔（默认 0.3s）。
"""
import json
import os
import sys
import time
import types

import requests

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)
ROOT = os.path.dirname(PHASE02)
sys.path.insert(0, HERE)

import config_loader  # noqa: E402,F401  自动加载 config.yaml
import api_assertions as aa  # noqa: E402
import api_runner  # noqa: E402
import run_case as rc  # noqa: E402

DELAY = float(os.environ.get("API_REQUEST_DELAY", "0.3"))


def _stub_cfg():
    """dry-run 时无 token 也要能规划请求。"""
    return types.SimpleNamespace(
        api_base=os.environ.get("GITCODE_API_BASE_URL", "https://api.gitcode.com").rstrip("/"),
        owner=os.environ.get("GITCODE_OWNER", "ComputingActionTest"),
        repo=os.environ.get("GITCODE_REPO", "bingo"),
        token="")


def _load_queue(run_dir, name, only=None):
    """读队列文件。缺文件返回 None（调用方退 1），否则返回 cases 列表。

    ui/git 批次共用（见 run_ui_batch.py / run_git_batch.py）。
    """
    path = os.path.join(run_dir, name)
    if not os.path.exists(path):
        print(f"缺 {name}（先跑 schema_check_ext.py）: {run_dir}")
        return None
    with open(path, encoding="utf-8") as f:
        cases = json.load(f).get("cases", [])
    return [c for c in cases if not only or c["case_id"] in only]


def preflight(cfg):
    """验证 token 可用。返回 (ok, 说明)。

    不做这一步的话，token 失效时所有请求得 401，而探测类用例的
    expected_status 恰好含 401 —— 会「全绿」掩盖配置错误。
    """
    url = f"{cfg.api_base}/api/v5/user"
    try:
        r = requests.get(url, headers={"Authorization": f"Bearer {cfg.token}",
                                       "Accept": "application/json"}, timeout=15)
    except requests.RequestException as e:
        return False, f"无法访问 {url}: {type(e).__name__}: {e}"
    if r.status_code == 200:
        return True, "token 有效"
    return False, f"token 校验失败: HTTP {r.status_code} {(r.text or '')[:120]}"


def _write_state(run_dir, state):
    with open(os.path.join(run_dir, "state_api.json"), "w", encoding="utf-8") as f:
        json.dump(state, f, ensure_ascii=False, indent=2)


def main():
    if len(sys.argv) < 2:
        print("usage: run_api_batch.py <run-id> [--dry-run] [--only A,B]")
        sys.exit(2)
    run_id = sys.argv[1]
    dry = "--dry-run" in sys.argv
    only = set()
    if "--only" in sys.argv:
        only = {s.strip() for s in sys.argv[sys.argv.index("--only") + 1].split(",")}

    run_dir = os.path.join(PHASE02, "runs", run_id)
    cases = _load_queue(run_dir, "queue_api.json", only)
    if cases is None:
        sys.exit(1)
    if not cases:
        print("queue_api.json 无可执行 api 用例")
        return

    try:
        cfg = api_runner.load_config()
    except FileNotFoundError as e:
        if not dry:
            print(f"错误: {e}")
            print("→ 将 86 条 api 用例全部记为 ENV_ERROR（覆盖率会如实下降）")
            _record_all_env_error(run_dir, cases, str(e))
            return
        cfg = _stub_cfg()

    print(f"=== api 批量执行 {run_id} · {len(cases)} 条"
          f"{' · DRY-RUN' if dry else ''} ===")
    print(f"API base: {cfg.api_base} · 写方法: "
          f"{'执行' if api_runner.ALLOW_WRITE else '跳过(API_ALLOW_WRITE=0)'}"
          f" · 直打真实资源的写请求: "
          f"{'执行(API_ALLOW_UNSAFE_WRITE=1)' if api_runner.ALLOW_UNSAFE_WRITE else '跳过(默认)'}")

    if not dry:
        ok, msg = preflight(cfg)
        print(f"预检: {msg}")
        if not ok:
            print("→ token 不可用，结果无意义。全部记为 ENV_ERROR")
            _record_all_env_error(run_dir, cases, msg)
            return

    state = {"status": "running", "total": len(cases), "done": 0, "current": ""}
    tally = {}
    skipped = 0
    for i, c in enumerate(cases, 1):
        cid = c["case_id"]
        doc = rc.load_contract(os.path.join(ROOT, c["contract_path"]))
        state["current"] = f"{cid} ({i}/{len(cases)})"
        if not dry:
            _write_state(run_dir, state)

        rr = api_runner.execute(doc, cfg, dry_run=dry)
        if dry:
            note = ""
            if rr.get("would_skip"):
                note = f"  ⛔ {rr['would_skip']}（不会发送）"
            elif rr.get("substituted"):
                note = f"  ← 探测占位符 {rr['substituted']}"
            print(f"[{i}/{len(cases)}] {cid}  {rr.get('method','?'):6s} "
                  f"{rr.get('url', rr.get('error',''))}{note}")
            skipped = skipped + 1 if rr.get("would_skip") else skipped
            continue

        verdict = aa.evaluate(rr, doc.get("assertions"))
        rec = rc.write_result(run_dir, doc, verdict, rr)
        rc.update_summary(run_dir, rec)
        v = verdict["verdict"]
        tally[v] = tally.get(v, 0) + 1
        state["done"] = i
        print(f"[{i}/{len(cases)}] {cid}  HTTP {str(rr.get('status')):>12s}  → {v}")
        if i < len(cases):
            time.sleep(DELAY)

    if dry:
        print(f"\nDRY-RUN 完成：{len(cases)} 条已规划，其中 {skipped} 条会被门禁跳过、"
              f"{len(cases) - skipped} 条会真实发出")
        return
    state.update(status="done", current="")
    _write_state(run_dir, state)
    print(f"\n=== api 批量完成 ===")
    print("  " + " / ".join(f"{k} {v}" for k, v in sorted(tally.items())))


def _record_all_env_error(run_dir, cases, reason):
    """环境不可用时如实落 ENV_ERROR，让门禁覆盖率反映真实情况。"""
    for c in cases:
        doc = rc.load_contract(os.path.join(ROOT, c["contract_path"]))
        rr = {"case_id": c["case_id"], "status": "ENV_ERROR", "logs": "",
              "jobs": [], "duration_seconds": 0, "gitcode_run_id": "",
              "head_sha": "", "run_url": ""}
        rec = rc.write_result(run_dir, doc, {
            "verdict": "ENV_ERROR", "verdict_flags": ["env"],
            "reason": reason, "assertion_results": []}, rr)
        rc.update_summary(run_dir, rec)
    print(f"已记录 {len(cases)} 条 ENV_ERROR")


if __name__ == "__main__":
    main()
