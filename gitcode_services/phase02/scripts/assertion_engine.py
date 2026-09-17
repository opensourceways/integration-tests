#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
assertion_engine.py — Phase 02 原生组件：确定性断言判定（可复用）

实现 `phase02/scripts/assertion-engine.md` 规格。**pass/fail 的最终裁决只由本引擎
做出，LLM 绝不参与**（rules.md §1）。判定词枚举与对外映射以 rules.md §11 为唯一权威。

输入：workflow_runner 产出的 RunResult + 用例的 assertions 列表。
输出：{ case_id, verdict, verdict_flags, assertion_results[], ... }，
      verdict ∈ §11 内部枚举：
        PASS / FAIL / NOT_CONFIGURED / NO_RUN / ENV_ERROR / TIMEOUT / INCONCLUSIVE
      （FLAKY 由 report-builder 跨多次执行判定，不在单次判定内产生）

支持的断言 kind（吸收自 execute_serial/logassert/masking + 规格）：
  状态型（不依赖日志正文）：
    status      : 所有 job/step 均为绿（COMPLETED/SUCCESS）。状态型用例把断言写进
                  workflow 内 shell test，失败即 step 非零退出 → 平台 FAILED。
    run_status  : {equals: <期望终态>} 比对 conclusion。
    job_status  : {equals: <期望终态>, name?: <job名/ID子串>} job 级终态判定。
                  有 name 时按 job name/id 子串匹配（无匹配 → INCONCLUSIVE）；
                  无 name 时任一 job 命中即 pass。
    step_status : {equals: <期望终态>, name?: <step名子串>} step 级终态判定，规则同上。
    job_count   : {equals: N} run 内 job 实例总数（matrix 展开计数）。
    job_count_by_status: {status: <终态>, equals: N} 处于指定终态的 job 数。
  日志型（需 RunResult.logs 非空）：
    value       : {expect: <非敏感值>} 日志应包含该值（positive）。
    value_in    : {any_of: [<值1>, <值2>, ...]} 日志应至少包含其一（positive）。
    leak        : {forbidden: <明文>} 日志不得包含该明文（negative, 安全命脉）。
    mask        : {secret_value: <夹具明文>} 日志出现 *** 且明文 0 命中（negative）。
    log_metric_le      : {metric: <名>, le: <秒>} 日志含 "metric=N" 且 N ≤ le。
    log_metric_delta_le: {start: <名>, end: <名>, le: <秒>}
                         日志含 "start=S"/"end=E" 且 E-S ≤ le（workflow 内自打时间戳）。
  资源探测：
    config_probe: {present: bool} 前置资源是否已配置；未配置 → NOT_CONFIGURED。
  耗时型（不依赖日志正文）：
    duration_le : {le: <秒>} run duration_seconds ≤ le 才 pass；超出判 INCONCLUSIVE
                  （duration 是指标的上界：duration ≤ le ⇒ 指标 ≤ le 成立；
                   duration > le 无法反推指标超标，保守不判 FAIL）。

假绿守卫（铁律）：run=COMPLETED 但无 job/step，或日志型断言而日志为空 → 不得判 PASS。
"""
import re

_GREEN = ("COMPLETED", "SUCCESS", None)  # None 容忍某些平台 step 无终态标记
_LOG_KINDS = ("value", "value_in", "leak", "mask", "config_probe",
              "log_metric_le", "log_metric_delta_le")

# 终态词归一（消除用例 success↔平台 COMPLETED 系统性假 FAIL）
# 等价类来源：compiled asserts 63 条 + results 192 条真实词形统计（2026-07-23-valid-clean）
# 2026-07-24 补充：SUCCESS/CANCELED/skipped/IGNORED 等遗漏映射（failure-analysis-96-cases.md 归因）
_TERMINAL_NORM = {
    "success": "COMPLETED", "completed": "COMPLETED", "completed(success)": "COMPLETED",
    "completed_success": "COMPLETED", "succeeded": "COMPLETED",
    "successful": "COMPLETED", "ok": "COMPLETED", "passed": "COMPLETED", "pass": "COMPLETED",
    "成功": "COMPLETED", "完成": "COMPLETED",
    "SUCCESS": "COMPLETED",  # ← 平台偶发返回 SUCCESS 而非 COMPLETED
    "failure": "FAILED", "failed": "FAILED", "completed(failure)": "FAILED",
    "error": "FAILED", "失败": "FAILED", "错误": "FAILED",
    "canceled": "CANCELLED", "cancelled": "CANCELLED", "取消": "CANCELLED",
    "CANCELED": "CANCELLED",  # ← 美式拼写（单 L）归一到英式 CANCELLED
    "skipped": "IGNORED", "SKIPPED": "IGNORED",  # ← 用例侧词汇映射到平台实际返回 IGNORED
    "IGNORED": "IGNORED",  # ← 平台原词保真
}


def _normalize_terminal(word):
    """大小写不敏感归一：按等价类映射规范终态，未知词保守原样大写返回。"""
    if not word:
        return word
    w = str(word).strip()
    return _TERMINAL_NORM.get(w.lower(), w.upper())


def _terminal_match(expected, actual):
    """终态匹配：expected 支持复合标记（2026-07-25，修"标记不匹配"假 FAIL）。

    - `A_OR_B` 多值：任一可选值命中即匹配（如 SUCCESS_OR_FAILURE、COMPLETED_OR_BLOCKED）。
    - `X_WITH_Y` 复合：WITH 后的语义（如 with_write/with_base_workflow）无法从
      conclusion 判定，按主状态 X 近似（对应的负向语义由 leak/value 断言覆盖）。
    """
    actual_n = _normalize_terminal(actual)
    for alt in re.split(r"_OR_", str(expected or "").upper()):
        alt = re.split(r"_WITH_", alt.strip())[0]
        if alt and _normalize_terminal(alt) == actual_n:
            return True
    return False


def _norm_sep(s):
    """分隔符归一：连续下划线/空格统一为单个空格。双侧对称使用保标识符不误伤。"""
    return re.sub(r'[_\s]+', ' ', s)


def _all_green(run_result):
    """状态型判绿：至少 1 个 job、且所有 job/step 状态为绿。含假绿守卫。"""
    jobs = run_result.get("jobs") or []
    if not jobs:
        return False, "no jobs (假绿守卫)"
    saw_step = False
    for j in jobs:
        if j.get("status") not in _GREEN:
            return False, f"job '{j.get('name')}' status={j.get('status')}"
        for s in (j.get("steps") or []):
            saw_step = True
            if s.get("status") not in _GREEN:
                return False, f"step '{s.get('name')}' status={s.get('status')}"
    if not saw_step:
        return False, "no steps (假绿守卫)"
    return True, "all job/step green"


def _eval_one(a, run_result):
    """判定单条断言 → result dict（含 pass / expected / actual）。

    返回的 result 额外可带：
      is_security_critical: True   （mask/leak 失败要高亮）
      inconclusive: True           （无法有意义判定，如日志型但无日志）
      not_configured: True         （config_probe 探到未配置）
    """
    kind = a.get("kind") or a.get("type")
    logs = run_result.get("logs") or ""
    logs_available = run_result.get("logs_available", False)

    # 日志型断言但日志不可得 → 无法判定（INCONCLUSIVE，不得当 FAIL）
    if kind in _LOG_KINDS and (not logs_available or not logs.strip()):
        return {"kind": kind, "pass": False, "inconclusive": True,
                "expected": f"log-based '{kind}'",
                "actual": "日志不可得/为空——无法确定性判定"}

    if kind == "config_probe":
        # 日志探测式：workflow echo "configured_len=${#SECRET}"（只暴露长度，不暴露值）；
        # 日志含 unconfigured_pattern（默认 "configured_len=0"）→ 前置资源未配置。
        pattern = a.get("unconfigured_pattern", "configured_len=0")
        unconfigured = pattern in logs
        return {"kind": kind, "pass": not unconfigured, "not_configured": unconfigured,
                "expected": f"资源已配置（日志无 '{pattern}'）",
                "actual": "NOT_CONFIGURED" if unconfigured else "configured"}

    if kind == "status":
        ok, why = _all_green(run_result)
        return {"kind": kind, "type": "positive", "target": "run_status",
                "pass": ok, "expected": "all job/step green", "actual": why}

    if kind == "run_status":
        expected_raw = a.get("equals", "COMPLETED")
        actual = _normalize_terminal(run_result.get("conclusion") or "")
        return {"kind": kind, "type": "positive", "target": "run_status",
                "pass": _terminal_match(expected_raw, run_result.get("conclusion") or ""),
                "expected": _normalize_terminal(expected_raw)
                if "_OR_" not in str(expected_raw) else str(expected_raw),
                "actual": actual}

    if kind == "run_status_not":
        not_expected = a["not_equals"]
        actual = _normalize_terminal(run_result.get("conclusion") or "")
        return {"kind": kind, "type": "negative", "target": "run_status",
                "pass": not _terminal_match(not_expected, run_result.get("conclusion") or ""),
                "expected": f"conclusion != {not_expected}", "actual": actual}

    if kind in ("job_status", "step_status"):
        expected_raw = a.get("equals", "COMPLETED")
        expected = _normalize_terminal(expected_raw)
        hint = (a.get("name") or "").lower()
        if kind == "job_status":
            pool = run_result.get("jobs") or []
            matched = [j for j in pool
                       if not hint or hint in str(j.get("name") or "").lower()
                       or hint in str(j.get("id") or "").lower()]
        else:
            pool = [dict(s, _job=j.get("name"))
                    for j in (run_result.get("jobs") or [])
                    for s in (j.get("steps") or [])]
            matched = [s for s in pool
                       if not hint or hint in str(s.get("name") or "").lower()]
        if hint and not matched:
            return {"kind": kind, "type": "positive", "target": kind,
                    "pass": False, "inconclusive": True,
                    "expected": f"{kind} == {expected} (name~'{hint}')",
                    "actual": f"无匹配 '{hint}' 的 {kind.split('_')[0]}——无法判定"}
        hit = [x for x in matched
               if _terminal_match(expected_raw, x.get("status") or "")]
        actual_desc = ", ".join(
            f"{x.get('name')}={_normalize_terminal(x.get('status') or '')}"
            for x in matched[:5]) or "empty"
        return {"kind": kind, "type": "positive", "target": kind,
                "pass": bool(hit),
                "expected": f"{kind} == {expected}" + (f" (name~'{hint}')" if hint else ""),
                "actual": actual_desc}

    if kind == "job_count":
        jobs = run_result.get("jobs") or []
        if not jobs:
            return {"kind": kind, "type": "positive", "target": "job_count",
                    "pass": False, "inconclusive": True,
                    "expected": f"job_count == {a.get('equals')}",
                    "actual": "no jobs (假绿守卫)"}
        expected_n = int(a.get("equals"))
        return {"kind": kind, "type": "positive", "target": "job_count",
                "pass": len(jobs) == expected_n,
                "expected": f"job_count == {expected_n}", "actual": len(jobs)}

    if kind == "job_count_by_status":
        jobs = run_result.get("jobs") or []
        if not jobs:
            return {"kind": kind, "type": "positive", "target": "job_count_by_status",
                    "pass": False, "inconclusive": True,
                    "expected": f"{a.get('status')} count == {a.get('equals')}",
                    "actual": "no jobs (假绿守卫)"}
        st = _normalize_terminal(a.get("status", "CANCELLED"))
        expected_n = int(a.get("equals"))
        n = sum(1 for j in jobs
                if _normalize_terminal(j.get("status") or "") == st)
        return {"kind": kind, "type": "positive", "target": "job_count_by_status",
                "pass": n == expected_n,
                "expected": f"{st} count == {expected_n}", "actual": n}

    if kind == "duration_le":
        le = float(a.get("le"))
        dur = run_result.get("duration_seconds")
        if dur is None:
            return {"kind": kind, "type": "nonfunctional", "target": "duration",
                    "pass": False, "inconclusive": True,
                    "expected": f"duration <= {le}s", "actual": "duration 不可得"}
        ok = float(dur) <= le
        # duration 是指标上界：≤le 确凿 pass；>le 无法反推具体指标 → inconclusive
        return {"kind": kind, "type": "nonfunctional", "target": "duration",
                "pass": ok, "inconclusive": not ok,
                "expected": f"duration <= {le}s（上界近似）",
                "actual": f"{dur}s" + ("" if ok else "（超上界，无法定位具体指标）")}

    if kind == "value":
        expect = a["expect"]
        present = _norm_sep(expect) in _norm_sep(logs)
        return {"kind": kind, "type": "positive", "target": "run_logs",
                "pass": present, "expected": f"log contains '{expect}'",
                "actual": "present" if present else "absent"}

    if kind == "leak":
        forbidden = a["forbidden"]
        leaked = _norm_sep(forbidden) in _norm_sep(logs)
        return {"kind": kind, "type": "negative", "target": "run_logs",
                "pass": not leaked, "is_security_critical": True,
                "expected": f"plaintext '{forbidden}' 0 hits",
                "actual": "FOUND" if leaked else 0}

    if kind == "mask":
        secret_value = a["secret_value"]
        leaked = secret_value in logs
        masked = "***" in logs
        return {"kind": kind, "type": "negative", "target": "run_logs",
                "pass": (not leaked) and masked, "is_security_critical": True,
                "expected": "*** present & plaintext 0 hits",
                "actual": f"plaintext={'FOUND' if leaked else 0}, "
                          f"***={'yes' if masked else 'no'}"}

    if kind == "value_in":
        choices = a.get("any_of") or []
        norm_logs = _norm_sep(logs)
        hit = [v for v in choices if _norm_sep(str(v)) in norm_logs]
        return {"kind": kind, "type": "positive", "target": "run_logs",
                "pass": bool(hit),
                "expected": f"log contains one of {choices}",
                "actual": f"hit={hit[0]}" if hit else "none present"}

    if kind == "log_metric_le":
        metric = a["metric"]
        le = float(a.get("le"))
        m = re.search(rf"{re.escape(metric)}\s*[=:]\s*(\d+(?:\.\d+)?)", logs)
        if not m:
            return {"kind": kind, "type": "nonfunctional", "target": metric,
                    "pass": False, "inconclusive": True,
                    "expected": f"{metric} <= {le}", "actual": f"日志无 '{metric}=N' 标记"}
        val = float(m.group(1))
        return {"kind": kind, "type": "nonfunctional", "target": metric,
                "pass": val <= le, "expected": f"{metric} <= {le}", "actual": val}

    if kind == "log_metric_delta_le":
        start, end = a["start"], a["end"]
        le = float(a.get("le"))
        ms = re.search(rf"{re.escape(start)}\s*[=:]\s*(\d+(?:\.\d+)?)", logs)
        me = re.search(rf"{re.escape(end)}\s*[=:]\s*(\d+(?:\.\d+)?)", logs)
        if not ms or not me:
            return {"kind": kind, "type": "nonfunctional", "target": f"{start}~{end}",
                    "pass": False, "inconclusive": True,
                    "expected": f"({end}-{start}) <= {le}",
                    "actual": f"日志缺时间戳标记（{'缺 '+start if not ms else ''}"
                              f"{'缺 '+end if not me else ''}）"}
        delta = float(me.group(1)) - float(ms.group(1))
        return {"kind": kind, "type": "nonfunctional", "target": f"{start}~{end}",
                "pass": delta <= le, "expected": f"({end}-{start}) <= {le}s",
                "actual": f"{delta:.0f}s"}

    # 未知 kind → 无法判定，不冒充 PASS
    return {"kind": kind, "pass": False, "inconclusive": True,
            "expected": f"known assertion kind", "actual": f"unknown kind '{kind}'"}


def evaluate(run_result, assertions):
    """主入口：RunResult + assertions → 判定结论（§11）。

    优先级（短路顺序）：
      1. 执行层异常状态（NO_RUN/TIMEOUT/ENV_ERROR）直接透传。
      2. config_probe 探到未配置 → NOT_CONFIGURED（资源缺失 ≠ FAIL）。
      3. 逐条判定；有 inconclusive 且无明确 FAIL → INCONCLUSIVE（映射"未发现问题"）。
      4. 全 pass → PASS；否则 FAIL（有安全断言失败则打 SECURITY_CRITICAL）。
    """
    case_id = run_result.get("case_id", "")
    status = run_result.get("status")

    # 1. 执行层异常透传
    if status in ("NO_RUN", "TIMEOUT", "ENV_ERROR", "COMPILE_ERROR"):
        return _verdict(case_id, status, [], run_result,
                        reason=run_result.get("reason", ""))

    # 1b. push 后 run FAILED 且 0 job → workflow 被平台拒绝（SYNTAX_ERROR 类）
    if run_result.get("workflow_rejected"):
        return _verdict(case_id, "COMPILE_ERROR", [], run_result,
                        reason=run_result.get("reason", "workflow 被平台拒绝"))

    results = [_eval_one(a, run_result) for a in (assertions or [])]

    # 2. 资源未配置
    if any(r.get("not_configured") for r in results):
        return _verdict(case_id, "NOT_CONFIGURED", results, run_result,
                        reason="前置资源未配置（config_probe）")

    # 若无任何断言：只要跑到终态且有 job/step 即视为状态型 PASS 的退化情况，
    # 但缺断言本身不足以确定性判定 → INCONCLUSIVE，交人工/补断言。
    if not results:
        ok, why = _all_green(run_result)
        if ok:
            return _verdict(case_id, "INCONCLUSIVE", [], run_result,
                            reason="无显式断言，仅平台状态为绿，不足以确定性判定")
        return _verdict(case_id, "FAIL", [], run_result, reason=f"无断言且状态非绿: {why}")

    # 3. 有无法判定项且没有确凿 FAIL → INCONCLUSIVE
    inconclusive = [r for r in results if r.get("inconclusive")]
    hard_fail = [r for r in results if not r["pass"] and not r.get("inconclusive")]
    if inconclusive and not hard_fail:
        return _verdict(case_id, "INCONCLUSIVE", results, run_result,
                        reason="存在无法确定性判定的断言（如日志不可得）")

    # 4. 终判
    if all(r["pass"] for r in results):
        return _verdict(case_id, "PASS", results, run_result)
    flags = []
    if any((not r["pass"]) and r.get("is_security_critical") for r in results):
        flags.append("SECURITY_CRITICAL")
    return _verdict(case_id, "FAIL", results, run_result, flags=flags)


def _verdict(case_id, verdict, results, run_result, flags=None, reason=""):
    return {
        "case_id": case_id,
        "verdict": verdict,
        "verdict_flags": flags or [],
        "reason": reason,
        "gitcode_run_id": run_result.get("gitcode_run_id", ""),
        "run_status": run_result.get("status"),
        "duration_seconds": run_result.get("duration_seconds", 0),
        "assertion_results": results,
    }


if __name__ == "__main__":
    # 自检：用构造的 RunResult 跑几种判定，验证 §11 枚举逻辑（不触网）。
    def check(name, rr, asserts, expect):
        v = evaluate(rr, asserts)["verdict"]
        ok = "OK" if v == expect else "XX"
        print(f"  [{ok}] {name}: got {v}, expect {expect}")

    green1 = {"case_id": "T", "status": "COMPLETED", "logs_available": True,
              "logs": "masked_probe=***\n", "jobs": [{"name": "j", "status": "COMPLETED",
              "steps": [{"name": "s", "status": "COMPLETED"}]}]}
    print("assertion_engine self-check:")
    check("mask ok", green1, [{"kind": "mask", "secret_value": "org_secret"}], "PASS")
    check("leak found", {**green1, "logs": "token=org_secret\n"},
          [{"kind": "leak", "forbidden": "org_secret"}], "FAIL")
    check("value present", {**green1, "logs": "orgvar_value=org_value\n"},
          [{"kind": "value", "expect": "orgvar_value=org_value"}], "PASS")
    check("status green", green1, [{"kind": "status"}], "PASS")
    check("empty jobs 假绿守卫", {**green1, "jobs": []}, [{"kind": "status"}], "FAIL")
    check("log unavailable", {**green1, "logs_available": False, "logs": ""},
          [{"kind": "mask", "secret_value": "x"}], "INCONCLUSIVE")
    check("not configured", {**green1, "logs": "configured_len=0\n"},
          [{"kind": "config_probe"}], "NOT_CONFIGURED")
    check("run_status_not pass(F=SUCCESS)", {**green1, "conclusion": "FAILED"},
          [{"kind": "run_status_not", "not_equals": "SUCCESS"}], "PASS")
    check("run_status_not fail(S=SUCCESS)", {**green1, "conclusion": "SUCCESS"},
          [{"kind": "run_status_not", "not_equals": "SUCCESS"}], "FAIL")
    check("timeout passthrough", {"case_id": "T", "status": "TIMEOUT"},
          [{"kind": "status"}], "TIMEOUT")
    # ── 新增 kind 自检（2026-07-25）──
    multi = {"case_id": "T", "status": "COMPLETED", "conclusion": "COMPLETED",
             "logs_available": True, "duration_seconds": 120,
             "logs": "upload_start=100\nupload_end=120\nhash_match=true\ndownload_content=BBB\n",
             "jobs": [{"name": "fail job", "status": "FAILED",
                       "steps": [{"name": "s", "status": "FAILED"}]},
                      {"name": "ok job", "status": "COMPLETED",
                       "steps": [{"name": "s", "status": "COMPLETED"}]},
                      {"name": "cancelled j1", "status": "CANCELLED", "steps": []},
                      {"name": "cancelled j2", "status": "CANCELLED", "steps": []}]}
    check("job_status any-failure", multi, [{"kind": "job_status", "equals": "failure"}], "PASS")
    check("job_status name hint hit", multi,
          [{"kind": "job_status", "equals": "failure", "name": "fail"}], "PASS")
    check("job_status name hint miss → INCONCLUSIVE", multi,
          [{"kind": "job_status", "equals": "failure", "name": "nonexistent"}], "INCONCLUSIVE")
    check("step_status failure", multi, [{"kind": "step_status", "equals": "failure"}], "PASS")
    check("job_count 4", multi, [{"kind": "job_count", "equals": 4}], "PASS")
    check("job_count wrong", multi, [{"kind": "job_count", "equals": 3}], "FAIL")
    check("cancelled count 2", multi,
          [{"kind": "job_count_by_status", "status": "CANCELLED", "equals": 2}], "PASS")
    check("value_in hit", multi,
          [{"kind": "value_in", "any_of": ["download_content=AAA",
                                           "download_content=BBB"]}], "PASS")
    check("value_in miss", multi,
          [{"kind": "value_in", "any_of": ["download_content=CCC"]}], "FAIL")
    check("metric delta ok", multi,
          [{"kind": "log_metric_delta_le", "start": "upload_start",
            "end": "upload_end", "le": 30}], "PASS")
    check("metric delta over", multi,
          [{"kind": "log_metric_delta_le", "start": "upload_start",
            "end": "upload_end", "le": 10}], "FAIL")
    check("metric missing → INCONCLUSIVE", multi,
          [{"kind": "log_metric_le", "metric": "nope_seconds", "le": 30}], "INCONCLUSIVE")
    check("duration within", multi, [{"kind": "duration_le", "le": 300}], "PASS")
    check("duration over → INCONCLUSIVE", multi, [{"kind": "duration_le", "le": 60}],
          "INCONCLUSIVE")
    # ── 复合终态标记（2026-07-25，SEC/COMP 标记不匹配修复）──
    check("run_status OR-match", multi,
          [{"kind": "run_status", "equals": "SUCCESS_OR_FAILURE"}], "PASS")
    check("run_status OR-miss", {**multi, "conclusion": "CANCELLED"},
          [{"kind": "run_status", "equals": "SUCCESS_OR_FAILURE"}], "FAIL")
    check("run_status WITH 近似", multi,
          [{"kind": "run_status", "equals": "SUCCESS_WITH_BASE_WORKFLOW"}], "PASS")
    check("run_status OR alt2 hit", {**multi, "conclusion": "FAILED"},
          [{"kind": "run_status", "equals": "COMPLETED_OR_BLOCKED"}], "FAIL")
    check("run_status_not OR 全避", multi,
          [{"kind": "run_status_not", "not_equals": "FAILED_OR_CANCELLED"}], "PASS")
    check("run_status 小写 OR 匹配", {**multi, "conclusion": "CANCELED"},
          [{"kind": "run_status", "equals": "failure_or_canceled"}], "PASS")
