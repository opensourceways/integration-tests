#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
登录流程封装

统一账号密码登录逻辑，消除 4 个脚本中的重复代码。
内置铁律 F-2（禁用 id 定位）、F-1（禁用 networkidle）。
"""

from playwright.sync_api import TimeoutError as PWTimeout
from common.constants import TIMEOUT
from common.config import config
from common.debug_utils import log
from slider_solver import solve_slider


def do_login(page) -> bool:
    """
    账号密码登录，返回是否成功跳回目标页。

    处理流程：
      1. 切换到「账号登录」Tab（如果不在）
      2. 填入账号密码（禁用 id 定位，用 type）
      3. 勾选隐私协议（如果存在）
      4. 处理登录滑块（自动破解，失败提示人工）
      5. 等待跳转到 /my/tokens

    内置铁律：
      - F-2：禁用 id 定位（输入框 id 每次加载随机）
      - F-1：禁用 networkidle（该页持续轮询，永不达成）
    """
    log("执行账号密码登录")

    # 切换到账号登录 Tab（若默认不在该 Tab）
    for name in ("账号登录", "密码登录"):
        tab = page.get_by_text(name, exact=True)
        if tab.count() > 0 and tab.first.is_visible():
            tab.first.click()
            log(f"  已切到「{name}」Tab")
            break

    page.wait_for_selector('input[type="text"]', timeout=TIMEOUT)
    # 禁用 id 定位（id 每次加载随机生成），按 type 定位
    page.locator('input[type="text"]').first.fill(config.account)
    page.locator('input[type="password"]').first.fill(config.password)
    log(f"  已填入账号 {config.account}")

    # 勾选隐私协议（若存在且未勾选，否则登录按钮可能不可用）
    try:
        agree = page.locator('.o-checkbox, input[type="checkbox"]').first
        if agree.count() > 0 and agree.is_visible():
            agree.click()
            log("  已勾选协议复选框")
    except Exception:
        pass

    page.get_by_role("button", name="登录").first.click()
    log("  已点击「登录」")

    # 登录可能触发滑块验证
    try:
        page.wait_for_selector(".verifybox", timeout=5_000)
        log("  登录触发滑块验证，尝试自动破解")
        if not solve_slider(page):
            log("  " + "!" * 58)
            log("  !! 阿蓁，滑块自动破解失败")
            log("  !! 请在 Chrome 窗口手动完成滑块验证")
            log("  !! 脚本会等待最多 3 分钟")
            log("  " + "!" * 58)
            page.wait_for_selector(".verifybox", state="hidden", timeout=180_000)
            log("  人工滑块已完成，继续")
    except PWTimeout:
        log("  未出现滑块验证")

    # 等待跳回目标页。注意：该页存在持续轮询，networkidle 永不达成，
    # 只能等 URL + 业务容器，不能等 networkidle（铁律 F-1）。
    try:
        page.wait_for_url("**/my/tokens**", timeout=TIMEOUT)
        log(f"  登录成功：{page.url}")
        return True
    except PWTimeout:
        log(f"  !! 登录后未跳回目标页，当前 URL: {page.url}")
        return False
