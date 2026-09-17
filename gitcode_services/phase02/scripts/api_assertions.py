#!/usr/bin/env python3
"""api_assertions.py — api 类用例断言判定（**本包独有**，上游无此文件）

判定确定性，不含 LLM。支持本用例集实际用到的全部 target/谓词:
  api_status_code    : status_codes(list) / status_code(int)
  api_response_body  : contains / must_not_contain / json_path + json_value
  api_response_header: contains（在「名: 值」串上不区分大小写查找）

verdict 取值与上游 assertion_engine 对齐，供 report_builder 归类:
  PASS / FAIL / INCONCLUSIVE / ENV_ERROR / TIMEOUT
"""
import json
import re

# 单发请求无法复现的场景 → 判 INCONCLUSIVE 而非 FAIL，避免报假缺陷
_RATE_LIMIT_STATUS = 429


def _json_path(body, expr):
    """极简 JSONPath：支持 `$`、`$.a.b`、`$[0].a`（覆盖本用例集全部用法）。"""
    try:
        cur = json.loads(body)
    except (ValueError, TypeError):
        return None, "响应非合法 JSON"
    tokens = re.findall(r"\[\d+\]|[\w-]+", (expr or "").lstrip("$"))
    for tok in tokens:
        if tok.startswith("["):
            idx = int(tok[1:-1])
            if not isinstance(cur, list) or idx >= len(cur):
                return None, f"下标越界 {tok}"
            cur = cur[idx]
        else:
            if not isinstance(cur, dict) or tok not in cur:
                return None, f"缺字段 {tok}"
            cur = cur[tok]
    return cur, None


def _values_equal(actual, expected):
    """类型一致时直接比较；类型不同时退化为字符串比较（YAML 标量宽容）。"""
    if type(actual) is type(expected):
        return actual == expected
    return str(actual) == str(expected)


def _eval_one(a, rr):
    """单条断言 → {kind, pass, expected, actual, unsupported}"""
    target = a.get("target")
    sc = rr.get("status_code")
    body = rr.get("logs") or ""

    if target == "api_status_code":
        if "status_codes" in a:
            exp = a["status_codes"]
            return {"kind": "api_status_code in", "pass": sc in exp,
                    "expected": exp, "actual": sc, "unsupported": False}
        if "status_code" in a:
            exp = a["status_code"]
            return {"kind": "api_status_code ==", "pass": sc == exp,
                    "expected": exp, "actual": sc, "unsupported": False}

    if target == "api_response_body":
        if "json_path" in a:
            val, err = _json_path(body, a["json_path"])
            exp = a.get("json_value")
            ok = err is None and _values_equal(val, exp)
            return {"kind": f"json_path {a['json_path']}", "pass": ok,
                    "expected": exp, "actual": err or val, "unsupported": False}
        if "contains" in a:
            exp = str(a["contains"])
            return {"kind": "body contains", "pass": exp in body,
                    "expected": exp, "actual": f"len={len(body)}",
                    "unsupported": False}
        if "must_not_contain" in a:
            exp = str(a["must_not_contain"])
            return {"kind": "body must_not_contain", "pass": exp not in body,
                    "expected": f"不含 {exp}", "actual": f"len={len(body)}",
                    "unsupported": False}

    if target == "api_response_header":
        if "contains" in a:
            exp = str(a["contains"])
            flat = "; ".join(f"{k}: {v}" for k, v in
                             (rr.get("resp_headers") or {}).items())
            return {"kind": "header contains", "pass": exp.lower() in flat.lower(),
                    "expected": exp, "actual": f"{len(rr.get('resp_headers') or {})} 个头",
                    "unsupported": False}

    return {"kind": f"{target} (未实现的谓词)", "pass": False,
            "expected": str({k: v for k, v in a.items() if k not in ("type", "target")}),
            "actual": "—", "unsupported": True}


def _expects_rate_limit(assertions):
    """用例是否只在限流态下成立（单发请求必然复现不了）。"""
    for a in assertions or []:
        if a.get("target") != "api_status_code":
            continue
        if a.get("status_code") == _RATE_LIMIT_STATUS:
            return True
        if a.get("status_codes") == [_RATE_LIMIT_STATUS]:
            return True
    return False


def evaluate(rr, assertions):
    """返回 run_case.write_result 可消费的 verdict 字典。"""
    status = rr.get("status")

    if status == "TIMEOUT":
        return {"verdict": "TIMEOUT", "verdict_flags": [],
                "reason": rr.get("error", "请求超时"), "assertion_results": []}
    if status == "ENV_ERROR":
        return {"verdict": "ENV_ERROR", "verdict_flags": [],
                "reason": rr.get("error", "环境不可用"), "assertion_results": []}
    if status == "SKIPPED_WRITE":
        return {"verdict": "INCONCLUSIVE", "verdict_flags": ["skipped_write"],
                "reason": rr.get("error", "写方法被跳过"), "assertion_results": []}
    if status == "SKIPPED_UNSAFE":
        return {"verdict": "INCONCLUSIVE", "verdict_flags": ["skipped_unsafe_write"],
                "reason": rr.get("error", "写请求直打真实资源，默认跳过"),
                "assertion_results": []}

    if _expects_rate_limit(assertions) and rr.get("status_code") != _RATE_LIMIT_STATUS:
        return {"verdict": "INCONCLUSIVE", "verdict_flags": ["rate_limit_not_triggered"],
                "reason": f"用例需限流态（期望 {_RATE_LIMIT_STATUS}），"
                          f"单发请求实际得 {rr.get('status_code')}；"
                          f"执行器不做压测式触发，判不可测试而非缺陷",
                "assertion_results": []}

    results = [_eval_one(a, rr) for a in assertions or []]
    flags = []
    sc = rr.get("status_code")
    if isinstance(sc, int) and sc >= 500:
        flags.append("server_error")
    if rr.get("substituted"):
        flags.append("probe_placeholder")

    failed = [r for r in results if not r["pass"] and not r["unsupported"]]
    unsupported = [r for r in results if r["unsupported"]]

    if failed:
        verdict, reason = "FAIL", "; ".join(
            f"{r['kind']} 期望 {r['expected']} 实际 {r['actual']}" for r in failed[:3])
    elif unsupported:
        verdict, reason = "INCONCLUSIVE", \
            f"{len(unsupported)} 条断言的谓词尚未实现: " + \
            "; ".join(r["kind"] for r in unsupported[:3])
    elif not results:
        verdict, reason = "INCONCLUSIVE", "用例无断言"
    else:
        verdict, reason = "PASS", f"{len(results)} 条断言全部通过（HTTP {sc}）"

    if "probe_placeholder" in flags and verdict == "PASS":
        reason += f"；占位符 {rr['substituted']} 用探测值，预期打不到真实资源"

    return {"verdict": verdict, "verdict_flags": flags, "reason": reason,
            "assertion_results": results}
