# utils.py
# 封装：浏览器初始化、通用操作、显式等待、日志、异常重试

import logging
import traceback
from typing import Optional, Callable

from playwright.sync_api import (
    sync_playwright,
    Page,
    Browser,
    BrowserContext,
    Locator,
    TimeoutError as PlaywrightTimeoutError,
)

from frontend.openeuler.home import config

# ==================== 日志初始化 ====================
logging.basicConfig(
    level=logging.INFO,
    format=config.LOG_FORMAT,
    datefmt=config.LOG_DATEFMT,
)
logger = logging.getLogger("openEulerAutomation")


class BrowserManager:
    """浏览器生命周期管理：启动、创建上下文、打开页面、关闭"""

    def __init__(self):
        self._playwright = None
        self._browser: Optional[Browser] = None
        self._context: Optional[BrowserContext] = None
        self.page: Optional[Page] = None

    def launch(self) -> Page:
        logger.info(f"🚀 启动浏览器 [{config.BROWSER_TYPE}] headless={config.HEADLESS}")
        self._playwright = sync_playwright().start()

        browser_type = getattr(self._playwright, config.BROWSER_TYPE)
        self._browser = browser_type.launch(headless=config.HEADLESS)

        self._context = self._browser.new_context(
            viewport=config.VIEWPORT,
            locale="zh-CN",
        )
        self.page = self._context.new_page()

        self.page.set_default_timeout(config.DEFAULT_TIMEOUT)
        self.page.set_default_navigation_timeout(config.NAVIGATION_TIMEOUT)

        logger.info(f"✅ 浏览器已启动，视窗: {config.VIEWPORT}")
        return self.page

    def close(self):
        logger.info("🛑 关闭浏览器...")
        try:
            if self._context:
                self._context.close()
            if self._browser:
                self._browser.close()
            if self._playwright:
                self._playwright.stop()
        except Exception as e:
            logger.error(f"浏览器关闭异常: {e}")
        finally:
            logger.info("✅ 浏览器已关闭")

    def __enter__(self):
        self.launch()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()


class PageOperator:
    """页面通用操作封装：显式等待、点击、输入、弹窗处理、异常重试"""

    def __init__(self, page: Page):
        self.page = page

    def wait_for_visible(self, locator_str: str, timeout: Optional[int] = None) -> Locator:
        to = timeout or config.ASSERTION_TIMEOUT
        logger.info(f"⏳ 等待元素可见: {locator_str} (timeout={to}ms)")
        try:
            locator = self.page.locator(locator_str)
            locator.wait_for(state="visible", timeout=to)
            logger.info(f"✅ 元素已可见: {locator_str}")
            return locator
        except PlaywrightTimeoutError:
            logger.error(f"❌ 元素等待超时（不可见）: {locator_str}")
            raise

    def wait_for_present(self, locator_str: str, timeout: Optional[int] = None) -> Locator:
        to = timeout or config.ASSERTION_TIMEOUT
        locator = self.page.locator(locator_str)
        locator.wait_for(state="attached", timeout=to)
        return locator

    def safe_click(self, locator_str: str, retries: int = 2, timeout: Optional[int] = None):
        locator = self.wait_for_visible(locator_str, timeout=timeout)
        for attempt in range(1, retries + 1):
            try:
                logger.info(f"🖱️ 点击元素: {locator_str} (第{attempt}次)")
                locator.click()
                logger.info(f"✅ 点击成功: {locator_str}")
                return
            except Exception as e:
                logger.warning(f"⚠️ 点击失败: {locator_str} | 异常: {e}")
                if attempt == retries:
                    logger.error(f"❌ 点击最终失败: {locator_str}")
                    raise
                self.page.wait_for_timeout(500)

    def safe_input(self, locator_str: str, text: str, timeout: Optional[int] = None):
        locator = self.wait_for_visible(locator_str, timeout=timeout)
        logger.info(f"⌨️ 输入文本到: {locator_str} | 内容: {text[:50]}{'...' if len(text) > 50 else ''}")
        locator.fill("")
        locator.fill(text)
        logger.info(f"✅ 输入完成: {locator_str}")

    def handle_dialog(self, action: str = "accept", prompt_text: Optional[str] = None):
        def on_dialog(dialog):
            logger.info(f"🪟 检测到弹窗: [{dialog.type}] {dialog.message[:100]}")
            if dialog.type == "prompt" and prompt_text:
                dialog.accept(prompt_text)
                logger.info("✅ 弹窗已输入并确认")
            elif action == "accept":
                dialog.accept()
                logger.info("✅ 弹窗已确认")
            else:
                dialog.dismiss()
                logger.info("✅ 弹窗已取消")

        self.page.on("dialog", on_dialog)

    def get_text(self, locator_str: str, timeout: Optional[int] = None) -> str:
        locator = self.wait_for_visible(locator_str, timeout=timeout)
        text = locator.inner_text()
        logger.info(f"📄 获取文本: {locator_str} -> {text[:80]}{'...' if len(text) > 80 else ''}")
        return text

    def get_element_count(self, locator_str: str) -> int:
        count = self.page.locator(locator_str).count()
        logger.info(f"🔢 元素计数: {locator_str} -> {count}")
        return count

    def log_page_info(self):
        logger.info(f"📍 当前URL: {self.page.url}")
        logger.info(f"📰 当前标题: {self.page.title()}")


def with_browser(wrapped_func: Callable):
    """装饰器：自动管理浏览器生命周期"""
    def wrapper(*args, **kwargs):
        bm = BrowserManager()
        try:
            page = bm.launch()
            op = PageOperator(page)
            return wrapped_func(page, op, *args, **kwargs)
        except Exception as e:
            logger.error(f"❌ 执行异常: {e}")
            traceback.print_exc()
            raise
        finally:
            bm.close()
    return wrapper
