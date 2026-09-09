#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
opengauss-etherpad 前端自动化测试脚本
测试地址: https://opengauss-etherpad.test.osinfra.cn
技术栈: Playwright + pytest

实际页面结构探测结果 (2026-08-17):
- 首页: /              → Etherpad 标准首页，有 #padname 输入框和创建按钮
- 登录: /ep_guest/login?redirect_uri=... → 302 跳转至统一认证 id-opengauss.test.osinfra.cn
- 编辑: /p/{padname}   → 可直接进入，有 #editorcontainerbox, #editbar 等
- 登出: /ep_guest/logout?redirect_uri=...

双重验证(MFA)结构探测结果 (2026-09-08):
- 弹窗容器:   .mfa-dialog          标题 .mfa-title = "需要验证您的身份"
- 验证目标:   .mfa-account input   (disabled，显示脱敏后的手机号/邮箱)
- 切换方式:   .mfa-switch a        文案在「使用邮箱验证」/「使用手机号验证」间切换
- 验证码输入: #codeInput input     (maxlength=6)
- 获取验证码: #codeInput a         文案「获取验证码」
- 确认/取消:  .mfa-footer button   第 1 个为「确认」(未填码时带 o-btn-disabled)

MFA 自动化策略:
1. 登录后若弹出 MFA 弹窗，自动点击「使用邮箱验证」切到 163 邮箱；
2. 点击「获取验证码」，由 email_verify 模块通过 IMAP 轮询邮箱抓取 6 位验证码；
3. 回填验证码并确认，完成登录；
4. 登录态通过 storage_state 落盘复用（见 AUTH_STATE_PATH），
   整个测试会话只需取一次验证码，后续用例直接复用登录态。

使用方法:
    pip install pytest pytest-html playwright python-dotenv
    playwright install chromium
    python email_verify.py                        # 先自测邮箱 IMAP 配置
    pytest test_cases.py --html=report.html -v
"""

import json
import os
import re
import time

import pytest
from dotenv import load_dotenv
from playwright.sync_api import Page, expect, sync_playwright, BrowserContext

from email_verify import fetch_verification_code, MailCodeError
from slider_solver import solve_slider

# 加载 .env 文件（如果存在），文件内变量将注入到环境变量中
load_dotenv()

# =============================================================================
# 配置项
# =============================================================================
BASE_URL = "https://opengauss-etherpad.test.osinfra.cn"
# 登录地址为 SPA，带 redirect_uri 参数
LOGIN_PATH = "/ep_guest/login?redirect_uri="
EDITOR_URL = f"{BASE_URL}/p/autotestpad"
TEST_PAD_NAME = f"autotest_{int(time.time())}"

USERNAME = os.environ.get("TEST_ACCOUNT", "")
PASSWORD = os.environ.get("TEST_PASSWORD", "")

if not USERNAME or not PASSWORD:
    raise EnvironmentError(
        "[ERROR] 未检测到账号密码，请通过以下任一方式配置:\n"
        "   1. 在项目根目录创建 .env 文件，写入:\n"
        "      TEST_ACCOUNT=your_user\n"
        "      TEST_PASSWORD=your_pass\n"
        "   2. 直接设置环境变量:\n"
        '      $env:TEST_ACCOUNT="your_user"; $env:TEST_PASSWORD="your_pass" (PowerShell)\n'
        '      export TEST_ACCOUNT=your_user TEST_PASSWORD=your_pass (Linux/macOS)\n'
        "   注意: .env 文件已被加入 .gitignore，不会被提交到版本控制。"
    )

# 超时配置（毫秒）
DEFAULT_TIMEOUT = 30000
ACTION_TIMEOUT = 15000

# 登录态缓存：整个会话只登录一次，避免反复触发双重验证
AUTH_STATE_PATH = os.path.join(".auth", "storage_state.json")
# 登录态文件复用窗口（秒），仅用于跨轮次运行时判断磁盘缓存是否值得一探
AUTH_STATE_TTL = int(os.environ.get("AUTH_STATE_TTL", "1800"))
# 登录态主动刷新间隔（秒）。实测服务端会话寿命约 100s 且不滑动续期，
# 故取一个明显小于该寿命的值，在用例间静默重登，避免后置用例掉登录态
AUTH_REFRESH_INTERVAL = int(os.environ.get("AUTH_REFRESH_INTERVAL", "60"))

# 邮箱验证码等待时长（秒）
MAIL_CODE_TIMEOUT = int(os.environ.get("MAIL_CODE_TIMEOUT", "150"))
# 人工兜底：置为 1 时，若邮箱取码不可用则暂停等待操作人在浏览器中手动输码
MFA_MANUAL_FALLBACK = os.environ.get("MFA_MANUAL", "0") == "1"
MFA_MANUAL_WAIT = int(os.environ.get("MFA_MANUAL_WAIT", "180"))

# 滑块 / 图形验证：检测到后暂停等待操作人手动拖动的最长秒数
# （置 0 表示不等待，检测到即失败退出，适用于无人值守的 CI）
SLIDER_WAIT = int(os.environ.get("SLIDER_WAIT", "300"))
# 是否先尝试自动破解滑块（AJ-Captcha 拼图滑块），失败再回落人工
SLIDER_AUTO = os.environ.get("SLIDER_AUTO", "1") == "1"
SLIDER_AUTO_ATTEMPTS = int(os.environ.get("SLIDER_AUTO_ATTEMPTS", "3"))


def get_launch_args():
    """
    获取 Chromium 启动参数。
    针对 Windows Server / 企业环境优化，解决 ERR_NETWORK_ACCESS_DENIED 等问题。
    """
    return [
        "--disable-web-security",
        "--disable-features=IsolateOrigins,site-per-process",
        "--disable-site-isolation-trials",
        "--disable-blink-features=AutomationControlled",
        "--no-sandbox",                    # 关键：禁用沙箱，避免 Windows 网络限制
        "--disable-setuid-sandbox",
        "--disable-dev-shm-usage",
        "--disable-accelerated-2d-canvas",
        "--disable-gpu",
        "--window-size=1920,1080",
        "--start-maximized",
        "--allow-running-insecure-content",  # 允许混合内容
        "--ignore-certificate-errors",       # 忽略证书错误
    ]


def new_context_kwargs(storage_state=None):
    """统一的浏览器上下文参数"""
    kwargs = {
        "viewport": {"width": 1920, "height": 1080},
        "ignore_https_errors": True,     # 测试环境证书可能不被信任
        "record_video_dir": "videos/",   # 失败时可回溯视频
    }
    if storage_state:
        kwargs["storage_state"] = storage_state
    return kwargs


# =============================================================================
# Fixtures
# =============================================================================
@pytest.fixture(scope="session")
def browser():
    """启动浏览器实例（session 级别复用）"""
    with sync_playwright() as p:
        # 使用系统已安装的 Edge 浏览器（Windows 组件，不受额外网络限制）
        browser = p.chromium.launch(
            channel="msedge",         # 调用系统 Microsoft Edge
            headless=False,           # 有头模式便于调试观察
            slow_mo=150,
        )
        yield browser
        browser.close()


class AuthManager:
    """
    登录态管理器（会话级单例）。

    背景：实测该 Etherpad 实例服务端会话寿命极短——登录后约 100 秒即失效，
    且期间持续访问也不会滑动续期（Cookie 本身是长效的，express_sid 24h、token 60d，
    失效发生在服务端）。因此不能"整轮只登录一次"，否则排在后面的用例必然掉登录态。

    策略：每次创建已登录上下文前检查登录态新鲜度，超过 AUTH_REFRESH_INTERVAL
    就静默重新登录一次。由于此时处于 SSO 免验证期，重新登录不会再次触发双重验证，
    因此全程仍然只需要取一次邮箱验证码。
    """

    def __init__(self):
        self._last_login_ts = 0.0

    def ensure_fresh(self, browser) -> str:
        """确保登录态新鲜，必要时重新登录，返回 storage_state 文件路径"""
        os.makedirs(os.path.dirname(AUTH_STATE_PATH), exist_ok=True)
        age = time.time() - self._last_login_ts

        if self._last_login_ts and age < AUTH_REFRESH_INTERVAL and os.path.exists(AUTH_STATE_PATH):
            return AUTH_STATE_PATH

        # 首次进入时，若磁盘上已有登录态且实测仍然有效，可直接复用（跨轮次运行场景）
        if not self._last_login_ts and _state_is_fresh() and _state_is_valid(browser):
            print(f"\n[AUTH] 复用磁盘上仍然有效的登录态: {AUTH_STATE_PATH}")
            self._last_login_ts = time.time()
            return AUTH_STATE_PATH

        reason = "首次登录" if not self._last_login_ts else f"登录态已届 {int(age)}s，主动刷新"
        print(f"\n[AUTH] {reason}...")
        self._login(browser)
        return AUTH_STATE_PATH

    def _login(self, browser):
        context = browser.new_context(**new_context_kwargs())
        context.set_default_timeout(DEFAULT_TIMEOUT)
        page = context.new_page()
        page.set_default_timeout(DEFAULT_TIMEOUT)
        try:
            perform_login(page, USERNAME, PASSWORD)
            page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(3000)
            dismiss_cookie_banner(page)
            if not wait_for_login_state(page, True, 20000):
                page.screenshot(path="debug_auth_failed.png")
                raise AssertionError(
                    "登录流程执行完毕，但编辑页仍为未登录态。"
                    "截图已保存: debug_auth_failed.png"
                )
            context.storage_state(path=AUTH_STATE_PATH)
            self._last_login_ts = time.time()
            print(f"[AUTH] 登录成功，登录态已保存至 {AUTH_STATE_PATH}")
        finally:
            page.close()
            context.close()

    def invalidate(self):
        """作废当前登录态缓存（登出用例执行后调用）"""
        self._last_login_ts = 0.0
        if os.path.exists(AUTH_STATE_PATH):
            os.remove(AUTH_STATE_PATH)


@pytest.fixture(scope="session")
def auth_manager():
    """会话级登录态管理器"""
    return AuthManager()


def _state_is_fresh() -> bool:
    """登录态文件存在且未超过 TTL"""
    if not os.path.exists(AUTH_STATE_PATH):
        return False
    age = time.time() - os.path.getmtime(AUTH_STATE_PATH)
    if age > AUTH_STATE_TTL:
        print(f"[AUTH] 登录态已过期（{int(age)}s > {AUTH_STATE_TTL}s），将重新登录")
        return False
    try:
        with open(AUTH_STATE_PATH, "r", encoding="utf-8") as f:
            return bool(json.load(f).get("cookies"))
    except Exception:
        return False


def _state_is_valid(browser) -> bool:
    """用缓存的登录态实访一次编辑页，确认服务端会话仍有效"""
    context = browser.new_context(**new_context_kwargs(storage_state=AUTH_STATE_PATH))
    page = context.new_page()
    try:
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)
        return wait_for_login_state(page, True, 12000)
    except Exception:
        return False
    finally:
        page.close()
        context.close()


@pytest.fixture(scope="function")
def context(browser, auth_manager):
    """已登录上下文：登录态过期时自动静默重登（免验证期内无需再次取验证码）"""
    state = auth_manager.ensure_fresh(browser)
    context = browser.new_context(**new_context_kwargs(storage_state=state))
    context.set_default_timeout(DEFAULT_TIMEOUT)
    yield context
    context.close()


@pytest.fixture(scope="function")
def page(context: BrowserContext):
    """每个测试用例使用新页面（已登录态）"""
    page = context.new_page()
    page.set_default_timeout(DEFAULT_TIMEOUT)
    yield page
    page.close()


@pytest.fixture(scope="function")
def anon_context(browser):
    """匿名上下文：不加载任何登录态，供匿名场景与登录失败场景使用"""
    context = browser.new_context(**new_context_kwargs())
    context.set_default_timeout(DEFAULT_TIMEOUT)
    yield context
    context.close()


@pytest.fixture(scope="function")
def anon_page(anon_context: BrowserContext):
    """每个测试用例使用新页面（匿名态）"""
    page = anon_context.new_page()
    page.set_default_timeout(DEFAULT_TIMEOUT)
    yield page
    page.close()


# =============================================================================
# 辅助函数
# =============================================================================
# 滑块 / 图形验证容器的候选选择器。
# 覆盖自研滑块（slide/drag/puzzle 类名）与三大主流风控组件（极验、阿里 NC、腾讯防水墙）。
# 注意不要用 [class*='verif'] 这类过宽的匹配 —— MFA 弹窗自身也带 verify 语义，会误报。
SLIDER_SELECTORS = [
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

# 文案兜底：风控组件常改类名，但提示语相对稳定。
# 只收录「拖拽」语义明确的短语 —— 像「安全验证」「请完成验证」这类泛词
# 在 SSO 页面本身就可能出现，纳入会导致误报并把脚本挂死在等待里。
SLIDER_TEXT_HINTS = [
    "拖动滑块", "拖动下方滑块", "按住滑块", "拖动下方图片",
    "向右滑动", "滑动验证", "拖动完成拼图", "完成拼图",
]


def detect_slider(page: Page):
    """
    检测页面上是否出现滑块 / 图形验证。

    :return: 命中的选择器或文案描述；未检测到返回 None
    """
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


def await_slider_cleared(page: Page, stage: str, timeout: int = None) -> bool:
    """
    检测滑块/图形验证；若出现则**提醒操作人手动完成**，并轮询等待其消失后继续。

    该 SSO 位于华为云 WAF 之后，滑块大概率带轨迹风控，脚本不做自动破解 ——
    按项目规约，遇到拖拽类验证一律提示操作人介入，避免与风控策略对抗导致账号异常。

    :param stage:   当前处于登录流程的哪一步，用于提示文案
    :param timeout: 最长等待秒数，缺省取 SLIDER_WAIT；为 0 时检测到即失败
    :return: True 表示出现过滑块且已被处理；False 表示本次未出现
    """
    hit = detect_slider(page)
    if not hit:
        return False

    print(f"   [滑块] 「{stage}」环节检测到滑块验证（{hit}）")

    # ---- 先尝试自动破解（AJ-Captcha 拼图滑块，后端只校验落点坐标）----
    if SLIDER_AUTO:
        try:
            if solve_slider(page, max_attempts=SLIDER_AUTO_ATTEMPTS):
                page.wait_for_timeout(1500)
                if detect_slider(page) is None:
                    return True
                print("   [滑块] 破解后仍检测到滑块，回落人工处理")
        except Exception as exc:
            print(f"   [滑块] 自动破解模块异常，回落人工处理：{type(exc).__name__}: {exc}")

    wait_sec = SLIDER_WAIT if timeout is None else timeout
    shot = f"debug_slider_{stage}.png"
    try:
        page.screenshot(path=shot, full_page=True)
    except Exception:
        shot = "(截图失败)"

    if wait_sec <= 0:
        pytest.fail(
            f"[FAIL] 「{stage}」环节出现滑块/图形验证（{hit}），当前为无人值守模式。\n"
            f"   阿蓁，如需人工介入请设置 SLIDER_WAIT=300 后重跑。\n"
            f"   截图已保存: {shot}"
        )

    print("\a")  # 终端响铃，提醒操作人回到屏幕前
    print("\n" + "!" * 68)
    print(f"   [滑块] 「{stage}」环节检测到滑块/图形验证（{hit}）")
    print("   阿蓁，请在弹出的浏览器窗口中【手动拖动滑块完成验证】。")
    print(f"   完成后脚本会自动继续，最长等待 {wait_sec} 秒。")
    print(f"   当前页面: {page.url}")
    print(f"   截图已保存: {shot}")
    print("!" * 68 + "\n")

    deadline = time.time() + wait_sec
    last_tick = 0
    while time.time() < deadline:
        page.wait_for_timeout(2000)
        if detect_slider(page) is None:
            print("   [滑块] 验证已通过，继续执行\n")
            page.wait_for_timeout(1500)
            return True
        remaining = int(deadline - time.time())
        # 每 20 秒播报一次剩余时间，避免操作人以为脚本卡死
        if remaining // 20 != last_tick:
            last_tick = remaining // 20
            print(f"   [滑块] 仍在等待人工完成验证（剩余 {remaining}s）...")

    page.screenshot(path=f"debug_slider_timeout_{stage}.png")
    pytest.fail(
        f"[FAIL] 「{stage}」环节等待人工完成滑块验证超时（{wait_sec}s）。\n"
        f"   可用环境变量 SLIDER_WAIT 调大等待时长。\n"
        f"   截图已保存: debug_slider_timeout_{stage}.png"
    )


def handle_security_check(page: Page):
    """兼容旧调用名，等价于 await_slider_cleared(page, '登录页')"""
    return await_slider_cleared(page, "登录页")


def wait_for_spa_render(page: Page):
    """等待 SPA 页面渲染完成（通过检查 #app 下是否有子元素）"""
    try:
        page.wait_for_selector("#app > *", timeout=10000)
    except Exception:
        pass  # 某些页面可能不用 #app
    # 额外等待 JS 渲染
    page.wait_for_timeout(2000)


def handle_mfa_challenge(page: Page) -> bool:
    """
    处理登录后的双重验证(MFA)弹窗。

    流程：切换到邮箱验证 → 点击获取验证码 → IMAP 抓取验证码 → 回填 → 确认。

    :return: True 表示处理了 MFA；False 表示本次登录未触发 MFA（处于免验证期）
    """
    dialog = page.locator(".mfa-dialog")
    try:
        dialog.first.wait_for(state="visible", timeout=8000)
    except Exception:
        print("   [MFA] 未出现双重验证弹窗（处于免验证期）")
        return False

    print("   [MFA] 检测到双重验证弹窗，开始自动处理...")

    # ---- 1. 切换为邮箱验证 ----
    switch_link = page.locator(".mfa-switch a").first
    if switch_link.count() > 0 and switch_link.is_visible():
        switch_text = switch_link.inner_text().strip()
        if "邮箱" in switch_text:
            print(f"   [MFA] 点击「{switch_text}」切换验证方式")
            switch_link.click()
            page.wait_for_timeout(2000)

    target = page.locator(".mfa-account input").first
    target_value = target.get_attribute("value") if target.count() > 0 else ""
    print(f"   [MFA] 验证码接收目标: {target_value}")

    if "@" not in (target_value or ""):
        page.screenshot(path="debug_mfa_not_email.png")
        pytest.fail(
            "[FAIL] 双重验证未能切换到邮箱方式，当前接收目标为: "
            f"{target_value}\n"
            "   阿蓁，请确认该 SSO 账号已绑定 163 邮箱且支持邮箱验证。\n"
            "   截图已保存: debug_mfa_not_email.png"
        )

    # ---- 2. 点击获取验证码 ----
    send_link = page.locator("#codeInput a").first
    assert send_link.count() > 0, "MFA 弹窗中未找到「获取验证码」入口"
    send_link.click()
    print("   [MFA] 已点击「获取验证码」")
    page.wait_for_timeout(2500)

    # 部分环境在「获取验证码」后弹出滑块，验证通过才真正发信。
    # 因此收信起始时间必须取【滑块通过之后】，否则可能匹配到上一轮的旧验证码。
    slider_done = await_slider_cleared(page, "获取验证码")
    if slider_done:
        page.wait_for_timeout(2000)
    request_ts = time.time()
    print("   [MFA] 等待验证码邮件送达...")

    # ---- 3. 取码并回填 ----
    code = None
    try:
        code = fetch_verification_code(since_ts=request_ts, timeout=MAIL_CODE_TIMEOUT)
    except MailCodeError as exc:
        if not MFA_MANUAL_FALLBACK:
            page.screenshot(path="debug_mfa_mail_failed.png")
            pytest.fail(
                f"{exc}\n\n"
                "   [提示] 阿蓁，若暂时无法配置邮箱授权码，可设置环境变量 "
                "MFA_MANUAL=1 后重跑，\n"
                "   脚本会暂停并等待你在弹出的浏览器窗口中手动输入验证码。\n"
                "   截图已保存: debug_mfa_mail_failed.png"
            )
        # 人工兜底：等待操作人在浏览器里手动完成
        print("\n" + "=" * 64)
        print("   [MFA] 邮箱自动取码不可用，已切换人工模式。")
        print(f"   阿蓁，请在弹出的浏览器窗口中手动输入验证码并点击「确认」，")
        print(f"   脚本将最多等待 {MFA_MANUAL_WAIT} 秒。")
        print("=" * 64 + "\n")
        deadline = time.time() + MFA_MANUAL_WAIT
        while time.time() < deadline:
            if not dialog.first.is_visible():
                print("   [MFA] 检测到弹窗已关闭，人工验证完成")
                page.wait_for_timeout(3000)
                return True
            page.wait_for_timeout(2000)
        pytest.fail(f"[FAIL] 人工验证等待超时（{MFA_MANUAL_WAIT}s）")

    code_input = page.locator("#codeInput input").first
    code_input.fill(code)
    page.wait_for_timeout(800)

    # ---- 4. 确认 ----
    confirm_btn = page.locator(".mfa-footer button").first
    # 验证码填入后按钮才会解除 disabled 态
    for _ in range(10):
        cls = confirm_btn.get_attribute("class") or ""
        if "o-btn-disabled" not in cls:
            break
        page.wait_for_timeout(500)
    confirm_btn.click()
    print("   [MFA] 已提交验证码，等待跳转...")
    page.wait_for_timeout(5000)

    # 校验弹窗是否消失（未消失通常意味着验证码错误或已失效）
    if dialog.first.count() > 0 and dialog.first.is_visible():
        page.screenshot(path="debug_mfa_rejected.png")
        extra = page.locator(".form-item-extra").first
        msg = extra.inner_text().strip() if extra.count() > 0 else ""
        pytest.fail(
            f"[FAIL] 验证码 {code} 提交后弹窗未关闭，疑似验证码错误或已过期。\n"
            f"   页面提示: {msg or '(无)'}\n"
            "   截图已保存: debug_mfa_rejected.png"
        )

    print("   [MFA] 双重验证通过")
    return True


def perform_login(page: Page, username: str, password: str, redirect_path: str = "/p/autotestpad"):
    """
    执行登录操作。
    该 Etherpad 实例使用 ep_guest 插件，登录会 302 跳转至 openGauss 统一认证中心，
    并可能触发双重验证(MFA)，由 handle_mfa_challenge 自动处理。
    """
    login_url = f"{BASE_URL}{LOGIN_PATH}{redirect_path}"
    print(f"   正在访问登录页: {login_url}")
    page.goto(login_url, wait_until="domcontentloaded", timeout=60000)
    page.wait_for_timeout(3000)
    wait_for_spa_render(page)

    # 若已处于登录态，SSO 会直接跳回业务域，无需再填表单
    if "id-opengauss" not in page.url and LOGIN_PATH.split("?")[0] not in page.url:
        print(f"   已处于登录态，直接跳转至: {page.url}")
        return

    # 检查是否需要处理图形验证码/滑块
    handle_security_check(page)

    # 统一认证登录页（Vue + o-design 组件库）表单选择器
    username_selectors = [
        "input[type='text']",
        "input[name='username']",
        "input[name='email']",
        "input[placeholder*='请输入']",
        "#username",
        ".o_input-input",
    ]

    password_selectors = [
        "input[type='password']",
        "input[name='password']",
        "#password",
    ]

    login_btn_selectors = [
        ".login-btn",
        "button:has-text('登录')",
        "button[type='submit']",
        "button:has-text('Log in')",
        "button:has-text('Sign in')",
        ".o-btn-primary",
    ]

    # 定位用户名输入框
    username_input = None
    for sel in username_selectors:
        loc = page.locator(sel).first
        if loc.count() > 0 and loc.is_visible():
            username_input = loc
            break

    if username_input is None:
        page.screenshot(path="debug_login_page.png")
        pytest.fail(
            "[FAIL] 未找到用户名输入框。\n"
            "   阿蓁，请检查 debug_login_page.png，确认登录表单实际结构。"
        )

    # 定位密码输入框
    password_input = None
    for sel in password_selectors:
        loc = page.locator(sel).first
        if loc.count() > 0 and loc.is_visible():
            password_input = loc
            break

    if password_input is None:
        page.screenshot(path="debug_login_page.png")
        pytest.fail(
            "[FAIL] 未找到密码输入框。\n"
            "   阿蓁，请检查 debug_login_page.png。"
        )

    # 填充账号密码
    username_input.fill(username)
    password_input.fill(password)

    # 点击登录按钮
    login_btn = None
    for sel in login_btn_selectors:
        loc = page.locator(sel).first
        if loc.count() > 0 and loc.is_visible():
            login_btn = loc
            break

    if login_btn is None:
        password_input.press("Enter")
    else:
        login_btn.click()

    page.wait_for_timeout(4000)  # SPA/内网环境用固定延迟替代 networkidle

    # 提交登录后也可能先弹滑块，通过后才进入双重验证环节
    await_slider_cleared(page, "提交登录")

    # 处理双重验证（若触发）
    handle_mfa_challenge(page)

    wait_for_spa_render(page)
    await_slider_cleared(page, "登录收尾")

    # 断言：登录成功后应离开统一认证域，跳回业务域
    assert "id-opengauss" not in page.url, (
        f"登录未完成，仍停留在统一认证页面: {page.url}"
    )


# 登出入口（已登录态的正向标识）。
# 注意：服务端下发的静态 HTML 中只有 Log In 入口，登录后由 JS 把 #login-redirect-uri
# 就地改写为 Log Out，因此绝不能只按元素 id 判定登录态，必须看文案/href。
LOGOUT_SELECTOR = (
    "a[href*='/ep_guest/logout'], a[data-l10n-id*='logout'], "
    "a:has-text('Log Out'), a:has-text('Logout'), a:has-text('登出'), a:has-text('退出')"
)
# 登录入口（未登录态的负向标识）
LOGIN_SELECTOR = (
    "a[href*='/ep_guest/login'], a[data-l10n-id='ep_guest_login'], "
    "a:has-text('Log In'), a:has-text('Login')"
)


def _first_visible(page: Page, selector: str) -> bool:
    """判断选择器命中的首个元素是否可见（吞掉定位异常，供状态判定使用）"""
    try:
        loc = page.locator(selector).first
        return loc.count() > 0 and loc.is_visible()
    except Exception:
        return False


def is_logged_in(page: Page) -> bool:
    """
    判断当前页面是否处于已登录态（不抛异常，供 fixture 内部判定使用）。

    判定优先级：
      1. 出现可见的 Log Out 入口  → 已登录（最强正向信号）
      2. 权限拒绝面板可见          → 未登录
      3. 出现可见的 Log In 入口    → 未登录
    不使用 #myusernameedit 的 disabled 属性做判定：该属性在服务端 HTML 中恒为
    disabled="disabled"，登录后才由前端 JS 解除，时序上不可靠。
    """
    if _first_visible(page, LOGOUT_SELECTOR):
        return True
    if _first_visible(page, "#permissionDenied"):
        return False
    if _first_visible(page, LOGIN_SELECTOR):
        return False
    return True


def wait_for_login_state(page: Page, expected: bool, timeout: int = 15000) -> bool:
    """
    轮询等待登录态稳定。

    页面顶栏的 Log In / Log Out 入口由前端 JS 异步渲染，一次性快照式判定存在竞态，
    因此这里持续轮询直到状态符合预期或超时。

    :param expected: True 期望已登录，False 期望已登出
    :return: 是否在超时前达到期望状态
    """
    deadline = time.time() + timeout / 1000
    while True:
        if is_logged_in(page) == expected:
            return True
        if time.time() >= deadline:
            return False
        page.wait_for_timeout(1000)


def ensure_logged_in(page: Page, timeout: int = 15000):
    """断言当前已处于登录状态"""
    dismiss_cookie_banner(page)
    if not wait_for_login_state(page, True, timeout):
        page.screenshot(path="debug_expect_logged_in.png")
        raise AssertionError(
            f"未检测到已登录状态标识（无可见 Log Out 入口），当前 URL: {page.url}\n"
            "   截图已保存: debug_expect_logged_in.png"
        )
    return True


def ensure_logged_out(page: Page, timeout: int = 15000):
    """断言当前已处于登出状态（编辑页中出现 Login 按钮且无 Log Out 入口）"""
    dismiss_cookie_banner(page)
    if not wait_for_login_state(page, False, timeout):
        page.screenshot(path="debug_expect_logged_out.png")
        raise AssertionError(
            f"登出后仍处于登录态（Log Out 入口依然可见），当前 URL: {page.url}\n"
            "   截图已保存: debug_expect_logged_out.png"
        )
    assert _first_visible(page, LOGIN_SELECTOR) or _first_visible(page, "#permissionDenied"), \
        "登出后未检测到 Login 按钮或权限拒绝提示"


def dismiss_cookie_banner(page: Page):
    """关闭底部 cookie 提示条，避免其遮挡页面元素导致点击被拦截"""
    try:
        close_btn = page.locator(
            ".cookie-banner .close, .cookie-tip .close, "
            "[class*='cookie'] [class*='close'], [class*='cookie'] button"
        ).first
        if close_btn.count() > 0 and close_btn.is_visible():
            close_btn.click(timeout=3000)
            page.wait_for_timeout(500)
    except Exception:
        pass  # 提示条不存在或已关闭，不影响主流程


def get_editor_body(page: Page):
    """定位编辑器内容区（模块级公共函数）"""
    dismiss_cookie_banner(page)
    outer_selectors = [
        "iframe[name='ace_outer']",
        "iframe[id='ace_outer']",
        "iframe.ace_outer",
        "iframe",
    ]
    for sel in outer_selectors:
        outer = page.locator(sel).first
        if outer.count() > 0:
            try:
                frame = outer.content_frame
                inner = frame.locator("iframe[name='ace_inner'], iframe[id='ace_inner'], iframe.ace_inner").first
                if inner.count() > 0:
                    frame = inner.content_frame
                body = frame.locator("#innerdocbody")
                if body.count() > 0:
                    return body
            except Exception:
                continue
    # 备选：直接查找可编辑区域
    return page.locator("#innerdocbody, .ace_content, [contenteditable='true']").first


def ensure_editor_editable(page: Page, body, timeout: int = 15000):
    """
    断言编辑区处于可编辑态。

    未登录时 Etherpad 会以只读态渲染（contenteditable="false"），
    此时 keyboard.type() 全部落空，断言却可能命中 Pad 中的历史残留内容而假通过。
    因此所有编辑类用例必须先过这道前置校验。
    """
    deadline = time.time() + timeout / 1000
    editable = None
    while time.time() < deadline:
        editable = body.get_attribute("contenteditable")
        if editable == "true":
            return True
        page.wait_for_timeout(1000)

    page.screenshot(path="debug_editor_readonly.png")
    pytest.fail(
        f"[FAIL] 编辑区处于只读态 contenteditable={editable!r}，无法执行编辑操作。\n"
        "   常见原因：登录态失效，Pad 以匿名只读方式渲染。\n"
        "   截图已保存: debug_editor_readonly.png"
    )


def clear_pad(page: Page, body):
    """清空 Pad 内容，避免历史残留内容干扰断言"""
    body.click()
    page.keyboard.press("Control+a")
    page.keyboard.press("Delete")
    page.wait_for_timeout(800)


# =============================================================================
# 测试用例
# =============================================================================
class TestLoginLogout:
    """登录相关测试（登出用例见文件末尾 TestLogout，需最后执行）"""

    def test_login_success(self, page: Page):
        """
        TC-LOGIN-001: 正常登录（含邮箱双重验证）
        前置: 拥有有效账号密码 + 邮箱可自动取码
        预期: 登录成功后跳转回编辑页，用户状态为已登录
        """
        print("\n[TC-LOGIN-001] 开始执行正常登录测试...")
        # 登录动作已由会话级 auth_state fixture 完成（含 MFA 邮箱取码），
        # 此处校验该登录态在全新上下文中确实生效
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)
        ensure_logged_in(page)

        # 进一步确认登录态带来了编辑权限
        body = get_editor_body(page)
        ensure_editor_editable(page, body)
        print("[PASS] 正常登录测试通过")

    def test_login_failure_wrong_password(self, anon_page: Page):
        """
        TC-LOGIN-002: 错误密码登录失败
        前置: 使用正确用户名 + 错误密码（匿名上下文，避免复用已有登录态）
        预期: 登录被拒绝，不进入双重验证环节，仍停留在统一认证页
        """
        print("\n[TC-LOGIN-002] 开始执行错误密码登录测试...")
        page = anon_page
        login_url = f"{BASE_URL}{LOGIN_PATH}/p/autotestpad"
        page.goto(login_url, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)
        wait_for_spa_render(page)
        handle_security_check(page)

        # 填充错误密码
        page.locator("input[type='text']").first.fill(USERNAME)
        page.locator("input[type='password']").first.fill("WrongPassword123!")
        login_btn = page.locator(".login-btn, button:has-text('登录')").first
        if login_btn.count() > 0 and login_btn.is_visible():
            login_btn.click()
        else:
            page.keyboard.press("Enter")

        page.wait_for_timeout(5000)
        wait_for_spa_render(page)

        # 关键断言 1：错误密码不应触发双重验证弹窗
        mfa_dialog = page.locator(".mfa-dialog").first
        mfa_shown = mfa_dialog.count() > 0 and mfa_dialog.is_visible()
        assert not mfa_shown, "错误密码不应通过密码校验并进入双重验证环节"

        # 关键断言 2：仍停留在统一认证登录页，或出现明确错误提示
        error_indicators = [
            "text=密码错误",
            "text=账号或密码",
            "text=用户名或密码",
            "text=Incorrect",
            "text=Invalid",
            "text=错误",
            "text=失败",
            ".o-form-item-extra",
            ".error",
        ]
        still_on_login = "id-opengauss" in page.url or "/login" in page.url
        has_error = any(
            page.locator(ind).first.count() > 0 and page.locator(ind).first.is_visible()
            for ind in error_indicators
        )
        assert still_on_login or has_error, "预期登录失败，但页面已跳转且无错误提示"
        print(f"[PASS] 错误密码登录测试通过（未触发 MFA，停留在: {page.url[:80]}）")


class TestEditor:
    """编辑器功能测试（登录态）"""

    def test_open_pad_and_type(self, page: Page):
        """
        TC-EDIT-001: 打开 Pad 并输入文本
        前置: 已登录
        预期: 文本成功输入并同步显示
        """
        print("\n[TC-EDIT-001] 开始执行编辑输入测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)

        body = get_editor_body(page)
        ensure_editor_editable(page, body)
        clear_pad(page, body)

        test_text = "Hello openGauss Etherpad! 自动化测试文本。"
        page.keyboard.type(test_text)

        expect(body).to_contain_text(re.compile(r"Hello openGauss Etherpad"))
        print("[PASS] 编辑输入测试通过")

    def test_format_bold(self, page: Page):
        """
        TC-EDIT-002: 文本加粗格式化
        前置: 已登录且进入编辑页
        预期: 选中文本加粗后，DOM 中出现携带该文本的 <b> 或等效标记
        """
        print("\n[TC-EDIT-002] 开始执行加粗格式化测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)

        body = get_editor_body(page)
        ensure_editor_editable(page, body)
        clear_pad(page, body)

        # 使用带时间戳的唯一文本，确保断言命中的是本次输入而非历史残留内容
        marker = f"bold{int(time.time())}"
        page.keyboard.type(marker)
        page.wait_for_timeout(500)

        # 加粗前先确认不存在同名加粗标记，排除脏数据干扰
        assert body.locator(f"b:has-text('{marker}'), strong:has-text('{marker}')").count() == 0, \
            "加粗操作前已存在同名加粗标记，用例数据不干净"

        page.keyboard.press("Control+a")
        bold_btn = page.locator(".buttonicon-bold, [title='Bold']").first
        if bold_btn.count() > 0 and bold_btn.is_visible():
            bold_btn.click()
        else:
            page.keyboard.press("Control+b")
        page.wait_for_timeout(1000)

        bold_markers = body.locator(f"b:has-text('{marker}'), strong:has-text('{marker}')")
        assert bold_markers.count() > 0, (
            f"加粗后未检测到包含本次输入文本 {marker} 的 <b>/<strong> 标记"
        )
        print("[PASS] 加粗格式化测试通过")

    def test_create_new_pad(self, page: Page):
        """
        TC-EDIT-003: 创建新 Pad
        前置: 已登录
        预期: 通过首页创建入口成功生成新 Pad 并进入编辑页
        """
        print("\n[TC-EDIT-003] 开始执行创建新 Pad 测试...")
        page.goto(BASE_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)

        pad_input = page.locator("#padname")
        assert pad_input.count() > 0, "首页未找到 Pad 名称输入框 #padname"

        pad_name = f"autotest_{int(time.time())}"
        pad_input.fill(pad_name)

        # 点击提交按钮或按回车
        submit_btn = page.locator("#go2Name button[type='submit']").first
        if submit_btn.count() > 0 and submit_btn.is_visible():
            submit_btn.click()
        else:
            page.keyboard.press("Enter")

        page.wait_for_timeout(3000)
        assert f"/p/{pad_name}" in page.url, f"创建 Pad 后未跳转到预期地址，当前: {page.url}"
        print("[PASS] 创建新 Pad 测试通过")

    def test_editor_toolbar_elements(self, page: Page):
        """
        TC-EDIT-004: 编辑器工具栏元素检查
        前置: 进入编辑页
        预期: 工具栏关键按钮和选择器可见
        """
        print("\n[TC-EDIT-004] 开始执行工具栏检查测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)

        # 检查关键编辑器元素
        checks = {
            "editbar": "#editbar",
            "editorcontainerbox": "#editorcontainerbox",
            "font_family_selector": "#font-family",
            "font_size_selector": "#font-size",
            "myuser_area": "#myuser",
            "chatbox": "#chatbox",
        }

        for name, selector in checks.items():
            loc = page.locator(selector)
            assert loc.count() > 0, f"编辑页缺少关键元素: {name} ({selector})"
            print(f"   OK 检测到 {name}")

        print("[PASS] 工具栏检查测试通过")


class TestAnonymous:
    """匿名访问场景测试（均使用匿名上下文，不加载登录态）"""

    def test_anonymous_create_pad(self, anon_page: Page):
        """
        TC-ANON-001: 匿名用户创建 Pad
        前置: 未登录（匿名上下文）
        预期: 可以正常创建并进入编辑页
        """
        print("\n[TC-ANON-001] 开始执行匿名创建 Pad 测试...")
        page = anon_page
        page.goto(BASE_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)

        pad_input = page.locator("#padname")
        assert pad_input.count() > 0, "首页未找到 Pad 名称输入框"

        pad_name = f"anon_test_{int(time.time())}"
        pad_input.fill(pad_name)
        page.keyboard.press("Enter")

        page.wait_for_timeout(3000)
        assert f"/p/{pad_name}" in page.url
        print("[PASS] 匿名创建 Pad 测试通过")

    def test_anonymous_edit_denied(self, anon_page: Page):
        """
        TC-ANON-002: 匿名用户访问编辑页被拦截
        前置: 未登录（匿名上下文）
        预期: 出现权限拒绝提示或登录按钮
        """
        print("\n[TC-ANON-002] 开始执行匿名访问拦截测试...")
        page = anon_page
        page.goto(f"{BASE_URL}/p/anon_edit_test", wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(5000)

        # 检查是否出现权限拒绝或登录入口
        perm_denied = page.locator("#permissionDenied").first
        login_btn = page.locator(
            "#login-redirect-uri, a:has-text('Login'), a:has-text('Log In')"
        ).first

        has_denied = perm_denied.count() > 0 and perm_denied.is_visible()
        has_login = login_btn.count() > 0 and login_btn.is_visible()

        assert has_denied or has_login, (
            "匿名访问编辑页应显示权限拒绝或登录按钮，但未检测到相关元素"
        )
        print("[PASS] 匿名访问拦截测试通过")


class TestLogout:
    """
    登出测试。

    注意：本类必须放在文件末尾。登出会销毁服务端会话，
    而所有登录态用例共享同一份 storage_state（同一个会话 Cookie），
    若提前执行会导致后续用例全部掉登录态。
    """

    def test_logout(self, page: Page, auth_manager):
        """
        TC-LOGOUT-001: 正常登出
        前置: 已登录状态
        预期: 点击登出后返回编辑页未登录态（出现 Login 按钮）
        """
        print("\n[TC-LOGOUT-001] 开始执行登出测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)
        ensure_logged_in(page)

        # 执行登出
        logout_url = f"{BASE_URL}/ep_guest/logout?redirect_uri=/p/autotestpad"
        page.goto(logout_url, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(4000)

        # 回到编辑页检查是否已登出
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)
        ensure_logged_out(page)

        # 登出已使服务端会话失效，同步作废登录态缓存，避免后续运行复用脏状态
        auth_manager.invalidate()
        print(f"   已清理失效的登录态缓存: {AUTH_STATE_PATH}")

        print("[PASS] 登出测试通过")


# =============================================================================
# 主入口（支持直接 python test_cases.py 运行，用于快速自测登录链路）
# =============================================================================
if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(
            channel="msedge",
            headless=False,
            slow_mo=200,
        )
        context = browser.new_context(
            viewport={"width": 1920, "height": 1080},
            ignore_https_errors=True
        )
        page = context.new_page()

        try:
            print("[DEBUG] 启动自测流程（含双重验证邮箱取码）...")
            perform_login(page, USERNAME, PASSWORD)
            page.screenshot(path="screenshot_logged_in.png")
            print("[PASS] 登录后截图已保存: screenshot_logged_in.png")

            page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(3000)
            page.screenshot(path="screenshot_editor.png")
            print(f"[PASS] 编辑器截图已保存: screenshot_editor.png")
            print(f"[INFO] 当前登录态: {'已登录' if is_logged_in(page) else '未登录'}")

            os.makedirs(os.path.dirname(AUTH_STATE_PATH), exist_ok=True)
            context.storage_state(path=AUTH_STATE_PATH)
            print(f"[PASS] 登录态已保存: {AUTH_STATE_PATH}")
        except Exception as e:
            page.screenshot(path="screenshot_error.png")
            print(f"[ERROR] 自测异常: {e}")
            print("   错误截图已保存: screenshot_error.png")
        finally:
            browser.close()
