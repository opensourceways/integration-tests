#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
status.py — Phase 02 进度查看（确定性，只读，可在执行中途运行）

读 runs/<id>/state.json（run_batch 每条前后更新）+ summary.json + queue.json，
打印当前进度快照。**执行中途运行也能看到实时进度**（state 增量更新）。

用法: python status.py <phase02-run-id>
"""
import os
import sys
import json

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)


def _load(path, d=None):
    return json.load(open(path, encoding="utf-8")) if os.path.exists(path) else d


def main():
    if len(sys.argv) < 2:
        print("usage: status.py <phase02-run-id>")
        sys.exit(2)
    run_id = sys.argv[1]
    run_dir = os.path.join(PHASE02, "runs", run_id)
    state = _load(os.path.join(run_dir, "state.json"))
    if not state:
        print(f"无 state.json（该 run 尚未 schema-check/执行）: runs/{run_id}/")
        sys.exit(1)
    summ = _load(os.path.join(run_dir, "summary.json"), {"records": []})
    queue = _load(os.path.join(run_dir, "queue.json"), {"total": state.get("total", 0)})

    done, total = state.get("done", 0), state.get("total", 0)
    pct = f"{done*100//total}%" if total else "—"
    bar = ("█" * (done * 20 // total) + "░" * (20 - done * 20 // total)) if total else ""

    print(f"═══ Phase 02 Run {run_id} ═══")
    print(f"状态: {state['status']}    进度: {done}/{total} {pct}  {bar}")
    if state.get("current"):
        print(f"当前执行: {state['current']}")
    v = state.get("verdicts", {})
    if v:
        print("判定累计: " + " · ".join(f"{k}={n}" for k, n in v.items()))
    # 预估剩余（按已完成条数的均匀假设，仅提示）
    if state["status"] == "running" and done and done < total:
        print(f"剩余约 {total - done} 条")
    # 最近几条结果
    recs = summ.get("records", [])
    if recs:
        print("\n最近结果:")
        for r in recs[-5:]:
            flag = f" [{','.join(r.get('verdict_flags', []))}]" if r.get("verdict_flags") else ""
            print(f"  {r['verdict']:15} {r['case_id']}{flag}")


if __name__ == "__main__":
    main()
