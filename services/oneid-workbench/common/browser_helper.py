#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
浏览器管理与等待逻辑

统一浏览器启动配置，消除 4 处重复代码。
内置铁律 F-1（禁用 networkidle）、F-11（等 hydration 收敛）。
"""

import time
from playwright.sync_api import sync_playwright
from common.constants import TIMEOUT, TARGET_URL
from common.debug_utils import log


class BrowserManager:
    """浏览器生命周期管理"""

    @staticmethod
    def launch(headless: bool = False):
        """
        启动浏览器并返回 (playwright, browser, context, page)。

        统一配置：Chrome 有头模式，1920x1080，中文，30s 超时。
        消除 phase1_probe.py 等 4 个脚本中的重复启动代码。
        """
        pw = sync_playwright().start()
        browser = pw.chromium.launch(channel="chrome", headless=headless)
        ctx = browser.new_context(
            viewport={"width": 1920, "height": 1080},
            locale="zh-CN"
        )
        ctx.set_default_timeout(TIMEOUT)
        page = ctx.new_page()
        return pw, browser, ctx, page


def settle_landing(page, rounds: int = 2, per_round_s: int = 60) -> None:
    """
    打开目标页并等落地态稳定：要么出现登录表单，要么出现令牌列表。

    实测该站有两个坑：
      1. 登录页是 SPA 壳，首屏标题 openEuler starter，表单要几秒后才渲染；
         偶发抽风时可超过 30s（17:31 实测一次 30s 未出）。
      2. 未登录时的重定向是异步的，goto 返回时 URL 还是目标页。
    因此用轮询而非一次性长等，并允许整页重载重试。

    内置铁律 F-1：禁用 networkidle（该页持续轮询，永不达成）。
    """
    for rd in range(1, rounds + 1):
        if rd > 1 or "/my/" not in page.url:
            page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=TIMEOUT)
        deadline = time.time() + per_round_s
        while time.time() < deadline:
            if page.locator('input[type="password"]').count() > 0:
                log(f"  落地：登录页（第 {rd} 轮，{per_round_s - int(deadline - time.time())}s）")
                return
            if page.locator(".private-token-list").count() > 0:
                log(f"  落地：令牌列表页（第 {rd} 轮）")
                return
            page.wait_for_timeout(2000)
        log(f"  第 {rd} 轮 {per_round_s}s 未落地（title={page.title()!r}），重载重试")
    raise RuntimeError(f"页面始终未落地，最后 URL={page.url}")


def wait_hydrated(page) -> None:
    """
    等 Vue hydration 收敛。

    复用登录态时页面渲染极快（<1s），此时 DOM 已有但事件未绑定，
    点击会穿透到 SSR 的 Tab 链接，导致误跳 /zh/my/settings。
    判据：TOKEN Tab 面板处于激活态 + 列表容器可见，再留一小段缓冲。

    内置铁律 F-11：点「创建私人令牌」前必须等 hydration 收敛。
    """
    page.wait_for_selector('.o-tab-pane-active[data-tab-pane-key="TOKEN"]',
                           timeout=TIMEOUT)
    page.wait_for_selector(".private-token-list", timeout=TIMEOUT)
    page.wait_for_selector(".private-token-head button", timeout=TIMEOUT)
    page.wait_for_timeout(2500)
