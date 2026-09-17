#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
schema_check.py — Phase 02 第一道闸门（确定性）

校验 Phase 01 交付的可执行 YAML 用例是否合规，产出执行队列 + 拒收清单。
实现 `/phase02-schema-check` 的确定性内核（命令 .md 只负责编排 + 展示）。

用法:
  python schema_check.py <phase01-run-id> <phase02-run-id> [--dims a,b] [--priority P0]
  例: python schema_check.py 2026-07-21-01 2026-07-21-10 --dims security

产出（写入 phase02/runs/<phase02-run-id>/）:
  queue.json     通过校验、待执行的用例清单（case_id/contract_path/dimension/priority）
  rejected.json  不合规用例 + 原因（回报 Phase 01）
  run.md         人可读运行元信息（status: ready）
  state.json     机器可读状态（供 status.py 中途读取）
"""
import os
import sys
import json
import glob

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)
ROOT = os.path.dirname(PHASE02)

import re
_ID_RE = re.compile(r"^(COMP|COMPAT|REL|SEC|USE)-[A-Z0-9]+(?:-[A-Z0-9]+)*-\d{2}-\d{3}(-V\d+)?$")
_DIMS = {"completeness", "compatibility", "reliability", "security", "usability"}
_PRIOS = {"P0", "P1", "P2"}
_ATYPES = {"positive", "negative", "nonfunctional"}


def validate_case(doc):
    """对单条契约 YAML 做 schema 关键规则校验。返回 errors 列表（空=通过）。"""
    errs = []
    if not isinstance(doc, dict):
        return ["顶层非映射"]
    for k in ("id", "dimension", "priority", "title", "intent_ref",
              "setup", "trigger", "assertions", "teardown"):
        if k not in doc:
            errs.append(f"缺必填字段 {k}")
    if "id" in doc and not _ID_RE.match(str(doc["id"])):
        errs.append(f"id 格式不合规: {doc['id']}")
    if doc.get("dimension") not in _DIMS:
        errs.append(f"dimension 非法: {doc.get('dimension')}")
    if doc.get("priority") not in _PRIOS:
        errs.append(f"priority 非法: {doc.get('priority')}")
    setup = doc.get("setup")
    if isinstance(setup, dict) and "repo_fixture" not in setup:
        errs.append("setup 缺 repo_fixture")
    asserts = doc.get("assertions")
    if not isinstance(asserts, list) or not asserts:
        errs.append("assertions 必须为非空数组")
    else:
        for i, a in enumerate(asserts):
            if not isinstance(a, dict) or a.get("type") not in _ATYPES:
                errs.append(f"assertions[{i}].type 非法")
            if isinstance(a, dict) and "target" not in a:
                errs.append(f"assertions[{i}] 缺 target")
    # 安全用例至少一条 negative
    if doc.get("dimension") == "security" and isinstance(asserts, list):
        if not any(isinstance(a, dict) and a.get("type") == "negative" for a in asserts):
            errs.append("security 用例至少需一条 type=negative")
    td = doc.get("teardown")
    if isinstance(td, dict) and td.get("reset") not in {"fixture", "full_instance", "none"}:
        errs.append(f"teardown.reset 非法: {td.get('reset')}")
    return errs


def main():
    if len(sys.argv) < 3:
        print("usage: schema_check.py <phase01-run-id> <phase02-run-id> [--dims a,b] [--priority P0]")
        sys.exit(2)
    p1, p2 = sys.argv[1], sys.argv[2]
    args = sys.argv[3:]
    dims = None
    prio = None
    src_dir_override = None
    if "--src-dir" in args:
        idx = args.index("--src-dir")
        src_dir_override = args[idx + 1]
    if "--dims" in args:
        dims = set(args[args.index("--dims") + 1].split(","))
    if "--priority" in args:
        prio = args[args.index("--priority") + 1]

    if src_dir_override:
        src_dir = src_dir_override
    else:
        src_dir = os.path.join(ROOT, "phase01", "runs", p1, "cases", "yaml")
    if not os.path.isdir(src_dir):
        print(f"找不到 Phase01 用例目录: {src_dir}")
        sys.exit(1)

    run_dir = os.path.join(PHASE02, "runs", p2)
    os.makedirs(run_dir, exist_ok=True)

    passed, rejected = [], []
    for f in sorted(glob.glob(os.path.join(src_dir, "*.yaml")) +
                    glob.glob(os.path.join(src_dir, "*.yml"))):
        try:
            doc = yaml.safe_load(open(f, encoding="utf-8"))
        except yaml.YAMLError as e:
            rejected.append({"file": os.path.basename(f), "errors": [f"YAML 解析失败: {e}"]})
            continue
        errs = validate_case(doc)
        if errs:
            rejected.append({"file": os.path.basename(f), "case_id": (doc or {}).get("id"),
                             "errors": errs})
            continue
        if dims and doc.get("dimension") not in dims:
            continue
        if prio and doc.get("priority") != prio:
            continue
        rel = os.path.relpath(f, ROOT).replace("\\", "/")
        passed.append({"case_id": doc["id"], "contract_path": rel,
                       "dimension": doc["dimension"], "priority": doc["priority"]})

    # 按优先级排序 P0→P1→P2
    passed.sort(key=lambda c: (c["priority"], c["case_id"]))

    queue = {"phase01_run_id": p1, "phase02_run_id": p2,
             "filters": {"dims": sorted(dims) if dims else None, "priority": prio},
             "total": len(passed), "cases": passed}
    json.dump(queue, open(os.path.join(run_dir, "queue.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=2)
    json.dump({"count": len(rejected), "items": rejected},
              open(os.path.join(run_dir, "rejected.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=2)

    state = {"status": "ready", "total": len(passed), "done": 0,
             "current": None, "verdicts": {}}
    json.dump(state, open(os.path.join(run_dir, "state.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=2)

    with open(os.path.join(run_dir, "run.md"), "w", encoding="utf-8") as f:
        f.write(f"# Phase 02 Run {p2}\n\n")
        f.write(f"- 状态: ready（schema 校验完成，待执行）\n")
        f.write(f"- Phase01 来源: {p1}\n")
        f.write(f"- 过滤: dims={sorted(dims) if dims else '全部'} priority={prio or '全部'}\n")
        f.write(f"- 通过校验: {len(passed)} 条 | 拒收: {len(rejected)} 条\n")

    print(f"schema-check 完成: {len(passed)} 通过 / {len(rejected)} 拒收")
    print(f"  queue.json / rejected.json / state.json → runs/{p2}/")
    if rejected:
        print(f"  ⚠️ {len(rejected)} 条拒收，回报 Phase 01（见 rejected.json）")


if __name__ == "__main__":
    main()
