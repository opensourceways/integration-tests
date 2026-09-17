#!/usr/bin/env python3
"""junit_export.py — 把执行结果导出为 JUnit XML（供 Jenkins 测试趋势图）

用法:
  python phase02/scripts/junit_export.py <phase02-run-id>

输入: phase02/runs/<run-id>/results/*.json（run_case.write_result 的产物）
产出: phase02/runs/<run-id>/junit.xml

verdict → JUnit 语义:
  PASS                                                  → 通过
  FAIL                                                  → <failure>
  其余（INCONCLUSIVE / NOT_CONFIGURED / NO_RUN /
  ENV_ERROR / TIMEOUT / COMPILE_ERROR）                  → <skipped>

INCONCLUSIVE 记 skipped 而非通过：report_builder 的有效覆盖率
effective = 通过 + 问题发现，本就不含 INCONCLUSIVE。若在 Jenkins 里显示为绿，
「没测到」会被误读成「测过且没问题」。

退出码: 0=导出成功, 1=无结果可导出
"""
import glob
import json
import os
import re
import sys
import xml.etree.ElementTree as ET

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)

PASSED = {"PASS"}
FAILED = {"FAIL"}
# 其余 verdict（含 INCONCLUSIVE）一律记为 skipped，与门禁的有效覆盖率口径一致

# XML 1.0 不允许的控制字符（日志/原因里可能夹带）
_ILLEGAL = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")


def _clean(text):
    return _ILLEGAL.sub("", str(text or ""))


def main():
    if len(sys.argv) < 2:
        print("usage: junit_export.py <phase02-run-id>")
        sys.exit(2)
    run_id = sys.argv[1]
    run_dir = os.path.join(PHASE02, "runs", run_id)

    recs = []
    for f in sorted(glob.glob(os.path.join(run_dir, "results", "*.json"))):
        with open(f, encoding="utf-8") as fh:
            recs.append(json.load(fh))
    if not recs:
        print(f"无执行结果，跳过 JUnit 导出: runs/{run_id}/results/")
        sys.exit(1)

    # 按维度分组 → 每维度一个 <testsuite>，Jenkins 里可按维度下钻
    by_dim = {}
    for r in recs:
        by_dim.setdefault(r.get("dimension") or "unknown", []).append(r)

    root = ET.Element("testsuites", {"name": f"gitcode-actions-{run_id}"})
    totals = {"tests": 0, "failures": 0, "skipped": 0, "time": 0.0}

    for dim in sorted(by_dim):
        items = by_dim[dim]
        dur = sum(float(r.get("duration_seconds") or 0) for r in items)
        n_fail = sum(1 for r in items if r["verdict"] in FAILED)
        n_skip = sum(1 for r in items if r["verdict"] not in PASSED | FAILED)
        suite = ET.SubElement(root, "testsuite", {
            "name": dim,
            "tests": str(len(items)),
            "failures": str(n_fail),
            "errors": "0",
            "skipped": str(n_skip),
            "time": f"{dur:.3f}",
        })
        totals["tests"] += len(items)
        totals["failures"] += n_fail
        totals["skipped"] += n_skip
        totals["time"] += dur

        for r in sorted(items, key=lambda x: (x.get("priority", ""), x["case_id"])):
            cid = r["case_id"]
            case = ET.SubElement(suite, "testcase", {
                "classname": f"{dim}.{r.get('priority') or 'NA'}",
                "name": f"{cid} {_clean(r.get('title'))}".strip(),
                "time": f"{float(r.get('duration_seconds') or 0):.3f}",
            })
            verdict = r["verdict"]
            flags = ", ".join(r.get("verdict_flags") or [])
            detail = _clean(r.get("reason"))
            if flags:
                detail = f"[{_clean(flags)}] {detail}".strip()
            if r.get("run_url"):
                detail = f"{detail}\nrun: {_clean(r['run_url'])}".strip()

            if verdict in FAILED:
                ET.SubElement(case, "failure", {
                    "type": verdict, "message": detail[:200] or verdict,
                }).text = detail
            elif verdict not in PASSED:
                ET.SubElement(case, "skipped", {
                    "message": f"{verdict}: {detail[:200]}".strip(": "),
                }).text = detail

    root.set("tests", str(totals["tests"]))
    root.set("failures", str(totals["failures"]))
    root.set("errors", "0")
    root.set("skipped", str(totals["skipped"]))
    root.set("time", f"{totals['time']:.3f}")

    out = os.path.join(run_dir, "junit.xml")
    ET.ElementTree(root).write(out, encoding="utf-8", xml_declaration=True)
    print(f"JUnit XML 已导出: runs/{run_id}/junit.xml "
          f"（{totals['tests']} 条 / 失败 {totals['failures']} / 跳过 {totals['skipped']}）")


if __name__ == "__main__":
    main()
