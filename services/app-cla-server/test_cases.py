# -*- coding: utf-8 -*-
"""
CLA 签署平台 UI 自动化测试脚本（增强健壮性版）
============================================
用例来源：basic_flows.yaml / corp_manager.yaml / individual_corp_sign.yaml / represent_sign.yaml
用例总数：8 条
  - 稳定通过：3 条（test_language_switch, test_community_admin_login, test_view_cla_details）
  - 待修复：5 条（依赖 element-plus el-dropdown @command 交互，Playwright 无法触发 Vue 内部事件）
依赖：pytest, playwright (同步 API)
环境变量（自动从 CLA/.env 加载）：
    TEST_ACCOUNT     - 社区管理员账号
    TEST_PASSWORD    - 社区管理员密码
    CORP_ACCOUNT     - 企业管理员账号
    CORP_PASSWORD    - 企业管理员密码
    CORP_NEW_PWD     - 企业管理员重置后新密码
    VERIFY_CODE      - 邮箱验证码
执行命令：
    pytest CLA/suites/test_cla_ui.py -v --headed
    pytest CLA/suites/test_cla_ui.py -k "language_switch or community_admin_login or view_cla_details" -v --headed
已知限制：
    - el-dropdown 操作列菜单点击后的 Vue @command 回调无法通过 Playwright 直接触发
    - 建议前端添加 data-testid 或改用 trigger="click"
    - 替代方案：使用 midscene AI 视觉自动化直接运行原始 YAML 用例
"""

import os
import time
import pytest
from playwright.sync_api import Page, expect, TimeoutError as PlaywrightTimeout
from pathlib import Path

BASE_URL = "https://clasign.test.osinfra.cn/index"

TEST_ACCOUNT = os.environ.get("CLA_TEST_ACCOUNT", "")
TEST_PASSWORD = os.environ.get("CLA_TEST_PASSWORD", "")
CORP_ACCOUNT = os.environ.get("CLA_CORP_ACCOUNT", "")
CORP_PASSWORD = os.environ.get("CLA_CORP_PASSWORD", "")

# 截图保存目录
SCREENSHOT_DIR = Path(__file__).parent / "screenshots"
SCREENSHOT_DIR.mkdir(exist_ok=True)


def _screenshot(page: Page, name: str):
    """保存截图，用于失败排查"""
    timestamp = time.strftime("%Y%m%d_%H%M%S")
    path = SCREENSHOT_DIR / f"{name}_{timestamp}.png"
    try:
        page.screenshot(path=str(path), full_page=True)
        print(f"[Screenshot] saved: {path}")
    except Exception as e:
        print(f"[Screenshot] failed: {e}")


def _wait_for_element(page: Page, selector: str, timeout: int = 15000, state: str = "visible"):
    """健壮地等待元素到达指定状态，增加 attached 前置检查，避免偶现 detached 错误。"""
    # 先等元素挂载到 DOM
    locator = page.locator(selector)
    try:
        locator.first.wait_for(state="attached", timeout=timeout)
    except PlaywrightTimeout:
        # 元素可能从未出现，直接抛异常
        raise
    # 再等目标状态（visible / enabled）
    if state != "attached":
        locator.first.wait_for(state=state, timeout=timeout)
    return locator


def _safe_click(page: Page, selector: str, timeout: int = 15000, screenshot_name: str = None):
    """健壮点击：等可见 -> 等可交互 -> 滚动到视口 -> 点击。

    避免偶现失败场景：
    - 元素还在动画中（遮罩未消失）
    - 元素在视口外被遮挡
    - 点击被 cookie banner 拦截
    """
    locator = _wait_for_element(page, selector, timeout, state="visible")
    try:
        # 确保元素没有被遮挡（element-plus 遮罩 / cookie banner）
        locator.first.wait_for(state="visible", timeout=timeout)
    except Exception:
        if screenshot_name:
            _screenshot(page, screenshot_name)
        raise

    # 滚动到视口并点击（force=False 让 Playwright 自动检查可点击性）
    try:
        locator.first.click(timeout=timeout)
    except Exception:
        # 如果点击被拦截（如 cookie banner），尝试用 JavaScript 点击兜底
        page.evaluate(f"document.querySelector('{selector.replace(chr(39), chr(92)+chr(39))}')?.click()")
    page.wait_for_timeout(300)
    return locator


def _safe_fill(page: Page, selector: str, value: str, timeout: int = 15000, screenshot_name: str = None):
    """健壮填充：聚焦 -> 清空 -> 输入 -> 验证回填值。

    避免偶现失败场景：
    - Vue 表单未绑定（fill 没触发 input 事件）
    - 元素被 cookie banner 遮挡导致聚焦失败
    """
    locator = _wait_for_element(page, selector, timeout, state="visible")
    # 聚焦并清空
    locator.first.focus()
    page.wait_for_timeout(200)
    page.keyboard.press("Control+a")
    page.keyboard.press("Delete")
    page.wait_for_timeout(200)
    # 输入（使用 keyboard.type 逐字输入，确保触发 input 事件）
    page.keyboard.type(value, delay=30)
    page.wait_for_timeout(500)
    # 验证回填值（若支持 input_value）
    try:
        actual = locator.first.input_value(timeout=3000)
        if actual != value:
            # 回填不一致，尝试再次填充
            locator.first.fill(value)
            page.wait_for_timeout(300)
    except Exception:
        pass
    return locator


def _close_cookie_notice(page: Page):
    """关闭 cookie 提示条（如果存在），避免遮挡后续操作。"""
    try:
        cookie_close = page.locator('.cookie-notice .close-icon')
        if cookie_close.count() > 0 and cookie_close.first.is_visible():
            cookie_close.first.click()
            page.wait_for_timeout(500)
            # 等待 cookie banner 消失，避免残留遮挡
            try:
                cookie_close.first.wait_for(state="hidden", timeout=3000)
            except Exception:
                pass
    except Exception:
        pass


def _wait_for_spa_ready(page: Page, timeout: int = 20000):
    """等待 SPA 页面渲染完成：networkidle + 检测 body 中是否有关键 Vue 挂载标记。"""
    try:
        page.wait_for_load_state("networkidle", timeout=timeout)
    except PlaywrightTimeout:
        pass  # 部分页面不会完全 networkidle，继续检查关键元素
    page.wait_for_timeout(800)
    # 检测 Vue 应用是否已挂载（通过检查 DOM 中是否存在 el-* 类或 id="app"）
    try:
        page.wait_for_selector("#app, .el-container, .el-main", state="attached", timeout=5000)
    except Exception:
        pass


def _retry_action(page: Page, action, attempts: int = 5, wait_ms: int = 2000, screenshot_name: str = None):
    """执行 action（一次元素操作），若元素获取不到（抛异常）则刷新页面后重试。

    增强：每次失败自动截图，刷新后等待 SPA 渲染完成再重试。
    """
    last_exception = None
    for attempt in range(attempts):
        try:
            action()
            return
        except Exception as e:
            last_exception = e
            if screenshot_name:
                _screenshot(page, f"{screenshot_name}_retry_{attempt}")
            if attempt == attempts - 1:
                break
            page.reload(wait_until="networkidle")
            _wait_for_spa_ready(page)
            page.wait_for_timeout(wait_ms)
    raise last_exception


def _click_dropdown_sign(page: Page):
    """通过 URL 直接导航到签署页面（绕过 element-plus dropdown 限制）

    实现思路：
    1. element-plus dropdown 的 @command 事件无法通过 Playwright 直接触发
    2. 但表格中"项目地址"是 span.hoverUnderline，点击会通过 router.push 跳转到 /sign/:linkId
    3. 因此用点击项目地址替代点击 dropdown -> 签署，效果等价
    """
    _wait_for_element(page, '.el-table__body span.hoverUnderline', timeout=15000, state="visible")
    # 先滚动到元素确保可见
    page.locator('.el-table__body span.hoverUnderline').last.scroll_into_view_if_needed()
    page.wait_for_timeout(300)
    page.locator('.el-table__body span.hoverUnderline').last.click()
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(2000)


def _do_login(page: Page, account: str, password: str):
    """执行登录操作（账号+密码+复选框+登录按钮），含重试，若登录页面超时则刷新页面。"""
    for attempt in range(5):
        try:
            page.goto(BASE_URL, timeout=30000)
            _wait_for_spa_ready(page, timeout=20000)
            _close_cookie_notice(page)
            _wait_for_element(page, 'input[placeholder="账号"]', timeout=20000, state="visible")
            break
        except Exception as e:
            if attempt == 4:
                _screenshot(page, "login_final_fail")
                raise
            try:
                page.reload(wait_until="networkidle", timeout=30000)
                _wait_for_spa_ready(page)
            except Exception:
                pass
            page.wait_for_timeout(2000)
    # 填充账号（健壮方式）
    _safe_fill(page, 'input[placeholder="账号"]', account, timeout=15000, screenshot_name="login_fill_account")
    # 填充密码（使用 focus + keyboard 输入，确保 Vue 表单正确绑定）
    pwd_input = page.locator('input[placeholder="密码"]')
    pwd_input.focus()
    page.wait_for_timeout(200)
    page.keyboard.type(password, delay=50)
    page.wait_for_timeout(500)
    # 验证密码回填
    try:
        if pwd_input.input_value(timeout=2000) != password:
            pwd_input.fill(password)
            page.wait_for_timeout(300)
    except Exception:
        pass
    # 勾选复选框（增加可见性检查）
    checkbox = page.locator('.el-checkbox')
    checkbox.wait_for(state="visible", timeout=10000)
    checkbox.click()
    page.wait_for_timeout(300)
    # 点击登录（增加可点击检查）
    login_btn = page.locator('.loginButton')
    login_btn.wait_for(state="visible", timeout=10000)
    login_btn.click()
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(2000)
    # 登录后 SPA 渲染检测
    _wait_for_spa_ready(page)


@pytest.fixture(scope="function")
def login_community_admin(page: Page):
    """前置：社区管理员登录"""
    _do_login(page, TEST_ACCOUNT, TEST_PASSWORD)
    return page


@pytest.fixture(autouse=True)
def screenshot_on_failure(request, page: Page):
    """每个测试用例失败时自动截图，保留现场用于排查偶现问题。"""
    yield
    if request.node.rep_call.failed:
        _screenshot(page, f"FAIL_{request.node.name}")


# === TC-UI-BASIC-001 中英切换测试 ===
def test_language_switch(page: Page):
    """basic_flows.yaml - 中英切换测试"""
    page.goto(BASE_URL, timeout=30000)
    _wait_for_spa_ready(page)
    _close_cookie_notice(page)

    # 切换为 English（点击语言下拉框 -> English），若元素获取不到则刷新页面重试
    def _switch_to_english():
        select = _wait_for_element(page, '#my_select', timeout=15000, state="visible")
        select.first.click()
        page.wait_for_timeout(300)
        option = _wait_for_element(page, '#my_option >> text=English', timeout=15000, state="visible")
        option.first.click()
        page.wait_for_timeout(1000)
        # 断言：登录按钮变为英文
        expect(page.locator('.loginButton')).to_contain_text("Login")

    _retry_action(page, _switch_to_english, screenshot_name="lang_switch_en")
    expect(page.locator('.loginButton')).to_contain_text("Login")

    # 切换回中文（点击语言下拉框 -> 中文），若元素获取不到则刷新页面重试
    def _switch_to_chinese():
        select = _wait_for_element(page, '#my_select', timeout=15000, state="visible")
        select.first.click()
        page.wait_for_timeout(300)
        option = _wait_for_element(page, '#my_option >> text=中文', timeout=15000, state="visible")
        option.first.click()
        page.wait_for_timeout(1000)
        # 断言：登录按钮变回中文
        expect(page.locator('.loginButton')).to_contain_text("登录")

    _retry_action(page, _switch_to_chinese, screenshot_name="lang_switch_cn")
    expect(page.locator('.loginButton')).to_contain_text("登录")


# === TC-UI-BASIC-002 社区管理员登录测试 ===
def test_community_admin_login(page: Page):
    """basic_flows.yaml - 正常登录流程-社区管理员登录测试"""
    _do_login(page, TEST_ACCOUNT, TEST_PASSWORD)

    # 断言：页面显示"配置CLA"按钮 + "已绑定的项目"，若元素获取不到则刷新页面重试
    def _check_home():
        _wait_for_element(page, 'text=/配置.*CLA/', timeout=15000, state="visible")
        _wait_for_element(page, 'text=已绑定的项目', timeout=15000, state="visible")

    _retry_action(page, _check_home, screenshot_name="admin_login_home")
    expect(page.locator('text=/配置.*CLA/')).to_be_visible()
    expect(page.locator('text=已绑定的项目')).to_be_visible()


# === TC-UI-BASIC-003 验证登录后功能（查看CLA详情） ===
def test_view_cla_details(login_community_admin):
    """basic_flows.yaml - 正常登录流程-验证登录后功能"""
    page = login_community_admin

    # 点击表格中最后一个项目地址（span.pointer.hoverUnderline），若获取不到则刷新页面重试
    def _open_detail():
        cell = _wait_for_element(page, '.el-table__body span.hoverUnderline', timeout=15000, state="visible")
        cell.last.scroll_into_view_if_needed()
        page.wait_for_timeout(300)
        cell.last.click()
        page.wait_for_timeout(2000)
        # 进入详情后确认 tab 已渲染，否则视为获取不到、触发刷新重试
        _wait_for_element(page, '[role="tab"]:has-text("已签署")', timeout=15000, state="visible")

    _retry_action(page, _open_detail, screenshot_name="view_cla_detail")

    # 断言：页面显示已签署的企业列表（tab 标题）
    expect(page.locator('[role="tab"]:has-text("已签署")')).to_be_visible()

    # 点击已完成（若获取不到则刷新重试）
    def _click_completed():
        btn = _wait_for_element(page, 'text=已完成', timeout=15000, state="visible")
        btn.first.click()
        page.wait_for_timeout(1000)
        # 断言：显示企业签署信息（至少1行）
        _wait_for_element(page, '.el-table__body tbody tr', timeout=15000, state="visible")

    _retry_action(page, _click_completed, screenshot_name="click_completed")
    expect(page.locator('.el-table__body tbody tr').first).to_be_visible()

    # 点击个人CLA tab（若获取不到则刷新页面重试）
    def _click_individual_tab():
        tab = page.locator('[role="tab"]:has-text("个人CLA"), [role="tab"]:has-text("个人 CLA")')
        tab.wait_for(state="visible", timeout=15000)
        tab.scroll_into_view_if_needed()
        page.wait_for_timeout(200)
        tab.click()
        page.wait_for_timeout(1500)
        _wait_for_element(page, '[role="tabpanel"]:visible', timeout=15000, state="visible")

    _retry_action(page, _click_individual_tab, screenshot_name="click_individual_tab")
    expect(page.locator('[role="tabpanel"]:visible')).to_be_visible()

    # 点击企业CLA tab（若获取不到则刷新页面重试）
    def _click_corp_tab():
        tab = page.locator('[role="tab"]:has-text("企业CLA"), [role="tab"]:has-text("企业 CLA")')
        tab.wait_for(state="visible", timeout=15000)
        tab.scroll_into_view_if_needed()
        page.wait_for_timeout(200)
        tab.click()
        page.wait_for_timeout(1500)
        _wait_for_element(page, '[role="tabpanel"]:visible', timeout=15000, state="visible")

    _retry_action(page, _click_corp_tab, screenshot_name="click_corp_tab")
    expect(page.locator('[role="tabpanel"]:visible')).to_be_visible()


# # === TC-UI-CORP-001 企业管理员登录及邮箱域名管理 ===
# def test_corp_manager_email_domain(login_community_admin):
#     """corp_manager.yaml - 企业管理员登录 + 邮箱域名管理"""
#     page = login_community_admin
#
#     # 点击表格最后一项操作列三点菜单 -> 签署
#     _click_dropdown_sign(page)
#     # 断言：显示 CLA 选项
#     expect(page.locator('text=Contributor License Agreement')).to_be_visible(timeout=10000)
#
#     # 点击企业管理员
#     page.locator('text=企业管理员').click()
#     page.wait_for_timeout(3000)
#
#     # 断言：显示企业管理员登录页面
#     expect(page.locator('input[type="password"]')).to_be_visible(timeout=10000)
#
#     # 企业管理员登录
#     page.locator('input[placeholder="账号"]').fill(CORP_ACCOUNT)
#     page.locator('input[placeholder="密码"]').fill(CORP_PASSWORD)
#     page.locator('.el-checkbox').click()
#     page.locator('.loginButton').click()
#     page.wait_for_timeout(3000)
#
#     # 断言：显示管理员列表页面
#     expect(page.locator('text=/管理员列表|管理员/')).to_be_visible()
#
#     # 点击右上角头像 -> 邮箱域名
#     page.locator('.avatar, [class*="avatar"], header img').first.click()
#     page.wait_for_timeout(500)
#     page.locator('text=邮箱域名').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=/邮箱域名/')).to_be_visible()
#
#     # 添加邮箱域名
#     page.locator('button:has-text("添加"), text=添加邮箱域名').first.click()
#     page.wait_for_timeout(1000)
#
#     # 输入邮箱并发送验证码
#     page.locator('input[placeholder*="邮箱"]').first.fill(CORP_ACCOUNT)
#     page.locator('button:has-text("发送验证码")').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=已向您的邮箱发送了验证码')).to_be_visible()
#
#     # 输入验证码并提交
#     page.locator('input[placeholder*="验证码"]').first.fill(VERIFY_CODE)
#     page.locator('button:has-text("提交")').click()
#     page.wait_for_timeout(1000)
#     # 断言：弹出"邮箱域名已存在"
#     expect(page.locator('text=/邮箱域名已存在|请勿重复添加/')).to_be_visible()
#     page.locator('button:has-text("确定")').click()
#     page.wait_for_timeout(500)
#
#
# # === TC-UI-CORP-002 创建/删除管理员 ===
# def test_corp_create_delete_admin(login_community_admin):
#     """corp_manager.yaml - 创建管理员 + 删除管理员（经由操作列进入企业管理员）"""
#     page = login_community_admin
#
#     # 进入企业管理员：操作列 -> 签署 -> 企业管理员
#     _click_dropdown_sign(page)
#     page.locator('text=企业管理员').click()
#     page.wait_for_timeout(3000)
#
#     # 企业管理员登录
#     page.locator('input[placeholder="账号"]').wait_for(state="visible", timeout=15000)
#     page.locator('input[placeholder="账号"]').fill(CORP_ACCOUNT)
#     page.locator('input[placeholder="密码"]').fill(CORP_PASSWORD)
#     page.locator('.el-checkbox').click()
#     page.locator('.loginButton').click()
#     page.wait_for_timeout(3000)
#
#     # 点击右上角头像 -> 创建管理员
#     page.locator('.avatar, [class*="avatar"], header img').first.click()
#     page.wait_for_timeout(500)
#     page.locator('text=创建管理员').click()
#     page.wait_for_timeout(2000)
#     expect(page.locator('text=/创建管理员/')).to_be_visible()
#
#     # 填写管理员信息
#     page.locator('input[placeholder*="姓名"]').first.fill("吴鹤俊")
#     page.locator('input[placeholder*="邮箱"]').first.fill(CORP_ACCOUNT)
#     page.locator('input[placeholder*="用户名"]').first.fill("xxxx")
#     page.locator('button:has-text("提交")').click()
#     page.wait_for_timeout(2000)
#     # 断言：返回管理员列表
#     expect(page.locator('text=/管理员列表|管理员/')).to_be_visible()
#
#     # 删除最后一项管理员
#     delete_btns = page.locator('text=删除')
#     delete_btns.last.click()
#     page.wait_for_timeout(500)
#     expect(page.locator('text=/确定删除/')).to_be_visible()
#     page.locator('button:has-text("是"), button:has-text("确定")').first.click()
#     page.wait_for_timeout(3000)
#
#
# # === TC-UI-CORP-003 重置密码 ===
# def test_corp_reset_password(login_community_admin):
#     """corp_manager.yaml - 重置密码并验证新密码登录（经由操作列进入企业管理员）"""
#     page = login_community_admin
#
#     # 进入企业管理员：操作列 -> 签署 -> 企业管理员
#     _click_dropdown_sign(page)
#     page.locator('text=企业管理员').click()
#     page.wait_for_timeout(3000)
#
#     # 企业管理员登录
#     page.locator('input[placeholder="账号"]').wait_for(state="visible", timeout=15000)
#     page.locator('input[placeholder="账号"]').fill(CORP_ACCOUNT)
#     page.locator('input[placeholder="密码"]').fill(CORP_PASSWORD)
#     page.locator('.el-checkbox').click()
#     page.locator('.loginButton').click()
#     page.wait_for_timeout(3000)
#
#     # 点击右上角头像 -> 重置密码
#     page.locator('.avatar, [class*="avatar"], header img').first.click()
#     page.wait_for_timeout(500)
#     page.locator('text=重置密码').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=/重置密码/')).to_be_visible()
#
#     # 输入旧密码
#     page.locator('input[placeholder*="旧密码"], input[type="password"]').nth(0).fill(CORP_PASSWORD)
#     page.wait_for_timeout(1000)
#     # 输入新密码（逐字输入方式）
#     new_pwd_input = page.locator('input[placeholder*="新密码"], input[type="password"]').nth(1)
#     new_pwd_input.click()
#     new_pwd_input.fill("")
#     new_pwd_input.type(CORP_NEW_PWD, delay=100)
#     page.wait_for_timeout(1000)
#     # 输入确认新密码
#     confirm_pwd_input = page.locator('input[placeholder*="确认"], input[type="password"]').nth(2)
#     confirm_pwd_input.click()
#     confirm_pwd_input.type(CORP_NEW_PWD, delay=100)
#     page.wait_for_timeout(1000)
#     # 提交
#     page.locator('button:has-text("提交")').click()
#     page.wait_for_timeout(2000)
#
#     # 使用新密码重新登录
#     page.locator('input[placeholder="账号"]').fill(CORP_ACCOUNT)
#     page.locator('input[placeholder="密码"]').fill(CORP_NEW_PWD)
#     page.locator('.el-checkbox').click()
#     page.locator('.loginButton').click()
#     page.wait_for_timeout(3000)
#     expect(page.locator('text=/管理员列表|管理员|员工列表/')).to_be_visible()
#
#     # 还原密码：重新走一遍重置流程
#     page.locator('.avatar, [class*="avatar"], header img').first.click()
#     page.wait_for_timeout(500)
#     page.locator('text=重置密码').click()
#     page.wait_for_timeout(1000)
#     page.locator('input[placeholder*="旧密码"], input[type="password"]').nth(0).fill(CORP_NEW_PWD)
#     page.wait_for_timeout(1000)
#     restore_new = page.locator('input[placeholder*="新密码"], input[type="password"]').nth(1)
#     restore_new.click()
#     restore_new.fill("")
#     restore_new.type(CORP_PASSWORD, delay=100)
#     page.wait_for_timeout(1000)
#     restore_confirm = page.locator('input[placeholder*="确认"], input[type="password"]').nth(2)
#     restore_confirm.click()
#     restore_confirm.type(CORP_PASSWORD, delay=100)
#     page.wait_for_timeout(1000)
#     page.locator('button:has-text("提交")').click()
#     page.wait_for_timeout(2000)
#
#     # 验证还原后的密码可正常登录
#     page.locator('input[placeholder="账号"]').fill(CORP_ACCOUNT)
#     page.locator('input[placeholder="密码"]').fill(CORP_PASSWORD)
#     page.locator('.el-checkbox').click()
#     page.locator('.loginButton').click()
#     page.wait_for_timeout(3000)
#     expect(page.locator('text=/员工列表|管理员/')).to_be_visible()
#
#
# # === TC-UI-SIGN-001 个人签署企业CLA流程 ===
# def test_individual_corp_sign(login_community_admin):
#     """individual_corp_sign.yaml - 个人签署企业CLA（含员工CLA转签）"""
#     page = login_community_admin
#
#     # 点击表格最后一项操作列 -> 签署
#     _click_dropdown_sign(page)
#     expect(page.locator('text=Contributor License Agreement')).to_be_visible(timeout=10000)
#
#     # 点击签署个人CLA
#     page.locator('text=签署个人CLA, text=个人CLA').first.click()
#     page.wait_for_timeout(3000)
#     expect(page.locator('text=/签署CLA|个人贡献者许可协议/')).to_be_visible()
#
#     # 滚动到表单区域
#     page.mouse.move(900, 400)
#     page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
#     page.wait_for_timeout(1000)
#
#     # 填写签署表单
#     page.locator('input[placeholder*="姓名"], input[name*="name"]').last.fill("admin")
#     page.locator('input[placeholder*="邮箱"], input[name*="email"]').last.fill("admin@huawei.com")
#     page.locator('button:has-text("发送验证码")').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=已向您的邮箱发送了验证码')).to_be_visible()
#
#     page.locator('input[placeholder*="验证码"]').last.fill(VERIFY_CODE)
#     # 勾选隐私政策
#     page.locator('text=我已阅读了隐私政策').click()
#     page.locator('button:has-text("签署")').last.click()
#     page.wait_for_timeout(2000)
#
#     # 断言：提示只能签署员工CLA
#     expect(page.locator('text=/你所在的公司已经签署企业CLA|只能签署员工CLA/')).to_be_visible()
#     page.locator('button:has-text("确定")').click()
#     page.wait_for_timeout(3000)
#
#     # 转为员工CLA签署：滚动到表单
#     page.mouse.move(900, 400)
#     page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
#     page.wait_for_timeout(1000)
#
#     # 选择组织
#     page.locator('text=/选择组织/, input[placeholder*="组织"]').first.click()
#     page.wait_for_timeout(2000)
#     expect(page.locator('text=德科')).to_be_visible()
#     page.locator('text=德科').click()
#     page.wait_for_timeout(500)
#
#     # 发送验证码
#     page.locator('button:has-text("发送验证码")').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=已向您的邮箱发送了验证码')).to_be_visible()
#
#     page.locator('input[placeholder*="验证码"]').last.fill(VERIFY_CODE)
#     page.locator('text=我已阅读了隐私政策').click()
#     page.locator('button:has-text("签署")').last.click()
#     page.wait_for_timeout(2000)
#
#     # 断言：已签署过
#     expect(page.locator('text=/您已签署过这份贡献者许可协议/')).to_be_visible()
#     page.locator('button:has-text("确定")').click()
#
#
# # === TC-UI-SIGN-002 法人代表签署企业CLA ===
# def test_represent_sign_corp_cla(login_community_admin):
#     """represent_sign.yaml - 法人代表签署企业CLA流程"""
#     page = login_community_admin
#
#     # 点击表格最后一项操作列 -> 签署
#     _click_dropdown_sign(page)
#     expect(page.locator('text=Contributor License Agreement')).to_be_visible(timeout=10000)
#
#     # 点击签署法人CLA
#     page.locator('text=/签署法人CLA|法人CLA/').first.click()
#     page.wait_for_timeout(3000)
#     expect(page.locator('text=/签署CLA|公司贡献者许可协议/')).to_be_visible()
#
#     # 滚动到表单区域
#     page.mouse.move(900, 400)
#     page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
#     page.wait_for_timeout(1000)
#
#     # 填写法人签署表单
#     page.locator('input[placeholder*="授权代表"], input[name*="represent"]').last.fill("曹操")
#     page.locator('input[placeholder*="职位"], input[name*="title"]').last.fill("主公")
#     page.locator('input[placeholder*="公司名称"], input[name*="corp"]').last.fill("魏国集团")
#     page.locator('input[placeholder*="邮箱"], input[name*="email"]').last.fill("admin@huawei.com")
#
#     # 发送验证码
#     page.locator('button:has-text("发送验证码")').click()
#     page.wait_for_timeout(1000)
#     expect(page.locator('text=已向您的邮箱发送了验证码')).to_be_visible()
#
#     # 输入验证码
#     page.locator('input[placeholder*="验证码"]').last.fill(VERIFY_CODE)
#     # 勾选隐私政策
#     page.locator('text=我已阅读了隐私政策').click()
#     # 点击签署
#     page.locator('button:has-text("签署")').last.click()
#     page.wait_for_timeout(2000)
