#!/usr/bin/env python3
"""schema_check_ext.py — 分流版 schema 校验（**本包独有**，上游无此文件）

上游 schema_check.py 只认 workflow 类：`trigger` 必填、id 正则只含
COMP|COMPAT|REL|SEC|USE —— 249 条里 166 条 api/ui 用例被直接拒收。

本模块不改上游文件（改了会被 sync-cases.sh 覆盖），而是分流：
  workflow 类 → 沿用上游 validate_case，写 queue.json（上游 run_batch 原样消费）
  api 类      → 本模块自有校验，写 queue_api.json（run_api_batch.py 消费）
  ui 类       → 写 queue_ui.json（run_ui_batch.py 消费）
  git 类      → 写 queue_git.json（run_git_batch.py 消费）

用法（与上游同签名，run_daily.sh 可直接替换）:
  python phase02/scripts/schema_check_ext.py <src-tag> <run-id> --src-dir <dir>
                                             [--dims a,b] [--priority P0]
"""
import glob
import json
import os
import re
import sys

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
PHASE02 = os.path.dirname(HERE)
ROOT = os.path.dirname(PHASE02)
sys.path.insert(0, HERE)

import schema_check as sc  # noqa: E402  复用上游 validate_case / _DIMS / _PRIOS

# 放宽的 id 正则：上游只认 5 个维度前缀，这里补上 API/UI/GIT
_ID_RE = re.compile(
    r"^(API|UI|GIT|COMP|COMPAT|REL|SEC|USE)-[A-Z0-9]+(?:-[A-Z0-9]+)*-\d{2}-\d{3}(-V\d+)?$")
_METHODS = {"GET", "POST", "PUT", "PATCH", "DELETE"}
_SUPPORTED_TARGETS = {"api_status_code", "api_response_body", "api_response_header"}
_UI_TARGETS = {"ui_element_visible", "ui_text_contains", "ui_page_title", "ui_url_match"}
_UI_VERBS = {"wait_for_selector", "wait", "click", "type", "navigate", "screenshot"}
_GIT_TARGETS = {"git_exit_code", "git_output", "latency"}
_GIT_ACTIONS = {"clone", "push"}


def _common_errs(doc, block):
    """id/维度/优先级/必填字段的公共校验。"""
    errs = []
    if not isinstance(doc, dict):
        return ["顶层非映射"]
    for k in ("id", "dimension", "priority", "title", "intent_ref",
              "setup", block, "assertions", "teardown"):
        if k not in doc:
            errs.append(f"缺必填字段 {k}")
    if "id" in doc and not _ID_RE.match(str(doc["id"])):
        errs.append(f"id 格式不合规: {doc['id']}")
    if doc.get("dimension") not in sc._DIMS:
        errs.append(f"dimension 非法: {doc.get('dimension')}")
    if doc.get("priority") not in sc._PRIOS:
        errs.append(f"priority 非法: {doc.get('priority')}")
    return errs


def _assert_errs(doc, allowed):
    errs = []
    asserts = doc.get("assertions")
    if not isinstance(asserts, list) or not asserts:
        return ["assertions 为空"]
    for i, a in enumerate(asserts):
        if not isinstance(a, dict):
            errs.append(f"assertions[{i}] 非映射")
            continue
        if a.get("type") not in sc._ATYPES:
            errs.append(f"assertions[{i}].type 非法: {a.get('type')}")
        if a.get("target") not in allowed:
            errs.append(f"assertions[{i}].target 无实现: {a.get('target')}")
    return errs


def validate_ui_case(doc):
    """ui 类契约校验。"""
    errs = _common_errs(doc, "ui")
    ui = doc.get("ui")
    if not isinstance(ui, dict):
        errs.append("ui 块缺失或非映射")
    else:
        if not str(ui.get("url") or "").startswith("http"):
            errs.append(f"ui.url 需为绝对地址: {ui.get('url')!r}")
        acts = ui.get("actions")
        if acts is not None and not isinstance(acts, list):
            errs.append("ui.actions 需为列表")
        else:
            for i, a in enumerate(acts or []):
                if not isinstance(a, dict):
                    errs.append(f"ui.actions[{i}] 非映射")
                elif a.get("type") not in _UI_VERBS:
                    errs.append(f"ui.actions[{i}].type 未实现: {a.get('type')}")
    return errs + _assert_errs(doc, _UI_TARGETS)


def validate_git_case(doc):
    """git 类契约校验。"""
    errs = _common_errs(doc, "git")
    g = doc.get("git")
    if not isinstance(g, dict):
        errs.append("git 块缺失或非映射")
    else:
        if g.get("action") not in _GIT_ACTIONS:
            errs.append(f"git.action 未实现: {g.get('action')}")
        if not isinstance(g.get("args") or {}, dict):
            errs.append("git.args 需为映射")
        if g.get("action") == "clone" and not (g.get("args") or {}).get("url"):
            errs.append("clone 用例缺 git.args.url")
    return errs + _assert_errs(doc, _GIT_TARGETS)


def validate_api_case(doc):
    """api 类契约校验。返回 errors 列表（空=通过）。"""
    errs = _common_errs(doc, "api")
    api = doc.get("api")
    if not isinstance(api, dict):
        errs.append("api 块缺失或非映射")
    else:
        ep = api.get("endpoint") or ""
        if not str(ep).startswith("/"):
            errs.append(f"api.endpoint 需以 / 开头: {ep!r}")
        if str(api.get("method", "")).upper() not in _METHODS:
            errs.append(f"api.method 不支持: {api.get('method')}")
        if api.get("auth") not in (None, "token"):
            errs.append(f"api.auth 仅支持 token: {api.get('auth')}")
        if api.get("params") is not None and not isinstance(api["params"], dict):
            errs.append("api.params 需为映射")
    return errs + _assert_errs(doc, _SUPPORTED_TARGETS)


def main():
    args = sys.argv[1:]
    if len(args) < 2:
        print("usage: schema_check_ext.py <src-tag> <run-id> --src-dir <dir> "
              "[--dims a,b] [--priority P0]")
        sys.exit(2)
    tag, run_id = args[0], args[1]
    src_dir = args[args.index("--src-dir") + 1] if "--src-dir" in args else \
        os.path.join(ROOT, "cases", "yaml")
    dims = set()
    if "--dims" in args:
        dims = {s.strip() for s in args[args.index("--dims") + 1].split(",")}
    prio = args[args.index("--priority") + 1] if "--priority" in args else None

    if not os.path.isdir(src_dir):
        print(f"找不到用例目录: {src_dir}")
        sys.exit(1)

    run_dir = os.path.join(PHASE02, "runs", run_id)
    os.makedirs(run_dir, exist_ok=True)

    # test_type → (校验函数, 目标队列 key)
    validators = {"api": validate_api_case, "ui": validate_ui_case,
                  "git": validate_git_case}
    queues = {"workflow": [], "api": [], "ui": [], "git": []}
    rejected = []

    for f in sorted(glob.glob(os.path.join(src_dir, "*.yaml")) +
                    glob.glob(os.path.join(src_dir, "*.yml"))):
        base = os.path.basename(f)
        try:
            doc = yaml.safe_load(open(f, encoding="utf-8"))
        except yaml.YAMLError as e:
            rejected.append({"file": base, "errors": [f"YAML 解析失败: {e}"]})
            continue
        doc = doc or {}
        tt = doc.get("test_type")
        if tt not in validators and tt != "workflow" and "workflow" not in doc:
            rejected.append({"file": base, "case_id": doc.get("id"),
                             "errors": [f"未知 test_type: {tt}"]})
            continue

        bucket = tt if tt in validators else "workflow"
        errs = validators.get(tt, sc.validate_case)(doc)
        if errs:
            rejected.append({"file": base, "case_id": doc.get("id"), "errors": errs})
            continue
        if dims and doc.get("dimension") not in dims:
            continue
        if prio and doc.get("priority") != prio:
            continue

        queues[bucket].append({
            "case_id": doc["id"],
            "contract_path": os.path.relpath(f, ROOT).replace("\\", "/"),
            "dimension": doc["dimension"], "priority": doc["priority"],
            "test_type": tt})

    for lst in queues.values():
        lst.sort(key=lambda c: (c["priority"], c["case_id"]))
    wf, api = queues["workflow"], queues["api"]

    def _dump(name, obj):
        with open(os.path.join(run_dir, name), "w", encoding="utf-8") as fh:
            json.dump(obj, fh, ensure_ascii=False, indent=2)

    _dump("queue.json", {"phase01_run_id": tag, "phase02_run_id": run_id,
                         "filters": {"dims": sorted(dims) if dims else None,
                                     "priority": prio},
                         "total": len(wf), "cases": wf})
    for kind in ("api", "ui", "git"):
        _dump(f"queue_{kind}.json", {"src_tag": tag, "phase02_run_id": run_id,
                                     "total": len(queues[kind]),
                                     "cases": queues[kind]})
    _dump("rejected.json", {"count": len(rejected), "items": rejected})
    _dump("state.json", {"status": "ready", "total": len(wf), "done": 0,
                         "current": None, "verdicts": {}})

    counts = " | ".join(f"{k}: {len(v)} 条" for k, v in queues.items())
    total = sum(len(v) for v in queues.values())

    with open(os.path.join(run_dir, "run.md"), "w", encoding="utf-8") as fh:
        fh.write(f"# Phase 02 Run {run_id}\n\n")
        fh.write("- 状态: ready（schema 校验完成，待执行）\n")
        fh.write(f"- 用例来源: {tag} / {src_dir}\n")
        fh.write(f"- {counts} | 拒收: {len(rejected)} 条\n")

    print(f"schema-check(ext) 完成: 入队 {total} 条 / 拒收 {len(rejected)} 条")
    print(f"  {counts}")
    print(f"  queue.json / queue_api.json / queue_ui.json / queue_git.json → runs/{run_id}/")
    if rejected:
        print(f"  ⚠️ {len(rejected)} 条拒收，原因见 rejected.json")


if __name__ == "__main__":
    main()
