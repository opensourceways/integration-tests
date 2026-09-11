#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
openEuler EUR（基于 Copr 改造）接口自动化测试 —— 单文件版
被测地址: https://packages.test.osinfra.cn （测试环境，可用 EUR_BASE_URL 覆盖）
技术栈:   pytest + requests（接口）  /  Playwright（仅用于前端登录获取 API Token）

依据 copr_openapi.yaml 生成，覆盖 13 个模块共 59 条用例：
  auth / build / build-chroot / mock-chroot / module / monitor / package /
  permission / project / project-chroot / rpmrepo / webhook / openeuler-pkg

凭证获取策略（实测 2026-09-10）:
  EUR API 使用 HTTP Basic Auth（API login + API token），token 只能在登录后的
  {EUR_BASE_URL}/api/ 页面 <pre> 块中查看：
        [copr-cli]
        login = xxx
        username = yyy
        token = zzz
        # expiration date: 2027-03-09
  未登录时上述字段显示为 LOGIN_TO_REVEAL。因此本脚本在会话开始时：
    1. 优先复用 .auth/eur_api_token.json 中缓存的 token（调用 /api_3/auth-check 验活）；
    2. 缓存无效则拉起浏览器：/oidc_login/ → omapi.test.osinfra.cn →
       openeuler-usercenter.test.osinfra.cn（测试环境统一认证；生产为 id.openeuler.org）
       填账号密码 → 滑块（slider_solver 自动破解，失败提示人工）→ 邮箱验证码
       （email_verify 经 IMAP 抓取，失败提示人工）→ 跳回 EUR → 抓取 /api/ 页面 token；
    3. token 有效期 180 天，落盘后后续运行无需再登录。

登录页结构探测（测试用户中心 / id.openeuler.org 结构一致，均为 o-design 组件库）:
  账号输入: input[type='text'].o_input-input      密码输入: input[type='password']
  登录按钮: button.login-btn（字段为空时带 o-btn-disabled）
  Tab:      .login-tabs .tab  「账号登录」/「验证码登录」
  另：验证码通过后会弹出「openEuler服务隐私声明变更」弹窗，须滚动正文到底部
      才能激活「我已阅读并同意」，由 handle_privacy_dialog 处理。

使用方法:
    pip install -r requirements.txt
    playwright install msedge   # 或使用系统已装 Edge
    python email_verify.py      # 先自测邮箱 IMAP 配置（可选）
    pytest test_copr_api.py --html=report.html --self-contained-html -v
"""

import json
import logging
import os
import re
import time

import pytest
import requests
from dotenv import load_dotenv
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

from email_verify import fetch_verification_code, MailCodeError
from slider_solver import solve_slider

load_dotenv()

logger = logging.getLogger("eur_api")

# =============================================================================
# 配置项
# =============================================================================
BASE_URL = os.environ.get("EUR_BASE_URL", "https://packages.test.osinfra.cn").rstrip("/")
OIDC_LOGIN_URL = f"{BASE_URL}/oidc_login/"
API_TOKEN_PAGE = f"{BASE_URL}/api/"

# 统一认证域标识（登录成功后应离开这些域回到 EUR 业务域）。
# 生产 EUR → id.openeuler.org；测试环境 EUR → openeuler-usercenter.test.osinfra.cn。
# 两套登录页同为 openEuler o-design 组件，选择器完全一致，故共用一套登录逻辑。
SSO_DOMAIN_HINTS = [
    h.strip() for h in os.environ.get(
        "EUR_SSO_HOSTS",
        "openeuler-usercenter.test.osinfra.cn,id.openeuler.org"
    ).split(",") if h.strip()
]


def on_sso_page(page) -> bool:
    """当前是否仍停留在统一认证域"""
    return any(h in page.url for h in SSO_DOMAIN_HINTS)

USERNAME = os.environ.get("TEST_ACCOUNT", "")
PASSWORD = os.environ.get("TEST_PASSWORD", "")

# 若已直接配置 API 凭证，则跳过浏览器登录
ENV_API_LOGIN = os.environ.get("EUR_API_LOGIN", "")
ENV_API_TOKEN = os.environ.get("EUR_API_TOKEN", "")

# token 缓存文件
AUTH_STATE_PATH = os.path.join(".auth", "eur_api_token.json")

# requests 配置
TIMEOUT = int(os.environ.get("EUR_TIMEOUT", "30"))
VERIFY_SSL = os.environ.get("EUR_VERIFY_SSL", "true").lower() in ("1", "true", "yes")
MAX_RETRIES = int(os.environ.get("EUR_MAX_RETRIES", "2"))

# Playwright 配置
DEFAULT_TIMEOUT = 30000
BROWSER_HEADLESS = os.environ.get("BROWSER_HEADLESS", "0") == "1"

# 邮箱验证码 / 人工兜底
MAIL_CODE_TIMEOUT = int(os.environ.get("MAIL_CODE_TIMEOUT", "150"))
MFA_MANUAL_FALLBACK = os.environ.get("MFA_MANUAL", "1") == "1"
MFA_MANUAL_WAIT = int(os.environ.get("MFA_MANUAL_WAIT", "180"))

# 滑块验证
SLIDER_WAIT = int(os.environ.get("SLIDER_WAIT", "300"))
SLIDER_AUTO = os.environ.get("SLIDER_AUTO", "1") == "1"
SLIDER_AUTO_ATTEMPTS = int(os.environ.get("SLIDER_AUTO_ATTEMPTS", "3"))

# 测试数据（ownername 缺省取登录用户名，在 fixture 中回填）
TEST_PROJECTNAME = os.environ.get("EUR_TEST_PROJECTNAME", "autotest-project")
TEST_PACKAGENAME = os.environ.get("EUR_TEST_PACKAGENAME", "hello")
TEST_BUILD_ID = int(os.environ.get("EUR_TEST_BUILD_ID", "1"))
TEST_CHROOTNAME = os.environ.get("EUR_TEST_CHROOTNAME", "openeuler-24.03_LTS-x86_64")
TEST_GROUP_NAME = os.environ.get("EUR_TEST_GROUP_NAME", "openeuler")


# =============================================================================
# 前端登录获取 API Token
# =============================================================================
_API_PAGE_RE = {
    "login": re.compile(r"^\s*login\s*=\s*(\S+)", re.M),
    "username": re.compile(r"^\s*username\s*=\s*(\S+)", re.M),
    "token": re.compile(r"^\s*token\s*=\s*(\S+)", re.M),
    "expiration": re.compile(r"expiration date:\s*(\S+)", re.M),
}


def _parse_api_page(pre_text: str) -> dict:
    """从 /api/ 页面 <pre> 文本中解析 login / username / token / 过期时间"""
    creds = {}
    for key, pattern in _API_PAGE_RE.items():
        m = pattern.search(pre_text or "")
        creds[key] = m.group(1).strip() if m else ""
    return creds


def _creds_revealed(creds: dict) -> bool:
    return bool(creds.get("login")) and bool(creds.get("token")) \
        and "LOGIN_TO_REVEAL" not in (creds["login"], creds["token"])


def _load_cached_creds():
    if not os.path.exists(AUTH_STATE_PATH):
        return None
    try:
        with open(AUTH_STATE_PATH, "r", encoding="utf-8") as f:
            data = json.load(f)
        return data if _creds_revealed(data) else None
    except Exception:
        return None


def _save_creds(creds: dict):
    os.makedirs(os.path.dirname(AUTH_STATE_PATH), exist_ok=True)
    creds = dict(creds)
    creds["saved_at"] = time.strftime("%Y-%m-%d %H:%M:%S")
    with open(AUTH_STATE_PATH, "w", encoding="utf-8") as f:
        json.dump(creds, f, ensure_ascii=False, indent=2)


def _creds_alive(creds: dict) -> bool:
    """调用 /api_3/auth-check 确认 token 仍有效"""
    try:
        resp = requests.get(
            f"{BASE_URL}/api_3/auth-check",
            auth=(creds["login"], creds["token"]),
            timeout=TIMEOUT, verify=VERIFY_SSL,
        )
        return resp.status_code == 200
    except requests.RequestException:
        return False


# ---- 滑块检测（迁移自 etherpad 参考实现）----
SLIDER_SELECTORS = [
    ".verifybox", ".verify-img-panel",           # AJ-Captcha（oneid 实测组件）
    ".slider-container", ".slide-verify", ".verify-slider", ".captcha-slider",
    "[class*='slide-block']", "[class*='sliderContainer']", "[class*='drag-verify']",
    "[class*='puzzle']", "[class*='jigsaw']",
    ".captcha", "#captcha", "[class*='captcha-modal']", "[class*='captcha-wrap']",
    "img[src*='captcha']", "iframe[src*='captcha']",
    ".geetest_challenge", ".geetest_panel", "[class*='geetest']",
    ".nc-container", "[id*='nc_1_n1z']", "[class*='nc_scale']",
    "[class*='tcaptcha']", "#tcaptcha_iframe", "[class*='TCaptcha']",
    "[class*='vaptcha']",
]
SLIDER_TEXT_HINTS = [
    "拖动滑块", "拖动下方滑块", "按住滑块", "拖动下方图片",
    "向右滑动", "滑动验证", "拖动完成拼图", "完成拼图",
]


def detect_slider(page):
    """检测页面上是否出现滑块 / 图形验证，返回命中描述或 None"""
    for selector in SLIDER_SELECTORS:
        try:
            loc = page.locator(selector).first
            if loc.count() > 0 and loc.is_visible():
                return f"选择器 {selector}"
        except Exception:
            continue
    for hint in SLIDER_TEXT_HINTS:
        try:
            loc = page.locator(f"text={hint}").first
            if loc.count() > 0 and loc.is_visible():
                return f"文案「{hint}」"
        except Exception:
            continue
    return None


def await_slider_cleared(page, stage: str) -> bool:
    """
    检测滑块；出现则先尝试 slider_solver 自动破解，失败后**提醒操作人手动完成**并轮询等待。
    :return: True 表示出现过滑块且已处理；False 表示本次未出现
    """
    hit = detect_slider(page)
    if not hit:
        return False
    print(f"   [滑块] 「{stage}」环节检测到滑块验证（{hit}）")

    if SLIDER_AUTO:
        try:
            if solve_slider(page, max_attempts=SLIDER_AUTO_ATTEMPTS):
                page.wait_for_timeout(1500)
                if detect_slider(page) is None:
                    return True
                print("   [滑块] 破解后仍检测到滑块，回落人工处理")
        except Exception as exc:
            print(f"   [滑块] 自动破解模块异常，回落人工处理：{type(exc).__name__}: {exc}")

    shot = f"debug_slider_{stage}.png"
    try:
        page.screenshot(path=shot, full_page=True)
    except Exception:
        shot = "(截图失败)"

    if SLIDER_WAIT <= 0:
        pytest.fail(f"[FAIL] 「{stage}」环节出现滑块验证（{hit}），无人值守模式下直接失败。截图: {shot}")

    print("\a")
    print("\n" + "!" * 68)
    print(f"   [滑块] 「{stage}」环节检测到滑块/图形验证（{hit}）")
    print("   阿蓁，请在弹出的浏览器窗口中【手动拖动滑块完成验证】。")
    print(f"   完成后脚本会自动继续，最长等待 {SLIDER_WAIT} 秒。当前页面: {page.url}")
    print("!" * 68 + "\n")

    deadline = time.time() + SLIDER_WAIT
    last_tick = 0
    while time.time() < deadline:
        page.wait_for_timeout(2000)
        if detect_slider(page) is None:
            print("   [滑块] 验证已通过，继续执行\n")
            page.wait_for_timeout(1500)
            return True
        remaining = int(deadline - time.time())
        if remaining // 20 != last_tick:
            last_tick = remaining // 20
            print(f"   [滑块] 仍在等待人工完成验证（剩余 {remaining}s）...")

    pytest.fail(f"[FAIL] 「{stage}」环节等待人工完成滑块验证超时（{SLIDER_WAIT}s）")


def _first_visible(page, selector: str):
    try:
        loc = page.locator(selector).first
        if loc.count() > 0 and loc.is_visible():
            return loc
    except Exception:
        pass
    return None


def handle_mfa_challenge(page) -> bool:
    """
    处理登录后的双重验证（邮箱 / 手机验证码）。
    兼容 oneid 的 .mfa-dialog 结构，以及泛化的「验证码输入框 + 获取验证码」结构。
    :return: True 表示处理了验证码；False 表示未触发
    """
    dialog = _first_visible(page, ".mfa-dialog")
    code_input = _first_visible(page, "#codeInput input") or \
        _first_visible(page, "input[placeholder*='验证码']") or \
        _first_visible(page, "input[maxlength='6']")
    if dialog is None and code_input is None:
        # 再等一会，弹窗可能延迟渲染
        try:
            page.locator(".mfa-dialog, #codeInput input, input[placeholder*='验证码']").first \
                .wait_for(state="visible", timeout=6000)
        except Exception:
            print("   [MFA] 未出现验证码环节（免验证期）")
            return False
        dialog = _first_visible(page, ".mfa-dialog")
        code_input = _first_visible(page, "#codeInput input") or \
            _first_visible(page, "input[placeholder*='验证码']") or \
            _first_visible(page, "input[maxlength='6']")

    print("   [MFA] 检测到验证码环节，开始自动处理...")

    # 1. 切换到邮箱验证（若当前为手机）
    switch_link = _first_visible(page, ".mfa-switch a")
    if switch_link is not None and "邮箱" in (switch_link.inner_text() or ""):
        print("   [MFA] 切换为邮箱验证")
        switch_link.click()
        page.wait_for_timeout(2000)

    # 2. 点击获取验证码
    send_link = _first_visible(page, "#codeInput a") or \
        _first_visible(page, "a:has-text('获取验证码')") or \
        _first_visible(page, "button:has-text('获取验证码')") or \
        _first_visible(page, "span:has-text('获取验证码')")
    if send_link is None:
        page.screenshot(path="debug_mfa_no_send.png")
        pytest.fail("[FAIL] 验证码环节未找到「获取验证码」入口，截图: debug_mfa_no_send.png")
    send_link.click()
    print("   [MFA] 已点击「获取验证码」")
    page.wait_for_timeout(2500)

    # 获取验证码后可能弹滑块，通过后才真正发信 → 收信起点取滑块通过之后
    if await_slider_cleared(page, "获取验证码"):
        page.wait_for_timeout(2000)
    request_ts = time.time()

    # 3. IMAP 取码，失败回落人工
    code = None
    try:
        code = fetch_verification_code(since_ts=request_ts, timeout=MAIL_CODE_TIMEOUT)
    except MailCodeError as exc:
        if not MFA_MANUAL_FALLBACK:
            page.screenshot(path="debug_mfa_mail_failed.png")
            pytest.fail(f"{exc}\n   截图: debug_mfa_mail_failed.png")
        print("\a")
        print("\n" + "=" * 64)
        print(f"   [MFA] 邮箱自动取码不可用：{exc}")
        print("   阿蓁，请在弹出的浏览器窗口中【手动输入验证码并点击确认】，")
        print(f"   脚本最多等待 {MFA_MANUAL_WAIT} 秒。")
        print("=" * 64 + "\n")
        deadline = time.time() + MFA_MANUAL_WAIT
        while time.time() < deadline:
            if not on_sso_page(page):
                print("   [MFA] 已跳离认证域，人工验证完成")
                page.wait_for_timeout(3000)
                return True
            page.wait_for_timeout(2000)
        pytest.fail(f"[FAIL] 人工验证等待超时（{MFA_MANUAL_WAIT}s）")

    code_input = _first_visible(page, "#codeInput input") or \
        _first_visible(page, "input[placeholder*='验证码']") or \
        _first_visible(page, "input[maxlength='6']")
    assert code_input is not None, "取到验证码但未找到输入框"
    code_input.fill(code)
    page.wait_for_timeout(800)

    # 4. 确认
    confirm_btn = _first_visible(page, ".mfa-footer button") or \
        _first_visible(page, "button:has-text('确认')") or \
        _first_visible(page, "button:has-text('确定')") or \
        _first_visible(page, "button.login-btn")
    if confirm_btn is not None:
        for _ in range(10):
            if "o-btn-disabled" not in (confirm_btn.get_attribute("class") or ""):
                break
            page.wait_for_timeout(500)
        confirm_btn.click()
    else:
        code_input.press("Enter")
    print("   [MFA] 已提交验证码，等待跳转...")
    page.wait_for_timeout(5000)
    return True


def handle_privacy_dialog(page, timeout_sec: int = 15) -> bool:
    """
    处理「openEuler服务隐私声明变更」弹窗（实测 2026-09-10 出现在验证码通过之后）。

    弹窗结构：标题含「隐私声明」，正文为可滚动区域，「我已阅读并同意」按钮初始为
    禁用态，须把正文滚动到底部后才会激活。这里循环把所有可滚动容器滚到底，
    再点击同意按钮。
    :return: True 表示出现并处理了弹窗；False 表示未出现
    """
    title = _first_visible(page, "text=隐私声明变更")
    agree_btn = _first_visible(page, "button:has-text('我已阅读并同意')")
    if title is None and agree_btn is None:
        return False

    print("   [隐私声明] 检测到隐私声明变更弹窗，滚动正文并点击「我已阅读并同意」")
    deadline = time.time() + timeout_sec
    while time.time() < deadline:
        # 把弹窗内所有可滚动容器滚动到底部（触发按钮激活）
        page.evaluate("""() => {
            for (const el of document.querySelectorAll('*')) {
                const st = getComputedStyle(el);
                if ((st.overflowY === 'auto' || st.overflowY === 'scroll')
                        && el.scrollHeight > el.clientHeight + 5) {
                    el.scrollTop = el.scrollHeight;
                    el.dispatchEvent(new Event('scroll', {bubbles: true}));
                }
            }
        }""")
        page.wait_for_timeout(800)

        agree_btn = _first_visible(page, "button:has-text('我已阅读并同意')")
        if agree_btn is None:
            print("   [隐私声明] 弹窗已关闭")
            return True
        cls = agree_btn.get_attribute("class") or ""
        disabled = agree_btn.get_attribute("disabled")
        if "disabled" not in cls and disabled is None:
            agree_btn.click()
            print("   [隐私声明] 已点击「我已阅读并同意」")
            page.wait_for_timeout(3000)
            return True

    # 兜底：按钮一直未激活，尝试强制点击
    try:
        agree_btn = _first_visible(page, "button:has-text('我已阅读并同意')")
        if agree_btn is not None:
            agree_btn.click(force=True)
            page.wait_for_timeout(3000)
            print("   [隐私声明] 已强制点击「我已阅读并同意」")
            return True
    except Exception as exc:
        print(f"   [隐私声明] 点击失败：{exc}")
    page.screenshot(path="debug_privacy_dialog.png")
    print("\a")
    print("\n" + "=" * 64)
    print("   [隐私声明] 自动处理失败。阿蓁，请在浏览器中手动滚动到底部并点击「我已阅读并同意」。")
    print("=" * 64 + "\n")
    return True


def perform_login(page):
    """
    从 EUR 的 /oidc_login/ 入口出发，完成 openEuler ID 统一认证登录。
    登录成功后 URL 应回到 EUR 业务域。
    """
    print(f"   正在访问登录入口: {OIDC_LOGIN_URL}")
    page.goto(OIDC_LOGIN_URL, wait_until="domcontentloaded", timeout=60000)
    page.wait_for_timeout(4000)

    if not on_sso_page(page):
        print(f"   已处于登录态，直接跳转至: {page.url}")
        return

    # 确保处于「账号登录」Tab
    tab = _first_visible(page, ".login-tabs .tab:has-text('账号登录')")
    if tab is not None and "selected" not in (tab.get_attribute("class") or ""):
        tab.click()
        page.wait_for_timeout(800)

    await_slider_cleared(page, "登录页")

    username_input = _first_visible(page, "input[type='text'].o_input-input") or \
        _first_visible(page, "input[type='text']") or \
        _first_visible(page, "input[placeholder*='请输入']")
    password_input = _first_visible(page, "input[type='password']")
    if username_input is None or password_input is None:
        page.screenshot(path="debug_login_page.png")
        pytest.fail("[FAIL] 未找到账号/密码输入框，请检查 debug_login_page.png")

    username_input.fill(USERNAME)
    password_input.fill(PASSWORD)
    page.wait_for_timeout(600)

    # 隐私/协议勾选框（若有且未勾选）
    try:
        cb = page.locator("input[type='checkbox']").first
        if cb.count() > 0 and cb.is_visible() and not cb.is_checked():
            cb.check()
    except Exception:
        pass

    login_btn = _first_visible(page, "button.login-btn") or \
        _first_visible(page, "button:has-text('登录')") or \
        _first_visible(page, "button[type='submit']")
    if login_btn is not None:
        for _ in range(10):
            if "o-btn-disabled" not in (login_btn.get_attribute("class") or ""):
                break
            page.wait_for_timeout(400)
        login_btn.click()
    else:
        password_input.press("Enter")
    print("   已提交账号密码")
    page.wait_for_timeout(4000)

    # 提交后可能先弹滑块，再进入验证码环节
    await_slider_cleared(page, "提交登录")
    handle_privacy_dialog(page)
    if on_sso_page(page):
        handle_mfa_challenge(page)
    await_slider_cleared(page, "登录收尾")
    handle_privacy_dialog(page)

    # 等待跳回业务域（期间若再弹隐私声明 / 滑块也一并处理）
    deadline = time.time() + 45
    while time.time() < deadline and on_sso_page(page):
        page.wait_for_timeout(1500)
        if handle_privacy_dialog(page) or await_slider_cleared(page, "登录等待"):
            deadline = time.time() + 30

    if on_sso_page(page):
        page.screenshot(path="debug_login_stuck.png")
        err = ""
        for sel in (".o-message", ".el-message", "[class*='error']", "[class*='tip']"):
            loc = _first_visible(page, sel)
            if loc is not None:
                err = loc.inner_text().strip()
                break
        pytest.fail(
            f"[FAIL] 登录未完成，仍停留在统一认证页面: {page.url}\n"
            f"   页面提示: {err or '(无)'}\n   截图: debug_login_stuck.png"
        )
    print(f"   登录成功，当前页面: {page.url}")


def fetch_api_token_from_page(page) -> dict:
    """访问 /api/ 页面，解析 <pre> 块中的 login / username / token"""
    page.goto(API_TOKEN_PAGE, wait_until="domcontentloaded", timeout=60000)
    page.wait_for_timeout(2000)
    pre = page.locator("pre").first
    if pre.count() == 0:
        page.screenshot(path="debug_api_page.png")
        pytest.fail("[FAIL] /api/ 页面未找到 <pre> 配置块，截图: debug_api_page.png")
    creds = _parse_api_page(pre.inner_text())
    if not _creds_revealed(creds):
        page.screenshot(path="debug_api_page.png")
        pytest.fail(
            "[FAIL] /api/ 页面仍显示 LOGIN_TO_REVEAL，登录态未生效。截图: debug_api_page.png"
        )
    return creds


def obtain_api_token_via_browser() -> dict:
    """拉起浏览器完成前端登录，返回 API 凭证字典"""
    if not USERNAME or not PASSWORD:
        pytest.fail(
            "[FAIL] 未配置 TEST_ACCOUNT / TEST_PASSWORD，无法通过前端登录获取 API token。\n"
            "   请在 .env 中填写，或直接配置 EUR_API_LOGIN / EUR_API_TOKEN。"
        )
    from playwright.sync_api import sync_playwright

    print("\n[AUTH] 缓存 token 不可用，拉起浏览器通过前端登录获取 API token...")
    with sync_playwright() as p:
        browser = p.chromium.launch(
            channel="msedge",
            headless=BROWSER_HEADLESS,
            slow_mo=120,
            args=["--no-sandbox", "--ignore-certificate-errors",
                  "--disable-blink-features=AutomationControlled", "--window-size=1600,900"],
        )
        context = browser.new_context(ignore_https_errors=True,
                                      viewport={"width": 1600, "height": 900})
        context.set_default_timeout(DEFAULT_TIMEOUT)
        page = context.new_page()
        try:
            perform_login(page)
            creds = fetch_api_token_from_page(page)
        finally:
            context.close()
            browser.close()

    _save_creds(creds)
    print(f"[AUTH] 已获取 API token：username={creds['username']} "
          f"login={creds['login']} 过期={creds.get('expiration') or '未知'}，"
          f"已缓存至 {AUTH_STATE_PATH}")
    return creds


def get_api_credentials() -> dict:
    """凭证获取总入口：环境变量 → 磁盘缓存（验活）→ 浏览器登录"""
    if ENV_API_LOGIN and ENV_API_TOKEN:
        creds = {"login": ENV_API_LOGIN, "token": ENV_API_TOKEN,
                 "username": os.environ.get("EUR_TEST_OWNERNAME", ENV_API_LOGIN)}
        print("\n[AUTH] 使用环境变量中的 EUR_API_LOGIN / EUR_API_TOKEN")
        return creds

    cached = _load_cached_creds()
    if cached:
        if _creds_alive(cached):
            print(f"\n[AUTH] 复用缓存 token（username={cached.get('username')}，"
                  f"过期={cached.get('expiration')}）")
            return cached
        print("\n[AUTH] 缓存 token 已失效")

    return obtain_api_token_via_browser()


# =============================================================================
# requests 客户端
# =============================================================================
class ApiClient:
    """EUR API 客户端：统一 BasicAuth、超时、重试、日志"""

    def __init__(self, base_url: str, auth=None):
        self.base_url = base_url.rstrip("/")
        self.auth = auth
        self.session = requests.Session()
        self.session.headers.update({
            "Accept": "application/json",
            "User-Agent": "eur-api-automation/1.0",
        })
        retries = Retry(total=MAX_RETRIES, backoff_factor=1.0,
                        status_forcelist=[502, 503, 504],
                        allowed_methods=["HEAD", "GET", "OPTIONS"])
        adapter = HTTPAdapter(max_retries=retries)
        self.session.mount("https://", adapter)
        self.session.mount("http://", adapter)

    def request(self, method: str, path: str, **kwargs) -> requests.Response:
        url = f"{self.base_url}{path}"
        kwargs.setdefault("timeout", TIMEOUT)
        kwargs.setdefault("verify", VERIFY_SSL)
        if self.auth and "auth" not in kwargs:
            kwargs["auth"] = self.auth
        start = time.time()
        resp = self.session.request(method, url, **kwargs)
        elapsed = time.time() - start
        logger.info("[%s] %s -> %s (%.3fs)", method, url, resp.status_code, elapsed)
        print(f"   [{method}] {path} -> {resp.status_code} ({elapsed:.2f}s) "
              f"{resp.text[:160].replace(chr(10), ' ')}")
        return resp

    def get(self, path, **kw):
        return self.request("GET", path, **kw)

    def post(self, path, **kw):
        return self.request("POST", path, **kw)

    def put(self, path, **kw):
        return self.request("PUT", path, **kw)

    def delete(self, path, **kw):
        return self.request("DELETE", path, **kw)

    def close(self):
        self.session.close()


# =============================================================================
# 断言封装
# =============================================================================
def assert_status_code(response, expected: int):
    assert response.status_code == expected, (
        f"Expected {expected}, got {response.status_code}. Body: {response.text[:300]}"
    )


def assert_status_codes(response, expected):
    assert response.status_code in expected, (
        f"Expected one of {expected}, got {response.status_code}. Body: {response.text[:300]}"
    )


def assert_json_key_exists(response, key: str):
    data = response.json()
    assert key in data, f"Response JSON missing key '{key}'. Body: {str(data)[:300]}"


def assert_is_list_or_paginated(response):
    """Copr API v3 列表接口可能返回裸数组，也可能返回 {items: [...], meta: {...}}"""
    data = response.json()
    if isinstance(data, dict):
        assert "items" in data, f"Expected 'items' in paginated response. Body: {str(data)[:300]}"
        assert isinstance(data["items"], list)
    else:
        assert isinstance(data, list), f"Expected list response, got {type(data)}"


# =============================================================================
# Fixtures
# =============================================================================
@pytest.fixture(scope="session")
def credentials():
    """会话级 API 凭证（自动经缓存 / 前端登录获取）"""
    return get_api_credentials()


@pytest.fixture(scope="session")
def client(credentials):
    c = ApiClient(BASE_URL, auth=(credentials["login"], credentials["token"]))
    yield c
    c.close()


@pytest.fixture(scope="session")
def anon_client():
    """匿名客户端：用于验证未登录场景"""
    c = ApiClient(BASE_URL, auth=None)
    yield c
    c.close()


class ApiTestData:
    """测试数据容器"""

    def __init__(self, ownername):
        self.OWNERNAME = ownername
        self.PROJECTNAME = TEST_PROJECTNAME
        self.PACKAGENAME = TEST_PACKAGENAME
        self.BUILD_ID = TEST_BUILD_ID
        self.CHROOTNAME = TEST_CHROOTNAME
        self.GROUP_NAME = TEST_GROUP_NAME


@pytest.fixture(scope="session")
def td(credentials):
    """测试数据：ownername 缺省取登录用户名"""
    owner = os.environ.get("EUR_TEST_OWNERNAME") or credentials.get("username") or credentials["login"]
    return ApiTestData(owner)


# =============================================================================
# 用例：auth（1）
# =============================================================================
@pytest.mark.smoke
@pytest.mark.auth
class TestAuth:

    def test_auth_check(self, client):
        """认证检查：携带有效 token 应返回 200 且回显当前用户

        实测该 EUR 实例返回 {"id": 5, "name": "guoxiaozhen2"}；
        openapi.yaml 未定义该接口响应体，故按实际字段断言并兼容 username 写法。
        """
        response = client.get("/api_3/auth-check")
        assert_status_code(response, 200)
        data = response.json()
        assert "name" in data or "username" in data, \
            f"auth-check 未回显用户名字段。Body: {str(data)[:300]}"
        assert data.get("name") or data.get("username"), "用户名字段为空"

    def test_auth_check_without_token(self, anon_client):
        """认证检查：未携带 token 应返回 401"""
        response = anon_client.get("/api_3/auth-check")
        assert_status_code(response, 401)


# =============================================================================
# 用例：build（16）
# =============================================================================
@pytest.mark.build
class TestBuild:

    @pytest.mark.smoke
    def test_get_build_detail(self, client, td):
        """查询构建详情"""
        response = client.get(f"/api_3/build/{td.BUILD_ID}")
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_json_key_exists(response, "id")

    def test_get_build_built_packages(self, client, td):
        """获取构建已产出包列表"""
        response = client.get(f"/api_3/build/built-packages/{td.BUILD_ID}/")
        assert_status_codes(response, [200, 404])

    def test_cancel_build(self, client, td):
        """取消构建"""
        response = client.put(f"/api_3/build/cancel/{td.BUILD_ID}")
        assert_status_codes(response, [200, 400, 403, 404])

    def test_check_before_build(self, client, td):
        """提交构建前预检"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME]}
        response = client.post("/api_3/build/check-before-build", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_custom(self, client, td):
        """通过自定义脚本提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME], "script": "echo 'hello world'"}
        response = client.post("/api_3/build/create/custom", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_distgit(self, client, td):
        """通过 dist-git 提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME], "distgit": "fedora", "package_name": td.PACKAGENAME}
        response = client.post("/api_3/build/create/distgit", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_pypi(self, client, td):
        """通过 PyPI 提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME], "pypi_package_name": "requests"}
        response = client.post("/api_3/build/create/pypi", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_rubygems(self, client, td):
        """通过 RubyGems 提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME], "gem_name": "rails"}
        response = client.post("/api_3/build/create/rubygems", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_scm(self, client, td):
        """通过 SCM 提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME],
                   "clone_url": "https://gitee.com/openeuler/hello-world.git",
                   "committish": "master"}
        response = client.post("/api_3/build/create/scm", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_upload(self, client, td):
        """通过上传 SRPM 提交构建（multipart）"""
        srpm_path = os.environ.get("EUR_TEST_SRPM", "")
        if not srpm_path or not os.path.exists(srpm_path):
            pytest.skip("未配置 EUR_TEST_SRPM 或文件不存在，跳过上传构建用例")
        with open(srpm_path, "rb") as f:
            response = client.post(
                "/api_3/build/create/upload",
                data={"json": json.dumps({"ownername": td.OWNERNAME,
                                          "projectname": td.PROJECTNAME,
                                          "chroots": [td.CHROOTNAME]})},
                files={"pkgs": (os.path.basename(srpm_path), f)},
                headers={"Accept": "application/json"},
            )
        assert_status_codes(response, [200, 201, 400, 403, 404])

    @pytest.mark.slow
    def test_create_build_from_url(self, client, td):
        """通过 URL 提交构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME], "pkgs": "https://example.com/test.src.rpm"}
        response = client.post("/api_3/build/create/url", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    def test_delete_build_list(self, client, td):
        """批量删除构建"""
        response = client.post("/api_3/build/delete/list", json={"builds": [td.BUILD_ID]})
        assert_status_codes(response, [200, 400, 403, 404])

    def test_delete_build(self, client, td):
        """删除单个构建"""
        response = client.delete(f"/api_3/build/delete/{td.BUILD_ID}")
        assert_status_codes(response, [200, 400, 403, 404])

    @pytest.mark.smoke
    def test_list_builds(self, client, td):
        """列出构建（按 ownername + projectname 过滤）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/build/list/", params=params)
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_is_list_or_paginated(response)

    def test_get_source_build_config(self, client, td):
        """获取源码构建配置"""
        response = client.get(f"/api_3/build/source-build-config/{td.BUILD_ID}/")
        assert_status_codes(response, [200, 404])

    def test_get_source_chroot(self, client, td):
        """获取源码 chroot 信息"""
        response = client.get(f"/api_3/build/source-chroot/{td.BUILD_ID}/")
        assert_status_codes(response, [200, 404])


# =============================================================================
# 用例：build-chroot（7）
# =============================================================================
@pytest.mark.chroot
class TestBuildChroot:

    @pytest.mark.smoke
    def test_get_build_chroot(self, client, td):
        """查询构建 chroot 详情（query 参数）"""
        params = {"build_id": td.BUILD_ID, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/", params=params)
        assert_status_codes(response, [200, 404])

    def test_get_build_chroot_build_config(self, client, td):
        """查询构建 chroot 构建配置（query 参数）"""
        params = {"build_id": td.BUILD_ID, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/build-config", params=params)
        assert_status_codes(response, [200, 404])

    def test_get_build_chroot_build_config_by_path(self, client, td):
        """查询构建 chroot 构建配置（路径参数）"""
        response = client.get(f"/api_3/build-chroot/build-config/{td.BUILD_ID}/{td.CHROOTNAME}")
        assert_status_codes(response, [200, 404])

    def test_get_build_chroot_built_packages(self, client, td):
        """获取构建 chroot 已产出包列表"""
        params = {"build_id": td.BUILD_ID, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/built-packages/", params=params)
        assert_status_codes(response, [200, 404])

    @pytest.mark.smoke
    def test_list_build_chroots(self, client, td):
        """列出构建 chroot（query 参数）"""
        response = client.get("/api_3/build-chroot/list", params={"build_id": td.BUILD_ID})
        assert_status_codes(response, [200, 404])

    def test_list_build_chroots_by_build_id(self, client, td):
        """按构建 ID 列出 chroot（路径参数）"""
        response = client.get(f"/api_3/build-chroot/list/{td.BUILD_ID}")
        assert_status_codes(response, [200, 404])

    def test_get_build_chroot_by_path(self, client, td):
        """查询构建 chroot 详情（路径参数）"""
        response = client.get(f"/api_3/build-chroot/{td.BUILD_ID}/{td.CHROOTNAME}")
        assert_status_codes(response, [200, 404])


# =============================================================================
# 用例：mock-chroot（1）
# =============================================================================
@pytest.mark.smoke
@pytest.mark.chroot
class TestMockChroot:

    def test_list_mock_chroots(self, client):
        """列出所有可用 Mock Chroot"""
        response = client.get("/api_3/mock-chroots/list")
        assert_status_code(response, 200)
        data = response.json()
        assert isinstance(data, (list, dict)) and len(data) > 0, "mock chroot 列表不应为空"


# =============================================================================
# 用例：module（1）
# =============================================================================
@pytest.mark.module
class TestModule:

    def test_build_module(self, client, td):
        """提交模块构建"""
        payload = {"modulemd": "---\ndocument: modulemd\nversion: 2\n"}
        response = client.post(f"/api_3/module/build/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])


# =============================================================================
# 用例：monitor（1）
# =============================================================================
@pytest.mark.smoke
@pytest.mark.monitor
class TestMonitor:

    def test_get_monitor(self, client, td):
        """获取项目监控数据"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/monitor", params=params)
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_json_key_exists(response, "packages")


# =============================================================================
# 用例：package（8）
# =============================================================================
@pytest.mark.package
class TestPackage:

    @pytest.mark.smoke
    def test_get_package(self, client, td):
        """查询包详情"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "packagename": td.PACKAGENAME}
        response = client.get("/api_3/package/", params=params)
        assert_status_codes(response, [200, 404])

    def test_add_package(self, client, td):
        """添加包（scm 来源）"""
        payload = {"clone_url": "https://gitee.com/openeuler/hello-world.git",
                   "committish": "master", "scm_type": "git", "source_build_method": "rpkg"}
        response = client.post(
            f"/api_3/package/add/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/scm",
            json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404, 409])

    def test_edit_package(self, client, td):
        """编辑包（通用入口）"""
        payload = {"clone_url": "https://gitee.com/openeuler/hello-world.git", "committish": "dev"}
        response = client.post(
            f"/api_3/package/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/",
            json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    def test_edit_package_with_source_type(self, client, td):
        """编辑包（指定来源类型）"""
        payload = {"clone_url": "https://gitee.com/openeuler/hello-world.git", "committish": "dev"}
        response = client.post(
            f"/api_3/package/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/scm",
            json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    def test_build_package(self, client, td):
        """触发包构建"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME, "chroots": [td.CHROOTNAME]}
        response = client.post("/api_3/package/build", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 404])

    def test_delete_package(self, client, td):
        """删除包"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME}
        response = client.delete("/api_3/package/delete", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    @pytest.mark.smoke
    def test_list_packages(self, client, td):
        """列出包"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/package/list", params=params)
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_is_list_or_paginated(response)

    def test_reset_package(self, client, td):
        """重置包"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME}
        response = client.put("/api_3/package/reset", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])


# =============================================================================
# 用例：project（8）
# =============================================================================
@pytest.mark.project
class TestProject:

    @pytest.mark.smoke
    def test_get_project(self, client, td):
        """查询项目详情"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/project", params=params)
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_json_key_exists(response, "name")

    def test_create_project(self, client, td):
        """创建项目"""
        payload = {"name": td.PROJECTNAME, "description": "Auto-generated test project",
                   "chroots": [td.CHROOTNAME]}
        response = client.post(f"/api_3/project/add/{td.OWNERNAME}", json=payload)
        assert_status_codes(response, [200, 201, 400, 403, 409])

    def test_edit_project(self, client, td):
        """编辑项目设置"""
        payload = {"description": "Updated by API automation"}
        response = client.put(f"/api_3/project/edit/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    def test_fork_project(self, client, td):
        """Fork 项目"""
        payload = {"name": f"{td.PROJECTNAME}-fork", "ownername": td.OWNERNAME}
        response = client.put(f"/api_3/project/fork/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    @pytest.mark.smoke
    def test_list_projects(self, client, td):
        """列出项目"""
        response = client.get("/api_3/project/list", params={"ownername": td.OWNERNAME})
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert_is_list_or_paginated(response)

    def test_regenerate_project_repos(self, client, td):
        """重新生成项目仓库元数据"""
        response = client.put(f"/api_3/project/regenerate-repos/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 400, 403, 404])

    @pytest.mark.smoke
    def test_search_projects(self, client, td):
        """搜索项目"""
        response = client.get("/api_3/project/search", params={"query": td.PROJECTNAME})
        assert_status_code(response, 200)
        assert_is_list_or_paginated(response)

    def test_delete_project(self, client, td):
        """删除项目（放在本组最后执行，避免影响其它用例）"""
        response = client.delete(f"/api_3/project/delete/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 400, 403, 404])


# =============================================================================
# 用例：permission（4）
# =============================================================================
@pytest.mark.permission
class TestPermission:

    def test_can_build_in_project(self, client, td):
        """查询用户是否有项目构建权限"""
        response = client.get(
            f"/api_3/project/permissions/can_build_in/{td.OWNERNAME}/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 404])

    def test_get_project_permissions(self, client, td):
        """获取项目权限"""
        response = client.get(f"/api_3/project/permissions/get/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 400, 403, 404])

    def test_request_project_permissions(self, client, td):
        """申请项目权限"""
        payload = {"builder": True, "admin": False}
        response = client.put(
            f"/api_3/project/permissions/request/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])

    def test_set_project_permissions(self, client, td):
        """设置项目权限"""
        payload = {td.OWNERNAME: {"builder": "approved"}}
        response = client.put(
            f"/api_3/project/permissions/set/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400, 403, 404])


# =============================================================================
# 用例：project-chroot（3）
# =============================================================================
@pytest.mark.chroot
class TestProjectChroot:

    @pytest.mark.smoke
    def test_get_project_chroot(self, client, td):
        """查询项目 chroot 配置"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/project-chroot/", params=params)
        assert_status_codes(response, [200, 404])

    def test_get_project_chroot_build_config(self, client, td):
        """查询项目 chroot 构建配置"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/project-chroot/build-config", params=params)
        assert_status_codes(response, [200, 404])

    def test_edit_project_chroot(self, client, td):
        """编辑项目 chroot 配置"""
        payload = {"additional_repos": [], "additional_packages": []}
        response = client.put(
            f"/api_3/project-chroot/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.CHROOTNAME}",
            json=payload)
        assert_status_codes(response, [200, 400, 403, 404])


# =============================================================================
# 用例：rpmrepo（1）
# =============================================================================
@pytest.mark.smoke
@pytest.mark.rpmrepo
class TestRpmRepo:

    def test_get_rpmrepo(self, client, td):
        """获取 RPM 仓库配置"""
        # name_release 形如 openeuler-24.03_LTS（chroot 名去掉架构后缀）
        name_release = td.CHROOTNAME.rsplit("-", 1)[0]
        response = client.get(f"/api_3/rpmrepo/{td.OWNERNAME}/{td.PROJECTNAME}/{name_release}/")
        assert_status_codes(response, [200, 404])


# =============================================================================
# 用例：webhook（1）
# =============================================================================
@pytest.mark.webhook
class TestWebhook:

    def test_generate_webhook(self, client, td):
        """生成项目 webhook secret"""
        response = client.post(f"/api_3/webhook/generate/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 400, 403, 404])


# =============================================================================
# 用例：openeuler-pkg  EUR 自定义接口（3）
# =============================================================================
@pytest.mark.openeuler
class TestOpenEulerPkg:

    def test_add_openeuler_pkg_group(self, client, td):
        """组项目：包贡献跳转"""
        response = client.get(
            f"/coprs/g/{td.GROUP_NAME}/{td.PROJECTNAME}/package/{td.PACKAGENAME}/add_openeuler_pkg",
            allow_redirects=False)
        assert_status_codes(response, [200, 302, 403, 404])

    def test_add_openeuler_pkg_user(self, client, td):
        """用户项目：包贡献跳转"""
        response = client.get(
            f"/coprs/{td.OWNERNAME}/{td.PROJECTNAME}/package/{td.PACKAGENAME}/add_openeuler_pkg",
            allow_redirects=False)
        assert_status_codes(response, [200, 302, 403, 404])

    @pytest.mark.smoke
    def test_packages_statistics(self, client):
        """全站包统计"""
        response = client.get("/coprs/packages_statistics")
        assert_status_code(response, 200)
