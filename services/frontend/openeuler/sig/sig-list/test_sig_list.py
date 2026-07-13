"""
test_sig_list.py
多场景 pytest 测试用例：正常流程 + 异常场景 + 参数化批量执行
"""

import re
import time
from pathlib import Path

import pytest
from playwright.sync_api import sync_playwright, expect, Page

from config import (
    TARGET_URL,
    BROWSER_TYPE,
    HEADLESS,
    SLOW_MO,
    VIEWPORT_WIDTH,
    VIEWPORT_HEIGHT,
    DEFAULT_TIMEOUT,
    NAVIGATION_TIMEOUT,
    SCREENSHOT_DIR,
    LOG_DIR,
)

SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)


def _save_screenshot(page: Page, name: str, full_page: bool = True) -> Path:
    """辅助截图函数"""
    timestamp = time.strftime("%H%M%S")
    safe = name.replace(" ", "_").replace("/", "_")
    filepath = SCREENSHOT_DIR / f"{safe}_{timestamp}.png"
    page.screenshot(path=str(filepath), full_page=full_page)
    print(f"[截图] {filepath}")
    return filepath


# ------------------- Fixture -------------------

@pytest.fixture(scope="session")
def browser_context():
    """session级：启动浏览器，所有用例共享Context"""
    playwright = sync_playwright().start()
    browser_launcher = getattr(playwright, BROWSER_TYPE)
    browser = browser_launcher.launch(
        headless=HEADLESS,
        slow_mo=SLOW_MO,
        args=["--disable-blink-features=AutomationControlled"],
    )
    context = browser.new_context(
        viewport={"width": VIEWPORT_WIDTH, "height": VIEWPORT_HEIGHT},
        locale="zh-CN",
        timezone_id="Asia/Shanghai",
    )
    yield context
    context.close()
    browser.close()
    playwright.stop()


@pytest.fixture
def page(browser_context):
    """function级：每个用例独立Page"""
    page = browser_context.new_page()
    page.set_default_timeout(DEFAULT_TIMEOUT)
    page.set_default_navigation_timeout(NAVIGATION_TIMEOUT)
    yield page
    page.close()


# ==================== 正常流程 ====================

class TestNormalFlow:
    def test_open_page_and_title(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        expect(page).to_have_title(re.compile("SIG"))
        assert "SIG" in page.title()

    def test_banner_visible(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        expect(page.locator(".banner-title")).to_be_visible()
        expect(page.locator(".banner-title")).to_contain_text("SIG中心")
        expect(page.locator(".banner-subtitle")).to_be_visible()

    def test_welcome_cards(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-welcome").scroll_into_view_if_needed()
        cards = page.locator(".sig-welcome-card .card-item")
        expect(cards).to_have_count(3)
        expected = ["了解SIG运转", "进行SIG交流", "参与SIG贡献"]
        for i, t in enumerate(expected):
            expect(cards.nth(i).locator(".title")).to_contain_text(t)

    def test_about_card_navigation(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-about-card[href*='/role-description']").click()
        page.wait_for_load_state("networkidle")
        expect(page).to_have_url(re.compile("/role-description"))
        _save_screenshot(page, "TEST_about_nav")

    def test_process_steps(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".application-process").scroll_into_view_if_needed()
        expect(page.locator(".process-step")).to_have_count(6)
        steps = ["寻人", "申请", "沟通", "获批", "运作", "改进"]
        for i, t in enumerate(steps):
            expect(page.locator(f".process-step.step-{i} .process")).to_contain_text(t)

    def test_list_skeleton(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-list").scroll_into_view_if_needed()
        expect(page.locator(".sig-list .section-title")).to_contain_text("openEuler SIGs")
        expect(page.locator(".filter-type .o-radio-group")).to_be_visible()
        expect(page.locator(".filter-select .o-select")).to_be_visible()
        expect(page.locator('input[placeholder="搜索SIG相关的信息"]')).to_be_visible()

    def test_full_integration(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        expect(page).to_have_title(re.compile("SIG"))
        expect(page.locator(".banner-title")).to_contain_text("SIG中心")
        page.locator(".sig-welcome").scroll_into_view_if_needed()
        expect(page.locator(".sig-welcome-card .card-item")).to_have_count(3)
        page.locator(".application-process").scroll_into_view_if_needed()
        expect(page.locator(".process-step")).to_have_count(6)
        page.locator(".sig-list").scroll_into_view_if_needed()
        expect(page.locator('input[placeholder="搜索SIG相关的信息"]')).to_be_visible()

        # 搜索
        search = page.locator('input[placeholder="搜索SIG相关的信息"]')
        search.fill("kernel")
        search.press("Enter")
        page.wait_for_timeout(2000)
        _save_screenshot(page, "TEST_full_search")

        # 筛选
        first_radio = page.locator(".filter-type .o-radio-group .o-radio").first
        if first_radio.count() > 0:
            first_radio.click()
            page.wait_for_timeout(1000)

        # 跳转
        page.locator(".sig-about-card[href*='/role-description']").click()
        page.wait_for_load_state("networkidle")
        expect(page).to_have_url(re.compile("/role-description"))
        _save_screenshot(page, "TEST_full_final")


# ==================== 异常场景 ====================

class TestAbnormalScenarios:
    def test_empty_search(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-list").scroll_into_view_if_needed()
        search = page.locator('input[placeholder="搜索SIG相关的信息"]')
        search.fill("")
        search.press("Enter")
        page.wait_for_timeout(1500)
        expect(page).to_have_title(re.compile("SIG"))
        expect(page.locator(".sig-list")).to_be_visible()
        _save_screenshot(page, "TEST_empty_search")

    def test_timeout_simulation(self, page: Page):
        page.set_default_navigation_timeout(500)
        with pytest.raises(Exception):
            page.goto(TARGET_URL, wait_until="networkidle")
        page.set_default_navigation_timeout(NAVIGATION_TIMEOUT)
        _save_screenshot(page, "TEST_timeout")

    def test_element_not_found(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        with pytest.raises(Exception):
            page.locator(".not-exist-12345").wait_for(state="visible", timeout=2000)
        expect(page).to_have_title(re.compile("SIG"))

    def test_double_click_filter(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-list").scroll_into_view_if_needed()
        radios = page.locator(".filter-type .o-radio-group .o-radio")
        if radios.count() > 0:
            radios.first.click()
            radios.first.click()
            radios.first.click()
            page.wait_for_timeout(1000)
            expect(page.locator(".sig-list")).to_be_visible()
            expect(page).to_have_title(re.compile("SIG"))
        _save_screenshot(page, "TEST_double_click")

    def test_back_and_refresh(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-about-card[href*='/role-description']").click()
        page.wait_for_load_state("networkidle")
        expect(page).to_have_url(re.compile("/role-description"))
        page.go_back(wait_until="networkidle")
        expect(page).to_have_url(re.compile("/sig-list"))
        page.reload(wait_until="networkidle")
        expect(page).to_have_title(re.compile("SIG"))
        expect(page.locator(".banner-title")).to_be_visible()
        expect(page.locator(".sig-list")).to_be_visible()


# ==================== 参数化批量/循环 ====================

class TestBatchAndLoop:
    @pytest.mark.parametrize("search_term", [
        "kernel", "cloud", "ai", "storage", "network"
    ])
    def test_batch_search(self, page: Page, search_term):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-list").scroll_into_view_if_needed()
        search = page.locator('input[placeholder="搜索SIG相关的信息"]')
        search.fill(search_term)
        search.press("Enter")
        page.wait_for_timeout(1500)
        assert "SIG" in page.title()
        expect(page.locator(".sig-list")).to_be_visible()
        _save_screenshot(page, f"TEST_batch_{search_term}")

    def test_loop_all_radio_filters(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-list").scroll_into_view_if_needed()
        radios = page.locator(".filter-type .o-radio-group .o-radio")
        count = radios.count()
        if count == 0:
            pytest.skip("无Radio选项")
        for idx in range(count):
            radios.nth(idx).click()
            page.wait_for_timeout(800)
            if idx % 3 == 0:
                _save_screenshot(page, f"TEST_loop_radio_{idx}")
            assert "SIG" in page.title()
            expect(page.locator(".sig-list")).to_be_visible()
        print(f"共测试 {count} 个筛选选项")

    def test_loop_all_welcome_cards(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        page.locator(".sig-welcome").scroll_into_view_if_needed()
        cards = page.locator(".sig-welcome-card .card-item")
        expect(cards).to_have_count(3)
        expected = ["了解SIG运转", "进行SIG交流", "参与SIG贡献"]
        for i in range(3):
            expect(cards.nth(i).locator(".title")).to_contain_text(expected[i])
            cards.nth(i).hover()
            page.wait_for_timeout(300)
        _save_screenshot(page, "TEST_loop_cards")


# ==================== 冒烟/回归 ====================

class TestSmokeAndRegression:
    def test_smoke_quick(self, page: Page):
        page.goto(TARGET_URL, wait_until="networkidle")
        expect(page).to_have_title(re.compile("SIG"))
        expect(page.locator(".banner-title")).to_be_visible()
        expect(page.locator(".sig-list")).to_be_visible()
        expect(page.locator('input[placeholder="搜索SIG相关的信息"]')).to_be_visible()
        expect(page.locator(".footer")).to_be_visible()

    def test_no_console_error(self, page: Page):
        console_errors = []
        def handle_console(msg):
            if msg.type == "error":
                console_errors.append(msg.text)
        page.on("console", handle_console)
        page.goto(TARGET_URL, wait_until="networkidle")
        page.wait_for_timeout(3000)
        critical = [e for e in console_errors if "404" in e or "Failed" in e]
        assert len(critical) == 0, f"关键错误: {critical}"
        page.remove_listener("console", handle_console)
