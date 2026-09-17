#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
compile_asserts.py — Phase 02 断言编译器：把 Phase01 契约 YAML 的 assertions 编译成
assertion_engine 可消费的 compiled/<case-id>.asserts.json。

定位：执行前准备（非判定）。把 rubric 里的语义翻译成引擎的确定性 kind，
最终 pass/fail 仍由 assertion_engine 确定性裁决（不违反判定铁律 §A）。

用法:
  python compile_asserts.py <phase01-run-id> <phase02-run-id> [--src-dir <path>]
  python compile_asserts.py 2026-07-23-01 2026-07-23-valid --src-dir path/to/yaml
"""

import os, sys, json, glob, re

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PHASE02 = os.path.join(ROOT, "phase02")

# 从 rubric 文本提取确定性关键词（大写标识符、数字码如 403）
_KEYWORD_RE = re.compile(r'[A-Z][A-Z0-9_]{2,}(?:=\S*)?|\b[0-9]{3}\b')


def _extract_keyword(rubric_text):
    matches = _KEYWORD_RE.findall(rubric_text or "")
    return [m.strip().rstrip(",").rstrip(";") for m in matches if len(m.strip()) > 2]


def compile_one(assertion, case_id):
    """编译单条 assertion → 引擎断言 dict 或 None（needs_review）。"""
    atype = assertion.get("type", "")
    target = assertion.get("target", "")
    rubric_text = assertion.get("rubric", "")

    # ── -1) 已知无确定性数据源的 target：直接 needs_review ──
    # 这些 target 的数据不在 RunResult（run_status/jobs/logs）内，
    # 若落入 §0 contains 全局规则会被误编译为日志断言 → 必然假 FAIL
    # （USE-MD-01-001: step_summary contains 被降级为 run_logs 扫描）。
    # 诚实降级为 needs_review，待引擎补对应数据源后再加映射。
    _NO_DATASOURCE_TARGETS = (
        "step_summary", "step_summary_html", "artifacts", "cache_contents",
        "run_ui", "pr_ui", "ui_layout", "ui_visual",
    )
    if target in _NO_DATASOURCE_TARGETS:
        return None

    # ── 0) 明文值字段：不限 target，有明确值就编译 ──
    # contains / must_contain（positive）
    if atype == "positive":
        val = (assertion.get("contains") or assertion.get("must_contain"))
        if val is not None:
            return {"kind": "value", "expect": str(val)}
    # must_not_contain / must_not_equal（negative）
    if atype == "negative":
        val = (assertion.get("must_not_contain") or assertion.get("must_not_equal"))
        if val is not None:
            return {"kind": "leak", "forbidden": str(val)}
    # must_not_contain_secret / contains_masked → config_probe
    sn = (assertion.get("must_not_contain_secret") or assertion.get("contains_masked"))
    if sn is not None and sn:
        return {"kind": "config_probe"}

    # ── 1) status 家族：run 级 / job 级 / step 级分流 ──
    # run 级：复用 conclusion 比对（run_status kind）。
    # job 级：job_status kind（2026-07-25 新增）——按 jobs 列表逐 job 判定，
    #   消除"job 级断言误绑 workflow 级 run_status"的假 FAIL（REL-CONTINUE-01-030 归因）。
    #   job_a_status / job_b_status 等带前缀 target → name hint（前缀小写），
    #   引擎按 job name/id 子串匹配；匹配不到 → INCONCLUSIVE（不冒充 FAIL）。
    # step 级：step_status kind，规则同 job 级。
    _RUN_STATUS_TARGETS = (
        "run_status", "workflow_status", "parent_status", "api_status",
        "downstream_status", "rerun_result",
    )
    _JOB_STATUS_TARGETS = ("job_status",)
    _STEP_STATUS_TARGETS = ("step_status", "step_conclusion")
    eq_val = assertion.get("equals")
    if target in _RUN_STATUS_TARGETS and eq_val is not None:
        eq_s = str(eq_val)
        if re.match(r"^\d{3}$", eq_s):
            return None  # HTTP 码不作为状态，留给明文值进入 needs_review
        if atype == "positive":
            return {"kind": "run_status", "equals": eq_s}
        if atype == "negative":
            not_eq = assertion.get("not_equals", eq_s)
            return {"kind": "run_status_not", "not_equals": str(not_eq)}

    if eq_val is not None and not re.match(r"^\d{3}$", str(eq_val)):
        if target in _JOB_STATUS_TARGETS or re.match(r"^job_[a-z0-9]+_status$", target):
            out = {"kind": "job_status", "equals": str(eq_val)}
            m = re.match(r"^(job_[a-z0-9]+)_status$", target)
            if m:  # job_a_status → hint "job_a"；裸 job_status 无 hint（任一 job 命中即 pass）
                out["name"] = m.group(1)
            return out
        if target in _STEP_STATUS_TARGETS:
            return {"kind": "step_status", "equals": str(eq_val)}
        # 通用 <前缀>_status / <前缀>_step_status → job/step 级 + name hint（2026-07-25）
        # 例: upload_status → job_status(name="upload")；cleanup_step_status → step_status(name="cleanup")
        m = re.match(r"^([a-z0-9_]+?)_step_status$", target)
        if m:
            return {"kind": "step_status", "equals": str(eq_val), "name": m.group(1)}
        m = re.match(r"^([a-z0-9]+)_status$", target)
        if m and m.group(1) not in ("run", "workflow", "job", "step",
                                    "parent", "api", "downstream"):
            return {"kind": "job_status", "equals": str(eq_val), "name": m.group(1)}

    # ── 1b) 原始 run_status（无 equals 时兜底）───
    if target == "run_status":
        if atype == "positive":
            val = assertion.get("equals", "COMPLETED")
            return {"kind": "run_status", "equals": str(val)}
        if atype == "negative":
            val = assertion.get("not_equals", assertion.get("equals") or "SUCCESS")
            return {"kind": "run_status_not", "not_equals": str(val)}

    # 2) run_logs（equals 字段 + 关键词提取，contains/must_not_contain 已在 §0 全局处理）
    if target == "run_logs":
        # 2a) equals（positive 用作日志内容匹配）
        if atype == "positive":
            val = assertion.get("equals")
            if val is not None:
                return {"kind": "value", "expect": str(val)}
        # 2b) eval=deterministic + rubric → extract keyword
        if assertion.get("eval") == "deterministic" and rubric_text:
            kws = _extract_keyword(rubric_text)
            if kws:
                kw = kws[0]
                if atype == "positive":
                    return {"kind": "value", "expect": kw}
                if atype == "negative":
                    return {"kind": "leak", "forbidden": kw}
        return None

    # ── 2c) job 计数家族（2026-07-25 新增，配合 matrix/fail-fast 用例）──
    if target == "generated_jobs_count" and eq_val is not None:
        return {"kind": "job_count", "equals": int(eq_val)}
    if target == "cancelled_jobs_count" and eq_val is not None:
        return {"kind": "job_count_by_status", "status": "CANCELLED",
                "equals": int(eq_val)}

    # ── 2d) 计时/性能家族（2026-07-25 新增）──
    # <x>_time_seconds + le → 日志时间戳对（<x>_start / <x>_end，workflow 内自打）。
    # scheduling_latency_seconds + le → duration_le（run duration 为延迟上界，
    #   duration ≤ le 确凿 pass；超出判 INCONCLUSIVE，见引擎 docstring）。
    le_val = assertion.get("le")
    if le_val is not None:
        m = re.match(r"^([a-z0-9_]+)_time_seconds$", target)
        if m:
            prefix = m.group(1)
            return {"kind": "log_metric_delta_le",
                    "start": f"{prefix}_start", "end": f"{prefix}_end",
                    "le": float(le_val)}
        if target in ("scheduling_latency_seconds", "duration_seconds"):
            return {"kind": "duration_le", "le": float(le_val)}

    # ── 2e) 制品内容家族（2026-07-25 新增）──
    # 约定：workflow 内 shell 自校验后 echo 标记，引擎做日志扫描。
    #   hash_match        → "hash_match=true/false"
    #   download_content  → "download_content=<值>"（in 列表逐项拼标记，任一命中即 pass）
    #   contains_mixed    → "contains_mixed=true/false"
    if target in ("hash_match", "md5_match") and eq_val is not None:
        return {"kind": "value", "expect": f"{target}={eq_val}"}
    if target == "download_content":
        in_list = assertion.get("in")
        if in_list:
            return {"kind": "value_in",
                    "any_of": [f"download_content={v}" for v in in_list]}
        mixed = assertion.get("contains_mixed")
        if mixed is not None:
            return {"kind": "value", "expect": f"contains_mixed={mixed}"}

    # 3) nonfunctional → 无法确定性编译
    if atype == "nonfunctional":
        return None

    return None


def main():
    if len(sys.argv) < 3:
        print("usage: compile_asserts.py <phase01-run-id> <phase02-run-id> [--src-dir <path>]")
        sys.exit(2)

    p1, p2 = sys.argv[1], sys.argv[2]
    args = sys.argv[3:]
    src_dir_override = None
    if "--src-dir" in args:
        idx = args.index("--src-dir")
        src_dir_override = args[idx + 1]

    if src_dir_override:
        src_dir = src_dir_override
    else:
        src_dir = os.path.join(ROOT, "phase01", "runs", p1, "cases", "yaml")
    if not os.path.isdir(src_dir):
        print(f"找不到用例目录: {src_dir}")
        sys.exit(1)

    out_dir = os.path.join(PHASE02, "runs", p2, "compiled")
    os.makedirs(out_dir, exist_ok=True)

    compiled = 0
    compiled_asserts = 0
    needs_review = []

    for f in sorted(glob.glob(os.path.join(src_dir, "*.yaml")) +
                    glob.glob(os.path.join(src_dir, "*.yml"))):
        try:
            doc = yaml.safe_load(open(f, encoding="utf-8"))
        except yaml.YAMLError:
            continue
        cid = (doc or {}).get("id", os.path.splitext(os.path.basename(f))[0])
        asserts = doc.get("assertions", []) if isinstance(doc, dict) else []
        if not asserts:
            continue

        compiled_list = []
        for a in asserts:
            if not isinstance(a, dict):
                continue
            result = compile_one(a, cid)
            if result:
                compiled_list.append(result)
                compiled_asserts += 1
            else:
                needs_review.append({
                    "case_id": cid,
                    "assertion": {str(k): str(v) for k, v in a.items()},
                    "reason": "target 或 rubric 无确定性映射规则",
                })

        if compiled_list:
            out_path = os.path.join(out_dir, f"{cid}.asserts.json")
            json.dump({"assertions": compiled_list}, open(out_path, "w", encoding="utf-8"),
                      ensure_ascii=False, indent=2)
            compiled += 1

    # ── compile-report ──
    print(f"compile_asserts 完成:")
    print(f"  成功编译: {compiled} 条用例（{compiled_asserts} 条断言）")
    print(f"  needs_review: {len(needs_review)} 条断言")

    if needs_review:
        review_path = os.path.join(out_dir, "_needs_review.json")
        json.dump(needs_review, open(review_path, "w", encoding="utf-8"),
                  ensure_ascii=False, indent=2)
        print(f"  needs_review 清单 → {review_path}")
        reasons = {}
        for item in needs_review:
            a = item["assertion"]
            r = f"type={a.get('type','?')} target={a.get('target','?')}"
            reasons[r] = reasons.get(r, 0) + 1
        print("  典型原因分布:")
        for r, c in sorted(reasons.items(), key=lambda x: -x[1])[:10]:
            print(f"    {c}x {r}")


if __name__ == "__main__":
    main()
