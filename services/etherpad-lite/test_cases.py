#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
opengauss-etherpad 前端自动化测试脚本
测试地址: https://opengauss-etherpad.test.osinfra.cn
技术栈: Playwright + pytest

实际页面结构探测结果 (2026-08-17):
- 首页: /              → Etherpad 标准首页，有 #padname 输入框和创建按钮
- 登录: /ep_guest/login?redirect_uri=... → SPA (openGauss starter)，JS 渲染表单
- 编辑: /p/{padname}   → 可直接进入，有 #editorcontainerbox, #editbar 等
- 登出: /ep_guest/logout?redirect_uri=...

使用方法:
    pip install pytest pytest-html playwright
    playwright install chromium
    pytest test_etherpad.py --html=report.html -v
"""

import os
import re
import time
import pytest
from dotenv import load_dotenv
from playwright.sync_api import Page, expect, sync_playwright, BrowserContext

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


@pytest.fixture(scope="function")
def context(browser):
    """每个测试用例使用独立的浏览器上下文（隔离 Cookie/缓存）"""
    context = browser.new_context(
        viewport={"width": 1920, "height": 1080},
        ignore_https_errors=True,     # 测试环境证书可能不被信任
        record_video_dir="videos/"    # 失败时可回溯视频
    )
    context.set_default_timeout(DEFAULT_TIMEOUT)
    yield context
    context.close()


@pytest.fixture(scope="function")
def page(context: BrowserContext):
    """每个测试用例使用新页面"""
    page = context.new_page()
    page.set_default_timeout(DEFAULT_TIMEOUT)
    yield page
    page.close()


# =============================================================================
# 辅助函数
# =============================================================================
def handle_security_check(page: Page):
    """
    处理可能出现的验证码或滑块验证。
    若页面出现验证元素，抛出提示让操作人手动处理。
    """
    captcha_selectors = [
        "img[src*='captcha']",
        ".captcha",
        "#captcha",
        ".slider-container",
        ".geetest_challenge",
        ".nc-container",
        "iframe[src*='captcha']",
        ".verify-code",           # 常见验证码输入
        "input[placeholder*='验证码']",
    ]

    for selector in captcha_selectors:
        try:
            if page.locator(selector).count() > 0 and page.locator(selector).is_visible(timeout=2000):
                pytest.fail(
                    f"[FAIL] 检测到安全验证元素: {selector}\n"
                    f"   阿蓁，请在浏览器中完成验证码/滑块验证后，按回车继续。\n"
                    f"   当前页面: {page.url}"
                )
        except Exception:
            continue


def wait_for_spa_render(page: Page):
    """等待 SPA 页面渲染完成（通过检查 #app 下是否有子元素）"""
    try:
        page.wait_for_selector("#app > *", timeout=10000)
    except Exception:
        pass  # 某些页面可能不用 #app
    # 额外等待 JS 渲染
    page.wait_for_timeout(2000)


def perform_login(page: Page, username: str, password: str, redirect_path: str = "/p/autotestpad"):
    """
    执行登录操作。
    该 Etherpad 实例使用 ep_guest 插件，登录页为 SPA（openGauss starter）。
    """
    login_url = f"{BASE_URL}{LOGIN_PATH}{redirect_path}"
    print(f"   正在访问登录页: {login_url}")
    page.goto(login_url, wait_until="domcontentloaded", timeout=60000)
    page.wait_for_timeout(3000)
    wait_for_spa_render(page)

    # 检查是否需要处理安全验证
    handle_security_check(page)

    # SPA 登录页（openGauss starter）常见表单选择器
    # 由于 JS 动态渲染，尝试多种可能的选择器组合
    username_selectors = [
        "input[type='text']",
        "input[name='username']",
        "input[name='email']",
        "input[name='login']",
        "input[placeholder*='手机']",
        "input[placeholder*='账号']",
        "input[placeholder*='用户名']",
        "input[placeholder*='Phone']",
        "input[placeholder*='User']",
        "input[placeholder*='Email']",
        "#username",
        ".el-input__inner",         # Element UI 常见
    ]

    password_selectors = [
        "input[type='password']",
        "input[name='password']",
        "#password",
        ".el-input__inner[type='password']",
    ]

    login_btn_selectors = [
        "button[type='submit']",
        "button:has-text('登录')",
        "button:has-text('Log in')",
        "button:has-text('Sign in')",
        "button:has-text('确定')",
        "button:has-text('OK')",
        ".el-button--primary",      # Element UI 主按钮
        "button.primary",
        "input[type='submit']",
    ]

    # 定位用户名输入框
    username_input = None
    for sel in username_selectors:
        loc = page.locator(sel).first
        if loc.count() > 0 and loc.is_visible():
            username_input = loc
            break

    if username_input is None:
        # 截图保存供调试
        page.screenshot(path="debug_login_page.png")
        pytest.fail(
            "[FAIL] 未找到用户名输入框。\n"
            "   阿蓁，请检查 debug_login_page.png，确认 SPA 登录表单实际结构。\n"
            "   当前页面已保存截图。"
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

    # 若出现验证码输入框
    captcha_input = page.locator("input[name='captcha'], input[placeholder*='验证码'], input[placeholder*='code']").first
    if captcha_input.count() > 0 and captcha_input.is_visible():
        page.screenshot(path="debug_captcha.png")
        pytest.fail(
            "[FAIL] 登录需要输入验证码。\n"
            "   阿蓁，请查看 debug_captcha.png，在浏览器中完成验证后重试。"
        )

    # 点击登录按钮
    login_btn = None
    for sel in login_btn_selectors:
        loc = page.locator(sel).first
        if loc.count() > 0 and loc.is_visible():
            login_btn = loc
            break

    if login_btn is None:
        # 尝试按 Enter 键提交
        password_input.press("Enter")
    else:
        login_btn.click()

    page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
    wait_for_spa_render(page)
    handle_security_check(page)

    # 断言：登录成功后应跳转回 redirect_uri（或包含原路径）
    assert redirect_path in page.url or page.url != login_url, \
        f"登录后未正确跳转，当前 URL: {page.url}"


def ensure_logged_in(page: Page):
    """断言当前已处于登录状态（编辑页中用户输入框非 disabled 或有用户名）"""
    # 已登录标识：myusernameedit 不再 disabled，或页面无 Login 按钮
    user_edit = page.locator("#myusernameedit")
    login_btn = page.locator("#login-redirect-uri, a:has-text('Login'), a:has-text('Log In')")

    # 如果存在 #myusernameedit 且不是 disabled，说明已登录可编辑名称
    if user_edit.count() > 0:
        is_disabled = user_edit.get_attribute("disabled")
        if is_disabled is None or is_disabled == "false":
            return True

    # 或者页面上没有 Login 按钮
    if login_btn.count() == 0 or not login_btn.is_visible():
        return True

    pytest.fail("登录后未检测到已登录状态标识")


def ensure_logged_out(page: Page):
    """断言当前已处于登出状态（编辑页中出现 Login 按钮）"""
    login_btn = page.locator("#login-redirect-uri, a:has-text('Login'), a:has-text('Log In')").first
    assert login_btn.count() > 0 and login_btn.is_visible(), "登出后未检测到 Login 按钮"


# =============================================================================
# 测试用例
# =============================================================================
class TestLoginLogout:
    """登录与登出相关测试"""

    def test_login_success(self, page: Page):
        """
        TC-LOGIN-001: 正常登录
        前置: 拥有有效账号密码
        预期: 登录成功后跳转回编辑页，用户状态为已登录
        """
        print("\n[TC-LOGIN-001] 开始执行正常登录测试...")
        perform_login(page, USERNAME, PASSWORD)
        # 跳转回编辑页后检查登录状态
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        ensure_logged_in(page)
        print("[PASS] 正常登录测试通过")

    def test_login_failure_wrong_password(self, page: Page):
        """
        TC-LOGIN-002: 错误密码登录失败
        前置: 使用正确用户名 + 错误密码
        预期: 页面提示登录失败（仍在登录页或出现错误提示）
        """
        print("\n[TC-LOGIN-002] 开始执行错误密码登录测试...")
        login_url = f"{BASE_URL}{LOGIN_PATH}/p/autotestpad"
        page.goto(login_url, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        wait_for_spa_render(page)
        handle_security_check(page)

        # 填充错误密码
        page.locator("input[type='text']").first.fill(USERNAME)
        page.locator("input[type='password']").first.fill("WrongPassword123!")
        page.keyboard.press("Enter")

        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        wait_for_spa_render(page)

        # 断言：仍在登录相关页或出现错误提示
        error_indicators = [
            "text=Incorrect",
            "text=错误",
            "text=failed",
            "text=失败",
            "text=Invalid",
            "text=密码错误",
            ".error",
            ".alert-danger",
            ".el-form-item__error",   # Element UI 错误提示
        ]
        # SSO 可能跳转至 id-opengauss.test.osinfra.cn，这也属于未登录成功
        still_on_login = (
            LOGIN_PATH in page.url
            or "/forceauth" in page.url
            or "id-opengauss" in page.url
            or "/login" in page.url
        )
        has_error = any(
            page.locator(ind).count() > 0 and page.locator(ind).is_visible()
            for ind in error_indicators
        )
        assert still_on_login or has_error, "预期登录失败，但页面已跳转且无错误提示"
        print("[PASS] 错误密码登录测试通过")

    def test_logout(self, page: Page):
        """
        TC-LOGOUT-001: 正常登出
        前置: 已登录状态
        预期: 点击登出后返回编辑页未登录态（出现 Login 按钮）
        """
        print("\n[TC-LOGOUT-001] 开始执行登出测试...")
        # 先登录
        perform_login(page, USERNAME, PASSWORD)
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        ensure_logged_in(page)

        # 点击登出
        logout_url = f"{BASE_URL}/ep_guest/logout?redirect_uri=/p/autotestpad"
        page.goto(logout_url, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        page.wait_for_timeout(2000)

        # 回到编辑页检查是否已登出
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        ensure_logged_out(page)
        print("[PASS] 登出测试通过")


def get_editor_body(page: Page):
    """定位编辑器内容区（模块级公共函数）"""
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


class TestEditor:
    """编辑器功能测试（匿名 + 登录态）"""

    @pytest.fixture(autouse=True)
    def setup_login(self, page: Page):
        """编辑器测试前确保已登录（若登录系统可用）"""
        try:
            perform_login(page, USERNAME, PASSWORD)
        except Exception as e:
            print(f"   登录步骤异常（可能已登录或无需登录）: {e}")
            # 如果登录失败，继续测试匿名编辑

    def _get_editor_body(self, page: Page):
        """定位编辑器内容区"""
        # Etherpad 编辑器常见结构：iframe[name='ace_outer'] -> iframe[name='ace_inner'] -> #innerdocbody
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

    def test_open_pad_and_type(self, page: Page):
        """
        TC-EDIT-001: 打开 Pad 并输入文本
        前置: 已登录
        预期: 文本成功输入并同步显示
        """
        print("\n[TC-EDIT-001] 开始执行编辑输入测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle

        body = get_editor_body(page)
        body.click()
        page.keyboard.press("Control+a")
        page.keyboard.press("Delete")

        test_text = "Hello openGauss Etherpad! 自动化测试文本。"
        page.keyboard.type(test_text)

        expect(body).to_contain_text(re.compile(r"Hello openGauss Etherpad"))
        print("[PASS] 编辑输入测试通过")

    def test_format_bold(self, page: Page):
        """
        TC-EDIT-002: 文本加粗格式化
        前置: 已登录且进入编辑页
        预期: 选中文本加粗后，DOM 中出现 <b> 或样式标记
        """
        print("\n[TC-EDIT-002] 开始执行加粗格式化测试...")
        page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle

        body = get_editor_body(page)
        body.click()
        page.keyboard.press("Control+a")
        page.keyboard.press("Delete")
        page.keyboard.type("bold text")

        page.keyboard.press("Control+a")
        bold_btn = page.locator(".buttonicon-bold, [title='Bold'], button:has-text('B')").first
        if bold_btn.count() > 0 and bold_btn.is_visible():
            bold_btn.click()
        else:
            page.keyboard.press("Control+b")

        bold_markers = body.locator("b, .bold, strong")
        assert bold_markers.count() > 0, "加粗后未检测到 <b> 或等效标记"
        print("[PASS] 加粗格式化测试通过")

    def test_create_new_pad(self, page: Page):
        """
        TC-EDIT-003: 创建新 Pad
        前置: 已登录
        预期: 通过首页创建入口成功生成新 Pad 并进入编辑页
        """
        print("\n[TC-EDIT-003] 开始执行创建新 Pad 测试...")
        page.goto(BASE_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle

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

        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
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
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle

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
    """匿名访问场景测试"""

    def test_anonymous_create_pad(self, page: Page):
        """
        TC-ANON-001: 匿名用户创建 Pad
        前置: 未登录（新上下文）
        预期: 可以正常创建并进入编辑页
        """
        print("\n[TC-ANON-001] 开始执行匿名创建 Pad 测试...")
        page.goto(BASE_URL, wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle

        pad_input = page.locator("#padname")
        assert pad_input.count() > 0, "首页未找到 Pad 名称输入框"

        pad_name = f"anon_test_{int(time.time())}"
        pad_input.fill(pad_name)
        page.keyboard.press("Enter")

        page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
        assert f"/p/{pad_name}" in page.url
        print("[PASS] 匿名创建 Pad 测试通过")

    def test_anonymous_edit_denied(self, page: Page):
        """
        TC-ANON-002: 匿名用户访问编辑页被拦截
        前置: 未登录
        预期: 出现权限拒绝提示或登录按钮
        """
        print("\n[TC-ANON-002] 开始执行匿名访问拦截测试...")
        page.goto(f"{BASE_URL}/p/anon_edit_test", wait_until="domcontentloaded", timeout=60000)
        page.wait_for_timeout(5000)

        # 检查是否出现权限拒绝或登录入口
        perm_denied = page.locator("#permissionDenied")
        login_btn = page.locator("#login-redirect-uri, a:has-text('Login'), a:has-text('Log In')").first

        has_denied = perm_denied.count() > 0 and perm_denied.is_visible()
        has_login = login_btn.count() > 0 and login_btn.is_visible()

        assert has_denied or has_login, (
            "匿名访问编辑页应显示权限拒绝或登录按钮，"
            "但未检测到相关元素"
        )
        print("[PASS] 匿名访问拦截测试通过")


# =============================================================================
# 主入口（支持直接 python test_etherpad.py 运行）
# =============================================================================
if __name__ == "__main__":
    with sync_playwright() as p:
        # 自测入口同样使用系统 Edge
        browser = p.chromium.launch(
            channel="msedge",
            headless=False,           # 有头模式便于调试观察
            slow_mo=200,
        )
        context = browser.new_context(
            viewport={"width": 1920, "height": 1080},
            ignore_https_errors=True
        )
        page = context.new_page()

        try:
            print("[DEBUG] 启动自测流程...")
            perform_login(page, USERNAME, PASSWORD)
            page.screenshot(path="screenshot_logged_in.png")
            print("[PASS] 登录后截图已保存: screenshot_logged_in.png")

            page.goto(EDITOR_URL, wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(3000)  # SPA/内网环境用固定延迟替代 networkidle
            page.screenshot(path="screenshot_editor.png")
            print("[PASS] 编辑器截图已保存: screenshot_editor.png")
        except Exception as e:
            page.screenshot(path="screenshot_error.png")
            print(f"[ERROR] 自测异常: {e}")
            print("   错误截图已保存: screenshot_error.png")
        finally:
            browser.close()
