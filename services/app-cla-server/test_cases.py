# -*- coding: utf-8 -*-
"""
CLA 签署平台 UI 自动化测试脚本
================================
用例来源：basic_flows.yaml / corp_manager.yaml / individual_corp_sign.yaml / represent_sign.yaml
用例总数：8 条
  - 稳定通过：3 条（test_language_switch, test_community_admin_login, test_view_cla_details）
  - 待修复：5 条（依赖 element-plus el-dropdown @command 交互，Playwright 无法触发 Vue 内部事件）
依赖：pytest, playwright (同步 API)
环境变量（自动从 CLA/.env 加载）：
    TEST_ACCOUNT     - 社区管理员账号
    TEST_PASSWORD    - 社区管理员密码
    CORP_ACCOUNT     - 企业管理员账号（默认 guoxiaozhen@grqy3283.wecom.work）
    CORP_PASSWORD    - 企业管理员密码（默认 Aa123456@）
    CORP_NEW_PWD     - 企业管理员重置后新密码
    VERIFY_CODE      - 邮箱验证码
执行命令：
    pytest CLA/suites/test_cla_ui.py -v --headed
    pytest CLA/suites/test_cla_ui.py -k "language_switch or community_admin_login or view_cla_details" -v --headed
已知限制：
    - el-dropdown 操作列菜单点击后的 Vue @command 回调无法通过 Playwright 触发
    - 建议前端添加 data-testid 或改用 trigger="click"
    - 替代方案：使用 midscene AI 视觉自动化直接运行原始 YAML 用例
"""

import os
import pytest
from playwright.sync_api import Page, expect
from pathlib import Path

BASE_URL = "https://clasign.test.osinfra.cn/index"

# 从 CLA/.env 加载环境变量
_env_file = Path(__file__).parent.parent / ".env"
if _env_file.exists():
    for line in _env_file.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if "=" in line and not line.startswith("#"):
            key, _, val = line.partition("=")
            key = key.strip()
            val = val.strip().strip('"')
            if key not in os.environ:
                os.environ[key] = val

TEST_ACCOUNT = os.environ.get("TEST_ACCOUNT", "")
TEST_PASSWORD = os.environ.get("TEST_PASSWORD", "")
CORP_ACCOUNT = os.environ.get("CORP_ACCOUNT", "") or "guoxiaozhen@grqy3283.wecom.work"
CORP_PASSWORD = os.environ.get("CORP_PASSWORD", "") or "Aa123456@"
CORP_NEW_PWD = os.environ.get("CORP_NEW_PWD", "")
VERIFY_CODE = os.environ.get("VERIFY_CODE", "")


def _close_cookie_notice(page: Page):
    """关闭 cookie 提示条（如果存在）"""
    try:
        cookie_close = page.locator('.cookie-notice .close-icon')
        if cookie_close.count() > 0 and cookie_close.first.is_visible():
            cookie_close.first.click()
            page.wait_for_timeout(300)
    except Exception:
        pass


def _click_dropdown_sign(page: Page):
    """通过 URL 直接导航到签署页面（绕过 element-plus dropdown 限制）

    实现思路：
    1. element-plus dropdown 的 @command 事件无法通过 Playwright 直接触发
    2. 但表格中"项目地址"是 span.hoverUnderline，点击会通过 router.push 跳转到 /sign/:linkId
    3. 因此用点击项目地址替代点击 dropdown -> 签署，效果等价
    """
    page.locator('.el-table__body span.hoverUnderline').last.wait_for(state="visible", timeout=15000)
    page.locator('.el-table__body span.hoverUnderline').last.click()
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(2000)


def _do_login(page: Page, account: str, password: str):
    """执行登录操作（账号+密码+复选框+登录按钮），含重试"""
    for attempt in range(3):
        try:
            page.goto(BASE_URL, timeout=30000)
            page.wait_for_load_state("domcontentloaded")
            page.wait_for_timeout(1500)
            _close_cookie_notice(page)
            page.locator('input[placeholder="账号"]').wait_for(state="visible", timeout=20000)
            break
        except Exception:
            if attempt == 2:
                raise
            page.wait_for_timeout(2000)
    page.locator('input[placeholder="账号"]').fill(account)
    page.locator('input[placeholder="密码"]').fill(password)
    page.locator('.el-checkbox').click()
    page.locator('.loginButton').click()
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(2000)


@pytest.fixture(scope="function")
def login_community_admin(page: Page):
    """前置：社区管理员登录"""
    _do_login(page, TEST_ACCOUNT, TEST_PASSWORD)
    return page


# === TC-UI-BASIC-001 中英切换测试 ===
def test_language_switch(page: Page):
    """basic_flows.yaml - 中英切换测试"""
    page.goto(BASE_URL)
    page.wait_for_timeout(1000)

    # 点击语言下拉框，切换为 English
    page.locator('#my_select').click()
    page.wait_for_timeout(300)
    page.locator('#my_option >> text=English').click()
    page.wait_for_timeout(1000)
    # 断言：登录按钮变为英文
    expect(page.locator('.loginButton')).to_contain_text("Login")

    # 切换回中文
    page.locator('#my_select').click()
    page.wait_for_timeout(300)
    page.locator('#my_option >> text=中文').click()
    page.wait_for_timeout(1000)
    # 断言：登录按钮变回中文
    expect(page.locator('.loginButton')).to_contain_text("登录")


# === TC-UI-BASIC-002 社区管理员登录测试 ===
def test_community_admin_login(page: Page):
    """basic_flows.yaml - 正常登录流程-社区管理员登录测试"""
    _do_login(page, TEST_ACCOUNT, TEST_PASSWORD)

    # 断言：页面显示"配置CLA"按钮
    expect(page.locator('text=/配置.*CLA/')).to_be_visible()
    # 断言：页面包含"已绑定的项目"
    expect(page.locator('text=已绑定的项目')).to_be_visible()


# === TC-UI-BASIC-003 验证登录后功能（查看CLA详情） ===
def test_view_cla_details(login_community_admin):
    """basic_flows.yaml - 正常登录流程-验证登录后功能"""
    page = login_community_admin

    # 点击表格中最后一个项目地址（span.pointer.hoverUnderline）
    page.locator('.el-table__body span.hoverUnderline').last.wait_for(state="visible", timeout=15000)
    page.locator('.el-table__body span.hoverUnderline').last.click()
    page.wait_for_timeout(2000)

    # 断言：页面显示已签署的企业列表（tab 标题）
    expect(page.locator('[role="tab"]:has-text("已签署")')).to_be_visible()

    # 点击已完成
    page.locator('text=已完成').click()
    page.wait_for_timeout(1000)
    # 断言：显示企业签署信息（至少1行）
    expect(page.locator('.el-table__body tbody tr').first).to_be_visible()

    # 点击个人CLA tab
    page.locator('[role="tab"]:has-text("个人CLA"), [role="tab"]:has-text("个人 CLA")').click()
    page.wait_for_timeout(1500)
    # 断言：tab 面板内有内容
    expect(page.locator('[role="tabpanel"]:visible')).to_be_visible()

    # 点击企业CLA tab
    page.locator('[role="tab"]:has-text("企业CLA"), [role="tab"]:has-text("企业 CLA")').click()
    page.wait_for_timeout(1500)
    # 断言：tab 面板内有内容
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
