#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
登录流程独立验证脚本（不依赖 EUR 地址）。

用途：在拿到 EUR 测试环境地址之前，先单独验证「账号密码 + 滑块自动破解 +
邮箱验证码 + 隐私声明弹窗」这条链路在指定的统一认证站点上是否跑得通。

用法：
    py verify_login.py                                        # 默认测试环境用户中心
    py verify_login.py https://id.openeuler.org/login          # 指定其它认证站点
"""
import io
import os
import sys
import time

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")

from dotenv import load_dotenv
from playwright.sync_api import sync_playwright

load_dotenv()

# 复用测试脚本中的登录处理逻辑（滑块 / 验证码 / 隐私声明）
import test_copr_api as suite

LOGIN_URL = sys.argv[1] if len(sys.argv) > 1 else "https://openeuler-usercenter.test.osinfra.cn/login"


def main():
    username = os.environ.get("TEST_ACCOUNT", "")
    password = os.environ.get("TEST_PASSWORD", "")
    if not username or not password:
        print("[FAIL] .env 中未配置 TEST_ACCOUNT / TEST_PASSWORD")
        return 1

    print("=" * 68)
    print(f"登录流程验证  站点: {LOGIN_URL}")
    print(f"账号: {username}")
    print("=" * 68)

    with sync_playwright() as p:
        browser = p.chromium.launch(
            channel="msedge", headless=False, slow_mo=120,
            args=["--no-sandbox", "--ignore-certificate-errors",
                  "--disable-blink-features=AutomationControlled"],
        )
        ctx = browser.new_context(ignore_https_errors=True,
                                  viewport={"width": 1600, "height": 900})
        ctx.set_default_timeout(30000)
        page = ctx.new_page()
        try:
            print(f"[1/6] 打开登录页 {LOGIN_URL}")
            page.goto(LOGIN_URL, wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(5000)
            print(f"      当前 URL: {page.url}")

            print("[2/6] 切换到「账号登录」Tab 并填入账号密码")
            tab = suite._first_visible(page, ".login-tabs .tab:has-text('账号登录')")
            if tab is not None and "selected" not in (tab.get_attribute("class") or ""):
                tab.click()
                page.wait_for_timeout(800)

            suite.await_slider_cleared(page, "登录页")

            user_input = suite._first_visible(page, "input[type='text'].o_input-input") or \
                suite._first_visible(page, "input[type='text']")
            pwd_input = suite._first_visible(page, "input[type='password']")
            if user_input is None or pwd_input is None:
                page.screenshot(path="debug_verify_no_form.png")
                print("[FAIL] 未找到账号/密码输入框，截图: debug_verify_no_form.png")
                return 1
            user_input.fill(username)
            pwd_input.fill(password)
            page.wait_for_timeout(600)

            print("[3/6] 点击登录")
            btn = suite._first_visible(page, "button.login-btn") or \
                suite._first_visible(page, "button:has-text('登录')")
            if btn is not None:
                for _ in range(10):
                    if "o-btn-disabled" not in (btn.get_attribute("class") or ""):
                        break
                    page.wait_for_timeout(400)
                btn.click()
            else:
                pwd_input.press("Enter")
            page.wait_for_timeout(4000)

            print("[4/6] 处理滑块 / 隐私声明")
            suite.await_slider_cleared(page, "提交登录")
            suite.handle_privacy_dialog(page)

            print("[5/6] 处理邮箱验证码（如触发）")
            suite.handle_mfa_challenge(page)
            suite.await_slider_cleared(page, "登录收尾")
            suite.handle_privacy_dialog(page)

            print("[6/6] 等待登录完成")
            deadline = time.time() + 45
            while time.time() < deadline and "/login" in page.url:
                page.wait_for_timeout(1500)
                if suite.handle_privacy_dialog(page):
                    deadline = time.time() + 30

            page.wait_for_timeout(2000)
            page.screenshot(path="debug_verify_login_result.png", full_page=True)
            body = page.inner_text("body")[:300].replace("\n", " | ")
            print("-" * 68)
            print(f"最终 URL : {page.url}")
            print(f"页面文本 : {body}")
            print(f"截图     : debug_verify_login_result.png")

            cookies = ctx.cookies()
            print(f"Cookie   : {len(cookies)} 个 -> {[c['name'] for c in cookies][:12]}")

            if "/login" in page.url:
                print("[FAIL] 仍停留在登录页，登录未完成")
                return 1
            print("[PASS] 登录成功")
            return 0
        finally:
            page.wait_for_timeout(1500)
            ctx.close()
            browser.close()


if __name__ == "__main__":
    sys.exit(main())
