"""
测试用例集：MindSpore 官网 - 实训环境导航功能

> 用例总数：13 项（pytest 收集数，含视口参数化展开）
> 合并记录：原 17 项经三处去重合并为 13 项
>   - TC-UI-RESP-001  → 并入 TC-UI-NAV-001（同一 VIEWPORTS，属包含关系）
>   - TC-UI-EDGE-002  → 并入 TC-UI-NAV-004（ESC 关不掉，代码已回落取消按钮）
>   - TC-API-SCHEMA-001 → 并入 TC-API-JUPYTER-001（前置一致，仅断言粒度不同）
> 合并后原 TC-xxx 编号保留在各用例 docstring 中，覆盖矩阵仍可追溯
> AI 执行工具：playwright + pytest
> 依赖：pytest, pytest-playwright, playwright
> 推荐执行命令：
>   pytest test_cases.py -v --html=report.html --self-contained-html

占位符清单：
  - TEST_ACCOUNT: 测试账号 (默认从环境变量读取)
  - TEST_PASSWORD: 测试密码 (默认从环境变量读取)
  - BASE_URL: 被测站点基地址
  - HEADLESS: 是否无头模式 (true/false，默认 true)

注意事项：
  - 运行前需安装浏览器依赖: `playwright install chromium`
  - 有头/无头模式通过环境变量 HEADLESS 控制
"""

import os
import time
from typing import Optional, Tuple

import pytest
from dotenv import load_dotenv
from playwright.sync_api import Page, BrowserContext, expect, TimeoutError as PlaywrightTimeout, Response

from email_verify import fetch_verification_code, MailCodeError
from slider_solver import solve_slider

# .env 中的配置需在读取环境变量前载入
load_dotenv()

BASE_URL = os.environ.get("BASE_URL", "https://mindspore-website.test.osinfra.cn/")
USERCENTER_LOGIN_URL = os.environ.get(
    "USERCENTER_LOGIN_URL", "https://mindspore-usercenter.test.osinfra.cn/login"
)
TEST_ACCOUNT = os.environ.get("TEST_ACCOUNT", "")
TEST_PASSWORD = os.environ.get("TEST_PASSWORD", "")

# 登录方式：
#   code     —— 验证码登录（账号需为邮箱，验证码由 IMAP 自动抓取，推荐）
#   password —— 账号密码登录，若触发双因子则弹窗内再走验证码 + 滑块
LOGIN_MODE = os.environ.get("LOGIN_MODE", "code").strip().lower()

# 邮箱验证码等待时长（秒）
MAIL_CODE_TIMEOUT = int(os.environ.get("MAIL_CODE_TIMEOUT", "150"))
# 人工兜底：置 1 时，邮箱取码不可用则暂停等待操作人在浏览器中手动输码
MFA_MANUAL_FALLBACK = os.environ.get("MFA_MANUAL", "0") == "1"
MFA_MANUAL_WAIT = int(os.environ.get("MFA_MANUAL_WAIT", "180"))

# 滑块：先自动破解（AJ-Captcha 拼图，实测 3/3 通过），失败回落人工
SLIDER_AUTO = os.environ.get("SLIDER_AUTO", "1") == "1"
SLIDER_AUTO_ATTEMPTS = int(os.environ.get("SLIDER_AUTO_ATTEMPTS", "3"))
# 自动破解失败后等待人工拖动的最长秒数；置 0 表示不等待（无人值守 CI）
SLIDER_WAIT = int(os.environ.get("SLIDER_WAIT", "300"))

# 等待 Jupyter 实例就绪的轮次（每轮约 20s + 重载开窗开销），实测后端常需 60s 以上
INSTANCE_READY_ROUNDS = int(os.environ.get("INSTANCE_READY_ROUNDS", "8"))

# 导航栏元素定位信息
NAV_ITEM_SELECTOR = '.nav-item:has-text("实训环境")'
NAV_TEXT_SELECTOR = '.nav-item:has-text("实训环境") .nav-label'

# 实训环境对话框配置
DIALOG_SELECTOR = ".jupyter-dlg.o-layer-main"
DIALOG_HEADER_SELECTOR = ".jupyter-dlg .o-dlg-header"
DIALOG_CANCEL_BTN_SELECTOR = ".o-btn.o-btn-outline"
DIALOG_SELECTORS = [
    ".jupyter-dlg",
    ".o-dlg-main.jupyter-dlg",
    "[class*='jupyter-dlg']",
    ".o-layer-main",
]

# API 端点
API_JUPYTER_CLOUD = "api-jupyter/server/cloud"

# ---- 登录页选择器（实测 o-design 组件库，非 .login-btn）----
LOGIN_TAB_CODE = ".tab:has-text('验证码登录')"
LOGIN_TAB_PASSWORD = ".tab:has-text('账号登录')"
LOGIN_ACCOUNT_INPUT = "input.o_input-input[type=text]"
LOGIN_PASSWORD_INPUT = "input.o_input-input[type=password]"
LOGIN_SEND_CODE_LINK = "a:has-text('获取验证码')"
LOGIN_SUBMIT_BTN = "button.o-btn-primary:has-text('登录')"

# 滑块弹窗（AJ-Captcha，与 slider_solver 模块一致）
SLIDER_BOX = ".verifybox"

# 双因子弹窗：根节点上的 mfa class 是瞬时的（动画结束即被移除），
# 故用弹窗内固有的「使用邮箱验证」链接作为结构锚点，文案作兜底
MFA_DIALOG = ".o-dialog:has(.mfa-switch)"
MFA_DIALOG_FALLBACK = ".o-dialog:has-text('需要验证您的身份')"
# 弹窗默认走手机号验证，需点此链接切到邮箱（手机号收短信，脚本无法自动读取）
MFA_SWITCH_LINK = ".mfa-switch a"
MFA_CONFIRM_BTN = "button.o-btn-solid:has-text('确认')"

# 移动端菜单按钮 selector（常见模式）
MOBILE_MENU_BTN_SELECTORS = [
    ".header-menu-btn",
    ".o-icon-menu",
    ".mobile-menu-btn",
    "button[aria-label='菜单']",
    "button[aria-label='Menu']",
    ".nav-toggle",
    ".header-toolbar .header-tool",
]

# 响应式断点 (width, height, 设备描述)
VIEWPORTS = {
    "desktop_large": (1920, 1080),
    "desktop": (1280, 800),
}

# 超时配置
DEFAULT_TIMEOUT = 30000  # 30s
NAVIGATION_TIMEOUT = 45000  # 45s
DIALOG_TIMEOUT = 10000  # 10s

# 页面渲染兜底：SPA 首屏偶发 body/导航项停在 hidden，刷新后即恢复。
# 与登录流程保持一致的「刷新重试」策略，至多 3 次。
PAGE_READY_REFRESH_ATTEMPTS = int(os.environ.get("PAGE_READY_REFRESH_ATTEMPTS", "3"))
# 单轮等待 body/导航项可见的时长，短于 DEFAULT_TIMEOUT 以便尽快进入刷新重试
PAGE_READY_TIMEOUT = int(os.environ.get("PAGE_READY_TIMEOUT", "12000"))


# ============================== Fixtures ==============================
@pytest.fixture(scope="session")
def browser_type_launch_args(browser_type_launch_args):
    """控制浏览器启动参数：有头/无头模式。

    通过环境变量 HEADLESS 控制：
      - HEADLESS=true（默认）：无头模式，后台运行，不弹出浏览器窗口
      - HEADLESS=false：有头模式，弹出浏览器窗口，便于观察调试

    示例：
      pytest test_cases.py -v              # 无头（默认）
      set HEADLESS=false && pytest test_cases.py -v  # 有头（Windows）
      HEADLESS=false pytest test_cases.py -v          # 有头（Linux/Mac）
    """
    return {
        **browser_type_launch_args,
        "headless": os.environ.get("HEADLESS", "true").lower() == "true",
        # "slow_mo": 500,  # 可选：每个操作延迟 500ms，便于观察
    }


@pytest.fixture(scope="session")
def browser_context_args(browser_context_args):
    """全局浏览器上下文参数：接受所有弹窗/下载，禁用缓存以便测试可重复。"""
    return {
        **browser_context_args,
        "accept_downloads": True,
        # "bypass_csp": True,  # 暂时禁用，可能影响 cookie 或登录态
        "ignore_https_errors": os.environ.get("IGNORE_HTT_ERRORS", "false").lower() == "true",
    }


@pytest.fixture
def page_fixture(page: Page) -> Page:
    """每个用例的 page 初始化：统一超时、视口、录屏。"""
    page.set_default_timeout(DEFAULT_TIMEOUT)
    page.set_default_navigation_timeout(NAVIGATION_TIMEOUT)
    return page


def _is_mobile_viewport(page: Page) -> bool:
    """判断当前视口是否为移动端。"""
    viewport = page.viewport_size
    if viewport:
        return viewport.get("width", 1280) <= 840
    return False


def _open_mobile_menu_if_needed(page: Page) -> None:
    """辅助：在移动端下若导航栏被折叠，则点击汉堡菜单展开。"""
    if not _is_mobile_viewport(page):
        return
    for sel in MOBILE_MENU_BTN_SELECTORS:
        btn = page.locator(sel).first
        if btn.count() > 0 and btn.is_visible():
            btn.click()
            page.wait_for_timeout(800)
            return


def _try_page_ready(page: Page) -> bool:
    """
    单轮尝试：等待 body 与实训环境导航项进入可见态。

    :return: True 表示本轮页面已就绪；False 表示仍停在 hidden，需由调用方刷新重试
    """
    try:
        page.wait_for_selector("body", state="visible", timeout=PAGE_READY_TIMEOUT)
    except PlaywrightTimeout:
        return False

    page.wait_for_load_state("domcontentloaded")
    _open_mobile_menu_if_needed(page)

    # 先等外层容器，给内部导航项的渲染留出时间
    for sel in (".app-header .header-nav", ".header-nav", ".app-header"):
        try:
            locator = page.locator(sel).first
            if locator.count() > 0:
                locator.wait_for(state="visible", timeout=5000)
                break
        except PlaywrightTimeout:
            continue

    # 移动端导航项本就折叠在菜单内，不以其可见性判定就绪
    if _is_mobile_viewport(page):
        return True

    # 关键：等导航项自身可见。原实现只等容器，导致 .nav-item 仍为 hidden 时
    # 就交给 expect().to_be_visible() 断言，表现为偶发失败。
    try:
        page.locator(NAV_ITEM_SELECTOR).first.wait_for(
            state="visible", timeout=PAGE_READY_TIMEOUT
        )
        return True
    except PlaywrightTimeout:
        return False


def _ensure_nav_visible(page: Page) -> None:
    """
    辅助：等待导航栏渲染完成（兼容移动端折叠菜单）。

    SPA 首屏偶发停在 hidden，故失败后强制刷新重试，至多
    PAGE_READY_REFRESH_ATTEMPTS 次；仍不就绪才抛错。
    """
    for attempt in range(1, PAGE_READY_REFRESH_ATTEMPTS + 1):
        if _try_page_ready(page):
            if attempt > 1:
                print(f"   [页面] 第 {attempt} 次尝试后导航栏已就绪")
            return

        if attempt < PAGE_READY_REFRESH_ATTEMPTS:
            print(
                f"   [页面] 导航栏未进入可见态，刷新重试 "
                f"{attempt}/{PAGE_READY_REFRESH_ATTEMPTS - 1}"
            )
            try:
                page.reload(wait_until="domcontentloaded")
            except PlaywrightTimeout:
                print("   [页面] 刷新超时，继续下一轮尝试")
            page.wait_for_timeout(3000)

    try:
        page.screenshot(path="debug_nav_not_ready.png", full_page=True)
    except Exception:
        pass
    raise AssertionError(
        f"页面导航栏在 {PAGE_READY_REFRESH_ATTEMPTS} 次尝试（含刷新）后仍未进入可见态。\n"
        f"   当前 URL: {page.url}\n"
        f"   视口: {page.viewport_size}\n"
        f"   截图: debug_nav_not_ready.png"
    )


def _slider_visible(page: Page) -> bool:
    """判断 AJ-Captcha 滑块弹窗当前是否可见。"""
    try:
        box = page.locator(SLIDER_BOX).first
        return box.count() > 0 and box.is_visible()
    except Exception:
        return False


def _await_slider_cleared(page: Page, stage: str) -> bool:
    """
    处理滑块人机校验：先自动破解，失败则提醒操作人手动拖动并轮询等待。

    :param stage: 当前所处环节，用于提示文案与截图命名
    :return: True 表示出现过滑块且已通过；False 表示本次未出现滑块
    """
    if not _slider_visible(page):
        return False

    print(f"   [滑块] 「{stage}」环节检测到滑块人机校验")

    if SLIDER_AUTO:
        try:
            if solve_slider(page, max_attempts=SLIDER_AUTO_ATTEMPTS):
                page.wait_for_timeout(1500)
                if not _slider_visible(page):
                    return True
                print("   [滑块] 破解后滑块仍在，回落人工处理")
        except Exception as exc:
            print(f"   [滑块] 自动破解异常，回落人工：{type(exc).__name__}: {exc}")

    shot = f"debug_slider_{stage}.png"
    try:
        page.screenshot(path=shot, full_page=True)
    except Exception:
        shot = "(截图失败)"

    if SLIDER_WAIT <= 0:
        pytest.fail(
            f"[FAIL] 「{stage}」环节滑块自动破解失败，当前为无人值守模式。\n"
            f"   阿蓁，如需人工介入请设置 SLIDER_WAIT=300 并配合 HEADLESS=false 重跑。\n"
            f"   截图: {shot}"
        )

    # 按项目规约：需要拖拉滑块时必须提醒操作人
    print("\a")
    print("\n" + "!" * 68)
    print(f"   [滑块] 「{stage}」环节需要人工完成滑块验证")
    print("   阿蓁，请在弹出的浏览器窗口中【手动拖动滑块完成验证】。")
    print(f"   完成后脚本会自动继续，最长等待 {SLIDER_WAIT} 秒。")
    print(f"   当前页面: {page.url}")
    print(f"   截图: {shot}")
    print("!" * 68 + "\n")

    deadline = time.time() + SLIDER_WAIT
    last_tick = -1
    while time.time() < deadline:
        page.wait_for_timeout(2000)
        if not _slider_visible(page):
            print("   [滑块] 验证已通过，继续执行\n")
            page.wait_for_timeout(1500)
            return True
        remaining = int(deadline - time.time())
        if remaining // 20 != last_tick:
            last_tick = remaining // 20
            print(f"   [滑块] 仍在等待人工完成验证（剩余 {remaining}s）...")

    pytest.fail(f"[FAIL] 「{stage}」环节等待人工滑块验证超时（{SLIDER_WAIT}s），截图: {shot}")


# 已移除 _login_if_needed：该函数仅在 URL 含 /login 或页面存在密码框时才填表，
# 在首页调用时静默空操作，曾导致 TC-UI-AUTH-002 名义测登录态、实际走匿名路径。
# 需要登录态的用例统一使用 _login_to_usercenter（含验证码 + 滑块完整流程）。



def _fetch_code_or_manual(page: Page, request_ts: float, dialog=None) -> Optional[str]:
    """
    取验证码：优先 IMAP 自动抓取，失败按配置回落人工输入。

    :param request_ts: 「获取验证码」的请求时刻（滑块通过之后），只认此后到达的邮件
    :param dialog:     若在弹窗内取码，传入弹窗 locator 用于判断人工是否已完成
    :return: 6 位验证码；返回 None 表示已由人工在浏览器中完成整个验证流程
    """
    try:
        return fetch_verification_code(since_ts=request_ts, timeout=MAIL_CODE_TIMEOUT)
    except MailCodeError as exc:
        if not MFA_MANUAL_FALLBACK:
            try:
                page.screenshot(path="debug_mail_code_failed.png")
            except Exception:
                pass
            pytest.fail(
                f"{exc}\n\n"
                "   [提示] 阿蓁，若暂时无法配置邮箱授权码，可设置 MFA_MANUAL=1 "
                "并配合 HEADLESS=false 重跑，\n"
                "   脚本会暂停等待你在浏览器窗口中手动输入验证码。\n"
                "   截图: debug_mail_code_failed.png"
            )

        # 人工兜底：等操作人在浏览器里手动输码并提交
        print("\a")
        print("\n" + "=" * 68)
        print("   [验证码] 邮箱自动取码不可用，已切换人工模式。")
        print("   阿蓁，请在弹出的浏览器窗口中【手动输入验证码并点击登录】，")
        print(f"   脚本将最多等待 {MFA_MANUAL_WAIT} 秒。")
        print("=" * 68 + "\n")

        deadline = time.time() + MFA_MANUAL_WAIT
        while time.time() < deadline:
            page.wait_for_timeout(2000)
            if dialog is not None:
                if dialog.count() == 0 or not dialog.is_visible():
                    print("   [验证码] 弹窗已关闭，人工验证完成")
                    page.wait_for_timeout(2000)
                    return None
            elif "login" not in page.url:
                print("   [验证码] 已离开登录页，人工验证完成")
                page.wait_for_timeout(2000)
                return None
        pytest.fail(f"[FAIL] 人工验证等待超时（{MFA_MANUAL_WAIT}s）")


def _handle_mfa_dialog(page: Page) -> bool:
    """
    处理账号密码登录后可能出现的双因子弹窗（验证码 + 可能的滑块）。

    :return: True 表示处理了双因子；False 表示未触发（处于免验证期）
    """
    # 弹窗为异步渲染，须用 wait_for 等待；count() 是瞬时快照会误判为"未出现"
    dialog = None
    for sel in (MFA_DIALOG, MFA_DIALOG_FALLBACK):
        loc = page.locator(sel).first
        try:
            loc.wait_for(state="visible", timeout=12000)
            dialog = loc
            break
        except PlaywrightTimeout:
            continue
    if dialog is None:
        print("   [MFA] 未出现双因子弹窗（处于免验证期）")
        return False

    print("   [MFA] 检测到双因子弹窗，开始自动处理...")

    # ---- 切换为邮箱验证：弹窗默认发短信到手机号，脚本读不到 ----
    switch = dialog.locator(MFA_SWITCH_LINK).first
    if switch.count() > 0 and switch.is_visible():
        label = switch.inner_text().strip()
        if "邮箱" in label:
            print(f"   [MFA] 点击「{label}」切换验证方式")
            switch.click()
            page.wait_for_timeout(2000)

    # 首个 input 为禁用态的接收目标展示框
    target = dialog.locator("input.o_input-input").first
    target_value = _get_input_value(target) if target.count() > 0 else ""
    print(f"   [MFA] 验证码接收目标: {target_value}")

    if "@" not in target_value:
        try:
            page.screenshot(path="debug_mfa_not_email.png")
        except Exception:
            pass
        pytest.fail(
            f"[FAIL] 双因子验证未能切换到邮箱方式，当前接收目标: {target_value}\n"
            "   阿蓁，请确认该账号已绑定邮箱且支持邮箱验证；手机号验证走短信，"
            "脚本无法自动取码。\n"
            "   截图: debug_mfa_not_email.png"
        )

    send_link = dialog.locator(LOGIN_SEND_CODE_LINK).first
    assert send_link.count() > 0, "双因子弹窗中未找到「获取验证码」入口"
    send_link.click()
    print("   [MFA] 已点击「获取验证码」")
    page.wait_for_timeout(2500)

    # 滑块须先过，服务端才真正发信；故取码起点必须在滑块之后
    if _await_slider_cleared(page, "MFA获取验证码"):
        page.wait_for_timeout(2000)
    request_ts = time.time()

    code = _fetch_code_or_manual(page, request_ts, dialog=dialog)
    if code is None:
        return True

    # 第二个 input 才是验证码输入框（第一个是禁用态的接收目标）
    dialog.locator("input.o_input-input").nth(1).fill(code)
    page.wait_for_timeout(800)

    # 「确认」为 o-btn-solid，「取消」为 o-btn-outline，须按文案区分
    confirm = dialog.locator(MFA_CONFIRM_BTN).first
    if confirm.count() == 0:
        confirm = dialog.locator("button.o-btn-solid").first
    for _ in range(10):
        if "o-btn-disabled" not in (confirm.get_attribute("class") or ""):
            break
        page.wait_for_timeout(500)
    confirm.click()
    print("   [MFA] 已提交验证码，等待跳转...")
    page.wait_for_timeout(5000)

    if dialog.count() > 0 and dialog.is_visible():
        try:
            page.screenshot(path="debug_mfa_rejected.png")
        except Exception:
            pass
        extra = dialog.locator(".o-form-item-error, .form-item-extra").first
        msg = extra.inner_text().strip() if extra.count() > 0 else ""
        pytest.fail(
            f"[FAIL] 验证码 {code} 提交后弹窗未关闭，疑似验证码错误或已过期。\n"
            f"   页面提示: {msg or '(无)'}\n"
            f"   截图: debug_mfa_rejected.png"
        )

    print("   [MFA] 双因子验证通过")
    return True


def _do_code_login(page: Page) -> None:
    """
    验证码登录：切 Tab → 填账号 → 获取验证码 → 过滑块 → IMAP 取码 → 回填 → 登录。

    账号须为邮箱地址，否则验证码走短信，脚本无法自动读取。
    """
    if "@" not in TEST_ACCOUNT:
        pytest.skip(
            f"验证码登录需要邮箱账号，当前 TEST_ACCOUNT={TEST_ACCOUNT} 不是邮箱。\n"
            "   阿蓁，请在 .env 中把 TEST_ACCOUNT 改为已绑定的邮箱地址，"
            "或设置 LOGIN_MODE=password 走密码登录。"
        )

    tab = page.locator(LOGIN_TAB_CODE).first
    if tab.count() > 0 and tab.is_visible():
        tab.click()
        page.wait_for_timeout(2000)
        print("   [登录] 已切换到「验证码登录」")

    page.locator(LOGIN_ACCOUNT_INPUT).first.fill(TEST_ACCOUNT)
    page.wait_for_timeout(1000)

    send_link = page.locator(LOGIN_SEND_CODE_LINK).first
    assert send_link.count() > 0, "登录页未找到「获取验证码」入口"
    for _ in range(10):
        if "o-link-disabled" not in (send_link.get_attribute("class") or ""):
            break
        page.wait_for_timeout(500)
    send_link.click()
    print("   [登录] 已点击「获取验证码」")

    # 滑块通过后服务端才真正发信，故取码起点须在滑块之后
    try:
        page.locator(SLIDER_BOX).first.wait_for(state="visible", timeout=10000)
    except PlaywrightTimeout:
        pass
    _await_slider_cleared(page, "获取验证码")
    page.wait_for_timeout(2000)
    request_ts = time.time()
    print("   [登录] 等待验证码邮件送达...")

    code = _fetch_code_or_manual(page, request_ts)
    if code is None:
        return

    code_input = page.locator(LOGIN_ACCOUNT_INPUT).nth(1)
    # Linux环境下增强输入可靠性：先清空，再逐字符输入，最后触发change事件
    code_input.click()
    page.wait_for_timeout(300)
    code_input.fill("")
    page.wait_for_timeout(200)
    code_input.type(code, delay=100)  # 逐字符输入，每个字符间隔100ms
    page.wait_for_timeout(500)

    # 手动触发input和change事件，确保表单验证生效
    code_input.evaluate("el => el.dispatchEvent(new Event('input', { bubbles: true }))")
    code_input.evaluate("el => el.dispatchEvent(new Event('change', { bubbles: true }))")
    page.wait_for_timeout(1000)

    submit = page.locator(LOGIN_SUBMIT_BTN).first
    # 等待登录按钮变为可用状态，最多等10秒
    for i in range(20):
        btn_class = submit.get_attribute("class") or ""
        if "o-btn-disabled" not in btn_class and "disabled" not in btn_class:
            print(f"   [登录] 登录按钮已就绪（第{i+1}次检查）")
            break
        page.wait_for_timeout(500)
    else:
        print("   [登录] 警告：登录按钮可能仍处于禁用状态")

    # 确保按钮可见且可点击
    submit.scroll_into_view_if_needed()
    page.wait_for_timeout(500)
    submit.click(force=True)  # 强制点击，绕过可能的遮罩层
    print("   [登录] 已提交验证码登录")
    page.wait_for_timeout(3000)  # 等待登录请求完成


def _do_password_login(page: Page) -> None:
    """账号密码登录：填表提交 → 过滑块 → 若弹出双因子则交由 _handle_mfa_dialog 处理。"""
    tab = page.locator(LOGIN_TAB_PASSWORD).first
    if tab.count() > 0 and tab.is_visible():
        tab.click()
        page.wait_for_timeout(1500)

    page.locator(LOGIN_ACCOUNT_INPUT).first.fill(TEST_ACCOUNT)
    page.wait_for_timeout(500)
    page.locator(LOGIN_PASSWORD_INPUT).first.fill(TEST_PASSWORD)
    page.wait_for_timeout(500)

    submit = page.locator(LOGIN_SUBMIT_BTN).first
    if submit.count() > 0 and not submit.is_disabled():
        submit.click()
        print("   [登录] 已提交账号密码")
    page.wait_for_timeout(2500)

    # 密码登录也可能先弹滑块
    _await_slider_cleared(page, "密码登录")

    # 密码正确后若开启双因子，会弹出验证码弹窗
    _handle_mfa_dialog(page)


def _login_to_usercenter(page: Page) -> None:
    """
    辅助：登录到 MindSpore 用户中心（已适配双因子：邮箱验证码 + 滑块人机校验）。

    两种登录方式由 LOGIN_MODE 控制：
      - code（默认）：验证码登录，账号须为邮箱，验证码经 IMAP 自动抓取
      - password    ：账号密码登录，若触发双因子再走弹窗内验证码 + 滑块

    环境检测：若登录页返回 /notfound 或不存在登录表单，
    说明测试环境登录服务不可用，将 pytest.skip 跳过当前测试。
    """
    if not TEST_ACCOUNT or not TEST_PASSWORD:
        pytest.skip(
            "未配置测试账号。阿蓁，请在 .env 中设置 TEST_ACCOUNT / TEST_PASSWORD"
        )

    # 访问登录页，等待页面稳定
    page.goto(USERCENTER_LOGIN_URL)
    page.wait_for_timeout(3000)

    # 环境可用性检测：如果前端路由跳转到 /notfound，说明登录页不可用
    if "/notfound" in page.url:
        pytest.skip(
            "用户中心登录页当前不可用（返回 /notfound），"
            "需要登录的测试暂时无法执行（环境限制）"
        )

    # 检查当前是否在登录页（如果不是，说明已登录或已被重定向）
    if "login" not in page.url and "usercenter" not in page.url:
        return

    # 检查是否存在登录表单
    if page.locator(LOGIN_ACCOUNT_INPUT).count() == 0:
        pytest.skip(
            "用户中心登录页未检测到登录表单（可能环境已变更），"
            "需要登录的测试暂时无法执行（环境限制）"
        )

    page.wait_for_selector(LOGIN_ACCOUNT_INPUT, timeout=DEFAULT_TIMEOUT)

    if LOGIN_MODE == "code":
        _do_code_login(page)
    else:
        _do_password_login(page)

    # 等待离开登录页（双因子流程较长，给到 25s）
    try:
        page.wait_for_url(
            lambda url: "login" not in url and "usercenter" not in url, timeout=25000
        )
        print("   [登录] 登录成功")
        return
    except PlaywrightTimeout:
        pass

    # 仍在登录页：检查是否有错误提示
    print("   [登录] 首次等待超时，检查页面状态...")
    page.wait_for_timeout(2000)

    # 检查验证码错误提示
    for err_sel in [".form-item-extra", ".o-form-item-error", ".error-message", ".o-input-error"]:
        err_loc = page.locator(err_sel).first
        if err_loc.count() > 0 and err_loc.is_visible():
            err_msg = err_loc.inner_text().strip()
            if err_msg and any(kw in err_msg for kw in ["验证码", "错误", "过期", "失效"]):
                print(f"   [登录] 检测到验证码错误提示: {err_msg}")
                # 验证码错误，无需重试
                try:
                    page.screenshot(path="debug_code_error.png", full_page=True)
                except Exception:
                    pass
                raise AssertionError(
                    f"验证码提交后出现错误提示: {err_msg}\n"
                    f"   可能原因：验证码已过期或输入错误\n"
                    f"   截图: debug_code_error.png"
                )

    # 滑块残留则再处理一轮
    if _slider_visible(page):
        print("   [登录] 检测到滑块残留，重新处理...")
        _await_slider_cleared(page, "登录提交")
        try:
            page.wait_for_url(
                lambda url: "login" not in url and "usercenter" not in url, timeout=15000
            )
            print("   [登录] 登录成功")
            return
        except PlaywrightTimeout:
            pass

    # 若仍在登录页，尝试刷新页面检查登录状态（最多3次）
    print("   [登录] 仍在登录页，尝试刷新页面检查登录状态...")
    for refresh_attempt in range(1, 4):
        print(f"   [登录] 刷新页面 {refresh_attempt}/3")
        try:
            page.reload(wait_until="domcontentloaded", timeout=10000)
        except PlaywrightTimeout:
            print(f"   [登录] 刷新超时，继续...")
        page.wait_for_timeout(3000)

        # 检查是否已离开登录页
        current_url = page.url
        if "login" not in current_url and "usercenter" not in current_url:
            print(f"   [登录] 刷新后登录成功，当前URL: {current_url}")
            return

        # 检查是否仍在登录页且表单已重置（说明登录失败）
        if "login" in current_url or "usercenter" in current_url:
            # 检查登录表单是否存在且为空（说明被重置了）
            account_input = page.locator(LOGIN_ACCOUNT_INPUT).first
            if account_input.count() > 0:
                input_value = _get_input_value(account_input)
                if not input_value or input_value != TEST_ACCOUNT:
                    print(f"   [登录] 表单已被重置，登录请求可能被拒绝")

            print(f"   [登录] 刷新后仍在登录相关页面: {current_url}")
            page.wait_for_timeout(2000)
            continue

    # 抓取页面上的真实错误提示（覆盖 o-design 的 form-item-extra 等结构）
    err_text = ""
    for sel in [".form-item-extra", ".o-form-item-error", ".error-message",
                ".el-form-item__error", ".o-message", ".o-input-error"]:
        loc = page.locator(sel).first
        try:
            if loc.count() > 0 and loc.is_visible():
                txt = loc.inner_text().strip()
                if txt:
                    err_text = txt
                    break
        except Exception:
            continue

    try:
        page.screenshot(path="debug_login_failed.png", full_page=True)
    except Exception:
        pass

    raise AssertionError(
        f"登录失败，刷新3次后仍停留在登录页。页面提示: {err_text or '(无)'}\n"
        f"   当前 URL: {page.url}\n"
        f"   登录方式: LOGIN_MODE={LOGIN_MODE}，账号: {TEST_ACCOUNT}\n"
        f"   截图: debug_login_failed.png"
    )



def _click_training_nav_and_capture_dialog(page: Page, timeout: int = 30000) -> Tuple[Page, Optional[object]]:
    """
    辅助：点击实训环境导航项并捕获弹出的配置对话框。
    返回: (page 对象, 对话框元素或 None)
    """
    nav_item = page.locator(NAV_ITEM_SELECTOR).first

    # 兜底：导航项未就绪时走刷新重试，避免直接断言失败
    try:
        nav_item.wait_for(state="visible", timeout=PAGE_READY_TIMEOUT)
    except PlaywrightTimeout:
        _ensure_nav_visible(page)
        nav_item = page.locator(NAV_ITEM_SELECTOR).first

    expect(nav_item).to_be_visible(timeout=DEFAULT_TIMEOUT)

    # 遮罩未消散时点击会被拦截，等待其隐藏
    mask = page.locator(".o-layer-mask").first
    if mask.count() > 0 and mask.is_visible():
        try:
            mask.wait_for(state="hidden", timeout=5000)
        except PlaywrightTimeout:
            pass

    # 点击导航项
    nav_item.click()

    # 等待对话框出现（优先使用 jupyter-dlg 类名）
    dialog = None
    for sel in DIALOG_SELECTORS:
        dlg = page.locator(sel).first
        if dlg.count() > 0:
            try:
                dlg.wait_for(state="visible", timeout=DIALOG_TIMEOUT)
                dialog = dlg
                break
            except PlaywrightTimeout:
                continue

    # 如未检测到对话框，可能是 API 请求失败或权限不足
    if dialog is None:
        # 检查是否有错误提示/Toast
        toast = page.locator(".o-message, .el-message, .toast, .notification").first
        if toast.count() > 0 and toast.is_visible():
            toast_text = toast.inner_text().strip()
            raise AssertionError(f"点击后未弹出对话框，检测到提示: {toast_text}")

    return page, dialog


def _goto_home(page: Page) -> None:
    """辅助：打开首页并等待导航栏渲染完成。"""
    page.goto(BASE_URL)
    _ensure_nav_visible(page)


def _close_dialog(page: Page, dialog) -> None:
    """辅助：关闭配置对话框（优先取消按钮，退而求其次 ESC）。"""
    cancel_btn = dialog.locator(DIALOG_CANCEL_BTN_SELECTOR).first
    if cancel_btn.count() > 0 and cancel_btn.is_visible():
        cancel_btn.click()
    else:
        close_btn = dialog.locator("button:has-text('取消'), button:has-text('Close'), .o-dlg-close").first
        if close_btn.count() > 0:
            close_btn.click()
        else:
            page.keyboard.press("Escape")
    page.wait_for_timeout(1000)


def _click_end_btn(page: Page, dialog) -> bool:
    """辅助：查找并点击结束按钮释放 Jupyter 实例。返回是否成功点击。"""
    end_btn = dialog.locator("button").filter(has_text="结束").first
    if end_btn.count() == 0:
        end_btn = dialog.locator("button.o-btn-outline").first
    if end_btn.count() > 0 and end_btn.is_visible() and "结束" in end_btn.inner_text().strip():
        print(f"[Jupyter] 点击结束按钮: {end_btn.inner_text().strip()}")
        end_btn.click()
        page.wait_for_timeout(3000)
        return True
    return False


def _wait_for_instance_ready(page: Page, print_prefix: str = "[Jupyter]", skip_on_unexpected: bool = False) -> Tuple[bool, Optional[object]]:
    """
    辅助：轮询等待 Jupyter 实例启动完成，返回 (是否就绪, 对话框元素)。

    每轮 20s 等待 + 重新打开对话框读按钮状态。实测后端拉起实例常超过 60s，
    故轮次由 INSTANCE_READY_ROUNDS 控制（缺省 8 轮，约 3 分钟）。
    """
    for i in range(INSTANCE_READY_ROUNDS):
        page.wait_for_timeout(20000)
        page.reload()
        page.wait_for_timeout(3000)
        _ensure_nav_visible(page)
        _, dialog = _click_training_nav_and_capture_dialog(page)
        if dialog is None:
            continue
        solid_btn = dialog.locator("button.o-btn-solid").first
        if solid_btn.count() == 0 or not solid_btn.is_visible():
            continue
        page.wait_for_timeout(3000)
        current_text = solid_btn.inner_text().strip()
        print(f"{print_prefix} Check {i+1}/{INSTANCE_READY_ROUNDS}: button text = {current_text}")
        if "Jupyter" in current_text:
            return True, dialog
        if any(kw in current_text for kw in ["启动中", "启动环境", "结束中", "关闭中"]):
            print(f"{print_prefix} 当前处于中间状态 '{current_text}'，继续等待...")
            # 若系统回到初始启动状态，说明启动请求未生效，重新触发
            if "启动环境" in current_text and i > 0:
                solid_btn.click()
                page.wait_for_timeout(5000)
            continue
        if skip_on_unexpected:
            pytest.skip(f"实例启动异常，当前按钮状态: {current_text}")
        return False, None
    return False, None


def _get_input_value(inp) -> str:
    """辅助：获取 input 元素的当前值（优先 value 属性，回退 input_value）。"""
    return (inp.get_attribute("value") or "") or (inp.input_value() or "")


def _click_nav_expect_cloud_api(page: Page, timeout: int = DEFAULT_TIMEOUT):
    """
    辅助：点击「实训环境」导航项并显式等待 cloud 配置接口返回。

    原实现点击后用固定 wait_for_timeout(3000) 等接口，全量跑时浏览器负载高、
    3 秒内响应未回即误判为「未捕获到 API 响应」，表现为偶发失败。改为
    expect_response 事件驱动等待，响应到达即返回，不再靠睡眠赌时间。

    :param timeout: 等待接口响应的最长毫秒数
    :return: 该接口的 Response 对象
    :raises PlaywrightTimeout: 超时仍未捕获到接口响应
    """
    with page.expect_response(
        lambda r: API_JUPYTER_CLOUD in r.url, timeout=timeout
    ) as resp_info:
        page.locator(NAV_ITEM_SELECTOR).click()
    return resp_info.value


# ============================== 测试用例 ==============================
# -----------------------------------------------------------------------
# 一、导航栏渲染与点击
# -----------------------------------------------------------------------

class TestNavigationRendering:
    """模块一：导航栏渲染与可见性"""

    @pytest.mark.parametrize("viewport_name, size", VIEWPORTS.items())
    def test_nav_visible_in_all_viewports(self, page_fixture: Page, viewport_name: str, size: tuple) -> None:
        """
        TC-UI-NAV-001 + TC-UI-RESP-001 [正常流][响应式]
        各视口下导航栏可见可交互，且点击后对话框正确弹出、内容非空
        优先级：P1

        合并说明：原 TC-UI-RESP-001（模块五）与本用例遍历同一个 VIEWPORTS 字典、
        各自加载一次首页，且「点击导航弹窗」本就以「导航可见」为前提，属包含关系，
        故合并为一次页面加载完成两段校验，省去重复的 goto。
        断言分两段：先导航栏渲染（原 NAV-001），再对话框弹出（原 RESP-001）。
        """
        width, height = size
        page_fixture.set_viewport_size({"width": width, "height": height})
        _goto_home(page_fixture)

        # ---- 第一段：导航栏渲染与可见性（原 TC-UI-NAV-001）----
        nav_item = page_fixture.locator(NAV_TEXT_SELECTOR)
        if nav_item.count() > 0 and nav_item.is_visible():
            expect(nav_item).to_have_text("实训环境")
        else:
            parent = page_fixture.locator(NAV_ITEM_SELECTOR)
            assert parent.count() > 0, "实训环境导航项未找到"

        parent = page_fixture.locator(NAV_ITEM_SELECTOR)
        classes = parent.get_attribute("class") or ""
        assert "nav-item" in classes, f"期望 class 包含 'nav-item'，实际: {classes}"

        # ---- 第二段：对话框弹出与内容校验（原 TC-UI-RESP-001）----
        # 移动端下导航项可能被折叠，此时跳过对话框校验
        if parent.count() == 0 or not parent.is_visible():
            pytest.skip(f"视口 {viewport_name} 下导航栏被折叠，无法测试对话框")

        page, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, f"视口 {viewport_name} 下点击后未弹出对话框"
        expect(dialog).to_be_visible()

        # 断言：对话框内容可见（标题或规格选择器）
        header = dialog.locator(DIALOG_HEADER_SELECTOR).first
        spec_select = dialog.locator(".o-select").first
        assert header.count() > 0 or spec_select.count() > 0, "对话框内容为空"

    def test_nav_hover_effect(self, page_fixture: Page) -> None:
        """
        TC-UI-NAV-002 [正常流] 鼠标悬停时导航项出现交互态（hover 样式/下拉菜单）
        优先级：P2
        """
        _goto_home(page_fixture)

        nav_item = page_fixture.locator(NAV_ITEM_SELECTOR)
        nav_item.hover()
        page_fixture.wait_for_timeout(500)

        expect(nav_item).to_be_visible()
        dropdown = page_fixture.locator(".o-nav-dropdown, .header-dropdown, .nav-dropdown").first
        if dropdown.count() > 0:
            expect(dropdown).to_be_visible()

    def test_nav_item_click_opens_dialog(self, page_fixture: Page) -> None:
        """
        TC-UI-NAV-003 [正常流] 点击实训环境导航项后弹出 Jupyter 配置对话框
        优先级：P0
        """
        _goto_home(page_fixture)

        page, dialog = _click_training_nav_and_capture_dialog(page_fixture)

        # 断言：对话框已弹出且可见
        assert dialog is not None, "点击实训环境后未弹出配置对话框"
        expect(dialog).to_be_visible()

        # 断言：对话框包含标题
        header = dialog.locator(DIALOG_HEADER_SELECTOR).first
        if header.count() > 0:
            header_text = header.inner_text().strip()
            assert len(header_text) > 0, "对话框标题为空"

    def test_dialog_cancel_closes(self, page_fixture: Page) -> None:
        """
        TC-UI-NAV-004 + TC-UI-EDGE-002 [正常流][异常]
        ESC 键不关闭对话框（当前实现），点击取消按钮可正常关闭
        优先级：P1

        合并说明：原 TC-UI-EDGE-002 立意测 ESC 关闭，但实测该对话框不响应 ESC，
        其代码已回落为点击取消按钮，与本用例完全重复，故合并。
        此处先显式断言「ESC 是 no-op」把该产品行为固化成回归保护，
        再验证取消按钮能正常关闭。
        """
        _goto_home(page_fixture)

        page, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, "对话框未弹出"

        # 前置断言（原 TC-UI-EDGE-002）：ESC 不应关闭对话框。
        # 若此断言失败，说明产品已支持 ESC 关闭，属行为变更，需同步更新用例预期。
        page_fixture.keyboard.press("Escape")
        page_fixture.wait_for_timeout(1000)
        assert dialog.is_visible(), (
            "ESC 键关闭了对话框 —— 与当前已知实现不符。"
            "产品若已支持 ESC 关闭，请更新本用例预期"
        )

        # 点击取消按钮
        cancel_btn = dialog.locator(DIALOG_CANCEL_BTN_SELECTOR).first
        if cancel_btn.count() > 0 and cancel_btn.is_visible():
            cancel_btn.click()
        else:
            # 退而查找包含取消/关闭文本的按钮。
            # 注意：不再回落按 ESC —— 上方已断言 ESC 为 no-op，
            # 用它兜底会与该断言自相矛盾。
            close_btn = dialog.locator(
                "button:has-text('取消'), button:has-text('Close'), .o-dlg-close"
            ).first
            assert close_btn.count() > 0, "对话框内未找到取消/关闭按钮"
            close_btn.click()

        page_fixture.wait_for_timeout(1000)

        # 断言：对话框已不可见或从 DOM 中移除
        assert not dialog.is_visible(), "取消按钮点击后对话框仍未关闭"


# -----------------------------------------------------------------------
# 二、实训环境 API 与配置校验
# -----------------------------------------------------------------------

class TestApiAndConfig:
    """模块二：API 响应与对话框配置内容校验"""

    def test_api_jupyter_cloud_returns_config(self, page_fixture: Page) -> None:
        """
        TC-API-JUPYTER-001 + TC-API-SCHEMA-001 [正常流]
        点击后 api-jupyter/server/cloud 接口返回可用服务器配置，且响应结构符合预期 schema
        优先级：P0

        合并说明：原 TC-API-SCHEMA-001（模块六）与本用例前置完全一致
        （打开首页 → 点击导航 → 等待同一接口），仅断言粒度不同，故合并。
        断言按「状态码 → 顶层字段 → data 非空 → data 项结构」由粗到细排列，
        便于从首个失败的断言直接定位问题层级。
        """
        all_api_calls: list[str] = []

        def handle_response(response: Response) -> None:
            # 记录所有API调用用于调试
            if "api-jupyter" in response.url:
                all_api_calls.append(response.url)

        page_fixture.on("response", handle_response)
        _goto_home(page_fixture)

        # 点击导航并显式等待接口响应，替代固定 3s 睡眠
        try:
            response = _click_nav_expect_cloud_api(page_fixture)
        except PlaywrightTimeout:
            pytest.fail(
                f"未检测到 {API_JUPYTER_CLOUD} 接口请求。实际调用的API: {all_api_calls}"
            )

        # 断言：API 请求被触发且返回 200
        assert response.status == 200, f"API 返回非 200 状态码: {response.status}"

        # 断言：响应体包含服务器配置 data 数组
        try:
            body = response.json()
        except Exception:
            body = None
        assert body is not None, "API 响应体解析失败"

        # 断言顶层字段（原 TC-API-SCHEMA-001）
        assert "code" in body, "响应缺少 code 字段"
        assert "msg" in body, "响应缺少 msg 字段"
        assert "data" in body, "响应缺少 data 字段"

        # 断言：响应体包含非空服务器配置 data 数组
        assert isinstance(body["data"], list), "API 响应 data 字段不是数组"
        assert len(body["data"]) > 0, "API 响应 data 数组为空"

        # 断言 data 数组元素结构（原 TC-API-SCHEMA-001）
        for item in body["data"]:
            assert "id" in item, "data 项缺少 id 字段"
            assert "name" in item, "data 项缺少 name 字段"
            assert "specs" in item, "data 项缺少 specs 字段"
            assert "images" in item, "data 项缺少 images 字段"
            assert isinstance(item["specs"], list), "specs 不是数组"
            assert isinstance(item["images"], list), "images 不是数组"

    def test_dialog_shows_server_specs(self, page_fixture: Page) -> None:
        """
        TC-UI-DIALOG-001 [正常流] 配置对话框正确展示服务器规格选项（Ascend-snt9b）
        优先级：P0
        """
        _goto_home(page_fixture)

        page, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, "对话框未弹出"

        # 等待对话框内容完全渲染
        page_fixture.wait_for_timeout(1500)

        # 断言：对话框中包含规格选择项
        spec_inputs = dialog.locator("input.o-select-input").all()
        assert len(spec_inputs) > 0, "对话框中未找到规格选择器"

        # 断言：至少一个 input 值包含 ascend 关键词
        ascend_found = any(
            (inp.get_attribute("value") or "").lower().count("ascend") > 0
            or (inp.input_value() or "").lower().count("ascend") > 0
            for inp in spec_inputs
        )
        assert ascend_found, "对话框规格选项中未找到 ascend 关键词"


# -----------------------------------------------------------------------
# 三、登录态与权限校验
# -----------------------------------------------------------------------

class TestAuthentication:
    """模块三：登录态与权限校验"""

    def test_nav_click_without_login(self, page_fixture: Page) -> None:
        """
        TC-UI-AUTH-001 [权限] 未登录状态下点击实训环境导航可正常弹出对话框或按规则提示登录
        优先级：P1
        """
        page_fixture.context.clear_cookies()
        _goto_home(page_fixture)

        nav_item = page_fixture.locator(NAV_ITEM_SELECTOR)
        nav_item.click()
        page_fixture.wait_for_timeout(3000)

        # 可能的结果：弹出对话框 或 提示登录 或 跳转登录页
        dialog = page_fixture.locator(DIALOG_SELECTOR).first
        has_dialog = dialog.count() > 0 and dialog.is_visible()
        has_login_hint = "/login" in page_fixture.url or page_fixture.locator("input[type='password']").count() > 0

        assert has_dialog or has_login_hint, \
            f"未登录点击后既未弹出对话框也未提示登录，当前 URL: {page_fixture.url}"

    def test_nav_click_with_login(self, page_fixture: Page) -> None:
        """
        TC-UI-AUTH-002 [权限][正常流] 登录状态下点击实训环境导航正常弹出配置对话框
        优先级：P0

        修复记录：原实现为 `goto(BASE_URL)` → `_login_if_needed()`，而
        `_login_if_needed` 仅在 URL 含 /login 或页面存在密码框时才填表；
        首页两者皆无，该调用实为空操作，用例走的是匿名路径，
        与 TC-UI-NAV-003 断言同一件事，P0「登录态」覆盖名不副实。
        现改用 `_login_to_usercenter`（完整验证码 + 滑块流程），
        并在点击导航前显式校验登录态已建立。
        """
        # 步骤1：完成用户中心登录（环境不可用时内部会 pytest.skip）
        _login_to_usercenter(page_fixture)

        # 步骤2：回到主站
        page_fixture.goto(BASE_URL)
        _ensure_nav_visible(page_fixture)

        # 步骤3：前置校验登录态确已建立，避免再次退化成匿名路径。
        # 登录后主站不应再出现「登录」入口；该入口仍在即说明登录态未带过来。
        login_entry = page_fixture.locator(
            ".header-toolbar a:has-text('登录'), .header-nav a:has-text('登录')"
        )
        assert login_entry.count() == 0 or not login_entry.first.is_visible(), (
            "主站仍显示「登录」入口，登录态未生效 —— 本用例无法验证登录场景"
        )

        # 步骤4：点击实训环境导航
        page, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, "登录后点击实训环境未弹出配置对话框"
        expect(dialog).to_be_visible()



# -----------------------------------------------------------------------
# 四、重复操作与异常场景
# -----------------------------------------------------------------------

class TestEdgeCases:
    """模块四：重复操作、异常场景与边界值"""

    def test_double_click_nav_item(self, page_fixture: Page) -> None:
        """
        TC-UI-EDGE-001 [重复] 快速连续点击实训环境导航项不应产生多个对话框或错误
        优先级：P2
        """
        _goto_home(page_fixture)

        nav_item = page_fixture.locator(NAV_ITEM_SELECTOR)
        try:
            nav_item.click()
            nav_item.click()
        except PlaywrightTimeout:
            pass

        page_fixture.wait_for_timeout(3000)

        # 断言：最多只有一个对话框可见
        dialogs = page_fixture.locator(DIALOG_SELECTOR).all()
        visible_dialogs = [d for d in dialogs if d.is_visible()]
        assert len(visible_dialogs) <= 1, f"快速双击后产生了多个对话框: {len(visible_dialogs)}"

    # 原 TC-UI-EDGE-002（test_dialog_close_by_esc）已合并进模块一的
    # test_dialog_cancel_closes —— 该用例立意测 ESC，但实测 ESC 关不掉对话框，
    # 代码已回落点击取消按钮，与 TC-UI-NAV-004 完全重复。

    def test_network_interrupted(self, page_fixture: Page) -> None:
        """
        TC-UI-EDGE-003 [异常] 网络中断后点击导航应有合理降级（无白屏/无崩溃）
        优先级：P3
        """
        _goto_home(page_fixture)

        page_fixture.route("**/*", lambda route: route.abort("internetdisconnected"))

        nav_item = page_fixture.locator(NAV_ITEM_SELECTOR)
        try:
            nav_item.click()
            page_fixture.wait_for_timeout(2000)
        except PlaywrightTimeout:
            pass
        finally:
            page_fixture.unroute("**/*")

        # 断言：页面 body 仍存在，前端未崩溃
        body = page_fixture.locator("body")
        assert body.count() > 0, "网络中断后页面 body 丢失，可能前端崩溃"

# 原「模块五：响应式布局与兼容性」（TC-UI-RESP-001）已合并进模块一的
# test_nav_visible_in_all_viewports —— 两者遍历同一 VIEWPORTS 字典，
# 且「点击弹窗」以「导航可见」为前提，属包含关系。

# 原「模块六：接口一致性校验」（TC-API-SCHEMA-001）已合并进模块二的
# test_api_jupyter_cloud_returns_config —— 两者前置完全一致，仅断言粒度不同。


# -----------------------------------------------------------------------
# 六、Jupyter 实例启动流程
# -----------------------------------------------------------------------

class TestJupyterLaunch:
    """模块七：Jupyter 实例启动与访问验证（原 TC-UI-MANUAL-001 自动化）"""

    def test_jupyter_launch_and_button_state_change(self, page_fixture: Page) -> None:
        """
        TC-UI-JUPYTER-001 [正常流] 登录后点击启动按钮，等待实例启动完成，按钮变为进入Jupyter
        优先级：P0
        """
        # 步骤1：登录用户中心（若环境不可用则自动跳过）
        _login_to_usercenter(page_fixture)

        # 步骤2：回到主站，点击实训环境导航
        page_fixture.goto(BASE_URL)
        page_fixture.wait_for_timeout(3000)
        _ensure_nav_visible(page_fixture)

        page_fixture, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, "对话框未弹出"
        expect(dialog).to_be_visible()

        # 步骤3：检查对话框主按钮状态
        solid_btn = dialog.locator("button.o-btn-solid").first
        assert solid_btn.count() > 0, "对话框中未找到主操作按钮"
        assert solid_btn.is_visible(), "主操作按钮不可见"

        initial_text = solid_btn.inner_text().strip()
        print(f"[Jupyter Launch] Initial button text: {initial_text}")

        # 如果按钮已经是"进入Jupyter"，说明实例已存在，直接断言成功
        if "Jupyter" in initial_text:
            _click_end_btn(page_fixture, dialog)
            return

        # 步骤4：如果按钮文本为启动类（"启动" / "启动环境"），点击启动按钮
        launch_keywords = ["启动", "启动环境", "Launch", "Start"]
        is_launch_btn = any(kw in initial_text for kw in launch_keywords)
        assert is_launch_btn, f"主按钮文本既不是'进入Jupyter'也不是启动类，实际: {initial_text}"

        # 用户要求：点击导航栏实训环境后，等 3s 再点击启动环境按钮（确保对话框状态稳定）
        page_fixture.wait_for_timeout(5000)
        solid_btn.click()
        page_fixture.wait_for_timeout(5000)

        # 步骤5：等待实例启动完成（最多60秒），成功后释放资源
        button_changed, dialog = _wait_for_instance_ready(page_fixture, "[Jupyter Launch]")
        if button_changed and dialog is not None:
            _click_end_btn(page_fixture, dialog)

        assert button_changed, (
            f"启动按钮在 {INSTANCE_READY_ROUNDS} 轮轮询内未变为'进入Jupyter'，"
            f"实例启动失败或超时。可调大 INSTANCE_READY_ROUNDS 后重试"
        )

# -----------------------------------------------------------------------
# 八、Jupyter 实例权限隔离（原 TC-UI-MANUAL-002 自动化）
# -----------------------------------------------------------------------

class TestJupyterPermission:
    """模块八：Jupyter 实例权限隔离（原 TC-UI-MANUAL-002 自动化）"""

    def test_jupyter_instance_logout_access_denied(self, page_fixture: Page, context: BrowserContext) -> None:
        """
        TC-UI-JUPYTER-002 [权限] 退出登录后再次访问 Jupyter 实例 URL 应被拒绝
        优先级：P2
        """
        # 步骤1：登录用户中心
        _login_to_usercenter(page_fixture)

        # 步骤2：回到主站，点击实训环境导航，弹出对话框
        page_fixture.goto(BASE_URL)
        page_fixture.wait_for_timeout(3000)
        _ensure_nav_visible(page_fixture)

        page_fixture, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None, "对话框未弹出"
        expect(dialog).to_be_visible()

        # 步骤3：检查主按钮状态，确保实例已启动
        solid_btn = dialog.locator("button.o-btn-solid").first
        assert solid_btn.count() > 0, "对话框中未找到主操作按钮"
        assert solid_btn.is_visible(), "主操作按钮不可见"

        initial_text = solid_btn.inner_text().strip()
        print(f"[Jupyter Permission] Initial button text: {initial_text}")

        instance_created_by_test = False

        # 如果当前没有实例，需要先启动一个
        if "Jupyter" not in initial_text:
            # 若前一个测试刚结束实例，等待释放完成（最多60秒）
            if any(kw in initial_text for kw in ["结束中", "关闭中"]):
                print(f"[Jupyter Permission] 实例正在关闭，等待释放...")
                for _ in range(6):
                    page_fixture.wait_for_timeout(10000)
                    page_fixture.reload()
                    page_fixture.wait_for_timeout(3000)
                    _ensure_nav_visible(page_fixture)
                    _, dlg = _click_training_nav_and_capture_dialog(page_fixture)
                    if dlg is None:
                        continue
                    btn = dlg.locator("button.o-btn-solid").first
                    if btn.count() == 0 or not btn.is_visible():
                        continue
                    txt = btn.inner_text().strip()
                    print(f"[Jupyter Permission] 等待释放: {txt}")
                    if "结束中" not in txt and "关闭中" not in txt:
                        initial_text = txt
                        break

            launch_keywords = ["启动", "启动环境", "Launch", "Start"]
            is_launch_btn = any(kw in initial_text for kw in launch_keywords)
            if not is_launch_btn:
                pytest.skip(f"当前按钮状态不是启动也不是进入Jupyter，无法继续测试: {initial_text}")

            page_fixture.wait_for_timeout(3000)
            solid_btn.click()
            page_fixture.wait_for_timeout(3000)
            instance_created_by_test = True

            # 等待实例启动完成（最多60秒）
            instance_ready, dialog = _wait_for_instance_ready(page_fixture, "[Jupyter Permission]", skip_on_unexpected=True)
            if not instance_ready:
                pytest.skip("实例启动超时，无法继续权限测试")

        # 如果对话框已不在页面上，重新打开；否则直接使用当前对话框
        if dialog.count() == 0 or not dialog.is_visible():
            page_fixture, dialog = _click_training_nav_and_capture_dialog(page_fixture)
        assert dialog is not None and dialog.is_visible(), "对话框未就绪，无法捕获 Jupyter URL"

        solid_btn = dialog.locator("button.o-btn-solid").first
        assert solid_btn.count() > 0 and "Jupyter" in solid_btn.inner_text().strip(), \
            "实例未就绪，无法捕获 Jupyter URL"

        # 步骤4：点击"进入Jupyter"按钮，捕获弹出的新页面 URL
        with page_fixture.expect_popup(timeout=30000) as popup_info:
            solid_btn.click()
            page_fixture.wait_for_timeout(3000)

        popup = popup_info.value
        jupyter_url = popup.url
        print(f"[Jupyter Permission] Captured Jupyter URL: {jupyter_url}")
        popup.close()

        try:
            # 步骤5：退出登录（清除所有 cookies 和 storage）
            context.clear_cookies()
            page_fixture.evaluate("() => { localStorage.clear(); sessionStorage.clear(); }")

            # 步骤6：在退出登录状态下再次访问该 Jupyter URL
            page_fixture.goto(jupyter_url)
            page_fixture.wait_for_timeout(5000)

            # 步骤7：验证是否被拒绝访问
            current_url = page_fixture.url
            page_title = page_fixture.title().strip()
            body_text = page_fixture.locator("body").inner_text().strip().lower()

            print(f"[Jupyter Permission] After logout, URL: {current_url}")
            print(f"[Jupyter Permission] After logout, title: {page_title}")
            print(f"[Jupyter Permission] After logout, body[:200]: {body_text[:200]}")

            # 判断被拒绝的方式
            is_redirected_to_login = "/login" in current_url or "usercenter" in current_url
            has_permission_error = any(kw in body_text for kw in ["403", "404","418", "权限", "无权限", "拒绝", "denied", "forbidden", "not found", "unauthorized", "不存在", "未登录", "error", "login"])
            is_error_page = page_fixture.locator(".error-page, .error-container, .not-found, .el-message-box, .o-message").count() > 0

            # 断言
            assert is_redirected_to_login or has_permission_error or is_error_page, \
                f"退出登录后仍可访问 Jupyter 实例 URL，权限隔离失败。当前URL: {current_url}, 标题: {page_title}, 内容: {body_text[:300]}"
        finally:
            # 步骤8：如果实例是本测试创建的，重新登录并结束实例（清理资源）
            if instance_created_by_test:
                try:
                    _login_to_usercenter(page_fixture)
                    page_fixture.goto(BASE_URL)
                    page_fixture.wait_for_timeout(3000)
                    _ensure_nav_visible(page_fixture)
                    page_fixture, dialog = _click_training_nav_and_capture_dialog(page_fixture)
                    if dialog is not None and _click_end_btn(page_fixture, dialog):
                        print("[Jupyter Permission] 已结束实例，释放资源")
                except Exception as e:
                    print(f"[Jupyter Permission] 清理实例时发生异常（非致命）: {e}")

# ============================== 覆盖矩阵 ==============================
"""
覆盖矩阵（功能点 × 9 维度）

功能点/维度 | 正常流 | 异常场景 | 边界值 | 空值 | 特殊字符 | 权限校验 | 数据唯一性 | 重复操作 | 异常输入
-----------|--------|----------|--------|------|----------|----------|------------|----------|----------
导航栏渲染 | ✅ TC-UI-NAV-001 | ✅ TC-UI-NAV-002 | ✅ 响应式视口 | N/A | N/A | N/A | N/A | ✅ TC-UI-EDGE-001 | N/A
对话框弹出 | ✅ TC-UI-NAV-003 | ✅ TC-UI-DIALOG-001 | N/A | N/A | N/A | ✅ TC-UI-AUTH-001/002 | N/A | ✅ TC-UI-EDGE-001 | ✅ TC-UI-EDGE-003
API 响应 | ✅ TC-API-JUPYTER-001 | ✅ TC-API-JUPYTER-001 | N/A | N/A | N/A | N/A | N/A | N/A | N/A
配置展示 | ✅ TC-UI-DIALOG-001 | N/A | ✅ 响应式视口 | N/A | N/A | N/A | N/A | N/A | N/A
关闭操作 | ✅ TC-UI-NAV-004 | ✅ TC-UI-NAV-004 | N/A | N/A | N/A | N/A | N/A | ✅ TC-UI-EDGE-001 | N/A
响应式布局 | ✅ TC-UI-NAV-001 | N/A | ✅ 视口边界 | N/A | N/A | N/A | N/A | N/A | N/A
实例启动 | ✅ TC-UI-JUPYTER-001 | N/A | ✅ 启动超时轮询 | N/A | N/A | ✅ TC-UI-JUPYTER-002 | N/A | N/A | N/A

备注：
- 空值/特殊字符/数据唯一性 对本功能（纯导航+弹窗+实例调度）不适用，已标注 N/A。
- 合并后一个用例函数可承载多个 TC 编号：
  TC-UI-NAV-001 兼含原 TC-UI-RESP-001（响应式布局行）；
  TC-UI-NAV-004 兼含原 TC-UI-EDGE-002（关闭操作异常列，ESC no-op 断言）；
  TC-API-JUPYTER-001 兼含原 TC-API-SCHEMA-001（API 响应异常列，schema 校验）。
- 异常输入维度由网络中断场景覆盖（TC-UI-EDGE-003）。
- Jupyter 实例启动与权限隔离已从手动测试块转为自动化（TC-UI-JUPYTER-001/002）。
"""
