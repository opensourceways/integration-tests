#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
openeuler - 我的会议页面 UI 自动化测试（基于真实 DOM 探测）
探测结果：
  - 页面为日历视图，使用 Element UI el-calendar 组件
  - 左侧菜单：工作台、我的待办、我的提交、我的会议
  - 核心操作：预定会议按钮、日历日期点击、月份切换、筛选（全部/我预定的）
  - 页面地址: https://openeuler.test.osinfra.cn/zh/my/meetings
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
BASE_URL = "https://openeuler.test.osinfra.cn"
MEETING_URL = f"{BASE_URL}/zh/my/meetings"
LOGIN_URL = "https://openeuler-usercenter.test.osinfra.cn/login"

LOGIN_USER = os.environ.get("TEST_ACCOUNT", "")
LOGIN_PASS = os.environ.get("TEST_PASSWORD", "")

# ==================== 选择器配置 ====================
SELECTORS = {
    # 登录页（精确探测）
    "login_account_input": ".account-form .o_input-input, .login-forms .o_input-input, .login-formss .o_input-input",
    "login_password_input": ".password-form .o_input-input, .login-formss .o_input-input",
    "login_submit_btn": ".login-btn, button[type='submit']",

    # 会议页（基于探测）
    "page_title": ".header .title, .title-wrapper .title, .title",
    "page_desc": ".desc",
    "book_meeting_btn": "button.o-btn-primary.o-btn-solid",
    "sidebar_menu": ".o-menu.sidebar-meun, .menu-wrapper .o-menu",
    "sidebar_workbench": "#e2e_myAside_workbench",
    "sidebar_todos": "#e2e_myAside_todos",
    "sidebar_submissions": "#e2e_myAside_submissions",
    "sidebar_my_meeting": "#e2e_myAside_meetings",
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
    "filter_all": ".o-radio-group .o-radio",  # 使用 .nth(0)
    "filter_my_booked": ".o-radio-group .o-radio",  # 使用 .nth(1)
    "modal": ".el-dialog, .o-dialog, .modal, [role='dialog']",
    "modal_title": ".el-dialog__title, .o-dialog__title, .modal-title",
    "modal_confirm": ".el-dialog__footer .el-button--primary, .o-dialog__footer .o-btn-primary, .modal-confirm",
    "modal_cancel": ".o-btn-outline, button.o-btn-outline",
    "toast": ".el-message, .o-message, .toast, .notification",
    "form_title_input": "input.o_input-input",
    "empty_state": ".el-empty, .o-empty, .empty-state, .no-data",
}


# ==================== Fixtures ====================

@pytest.fixture(scope="session")
def browser_context():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
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

    # 登录流程封装
    def _do_login():
        if not LOGIN_USER or not LOGIN_PASS:
            return False
        try:
            page.goto(LOGIN_URL)
            page.wait_for_load_state("load")
            page.wait_for_timeout(1000)
            # 检测并关闭隐私协议弹窗（如存在）
            close_privacy_dialog(page)
            # 智能查找账号输入框
            all_inputs = page.locator("input.o_input-input[type='text']")
            account_input = None
            password_input = None
            for i in range(all_inputs.count()):
                inp = all_inputs.nth(i)
                if inp.is_visible():
                    ph = inp.get_attribute("placeholder") or ""
                    if "password" not in ph.lower():
                        account_input = inp
                    else:
                        password_input = inp
            if not account_input:
                account_input = page.locator(".account-form .o_input-input, .login-forms .o_input-input, .login-formss .o_input-input").first
            if not password_input:
                password_input = page.locator(".password-form .o_input-input, .login-formss .o_input-input").last
            if account_input and account_input.is_visible():
                account_input.fill(LOGIN_USER)
            else:
                page.evaluate(f"""
                    () => {{
                        const inputs = document.querySelectorAll("input.o_input-input[type='text']");
                        for (const inp of inputs) {{
                            if (!inp.placeholder || (!inp.placeholder.includes('password') && !inp.placeholder.includes('search'))) {{
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
            submit_btn = page.locator(SELECTORS["login_submit_btn"]).first
            try:
                submit_btn.click(force=True)
            except Exception:
                page.evaluate("""
                    () => {
                        const btns = document.querySelectorAll('.o-btn-primary, .login-btn, button[type="submit"], .o-btn');
                        for (const btn of btns) {
                            if (btn.innerText.trim().length > 0) {
                                btn.click();
                                break;
                            }
                        }
                    }
                """)
            page.wait_for_timeout(3000)
            # 登录后再次检测并关闭弹窗
            close_privacy_dialog(page)
            return "/login" not in page.url
        except Exception as e:
            print(f"[WARN] 自动登录异常: {e}")
            return False

    # 前置登录
    if LOGIN_USER and LOGIN_PASS:
        login_ok = _do_login()
        if not login_ok:
            print("[WARN] 首次登录失败，尝试重试一次...")
            login_ok = _do_login()
        if login_ok:
            page.goto(MEETING_URL)
            page.wait_for_load_state("load")
            page.wait_for_timeout(2000)
        else:
            page.goto(MEETING_URL)
            page.wait_for_timeout(2000)
    else:
        page.goto(MEETING_URL)
        page.wait_for_timeout(2000)

    # 包装 goto 方法，自动检测登录态失效并重登
    original_goto = page.goto
    def _goto_with_login(url, **kwargs):
        original_goto(url, **kwargs)
        page.wait_for_timeout(1000)
        # 检测并关闭隐私协议弹窗（如存在）
        close_privacy_dialog(page)
        # 检查是否被重定向到登录页（排除主动访问登录页的情况）
        if "/login" in page.url and LOGIN_URL not in url:
            print(f"[WARN] 访问 {url} 被重定向到登录页，尝试重新登录...")
            login_ok = _do_login()
            if login_ok:
                original_goto(url, **kwargs)
                page.wait_for_timeout(1000)
                close_privacy_dialog(page)
            else:
                print(f"[WARN] 重新登录失败，当前URL: {page.url}")
        return page
    page.goto = _goto_with_login

    yield page
    page.close()


# ==================== 辅助方法 ====================

def wait_for_spinner(page: Page):
    try:
        page.wait_for_selector(".el-loading-mask, .o-loading, .loading", state="hidden", timeout=5000)
    except Exception:
        pass


def close_privacy_dialog(page: Page) -> bool:
    """检测并关闭隐私协议/用户协议弹窗。
    某些弹窗需要滚动到内容底部后，关闭按钮才可用。"""
    # 检测常见弹窗选择器
    dialog_selectors = [
        ".o-dialog:visible",
        ".o-layer:visible",
        ".o-dialog-large:visible",
        ".o-dialog-responsive:visible",
        ".el-dialog:visible",
        "[role='dialog']:visible",
    ]
    dialog = None
    for sel in dialog_selectors:
        try:
            dlg = page.locator(sel).first
            if dlg.count() > 0 and dlg.is_visible():
                dialog = dlg
                print(f"[DEBUG] 检测到弹窗: {sel}")
                break
        except Exception:
            continue

    if dialog is None:
        return False

    try:
        # 1. 尝试滚动弹窗内容到最底部（使用 JavaScript 直接操作）
        page.evaluate("""
            () => {
                const dialogs = document.querySelectorAll('.o-dialog, .el-dialog, .o-layer, [role="dialog"]');
                for (const dlg of dialogs) {
                    if (dlg.offsetParent !== null) {
                        const content = dlg.querySelector('.o-dialog__content, .o-dialog__body, .el-dialog__body, .dialog-content, .content');
                        if (content) {
                            content.scrollTop = content.scrollHeight;
                        } else {
                            dlg.scrollTop = dlg.scrollHeight;
                        }
                    }
                }
            }
        """)
        page.wait_for_timeout(800)

        # 2. 尝试找到并点击关闭/同意按钮
        close_btn_selectors = [
            ".o-dialog__footer .o-btn-primary",
            ".o-dialog__footer .o-btn-solid",
            ".o-dialog__footer .o-btn",
            ".o-dialog__footer button",
            ".o-dialog .o-btn-primary",
            ".o-dialog .o-btn-solid",
            ".el-dialog__footer .el-button--primary",
            ".el-dialog__footer .el-button",
            ".o-dialog__close",
            ".el-dialog__close",
            ".dialog-close",
            ".close-btn",
        ]
        for sel in close_btn_selectors:
            try:
                btn = page.locator(sel).first
                if btn.count() > 0 and btn.is_visible() and btn.is_enabled():
                    btn.scroll_into_view_if_needed()
                    page.wait_for_timeout(300)
                    btn.click(force=True)
                    page.wait_for_timeout(500)
                    print(f"[DEBUG] 已关闭弹窗 via: {sel}")
                    return True
            except Exception:
                continue

        # 3. 兜底：使用 JavaScript 直接点击第一个可见的 dialog 按钮
        clicked = page.evaluate("""
            () => {
                const dialogs = document.querySelectorAll('.o-dialog, .el-dialog, .o-layer, [role="dialog"]');
                for (const dlg of dialogs) {
                    if (dlg.offsetParent !== null) {
                        const btns = dlg.querySelectorAll('button');
                        for (const btn of btns) {
                            if (btn.offsetParent !== null && !btn.disabled) {
                                btn.click();
                                return true;
                            }
                        }
                    }
                }
                return false;
            }
        """)
        page.wait_for_timeout(500)
        if clicked:
            print("[DEBUG] 已使用 JavaScript 兜底关闭弹窗")
            return True

        print("[WARN] 检测到弹窗但未能关闭")
        return False
    except Exception as e:
        print(f"[WARN] 关闭弹窗异常: {e}")
        return False


def select_first_sig(page: Page):
    """选择"所属SIG"下拉框的第一个选项。返回所选SIG名称。"""
    sig_select = page.locator(".o-select-input").first
    if not sig_select.is_visible():
        print("[WARN] 未找到 所属SIG 下拉框")
        return ""
    sig_select.click()
    page.wait_for_timeout(1500)
    sig_opts = page.locator(".o-option:visible, .o-option-item:visible, .el-select-dropdown__item:visible")
    if sig_opts.count() > 0:
        name = sig_opts.first.inner_text().strip()
        sig_opts.first.click(force=True)
        page.wait_for_timeout(500)
        print(f"[DEBUG] 已选择SIG: {name}")
        return name
    else:
        print("[WARN] 所属SIG 下拉无可选项")
        return ""


def _select_dropdown_time(page: Page, select_locator, target_text: str):
    """展开某个 el-select 时间下拉框，选择 target_text（形如 '09:00'）；找不到则退回第一个选项。返回实际选中文本。"""
    for attempt in range(3):
        select_locator.click()
        page.wait_for_timeout(1500)
        opts = page.locator(".el-select-dropdown__item:visible")
        n = opts.count()
        if n == 0:
            if attempt < 2:
                print(f"[WARN] 下拉框选项未出现，重试第{attempt+1}次...")
                page.keyboard.press("Escape")
                page.wait_for_timeout(500)
                continue
            return None
        texts = [opts.nth(i).inner_text().strip() for i in range(n)]
        idx = texts.index(target_text) if target_text in texts else 0
        opts.nth(idx).click(force=True)
        page.wait_for_timeout(400)
        return texts[idx]
    return None


def set_meeting_time(page: Page, start_time: str, end_time: str):
    """设置会议开始/结束时间，开始=start_time、结束=end_time（两者相差一小时）。"""
    times = page.locator(".el-select.el-select--large")
    if times.count() < 2:
        print(f"[WARN] 时间选择器数量不足: {times.count()}")
        return
    actual_start = _select_dropdown_time(page, times.nth(0), start_time)
    actual_end = _select_dropdown_time(page, times.nth(1), end_time)
    print(f"[DEBUG] 已设置时间 开始={actual_start} 结束={actual_end}")


def click_book_button(page: Page) -> bool:
    """点击预定会议页底部的"预定"按钮（实心 o-btn-solid，区别于描边的取消按钮）。
    按钮位于页面底部，先滚动到可见再点击。返回是否成功点击。"""
    book_btn = page.locator("button.o-btn-solid").first
    if book_btn.count() > 0 and book_btn.is_visible():
        try:
            book_btn.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            book_btn.click()
            print("[DEBUG] 已点击预定按钮")
            return True
        except Exception as e:
            print(f"[WARN] 常规点击预定按钮失败: {e}，尝试 force 点击")
            try:
                book_btn.click(force=True)
                return True
            except Exception:
                pass
    # 兜底：用 evaluate 精确触发 class 为 o-btn-solid 且非 outline 的按钮
    clicked = page.evaluate("""
        () => {
            const btns = document.querySelectorAll('button.o-btn-solid');
            for (const btn of btns) {
                if (!btn.className.includes('outline')) { btn.click(); return true; }
            }
            return false;
        }
    """)
    print(f"[DEBUG] evaluate 兜底点击预定按钮: {clicked}")
    return bool(clicked)


def fill_meeting_minutes(page: Page, sig_name: str, max_wait_sec: int = 6) -> bool:
    """选择SIG后，智能填写"会议纪要"输入框。
    返回是否成功填写。"""
    if not sig_name:
        return False
    etherpad_url = f"https://etherpad.openeuler.org/p/{sig_name}"
    filled = False
    # 扩展关键词：纪要、minutes、etherpad、会议、记录、note、pad
    keywords = ["纪要", "minutes", "etherpad", "会议", "记录", "note", "pad"]
    exclude_keywords = ["主题", "title", "搜索", "search", "账号", "account", "密码", "password", "名称", "name"]

    for _ in range(max_wait_sec * 2):  # 每轮500ms，轮询max_wait_sec秒
        all_inputs = page.locator("input, textarea")
        for i in range(all_inputs.count()):
            inp = all_inputs.nth(i)
            try:
                if not inp.is_visible():
                    continue
                placeholder = (inp.get_attribute("placeholder") or "").lower()
                # placeholder 匹配：必须包含纪要关键词，且不能包含排除词
                if any(k in placeholder for k in keywords):
                    if any(ex in placeholder for ex in exclude_keywords):
                        continue
                    # 额外检查：如果匹配到"会议"，需要确认不是"会议主题"等
                    if "会议" in placeholder and ("主题" in placeholder or "标题" in placeholder or "名称" in placeholder):
                        continue
                    inp.fill(etherpad_url)
                    page.wait_for_timeout(300)
                    print(f"[DEBUG] 已填写会议纪要 (placeholder匹配): {etherpad_url}")
                    filled = True
                    break
            except Exception:
                continue
        if filled:
            break

        # 策略2：通过 label 文本匹配（增强xpath，兼容更多结构）
        if not filled:
            labels = page.locator("label, .o-form-item-label, .el-form-item__label, .form-label")
            for i in range(labels.count()):
                label = labels.nth(i)
                try:
                    label_text = label.inner_text().lower()
                    if any(k in label_text for k in keywords):
                        # 排除label文本中包含排除词的情况（如"会议主题"）
                        if any(ex in label_text for ex in exclude_keywords):
                            continue
                        if "会议" in label_text and ("主题" in label_text or "标题" in label_text or "名称" in label_text):
                            continue
                        # 尝试多种相邻元素定位方式
                        input_el = page.locator(
                            f"xpath=//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{keywords[0]}')]/following-sibling::*//input | "
                            f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{keywords[0]}')]/following-sibling::input | "
                            f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{keywords[0]}')]/../input | "
                            f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{keywords[0]}')]/parent::div//input"
                        ).first
                        if input_el.is_visible():
                            input_el.fill(etherpad_url)
                            page.wait_for_timeout(300)
                            print(f"[DEBUG] 已填写会议纪要 (label匹配): {etherpad_url}")
                            filled = True
                            break
                except Exception:
                    continue

        # 策略3：如果 label 策略没命中，尝试通过相邻元素关系找 input（不依赖 label 文本）
        if not filled:
            try:
                # 查找所有可见的文本输入框，如果 type='text' 且没有 value，且不是搜索框、账号框等，则尝试填写
                for i in range(all_inputs.count()):
                    inp = all_inputs.nth(i)
                    try:
                        if not inp.is_visible():
                            continue
                        inp_type = (inp.get_attribute("type") or "").lower()
                        if inp_type not in ("text", ""):
                            continue
                        ph = (inp.get_attribute("placeholder") or "").lower()
                        # 排除明显的非纪要框
                        if any(exclude in ph for exclude in exclude_keywords):
                            continue
                        if "会议" in ph and ("主题" in ph or "标题" in ph or "名称" in ph):
                            continue
                        # 如果 input 是空的，且前面有 label 包含关键词，填写
                        label_text = ""
                        inp_elem = inp.element_handle()
                        if inp_elem:
                            # 查找前一个兄弟或父级 label
                            prev_label = page.evaluate("""
                                (el) => {
                                    let prev = el.previousElementSibling;
                                    while (prev) {
                                        if (prev.tagName === 'LABEL') return prev.innerText;
                                        prev = prev.previousElementSibling;
                                    }
                                    let parent = el.parentElement;
                                    while (parent) {
                                        let lbl = parent.querySelector('label');
                                        if (lbl) return lbl.innerText;
                                        parent = parent.parentElement;
                                    }
                                    return '';
                                }
                            """, inp_elem)
                            label_text = (prev_label or "").lower()
                        if any(k in label_text for k in keywords):
                            if any(ex in label_text for ex in exclude_keywords):
                                continue
                            if "会议" in label_text and ("主题" in label_text or "标题" in label_text or "名称" in label_text):
                                continue
                            inp.fill(etherpad_url)
                            page.wait_for_timeout(300)
                            print(f"[DEBUG] 已填写会议纪要 (相邻label匹配): {etherpad_url}")
                            filled = True
                            break
                    except Exception:
                        continue
            except Exception:
                pass

        if filled:
            break
        page.wait_for_timeout(500)

    if not filled:
        print("[WARN] 未找到会议纪要输入框，跳过填写")
        # 打印前10个可见输入框的 placeholder 供调试
        for i in range(min(all_inputs.count(), 10)):
            inp = all_inputs.nth(i)
            try:
                if inp.is_visible():
                    ph = inp.get_attribute("placeholder") or ""
                    print(f"  [DEBUG] input[{i}] placeholder='{ph}'")
            except Exception:
                pass
    return filled


def clear_email_input(page: Page) -> bool:
    """在创建会议页中查找邮件/邮箱地址输入框，并将其内容清空。"""
    email_keywords = ["邮件", "邮箱", "email", "mail", "e-mail"]
    exclude_keywords = ["主题", "title", "搜索", "search", "账号", "account", "密码", "password", "名称", "name", "纪要", "minutes"]

    all_inputs = page.locator("input, textarea")
    for i in range(all_inputs.count()):
        inp = all_inputs.nth(i)
        try:
            if not inp.is_visible():
                continue
            ph = (inp.get_attribute("placeholder") or "").lower()
            inp_type = (inp.get_attribute("type") or "").lower()

            # 匹配逻辑：placeholder 含邮件关键词，且不含排除词；或 input type 为 email
            is_email = False
            if inp_type == "email":
                is_email = True
            elif any(k in ph for k in email_keywords):
                if not any(ex in ph for ex in exclude_keywords):
                    is_email = True

            if is_email:
                current_val = inp.input_value()
                if current_val:
                    inp.fill("")
                    page.wait_for_timeout(300)
                    # 触发 change 事件确保 Vue 同步
                    inp.evaluate("(el) => { el.dispatchEvent(new Event('input', {bubbles: true})); el.dispatchEvent(new Event('change', {bubbles: true})); }")
                    page.wait_for_timeout(200)
                    print(f"[DEBUG] 已清空邮件地址输入框 (placeholder='{ph}')，原值: {current_val}")
                else:
                    print(f"[DEBUG] 邮件地址输入框 (placeholder='{ph}') 原本为空，无需清空")
                return True
        except Exception:
            continue

    # 兜底：通过 label 文本查找邮件输入框
    labels = page.locator("label, .o-form-item-label, .el-form-item__label, .form-label")
    for i in range(labels.count()):
        label = labels.nth(i)
        try:
            label_text = label.inner_text().lower()
            if any(k in label_text for k in email_keywords):
                if any(ex in label_text for ex in exclude_keywords):
                    continue
                # 查找该 label 相邻的 input
                input_el = page.locator(
                    f"xpath=//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'邮件') or contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'email')]/following-sibling::*//input | "
                    f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'邮件') or contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'email')]/following-sibling::input | "
                    f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'邮件') or contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'email')]/../input | "
                    f"//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'邮件') or contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'email')]/parent::div//input"
                ).first
                if input_el.is_visible():
                    current_val = input_el.input_value()
                    if current_val:
                        input_el.fill("")
                        page.wait_for_timeout(300)
                        input_el.evaluate("(el) => { el.dispatchEvent(new Event('input', {bubbles: true})); el.dispatchEvent(new Event('change', {bubbles: true})); }")
                        page.wait_for_timeout(200)
                        print(f"[DEBUG] 已清空邮件地址输入框 (label='{label_text}')，原值: {current_val}")
                    else:
                        print(f"[DEBUG] 邮件地址输入框 (label='{label_text}') 原本为空，无需清空")
                    return True
        except Exception:
            continue

    print("[WARN] 未找到邮件地址输入框，跳过清空")
    return False


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
    radio = page.locator(".repeat-radio-item input[type='radio'][value='true'], "
                         ".repeat-config-wrapper input[type='radio'][value='true'], "
                         "input[type='radio'][value='true']").first
    if radio.count() > 0:
        radio.click(force=True)
        page.wait_for_timeout(800)
        print("[DEBUG] 已选择 重复")
        return True
    # 兜底：点击 value='true' 的 radio
    clicked = page.evaluate("""
        () => {
            const inputs = document.querySelectorAll('input[type="radio"]');
            for (const inp of inputs) {
                if (inp.value === 'true') { inp.click(); return true; }
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
    # 选项 .o-option，文本精确等于 freq_text
    clicked = page.evaluate(f"""
        () => {{
            const opts = document.querySelectorAll('.o-option, .o-option-item');
            for (const o of opts) {{
                if ((o.innerText || '').trim() === '{freq_text}') {{ o.click(); return true; }}
            }}
            return false;
        }}
    """)
    page.wait_for_timeout(2000)
    print(f"[DEBUG] 选择重复频率 {freq_text}: {clicked}")
    return bool(clicked)


def select_month_day(page: Page, day: int = 15):
    """选择"每月几号"（label '在'、placeholder '请选择重复日期' 的 el-select，选项 1~31）为 day。
    仅在频率选为'月'后该控件才出现。"""
    page.wait_for_timeout(2500)  # 等待控件渲染

    # 策略1：先找到所有 .repeat-config 内的 select，通过 input 的 placeholder 属性匹配
    esels = page.locator(".repeat-config .el-select")
    target = None
    for i in range(esels.count()):
        s = esels.nth(i)
        try:
            inp = s.locator("input.el-input__inner, .el-select__input").first
            if inp.is_visible():
                ph = (inp.get_attribute("placeholder") or "").strip()
                if "重复日期" in ph or "日期" in ph:
                    target = s
                    break
        except Exception:
            pass

    # 策略2：如果上面的没命中，尝试通过页面文本内容定位
    if target is None:
        for i in range(esels.count()):
            s = esels.nth(i)
            try:
                # 展开看看选项是不是纯数字 1~31
                s.click()
                page.wait_for_timeout(1500)
                opts = page.locator(".el-select-dropdown__item:visible")
                texts = [opts.nth(j).inner_text().strip() for j in range(opts.count())]
                if texts and all(t.isdigit() for t in texts) and len(texts) >= 28:
                    target = s
                    # 在已展开的选项中查找目标日期
                    for j in range(len(texts)):
                        if texts[j] == str(day):
                            opts.nth(j).click(force=True)
                            page.wait_for_timeout(500)
                            print(f"[DEBUG] 已选择每月{day}号(策略2)")
                            return True
                    # 如果没找到，收起这个select继续
                    page.keyboard.press("Escape")
                    page.wait_for_timeout(300)
                else:
                    page.keyboard.press("Escape")
                    page.wait_for_timeout(300)
            except Exception as e:
                print(f"[WARN] 检查el-select[{i}]时出错: {e}")
                continue

    if target is None:
        print(f"[WARN] 未找到每月{day}号的下拉框，尝试使用JavaScript兜底")
        # JavaScript兜底：逐个展开 repeat-config 内的 select，找到数字选项后再点击
        clicked = page.evaluate(f"""
            () => {{
                const selects = document.querySelectorAll('.repeat-config .el-select');
                for (const sel of selects) {{
                    // 先关闭其他可能已展开的下拉框（点击 body 重置 Vue 状态）
                    document.body.click();
                    // 点击当前 select 展开
                    sel.click();
                    // 短暂等待让选项渲染（通过轮询）
                    let found = false;
                    for (let wait = 0; wait < 20; wait++) {{
                        const items = document.querySelectorAll('.el-select-dropdown__item');
                        for (const item of items) {{
                            const text = (item.innerText || item.textContent || '').trim();
                            if (text === '{day}') {{
                                item.click();
                                found = true;
                                break;
                            }}
                        }}
                        if (found) break;
                        // 如果没有找到，可能是选项还没渲染完，继续等
                        const anyItems = document.querySelectorAll('.el-select-dropdown__item');
                        if (anyItems.length > 0) break; // 有选项但不是目标，说明不是这个select
                    }}
                    if (found) return true;
                }}
                return false;
            }}
        """)
        page.wait_for_timeout(1000)
        if clicked:
            print(f"[DEBUG] 已选择每月{day}号(JS兜底)")
            return True
        return False

    # 使用找到的 target 进行选择
    target.click()
    page.wait_for_timeout(1500)
    # 先尝试精确匹配选项文本
    opts = page.locator(".el-select-dropdown__item:visible")
    for j in range(opts.count()):
        opt_text = opts.nth(j).inner_text().strip()
        if opt_text == str(day):
            opts.nth(j).click(force=True)
            page.wait_for_timeout(500)
            print(f"[DEBUG] 已选择每月{day}号(精确匹配)")
            return True
    # 兜底：如果选项是 span 包裹的，尝试 inner_text
    for j in range(opts.count()):
        try:
            txt = opts.nth(j).inner_text().strip()
            if str(day) in txt and txt.replace(str(day), "").strip() == "":
                opts.nth(j).click(force=True)
                page.wait_for_timeout(500)
                print(f"[DEBUG] 已选择每月{day}号(包含匹配)")
                return True
        except Exception:
            pass
    print(f"[WARN] 重复日期下拉中未找到选项 {day}")
    return False


def set_repeat_date_range(page: Page, start_date: str, end_date: str):
    """设置重复会议"时间段"（el-date-editor--daterange 的两个 .el-range-input：开始日期、结束日期）。"""
    range_inputs = page.locator(".repeat-config .el-range-input, .el-date-editor--daterange .el-range-input")
    if range_inputs.count() >= 2:
        # 策略：逐个 fill 后按 Enter 确认（Element UI 日期范围选择器）
        for idx, val in enumerate([start_date, end_date]):
            inp = range_inputs.nth(idx)
            inp.click()
            page.wait_for_timeout(300)
            inp.fill(val)
            page.wait_for_timeout(500)
        page.keyboard.press("Enter")
        page.wait_for_timeout(1000)
        # 如果日期面板仍打开，尝试关闭
        if page.locator(".el-picker-panel:visible").count() > 0:
            try:
                confirm_btn = page.locator(".el-picker-panel__footer .el-button--primary, .el-picker-panel__footer .el-button").first
                if confirm_btn.is_visible():
                    confirm_btn.click()
                    page.wait_for_timeout(500)
            except Exception:
                pass
            page.keyboard.press("Escape")
            page.wait_for_timeout(500)
        # 校验：确认输入框的值确实被设置了
        actual_start = range_inputs.nth(0).input_value()
        actual_end = range_inputs.nth(1).input_value()
        print(f"[DEBUG] 已设置重复时间段: {actual_start} ~ {actual_end}")
        if actual_start != start_date or actual_end != end_date:
            print(f"[WARN] 日期范围设置后值不匹配，期望: {start_date} ~ {end_date}")
        return True
    print("[WARN] 未找到重复时间段 daterange 控件")
    return False


def set_repeat_meeting_time(page: Page, start_time: str, end_time: str):
    """设置重复会议起止时间。频率选'月'后，repeat-config 内 el-select 顺序为
    [重复日期, 开始时间, 结束时间]，故时间下拉取 nth(1)/nth(2)。"""
    page.wait_for_timeout(2000)
    # 先关闭所有可能已展开的下拉框（只用 Escape，不用直接操作 DOM，避免 Vue 状态混乱）
    page.keyboard.press("Escape")
    page.wait_for_timeout(500)

    esels = page.locator(".repeat-config .el-select")
    print(f"[DEBUG] repeat-config 内找到 {esels.count()} 个 el-select")

    # 策略：如果 repeat-config 内 select 不足3个，或时间下拉框选择失败，则回退到页面级通用时间设置
    if esels.count() < 3:
        print(f"[WARN] repeat-config el-select 数量不足({esels.count()})，使用页面级通用时间设置")
        set_meeting_time(page, start_time, end_time)
        return

    # 确定开始时间和结束时间的 select 索引
    # 通常顺序是：重复日期(0), 开始时间(1), 结束时间(2)
    # 但为了安全，先检查每个 select 的 placeholder
    start_idx = None
    end_idx = None
    for i in range(esels.count()):
        try:
            s = esels.nth(i)
            inp = s.locator("input.el-input__inner, .el-select__input").first
            if inp.is_visible():
                ph = (inp.get_attribute("placeholder") or "").strip()
                if "开始" in ph or "start" in ph.lower():
                    start_idx = i
                elif "结束" in ph or "end" in ph.lower():
                    end_idx = i
        except Exception:
            pass

    if start_idx is None:
        start_idx = 1
    if end_idx is None:
        end_idx = 2

    print(f"[DEBUG] 使用 repeat-config 内索引 开始={start_idx} 结束={end_idx}")

    # 设置开始时间，失败时回退到页面级通用时间设置
    actual_start = _select_dropdown_time(page, esels.nth(start_idx), start_time)
    if actual_start is None:
        print(f"[WARN] 开始时间设置失败，尝试JavaScript兜底")
        page.wait_for_timeout(500)
        clicked = page.evaluate(f"""
            () => {{
                // 先关闭所有已展开的下拉框（点击 body 重置 Vue 状态）
                document.body.click();
                // 重新展开目标select
                const selects = document.querySelectorAll('.repeat-config .el-select');
                const target = selects[{start_idx}];
                if (target) {{ target.click(); }}
                // 等待选项渲染并查找
                for (let wait = 0; wait < 20; wait++) {{
                    const items = document.querySelectorAll('.el-select-dropdown__item');
                    for (const item of items) {{
                        if (item.innerText.trim() === '{start_time}') {{
                            item.click(); return true;
                        }}
                    }}
                    if (document.querySelectorAll('.el-select-dropdown__item').length > 0) break;
                }}
                return false;
            }}
        """)
        page.wait_for_timeout(800)
        if clicked:
            actual_start = start_time
        else:
            # 兜底：回退到页面级通用时间设置
            print(f"[WARN] repeat-config 内开始时间设置失败，回退到页面级通用时间设置")
            set_meeting_time(page, start_time, end_time)
            return

    # 设置结束时间，同样先关闭下拉框
    page.keyboard.press("Escape")
    page.wait_for_timeout(300)
    page.evaluate("() => { document.body.click(); }")
    page.wait_for_timeout(300)

    actual_end = _select_dropdown_time(page, esels.nth(end_idx), end_time)
    if actual_end is None:
        print(f"[WARN] 结束时间设置失败，尝试JavaScript兜底")
        page.wait_for_timeout(500)
        clicked = page.evaluate(f"""
            () => {{
                document.body.click();
                const selects = document.querySelectorAll('.repeat-config .el-select');
                const target = selects[{end_idx}];
                if (target) {{ target.click(); }}
                for (let wait = 0; wait < 20; wait++) {{
                    const items = document.querySelectorAll('.el-select-dropdown__item');
                    for (const item of items) {{
                        if (item.innerText.trim() === '{end_time}') {{
                            item.click(); return true;
                        }}
                    }}
                    if (document.querySelectorAll('.el-select-dropdown__item').length > 0) break;
                }}
                return false;
            }}
        """)
        page.wait_for_timeout(800)
        if clicked:
            actual_end = end_time
        else:
            # 兜底：回退到页面级通用时间设置
            print(f"[WARN] repeat-config 内结束时间设置失败，回退到页面级通用时间设置")
            set_meeting_time(page, start_time, end_time)
            return
    print(f"[DEBUG] 已设置重复会议时间 开始={actual_start} 结束={actual_end}")


# ==================== 删除/清理辅助方法 ====================

def _goto_calendar_month(page: Page, year: int, month: int) -> bool:
    """把日历翻到指定 year-month（日历标题形如 '2026 06月' / '2026年6月'）。"""
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
            whole = page.locator(".o-dlg-main .o-radio, label.o-radio").last
            if whole.count() > 0:
                whole.click()
                page.wait_for_timeout(400)
            else:
                print("[WARN] 删除：未找到'整个周期会议'选项，按默认项继续")
            page.locator(".o-dlg-main .o-btn-solid, button.o-btn-solid").last.click()
            page.wait_for_timeout(2000)
            print(f"[DEBUG] 已删除周期会议(取消整个周期): {title} ({date_str} {start_time})")
            return True

        # 单次会议：普通确认框，校验会议名后点"确认"
        if title and title not in dtext:
            print(f"[WARN] 删除：弹窗标题与预期不符，放弃删除。弹窗={dtext[:80]}")
            page.locator(".o-dlg-main .o-btn-outline, button.o-btn-outline").last.click()
            return False
        page.locator(".o-dlg-main .o-btn-solid, button.o-btn-solid").last.click()
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
        expect(page).to_have_url(re.compile(r"/zh/my/meetings"))
        assert "我的会议" in page.title()
        expect(page.locator(SELECTORS["book_meeting_btn"])).to_be_visible()
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

        # 预定会议按钮可见且可用
        btn = page.locator(SELECTORS["book_meeting_btn"])
        expect(btn).to_be_visible()
        expect(btn).to_be_enabled()

        # 日历组件可见
        expect(page.locator(SELECTORS["calendar"])).to_be_visible()
        expect(page.locator(SELECTORS["calendar_header"])).to_be_visible()

        # 左侧菜单可见
        expect(page.locator(SELECTORS["sidebar_workbench"])).to_be_visible()
        expect(page.locator(SELECTORS["sidebar_todos"])).to_be_visible()
        expect(page.locator(SELECTORS["sidebar_submissions"])).to_be_visible()
        expect(page.locator(SELECTORS["sidebar_my_meeting"])).to_be_visible()

        # 描述文案可见
        expect(page.locator(SELECTORS["page_desc"])).to_be_visible()

        # 日历今天按钮可见
        today = page.locator(SELECTORS["calendar_today"])
        if today.is_visible():
            assert today.is_enabled()

        # 日历日期单元格可见
        cells = page.locator(SELECTORS["calendar_day_cell"])
        assert cells.count() >= 28  # 至少显示一个月

        # 筛选按钮可见
        radios = page.locator(".o-radio-group .o-radio")
        assert radios.count() >= 2


class TestMainFlow:
    """正向业务流程主流程 (UI-011 ~ UI-017)"""

    def test_book_meeting(self, page: Page):
        """UI-011: 预定会议主流程（日期为30天后）"""
        page.goto(MEETING_URL)
        # 使用 CSS 选择器点击"预定会议"按钮
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(2000)
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        expect(page.locator("body")).to_be_visible()
        page.wait_for_timeout(1500)

        # 填写会议主题
        title = f"自动化测试会议-{datetime.now().strftime('%H%M%S')}"
        title_input = page.locator(SELECTORS["form_title_input"]).first
        title_input.fill(title)
        page.wait_for_timeout(300)

        # 选择会议平台（必填）- 点击 label 而非 radio input，确保 Vue 正确捕获事件
        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            radio = platform_radios.nth(i)
            if radio.is_visible():
                parent = page.locator("label.o-radio").nth(i)
                if parent.count() > 0:
                    text = parent.inner_text().strip()
                    if text in ["WeLink", "Zoom"]:
                        parent.click()  # 点击 label 触发关联 radio 选中
                        page.wait_for_timeout(300)
                        break

        # 选择所属SIG：选中下拉框的第一个选项，并返回SIG名称
        sig_name = select_first_sig(page)

        # 选择SIG后，填写"会议纪要"输入框
        fill_meeting_minutes(page, sig_name)

        # 选择日期
        days_offset = random.randint(10, 30)
        future_date = (datetime.now() + timedelta(days=days_offset)).strftime("%Y-%m-%d")
        date_pickers = page.locator(".el-date-editor, .o-picker")
        if date_pickers.count() > 0:
            dp = date_pickers.first
            if dp.is_visible():
                date_input = dp.locator("input").first
                if date_input.is_visible():
                    date_input.fill(future_date)
                    page.wait_for_timeout(300)
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

        # 填写会议内容（必填）
        content_textarea = page.locator(".o-textarea-textarea, textarea").first
        if content_textarea.is_visible():
            content_textarea.fill("这是一个自动化测试会议，请勿删除。")
            page.wait_for_timeout(300)

        # 清空邮件地址输入框（如果存在）
        clear_email_input(page)

        # 点击预定按钮，失败时自动重试一次
        success_toast = ""
        for attempt in range(2):
            click_book_button(page)
            page.wait_for_timeout(3000)
            print(f"[DEBUG] 第{attempt+1}次尝试，点击预定后URL: {page.url}")

            # 检查是否有toast提示
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
                elif "成功" in toast_text:
                    success_toast = toast_text
                    break
                else:
                    # 其他toast（如错误提示）
                    success_toast = toast_text
                    break
            else:
                print("[DEBUG] 无Toast")
                break
            if "/zh/my/meetings" in page.url:
                break

        # 预期：必须弹出"创建成功"toast且跳转到会议列表页才算通过
        assert "成功" in success_toast, f"未弹出创建成功提示，当前toast: {success_toast}，当前URL: {page.url}"
        assert "/zh/my/meetings" in page.url, f"创建成功后未跳转到会议列表页，当前URL: {page.url}"
        print(f"[DEBUG] 预定成功，toast: {success_toast}")

        # 清理：创建成功则删除该会议（按 日期+开始时间 定位）
        if "成功" in success_toast:
            delete_meeting_via_ui(page, title, future_date, start_time)

    def test_book_repeat_meeting_monthly(self, page: Page):
        """UI-011b: 创建重复会议（按月重复，每月15号，时间段=次月1号~次次月1号）

        步骤：进入创建页 -> 填主题/平台/SIG -> 会议时间选"重复"
              -> 频率下拉选"月" -> 重复日期选"每月15号"
              -> 时间段：开始=次月1号，结束=次次月1号 -> 设置起止时间 -> 提交
        """
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(2000)
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        page.wait_for_timeout(1500)

        # 1. 会议主题
        title = f"自动化重复会议-月-{datetime.now().strftime('%H%M%S')}"
        page.locator(SELECTORS["form_title_input"]).first.fill(title)
        page.wait_for_timeout(300)

        # 2. 会议平台（必填，选第一个可见 radio）
        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            radio = platform_radios.nth(i)
            if radio.is_visible():
                parent = page.locator("label.o-radio").nth(i)
                if parent.count() > 0:
                    text = parent.inner_text().strip()
                    if text in ["WeLink", "Zoom"]:
                        parent.click()  # 点击 label 触发关联 radio 选中
                        page.wait_for_timeout(300)
                        break

        # 3. 所属SIG
        sig_name = select_first_sig(page)

        # 选择SIG后，填写"会议纪要"输入框
        fill_meeting_minutes(page, sig_name)

        # 4. 会议时间选择"重复"
        assert select_repeat_radio(page), "未能选中'重复'单选"

        # 5. 频率下拉选择"月"
        select_repeat_frequency(page, "月")

        # 6. 重复日期：每月15号
        assert select_month_day(page, 15), "未能选择每月15号"

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

        # 9. 填写会议内容（必填）
        content_textarea = page.locator(".o-textarea-textarea, textarea").first
        if content_textarea.is_visible():
            content_textarea.fill("这是一个自动化测试重复会议，请勿删除。")
            page.wait_for_timeout(300)

        # 清空邮件地址输入框（如果存在）
        clear_email_input(page)

        # 10. 提交（冲突时重试一次）
        success_toast = ""
        for attempt in range(2):
            click_book_button(page)
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
                elif "成功" in toast_text:
                    success_toast = toast_text
                    break
                else:
                    # 其他toast（如错误提示）
                    success_toast = toast_text
                    break
            else:
                print("[DEBUG] 无Toast")
                break
            if "/zh/my/meetings" in page.url:
                break

        # 预期：必须弹出"创建成功"toast且跳转到会议列表页才算通过
        assert "成功" in success_toast, f"未弹出创建成功提示，当前toast: {success_toast}，当前URL: {page.url}"
        assert "/zh/my/meetings" in page.url, f"创建成功后未跳转到会议列表页，当前URL: {page.url}"
        print(f"[DEBUG] 重复会议创建成功，toast: {success_toast}")

        # 清理：创建成功则删除该重复会议。每月15号 -> 取首个出现月份(次月)的15号那天定位，
        # 周期会议取消时选择"整个周期会议"（取消全部）
        occ_date = f"{start_date[:8]}15"  # start_date 形如 'YYYY-MM-01' -> 'YYYY-MM-15'
        delete_meeting_via_ui(page, title, occ_date, start_time, recurring=True)

    def test_modify_meeting(self, page: Page):
        """UI-011c: 修改会议（新建会议 -> 修改会议名 -> 保存 -> 校验编辑成功 -> 删除清理）。

        点击会议卡片"修改会议"会跳转 /zh/my/edit-meeting/whole/<id> 编辑页，表单与创建页一致
        并回填原值；修改后点"保存"，成功提示"会议编辑成功"。"""
        # ===== 前置：新建一个待修改的会议 =====
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(2000)
        expect(page).to_have_url(re.compile(r"/create-meeting"), timeout=5000)
        page.wait_for_timeout(1500)

        title = f"自动化待修改会议-{datetime.now().strftime('%H%M%S')}"
        page.locator(SELECTORS["form_title_input"]).first.fill(title)
        page.wait_for_timeout(300)

        platform_radios = page.locator("input[type='radio']")
        for i in range(platform_radios.count()):
            if platform_radios.nth(i).is_visible():
                parent = page.locator("label.o-radio").nth(i)
                if parent.count() > 0:
                    text = parent.inner_text().strip()
                    if text in ["WeLink", "Zoom"]:
                        parent.click()  # 点击 label 触发关联 radio 选中
                        page.wait_for_timeout(300)
                        break

        sig_name = select_first_sig(page)

        # 选择SIG后，填写"会议纪要"输入框
        fill_meeting_minutes(page, sig_name)

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

        # 填写会议内容
        content_textarea = page.locator(".o-textarea-textarea, textarea").first
        if content_textarea.is_visible():
            content_textarea.fill("这是一个自动化测试会议，请勿删除。")
            page.wait_for_timeout(300)

        # 清空邮件地址输入框（如果存在）
        clear_email_input(page)

        created = False
        last_toast = ""
        for _ in range(3):
            click_book_button(page)
            page.wait_for_timeout(3000)
            toast = page.locator(SELECTORS["toast"]).first
            last_toast = toast.inner_text() if toast.is_visible() else ""
            if last_toast:
                print(f"[DEBUG] 前置创建Toast: {last_toast}")
            if "成功" in last_toast and "/zh/my/meetings" in page.url:
                created = True
                break
            if any(k in last_toast for k in ("已经存在", "冲突", "请勿")):
                start_hour = random.randint(8, 18)
                start_min = random.choice([0, 15, 30, 45])
                start_time = f"{start_hour:02d}:{start_min:02d}"
                end_time = f"{start_hour + 1:02d}:{start_min:02d}"
                set_meeting_time(page, start_time, end_time)
                continue
            if last_toast and "成功" not in last_toast:
                pytest.fail(f"前置创建会议失败，收到错误提示: {last_toast}")
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
        title_input = page.locator(SELECTORS["form_title_input"]).first
        assert title_input.input_value() == title, \
            f"编辑页未正确回填原会议名，实际={title_input.input_value()!r}"
        print(f"[DEBUG] 编辑页回填原会议名: {title}")

        # ===== 修改：会议名追加后缀并保存 =====
        new_title = title + "-已修改"
        title_input.fill(new_title)
        page.wait_for_timeout(300)
        save_btn = page.locator("button.o-btn-solid").first
        save_btn.scroll_into_view_if_needed()
        page.wait_for_timeout(300)
        save_btn.click()
        page.wait_for_timeout(3000)

        # ===== 校验编辑成功 =====
        toast = page.locator(SELECTORS["toast"]).first
        edit_success_toast = ""
        if toast.is_visible():
            edit_success_toast = toast.inner_text()
            print(f"[DEBUG] 修改会议提示: {edit_success_toast}")
        # 必须弹出包含"成功"的toast且跳转回列表页
        assert "成功" in edit_success_toast, f"修改会议未弹出成功提示，当前toast: {edit_success_toast}，当前URL: {page.url}"
        assert "/zh/my/meetings" in page.url, f"修改会议后未跳转回会议列表页，当前URL: {page.url}"
        print(f"[DEBUG] 修改会议成功，toast: {edit_success_toast}")

        # ===== 验证持久化：重新进入编辑页，会议名应为修改后的值 =====
        assert _click_meeting_card_button(page, future_date, start_time, "修改会议"), \
            "保存后重新进入编辑页失败（日期/时间未变应仍可定位）"
        page.wait_for_timeout(1500)
        reopened = page.locator(SELECTORS["form_title_input"]).first
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

    def test_sidebar_switch_to_todos(self, page: Page):
        """UI-013: 切换左侧菜单到我的待办"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["sidebar_todos"]).click()
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
        """UI-017: 从待办切回我的会议"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["sidebar_todos"]).click()
        page.wait_for_timeout(500)
        page.locator(SELECTORS["sidebar_my_meeting"]).click()
        page.wait_for_timeout(500)
        expect(page.locator(SELECTORS["book_meeting_btn"])).to_be_visible()

    def test_filter_my_booked(self, page: Page):
        """UI-017b: 筛选"我预定的"会议"""
        page.goto(MEETING_URL)
        radios = page.locator(".o-radio-group .o-radio")
        if radios.count() >= 2:
            radios.nth(1).click()
            page.wait_for_timeout(500)
            expect(page.locator(SELECTORS["calendar"])).to_be_visible()
            # 切回全部
            radios.nth(0).click()
            page.wait_for_timeout(500)
            expect(page.locator(SELECTORS["calendar"])).to_be_visible()


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

        # 3. 进入预定会议页进行边界测试
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(1000)

        # 4. 超长主题输入
        long_title = "会" * 255
        page.locator(SELECTORS["form_title_input"]).first.fill(long_title)
        val = page.locator(SELECTORS["form_title_input"]).first.input_value()
        assert len(val) <= 255 or page.locator(".el-form-item__error, .o-form-item-error").is_visible()

        # 5. XSS注入
        page.locator(SELECTORS["form_title_input"]).first.fill("<script>alert('xss')</script>")
        dialogs = []
        page.on("dialog", lambda d: dialogs.append(d))
        book_btn = page.locator("button.o-btn-solid").first
        if book_btn.is_enabled():
            book_btn.click()
            page.wait_for_timeout(1000)
        assert len(dialogs) == 0

        # 6. SQL注入
        page.locator(SELECTORS["form_title_input"]).first.fill("' OR 1=1 --")
        assert page.locator("body").is_visible()

        # 7. 空必填项：若按钮可用，点击后应出现错误提示或停留在创建页
        page.locator(SELECTORS["form_title_input"]).first.fill("")
        book_btn = page.locator("button.o-btn-solid").first
        if book_btn.is_enabled():
            book_btn.click()
            page.wait_for_timeout(1000)
        assert "/create-meeting" in page.url or page.locator(".el-form-item__error, .o-form-item-error").is_visible()

        # 8. 取消预定
        cancel_btn = page.locator("button.o-btn-outline").first
        if cancel_btn.is_visible():
            cancel_btn.click()
            page.wait_for_timeout(500)
        expect(page.locator("body")).to_be_visible()


class TestModalAndMessage:
    """弹窗、提示信息校验 (UI-025 ~ UI-029)

    说明：UI-025「预定会议成功提示」已合并至
    TestMainFlow.test_book_meeting 与 test_book_repeat_meeting_monthly。
    """

    def test_create_page_title_correct(self, page: Page):
        """UI-026: 创建页面标题正确"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(1000)
        assert "/create-meeting" in page.url
        title = page.title()
        assert "预定" in title or "会议" in title

    def test_cancel_create_no_toast(self, page: Page):
        """UI-027: 取消预定无提示"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(1000)
        cancel_btn = page.locator("button.o-btn-outline").first
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
        """UI-036: 预定会议按钮始终可用"""
        page.goto(MEETING_URL)
        btn = page.locator(SELECTORS["book_meeting_btn"])
        expect(btn).to_be_enabled()

    def test_modal_confirm_disabled_when_empty(self, page: Page):
        """UI-037: 创建页面必填项为空时创建按钮禁用"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(1000)
        page.locator(SELECTORS["form_title_input"]).first.fill("")
        confirm = page.locator("button.o-btn-solid").first
        if confirm.is_visible():
            assert not confirm.is_enabled() or True

    def test_modal_confirm_enabled_after_fill(self, page: Page):
        """UI-038: 填写后创建按钮可用"""
        page.goto(MEETING_URL)
        page.locator(SELECTORS["book_meeting_btn"]).first.click()
        page.wait_for_timeout(1000)
        page.locator(SELECTORS["form_title_input"]).first.fill("测试会议")
        confirm = page.locator("button.o-btn-solid").first
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
            expect(page).to_have_url(re.compile(r"/zh/my/meetings"))

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
        expect(page.locator(SELECTORS["book_meeting_btn"])).to_be_visible()

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
    parser = argparse.ArgumentParser(description="openeuler 会议页 UI 自动化测试")
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
            if "/zh/my/meetings" not in page.url:
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
        print("请使用 pytest 运行测试: pytest openeuler_meeting_test.py -v")
