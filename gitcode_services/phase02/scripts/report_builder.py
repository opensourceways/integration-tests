#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
report_builder.py — Phase 02 报告生成（确定性）

聚合 results/*.json → 分维度通过率 + §11 内部判定→对外三态映射 + 门禁判定
+ 回归 diff（与上次 run 对比）。实现 `/phase02-report` 的确定性内核。

用法: python report_builder.py <phase02-run-id> [--compare <prev-run-id>]

对外三态映射见 rules.md §11.3：
  PASS→通过；INCONCLUSIVE→未发现问题；
  NOT_CONFIGURED/NO_RUN/ENV_ERROR/TIMEOUT/COMPILE_ERROR→不可测试；
  FAIL→问题发现（平台缺陷 or 用例问题，由 failure-analyst 归因）。
通过率分母剔除「不可测试」「未发现问题」。
"""
import os
import sys
import json
import glob

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)

# 内部判定 → 对外结论
CONCLUSION = {
    "PASS": "通过",
    "INCONCLUSIVE": "未发现问题",
    "NOT_CONFIGURED": "不可测试", "NO_RUN": "不可测试", "ENV_ERROR": "不可测试",
    "TIMEOUT": "不可测试", "COMPILE_ERROR": "不可测试",
    "FAIL": "问题发现",
}
MIN_EXECUTION_COVERAGE = float(os.environ.get("MIN_EXECUTION_COVERAGE", "0.6"))
# 分维度默认阈值（quality-gate.md 不可解析时的兜底）
DEFAULT_GATE = {"completeness": 95, "compatibility": 90, "reliability": 85,
                "security": 90, "usability": 80}


def _load(path, d=None):
    return json.load(open(path, encoding="utf-8")) if os.path.exists(path) else d


def main():
    if len(sys.argv) < 2:
        print("usage: report_builder.py <phase02-run-id> [--compare <prev-run-id>]")
        sys.exit(2)
    run_id = sys.argv[1]
    compare = None
    if "--compare" in sys.argv:
        compare = sys.argv[sys.argv.index("--compare") + 1]

    run_dir = os.path.join(PHASE02, "runs", run_id)
    recs = []
    for f in sorted(glob.glob(os.path.join(run_dir, "results", "*.json"))):
        recs.append(_load(f))
    if not recs:
        print(f"无执行结果: runs/{run_id}/results/")
        sys.exit(1)

    # 分维度聚合
    dims = {}
    for r in recs:
        d = r.get("dimension", "?")
        concl = CONCLUSION.get(r["verdict"], "?")
        s = dims.setdefault(d, {"通过": 0, "问题发现": 0, "未发现问题": 0, "不可测试": 0,
                                "total": 0, "p0_fail": 0})
        s[concl] = s.get(concl, 0) + 1
        s["total"] += 1
        if r["verdict"] == "FAIL" and r.get("priority") == "P0":
            s["p0_fail"] += 1

    tot = len(recs)
    # 执行覆盖率 guard：有效判定（通过+问题发现）/ 总数 < 阈值 → 整体 INCONCLUSIVE
    effective = sum(s["通过"] + s["问题发现"] for s in dims.values())
    exec_coverage = (effective / tot * 100) if tot else 0
    coverage_ok = (effective / tot) >= MIN_EXECUTION_COVERAGE if tot else False

    # 门禁：先判覆盖率，不够 → INCONCLUSIVE；够了再走 P0/通过率逻辑
    blocked_dims, overall = [], "GO"
    if not coverage_ok:
        overall = "INCONCLUSIVE"
    dim_rows = []
    for d, s in sorted(dims.items()):
        denom = s["通过"] + s["问题发现"]  # 剔除不可测试/未发现问题
        rate = (s["通过"] * 100 // denom) if denom else None
        thr = DEFAULT_GATE.get(d, 85)
        gate = "✅"
        if not coverage_ok:
            gate = "⚪"; overall = "INCONCLUSIVE"
        if rate is not None and rate < thr:
            gate = "⛔"; blocked_dims.append(d); overall = "BLOCKED"
        if s["p0_fail"]:
            gate = "⛔"; overall = "BLOCKED"
        rate_s = f"{rate}%" if rate is not None else "N/A(全不可测)"
        dim_rows.append(f"| {d} | {s['total']} | {s['通过']} | {s['问题发现']} | "
                        f"{s['未发现问题']} | {s['不可测试']} | {rate_s} | {s['p0_fail']} | {gate} |")

    # 回归 diff
    regressions, fixes = [], []
    if compare:
        prev = _load(os.path.join(PHASE02, "runs", compare, "summary.json"), {"records": []})
        prev_v = {r["case_id"]: r["verdict"] for r in prev.get("records", [])}
        for r in recs:
            pv = prev_v.get(r["case_id"])
            if pv == "PASS" and r["verdict"] == "FAIL":
                regressions.append(r["case_id"])
            elif pv == "FAIL" and r["verdict"] == "PASS":
                fixes.append(r["case_id"])

    # 写报告
    by_v = {}
    for r in recs:
        by_v[r["verdict"]] = by_v.get(r["verdict"], 0) + 1
    os.makedirs(os.path.join(PHASE02, "reports", run_id), exist_ok=True)
    rp = os.path.join(PHASE02, "reports", run_id, "report.md")
    with open(rp, "w", encoding="utf-8") as f:
        f.write(f"# GitCode Actions 测试报告 · {run_id}\n\n")
        icon = "⛔ BLOCKED" if overall == "BLOCKED" else ("⚪ INCONCLUSIVE" if overall == "INCONCLUSIVE" else "✅ GO")
        f.write(f"## 门禁判定: {icon}\n\n")
        f.write(f"- 执行覆盖率: {(exec_coverage/100):.1%}（{effective}/{tot} 有效判定）\n")
        if not coverage_ok:
            f.write(f"- 原因: 执行覆盖率仅 {effective}/{tot}，未达阈值 {MIN_EXECUTION_COVERAGE:.0%}，样本不足以支撑上线结论\n")
        if blocked_dims:
            f.write(f"**Blocked 维度**: {', '.join(blocked_dims)}\n\n")
        f.write("## 执行摘要\n")
        f.write(f"- 总用例: {tot}\n")
        f.write("- 内部判定: " + " · ".join(f"{k}={n}" for k, n in sorted(by_v.items())) + "\n\n")
        f.write("## 分维度（对外三态，通过率已剔除不可测试/未发现问题）\n")
        f.write("| 维度 | 总数 | 通过 | 问题发现 | 未发现问题 | 不可测试 | 通过率 | P0失败 | 门禁 |\n")
        f.write("|---|---|---|---|---|---|---|---|---|\n")
        f.write("\n".join(dim_rows) + "\n\n")
        # 问题发现清单
        findings = [r for r in recs if r["verdict"] == "FAIL"]
        if findings:
            f.write("## 问题发现（FAIL，需 failure-analyst 归因）\n")
            f.write("| 用例 | 维度 | 优先级 | flags | run |\n|---|---|---|---|---|\n")
            for r in findings:
                f.write(f"| {r['case_id']} | {r['dimension']} | {r.get('priority','')} | "
                        f"{','.join(r.get('verdict_flags', []))} | {r.get('gitcode_run_id','')[:10]} |\n")
            f.write("\n")
        # 不可测试清单
        nt = [r for r in recs if CONCLUSION.get(r["verdict"]) == "不可测试"]
        if nt:
            f.write("## 不可测试（缺失条件/编译错误，非平台缺陷）\n")
            for r in nt:
                f.write(f"- {r['case_id']} ({r['verdict']}): {r.get('reason','')}\n")
            f.write("\n")
        if compare:
            f.write(f"## 回归 diff（vs {compare}）\n")
            f.write(f"- 新增失败(回归): {regressions or '无'}\n")
            f.write(f"- 修复(转绿): {fixes or '无'}\n\n")
        f.write("---\n*report_builder.py · 判定模型 rules.md §11 · pass/fail 由 assertion_engine 确定性裁决*\n")

    # 复制 summary 到 reports
    summ = _load(os.path.join(run_dir, "summary.json"))
    if summ:
        json.dump(summ, open(os.path.join(PHASE02, "reports", run_id, "summary.json"),
                             "w", encoding="utf-8"), ensure_ascii=False, indent=2)
    with open(os.path.join(PHASE02, "reports", "latest.txt"), "w", encoding="utf-8") as f:
        f.write(run_id + "\n")

    print(f"报告已生成: reports/{run_id}/report.md")
    print(f"执行覆盖率: {effective}/{tot} ({effective/tot:.1%})" if tot else "覆盖率: N/A")
    print(f"门禁: {overall}" + (f" (blocked: {blocked_dims})" if blocked_dims else ""))
    if compare:
        print(f"回归: {regressions or '无'} | 修复: {fixes or '无'}")


if __name__ == "__main__":
    main()
