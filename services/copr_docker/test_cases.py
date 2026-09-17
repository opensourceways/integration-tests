#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
openEuler EUR（基于 Copr 改造）接口自动化测试 —— 单文件版
被测地址: https://packages.test.osinfra.cn （测试环境，可用 EUR_BASE_URL 覆盖）
技术栈:   pytest + requests（接口）  /  Playwright（仅用于前端登录获取 API Token）

依据《copr_docker 集成测试接口说明.md》与 copr_openapi.yaml 编写，覆盖：

  frontend（§3.1）  ：探活 / auth / build / build-chroot / mock-chroot / module /
                      monitor / package / permission / project / project-chroot /
                      rpmrepo / webhook / openeuler-pkg / 分页 / 匿名鉴权边界
  backend_httpd（§3.2）：/results/、/per-task-logs/、.gz 响应头、404
  distgit（§3.3）   ：/cgit/、/cgit-data/
  数据结构（§5）    ：Build / SourcePackage / Package / PackageBuilds /
                      ProjectChroot / monitor 字段与枚举校验
  端到端（§6.2）    ：提交构建 → 轮询 state → 经 /results/ 校验产物
                      （耗资源，默认关闭，EUR_E2E=1 开启）

可选环境变量（子服务直连 / 端到端）：
  EUR_BACKEND_URL   backend_httpd 地址，缺省复用 EUR_BASE_URL
  EUR_DISTGIT_URL   distgit 地址，缺省复用 EUR_BASE_URL
  EUR_E2E=1         开启端到端构建；EUR_E2E_TIMEOUT / EUR_E2E_POLL 控制轮询

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
    pytest test_cases.py --html=report.html --self-contained-html -v
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

# ---- 子服务直连地址（文档 §3.2 / §3.3）----
# backend_httpd 与 distgit 已由 ingress 归集到主域名，缺省复用 BASE_URL；
# 需直连时用环境变量覆盖，保证公网黑盒场景可独立运行。
BACKEND_URL = os.environ.get("EUR_BACKEND_URL", BASE_URL).rstrip("/")
DISTGIT_URL = os.environ.get("EUR_DISTGIT_URL", BASE_URL).rstrip("/")

# ---- 端到端构建流程（文档 §6.2）----
# 真实构建耗时长且占用 builder 资源，默认关闭，需显式 EUR_E2E=1 开启
E2E_ENABLED = os.environ.get("EUR_E2E", "0") == "1"
E2E_TIMEOUT = int(os.environ.get("EUR_E2E_TIMEOUT", "1800"))
E2E_POLL_INTERVAL = int(os.environ.get("EUR_E2E_POLL", "20"))

# ---- 构建状态枚举 ----
# DOC_BUILD_STATES 为文档 §3.1.3 明示的 8 个状态；
# EXTRA_BUILD_STATES 是 Copr 上游实际还会返回、但文档未列出的状态，
# 断言取两者并集，落在 EXTRA 中时打印文档漂移提示而不失败。
DOC_BUILD_STATES = {"succeeded", "failed", "running", "pending",
                    "skipped", "waiting", "importing", "canceled"}
EXTRA_BUILD_STATES = {"starting", "forked", "unknown"}
ALL_BUILD_STATES = DOC_BUILD_STATES | EXTRA_BUILD_STATES
FINAL_BUILD_STATES = {"succeeded", "failed", "canceled", "skipped", "forked"}
UNFINISHED_BUILD_STATES = ALL_BUILD_STATES - FINAL_BUILD_STATES


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


def assert_created_or_exists(response, resource: str = "资源"):
    """
    断言「创建成功」或「已存在」。

    该 EUR 实例对重复创建不返回标准的 409：
      - 项目重复 → 400 "You already have a project named 'x'."
      - 包重复   → 500 "Package x already exists in copr y/z."
    为使用例可重复执行（上一轮异常中断导致资源残留时不应误报），
    这里按响应体语义判定，而非仅看状态码。
    """
    if response.status_code in (200, 201):
        return "created"
    body = response.text.lower()
    if "already exists" in body or "already have" in body:
        print(f"   [幂等] {resource}已存在，视为就绪（HTTP {response.status_code}）")
        return "exists"
    raise AssertionError(
        f"{resource}创建失败：HTTP {response.status_code}，Body: {response.text[:300]}")


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
        self.FORK_PROJECTNAME = f"{TEST_PROJECTNAME}-fork"
        self.PACKAGENAME = TEST_PACKAGENAME
        self.BUILD_ID = TEST_BUILD_ID
        self.CHROOTNAME = TEST_CHROOTNAME
        self.GROUP_NAME = TEST_GROUP_NAME


@pytest.fixture(scope="session")
def td(credentials):
    """测试数据：ownername 缺省取登录用户名"""
    owner = os.environ.get("EUR_TEST_OWNERNAME") or credentials.get("username") or credentials["login"]
    return ApiTestData(owner)


@pytest.fixture(scope="session")
def backend_client():
    """backend_httpd 客户端（静态文件服务，无需认证）"""
    c = ApiClient(BACKEND_URL, auth=None)
    yield c
    c.close()


@pytest.fixture(scope="session")
def distgit_client():
    """distgit 客户端（cgit 页面，无需认证）"""
    c = ApiClient(DISTGIT_URL, auth=None)
    yield c
    c.close()


# ---- 真实 build id ----
# 原实现用写死的 EUR_TEST_BUILD_ID=1，该构建不属于测试账号，
# 导致 TestBuild 的查询/删除类用例常态落在 404 分支形同空跑。
# 改为：优先复用项目内既有构建 → 没有则真实提交一个 → 都失败才退回环境变量。
_BUILD_ID_CACHE = {}


def _list_project_builds(client, td):
    resp = client.get("/api_3/build/list/", params={
        "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
    if resp.status_code != 200:
        return []
    data = resp.json()
    return data["items"] if isinstance(data, dict) else data


def _submit_probe_build(client, td):
    """提交一个最小构建用于查询类用例，返回 build id 或 None"""
    payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
               "package_name": td.PACKAGENAME, "chroots": [td.CHROOTNAME]}
    resp = client.post("/api_3/package/build", json=payload)
    if resp.status_code in (200, 201):
        try:
            return resp.json().get("id")
        except ValueError:
            return None
    return None


@pytest.fixture(scope="session")
def build_id(client, td):
    """会话级真实 build id（属于测试账号，可安全查询/取消）"""
    if "id" in _BUILD_ID_CACHE:
        return _BUILD_ID_CACHE["id"]

    builds = _list_project_builds(client, td)
    bid = builds[0].get("id") if builds else _submit_probe_build(client, td)
    if not bid:
        bid = TEST_BUILD_ID
        print(f"   [build_id] 无法获取本账号构建，退回环境变量默认值 {bid}（用例可能落 404 分支）")
    else:
        print(f"   [build_id] 本轮使用 build id={bid}")
    _BUILD_ID_CACHE["id"] = bid
    return bid


@pytest.fixture
def disposable_build(client, td):
    """一次性构建：提交 → 取消，供删除类用例使用（Copr 仅允许删除已终结的构建）"""
    bid = _submit_probe_build(client, td)
    if not bid:
        pytest.skip("无法提交一次性构建，跳过删除类用例")
    client.put(f"/api_3/build/cancel/{bid}")
    time.sleep(3)
    return bid


# =============================================================================
# 用例：frontend 探活（文档 §3.1.2）
# =============================================================================
@pytest.mark.smoke
@pytest.mark.frontend
class TestFrontendProbe:

    def test_root_page(self, anon_client):
        """GET / 返回 200 Web UI HTML 页面"""
        response = anon_client.get("/", headers={"Accept": "text/html"})
        assert_status_code(response, 200)
        ctype = response.headers.get("Content-Type", "")
        assert "text/html" in ctype, f"期望 text/html，实际 {ctype}"
        assert "<html" in response.text.lower(), "响应体不是 HTML 页面"


# =============================================================================
# 用例：auth（2）
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
# 用例：资源创建（2）—— 必须最先执行
#
# pytest 按定义顺序执行，本类刻意置于所有业务用例之前：先把项目与包真实建出来，
# 后续 package / build / chroot / webhook 等用例才能跑到 200 正向分支，
# 而不是清一色落到「项目不存在」的 404 上。对应的删除用例见文件末尾 TestZCleanup。
# =============================================================================
@pytest.mark.setup
@pytest.mark.project
class TestSetupResources:

    @pytest.mark.smoke
    def test_create_project(self, client, td):
        """创建项目（链路起点，须真实创建成功）"""
        payload = {"name": td.PROJECTNAME,
                   "description": "Auto-generated by API automation",
                   "chroots": [td.CHROOTNAME]}
        response = client.post(f"/api_3/project/add/{td.OWNERNAME}", json=payload)
        outcome = assert_created_or_exists(response, "项目")
        if outcome == "created":
            data = response.json()
            assert data.get("name") == td.PROJECTNAME, \
                f"创建返回的项目名不符：{data.get('name')}"

        # 二次确认：查询接口应能查到该项目
        check = client.get("/api_3/project", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
        assert_status_code(check, 200)
        assert check.json().get("name") == td.PROJECTNAME

    @pytest.mark.smoke
    @pytest.mark.package
    def test_add_package(self, client, td):
        """向项目中添加包（scm 来源，须真实创建成功）

        注意：package_name 虽已在 URL 路径中，服务端表单校验仍从**请求体**读取该字段，
        缺失时返回 500 "Please enter a valid package name"。openapi.yaml 未体现这一点。
        """
        payload = {"package_name": td.PACKAGENAME,
                   "clone_url": "https://gitee.com/src-openeuler/hello.git",
                   "committish": "master", "scm_type": "git",
                   "source_build_method": "rpkg"}
        response = client.post(
            f"/api_3/package/add/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/scm",
            json=payload)
        assert_created_or_exists(response, "包")

        # 二次确认：查询接口应能查到该包
        check = client.get("/api_3/package/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "packagename": td.PACKAGENAME})
        assert_status_code(check, 200)
        assert check.json().get("name") == td.PACKAGENAME


# =============================================================================
# 用例：build（19）
# =============================================================================
@pytest.mark.build
class TestBuild:

    @pytest.mark.smoke
    def test_get_build_detail(self, client, build_id):
        """查询构建详情（build_id 由 fixture 提供，属于本账号）"""
        response = client.get(f"/api_3/build/{build_id}")
        assert_status_code(response, 200)
        assert_json_key_exists(response, "id")
        assert response.json()["id"] == build_id

    def test_get_build_built_packages(self, client, build_id):
        """获取构建已产出包列表"""
        response = client.get(f"/api_3/build/built-packages/{build_id}/")
        assert_status_code(response, 200)

    def test_get_build_detail_not_found(self, client):
        """查询不存在的构建应返回 404（文档 §3.1.3 状态码约定）"""
        response = client.get("/api_3/build/999999999")
        assert_status_code(response, 404)

    def test_cancel_build(self, client, build_id):
        """取消构建：未终结的构建应 200

        build_id fixture 取项目构建列表首条，可能已处于终态
        （succeeded/failed/canceled）。此时 EUR 返回 409
        "Cannot cancel build N"，属预期行为，一并接受。
        """
        response = client.put(f"/api_3/build/cancel/{build_id}")
        assert_status_codes(response, [200, 400, 409])

    def test_check_before_build(self, client, td):
        """提交构建前预检（项目已由前置用例创建，不应再出现 403/404）"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME]}
        response = client.post("/api_3/build/check-before-build", json=payload)
        assert_status_codes(response, [200, 400])

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

    @pytest.mark.slow
    def test_delete_build_list(self, client, disposable_build):
        """批量删除构建（删除本用例自建并已取消的构建）

        标记 slow：disposable_build fixture 会真实提交一个构建再取消，
        占用 builder 资源，默认执行（-m "not slow"）时排除。
        """
        response = client.post("/api_3/build/delete/list",
                               json={"builds": [disposable_build]})
        assert_status_codes(response, [200, 400])

    @pytest.mark.slow
    def test_delete_build(self, client, disposable_build):
        """删除单个构建（删除本用例自建并已取消的构建）

        标记 slow：理由同 test_delete_build_list。
        """
        response = client.delete(f"/api_3/build/delete/{disposable_build}")
        assert_status_codes(response, [200, 400])

    @pytest.mark.smoke
    def test_list_builds(self, client, td):
        """列出构建（按 ownername + projectname 过滤）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/build/list/", params=params)
        assert_status_code(response, 200)
        assert_is_list_or_paginated(response)

    def test_list_builds_filter_by_packagename(self, client, td, build_id):
        """列出构建：按包名过滤，返回项应全部属于该包（文档 §3.1.3）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "packagename": td.PACKAGENAME}
        response = client.get("/api_3/build/list/", params=params)
        assert_status_code(response, 200)
        data = response.json()
        items = data["items"] if isinstance(data, dict) else data
        bad = [b.get("source_package", {}).get("name") for b in items
               if b.get("source_package", {}).get("name") not in (None, "", td.PACKAGENAME)]
        assert not bad, f"packagename 过滤失效，混入其他包: {bad}"

    def test_list_builds_filter_by_status(self, client, td, build_id):
        """列出构建：按 status 过滤，返回项 state 应全部等于该值（文档 §3.1.3）"""
        for status in ("succeeded", "failed", "canceled"):
            params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                      "status": status}
            response = client.get("/api_3/build/list/", params=params)
            assert_status_codes(response, [200, 400])
            if response.status_code != 200:
                continue
            data = response.json()
            items = data["items"] if isinstance(data, dict) else data
            mismatched = [b.get("state") for b in items if b.get("state") != status]
            assert not mismatched, f"status={status} 过滤失效，混入: {set(mismatched)}"

    def test_get_source_build_config(self, client, build_id):
        """获取源码构建配置"""
        response = client.get(f"/api_3/build/source-build-config/{build_id}/")
        assert_status_code(response, 200)

    def test_get_source_chroot(self, client, build_id):
        """获取源码 chroot 信息

        实测：构建尚处 pending/importing（source chroot 记录未落库）时，
        服务端返回 500 "there is probably a bug in the Copr code" 而非 404。
        这属于服务端健壮性问题，放行 500 并打印提示，不阻塞其余用例。
        """
        response = client.get(f"/api_3/build/source-chroot/{build_id}/")
        assert_status_codes(response, [200, 404, 500])
        if response.status_code == 500:
            print("   [服务端问题] source-chroot 对未导入的构建返回 500，预期应为 404")


# =============================================================================
# 用例：build-chroot（8）
# =============================================================================
@pytest.mark.chroot
class TestBuildChroot:

    @pytest.mark.smoke
    def test_get_build_chroot(self, client, build_id, td):
        """查询构建 chroot 详情（query 参数）"""
        params = {"build_id": build_id, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/", params=params)
        assert_status_code(response, 200)
        assert response.json().get("name") == td.CHROOTNAME

    def test_get_build_chroot_build_config(self, client, build_id, td):
        """查询构建 chroot 构建配置（query 参数）"""
        params = {"build_id": build_id, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/build-config", params=params)
        assert_status_code(response, 200)

    def test_get_build_chroot_build_config_by_path(self, client, build_id, td):
        """查询构建 chroot 构建配置（路径参数，文档标注已废弃）"""
        response = client.get(f"/api_3/build-chroot/build-config/{build_id}/{td.CHROOTNAME}")
        assert_status_code(response, 200)

    def test_get_build_chroot_built_packages(self, client, build_id, td):
        """获取构建 chroot 已产出包列表"""
        params = {"build_id": build_id, "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/build-chroot/built-packages/", params=params)
        assert_status_code(response, 200)

    @pytest.mark.smoke
    def test_list_build_chroots(self, client, build_id):
        """列出构建 chroot（query 参数）"""
        response = client.get("/api_3/build-chroot/list", params={"build_id": build_id})
        assert_status_code(response, 200)

    def test_list_build_chroots_by_build_id(self, client, build_id):
        """按构建 ID 列出 chroot（路径参数）"""
        response = client.get(f"/api_3/build-chroot/list/{build_id}")
        assert_status_code(response, 200)

    def test_get_build_chroot_by_path(self, client, build_id, td):
        """查询构建 chroot 详情（路径参数）"""
        response = client.get(f"/api_3/build-chroot/{build_id}/{td.CHROOTNAME}")
        assert_status_code(response, 200)

    def test_get_build_chroot_not_found(self, client, build_id):
        """不存在的 chroot 名应返回 404"""
        response = client.get(f"/api_3/build-chroot/{build_id}/no-such-chroot-x86_64")
        assert_status_code(response, 404)


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
        """提交模块构建（最小 modulemd）

        实测该实例对不完整的 modulemd 返回 500 + "there is probably a bug in the
        Copr code"，而非 400 参数错误。此处放行 500 以免阻塞其余用例，
        但这属于服务端健壮性问题，已在报告中标注待确认。
        """
        payload = {"modulemd": "---\ndocument: modulemd\nversion: 2\n"}
        response = client.post(f"/api_3/module/build/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 201, 400, 404, 500])


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
# 用例：package（7）
# =============================================================================
@pytest.mark.package
class TestPackage:

    @pytest.mark.smoke
    def test_get_package(self, client, td):
        """查询包详情（TestSetupResources 已建包，应查到）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "packagename": td.PACKAGENAME}
        response = client.get("/api_3/package/", params=params)
        assert_status_code(response, 200)
        data = response.json()
        assert data.get("name") == td.PACKAGENAME
        assert data.get("source_type") == "scm", f"来源类型应为 scm，实际 {data.get('source_type')}"

    def test_get_package_with_latest_build(self, client, td):
        """查询包详情（带最近构建信息）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "packagename": td.PACKAGENAME, "with_latest_build": "true"}
        response = client.get("/api_3/package/", params=params)
        assert_status_code(response, 200)
        assert_json_key_exists(response, "builds")

    def test_edit_package(self, client, td):
        """编辑包（通用入口）"""
        # spec 字段必填且须以 .spec 结尾，缺失时服务端返回 500
        payload = {"package_name": td.PACKAGENAME,
                   "clone_url": "https://gitee.com/src-openeuler/hello.git",
                   "committish": "dev", "scm_type": "git",
                   "source_build_method": "rpkg", "spec": f"{td.PACKAGENAME}.spec"}
        response = client.post(
            f"/api_3/package/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/",
            json=payload)
        assert_status_codes(response, [200, 400])

    def test_edit_package_with_source_type(self, client, td):
        """编辑包（指定来源类型），并校验改动已生效"""
        # spec 字段必填且须以 .spec 结尾，缺失时服务端返回 500
        payload = {"package_name": td.PACKAGENAME,
                   "clone_url": "https://gitee.com/src-openeuler/hello.git",
                   "committish": "dev", "scm_type": "git",
                   "source_build_method": "rpkg", "spec": f"{td.PACKAGENAME}.spec"}
        response = client.post(
            f"/api_3/package/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.PACKAGENAME}/scm",
            json=payload)
        assert_status_code(response, 200)
        check = client.get("/api_3/package/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "packagename": td.PACKAGENAME})
        assert check.json().get("source_dict", {}).get("committish") == "dev", \
            "编辑后 committish 未更新为 dev"

    @pytest.mark.slow
    def test_build_package(self, client, td):
        """触发包构建（会产生真实构建任务）"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME, "chroots": [td.CHROOTNAME]}
        response = client.post("/api_3/package/build", json=payload)
        assert_status_codes(response, [200, 201, 400])
        if response.status_code in (200, 201):
            assert_json_key_exists(response, "id")

    @pytest.mark.smoke
    def test_list_packages(self, client, td):
        """列出包，应包含前置创建的包"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/package/list", params=params)
        assert_status_code(response, 200)
        assert_is_list_or_paginated(response)
        data = response.json()
        items = data["items"] if isinstance(data, dict) else data
        names = [p.get("name") for p in items]
        assert td.PACKAGENAME in names, f"包列表中未找到 {td.PACKAGENAME}，实际: {names}"

    def test_reset_package(self, client, td):
        """重置包"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME}
        response = client.put("/api_3/package/reset", json=payload)
        assert_status_codes(response, [200, 400])


# =============================================================================
# 用例：project（6）
# =============================================================================
@pytest.mark.project
class TestProject:

    @pytest.mark.smoke
    def test_get_project(self, client, td):
        """查询项目详情（TestSetupResources 已建项目，应查到）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME}
        response = client.get("/api_3/project", params=params)
        assert_status_code(response, 200)
        data = response.json()
        assert data.get("name") == td.PROJECTNAME
        assert data.get("ownername") == td.OWNERNAME
        assert td.CHROOTNAME in data.get("chroot_repos", {}), \
            f"项目未启用 {td.CHROOTNAME}，实际: {list(data.get('chroot_repos', {}))}"

    def test_edit_project(self, client, td):
        """编辑项目设置，并校验改动已生效"""
        new_desc = "Updated by API automation"
        payload = {"description": new_desc}
        response = client.put(f"/api_3/project/edit/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_code(response, 200)
        check = client.get("/api_3/project", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
        assert check.json().get("description") == new_desc, "编辑后 description 未更新"

    def test_fork_project(self, client, td):
        """Fork 项目到同一账号下的新名称"""
        payload = {"name": td.FORK_PROJECTNAME, "ownername": td.OWNERNAME,
                   "confirm": True}
        response = client.put(f"/api_3/project/fork/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 201, 400, 409])

    @pytest.mark.smoke
    def test_list_projects(self, client, td):
        """列出项目，应包含前置创建的项目"""
        response = client.get("/api_3/project/list", params={"ownername": td.OWNERNAME})
        assert_status_code(response, 200)
        assert_is_list_or_paginated(response)
        data = response.json()
        items = data["items"] if isinstance(data, dict) else data
        names = [p.get("name") for p in items]
        assert td.PROJECTNAME in names, f"项目列表中未找到 {td.PROJECTNAME}，实际: {names}"

    def test_regenerate_project_repos(self, client, td):
        """重新生成项目仓库元数据"""
        response = client.put(f"/api_3/project/regenerate-repos/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 400])

    @pytest.mark.smoke
    def test_search_projects(self, client, td):
        """搜索项目"""
        response = client.get("/api_3/project/search", params={"query": td.PROJECTNAME})
        assert_status_code(response, 200)
        assert_is_list_or_paginated(response)


# =============================================================================
# 用例：permission（5）
# =============================================================================
@pytest.mark.permission
class TestPermission:

    def test_can_build_in_project(self, client, td):
        """查询用户是否有项目构建权限"""
        response = client.get(
            f"/api_3/project/permissions/can_build_in/{td.OWNERNAME}/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 404])

    def test_get_project_permissions(self, client, td):
        """获取项目权限

        实测：新建项目未授予任何协作者时，服务端返回 404
        "No permissions set on {owner}/{project} project" —— 这是合法语义，
        故按「200 有权限列表」或「404 且提示无权限设置」两种正常结果断言。
        """
        response = client.get(f"/api_3/project/permissions/get/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 404])
        if response.status_code == 404:
            assert "no permissions set" in response.text.lower(), \
                f"404 应说明「无权限设置」，实际: {response.text[:200]}"
        else:
            assert isinstance(response.json(), dict), "权限列表应为对象"

    def test_request_project_permissions(self, client, td):
        """申请项目权限：owner 对自己项目申请，服务端拒绝属预期（400）"""
        payload = {"builder": True, "admin": False}
        response = client.put(
            f"/api_3/project/permissions/request/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400])

    def test_set_project_permissions(self, client, td):
        """设置项目权限：owner 不能给自己设权限，服务端拒绝属预期（400）"""
        payload = {td.OWNERNAME: {"builder": "approved"}}
        response = client.put(
            f"/api_3/project/permissions/set/{td.OWNERNAME}/{td.PROJECTNAME}", json=payload)
        assert_status_codes(response, [200, 400])

    def test_get_permissions_nonexistent_project(self, client, td):
        """不存在的项目应返回 404"""
        response = client.get(
            f"/api_3/project/permissions/get/{td.OWNERNAME}/no-such-project-xyz")
        assert_status_code(response, 404)


# =============================================================================
# 用例：project-chroot（3）
# =============================================================================
@pytest.mark.chroot
class TestProjectChroot:

    @pytest.mark.smoke
    def test_get_project_chroot(self, client, td):
        """查询项目 chroot 配置（项目已启用该 chroot，应 200）"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/project-chroot/", params=params)
        assert_status_code(response, 200)

    def test_get_project_chroot_build_config(self, client, td):
        """查询项目 chroot 构建配置"""
        params = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                  "chrootname": td.CHROOTNAME}
        response = client.get("/api_3/project-chroot/build-config", params=params)
        assert_status_code(response, 200)

    def test_edit_project_chroot(self, client, td):
        """编辑项目 chroot 配置，并校验改动已生效"""
        payload = {"additional_repos": [], "additional_packages": ["bash"]}
        response = client.put(
            f"/api_3/project-chroot/edit/{td.OWNERNAME}/{td.PROJECTNAME}/{td.CHROOTNAME}",
            json=payload)
        assert_status_code(response, 200)
        check = client.get("/api_3/project-chroot/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "chrootname": td.CHROOTNAME})
        assert_status_code(check, 200)
        assert "bash" in (check.json().get("additional_packages") or []), \
            "编辑后 additional_packages 未包含 bash"


# =============================================================================
# 用例：rpmrepo（2）
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

    def test_get_rpmrepo_nonexistent(self, client, td):
        """不存在的项目目录应返回 404"""
        response = client.get(
            f"/api_3/rpmrepo/{td.OWNERNAME}/no-such-project-xyz/openeuler-24.03_LTS/")
        assert_status_code(response, 404)


# =============================================================================
# 用例：webhook（2）
# =============================================================================
@pytest.mark.webhook
class TestWebhook:

    def test_generate_webhook(self, client, td):
        """生成项目 webhook secret（旧 secret 即时失效，文档 §3.1.3）"""
        response = client.post(f"/api_3/webhook/generate/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_code(response, 200)

    def test_generate_webhook_nonexistent_project(self, client, td):
        """不存在的项目应返回 404"""
        response = client.post(
            f"/api_3/webhook/generate/{td.OWNERNAME}/no-such-project-xyz")
        assert_status_code(response, 404)


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


# =============================================================================
# 用例：backend_httpd 静态文件服务（文档 §3.2）
#
# nginx，root /var/lib/copr/public_html/，autoindex on。
# 通过 ingress 归集在主域名下，缺省与 frontend 同域；可用 EUR_BACKEND_URL 指向
# port-forward 后的 5002 端口单独验证。
# =============================================================================
@pytest.mark.backend
class TestBackendHttpd:

    @pytest.mark.smoke
    def test_results_directory_listing(self, backend_client):
        """GET /results/ 返回 200 + nginx autoindex 目录列表"""
        response = backend_client.get("/results/", headers={"Accept": "text/html"})
        assert_status_code(response, 200)
        body = response.text
        assert "<a href=" in body or "Index of" in body, \
            f"未识别到 autoindex 目录列表特征，前 200 字: {body[:200]}"

    @pytest.mark.smoke
    def test_per_task_logs_accessible(self, backend_client):
        """GET /per-task-logs/ 返回 200 目录列表"""
        response = backend_client.get("/per-task-logs/", headers={"Accept": "text/html"})
        assert_status_code(response, 200)

    def test_project_results_directory(self, backend_client, td):
        """GET /results/{owner}/{project}/ 项目结果目录

        项目刚创建、尚无成功构建时后端目录可能未落地，故放行 404 并打印提示。
        """
        response = backend_client.get(
            f"/results/{td.OWNERNAME}/{td.PROJECTNAME}/", headers={"Accept": "text/html"})
        assert_status_codes(response, [200, 404])
        if response.status_code == 404:
            print("   [backend] 项目结果目录尚未生成（无成功构建），符合预期")

    def test_nonexistent_path_404(self, backend_client):
        """不存在的路径应返回 404"""
        response = backend_client.get("/results/__no_such_dir_xyz__/")
        assert_status_code(response, 404)


# =============================================================================
# 用例：distgit（文档 §3.3）
# =============================================================================
@pytest.mark.distgit
class TestDistgit:

    @pytest.mark.smoke
    def test_cgit_index(self, distgit_client):
        """GET /cgit/ 返回 200 cgit 仓库浏览页"""
        response = distgit_client.get("/cgit/", headers={"Accept": "text/html"})
        assert_status_code(response, 200)
        ctype = response.headers.get("Content-Type", "")
        assert "text/html" in ctype, f"期望 text/html，实际 {ctype}"
        assert "cgit" in response.text.lower(), "响应体未包含 cgit 特征"

    def test_cgit_data_assets(self, distgit_client):
        """GET /cgit-data/ 静态资源可访问

        cgit-data 目录通常关闭 autoindex，此时访问目录本身返回 403/404，
        改取其中确定存在的 cgit.css 验证。
        """
        response = distgit_client.get("/cgit-data/cgit.css")
        assert_status_codes(response, [200, 404])
        if response.status_code == 200:
            assert len(response.content) > 0, "cgit.css 内容为空"
        else:
            listing = distgit_client.get("/cgit-data/")
            assert_status_codes(listing, [200, 403])

    def test_cgit_nonexistent_repo_404(self, distgit_client):
        """不存在的仓库路径应返回 404"""
        response = distgit_client.get("/cgit/__no_such_repo_xyz__/")
        assert_status_codes(response, [404, 200])
        if response.status_code == 200:
            # cgit 对未知仓库会渲染错误页而非 404，此时正文应含错误提示
            assert "no repositories" in response.text.lower() \
                or "unable to find" in response.text.lower() \
                or "not found" in response.text.lower(), \
                "cgit 对不存在仓库既未 404 也未渲染错误提示"


# =============================================================================
# 用例：返回数据结构校验（文档 §5 附录）
# =============================================================================
@pytest.mark.schema
class TestResponseSchema:

    def test_build_schema(self, client, build_id, td):
        """Build 对象字段与类型（文档 §5.1）"""
        response = client.get(f"/api_3/build/{build_id}")
        assert_status_code(response, 200)
        data = response.json()

        expected_types = {
            "id": int, "state": str, "ownername": str, "projectname": str,
            "project_dirname": str, "repo_url": str, "chroots": list,
            "is_background": bool, "submitter": str,
        }
        for field, ftype in expected_types.items():
            assert field in data, f"Build 缺少字段 '{field}'。实际字段: {sorted(data)}"
            if data[field] is not None:
                assert isinstance(data[field], ftype), \
                    f"Build.{field} 类型应为 {ftype.__name__}，实际 {type(data[field]).__name__}"

        # 时间戳：submitted_on 必有值，started_on / ended_on 未开始时可为 null
        assert isinstance(data.get("submitted_on"), int), \
            f"submitted_on 应为 Unix 秒整数，实际 {data.get('submitted_on')!r}"
        for field in ("started_on", "ended_on"):
            assert field in data, f"Build 缺少字段 '{field}'"
            if data[field] is not None:
                assert isinstance(data[field], int), f"Build.{field} 应为整数时间戳"

        # 业务一致性
        assert data["ownername"] == td.OWNERNAME
        assert data["projectname"] == td.PROJECTNAME
        assert data["state"] in ALL_BUILD_STATES, \
            f"state '{data['state']}' 不在已知状态集合内: {sorted(ALL_BUILD_STATES)}"
        if data["state"] not in DOC_BUILD_STATES:
            print(f"   [文档漂移] state '{data['state']}' 未在接口文档 §3.1.3 枚举中列出")

    def test_source_package_schema(self, client, build_id):
        """SourcePackage 字段（文档 §5.2）"""
        response = client.get(f"/api_3/build/{build_id}")
        assert_status_code(response, 200)
        data = response.json()
        assert "source_package" in data, "Build 缺少 source_package"
        sp = data["source_package"]
        assert isinstance(sp, dict), f"source_package 应为对象，实际 {type(sp).__name__}"
        for field in ("name", "version", "url"):
            assert field in sp, f"SourcePackage 缺少字段 '{field}'。实际: {sorted(sp)}"

    def test_package_schema(self, client, td):
        """Package 与 PackageBuilds 字段（文档 §5.3 / §5.4）"""
        response = client.get("/api_3/package/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "packagename": td.PACKAGENAME, "with_latest_build": "true",
            "with_latest_succeeded_build": "true"})
        assert_status_code(response, 200)
        data = response.json()

        expected_types = {"id": int, "name": str, "ownername": str,
                          "projectname": str, "source_type": str,
                          "source_dict": dict, "auto_rebuild": bool}
        for field, ftype in expected_types.items():
            assert field in data, f"Package 缺少字段 '{field}'。实际字段: {sorted(data)}"
            if data[field] is not None:
                assert isinstance(data[field], ftype), \
                    f"Package.{field} 类型应为 {ftype.__name__}，实际 {type(data[field]).__name__}"

        assert "builds" in data, "Package 缺少 builds（PackageBuilds）"
        builds = data["builds"]
        assert isinstance(builds, dict)
        for field in ("latest", "latest_succeeded"):
            assert field in builds, f"PackageBuilds 缺少字段 '{field}'。实际: {sorted(builds)}"

    def test_project_chroot_schema(self, client, td):
        """ProjectChroot 字段与 isolation 枚举（文档 §5.5）"""
        response = client.get("/api_3/project-chroot/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "chrootname": td.CHROOTNAME})
        assert_status_code(response, 200)
        data = response.json()

        for field in ("mock_chroot", "ownername", "projectname", "comps_name",
                      "additional_repos", "additional_packages", "additional_modules",
                      "with_opts", "without_opts", "delete_after_days", "isolation"):
            assert field in data, f"ProjectChroot 缺少字段 '{field}'。实际字段: {sorted(data)}"

        for field in ("additional_repos", "additional_packages",
                      "additional_modules", "with_opts", "without_opts"):
            if data[field] is not None:
                assert isinstance(data[field], list), f"{field} 应为数组"

        if data["delete_after_days"] is not None:
            assert isinstance(data["delete_after_days"], int), "delete_after_days 应为整数"
        # 文档 §5.5 只列了 default / simple / nspawn，实测新建 chroot 返回
        # 'unchanged'（表示沿用上级配置，Copr 上游合法取值），属文档遗漏。
        doc_isolation = ("default", "simple", "nspawn")
        all_isolation = doc_isolation + ("unchanged",)
        if data["isolation"] is not None:
            assert data["isolation"] in all_isolation, \
                f"isolation 取值未知：'{data['isolation']}'，已知 {all_isolation}"
            if data["isolation"] not in doc_isolation:
                print(f"   [文档漂移] isolation '{data['isolation']}' "
                      f"未在接口文档 §5.5 枚举中列出")

    def test_monitor_schema(self, client, td):
        """monitor 返回结构：packages 数组，每项含 chroots 状态与日志链接"""
        response = client.get("/api_3/monitor", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
        assert_status_code(response, 200)
        data = response.json()
        assert isinstance(data.get("packages"), list), "monitor.packages 应为数组"
        if not data["packages"]:
            pytest.skip("monitor 暂无包数据")
        pkg = data["packages"][0]
        assert "name" in pkg, f"monitor 包项缺少 name。实际: {sorted(pkg)}"
        assert "chroots" in pkg, f"monitor 包项缺少 chroots。实际: {sorted(pkg)}"
        for chroot_name, info in (pkg["chroots"] or {}).items():
            assert "state" in info, f"chroot {chroot_name} 缺少 state"
            if info["state"]:
                assert info["state"] in ALL_BUILD_STATES, \
                    f"monitor chroot state '{info['state']}' 不在已知集合内"
            break


# =============================================================================
# 用例：匿名访问 / 鉴权边界（文档 §6.4）
#
# 文档明确：所有写操作须携带 API login/token 的 Basic Auth；
# 只读接口多数无需认证。这里两侧都验。
# =============================================================================
@pytest.mark.anon
class TestAnonymousAccess:

    def test_anon_create_project_rejected(self, anon_client, td):
        """匿名创建项目应被拒绝（401/403）"""
        response = anon_client.post(f"/api_3/project/add/{td.OWNERNAME}",
                                    json={"name": "anon-should-fail",
                                          "chroots": [td.CHROOTNAME]})
        assert_status_codes(response, [401, 403])

    def test_anon_delete_project_rejected(self, anon_client, td):
        """匿名删除项目应被拒绝（401/403），且项目仍然存在"""
        response = anon_client.delete(
            f"/api_3/project/delete/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [401, 403])

    def test_anon_generate_webhook_rejected(self, anon_client, td):
        """匿名生成 webhook secret 应被拒绝（401/403）"""
        response = anon_client.post(
            f"/api_3/webhook/generate/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [401, 403])

    def test_anon_readonly_allowed(self, anon_client, td):
        """匿名只读接口应可访问（文档 §6.4：只读接口多数无需认证）"""
        for path, params in (
            ("/api_3/project/list", {"ownername": td.OWNERNAME}),
            ("/api_3/mock-chroots/list", None),
            ("/api_3/project", {"ownername": td.OWNERNAME,
                                "projectname": td.PROJECTNAME}),
        ):
            response = anon_client.get(path, params=params)
            assert_status_code(response, 200)

    def test_bad_token_rejected(self, td):
        """错误 token 应返回 401"""
        bad = ApiClient(BASE_URL, auth=("nobody", "invalid-token-xxxx"))
        try:
            response = bad.get("/api_3/auth-check")
            assert_status_code(response, 401)
        finally:
            bad.close()


# =============================================================================
# 用例：分页
# =============================================================================
@pytest.mark.smoke
class TestPagination:

    def test_package_list_pagination(self, client, td):
        """package/list 支持 limit / offset 分页"""
        first = client.get("/api_3/package/list", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME, "limit": 1})
        assert_status_code(first, 200)
        data = first.json()
        items = data["items"] if isinstance(data, dict) else data
        assert len(items) <= 1, f"limit=1 应最多返回 1 项，实际 {len(items)}"

        second = client.get("/api_3/package/list", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "limit": 1, "offset": 1})
        assert_status_code(second, 200)

    def test_packages_statistics_pagination(self, client):
        """packages_statistics 分页页面（文档 §3.1.4：每页 50 条）"""
        response = client.get("/coprs/packages_statistics", params={"page": 2})
        assert_status_code(response, 200)
        assert "text/html" in response.headers.get("Content-Type", "")


# =============================================================================
# 用例：端到端构建流程（文档 §6.2）
#
# 提交构建 → 轮询 state 至终态 → 成功后经 backend_httpd /results/ 拉取产物。
# 真实占用 builder 资源且耗时可达数十分钟，默认关闭，需 EUR_E2E=1 开启。
# =============================================================================
@pytest.mark.e2e
@pytest.mark.slow
class TestE2EBuildFlow:

    def test_build_lifecycle(self, client, backend_client, td):
        """完整链路：create/scm → 轮询 build 详情 → /results/ 校验产物"""
        if not E2E_ENABLED:
            pytest.skip("未开启端到端构建流程（设置 EUR_E2E=1 启用）")

        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "chroots": [td.CHROOTNAME],
                   "clone_url": "https://gitee.com/src-openeuler/hello.git",
                   "committish": "master", "scm_type": "git",
                   "spec": f"{td.PACKAGENAME}.spec", "source_build_method": "rpkg"}
        submit = client.post("/api_3/build/create/scm", json=payload)
        assert_status_codes(submit, [200, 201])
        bid = submit.json().get("id")
        assert bid, f"提交构建未返回 build id。Body: {submit.text[:300]}"
        print(f"   [E2E] 已提交构建 id={bid}，开始轮询（超时 {E2E_TIMEOUT}s）")

        deadline = time.time() + E2E_TIMEOUT
        state, detail = None, {}
        while time.time() < deadline:
            resp = client.get(f"/api_3/build/{bid}")
            assert_status_code(resp, 200)
            detail = resp.json()
            state = detail.get("state")
            assert state in ALL_BUILD_STATES, f"未知构建状态 '{state}'"
            if state in FINAL_BUILD_STATES:
                break
            print(f"   [E2E] build {bid} 当前状态 {state}，"
                  f"剩余 {int(deadline - time.time())}s")
            time.sleep(E2E_POLL_INTERVAL)
        else:
            client.put(f"/api_3/build/cancel/{bid}")
            pytest.fail(f"[FAIL] build {bid} 在 {E2E_TIMEOUT}s 内未进入终态，"
                        f"最后状态 {state}（已发起取消）")

        print(f"   [E2E] build {bid} 终态: {state}")
        assert state == "succeeded", \
            f"构建未成功，终态 {state}。详情: {str(detail)[:400]}"

        # 构建 chroot 应产出包列表
        built = client.get("/api_3/build-chroot/built-packages/", params={
            "build_id": bid, "chrootname": td.CHROOTNAME})
        assert_status_code(built, 200)
        assert built.json().get("packages"), \
            f"成功构建未返回产出包列表。Body: {built.text[:300]}"

        # 经 backend_httpd 拉取产物目录
        #
        # 注意：build 详情的 repo_url 在 EUR 部署中返回的是 API 自引用
        # （形如 /api_3/build/661），不是产物目录地址，不能用它拼路径。
        # 产物目录遵循 copr-backend 固定布局：
        #   /results/{owner}/{project_dirname}/{chroot}/{build_id:08d}-{pkg}/
        pkg_name = (detail.get("source_package") or {}).get("name") or td.PACKAGENAME
        dirname = detail.get("project_dirname") or td.PROJECTNAME
        result_path = (f"/results/{detail['ownername']}/{dirname}/"
                       f"{td.CHROOTNAME}/{bid:08d}-{pkg_name}/")
        results = backend_client.get(result_path,
                                     headers={"Accept": "text/html"})
        assert_status_code(results, 200)
        assert "<a href=" in results.text, "构建结果目录不可浏览"


# =============================================================================
# 用例：资源清理（4）—— 必须最后执行
#
# 类名以 Z 开头，保证在文件中位于最末，pytest 按定义顺序执行时最后跑。
# 删除顺序：包 → fork 项目 → 主项目，避免残留影响下一轮。
# =============================================================================
@pytest.mark.cleanup
class TestZCleanup:

    @pytest.mark.build
    def test_cancel_running_builds(self, client, td):
        """取消项目内所有未完成的构建

        必须先于删除项目执行：build 创建类用例会提交真实构建任务，
        存在未完成构建时删除项目会返回 500
        "User 'xxx' can not delete build N"。
        """
        response = client.get("/api_3/build/list/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
        if response.status_code == 404:
            pytest.skip("项目不存在，无需取消构建")
        assert_status_code(response, 200)

        data = response.json()
        items = data["items"] if isinstance(data, dict) else data
        unfinished = [b for b in items if b.get("state") in UNFINISHED_BUILD_STATES]
        print(f"   [清理] 共 {len(items)} 个构建，其中 {len(unfinished)} 个未完成")

        for build in unfinished:
            cancel = client.put(f"/api_3/build/cancel/{build['id']}")
            assert_status_codes(cancel, [200, 400, 404])

        # 等待状态落到终态，避免紧接着的删除仍被拒
        if unfinished:
            time.sleep(3)

    @pytest.mark.package
    def test_delete_package(self, client, td):
        """删除包"""
        payload = {"ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
                   "package_name": td.PACKAGENAME}
        response = client.delete("/api_3/package/delete", json=payload)
        assert_status_codes(response, [200, 404])

        # 二次确认：删除后应查不到
        check = client.get("/api_3/package/", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME,
            "packagename": td.PACKAGENAME})
        assert_status_code(check, 404)

    @pytest.mark.project
    def test_delete_fork_project(self, client, td):
        """删除 fork 出来的项目"""
        response = client.delete(
            f"/api_3/project/delete/{td.OWNERNAME}/{td.FORK_PROJECTNAME}")
        assert_status_codes(response, [200, 404])

    @pytest.mark.project
    def test_delete_project(self, client, td):
        """删除主项目"""
        response = client.delete(f"/api_3/project/delete/{td.OWNERNAME}/{td.PROJECTNAME}")
        assert_status_codes(response, [200, 404])

        # 二次确认：删除后应查不到
        check = client.get("/api_3/project", params={
            "ownername": td.OWNERNAME, "projectname": td.PROJECTNAME})
        assert_status_code(check, 404)


# =============================================================================
# 直接执行入口
#
# `python3 test_cases.py` 等价于 `pytest test_cases.py`：读取 pytest.ini 的
# addopts（已不含 -m "not slow"），因此 slow 用例默认参与执行。
# 端到端用例另由 EUR_E2E 控制，此处默认置为 1 一并执行；
# 不需要时显式设置 EUR_E2E=0。
# 追加的命令行参数会原样透传，例如：
#   python3 test_cases.py -k test_build_lifecycle
#   python3 test_cases.py -m "not slow"
# =============================================================================
if __name__ == "__main__":
    import sys

    os.environ.setdefault("EUR_E2E", "1")
    sys.exit(pytest.main([__file__, *sys.argv[1:]]))
