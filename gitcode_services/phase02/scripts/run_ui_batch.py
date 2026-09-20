#!/usr/bin/env python3
"""run_ui_batch.py — ui 类用例批量执行（**本包独有**，上游无此文件）

读 phase02/runs/<run-id>/queue_ui.json，复用一个 Chromium 实例、每条用例一个
context（cookie/viewport 隔离），结果经 run_case.write_result 落盘，
因此 junit_export.py 与 report_builder.py 无需改动。

用法:
  python phase02/scripts/run_ui_batch.py <run-id> [--dry-run] [--only A,B]
"""
import json
import os
import sys
import types

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)
ROOT = os.path.dirname(PHASE02)
sys.path.insert(0, HERE)

import config_loader  # noqa: E402,F401  自动加载 config.yaml
import run_case as rc  # noqa: E402
import ui_runner  # noqa: E402
from run_api_batch import _record_all_env_error, _load_queue  # noqa: E402


def _cfg():
    """ui 用例的 repo_fixture 全为 null，owner/repo 取环境默认值即可（不需要 token）。"""
    return types.SimpleNamespace(
        owner=os.environ.get("GITCODE_OWNER", "ComputingActionTest"),
        repo=os.environ.get("GITCODE_REPO", "bingo"))


def main():
    if len(sys.argv) < 2:
        print("usage: run_ui_batch.py <run-id> [--dry-run] [--only A,B]")
        sys.exit(2)
    run_id = sys.argv[1]
    dry = "--dry-run" in sys.argv
    only = set()
    if "--only" in sys.argv:
        only = {s.strip() for s in sys.argv[sys.argv.index("--only") + 1].split(",")}

    run_dir = os.path.join(PHASE02, "runs", run_id)
    cases = _load_queue(run_dir, "queue_ui.json", only)
    if cases is None:
        sys.exit(1)
    if not cases:
        print("queue_ui.json 无可执行 ui 用例")
        return

    cfg = _cfg()
    print(f"=== ui 批量执行 {run_id} · {len(cases)} 条{' · DRY-RUN' if dry else ''} ===")
    print(f"目标: {cfg.owner}/{cfg.repo} · headless={ui_runner.HEADLESS} · "
          f"登录态={'有' if os.environ.get('GITCODE_COOKIE') else '无（私有页会判不可测试）'}")

    if dry:
        for i, c in enumerate(cases, 1):
            doc = rc.load_contract(os.path.join(ROOT, c["contract_path"]))
            rr = ui_runner.execute(doc, cfg, dry_run=True)
            print(f"[{i}/{len(cases)}] {c['case_id']}  {rr['run_url']}  "
                  f"({rr['action_count']} 个 action)")
        print(f"\nDRY-RUN 完成：{len(cases)} 条已规划，未启动浏览器")
        return

    if not ui_runner.playwright_available():
        print("错误: Playwright 未安装 → 全部记 ENV_ERROR（覆盖率会如实下降）")
        print("      pip install playwright && playwright install chromium")
        _record_all_env_error(run_dir, cases, "Playwright 未安装")
        return

    from playwright.sync_api import sync_playwright

    shot_dir = os.path.join(run_dir, "screenshots")
    tally = {}
    with sync_playwright() as pw:
        browser = pw.chromium.launch(headless=ui_runner.HEADLESS)
        try:
            for i, c in enumerate(cases, 1):
                cid = c["case_id"]
                doc = rc.load_contract(os.path.join(ROOT, c["contract_path"]))
                rr = ui_runner.execute(doc, cfg, browser=browser, shot_dir=shot_dir)
                verdict = ui_runner.evaluate(rr, doc.get("assertions"))
                rec = rc.write_result(run_dir, doc, verdict, rr)
                rc.update_summary(run_dir, rec)
                v = verdict["verdict"]
                tally[v] = tally.get(v, 0) + 1
                ae = len(rr.get("action_errors") or [])
                print(f"[{i}/{len(cases)}] {cid}  {rr.get('duration_seconds')}s  "
                      f"action 错误 {ae}  → {v}")
        finally:
            browser.close()

    print("\n=== ui 批量完成 ===")
    print("  " + " / ".join(f"{k} {v}" for k, v in sorted(tally.items())))


if __name__ == "__main__":
    main()
