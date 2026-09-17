#!/usr/bin/env python3
"""ui_runner.py — ui 类用例执行器（**本包独有**，上游无此文件）

驱动 Playwright Chromium 跑 75 条 ui 用例。判定与驱动分离：
execute() 把每条断言所需的页面事实抽成 probes（纯 dict），
evaluate() 只吃 probes —— 因此判定逻辑可在无浏览器环境下单测。

支持的 action 动词（用例集全集）:
  wait_for_selector(selector, timeout) / wait(ms) / click(selector)
  type(selector, value) / navigate(url) / screenshot(path)

支持的断言 target:
  ui_element_visible(selector) / ui_text_contains(selector, text)
  ui_page_title(text) / ui_url_match(contains)

selector 直接透传给 Playwright，因此 `:visible`、`:has-text()`、
逗号回退（`a, b, c` = 命中任一）都按 Playwright CSS 方言生效。

环境变量:
  UI_HEADLESS=0      有头模式调试（默认 1 headless）
  UI_ACTION_TIMEOUT  单个 action 默认超时毫秒（默认 15000）
  UI_NAV_TIMEOUT     页面导航超时毫秒（默认 30000）
  UI_SETTLE_TIMEOUT  SPA 渲染静默等待毫秒（默认 10000）
  GITCODE_COOKIE     登录态；缺失时公开页仍可跑，私有页会判不可测试
"""
import os
import re

HEADLESS = os.environ.get("UI_HEADLESS", "1") != "0"
ACTION_TIMEOUT = int(os.environ.get("UI_ACTION_TIMEOUT", 15000))
NAV_TIMEOUT = int(os.environ.get("UI_NAV_TIMEOUT", 30000))
SETTLE_TIMEOUT = int(os.environ.get("UI_SETTLE_TIMEOUT", 10000))


def settle(page, flags=None):
    """等 SPA 真正渲染出内容。

    GitCode 是 SPA：domcontentloaded 时 body 已存在但内容为空，而用例集里
    大量 `wait_for_selector: body` 会立刻返回，导致断言与渲染赛跑（同一条
    用例在 PASS / FAIL 之间漂移）。这里等到 body 有可见文字为止；等不到不
    致命，只在 flags 里留痕，让判定按实际页面事实走。
    """
    try:
        page.wait_for_function(
            "() => document.body && document.body.innerText.trim().length > 0",
            timeout=SETTLE_TIMEOUT)
    except Exception:
        if flags is not None:
            flags.append("settle_timeout")
        return False
    return True


def playwright_available():
    try:
        import playwright.sync_api  # noqa: F401
        return True
    except ImportError:
        return False


def subst(text, owner, repo):
    """ui.url / navigate.url 里的 {owner}/{repo} 占位符替换。"""
    return (text or "").replace("{owner}", owner).replace("{repo}", repo)


def parse_cookie(raw, domain="gitcode.com"):
    """`k=v; k2=v2` 形式的 Cookie 串 → Playwright add_cookies 入参。"""
    out = []
    for part in (raw or "").split(";"):
        part = part.strip()
        if not part or "=" not in part:
            continue
        k, _, v = part.partition("=")
        out.append({"name": k.strip(), "value": v.strip(),
                    "domain": domain, "path": "/"})
    return out


def _run_actions(page, actions, owner, repo, shot_dir, flags=None):
    """按序执行 actions，返回错误列表（不抛异常，让断言去反映页面真实状态）。"""
    errors = []
    for i, a in enumerate(actions or []):
        t = a.get("type")
        sel = a.get("selector")
        try:
            if t == "wait_for_selector":
                page.wait_for_selector(sel, timeout=a.get("timeout") or ACTION_TIMEOUT,
                                       state="visible")
            elif t == "wait":
                page.wait_for_timeout(a.get("ms") or 1000)
            elif t == "click":
                page.locator(sel).first.click(timeout=a.get("timeout") or ACTION_TIMEOUT)
            elif t == "type":
                page.locator(sel).first.fill(str(a.get("value", "")),
                                             timeout=a.get("timeout") or ACTION_TIMEOUT)
            elif t == "navigate":
                page.goto(subst(a.get("url"), owner, repo), timeout=NAV_TIMEOUT,
                          wait_until="domcontentloaded")
                settle(page, flags)
            elif t == "screenshot":
                if shot_dir:
                    os.makedirs(shot_dir, exist_ok=True)
                    name = os.path.basename(a.get("path") or f"shot-{i}.png")
                    page.screenshot(path=os.path.join(shot_dir, name))
            else:
                errors.append(f"actions[{i}]: 未实现的动词 {t}")
        except Exception as e:  # Playwright 超时/元素缺失都在此收口
            errors.append(f"actions[{i}] {t}({sel or ''}): "
                          f"{type(e).__name__}: {str(e).splitlines()[0][:120]}")
    return errors


def _probe(page, assertions):
    """把每条断言需要的页面事实抽成纯 dict，供 evaluate() 离线判定。"""
    probes = []
    for a in assertions or []:
        tgt, sel = a.get("target"), a.get("selector")
        p = {"target": tgt, "selector": sel}
        try:
            if tgt == "ui_element_visible":
                loc = page.locator(sel)
                p["visible"] = loc.count() > 0 and loc.first.is_visible()
            elif tgt == "ui_text_contains":
                loc = page.locator(sel)
                p["text"] = loc.first.inner_text() if loc.count() else None
            elif tgt == "ui_page_title":
                p["title"] = page.title()
            elif tgt == "ui_url_match":
                p["url"] = page.url
            else:
                p["unsupported"] = True
        except Exception as e:
            p["error"] = f"{type(e).__name__}: {str(e).splitlines()[0][:100]}"
        probes.append(p)
    return probes


def execute(doc, cfg, browser=None, shot_dir=None, dry_run=False):
    """跑一条 ui 用例。browser 由 run_ui_batch 复用（一个浏览器多个 context）。"""
    ui = doc.get("ui") or {}
    owner, repo = cfg.owner, cfg.repo
    url = subst(ui.get("url"), owner, repo)
    vp = ui.get("viewport") or {"width": 1280, "height": 720}
    rr = {"case_id": doc.get("id", ""), "jobs": [], "gitcode_run_id": "",
          "head_sha": "", "duration_seconds": 0, "logs": "", "run_url": url,
          "action_count": len(ui.get("actions") or [])}

    if dry_run:
        rr.update(status="DRY_RUN")
        return rr
    if not playwright_available():
        rr.update(status="ENV_ERROR", error="Playwright 未安装（pip install playwright "
                                           "&& playwright install chromium）")
        return rr

    import time
    from playwright.sync_api import Error as PWError

    cookie = os.environ.get("GITCODE_COOKIE", "")
    t0 = time.time()
    ctx = page = None
    try:
        ctx = browser.new_context(viewport={"width": vp.get("width", 1280),
                                            "height": vp.get("height", 720)})
        if cookie:
            try:
                ctx.add_cookies(parse_cookie(cookie))
            except PWError as e:
                rr["cookie_warning"] = f"Cookie 注入失败: {e}"
        page = ctx.new_page()
        flags = []
        page.goto(url, timeout=NAV_TIMEOUT, wait_until="domcontentloaded")
        settle(page, flags)
        rr["action_errors"] = _run_actions(page, ui.get("actions"), owner, repo,
                                           shot_dir, flags)
        rr["probes"] = _probe(page, doc.get("assertions"))
        rr["flags"] = flags
        rr.update(status=page.url and 200, final_url=page.url,
                  page_title=page.title(), logged_in=bool(cookie),
                  logs=(page.content() or "")[:20000])
    except Exception as e:
        rr.update(status="ENV_ERROR",
                  error=f"页面打开失败 {url}: {type(e).__name__}: "
                        f"{str(e).splitlines()[0][:150]}")
    finally:
        for obj in (page, ctx):
            try:
                obj and obj.close()
            except Exception:
                pass
        rr["duration_seconds"] = round(time.time() - t0, 2)
    return rr


def evaluate(rr, assertions):
    """纯函数判定：只依赖 rr["probes"]，无需浏览器。"""
    if rr.get("status") == "ENV_ERROR":
        return {"verdict": "ENV_ERROR", "verdict_flags": [],
                "reason": rr.get("error", "环境不可用"), "assertion_results": []}

    probes = rr.get("probes") or []
    results = []
    for a, p in zip(assertions or [], probes):
        tgt = a.get("target")
        if p.get("unsupported"):
            results.append({"kind": f"{tgt} (未实现)", "pass": False,
                            "expected": "—", "actual": "—", "unsupported": True})
            continue
        if p.get("error"):
            results.append({"kind": f"{tgt} 探测失败", "pass": False,
                            "expected": a.get("selector") or a.get("text"),
                            "actual": p["error"], "unsupported": False})
            continue
        if tgt == "ui_element_visible":
            results.append({"kind": "element_visible", "pass": bool(p.get("visible")),
                            "expected": p["selector"], "actual": p.get("visible"),
                            "unsupported": False})
        elif tgt == "ui_text_contains":
            txt, exp = p.get("text") or "", str(a.get("text", ""))
            results.append({"kind": "text_contains", "pass": exp in txt,
                            "expected": exp, "actual": f"len={len(txt)}",
                            "unsupported": False})
        elif tgt == "ui_page_title":
            title, exp = p.get("title") or "", str(a.get("text", ""))
            results.append({"kind": "page_title", "pass": exp in title,
                            "expected": exp, "actual": title[:60],
                            "unsupported": False})
        elif tgt == "ui_url_match":
            cur, exp = p.get("url") or "", str(a.get("contains", ""))
            results.append({"kind": "url_match", "pass": exp in cur,
                            "expected": exp, "actual": cur[:80],
                            "unsupported": False})

    flags = []
    if rr.get("action_errors"):
        flags.append("action_error")
    if not rr.get("logged_in"):
        flags.append("no_login")

    failed = [r for r in results if not r["pass"] and not r["unsupported"]]
    unsupported = [r for r in results if r["unsupported"]]

    if failed:
        verdict = "FAIL"
        reason = "; ".join(f"{r['kind']} 期望 {r['expected']} 实际 {r['actual']}"
                           for r in failed[:3])
    elif unsupported:
        verdict, reason = "INCONCLUSIVE", \
            f"{len(unsupported)} 条断言 target 未实现"
    elif not results:
        verdict, reason = "INCONCLUSIVE", "用例无断言"
    else:
        verdict, reason = "PASS", f"{len(results)} 条断言全部通过"

    # 交互没走完时，通过的断言可能是空转（用例集有 90 处 selector 就是 `body`），
    # 故降级为不可测试而非记通过。
    if verdict == "PASS" and rr.get("action_errors"):
        verdict = "INCONCLUSIVE"
        reason = (f"{len(rr['action_errors'])} 个 action 未成功，页面未达预期状态，"
                  f"断言通过不足以采信: {rr['action_errors'][0]}")
    if rr.get("action_errors"):
        reason += f"（action 错误 {len(rr['action_errors'])} 个）"
    return {"verdict": verdict, "verdict_flags": flags, "reason": reason,
            "assertion_results": results}
