#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
身份验证弹窗处理

统一「用户身份验证」弹窗处理逻辑：限流等待 → 滑块 → 邮箱验证码 → 确认。
内置铁律 F-12（滑块必须等图加载完再破解）。
"""

import time
from playwright.sync_api import TimeoutError as PWTimeout
from common.debug_utils import log
from slider_token import solve_slider_token  # 用令牌页适配版（已内置等图逻辑）
from email_verify import fetch_verification_code

# 全局变量：上次发送验证码的时间戳（用于限流）
_last_send_ts = 0.0


def pass_identity_verify(page, step: str = "operation") -> None:
    """
    处理「用户身份验证」弹窗：限流等待 → 滑块 → 邮箱取码 → 确认。

    :param page: Playwright 页面对象
    :param step: 操作步骤名（用于日志与快照命名）

    处理流程：
      1. 检测弹窗是否出现（emailToken 仍有效时不弹）
      2. 限流等待（确保两次验证码间隔 > 65s）
      3. 点击「获取验证码」
      4. 处理滑块验证（自动破解，失败提示人工）
      5. 等待「发送成功」Toast
      6. IMAP 取邮箱验证码
      7. 填码并确认

    内置铁律 F-12：滑块必须等图加载完再破解（slider_token 已处理）。
    """
    global _last_send_ts

    # 弹窗可能不出现（emailToken 仍在有效期内）
    try:
        page.wait_for_selector("text=用户身份验证", timeout=8_000)
    except PWTimeout:
        log(f"  [{step}] 未弹身份验证（emailToken 仍有效），跳过")
        return

    log(f"  [{step}] 出现「用户身份验证」弹窗")

    # 限流等待：确保两次「获取验证码」间隔 > 65s
    if _last_send_ts:
        wait = 65 - (time.time() - _last_send_ts)
        if wait > 0:
            log(f"  后端限流：等待 {wait:.0f}s 再发下一封验证码")
            time.sleep(wait)

    # ① 点「获取验证码」
    page.get_by_text("获取验证码", exact=False).last.click()
    _last_send_ts = time.time()
    log(f"  [{step}] 已点击「获取验证码」")

    # ② 滑块验证（用 slider_token 版本，已内置等图逻辑，铁律 F-12）
    try:
        page.wait_for_selector(".verifybox", timeout=10_000)
        log(f"  [{step}] 弹出滑块，尝试自动破解")
        if not solve_slider_token(page):
            # 按项目规范：滑块需人工时必须明确提醒操作人
            log("  " + "!" * 60)
            log("  !! 阿蓁，滑块自动破解失败")
            log("  !! 请在 Chrome 窗口手动完成滑块验证")
            log("  !! 脚本会等待最多 3 分钟")
            log("  " + "!" * 60)
            page.wait_for_selector(".verifybox", state="hidden", timeout=180_000)
            log(f"  [{step}] 人工滑块已完成")
    except PWTimeout:
        log(f"  [{step}] 未出现滑块")

    # ③ 等「发送成功」Toast
    try:
        page.wait_for_selector("text=发送成功", timeout=20_000)
        log(f"  [{step}] 已捕获 Toast：发送成功")
    except PWTimeout:
        log(f"  [{step}] 未捕获「发送成功」Toast（继续尝试取码）")

    # 在确认发送成功后再记录时间戳，确保只获取新邮件
    code_since = time.time()

    # ④ IMAP 取码
    code = fetch_verification_code(code_since, timeout=180, poll_interval=5)
    log(f"  [{step}] 邮箱取码成功：{code}")

    # ⑤ 填码（验证码框 maxlength=6，用它区分于页面其它输入框）
    box = page.locator('input[maxlength="6"]')
    if box.count() == 0:
        box = page.locator('.o-dialog input[type="text"]')
    box.last.fill(code)
    log(f"  [{step}] 已填写验证码：{code}")

    # 验证验证码是否填写成功
    filled_value = box.last.input_value()
    log(f"  [{step}] 验证码输入框当前值：{filled_value}")

    # 等待滑块区域消失（如果存在）
    try:
        page.wait_for_selector(".verify-bar-area", state="hidden", timeout=5_000)
        log(f"  [{step}] 滑块区域已消失")
    except PWTimeout:
        log(f"  [{step}] 滑块区域不存在或已消失")

    # ⑥ 确认（弹窗内定位必须限定 .o-dlg-footer 作用域，铁律 F-10）
    confirm_btn = page.locator(".o-dlg-footer").get_by_role("button", name="确认")
    log(f"  [{step}] 找到确认按钮，数量：{confirm_btn.count()}")

    # 检查确认按钮是否可见和可点击
    if confirm_btn.count() > 0:
        is_visible = confirm_btn.first.is_visible()
        is_enabled = confirm_btn.first.is_enabled()
        log(f"  [{step}] 确认按钮状态 - 可见：{is_visible}, 可点击：{is_enabled}")

        # 等待按钮完全可点击
        try:
            confirm_btn.first.wait_for(state="visible", timeout=5000)
            page.wait_for_timeout(500)  # 等待页面稳定
            log(f"  [{step}] 准备点击确认按钮")
            confirm_btn.first.click(timeout=10_000)
            log(f"  [{step}] ✅ 已成功点击确认按钮")
        except Exception as e:
            log(f"  [{step}] ❌ 点击确认按钮失败：{e}")
            raise
    else:
        log(f"  [{step}] ❌ 未找到确认按钮")
        raise Exception("未找到确认按钮")
