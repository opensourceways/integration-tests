#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
P2 边界场景测试

覆盖场景：
  B-08: 未登录直接访问
"""

import pytest
from common.constants import TARGET_URL


class TestBoundary:
    """P2 边界场景测试套件"""

    @pytest.mark.fast
    def test_b08_unauthenticated_access(self):
        """B-08: 未登录直接访问（302 到登录页）"""
        # 启动新的无登录态浏览器
        from playwright.sync_api import sync_playwright
        from common.constants import TIMEOUT

        with sync_playwright() as pw:
            browser = pw.chromium.launch(channel="chrome", headless=True)
            ctx = browser.new_context()
            ctx.set_default_timeout(TIMEOUT)
            page = ctx.new_page()

            # 直接访问目标页
            page.goto(TARGET_URL, wait_until="domcontentloaded")
            page.wait_for_timeout(3000)

            # 断言：重定向到登录页
            assert "login" in page.url
            assert "openeuler-usercenter.test.osinfra.cn" in page.url

            ctx.close()
            browser.close()
