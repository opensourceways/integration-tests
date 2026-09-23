#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
datastat 数据中台 —— 登录功能自动化测试
========================================
被测站点: https://datastat2.test.osinfra.cn/
统一认证: https://id.test.osinfra.cn/login  （未登录自动 302 到此）

用例总数: 25 条（fast 19 / slow 6）
覆盖维度: 访问控制、页面渲染、国际化、表单校验、边界值、特殊字符、
          滑块验证、邮箱验证码、登录成功/失败、会话保持、退出登录

登录流程（实测确认，非推测）
---------------------------
  1. 访问目标站 → 302 到 id.test.osinfra.cn/login?redirect_uri=<原地址>&lang=zh
  2. 该站**只有「验证码登录」一个 Tab**，无密码登录
  3. 填邮箱 → 点「获取验证码」→ POST /oneid/captcha/get → 弹 AJ-Captcha 拼图滑块
  4. 滑块通过 → POST /oneid/captcha/check → POST /oneid/captcha/sendCode
  5. 发送成功后：Toast「发送成功」+ 验证码输入框由 disabled 解锁
     + 按钮变「Ns后可重发」倒计时
  6. 填 6 位验证码 → 点「登录」→ POST /oneid/captcha/checkLogin → POST /oneid/login
  7. 成功则 302 回 datastat2，右上角 .opt-name 显示用户名

已知环境约束
-----------
  * 同一邮箱 60s 内只能发一次验证码，否则提示「该邮箱 1 分钟内已发送过验证码」。
    本文件用 wait_send_cooldown() 统一节流，slow 用例串行执行。
  * 验证码输入框初始为 disabled，只有 sendCode 成功后才解锁 —— 这是判断
    「验证码已发出」最可靠的信号，比抢 Toast 稳定。
  * 输入框 id 每次加载随机生成（如 jm00u4t6），**禁止用 id 定位**，一律用 placeholder。

登录成功的判定标准
-----------------
测试账号 guozhi1992@163.com 无管理后台数据权限，落地路径在站点根路径与
/noPermission（显示「暂无权限」）之间不固定，取决于后端权限接口返回时序。
按约定：**能带着登录态进到 datastat2 页面即视为登录成功**，即
  回到 datastat2 域  +  右上角 .opt-name 显示用户名
不校验落地路径与业务页面内容，也不校验数据权限。

本文件只覆盖邮箱验证码登录，不测手机号登录。

依赖
----
  pip install pytest playwright python-dotenv pillow numpy
  playwright install chrome

配置（全部读自同目录 .env）
--------------------------
  必填
    TEST_ACCOUNT          测试邮箱；MAIL_USER 留空时用它
    MAIL_AUTH_CODE        邮箱 IMAP【客户端授权码】，非邮箱登录密码
  选填（括号内为缺省值）
    MAIL_USER             IMAP 登录邮箱，留空回落 TEST_ACCOUNT
    LOGIN_MODE     (code) 本站仅支持 code；填其它值会整体 skip
    MAIL_CODE_TIMEOUT(150) 取验证码最长等待秒数
    SLIDER_AUTO      (1)  1=自动破解滑块，0=直接等人工
    SLIDER_AUTO_ATTEMPTS(3) 自动破解尝试次数（失败刷新换图重试）
    SLIDER_WAIT     (300) 自动破解失败后等人工拖动的秒数；0=直接失败（无人值守 CI）
    MFA_MANUAL       (0)  1=IMAP 取码失败时暂停，等人工在浏览器输码
    MFA_MANUAL_WAIT (180) 人工输码等待秒数
    HEADLESS         (0)  1=无头运行；有头时滑块更稳且便于人工兜底

  TEST_PASSWORD 在本站用不到 —— 该站无密码登录入口。
  真实环境变量优先于 .env（override=False），便于 CI 覆盖与临时调参。

执行
----
  # 全量（含 slow，约 6-8 分钟）
  pytest test_cases.py -v
  # 只跑快测（约 90 秒，不发邮件）
  pytest test_cases.py -v -k "not Slow"
  # 无头模式（临时覆盖 .env）
  HEADLESS=1 pytest test_cases.py -v
  # 无人值守：滑块过不去就失败，不挂在那里等人
  SLIDER_WAIT=0 pytest test_cases.py -v

可选：在 pytest.ini 注册 marker 以消除告警
  [pytest]
  markers =
      slow: 需要邮箱验证码与滑块，约 1-2 分钟/条
"""

import os
import re
import sys
import time
from pathlib import Path

import pytest
from playwright.sync_api import (
    Page,
    TimeoutError as PWTimeout,
    expect,
    sync_playwright,
)

# 让 email_verify / slider_solver 可被导入（与本文件同目录）
_HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(_HERE))

# =============================================================================
# 配置加载：全部取自 .env
# =============================================================================
try:
    from dotenv import load_dotenv
except ImportError:  # pragma: no cover
    raise ImportError(
        "缺少 python-dotenv，配置改用 .env 后必须安装：pip install python-dotenv"
    ) from None

# override=False：真实环境变量优先于 .env，便于 CI 覆盖与临时调参
_ENV_PATH = _HERE / ".env"
if not _ENV_PATH.exists():
    raise FileNotFoundError(
        f"未找到配置文件 {_ENV_PATH}。\n"
        f"   请在该路径创建 .env，至少包含 TEST_ACCOUNT 与 MAIL_AUTH_CODE。"
    )
load_dotenv(_ENV_PATH, override=False)


def env_str(key: str, default: str = "") -> str:
    """读字符串配置。空串按未配置处理（.env 里 MAIL_USER 就是留空的）"""
    return (os.environ.get(key) or "").strip() or default


def env_int(key: str, default: int) -> int:
    """读整数配置，非法值回落默认并告警"""
    raw = env_str(key)
    if not raw:
        return default
    try:
        return int(raw)
    except ValueError:
        print(f"[配置] {key}={raw!r} 不是整数，回落默认值 {default}", flush=True)
        return default


def env_bool(key: str, default: bool) -> bool:
    """读布尔配置，接受 1/true/yes/on（大小写不敏感）"""
    raw = env_str(key).lower()
    if not raw:
        return default
    return raw in ("1", "true", "yes", "on")


# ---- 账号 ----
ACCOUNT = env_str("MAIL_USER") or env_str("TEST_ACCOUNT")
if not ACCOUNT or "@" not in ACCOUNT:
    raise ValueError(
        f"未配置有效的测试邮箱。请在 {_ENV_PATH} 中设置 "
        f"TEST_ACCOUNT=your_mail@163.com（或 MAIL_USER）"
    )
if not env_str("MAIL_AUTH_CODE"):
    raise ValueError(
        f"未配置邮箱 IMAP 授权码。请在 {_ENV_PATH} 中设置 MAIL_AUTH_CODE=<客户端授权码>。\n"
        f"   获取方式：mail.163.com → 设置 → POP3/SMTP/IMAP → 开启 IMAP → 新增授权密码"
    )

# email_verify 直接读 MAIL_USER，而 .env 里它可能留空 —— 显式回填，
# 否则空串会让 setdefault 失效（键存在但无值）
os.environ["MAIL_USER"] = ACCOUNT

# ---- 登录方式 ----
# 本站只有「验证码登录」一个 Tab，不支持密码登录；TEST_PASSWORD 在此站用不到。
LOGIN_MODE = env_str("LOGIN_MODE", "code").lower()

# ---- 可调参数（全部来自 .env，带默认值）----
MAIL_CODE_TIMEOUT = env_int("MAIL_CODE_TIMEOUT", 150)   # 取码最长等待秒数
SLIDER_AUTO = env_bool("SLIDER_AUTO", True)             # 是否自动破解滑块
SLIDER_AUTO_ATTEMPTS = env_int("SLIDER_AUTO_ATTEMPTS", 3)
SLIDER_WAIT = env_int("SLIDER_WAIT", 300)               # 人工拖滑块等待秒数，0=不等
MFA_MANUAL = env_bool("MFA_MANUAL", False)              # 取码失败是否回落人工输码
MFA_MANUAL_WAIT = env_int("MFA_MANUAL_WAIT", 180)
HEADLESS = env_bool("HEADLESS", False)

from email_verify import MailCodeError, fetch_verification_code  # noqa: E402
from slider_solver import solve_slider  # noqa: E402

# 本站只有「验证码登录」一个 Tab，LOGIN_MODE 填别的值说明配置与被测站不匹配
if LOGIN_MODE != "code":
    pytest.skip(
        f"LOGIN_MODE={LOGIN_MODE!r}，但 datastat2 只支持验证码登录（无密码登录 Tab）。"
        f"请在 .env 中设置 LOGIN_MODE=code",
        allow_module_level=True,
    )

# =============================================================================
# 常量
# =============================================================================
TARGET_URL = "https://datastat2.test.osinfra.cn/"
TARGET_HOST = "datastat2.test.osinfra.cn"
SSO_LOGIN = "id.test.osinfra.cn/login"
NO_PERMISSION_PATH = "/noPermission"

# 定位器（禁用随机 id，统一用 placeholder / 语义类名）
MAIL_INPUT = 'input[placeholder="请输入您的邮箱地址或手机号"]'
CODE_INPUT = 'input[placeholder="请输入验证码"]'
FORM_ERROR = ".el-form-item__error"
LOGIN_TABS = ".login-tabs"
TAB_ITEM = ".login-tabs .tab"
HEADER_TITLE = ".header-title"
VERIFY_BOX = ".verifybox"
OPT_USER = ".opt-user"
OPT_NAME = ".opt-name"
LOGOUT_ITEM = ".opt-user .menu-list li"

# 文案
ERR_EMPTY = "输入不能为空"
ERR_FORMAT = "请输入正确的邮箱或手机号"
TOAST_SENT = "发送成功"
TOAST_RATE_LIMIT = "分钟内已发送过验证码"
NO_PERMISSION_TEXT = "暂无权限"
COUNTDOWN_RE = re.compile(r"^\d+s后可重发$")

TIMEOUT = 30_000
SEND_COOLDOWN = 65          # 后端限流窗口 60s，留 5s 余量

# 上次成功触发 sendCode 的时间戳（模块级，跨用例节流）
_last_send_ts = 0.0


# =============================================================================
# 工具函数
# =============================================================================
def log(msg: str) -> None:
    """带即时刷新的日志，避免长任务看起来卡死"""
    print(msg, flush=True)


def wait_send_cooldown() -> None:
    """等够后端限流窗口，确保本次「获取验证码」能真正发出"""
    global _last_send_ts
    if _last_send_ts:
        remain = SEND_COOLDOWN - (time.time() - _last_send_ts)
        if remain > 0:
            log(f"   [限流] 距上次发码不足 {SEND_COOLDOWN}s，等待 {remain:.0f}s")
            # 分段睡眠并打点，避免长时间无输出
            end = time.time() + remain
            while time.time() < end:
                time.sleep(min(10, max(0, end - time.time())))
                left = int(end - time.time())
                if left > 0:
                    log(f"   [限流] 剩余 {left}s")


def open_login_page(page: Page) -> None:
    """打开目标站并等落到统一认证登录页"""
    page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=60_000)
    page.wait_for_selector(LOGIN_TABS, timeout=TIMEOUT)
    page.wait_for_selector(MAIL_INPUT, timeout=TIMEOUT)
    page.wait_for_timeout(1200)  # 等 Vue 事件绑定收敛，否则点击可能落空


def visible_form_errors(page: Page):
    """当前可见的表单校验错误文案（去重）"""
    raw = page.evaluate(
        """(sel) => [...document.querySelectorAll(sel)]
             .filter(e => {
                 const r = e.getBoundingClientRect();
                 const s = getComputedStyle(e);
                 return r.width > 0 && r.height > 0
                        && s.visibility !== 'hidden' && s.display !== 'none';
             })
             .map(e => (e.innerText || '').trim())
             .filter(Boolean)""",
        FORM_ERROR,
    )
    return list(dict.fromkeys(raw))


def slider_images_ready(page: Page, timeout_ms: int = 12_000) -> bool:
    """
    等滑块两张内联图都解码完成。

    必须等：图未 decode 时 naturalWidth=0，locate_gap 会拿到空图而算错落点。
    """
    deadline = time.time() + timeout_ms / 1000
    while time.time() < deadline:
        widths = page.evaluate(
            """(sel) => [...document.querySelectorAll(sel + ' img')]
                   .map(i => i.naturalWidth)""",
            VERIFY_BOX,
        )
        if len(widths) >= 2 and all(w > 0 for w in widths):
            return True
        page.wait_for_timeout(400)
    return False


def pass_slider(page: Page) -> None:
    """
    处理滑块：按 .env 配置自动破解，失败则提示人工并等待。

    相关 .env 配置：
      SLIDER_AUTO=0          跳过自动破解，直接等人工
      SLIDER_AUTO_ATTEMPTS   自动破解尝试次数（失败会刷新换图重试）
      SLIDER_WAIT=0          不等人工，直接抛错（无人值守 CI 用）

    项目规范要求：需要人工介入时必须明确提醒操作人。
    """
    box = page.locator(VERIFY_BOX)
    if box.count() == 0 or not box.first.is_visible():
        log("   [滑块] 未出现滑块")
        return

    if SLIDER_AUTO:
        if not slider_images_ready(page):
            log("   [滑块] 图片未在 12s 内加载完，仍尝试破解")
        if solve_slider(page, max_attempts=SLIDER_AUTO_ATTEMPTS):
            return
        log(f"   [滑块] {SLIDER_AUTO_ATTEMPTS} 次自动破解均未通过")
    else:
        log("   [滑块] SLIDER_AUTO=0，跳过自动破解")

    if SLIDER_WAIT <= 0:
        raise AssertionError(
            "滑块未通过，且 SLIDER_WAIT=0（无人值守模式不等待人工）。"
            "如需人工兜底，请在 .env 中把 SLIDER_WAIT 设为等待秒数。"
        )

    log("   " + "!" * 62)
    log("   !! 阿蓁，需要您手动完成滑块验证")
    log("   !! 请在 Chrome 窗口拖动拼图块对齐缺口")
    log(f"   !! 脚本会等待最多 {SLIDER_WAIT}s")
    log("   " + "!" * 62)
    page.wait_for_selector(VERIFY_BOX, state="hidden", timeout=SLIDER_WAIT * 1000)
    log("   [滑块] 人工验证已完成，继续")


def request_code(page: Page, email: str = ACCOUNT, respect_cooldown: bool = True) -> float:
    """
    完成「填邮箱 → 获取验证码 → 过滑块 → 确认已发出」。

    :param respect_cooldown: True 时先等够限流窗口（正常用例）；
                             False 时故意不等（限流用例需要触发被拒）
    :return: 点击「获取验证码」前的时间戳，供 IMAP 只取此后的新邮件
    """
    global _last_send_ts

    if respect_cooldown:
        wait_send_cooldown()

    page.locator(MAIL_INPUT).fill(email)
    since = time.time()
    page.get_by_role("button", name="获取验证码").click()
    log("   [发码] 已点击「获取验证码」")
    page.wait_for_timeout(2000)

    pass_slider(page)
    page.wait_for_timeout(1500)

    # 码框解锁 = sendCode 成功，比抢 Toast 可靠
    try:
        expect(page.locator(CODE_INPUT)).to_be_enabled(timeout=20_000)
    except AssertionError:
        toasts = page.evaluate(
            """() => [...document.querySelectorAll('[class*=toast],[class*=message]')]
                   .map(e => (e.innerText || '').trim()).filter(Boolean).slice(0, 3)"""
        )
        raise AssertionError(
            f"点「获取验证码」并通过滑块后，验证码输入框仍为 disabled，"
            f"说明验证码未发出。页面提示: {toasts}"
        )

    _last_send_ts = time.time()
    log("   [发码] 验证码已发出（码框已解锁）")
    return since


def fetch_code(since: float) -> str:
    """
    从邮箱取 6 位验证码。等待上限取 .env 的 MAIL_CODE_TIMEOUT。

    :raises MailCodeError: 超时未取到（MFA_MANUAL=1 时改为返回空串，由调用方转人工）
    """
    log(f"   [取码] 开始轮询邮箱（上限 {MAIL_CODE_TIMEOUT}s）...")
    try:
        code = fetch_verification_code(since, timeout=MAIL_CODE_TIMEOUT, poll_interval=5)
    except MailCodeError:
        if not MFA_MANUAL:
            raise
        log("   [取码] IMAP 取码失败，MFA_MANUAL=1，转人工输码")
        return ""
    log(f"   [取码] 已取到验证码 {code}")
    return code


def submit_code(page: Page, code: str) -> None:
    """
    填入验证码并点「登录」。

    code 为空串时走人工兜底（MFA_MANUAL=1）：提示操作人在浏览器里自行输码并提交，
    脚本只等待跳转结果。
    """
    if code:
        page.locator(CODE_INPUT).fill(code)
        page.wait_for_timeout(400)
        page.get_by_role("button", name="登录").click()
        log("   [登录] 已点击「登录」")
        return

    log("   " + "!" * 62)
    log("   !! 阿蓁，邮箱取码失败，需要您人工介入")
    log("   !! 请在 Chrome 窗口填入收到的验证码并点「登录」")
    log(f"   !! 脚本会等待最多 {MFA_MANUAL_WAIT}s")
    log("   " + "!" * 62)


def do_login(page: Page, email: str = ACCOUNT) -> None:
    """完整邮箱验证码登录，成功后停在 datastat2 域"""
    open_login_page(page)
    since = request_code(page, email)
    code = fetch_code(since)
    submit_code(page, code)

    # 人工输码时留足人工操作时间
    nav_timeout = MFA_MANUAL_WAIT * 1000 if not code else 60_000
    page.wait_for_url(f"**{TARGET_HOST}**", timeout=nav_timeout)
    page.wait_for_selector(OPT_NAME, timeout=TIMEOUT)
    log(f"   [登录] 登录成功，落地 {page.url}")


# =============================================================================
# Fixtures
# =============================================================================
@pytest.fixture(scope="session", autouse=True)
def config_banner():
    """开跑前打印生效配置，便于对照 .env 排查（不打印任何密钥）"""
    log("=" * 64)
    log("生效配置（来自 .env）")
    log(f"  测试账号        : {ACCOUNT}")
    log(f"  登录方式        : {LOGIN_MODE}")
    log(f"  取码超时        : {MAIL_CODE_TIMEOUT}s")
    log(f"  滑块自动破解    : {'开' if SLIDER_AUTO else '关'}"
        f"（{SLIDER_AUTO_ATTEMPTS} 次）")
    log(f"  滑块人工等待    : {SLIDER_WAIT}s" + ("（0=不等待）" if SLIDER_WAIT <= 0 else ""))
    log(f"  人工输码兜底    : {'开' if MFA_MANUAL else '关'}"
        f"（{MFA_MANUAL_WAIT}s）")
    log(f"  浏览器模式      : {'无头' if HEADLESS else '有头'}")
    log("=" * 64)


@pytest.fixture(scope="session")
def browser():
    """
    会话级浏览器。默认有头：滑块破解更稳，且人工回落时需要可见窗口。

    无头由 .env 的 HEADLESS 控制（也可用环境变量临时覆盖）。
    """
    with sync_playwright() as pw:
        b = pw.chromium.launch(channel="chrome", headless=HEADLESS)
        yield b
        b.close()


@pytest.fixture
def page(browser):
    """函数级：每条用例一个干净 context，落在登录页"""
    ctx = browser.new_context(viewport={"width": 1920, "height": 1080}, locale="zh-CN")
    ctx.set_default_timeout(TIMEOUT)
    p = ctx.new_page()
    open_login_page(p)
    yield p
    ctx.close()


@pytest.fixture
def blank_page(browser):
    """函数级：不预先导航，供访问控制类用例自己决定入口 URL"""
    ctx = browser.new_context(viewport={"width": 1920, "height": 1080}, locale="zh-CN")
    ctx.set_default_timeout(TIMEOUT)
    p = ctx.new_page()
    yield p
    ctx.close()


@pytest.fixture(scope="session")
def logged_in_page(browser):
    """
    会话级登录态：整个套件只真实登录一次，供会话保持 / 退出登录等用例复用。

    单独 context，避免与函数级用例互相污染 cookie。
    """
    ctx = browser.new_context(viewport={"width": 1920, "height": 1080}, locale="zh-CN")
    ctx.set_default_timeout(TIMEOUT)
    p = ctx.new_page()
    log("=" * 64)
    log("会话级登录（整个套件仅执行一次）")
    do_login(p)
    log("=" * 64)
    yield p
    ctx.close()


# =============================================================================
# 一、访问控制
# =============================================================================
class TestAccessControl:
    """未登录时的重定向与路由保护"""

    def test_unauthenticated_redirect_to_sso(self, blank_page: Page):
        """[正常流] 未登录访问首页 → 重定向到统一认证登录页，并带上回跳地址"""
        blank_page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=60_000)
        blank_page.wait_for_selector(LOGIN_TABS, timeout=TIMEOUT)

        assert SSO_LOGIN in blank_page.url, f"未跳到统一认证登录页: {blank_page.url}"
        assert "redirect_uri" in blank_page.url, "登录 URL 未携带 redirect_uri"
        assert TARGET_HOST in blank_page.url, "redirect_uri 未指回 datastat2"

    def test_protected_route_preserves_redirect_target(self, blank_page: Page):
        """[正常流] 未登录访问 /overview → 跳登录页且 redirect_uri 保留原路径"""
        blank_page.goto(f"{TARGET_URL.rstrip('/')}/overview",
                        wait_until="domcontentloaded", timeout=60_000)
        blank_page.wait_for_selector(LOGIN_TABS, timeout=TIMEOUT)

        assert SSO_LOGIN in blank_page.url
        assert "overview" in blank_page.url, (
            f"redirect_uri 丢失了原始路径 /overview: {blank_page.url}"
        )

    def test_no_permission_page_open_without_login(self, blank_page: Page):
        """[边界] /noPermission 为公开兜底页，未登录访问不应被劫持到登录页"""
        blank_page.goto(f"{TARGET_URL.rstrip('/')}{NO_PERMISSION_PATH}",
                        wait_until="domcontentloaded", timeout=60_000)
        blank_page.wait_for_timeout(4000)

        assert TARGET_HOST in blank_page.url, f"被跳走了: {blank_page.url}"
        assert SSO_LOGIN not in blank_page.url


# =============================================================================
# 二、登录页渲染与国际化
# =============================================================================
class TestLoginPageUI:
    """登录页元素完整性、默认态、语言切换"""

    def test_login_page_elements_present(self, page: Page):
        """[正常流] 登录页关键元素齐全：标题、Tab、两个输入框、两个按钮"""
        expect(page.locator(HEADER_TITLE)).to_contain_text("欢迎登录")
        expect(page.locator(MAIL_INPUT)).to_be_visible()
        expect(page.locator(CODE_INPUT)).to_be_visible()
        expect(page.get_by_role("button", name="获取验证码")).to_be_visible()
        expect(page.get_by_role("button", name="登录")).to_be_visible()
        assert "登录" in page.title(), f"页面标题异常: {page.title()!r}"

    def test_only_verification_code_login_supported(self, page: Page):
        """[正常流] 该站仅支持验证码登录：唯一 Tab 且处于选中态，无密码输入框"""
        tabs = page.locator(TAB_ITEM)
        assert tabs.count() == 1, f"预期只有 1 个登录 Tab，实际 {tabs.count()} 个"
        expect(tabs.first).to_have_text("验证码登录")
        assert "selected" in (tabs.first.get_attribute("class") or "")
        assert page.locator('input[type="password"]').count() == 0, "不应存在密码输入框"

    def test_code_input_disabled_before_sending(self, page: Page):
        """[正常流] 未获取验证码时，验证码输入框应为禁用态，防止无效提交"""
        expect(page.locator(CODE_INPUT)).to_be_disabled()

    def test_switch_language_to_english(self, page: Page):
        """[正常流] 切到 English：URL lang=en，标题/占位符/按钮同步英文化"""
        page.get_by_text("English", exact=True).first.click()
        page.wait_for_timeout(3000)

        assert "lang=en" in page.url, f"URL 未切到 lang=en: {page.url}"
        expect(page.locator(TAB_ITEM).first).to_have_text("Verification Code")
        expect(page.locator(HEADER_TITLE)).to_contain_text("Welcome back")
        expect(page.locator('input[placeholder="Email address or mobile number"]')
               ).to_be_visible()
        expect(page.get_by_role("button", name="Get code")).to_be_visible()
        expect(page.get_by_role("button", name="Sign In")).to_be_visible()

    def test_switch_language_back_to_chinese(self, page: Page):
        """[正常流] English 切回中文，文案还原且不残留英文态"""
        page.get_by_text("English", exact=True).first.click()
        page.wait_for_timeout(2500)
        page.get_by_text("中文", exact=True).first.click()
        page.wait_for_timeout(3000)

        assert "lang=zh" in page.url, f"URL 未切回 lang=zh: {page.url}"
        expect(page.locator(TAB_ITEM).first).to_have_text("验证码登录")
        expect(page.locator(MAIL_INPUT)).to_be_visible()


# =============================================================================
# 三、表单校验（不触发真实发码，执行快）
# =============================================================================
class TestFormValidation:
    """账号框格式校验、空值、边界与特殊字符"""

    def test_empty_email_get_code(self, page: Page):
        """[空值] 邮箱为空点「获取验证码」→ 提示不能为空，且不弹滑块"""
        page.get_by_role("button", name="获取验证码").click()
        page.wait_for_timeout(2000)

        errors = visible_form_errors(page)
        assert any(ERR_EMPTY in e for e in errors), f"未提示空值，实际: {errors}"
        assert page.locator(VERIFY_BOX).count() == 0, "空邮箱不应弹出滑块"

    def test_whitespace_only_email(self, page: Page):
        """[边界值] 邮箱只填空格 → 按空值处理（前端已 trim）"""
        page.locator(MAIL_INPUT).fill("   ")
        page.get_by_role("button", name="获取验证码").click()
        page.wait_for_timeout(2000)

        errors = visible_form_errors(page)
        assert any(ERR_EMPTY in e for e in errors), f"空格未按空值处理，实际: {errors}"

    @pytest.mark.parametrize("bad_value", [
        "abc@",                      # 缺域名
        "a@b",                       # 域名无点
        "a@b.c",                      # 顶级域过短
        "guozhi1992@163.com.",        # 尾部多余点号
        "guozhi1992＠163.com",        # 全角 @
        "<script>alert(1)</script>",  # XSS 载荷
    ])
    def test_invalid_account_format(self, page: Page, bad_value: str):
        """[异常输入/特殊字符] 非法账号格式应被前端拦截，不发起发码请求"""
        page.locator(MAIL_INPUT).fill(bad_value)
        page.get_by_role("button", name="获取验证码").click()
        page.wait_for_timeout(2000)

        errors = visible_form_errors(page)
        assert any(ERR_FORMAT in e for e in errors), (
            f"{bad_value!r} 未被拦截，实际提示: {errors}"
        )
        assert page.locator(VERIFY_BOX).count() == 0, (
            f"{bad_value!r} 不应通过校验并弹出滑块"
        )

    def test_empty_form_submit_login(self, page: Page):
        """[空值] 账号与验证码都为空点「登录」→ 拦在前端，URL 不变"""
        before = page.url
        page.get_by_role("button", name="登录").click()
        page.wait_for_timeout(2500)

        errors = visible_form_errors(page)
        assert any(ERR_EMPTY in e for e in errors), f"空表单未提示，实际: {errors}"
        assert page.url == before, "空表单不应发生跳转"

    def test_login_without_requesting_code(self, page: Page):
        """[异常流] 填了合法邮箱但未取码就点「登录」→ 提示验证码不能为空"""
        page.locator(MAIL_INPUT).fill(ACCOUNT)
        page.get_by_role("button", name="登录").click()
        page.wait_for_timeout(2500)

        errors = visible_form_errors(page)
        assert any(ERR_EMPTY in e for e in errors), f"未提示验证码为空，实际: {errors}"
        assert SSO_LOGIN in page.url, "未登录成功却离开了登录页"

    def test_long_account_value_not_truncated(self, page: Page):
        """[边界值] 超长账号（308 字符）不被静默截断，交由校验逻辑处理"""
        long_value = "a" * 300 + "@163.com"
        page.locator(MAIL_INPUT).fill(long_value)

        actual = page.locator(MAIL_INPUT).input_value()
        assert len(actual) == len(long_value), (
            f"输入被截断: 填入 {len(long_value)} 字符，实际保留 {len(actual)} 字符"
        )


# =============================================================================
# 四、验证码发送与滑块（slow：真实发邮件）
# =============================================================================
@pytest.mark.slow
class TestSlowVerificationCode:
    """滑块破解 + 发码链路。受后端 60s 限流约束，用例串行。"""

    def test_send_code_full_contract(self, page: Page):
        """
        [正常流] 点「获取验证码」的完整契约：
          弹滑块 → 自动破解 → Toast「发送成功」→ 码框解锁 → 按钮进入倒计时
        """
        wait_send_cooldown()
        page.locator(MAIL_INPUT).fill(ACCOUNT)

        sent_status = {}
        page.on("response", lambda r: sent_status.update(
            {"code": r.status}) if "/oneid/captcha/sendCode" in r.url else None)

        page.get_by_role("button", name="获取验证码").click()
        page.wait_for_timeout(2000)

        expect(page.locator(VERIFY_BOX).first).to_be_visible()
        assert slider_images_ready(page), "滑块底图/拼图块未加载完成"
        pass_slider(page)

        expect(page.locator(CODE_INPUT)).to_be_enabled(timeout=20_000)
        global _last_send_ts
        _last_send_ts = time.time()

        assert sent_status.get("code") == 200, (
            f"sendCode 接口未返回 200，实际: {sent_status.get('code')}"
        )
        expect(page.get_by_text(TOAST_SENT).first).to_be_visible(timeout=10_000)

        countdown = page.evaluate(
            """() => [...document.querySelectorAll('button,.o-btn')]
                   .map(b => (b.innerText || '').trim())
                   .find(t => /^\\d+s后可重发$/.test(t)) || null"""
        )
        assert countdown and COUNTDOWN_RE.match(countdown), (
            f"按钮未进入倒计时态，当前文案: {countdown!r}"
        )

    def test_resend_within_one_minute_rate_limited(self, page: Page):
        """
        [重复操作] 60s 内对同一邮箱二次发码 → 被后端限流拒绝。

        依赖前一条用例刚发过码，故**故意不等**冷却窗口。
        判定放宽为「出现限流提示」或「码框仍禁用」：两者都表示没有真发出第二封。
        """
        assert _last_send_ts, "本用例需紧随发码用例执行，请勿单独运行"
        elapsed = time.time() - _last_send_ts
        assert elapsed < SEND_COOLDOWN, (
            f"距上次发码已 {elapsed:.0f}s，超出限流窗口，本用例前置条件不成立"
        )

        page.locator(MAIL_INPUT).fill(ACCOUNT)
        page.get_by_role("button", name="获取验证码").click()
        page.wait_for_timeout(2000)
        pass_slider(page)
        page.wait_for_timeout(2500)

        rate_limited = page.get_by_text(TOAST_RATE_LIMIT).count() > 0
        still_disabled = page.locator(CODE_INPUT).is_disabled()
        assert rate_limited or still_disabled, (
            "60s 内二次发码既未提示限流，码框也已解锁 —— 限流未生效"
        )


# =============================================================================
# 五、登录成败（slow：真实发邮件）
# =============================================================================
@pytest.mark.slow
class TestSlowLoginFlow:
    """错误验证码被拒 + 正确验证码登录成功"""

    def test_login_with_wrong_code_rejected(self, page: Page):
        """[异常输入] 填错验证码点登录 → /oneid/login 返回 400，停留在登录页"""
        since = request_code(page)  # 先正常发码以解锁码框
        assert since > 0

        statuses = []
        page.on("response", lambda r: statuses.append(r.status)
                if r.url.rstrip("/").endswith("/oneid/login") else None)

        page.locator(CODE_INPUT).fill("111111")
        page.get_by_role("button", name="登录").click()
        page.wait_for_timeout(5000)

        assert SSO_LOGIN in page.url, f"错误验证码竟然登录成功了: {page.url}"
        assert statuses, "未捕获到 /oneid/login 响应"
        assert statuses[-1] == 400, (
            f"错误验证码应返回 400，实际 {statuses[-1]}"
        )

    def test_login_success_with_valid_code(self, logged_in_page: Page):
        """
        [正常流] 邮箱验证码登录成功：回跳 datastat2 并显示登录用户名。

        注意：测试账号无管理后台权限，落地路径在 / 与 /noPermission 之间不稳定，
        故断言「登录态成立」而非具体路径或业务内容。
        """
        page = logged_in_page
        assert TARGET_HOST in page.url, f"未回跳目标站: {page.url}"
        assert SSO_LOGIN not in page.url

        expect(page.locator(OPT_NAME)).to_be_visible()
        user = page.locator(OPT_NAME).inner_text().strip()
        assert user, "已登录但用户名为空"
        log(f"   [断言] 登录用户: {user}")
        assert "datastat" in page.title(), f"落地页标题异常: {page.title()!r}"


# =============================================================================
# 六、会话保持与退出（slow：复用会话级登录态）
# =============================================================================
@pytest.mark.slow
class TestSlowSession:
    """登录态持久化与退出登录。退出用例放最后，避免破坏其它用例的登录态。"""

    def test_session_persists_after_reload(self, logged_in_page: Page):
        """[正常流] 登录后重新打开站点，会话保持，不再要求重新登录"""
        page = logged_in_page
        page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=60_000)
        page.wait_for_timeout(6000)

        assert SSO_LOGIN not in page.url, f"刷新后被踢回登录页: {page.url}"
        assert TARGET_HOST in page.url
        expect(page.locator(OPT_NAME)).to_be_visible()

    def test_logout_clears_session(self, logged_in_page: Page):
        """
        [正常流] 点「退出登录」→ 会话失效，再访问首页需重新登录。

        本用例会销毁会话级登录态，故置于套件末尾。
        """
        page = logged_in_page
        page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=60_000)
        page.wait_for_selector(OPT_USER, timeout=TIMEOUT)
        page.wait_for_timeout(2500)

        page.locator(OPT_USER).first.hover()
        page.wait_for_timeout(800)
        logout = page.locator(LOGOUT_ITEM).filter(has_text="退出登录")
        if logout.count() == 0 or not logout.first.is_visible():
            page.locator(OPT_USER).first.click()
            page.wait_for_timeout(1500)
            logout = page.locator(LOGOUT_ITEM).filter(has_text="退出登录")

        expect(logout.first).to_be_visible()
        logout.first.click()
        log("   [登出] 已点击「退出登录」")
        page.wait_for_timeout(6000)

        back_to_login = SSO_LOGIN in page.url
        user_gone = page.locator(OPT_NAME).count() == 0
        assert back_to_login or user_gone, (
            f"退出登录后仍处于登录态: url={page.url} 用户名仍在={not user_gone}"
        )

        if not back_to_login:
            page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=60_000)
            page.wait_for_timeout(5000)
            assert SSO_LOGIN in page.url, (
                f"退出后再次访问首页未要求登录: {page.url}"
            )
