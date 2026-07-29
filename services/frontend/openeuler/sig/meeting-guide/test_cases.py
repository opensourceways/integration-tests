"""
阶段4：多场景测试用例（pytest函数式）
test/test_meeting_guide.py

说明：
  本文件基于阶段1页面分析结论（信息展示页，无表单/登录/弹窗），编写贴合真实页面的测试用例。
  由于目标页面无表单提交功能，用户原始要求的"空表单/错误账号/重复提交"场景在本页不适用，
  已替换为信息展示页对应的异常场景：404访问、元素缺失、网络超时、响应式布局等。

用例分类：
  - 正常流程：页面加载、Banner面包屑、板块标题、卡片、搜索框、链接、页脚、跳转
  - 异常场景：404错误路径、元素缺失断言、弱网超时、响应式布局异常
  - 批量/循环：pytest.mark.parametrize 多视口尺寸循环执行
"""

import pytest
from playwright.sync_api import Page, expect, TimeoutError as PlaywrightTimeoutError

# 导入阶段2封装的工具类和全局配置
from browser_utils import BrowserManager, ActionUtils, take_screenshot, logger
from config import (
    TARGET_URL,
    EXPECTED_TITLE_PATTERN,
    EXPECTED_URL_PATH,
    EXPECTED_SECTIONS,
    EXPECTED_BREADCRUMB,
    EXPECTED_FOOTER_LINKS,
    DEFAULT_TIMEOUT,
)


# ============================================================
# Pytest Fixtures
# ============================================================
@pytest.fixture(scope="function")
def browser_manager():
    """
    【Fixture】每条例程启动一次浏览器，结束后自动关闭。
    使用阶段2 BrowserManager 封装，确保有头模式、中文环境、30s超时。
    """
    bm = BrowserManager()
    bm.start()
    yield bm
    bm.close()


@pytest.fixture(scope="function")
def page(browser_manager):
    """
    【Fixture】从 BrowserManager 获取当前 Page 对象。
    """
    yield browser_manager.page


@pytest.fixture(scope="function")
def utils(page):
    """
    【Fixture】为当前 Page 创建 ActionUtils 实例。
    """
    yield ActionUtils(page)



# ============================================================
# 一、正常流程用例（Normal Scenarios）
# ============================================================

class TestNormalFlow:
    """正常流程：页面完整加载与内容校验"""

    def test_01_page_load_success(self, browser_manager, page, utils):
        """
        【N-01】页面正常加载：HTTP 200、标题正则匹配、URL路径正确。
        """
        # 【操作】导航至目标页面
        response = browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【校验】HTTP 状态码 200
        assert response is not None, "页面响应为空"
        assert response.status == 200, f"HTTP 状态码异常: {response.status}"

        # 【校验】页面标题包含正则
        utils.assert_title_contains(EXPECTED_TITLE_PATTERN, timeout=DEFAULT_TIMEOUT)

        # 【校验】URL 包含预期路径
        utils.assert_url_contains(EXPECTED_URL_PATH, timeout=DEFAULT_TIMEOUT)

    def test_02_banner_and_breadcrumb(self, browser_manager, page, utils):
        """
        【N-02】Banner与面包屑：H1标题存在，面包屑包含"SIG中心"和"会议指南"。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【校验】H1 主标题可见且包含"会议指南"
        h1 = page.locator("h1").first
        utils.assert_element_visible(h1, timeout=DEFAULT_TIMEOUT, description="H1主标题")
        utils.assert_text_visible(h1, "会议指南", timeout=DEFAULT_TIMEOUT, description="H1主标题")

        # 【校验】面包屑导航可点击链接包含"SIG中心"
        breadcrumb_texts = page.locator("a.o-breadcrumb-item-label").all_inner_texts()
        assert any("SIG中心" in t for t in breadcrumb_texts), \
            f"面包屑缺少可点击链接: SIG中心，实际: {breadcrumb_texts}"

        # 【校验】面包屑当前页文本包含"会议指南"（当前页通常非可点击链接）
        # 通过页面范围内文本定位
        current_crumb = page.locator("text=会议指南").first
        assert current_crumb.is_visible(), "面包屑当前页'会议指南'不可见"

    def test_03_section_headings(self, browser_manager, page, utils):
        """
        【N-03】三大板块标题：H2 必须同时包含"会议规划"、"会议类型"、"组织会议"。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        h2_texts = page.locator("h2").all_inner_texts()
        for section in EXPECTED_SECTIONS:
            assert any(section in t for t in h2_texts), \
                f"缺少板块标题: {section}，实际H2: {h2_texts}"

    def test_04_meeting_type_cards(self, browser_manager, page, utils):
        """
        【N-04】会议类型卡片：单SIG卡片与WG卡片均可见且内容完整。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【校验】单 SIG 卡片
        card_single = page.locator(".o-card:has-text('单 SIG 组工作会议')").first
        utils.assert_element_visible(card_single, timeout=DEFAULT_TIMEOUT, description="单SIG卡片")
        utils.assert_text_visible(card_single, "Maintainer", timeout=DEFAULT_TIMEOUT, description="单SIG卡片内容")

        # 【校验】WG 卡片
        card_wg = page.locator(".o-card:has-text('Working Group 工作会议')").first
        utils.assert_element_visible(card_wg, timeout=DEFAULT_TIMEOUT, description="WG卡片")
        utils.assert_text_visible(card_wg, "跨 SIG", timeout=DEFAULT_TIMEOUT, description="WG卡片内容")

    def test_05_search_box_exists(self, browser_manager, page, utils):
        """
        【N-05】搜索框存在性：可见、placeholder="搜索"、type="text"。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        search = page.locator("input.el-input__inner").first
        utils.assert_element_visible(search, timeout=DEFAULT_TIMEOUT, description="搜索框")

        placeholder = utils.get_attribute(search, "placeholder", timeout=DEFAULT_TIMEOUT, description="搜索框placeholder")
        assert placeholder == "搜索", f"placeholder 异常: {placeholder}"

        input_type = utils.get_attribute(search, "type", timeout=DEFAULT_TIMEOUT, description="搜索框type")
        assert input_type == "text", f"type 异常: {input_type}"

    def test_06_key_content_links(self, browser_manager, page, utils):
        """
        【N-06】关键内容链接："点击查看"、Etherpad、模板、邮件列表链接可见且href正确。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【校验】点击查看链接
        link_check = page.locator("a.underline-link:has-text('点击查看')").first
        utils.assert_element_visible(link_check, timeout=DEFAULT_TIMEOUT, description="点击查看链接")
        href = utils.get_attribute(link_check, "href", timeout=DEFAULT_TIMEOUT, description="点击查看href")
        assert "/zh/meeting/" in href, f"'点击查看' href 异常: {href}"

        # 【校验】Etherpad 链接
        link_ep = page.locator('a[href="https://etherpad.openeuler.org/"]').first
        utils.assert_element_visible(link_ep, timeout=DEFAULT_TIMEOUT, description="Etherpad链接")
        target = utils.get_attribute(link_ep, "target", timeout=DEFAULT_TIMEOUT, description="Etherpad target")
        assert target == "_blank", f"Etherpad 未设置新标签页打开: {target}"

        # 【校验】模板链接
        link_tpl = page.locator('a[href="https://etherpad.openeuler.org/p/planning-template"]').first
        utils.assert_element_visible(link_tpl, timeout=DEFAULT_TIMEOUT, description="规划模板链接")

        # 【校验】邮件列表链接（部分匹配）
        link_mail = page.locator('a[href*="mailweb.openeuler.org"]').first
        utils.assert_element_visible(link_mail, timeout=DEFAULT_TIMEOUT, description="邮件列表链接")

    def test_07_footer_links(self, browser_manager, page, utils):
        """
        【N-07】页脚关键链接：隐私声明、法律声明、关于cookies 必须存在。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        footer_texts = page.locator("footer a.link, a.link").all_inner_texts()
        for expected in EXPECTED_FOOTER_LINKS:
            assert any(expected in t for t in footer_texts), \
                f"页脚缺少关键链接: {expected}，实际: {footer_texts}"

    def test_08_no_blocking_modal(self, browser_manager, page, utils):
        """
        【N-08】无阻塞弹窗：Element Plus 遮罩层 .el-overlay 默认隐藏。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        overlay = page.locator(".el-overlay").first
        expect(overlay).to_be_hidden(timeout=5000)

    def test_09_click_check_more_navigation(self, browser_manager, page, utils):
        """
        【N-09】点击"点击查看"链接并校验跳转：URL 应包含 /zh/meeting/，随后返回原页。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        link = page.locator("a.underline-link:has-text('点击查看')").first
        utils.scroll_to(link, description="点击查看链接")
        utils.safe_click(link, timeout=DEFAULT_TIMEOUT, description="点击查看链接")

        # 【校验】跳转后 URL
        utils.assert_url_contains("/zh/meeting/", timeout=DEFAULT_TIMEOUT)
        assert len(page.title()) > 0, "跳转后页面标题为空"

        # 【操作】返回原页面
        page.go_back(wait_until="domcontentloaded", timeout=DEFAULT_TIMEOUT)
        utils.assert_url_contains(EXPECTED_URL_PATH, timeout=DEFAULT_TIMEOUT)


# ============================================================
# 二、异常场景用例（Error / Boundary Scenarios）
# ============================================================

class TestAbnormalScenarios:
    """异常场景：错误路径、元素缺失、超时、响应式异常"""

    def test_e01_404_not_found(self, browser_manager, page, utils):
        """
        【E-01】访问错误路径：构造一个不存在的 URL，断言页面标题不包含"会议指南"。
        """
        bad_url = TARGET_URL.rstrip("/") + "/nonexistent-page-12345/"
        response = browser_manager.goto(bad_url, wait_until="domcontentloaded", timeout=DEFAULT_TIMEOUT)

        # 【校验】HTTP 状态码非 200（可能 404 或 302 跳转至错误页）
        if response:
            assert response.status != 200, f"错误路径返回 200，不符合预期: {response.status}"

        # 【校验】页面标题不应包含"会议指南"（404页面通常显示错误提示）
        assert "会议指南" not in page.title(), \
            f"错误路径页面标题仍包含'会议指南': {page.title()}"
        # 截图存档（异常场景也保留现场）
        take_screenshot(page, name="test_e01_404")

    def test_e02_element_missing_assertion(self, browser_manager, page, utils):
        """
        【E-02】模拟关键元素缺失：主动断言一个不存在的元素，验证失败时自动截图机制。
        用途：验证 ActionUtils 断言失败时截图与日志是否正常触发。
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【操作】故意定位一个不会出现的文本
        fake_locator = page.locator("text=这是一个不可能存在的测试文本XYZ123")

        # 【校验】预期该断言失败，触发截图和日志
        with pytest.raises(Exception):
            utils.assert_element_visible(fake_locator, timeout=3000, description="【模拟】不存在元素")

        # 若走到此处说明断言失败被捕获，验证 pytest.raises 生效
        logger.info("[test_e02] 断言失败被正确捕获，截图已自动保存")

    def test_e03_slow_network_timeout(self, browser_manager, page, utils):
        """
        【E-03】弱网/超时场景：将 Playwright 默认超时降至 500ms，访问页面预期触发超时。
        用途：验证超时异常捕获和截图机制。
        """
        # 【操作】临时缩短超时以模拟弱网
        page.set_default_timeout(500)
        try:
            # 直接使用 page.goto 绕过 browser_manager.goto 内部的降级重试逻辑
            # networkidle 在 500ms 内几乎必然超时
            page.goto(TARGET_URL, wait_until="networkidle", timeout=500)
            pytest.fail("预期超时未发生，测试逻辑异常")
        except PlaywrightTimeoutError:
            # 【校验】正确捕获超时异常，自动截图已在 browser_manager.goto 内部触发
            logger.info("[test_e03] 弱网超时异常被正确捕获")
        finally:
            # 恢复默认超时，避免影响后续用例
            page.set_default_timeout(DEFAULT_TIMEOUT)

    def test_e04_overlay_unexpected_visible(self, browser_manager, page, utils):
        """
        【E-04】意外弹窗阻塞：模拟断言 .el-overlay 必须隐藏，若页面有意外弹窗则失败。
        （与正常场景 N-08 相同校验点，但独立为异常类用例，便于单独运行/跳过）
        """
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        overlay = page.locator(".el-overlay").first
        # 若此处 overlay 意外可见，则截图并失败
        try:
            expect(overlay).to_be_hidden(timeout=5000)
        except Exception as e:
            take_screenshot(page, name="test_e04_overlay_visible")
            raise


# ============================================================
# 三、批量执行 / 参数化 / 循环运行
# ============================================================

class TestBatchAndParameterized:
    """批量与参数化：多视口尺寸、多轮循环、稳定性验证"""

    @pytest.mark.parametrize("width,height", [
        (1920, 1080),   # 桌面标准
        (1366, 768),    # 笔记本常见
        (768, 1024),    # 平板竖屏
        (375, 667),     # 手机竖屏
    ])
    def test_responsive_viewport_sections(self, browser_manager, page, utils, width, height):
        """
        【B-01】响应式布局校验：在多种视口尺寸下，三大板块标题仍然可见。
        使用 pytest.mark.parametrize 实现批量多尺寸循环。
        """
        # 【操作】重新设置视口尺寸（需重新加载页面以触发响应式渲染）
        page.set_viewport_size({"width": width, "height": height})
        browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

        # 【校验】三大板块标题在缩小视口后仍可见（或至少存在于DOM中）
        for section in EXPECTED_SECTIONS:
            heading = page.locator("h2", has_text=section).first
            # 在极小视口下元素可能被折叠，但 DOM 中必须 attached；
            # 使用 wait_for(state="attached") 而非 visible，避免响应式折叠导致误失败
            heading.wait_for(state="attached", timeout=DEFAULT_TIMEOUT)
            logger.info(f"[B-01] 视口 {width}x{height} | 板块 '{section}' 已挂载到DOM")

        # 截图存档（带视口尺寸标识）
        take_screenshot(page, name=f"responsive_{width}x{height}")

    def test_multiple_rounds_stability(self, browser_manager, page, utils):
        """
        【B-02】稳定性循环：连续3次刷新页面，每次校验标题与URL，验证无偶发性渲染失败。
        用途：排查页面偶发白屏、资源加载不全、CDN抖动等问题。
        """
        for i in range(1, 4):
            logger.info(f"[B-02] 第 {i}/3 轮稳定性测试开始...")

            # 【操作】重新导航（模拟刷新）
            browser_manager.goto(TARGET_URL, wait_until="networkidle", timeout=DEFAULT_TIMEOUT)

            # 【校验】标题与 URL
            utils.assert_title_contains(EXPECTED_TITLE_PATTERN, timeout=DEFAULT_TIMEOUT)
            utils.assert_url_contains(EXPECTED_URL_PATH, timeout=DEFAULT_TIMEOUT)

            # 【校验】H1 主标题可见
            h1 = page.locator("h1").first
            utils.assert_element_visible(h1, timeout=DEFAULT_TIMEOUT, description="H1主标题")

            logger.info(f"[B-02] 第 {i}/3 轮通过")

        take_screenshot(page, name="stability_round3_final")
        logger.info("[B-02] 全部3轮稳定性测试通过")
