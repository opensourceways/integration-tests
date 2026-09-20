#!/usr/bin/env python3
"""run_git_batch.py — git 类用例批量执行（**本包独有**，上游无此文件）

读 phase02/runs/<run-id>/queue_git.json，逐条跑 git 命令。
结果经 run_case.write_result 落盘，junit/report 无需改动。

用法:
  python phase02/scripts/run_git_batch.py <run-id> [--dry-run] [--only A,B]
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)
ROOT = os.path.dirname(PHASE02)
sys.path.insert(0, HERE)

import config_loader  # noqa: E402,F401  自动加载 config.yaml
import git_runner  # noqa: E402
import run_case as rc  # noqa: E402
from run_api_batch import _load_queue  # noqa: E402


def main():
    if len(sys.argv) < 2:
        print("usage: run_git_batch.py <run-id> [--dry-run] [--only A,B]")
        sys.exit(2)
    run_id = sys.argv[1]
    dry = "--dry-run" in sys.argv
    only = set()
    if "--only" in sys.argv:
        only = {s.strip() for s in sys.argv[sys.argv.index("--only") + 1].split(",")}

    run_dir = os.path.join(PHASE02, "runs", run_id)
    cases = _load_queue(run_dir, "queue_git.json", only)
    if cases is None:
        sys.exit(1)
    if not cases:
        print("queue_git.json 无可执行 git 用例")
        return

    print(f"=== git 批量执行 {run_id} · {len(cases)} 条{' · DRY-RUN' if dry else ''} ===")
    print(f"push 用例: {'执行(GIT_ALLOW_PUSH=1)' if git_runner.ALLOW_PUSH else '跳过(默认)'}")

    tally = {}
    for i, c in enumerate(cases, 1):
        cid = c["case_id"]
        doc = rc.load_contract(os.path.join(ROOT, c["contract_path"]))
        rr = git_runner.execute(doc, dry_run=dry)
        if dry:
            note = f"  ⛔ {rr['would_skip']}（不会执行）" if rr.get("would_skip") else ""
            print(f"[{i}/{len(cases)}] {cid}  {rr.get('command', rr.get('error',''))}{note}")
            continue
        verdict = git_runner.evaluate(rr, doc.get("assertions"))
        rec = rc.write_result(run_dir, doc, verdict, rr)
        rc.update_summary(run_dir, rec)
        v = verdict["verdict"]
        tally[v] = tally.get(v, 0) + 1
        print(f"[{i}/{len(cases)}] {cid}  exit={rr.get('status')}  "
              f"{rr.get('duration_seconds')}s  → {v}")

    if dry:
        print(f"\nDRY-RUN 完成：{len(cases)} 条已规划，未执行")
        return
    print("\n=== git 批量完成 ===")
    print("  " + " / ".join(f"{k} {v}" for k, v in sorted(tally.items())))


if __name__ == "__main__":
    main()
