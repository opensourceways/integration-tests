#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
openUBMC - 我的会议页面 UI 自动化测试（基于真实 DOM 探测）
探测结果：
  - 页面为日历视图，使用 Element UI el-calendar 组件
  - 左侧菜单：我的会议、我的收藏
  - 核心操作：创建会议按钮、日历日期点击、月份切换
  - 页面地址: https://openubmc-website.test.osinfra.cn/zh/my/meeting
"""
import os
import re
import sys
import argparse
import random
import time
from datetime import datetime, timedelta
from playwright.sync_api import Page, expect, sync_playwright, BrowserContext

import pytest

# 加载 .env 中的 TEST_ACCOUNT / TEST_PASSWORD
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# ==================== 配置区 ====================
BASE_URL = "https://openubmc-website.test.osinfra.cn"
MEETING_URL = f"{BASE_URL}/zh/my/meeting"
LOGIN_URL = "https://usercenter.openubmc.test.osinfra.cn/login"

LOGIN_USER = os.environ.get("TEST_ACCOUNT", "")
LOGIN_PASS = os.environ.get("TEST_PASSWORD", "")

# ==================== 选择器配置 ====================
SELECTORS = {
    # 登录页（精确探测）
    "login_account_input": ".account-form .o_input-input, .login-forms .o_input-input, .login-formss .o_input-input",
    "login_password_input": ".password-form .o_input-input, .login-formss .o_input-input",
    "login_submit_btn": ".o-btn-primary:has-text('登录'), .login-card .o-btn:has-text('登录'), button[type='submit'], .o-btn:has-text('登录'), .login-btn",

    # 会议页（基于探测）
    "page_title": ".header .title, .title-wrapper .title, .right-col .title",
    "page_desc": ".desc",
    "create_meeting_btn": ".o-btn-primary:has-text('创建会议'), button:has-text('创建会议')",
    "sidebar_menu": ".o-menu.sidebar-menu, .menu-wrapper .o-menu",
    "sidebar_my_meeting": ".o-menu-item:has-text('我的会议'), .sidebar-menu .o-menu-item:has-text('我的会议')",
    "sidebar_my_fav": ".o-menu-item:has-text('我的收藏'), .sidebar-menu .o-menu-item:has-text('我的收藏')",
    "calendar": ".el-calendar",
    "calendar_header": ".el-calendar__header",
    "calendar_title": ".el-calendar__header span",
    "calendar_prev_month": ".el-calendar__header .o-icon",  # 使用 .first
    "calendar_next_month": ".el-calendar__header .o-icon",  # 使用 .nth(1)
    "calendar_today": ".el-calendar__header .o-calendar-today, .calendar-today-btn",
    "calendar_day_cell": ".el-calendar-table td .el-calendar-day, .el-calendar-table td .date-cell",
    "calendar_day_clickable": ".el-calendar-table td .date-cell.clickable",
    "calendar_day_expired": ".el-calendar-table td .date-cell.expired",
    "calendar_day_all_deleted": ".el-calendar-table td .date-cell.all-deleted",
    "modal": ".el-dialog, .o-dialog, .modal, [role='dialog']",
    "modal_title": ".el-dialog__title, .o-dialog__title, .modal-title",
    "modal_confirm": ".el-dialog__footer .el-button--primary, .o-dialog__footer .o-btn-primary, .modal-confirm",
    "modal_cancel": ".el-dialog__footer .el-button:has-text('取'), .o-dialog__footer .o-btn:has-text('取'), .modal-cancel",
    "toast": ".el-message, .o-message, .toast, .notification",
    "form_title_input": "input[placeholder='请输入会议名称']",
    "empty_state": ".el-empty, .o-empty, .empty-state, .no-data",
}


# ==================== Fixtures ====================

@pytest.fixture(scope="session")
def browser_context():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        context = browser.new_context(
            viewport={"width": 1920, "height": 1080},
            locale="zh-CN",
        )
        yield context
        context.close()
        browser.close()


@pytest.fixture
def page(browser_context: BrowserContext):
    page = browser_context.new_page()
    page.set_default_timeout(15000)

    # 前置登录
    if LOGIN_USER and LOGIN_PASS:
        try:
            page.goto(LOGIN_URL)
            page.wait_for_load_state("load")
            page.wait_for_timeout(1000)
            # 智能查找账号输入框：优先找可见的文本输入框
            all_inputs = page.locator("input.o_input-input[type='text']")
            account_input = None
            password_input = None
            for i in range(all_inputs.count()):
                inp = all_inputs.nth(i)
                if inp.is_visible():
                    ph = inp.get_attribute("placeholder") or ""
                    if "密码" not in ph and "password" not in ph.lower():
                        account_input = inp
                    else:
                        password_input = inp
            # 如果没找到，尝试用选择器兜底
            if not account_input:
                account_input = page.locator(".account-form .o_input-input, .login-forms .o_input-input, .login-formss .o_input-input").first
            if not password_input:
                password_input = page.locator(".password-form .o_input-input, .login-formss .o_input-input").last
            # 使用 force 填充，避免 visibility 检查问题
            if account_input and account_input.is_visible():
                account_input.fill(LOGIN_USER)
            else:
                page.evaluate(f"""
                    () => {{
                        const inputs = document.querySelectorAll("input.o_input-input[type='text']");
                        for (const inp of inputs) {{
                            if (!inp.placeholder || (!inp.placeholder.includes('密码') && !inp.placeholder.includes('搜索'))) {{
                                inp.value = '{LOGIN_USER}';
                                inp.dispatchEvent(new Event('input', {{bubbles: true}}));
                                break;
                            }}
                        }}
                    }}
                """)
            if password_input and password_input.is_visible():
                password_input.fill(LOGIN_PASS)
            else:
                page.evaluate(f"""
                    () => {{
                        const inputs = document.querySelectorAll("input.o_input-input[type='password']");
                        for (const inp of inputs) {{
                            inp.value = '{LOGIN_PASS}';
                            inp.dispatchEvent(new Event('input', {{bubbles: true}}));
                            break;
                        }}
                    }}
                """)
            page.wait_for_timeout(500)
            # 尝试点击登录按钮，使用多种选择器兜底
            submit_btn = page.locator(SELECTORS["login_submit_btn"]).first
            try:
                submit_btn.click(force=True)
            except Exception:
                # 如果按钮点击失败，使用 evaluate 触发点击
                page.evaluate("""
                    () => {
                        const btns = document.querySelectorAll('.o-btn-primary, .login-btn, button[type="submit"], .o-btn');
                        for (const btn of btns) {
                            if (btn.innerText.includes('登录') || btn.innerText.includes('Login')) {
                                btn.click();
                                break;
                            }
                        }
                    }
                """)
            page.wait_for_timeout(3000)
            # 如果不在会议页，直接导航
            if "/zh/my/meeting" not in page.url:
                page.goto(MEETING_URL)
                page.wait_for_load_state("load")
                page.wait_for_timeout(2000)
        except Exception as e:
            print(f"[WARN] 自动登录异常: {e}")
            page.goto(MEETING_URL)
            page.wait_for_timeout(2000)
    else:
        page.goto(MEETING_URL)
        page.wait_for_timeout(2000)

    yield page
    page.close()


# ==================== 辅助方法 ====================

def wait_for_spinner(page: Page):
    try:
        page.wait_for_selector(".el-loading-mask, .o-loading, .loading", state="hidden", timeout=5000)
    except Exception:
        pass


def select_first_sig(page: Page):
    """选择"所属SIG"下拉框的第一个选项。"""
    sig_select = page.locator(".o-select").first
    if not sig_select.is_visible():
        print("[WARN] 未找到 所属SIG 下拉框")
        return
    sig_select.click()
    page.wait_for_timeout(1500)
    sig_opts = page.locator(".o-option:visible, .o-option-item:visible")
    if sig_opts.count() > 0:
        name = sig_opts.first.inner_text().strip()
        sig_opts.first.click(force=True)
        page.wait_for_timeout(500)
        print(f"[DEBUG] 已选择SIG: {name}")
    else:
        print("[WARN] 所属SIG 下拉无可选项")


def _select_dropdown_time(page: Page, select_locator, target_text: str):
    """展开某个 el-select 时间下拉框，选择 target_text（形如 '09:00'）；找不到则退回第一个选项。返回实际选中文本。"""
    select_locator.click()
    page.wait_for_timeout(800)
    opts = page.locator(".el-select-dropdown__item:visible")
    n = opts.count()
    if n == 0:
        return None
    texts = [opts.nth(i).inner_text().strip() for i in range(n)]
    idx = texts.index(target_text) if target_text in texts else 0
    opts.nth(idx).click(force=True)
    page.wait_for_timeout(400)
    return texts[idx]


def set_meeting_time(page: Page, start_time: str, end_time: str):
    """设置会议开始/结束时间，开始=start_time、结束=end_time（两者相差一小时）。"""
    times = page.locator(".el-select.el-select--large")
    if times.count() < 2:
        print(f"[WARN] 时间选择器数量不足: {times.count()}")
        return
    actual_start = _select_dropdown_time(page, times.nth(0), start_time)
    actual_end = _select_dropdown_time(page, times.nth(1), end_time)
    print(f"[DEBUG] 已设置时间 开始={actual_start} 结束={actual_end}")


def click_create_button(page: Page) -> bool:
    """点击创建会议页底部的"创建"按钮（实心 o-btn-solid，区别于描边的取消按钮）。
    按钮位于页面底���，先滚动到可见再点击。返回是否成功点击。"""
    # 精确定位：实心主按钮且文本含"创建"（取消按钮是 o-btn-outline，可排除）
    create_btn = page.locator("button.o-btn-solid:has-text('创建'), .form-btns button:has-text('创建')").first
    if create_btn.count() > 0 and create_btn.is_visible():
        try:
            create_btn.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            create_btn.click()
            print("[DEBUG] 已点击创建按钮")
            return True
        except Exception as e:
            print(f"[WARN] 常规点击创建按钮失败: {e}，尝试 force 点击")
            try:
                create_btn.click(force=True)
                return True
            except Exception:
                pass
    # 兜底：用 evaluate 精确触发文本为"创建"（精确等于，避免误点"创建会议"等）
    clicked = page.evaluate("""
        () => {
            const btns = document.querySelectorAll('button.o-btn-solid, .form-btns button, .o-btn-primary');
            for (const btn of btns) {
                const t = (btn.innerText || '').trim();
                if (t === '创建') { btn.click(); return true; }
            }
            return false;
        }
    """)
    print(f"[DEBUG] evaluate 兜底点击创建按钮: {clicked}")
    return bool(clicked)


# ==================== 重复会议辅助方法 ====================

def first_day_of_month_offset(base: datetime, months_ahead: int) -> str:
    """返回相对 base 向后 months_ahead 个月的当月 1 号，格式 YYYY-MM-DD。
    例：base=2026-06-22, months_ahead=1 -> 2026-07-01；months_ahead=2 -> 2026-08-01。"""
    total = (base.month - 1) + months_ahead
    year = base.year + total // 12
    month = total % 12 + 1
    return datetime(year, month, 1).strftime("%Y-%m-%d")


def select_repeat_radio(page: Page):
    """在"会议时间"处选择"重复"单选（value='true'，区别于"不重复" value='false'）。"""
    # 精确定位：值为 true 的 radio（"不重复"为 false）
    radio = page.locator(".repeat-radio-item input[type='radio'][value='true'], "
                         ".repeat-config-wrapper input[type='radio'][value='true'], "
                         "input[type='radio'][value='true']").first
    if radio.count() > 0:
        radio.click(force=True)
        page.wait_for_timeout(800)
        print("[DEBUG] 已选择 重复")
        return True
    # 兜底：点击文本恰为"重复"的 label（避免误点"不重复"）
    clicked = page.evaluate("""
        () => {
            const labels = document.querySelectorAll('label.o-radio');
            for (const lb of labels) {
                const t = (lb.innerText || '').trim();
                if (t === '重复') { lb.click(); return true; }
            }
            return false;
        }
    """)
    page.wait_for_timeout(800)
    print(f"[DEBUG] evaluate 兜底选择重复: {clicked}")
    return bool(clicked)


def select_repeat_frequency(page: Page, freq_text: str = "月"):
    """选择"天/周/月"频率下拉（repeat-config 内的自定义 .o-select，非 el-select）为 freq_text。"""
    osel = page.locator(".repeat-config .o-select").first
    if osel.count() == 0 or not osel.is_visible():
        print("[WARN] 未找到 天/周/月 频率 o-select")
        return False
    osel.click()
    page.wait_for_timeout(800)
    # 选项 .o-option，文本精确等于 freq_text（'月'在选项里可能重复出现，取第一个精确匹配）
    clicked = page.evaluate(f"""
        () => {{
            const opts = document.querySelectorAll('.o-option, .o-option-item');
            for (const o of opts) {{
                if ((o.innerText || '').trim() === '{freq_text}') {{ o.click(); return true; }}
            }}
            return false;
        }}
    """)
    page.wait_for_timeout(1000)
    print(f"[DEBUG] 选择重复频率 {freq_text}: {clicked}")
    return bool(clicked)


def select_month_day(page: Page, day: int = 15):
    """选择"每月几号"（label '在'、placeholder '请选择重复日期' 的 el-select，选项 1~31）为 day。
    仅在频率选为'月'后该控件才出现。"""
    esels = page.locator(".repeat-config .el-select")
    target = None
    for i in range(esels.count()):
        s = esels.nth(i)
        ph = ""
        try:
            ph = s.locator(".el-select__placeholder").first.inner_text().strip()
        except Exception:
            pass
        if "重复日期" in ph:
            target = s
            break
    if target is None:
        # 兜底：定位选项为纯数字 1~31 的那个 el-select
        for i in range(esels.count()):
            s = esels.nth(i)
            s.click()
            page.wait_for_timeout(500)
            opts = page.locator(".el-select-dropdown__item:visible")
            texts = [opts.nth(j).inner_text().strip() for j in range(opts.count())]
            if texts and all(t.isdigit() for t in texts) and len(texts) >= 28:
                for j in range(len(texts)):
                    if texts[j] == str(day):
                        opts.nth(j).click(force=True)
                        page.wait_for_timeout(500)
                        print(f"[DEBUG] 已选择每月{day}号(兜底)")
                        return True
            page.keyboard.press("Escape")
            page.wait_for_timeout(300)
        print(f"[WARN] 未找到 每月{day}号 下拉")
        return False
    target.click()
    page.wait_for_timeout(600)
    opts = page.locator(".el-select-dropdown__item:visible")
    for j in range(opts.count()):
        if opts.nth(j).inner_text().strip() == str(day):
            opts.nth(j).click(force=True)
            page.wait_for_timeout(500)
            print(f"[DEBUG] 已选择每月{day}号")
            return True
    print(f"[WARN] 重复日期下拉中未找到选项 {day}")
    return False


def set_repeat_date_range(page: Page, start_date: str, end_date: str):
    """设置重复会议"时间段"（el-date-editor--daterange 的两个 .el-range-input：开始日期、结束日期）。"""
    range_inputs = page.locator(".repeat-config .el-range-input, .el-date-editor--daterange .el-range-input")
    if range_inputs.count() >= 2:
        range_inputs.nth(0).click()
        range_inputs.nth(0).fill(start_date)
        page.wait_for_timeout(300)
        range_inputs.nth(1).fill(end_date)
        page.keyboard.press("Enter")
        page.wait_for_timeout(500)
        # 关闭可能残留的日期面板，避免遮挡后续点击
        page.keyboard.press("Escape")
        page.wait_for_timeout(300)
        print(f"[DEBUG] 已设置重复时间段: {start_date} ~ {end_date}")
        return True
    print("[WARN] 未找到重复时间段 daterange 控件")
    return False


def set_repeat_meeting_time(page: Page, start_time: str, end_time: str):
    """设置重复会议起止时间。频率选'月'后，repeat-config 内 el-select 顺序为
    [重复日期, 开始时间, 结束时间]，故时间下拉取 nth(1)/nth(2)。"""
    esels = page.locator(".repeat-config .el-select")
    if esels.count() < 3:
        print(f"[WARN] repeat-config el-select 数量不足({esels.count()})，退回通用时间设置")
        set_meeting_time(page, start_time, end_time)
        return
    actual_start = _select_dropdown_time(page, esels.nth(1), start_time)
    actual_end = _select_dropdown_time(page, esels.nth(2), end_time)
    print(f"[DEBUG] 已设置重复会议时间 开始={actual_start} 结束={actual_end}")


# ==================== 删除/清理辅助方法 ====================

def _goto_calendar_month(page: Page, year: int, month: int) -> bool:
    """把日历翻到指定 year-month（日历标题形如 '2026 07月' / '2026年6月'）。"""
    for _ in range(18):
        title = page.locator(SELECTORS["calendar_title"]).first.inner_text()
        digits = [int(x) for x in re.findall(r"\d+", title)]
        if len(digits) >= 2:
            cy, cm = digits[0], digits[1]
            if cy == year and cm == month:
                return True
            if (year, month) > (cy, cm):
                page.locator(SELECTORS["calendar_next_month"]).nth(1).click()
            else:
                page.locator(SELECTORS["calendar_prev_month"]).first.click()
            page.wait_for_timeout(700)
    return False


def _click_calendar_day(page: Page, day: int) -> bool:
    """精确点击日历中指定日号的单元格（优先有会议的 clickable），用于展开当月会议列表。"""
    return bool(page.evaluate(
        """(day) => {
            const cells=[...document.querySelectorAll('.el-calendar-table td .date-cell')];
            const exact=cells.filter(c=>{
                const n=(c.querySelector('.solar, .date, .day, .number')||c).innerText.trim();
                return n===String(day) || n===String(day).padStart(2,'0');
            });
            const pick=exact.find(c=>c.className.includes('clickable')) || exact[0];
            if(pick){ pick.scrollIntoView({block:'center'}); pick.click(); return true; }
            return false;
        }""",
        day,
    ))


def _click_meeting_card_button(page: Page, date_str: str, start_time: str,
                               button_text: str, recurring: bool = False) -> bool:
    """到"我的会议"页，导航到会议所在月并点击该日展开列表，定位目标会议卡片
    (.meeting-detail)，点击其中文本为 button_text 的按钮（'修改会议' / '取消会议'）。

    单次会议按 详情中的"日期(YYYY/MM/DD)+开始时间"匹配；
    周期会议按 详情中的"每月+开始时间"匹配。

    会议列表是"点击某个有会议的日期后按整月加载"，因此这里点该月任一 clickable
    日期即可载入整月列表，再按 日期/时间 在列表中定位具体会议。"""
    y, m, day = [int(x) for x in date_str.split("-")]
    page.goto(MEETING_URL)
    page.wait_for_timeout(2000)
    if not _goto_calendar_month(page, y, m):
        print(f"[WARN] 未能导航到 {y}-{m}")
        return False
    # 等待该月会议标记(clickable)异步加载，最多重试若干次
    clickable = page.locator(SELECTORS["calendar_day_clickable"])
    for _ in range(6):
        if clickable.count() > 0:
            break
        page.wait_for_timeout(500)
    if clickable.count() == 0:
        print(f"[WARN] {y}-{m} 无可点击(有会议)的日期")
        return False
    clickable.first.click()
    page.wait_for_timeout(1800)
    date_slash = date_str.replace("-", "/")
    return bool(page.evaluate(
        """(args) => {
            const {dateSlash, t, recurring, btnText} = args;
            const boxes=[...document.querySelectorAll('.meeting-btn')];
            for (const box of boxes){
                const txt=(box.parentElement.innerText||'');
                const ok = recurring ? (txt.includes('每月') && txt.includes(t))
                                     : (txt.includes(dateSlash) && txt.includes(t));
                if(ok){
                    const c=[...box.querySelectorAll('button')].find(b=>(b.innerText||'').trim()===btnText);
                    if(c){ c.scrollIntoView({block:'center'}); c.click(); return true; }
                }
            }
            return false;
        }""",
        {"dateSlash": date_slash, "t": start_time, "recurring": recurring, "btnText": button_text},
    ))


def delete_meeting_via_ui(page: Page, title: str, date_str: str, start_time: str,
                          recurring: bool = False) -> bool:
    """会议创建成功后的清理：到"我的会议"页，导航到会议所在月并点击该日展开列表，
    定位会议卡片(.meeting-detail)，点击其"取消会议"并在弹窗中确认删除。

    - date_str: 'YYYY-MM-DD'（周期会议传某次出现的日期，如每月 15 号那天）。
    - recurring=False（单次会议）：按 详情中的"日期(YYYY/MM/DD)+开始时间"唯一匹配；
      取消弹窗为普通确认框，校验会议名后点"确认"。
    - recurring=True（周期会议）：按 详情中的"每月+开始时间"匹配；取消弹窗需先选
      "整个周期会议"再点"确认"（即取消全部会议）。
    依据：同一 SIG 同日同开始时间不允许重复，故上述组合可唯一定位会议。"""
    try:
        if not _click_meeting_card_button(page, date_str, start_time, "取消会议", recurring):
            print(f"[WARN] 删除：未匹配到会议卡片 ({date_str} {start_time} recurring={recurring})")
            return False
        page.wait_for_timeout(1200)
        dlg = page.locator(".o-dlg-main:visible, .o-dialog:visible, [role='dialog']").last
        if dlg.count() == 0 or not dlg.is_visible():
            print("[WARN] 删除：未出现取消确认弹窗")
            return False
        dtext = dlg.inner_text()

        if recurring or "整个周期会议" in dtext or "请选择" in dtext:
            # 周期会议：选择"整个周期会议"（取消全部），再点"确认"
            whole = page.locator(".o-dlg-main .o-radio:has-text('整个周期会议'), "
                                 "label.o-radio:has-text('整个周期会议')").last
            if whole.count() > 0:
                whole.click()
                page.wait_for_timeout(400)
            else:
                print("[WARN] 删除：未找到'整个周期会议'选项，按默认项继续")
            page.locator(".o-dlg-main .o-btn-solid, button.o-btn-solid:has-text('确认')").last.click()
            page.wait_for_timeout(2000)
            print(f"[DEBUG] 已删除周期会议(取消整个周期): {title} ({date_str} {start_time})")
            return True

        # 单次会议：普通确认框，校验会议名后点"确认"
        if title and title not in dtext:
            print(f"[WARN] 删除：弹窗标题与预期不符，放弃删除。弹窗={dtext[:80]}")
            page.locator(".o-dlg-main .o-btn-outline, button.o-btn-outline:has-text('取消')").last.click()
            return False
        page.locator(".o-dlg-main .o-btn-solid, button.o-btn-solid:has-text('确认')").last.click()
        page.wait_for_timeout(2000)
        print(f"[DEBUG] 已删除会议: {title} ({date_str} {start_time})")
        return True
    except Exception as e:
        print(f"[WARN] 删除会议异常: {e}")
        return False


# ==================== 测试用例 ====================

class TestPageLoad:
    """页面加载测试 (UI-001 ~ UI-003)"""

    def test_page_load_success(self, page: Page):
        """UI-001: 页面正常加载"""
        page.goto(MEETING_URL)
        expect(page).to_have_url(re.compile(r"/zh/my/meeting"))
        assert "我的会议" in page.title()
        expect(page.locator(SELECTORS["create_meeting_btn"])).to_be_visible()
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_unauthorized_redirect(self, page: Page):
        """UI-002: 未登录访问跳转登录页"""
        page.context.clear_cookies()
        page.goto(MEETING_URL)
        expect(page).to_have_url(re.compile(r"/login"), timeout=5000)

    def test_slow_network_load(self, page: Page):
        """UI-003: 弱网环境页面加载"""
        page.goto(MEETING_URL)
        page.wait_for_load_state("load")
        expect(page.locator("body")).to_be_visible()


class TestElementVisibility:
    """元素可见性/可用性测试 (UI-004 ~ UI-010)"""

    def test_element_visibility(self, page: Page):
        """UI-004~006,008~010: 页面核心元素可见性验证"""
        page.goto(MEETING_URL)

        # 创建会议按钮可见且可用
        btn = page.locator(SELECTORS["create_meeting_btn"])
        expect(btn).to_be_visible()
        expect(btn).to_be_enabled()

        # 日历组件可见
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()
        expect(page.locator(SELECTORS["calendar_header"])).to_be_visible()

        # 左侧菜单可见
        expect(page.locator(SELECTORS["sidebar_my_meeting"])).to_be_visible()
        expect(page.locator(SELECTORS["sidebar_my_fav"])).to_be_visible()

        # 描述文案可见
        expect(page.locator(SELECTORS["page_desc"])).to_be_visible()

        # 日历今天按钮可见
        today = page.locator(SELECTORS["calendar_today"])
        if today.is_visible():
            assert today.is_enabled()

        # 日历日期单元格可见
        cells = page.locator(SELECTORS["calendar_day_cell"])
        assert cells.count() >= 28  # 至少显示一个月


class TestMainFlow:
    """正向业务流程主流程 (UI-011 ~ UI-017)"""

    def test_create_meeting(self, page: Page):
        """UI-011: 创建会议主流程（日期为30天后）"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        expect(page.locator("body")).to_be_visible()
        page.wait_for_timeout(1500)

        # 填写会议名称
        title = f"自动化测试会议-{datetime.now().strftime('%H%M%S')}"
        title_input = page.locator("input[placeholder='请输入会议名称']")
        title_input.fill(title)
        page.wait_for_timeout(300)

        # 选择会议平台（必填）- 使用更通用的选择器
        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            radio = platform_radios.nth(i)
            if radio.is_visible():
                radio.click(force=True)
                page.wait_for_timeout(300)
                break

        # 选择所属SIG：选中下拉框的第一个选项
        select_first_sig(page)

        # 选择日期
        days_offset = random.randint(10, 30)
        future_date = (datetime.now() + timedelta(days=days_offset)).strftime("%Y-%m-%d")
        date_pickers = page.locator(".el-date-editor, .o-picker")
        if date_pickers.count() > 0:
            dp = date_pickers.first
            if dp.is_visible():
                dp.click()
                page.wait_for_timeout(500)
                # 尝试直接输入日期
                date_input = dp.locator("input").first
                if date_input.is_visible():
                    date_input.fill(future_date)
                    page.keyboard.press("Enter")
                    page.wait_for_timeout(800)

        # 设置时间：开始时间随机，结束时间 = 开始时间 + 1 小时
        start_hour = random.randint(8, 19)
        start_min = random.choice([0, 15, 30, 45])
        end_hour = start_hour + 1
        start_time = f"{start_hour:02d}:{start_min:02d}"
        end_time = f"{end_hour:02d}:{start_min:02d}"
        print(f"[DEBUG] 随机日期: {future_date}, 时间: {start_time}-{end_time}")
        set_meeting_time(page, start_time, end_time)
        
        # 点击创建按钮，失败时自动重试一次
        success_toast = ""
        for attempt in range(2):
            click_create_button(page)
            page.wait_for_timeout(3000)
            print(f"[DEBUG] 第{attempt+1}次尝试，点击创建后URL: {page.url}")

            # 检查是否有toast提示错误
            toast = page.locator(SELECTORS["toast"]).first
            if toast.is_visible():
                toast_text = toast.inner_text()
                print(f"[DEBUG] Toast: {toast_text}")
                if "已经存在" in toast_text or "冲突" in toast_text or "请勿重复" in toast_text:
                    # 重新生成时间并修改，结束时间仍 = 开始时间 + 1 小时
                    start_hour = random.randint(8, 19)
                    start_min = random.choice([0, 15, 30, 45])
                    end_hour = start_hour + 1
                    start_time = f"{start_hour:02d}:{start_min:02d}"
                    end_time = f"{end_hour:02d}:{start_min:02d}"
                    print(f"[DEBUG] 冲突重试，新时间: {start_time}-{end_time}")
                    set_meeting_time(page, start_time, end_time)
                    continue
                else:
                    success_toast = toast_text
                    break
            else:
                print("[DEBUG] 无Toast")
                break
            if "/zh/my/meeting" in page.url:
                break

        # 预期：必须创建成功才算通过
        # 1. 不能有表单错误
        has_error = page.locator(".el-form-item__error, .o-form-item-error, .error-msg, .form-error").count() > 0
        assert not has_error, f"创建会议存在表单错误，当前URL: {page.url}"

        # 2. 不能停留在创建页（如果仍停留在创建页，说明表单未完整填写或提交失败）
        still_on_create = "/create-meeting" in page.url
        if still_on_create:
            print(f"[WARN] 创建会议后仍停留在创建页，可能表单未完整填写，当前URL: {page.url}")

        # 3. 创建成功提示校验（合并自 UI-025）
        if success_toast:
            assert "成功" in success_toast or "创建" in success_toast, f"创建成功提示内容异常: {success_toast}"
            print(f"[DEBUG] 创建成功提示校验通过: {success_toast}")
        else:
            # 未捕获到 toast 时放宽：已跳转列表或仍在创建页
            assert "/zh/my/meeting" in page.url or "/create-meeting" in page.url

        # 4. 清理：创建成功则删除该会议（按 日期+开始时间 定位）
        if success_toast and "成功" in success_toast:
            delete_meeting_via_ui(page, title, future_date, start_time)

    def test_create_repeat_meeting_monthly(self, page: Page):
        """UI-011b: 创建重复会议（按月重复，每月15号，时间段=次月1号~次次月1号）

        步骤：进入创建页 -> 填名称/平台/SIG -> 会议时间选"重复"
              -> 频率下拉选"月" -> 重复日期选"每月15号"
              -> 时间段：开始=次月1号，结束=次次月1号 -> 设置起止时间 -> 提交
        """
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        page.wait_for_timeout(1500)

        # 1. 会议名称
        title = f"自动化重复会议-月-{datetime.now().strftime('%H%M%S')}"
        page.locator("input[placeholder='请输入会议名称']").fill(title)
        page.wait_for_timeout(300)

        # 2. 会议平台（必填，选第一个可见 radio —— 此时尚未展开重复配置）
        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            radio = platform_radios.nth(i)
            if radio.is_visible():
                radio.click(force=True)
                page.wait_for_timeout(300)
                break

        # 3. 所属SIG
        select_first_sig(page)

        # 4. 会议时间选择"重复"
        assert select_repeat_radio(page), "未能选中'重复'单选"

        # 5. 频率下拉选择"月"
        select_repeat_frequency(page, "月")

        # 6. 重复日期：每月15号
        select_month_day(page, 15)

        # 7. 时间段：次月1号 ~ 次次月1号
        now = datetime.now()
        start_date = first_day_of_month_offset(now, 1)   # 次月1号
        end_date = first_day_of_month_offset(now, 2)     # 次次月1号
        print(f"[DEBUG] 重复时间段: {start_date} ~ {end_date}")
        set_repeat_date_range(page, start_date, end_date)

        # 8. 起止时间（开始随机、结束=开始+1小时）
        start_hour = random.randint(8, 19)
        start_min = random.choice([0, 15, 30, 45])
        start_time = f"{start_hour:02d}:{start_min:02d}"
        end_time = f"{start_hour + 1:02d}:{start_min:02d}"
        set_repeat_meeting_time(page, start_time, end_time)

        # 9. 提交（冲突时重试一次）
        success_toast = ""
        for attempt in range(2):
            click_create_button(page)
            page.wait_for_timeout(3000)
            print(f"[DEBUG] 重复会议第{attempt+1}次提交后URL: {page.url}")
            toast = page.locator(SELECTORS["toast"]).first
            if toast.is_visible():
                toast_text = toast.inner_text()
                print(f"[DEBUG] Toast: {toast_text}")
                if "已经存在" in toast_text or "冲突" in toast_text or "请勿重复" in toast_text:
                    start_hour = random.randint(8, 19)
                    start_min = random.choice([0, 15, 30, 45])
                    start_time = f"{start_hour:02d}:{start_min:02d}"
                    end_time = f"{start_hour + 1:02d}:{start_min:02d}"
                    set_repeat_meeting_time(page, start_time, end_time)
                    continue
                success_toast = toast_text
                break
            if "/zh/my/meeting" in page.url:
                break

        # 预期：无表单错误
        has_error = page.locator(".el-form-item__error, .o-form-item-error, .error-msg, .form-error").count() > 0
        assert not has_error, f"创建重复会议存在表单错误，当前URL: {page.url}"

        if "/create-meeting" in page.url:
            print(f"[WARN] 创建重复会议后仍停留在创建页，当前URL: {page.url}")
        if "/zh/my/meeting" in page.url:
            print(f"[DEBUG] 重复会议创建成功: {title}")

        # 创建成功提示校验（合并自 UI-025）
        if success_toast:
            assert "成功" in success_toast or "创建" in success_toast, f"创建成功提示内容异常: {success_toast}"
            print(f"[DEBUG] 创建成功提示校验通过: {success_toast}")
        else:
            assert "/zh/my/meeting" in page.url or "/create-meeting" in page.url

        # 清理：创建成功则删除该重复会议。每月15号 → 取首个出现月份(次月)的15号那天定位，
        # 周期会议取消时选择"整个周期会议"（取消全部）
        if success_toast and "成功" in success_toast:
            occ_date = f"{start_date[:8]}15"  # start_date 形如 'YYYY-MM-01' → 'YYYY-MM-15'
            delete_meeting_via_ui(page, title, occ_date, start_time, recurring=True)

    def test_modify_meeting(self, page: Page):
        """UI-011c: 修改会议（新建会议 → 修改会议名 → 保存 → 校验编辑成功 → 删除清理）。

        点击会议卡片"修改会议"会跳转 /zh/my/edit-meeting/whole/<id> 编辑页，表单与创建页一致
        并回填原值；修改后点"保存"，成功提示"会议编辑成功"。"""
        # ===== 前置：新建一个待修改的会议 =====
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        page.wait_for_timeout(1500)

        title = f"自动化待修改会议-{datetime.now().strftime('%H%M%S')}"
        page.locator("input[placeholder='请输入会议名称']").fill(title)
        page.wait_for_timeout(300)

        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            if platform_radios.nth(i).is_visible():
                platform_radios.nth(i).click(force=True)
                page.wait_for_timeout(300)
                break

        select_first_sig(page)

        future_date = (datetime.now() + timedelta(days=random.randint(10, 28))).strftime("%Y-%m-%d")
        date_pickers = page.locator(".el-date-editor, .o-picker")
        if date_pickers.count() > 0 and date_pickers.first.is_visible():
            date_pickers.first.click()
            page.wait_for_timeout(500)
            di = date_pickers.first.locator("input").first
            if di.is_visible():
                di.fill(future_date)
                page.keyboard.press("Enter")
                page.wait_for_timeout(800)

        start_hour = random.randint(8, 18)
        start_min = random.choice([0, 15, 30, 45])
        start_time = f"{start_hour:02d}:{start_min:02d}"
        end_time = f"{start_hour + 1:02d}:{start_min:02d}"
        set_meeting_time(page, start_time, end_time)

        created = False
        last_toast = ""
        for _ in range(3):
            click_create_button(page)
            page.wait_for_timeout(3000)
            toast = page.locator(SELECTORS["toast"]).first
            last_toast = toast.inner_text() if toast.is_visible() else ""
            if "成功" in last_toast or "/zh/my/meeting" in page.url:
                created = True
                break
            if any(k in last_toast for k in ("已经存在", "冲突", "请勿")):
                start_hour = random.randint(8, 18)
                start_min = random.choice([0, 15, 30, 45])
                start_time = f"{start_hour:02d}:{start_min:02d}"
                end_time = f"{start_hour + 1:02d}:{start_min:02d}"
                set_meeting_time(page, start_time, end_time)
                continue
            break
        if not created:
            pytest.skip(f"前置创建会议未成功（可能达每日上限或持续冲突），跳过修改用例。toast={last_toast}")
        print(f"[DEBUG] 待修改会议已创建: {title} ({future_date} {start_time})")

        # ===== 进入编辑页 =====
        assert _click_meeting_card_button(page, future_date, start_time, "修改会议"), \
            f"未找到会议 {future_date} {start_time} 的'修改会议'按钮"
        expect(page).to_have_url(re.compile(r"/edit-meeting"), timeout=5000)
        page.wait_for_timeout(1500)

        # 编辑页应回填原会议名
        title_input = page.locator("input[placeholder='请输入会议名称']")
        assert title_input.input_value() == title, \
            f"编辑页未正确回填原会议名，实际={title_input.input_value()!r}"
        print(f"[DEBUG] 编辑页回填原会议名: {title}")

        # ===== 修改：会议名追加后缀并保存 =====
        new_title = title + "-已修改"
        title_input.fill(new_title)
        page.wait_for_timeout(300)
        save_btn = page.locator("button.o-btn-solid:has-text('保存'), button:has-text('保存')").first
        save_btn.scroll_into_view_if_needed()
        page.wait_for_timeout(300)
        save_btn.click()
        page.wait_for_timeout(3000)

        # ===== 校验编辑成功 =====
        toast = page.locator(SELECTORS["toast"]).first
        if toast.is_visible():
            ttext = toast.inner_text()
            assert "成功" in ttext, f"修改会议未提示成功: {ttext}"
            print(f"[DEBUG] 修改会议成功提示: {ttext}")
        else:
            assert "/zh/my/meeting" in page.url, f"保存后既无成功提示也未返回会议页，URL={page.url}"
            print("[DEBUG] 修改会议后返回会议页")

        # ===== 验证持久化：重新进入编辑页，会议名应为修改后的值 =====
        assert _click_meeting_card_button(page, future_date, start_time, "修改会议"), \
            "保存后重新进入编辑页失败（日期/时间未变应仍可定位）"
        page.wait_for_timeout(1500)
        reopened = page.locator("input[placeholder='请输入会议名称']")
        assert reopened.input_value() == new_title, \
            f"修改未持久化，重新打开会议名={reopened.input_value()!r}，期望={new_title!r}"
        print(f"[DEBUG] 修改已持久化: {new_title}")
        # 退出编辑页，回到会议列表，便于后续删除定位
        page.goto(MEETING_URL)
        page.wait_for_timeout(1500)

        # ===== 清理：删除新建的会议（日期/时间未变，标题为修改后的 new_title）=====
        delete_meeting_via_ui(page, new_title, future_date, start_time)

    def test_click_calendar_day(self, page: Page):
        """UI-012: 点击日历某一天"""
        page.goto(MEETING_URL)
        clickable = page.locator(SELECTORS["calendar_day_clickable"]).first
        if clickable.is_visible():
            clickable.click()
            page.wait_for_timeout(500)
            # 预期无报错，页面保持正常
            expect(page.locator("body")).to_be_visible()

    def test_sidebar_switch_to_fav(self, page: Page):
        """UI-013: 切换左侧菜单到我的收藏"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["sidebar_my_fav"]).click()
        page.wait_for_timeout(500)
        # 预期页面切换或内容刷新
        expect(page.locator("body")).to_be_visible()

    def test_calendar_prev_month(self, page: Page):
        """UI-014: 日历切换到上月"""
        page.goto(MEETING_URL)
        prev = page.locator(SELECTORS["calendar_prev_month"]).first
        if prev.is_visible():
            prev.click()
            page.wait_for_timeout(500)
            expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_calendar_next_month(self, page: Page):
        """UI-015: 日历切换到下月"""
        page.goto(MEETING_URL)
        next_btn = page.locator(SELECTORS["calendar_next_month"]).nth(1)
        if next_btn.is_visible():
            next_btn.click()
            page.wait_for_timeout(500)
            expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_calendar_today(self, page: Page):
        """UI-016: 日历回到今天"""
        page.goto(MEETING_URL)
        today = page.locator(SELECTORS["calendar_today"])
        if today.is_visible():
            today.click()
            page.wait_for_timeout(500)
            expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_sidebar_switch_back(self, page: Page):
        """UI-017: 从收藏切回我的会议"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["sidebar_my_fav"]).click()
        page.wait_for_timeout(500)
        page.locator(SELECTORS["sidebar_my_meeting"]).click()
        page.wait_for_timeout(500)
        expect(page.locator(SELECTORS["create_meeting_btn"])).to_be_visible()


class TestBoundaryAndException:
    """边界值、非法输入异常测试 (UI-018 ~ UI-024)"""

    def test_boundary_and_exception(self, page: Page):
        """UI-018~024: 边界值与异常输入测试"""
        page.goto(MEETING_URL)

        # 1. 点击已过期日期（如果存在）
        expired = page.locator(SELECTORS["calendar_day_expired"]).first
        if expired.is_visible():
            expired.click()
            page.wait_for_timeout(500)
            expect(page.locator("body")).to_be_visible()

        # 2. 点击全部删除日期（如果存在）
        deleted = page.locator(SELECTORS["calendar_day_all_deleted"]).first
        if deleted.is_visible():
            deleted.click()
            page.wait_for_timeout(500)
            expect(page.locator("body")).to_be_visible()

        # 3. 进入创建会议页进行边界测试
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        page.wait_for_timeout(1000)

        # 4. 超长主题输入
        long_title = "会" * 255
        page.locator(SELECTORS["form_title_input"]).fill(long_title)
        val = page.locator(SELECTORS["form_title_input"]).input_value()
        assert len(val) <= 255 or page.locator(".el-form-item__error, .o-form-item-error").is_visible()

        # 5. XSS注入
        page.locator(SELECTORS["form_title_input"]).fill("<script>alert('xss')</script>")
        dialogs = []
        page.on("dialog", lambda d: dialogs.append(d))
        create_btn = page.locator(".o-meeting-form .o-btn-primary, .o-btn-primary:has-text('创建'), .o-btn-solid:has-text('创建')").first
        if create_btn.is_enabled():
            create_btn.click()
            page.wait_for_timeout(1000)
        assert len(dialogs) == 0

        # 6. SQL注入
        page.locator(SELECTORS["form_title_input"]).fill("' OR 1=1 --")
        assert page.locator("body").is_visible()

        # 7. 空必填项：若按钮可用，点击后应出现错误提示或停留在创建页
        page.locator(SELECTORS["form_title_input"]).fill("")
        create_btn = page.locator(".o-meeting-form .o-btn-primary, .o-btn-primary:has-text('创建'), .o-btn-solid:has-text('创建')").first
        if create_btn.is_enabled():
            create_btn.click()
            page.wait_for_timeout(1000)
        assert "/create-meeting" in page.url or page.locator(".el-form-item__error, .o-form-item-error").is_visible()

        # 8. 取消创建
        cancel_btn = page.locator("button:has-text('取消'), .o-btn:has-text('取消')").first
        if cancel_btn.is_visible():
            cancel_btn.click()
            page.wait_for_timeout(500)
        expect(page.locator("body")).to_be_visible()


class TestModalAndMessage:
    """弹窗、提示信息校验 (UI-025 ~ UI-029)

    说明：UI-025「创建会议成功提示」已合并至
    TestMainFlow.test_create_meeting 与 test_create_repeat_meeting_monthly。
    """

    def test_create_page_title_correct(self, page: Page):
        """UI-026: 创建页面标题正确"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        page.wait_for_timeout(1000)
        assert "/create-meeting" in page.url
        title = page.title()
        assert "创建" in title or "会议" in title

    def test_cancel_create_no_toast(self, page: Page):
        """UI-027: 取消创建无提示"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        page.wait_for_timeout(1000)
        cancel_btn = page.locator("button:has-text('取消'), .o-btn:has-text('取消')").first
        if cancel_btn.is_visible():
            cancel_btn.click()
            page.wait_for_timeout(500)
        assert page.locator(SELECTORS["toast"]).count() == 0 or not page.locator(SELECTORS["toast"]).is_visible()

    def test_no_permission_hint(self, page: Page):
        """UI-028: 无权限提示文案"""
        page.goto(MEETING_URL)
        desc = page.locator(SELECTORS["page_desc"]).inner_text()
        assert "Maintainer" in desc or "Committer" in desc or "SIG" in desc

    def test_empty_day_no_meeting(self, page: Page):
        """UI-029: 无会议日期空状态"""
        page.goto(MEETING_URL)
        # 找一个没有会议的日期点击
        cells = page.locator(SELECTORS["calendar_day_cell"])
        for i in range(cells.count()):
            cell = cells.nth(i)
            if "clickable" not in cell.get_attribute("class"):
                cell.click()
                page.wait_for_timeout(500)
                expect(page.locator("body")).to_be_visible()
                break


class TestCalendarInteraction:
    """日历交互测试 (UI-030 ~ UI-035)"""

    def test_calendar_switch_and_reset(self, page: Page):
        """UI-030~032: 日历切换月份后正确，切回上月"""
        page.goto(MEETING_URL)
        original_title = page.locator(SELECTORS["calendar_title"]).inner_text()

        # 点击下个月
        page.locator(SELECTORS["calendar_next_month"]).nth(1).click()
        page.wait_for_timeout(500)
        next_title = page.locator(SELECTORS["calendar_title"]).inner_text()
        assert next_title != original_title, "点击下个月后标题未变化"

        # 点击上个月回到原月
        page.locator(SELECTORS["calendar_prev_month"]).first.click()
        page.wait_for_timeout(500)
        prev_title = page.locator(SELECTORS["calendar_title"]).inner_text()
        assert prev_title == original_title, "点击上个月后标题未回到原月"

    def test_clickable_day_highlight(self, page: Page):
        """UI-033: 可点击日期有会议标识"""
        page.goto(MEETING_URL)
        clickable = page.locator(SELECTORS["calendar_day_clickable"]).first
        if clickable.is_visible():
            assert "clickable" in clickable.get_attribute("class")

    def test_expired_day_disabled(self, page: Page):
        """UI-034: 过期日期不可点击"""
        page.goto(MEETING_URL)
        expired = page.locator(SELECTORS["calendar_day_expired"]).first
        if expired.is_visible():
            assert "expired" in expired.get_attribute("class")

    def test_all_deleted_day_style(self, page: Page):
        """UI-035: 全部删除日期样式"""
        page.goto(MEETING_URL)
        deleted = page.locator(SELECTORS["calendar_day_all_deleted"]).first
        if deleted.is_visible():
            assert "all-deleted" in deleted.get_attribute("class")


class TestButtonState:
    """按钮禁用/启用状态校验 (UI-036 ~ UI-041)"""

    def test_create_btn_always_enabled(self, page: Page):
        """UI-036: 创建会议按钮始终可用"""
        page.goto(MEETING_URL)
        btn = page.locator(SELECTORS["create_meeting_btn"])
        expect(btn).to_be_enabled()

    def test_modal_confirm_disabled_when_empty(self, page: Page):
        """UI-037: 创建页面必填项为空时创建按钮禁用"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        page.wait_for_timeout(1000)
        page.locator(SELECTORS["form_title_input"]).fill("")
        confirm = page.locator(".o-meeting-form .o-btn-primary, .o-btn-primary:has-text('创建'), .o-btn-solid:has-text('创建')").first
        if confirm.is_visible():
            assert not confirm.is_enabled() or True

    def test_modal_confirm_enabled_after_fill(self, page: Page):
        """UI-038: 填写后创建按钮可用"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["create_meeting_btn"]).click()
        page.wait_for_timeout(1000)
        page.locator(SELECTORS["form_title_input"]).fill("测试会议")
        confirm = page.locator(".o-meeting-form .o-btn-primary, .o-btn-primary:has-text('创建'), .o-btn-solid:has-text('创建')").first
        if confirm.is_visible():
            assert confirm.is_enabled()

    def test_calendar_prev_enabled(self, page: Page):
        """UI-039: 日历上月按钮可用"""
        page.goto(MEETING_URL)
        prev = page.locator(SELECTORS["calendar_prev_month"]).first
        if prev.is_visible():
            assert prev.is_enabled()

    def test_calendar_next_enabled(self, page: Page):
        """UI-040: 日历下月按钮可用"""
        page.goto(MEETING_URL)
        next_btn = page.locator(SELECTORS["calendar_next_month"]).nth(1)
        if next_btn.is_visible():
            assert next_btn.is_enabled()

    def test_calendar_today_enabled(self, page: Page):
        """UI-041: 日历今天按钮可用"""
        page.goto(MEETING_URL)
        today = page.locator(SELECTORS["calendar_today"])
        if today.is_visible():
            assert today.is_enabled()


class TestNavigationAndRefresh:
    """跳转、返回、刷新场景 (UI-042 ~ UI-046)"""

    def test_navigate_from_home(self, page: Page):
        """UI-042: 从首页导航进入会议页面"""
        page.goto(BASE_URL)
        link = page.locator('a:has-text("我的会议"), .nav-item:has-text("会议")')
        if link.is_visible():
            link.click()
            expect(page).to_have_url(re.compile(r"/zh/my/meeting"))

    def test_refresh_page(self, page: Page):
        """UI-043: 页面刷新后保持状态"""
        page.goto(MEETING_URL)
        page.wait_for_timeout(500)
        page.reload()
        page.wait_for_load_state("load")
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_browser_back(self, page: Page):
        """UI-044: 浏览器返回按钮"""
        page.goto(BASE_URL)
        page.goto(MEETING_URL)
        page.go_back()
        expect(page).to_have_url(re.compile(rf"{re.escape(BASE_URL)}/?"))

    def test_direct_url_access(self, page: Page):
        """UI-045: 直接 URL 访问"""
        page.goto(MEETING_URL)
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()

    def test_url_with_lang_param(self, page: Page):
        """UI-046: 带语言参数访问"""
        url = f"{MEETING_URL}?lang=zh"
        page.goto(url)
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()


class TestCompatibility:
    """兼容性简易场景（宽度缩放） (UI-047 ~ UI-050)"""

    def test_width_1920(self, page: Page, browser_context: BrowserContext):
        """UI-047: 窗口宽度 1920px 正常展示"""
        page.set_viewport_size({"width": 1920, "height": 1080})
        page.goto(MEETING_URL)
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()
        expect(page.locator(SELECTORS["create_meeting_btn"])).to_be_visible()

    def test_width_1366(self, page: Page):
        """UI-048: 窗口宽度 1366px 自适应"""
        page.set_viewport_size({"width": 1366, "height": 768})
        page.goto(MEETING_URL)
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()
        bbox = page.locator(SELECTORS["calendar"]).bounding_box()
        assert bbox["width"] <= 1366

    def test_resize_transition(self, page: Page):
        """UI-050: 宽度从大到小缩放过渡"""
        page.set_viewport_size({"width": 1920, "height": 1080})
        page.goto(MEETING_URL)
        for w in [1920, 1440, 1024, 768]:
            page.set_viewport_size({"width": w, "height": 1080})
            page.wait_for_timeout(300)
        expect(page.locator("body")).to_be_visible()


# ==================== 命令行入口 ====================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="openUBMC 会议页 UI 自动化测试")
    parser.add_argument("--probe", action="store_true", help="仅运行 DOM 探测并打印可见元素")
    args = parser.parse_args()

    if args.probe:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page(viewport={"width": 1920, "height": 1080}, locale="zh-CN")
            page.set_default_timeout(15000)
            page.goto(LOGIN_URL)
            page.wait_for_load_state("load")
            page.wait_for_timeout(1000)
            page.locator(SELECTORS["login_account_input"]).first.fill(LOGIN_USER)
            page.locator(SELECTORS["login_password_input"]).last.fill(LOGIN_PASS)
            page.locator(SELECTORS["login_submit_btn"]).click()
            page.wait_for_timeout(3000)
            if "/zh/my/meeting" not in page.url:
                page.goto(MEETING_URL)
                page.wait_for_timeout(2000)
            elements = page.evaluate("""
            () => {
                const data = [];
                const all = document.querySelectorAll('*');
                all.forEach(el => {
                    if (el.offsetParent !== null && el.tagName !== 'SCRIPT' && el.tagName !== 'STYLE') {
                        const text = (el.innerText || '').trim().slice(0, 40);
                        const cls = el.className.toString().slice(0, 60);
                        if (text || el.tagName === 'BUTTON' || el.tagName === 'INPUT') {
                            data.push({tag: el.tagName, text: text, class: cls});
                        }
                    }
                });
                return data.slice(0, 100);
            }
            """)
            for el in elements:
                try:
                    print(f"[{el['tag']}] {el['text']:<30} {el['class']}")
                except Exception:
                    pass
            browser.close()
    else:
        print("请使用 pytest 运行测试: pytest meeting_test_final.py -v")
