"""
page_utils.py
通用页面操作工具封装：等待元素、输入、点击、弹窗处理、截图、重试等。
所有操作均基于Playwright显式等待，禁用固定sleep。
"""

import time
import logging
from pathlib import Path
from typing import Optional, Callable, Any
from playwright.sync_api import Page, Locator

# 导入全局配置
from global_config import (
    SCREENSHOT_DIR,
    SCREENSHOT_PREFIX,
    MAX_RETRY,
    RETRY_DELAY,
)

logger = logging.getLogger(__name__)


class PageUtils:
    """
    页面操作工具类：封装高频交互动作，提供统一异常处理、自动截图、日志输出。
    每个方法均遵循：显式等待 → 执行操作 → 日志记录 → 异常捕获 → 自动截图。
    """

    def __init__(self, page: Page):
        """
        :param page: Playwright Page对象（由BrowserManager.start()创建）
        """
        self.page = page
        self._screenshot_counter = 0

    # ==================== 1. 元素等待方法 ====================

    def wait_for_visible(self, selector: str, timeout: Optional[int] = None) -> Locator:
        """
        显式等待元素可见（attached + visible）。
        若选择器匹配多个元素，仅等待第一个元素可见，避免 strict mode violation。

        :param selector: CSS选择器或XPath
        :param timeout: 自定义超时（毫秒），默认使用page默认超时
        :return: 可见的Locator对象（指向第一个匹配元素）
        :raises: PlaywrightTimeout 如果超时仍未可见
        """
        logger.info("[Wait] 等待元素可见: %s", selector)
        locator = self.page.locator(selector).first
        locator.wait_for(state="visible", timeout=timeout)
        logger.info("[Wait] 元素已可见: %s", selector)
        return locator

    def wait_for_hidden(self, selector: str, timeout: Optional[int] = None) -> None:
        """
        显式等待元素隐藏或从DOM中移除。
        若选择器匹配多个元素，仅检查第一个元素是否隐藏。
        常用于：loading消失、弹窗关闭、骨架屏结束。
        """
        logger.info("[Wait] 等待元素隐藏: %s", selector)
        locator = self.page.locator(selector).first
        locator.wait_for(state="hidden", timeout=timeout)
        logger.info("[Wait] 元素已隐藏: %s", selector)

    def wait_for_selector(self, selector: str, timeout: Optional[int] = None) -> Locator:
        """
        等待元素存在于DOM中（attached状态），不强制要求可见。
        若选择器匹配多个元素，仅等待第一个元素。
        """
        logger.info("[Wait] 等待元素存在于DOM: %s", selector)
        locator = self.page.locator(selector).first
        locator.wait_for(state="attached", timeout=timeout)
        return locator

    # ==================== 2. 输入操作方法 ====================

    def type_text(self, selector: str, text: str, clear_first: bool = True, press_enter: bool = False) -> None:
        """
        在指定元素中输入文本，支持先清空、支持回车触发。

        :param selector: 目标输入框选择器
        :param text: 要输入的文本
        :param clear_first: 是否先清空（默认True）
        :param press_enter: 输入后是否按回车（默认False）
        """
        logger.info("[Input] 在 %s 中输入文本: %s", selector, text)
        locator = self.wait_for_visible(selector)

        if clear_first:
            locator.clear()
            logger.info("[Input] 已清空输入框。")

        locator.fill(text)
        logger.info("[Input] 文本已输入。")

        if press_enter:
            locator.press("Enter")
            logger.info("[Input] 已按下回车键。")

    # ==================== 3. 点击操作方法 ====================

    def click(self, selector: str, force: bool = False) -> None:
        """
        点击指定元素，等待元素可点击后执行。
        若选择器匹配多个元素，仅点击第一个匹配元素。

        :param selector: 目标元素选择器
        :param force: 是否强制点击（跳过可操作性检查，如元素被遮挡时）
        """
        logger.info("[Click] 点击元素: %s (force=%s)", selector, force)
        locator = self.page.locator(selector).first
        locator.click(force=force)
        logger.info("[Click] 点击完成。")

    def click_by_text(self, text: str, exact: bool = False, force: bool = False, parent_selector: Optional[str] = None) -> None:
        """
        根据文本内容点击元素（适用于按钮、链接等）。
        当页面存在多处相同文本时，可通过 parent_selector 限制搜索范围，避免 strict mode violation。

        :param text: 要匹配的文本
        :param exact: 是否精确匹配（默认False，包含匹配）
        :param force: 是否强制点击（跳过可操作性检查）
        :param parent_selector: 父级容器CSS选择器，用于限定搜索范围（如".filter-arch"）
        """
        logger.info("[Click] 根据文本点击: '%s' (exact=%s, parent=%s)", text, exact, parent_selector)
        if parent_selector:
            parent = self.page.locator(parent_selector)
            locator = parent.get_by_text(text, exact=exact)
        else:
            if exact:
                locator = self.page.get_by_text(text, exact=True)
            else:
                locator = self.page.get_by_text(text)
        locator.first.wait_for(state="visible")
        locator.first.click(force=force)
        logger.info("[Click] 文本点击完成。")

    def click_toggle(self, text: str, force: bool = False) -> None:
        """
        专门用于点击筛选区的 toggle 标签（如架构筛选标签）。
        使用 .commercial-release .o-toggle 配合 filter(has_text) 精确定位，避免与卡片中的架构标签混淆。

        :param text: toggle 标签文本（如 "x86_64"、"AArch64"）
        :param force: 是否强制点击
        """
        logger.info("[Click] 点击 toggle 标签: '%s'", text)
        # 使用 .filter(has_text=...) 替代 has_text 参数，兼容性更好
        locator = self.page.locator(".commercial-release .o-toggle").filter(has_text=text)
        locator.first.wait_for(state="visible")
        locator.first.click(force=force)
        logger.info("[Click] toggle 标签点击完成。")

    # ==================== 4. 弹窗/通知处理方法 ====================

    def handle_cookie_notice(self, selector: str = ".cookie-notice", close_selector: str = ".cookie-notice .close") -> bool:
        """
        检查并关闭Cookie通知栏。如果存在则关闭，不存在则静默返回。

        :return: 是否成功关闭（True=已关闭，False=未找到）
        """
        logger.info("[Popup] 检查Cookie通知栏...")
        notice = self.page.locator(selector)

        if notice.count() == 0 or not notice.is_visible():
            logger.info("[Popup] Cookie通知栏未出现或已关闭，无需处理。")
            return False

        try:
            # 尝试点击关闭按钮
            close_btn = self.page.locator(close_selector)
            if close_btn.count() > 0 and close_btn.is_visible():
                close_btn.click()
                logger.info("[Popup] Cookie通知栏已关闭。")
                # 等待通知栏消失
                self.wait_for_hidden(selector, timeout=5000)
                return True
        except Exception as e:
            logger.warning("[Popup] 关闭Cookie通知栏时异常: %s", e)

        # 若无法点击关闭，尝试JavaScript强制移除（兜底方案）
        try:
            self.page.evaluate(f'document.querySelector("{selector}")?.remove()')
            logger.info("[Popup] Cookie通知栏已通过JS移除。")
            return True
        except Exception as e:
            logger.warning("[Popup] JS移除Cookie通知栏失败: %s", e)
            return False

    def is_dialog_visible(self, selector: str = ".el-overlay-dialog") -> bool:
        """
        检查Element UI弹窗/遮罩是否可见。

        :return: True=弹窗可见（可能阻塞操作），False=无弹窗或隐藏
        """
        dialog = self.page.locator(selector)
        if dialog.count() == 0:
            return False
        # 使用 .first 避免 strict mode violation（当页面存在多个隐藏弹窗层时）
        return dialog.first.is_visible()

    # ==================== 5. 截图方法 ====================

    def take_screenshot(self, name: Optional[str] = None, full_page: bool = True) -> Path:
        """
        自动截图并保存到配置目录，文件名包含序号和时间戳。

        :param name: 截图自定义名称（可选）
        :param full_page: 是否截取全页面（默认True），False=仅当前视口
        :return: 截图保存的绝对路径
        """
        self._screenshot_counter += 1
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = f"{SCREENSHOT_PREFIX}_{self._screenshot_counter:03d}_{timestamp}"
        if name:
            filename += f"_{name}"
        filename += ".png"

        filepath = SCREENSHOT_DIR / filename
        self.page.screenshot(path=str(filepath), full_page=full_page)
        logger.info("[Screenshot] 已保存截图: %s", filepath)
        return filepath

    def take_element_screenshot(self, selector: str, name: Optional[str] = None) -> Path:
        """
        对特定元素进行截图。
        """
        self._screenshot_counter += 1
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = f"{SCREENSHOT_PREFIX}_{self._screenshot_counter:03d}_{timestamp}"
        if name:
            filename += f"_{name}"
        filename += ".png"

        filepath = SCREENSHOT_DIR / filename
        locator = self.wait_for_visible(selector)
        locator.screenshot(path=str(filepath))
        logger.info("[Screenshot] 已保存元素截图: %s", filepath)
        return filepath

    # ==================== 6. 重试装饰器/方法 ====================

    def retry(self, action: Callable, description: str = "操作", max_retry: int = MAX_RETRY) -> Any:
        """
        通用重试执行器：对任意可调用对象进行异常捕获和重试。

        :param action: 无参可调用对象（lambda或函数）
        :param description: 操作描述，用于日志
        :param max_retry: 最大重试次数
        :return: action的返回值
        :raises: 最后一次重试失败的异常
        """
        last_exception = None
        for attempt in range(1, max_retry + 1):
            try:
                logger.info("[Retry] 执行 '%s'，第 %d/%d 次...", description, attempt, max_retry)
                result = action()
                logger.info("[Retry] '%s' 执行成功。", description)
                return result
            except Exception as e:
                last_exception = e
                logger.warning("[Retry] '%s' 第 %d 次失败: %s", description, attempt, e)
                if attempt < max_retry:
                    # 使用显式等待替代sleep：等待页面稳定
                    self.page.wait_for_timeout(int(RETRY_DELAY * 1000))
                else:
                    logger.error("[Retry] '%s' 已达最大重试次数，放弃。", description)

        raise last_exception

    def safe_click(self, selector: str, max_retry: int = MAX_RETRY) -> None:
        """
        带重试的安全点击：处理元素瞬态遮挡、Vue重渲染等导致的点击失败。
        """
        def _do_click():
            self.click(selector)

        self.retry(_do_click, description=f"点击 {selector}", max_retry=max_retry)

    def safe_type(self, selector: str, text: str, press_enter: bool = False, max_retry: int = MAX_RETRY) -> None:
        """
        带重试的安全输入：处理输入框未就绪或值被覆盖的情况。
        """
        def _do_type():
            self.type_text(selector, text, clear_first=True, press_enter=press_enter)

        self.retry(_do_type, description=f"输入 {text} 到 {selector}", max_retry=max_retry)

    # ==================== 7. 断言辅助方法 ====================

    def assert_title_contains(self, keywords: list[str]) -> None:
        """
        断言页面标题包含指定关键词之一。

        :raises AssertionError: 标题不匹配时抛出
        """
        title = self.page.title()
        logger.info("[Assert] 当前页面标题: %s", title)
        for kw in keywords:
            if kw in title:
                logger.info("[Assert] 标题断言通过，包含关键词: '%s'", kw)
                return
        raise AssertionError(f"页面标题断言失败: '{title}' 不包含任何期望关键词 {keywords}")

    def assert_url_equals(self, expected_url: str) -> None:
        """
        断言当前页面URL完全匹配期望值。
        """
        current = self.page.url
        logger.info("[Assert] 当前URL: %s", current)
        if current != expected_url:
            raise AssertionError(f"URL断言失败: 期望 '{expected_url}', 实际 '{current}'")
        logger.info("[Assert] URL断言通过。")

    def assert_element_visible(self, selector: str, description: str = "") -> None:
        """
        断言元素在页面上可见。
        """
        locator = self.page.locator(selector)
        count = locator.count()
        if count == 0:
            raise AssertionError(f"元素未找到: {selector} ({description})")
        if not locator.first.is_visible():
            raise AssertionError(f"元素存在但不可见: {selector} ({description})")
        logger.info("[Assert] 元素可见性断言通过: %s (%s)", selector, description or "无描述")

    def assert_element_count(self, selector: str, expected: int, operator: str = "==") -> None:
        """
        断言元素数量满足条件。

        :param operator: 比较运算符："==", ">=", ">", "<=", "<"
        """
        locator = self.page.locator(selector)
        count = locator.count()
        logger.info("[Assert] 元素 %s 数量: %d, 期望 %s %d", selector, count, operator, expected)

        ok = False
        if operator == "==":
            ok = count == expected
        elif operator == ">=":
            ok = count >= expected
        elif operator == ">":
            ok = count > expected
        elif operator == "<=":
            ok = count <= expected
        elif operator == "<":
            ok = count < expected
        else:
            raise ValueError(f"不支持的运算符: {operator}")

        if not ok:
            raise AssertionError(f"元素数量断言失败: {selector} 实际={count}, 期望 {operator} {expected}")
        logger.info("[Assert] 元素数量断言通过。")

    # ==================== 8. 页面信息获取 ====================

    def get_element_text(self, selector: str, index: int = 0) -> str:
        """
        获取指定元素的文本内容。
        """
        locator = self.page.locator(selector).nth(index)
        locator.wait_for(state="visible")
        text = locator.inner_text()
        logger.info("[Info] 元素 %s[%d] 的文本: %s", selector, index, text)
        return text

    def get_element_attribute(self, selector: str, attr: str, index: int = 0) -> str:
        """
        获取指定元素的属性值（如href、src、data-*等）。
        """
        locator = self.page.locator(selector).nth(index)
        locator.wait_for(state="attached")
        value = locator.get_attribute(attr) or ""
        logger.info("[Info] 元素 %s[%d] 的属性 %s = %s", selector, index, attr, value)
        return value
