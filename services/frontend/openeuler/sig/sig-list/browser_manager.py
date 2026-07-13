"""
browser_manager.py
Playwright浏览器生命周期管理：启动、关闭、上下文配置
"""

from playwright.sync_api import sync_playwright, Browser, BrowserContext, Page

from config import (
    BROWSER_TYPE,
    HEADLESS,
    SLOW_MO,
    VIEWPORT_WIDTH,
    VIEWPORT_HEIGHT,
    DEFAULT_TIMEOUT,
    NAVIGATION_TIMEOUT,
)
from logger import get_logger

logger = get_logger(__name__)


class BrowserManager:
    """
    Playwright浏览器上下文管理器
    使用with语句确保安全关闭，自动注入全局超时和视口配置
    """

    def __init__(self):
        self._playwright = None
        self._browser: Browser | None = None
        self._context: BrowserContext | None = None
        self._page: Page | None = None

    def launch(self) -> Page:
        """
        启动浏览器并创建Page实例
        :return: 配置好的Page对象
        :raises RuntimeError: 浏览器启动失败
        """
        try:
            self._playwright = sync_playwright().start()

            browser_launcher = getattr(self._playwright, BROWSER_TYPE)
            self._browser = browser_launcher.launch(
                headless=HEADLESS,
                slow_mo=SLOW_MO,
                args=["--disable-blink-features=AutomationControlled"],
            )

            self._context = self._browser.new_context(
                viewport={"width": VIEWPORT_WIDTH, "height": VIEWPORT_HEIGHT},
                locale="zh-CN",
                timezone_id="Asia/Shanghai",
            )

            self._page = self._context.new_page()
            self._page.set_default_timeout(DEFAULT_TIMEOUT)
            self._page.set_default_navigation_timeout(NAVIGATION_TIMEOUT)

            logger.info(
                f"浏览器启动成功：{BROWSER_TYPE} | headless={HEADLESS} | "
                f"viewport={VIEWPORT_WIDTH}x{VIEWPORT_HEIGHT}"
            )
            return self._page

        except Exception as e:
            logger.error(f"浏览器启动失败：{e}")
            self.shutdown()
            raise RuntimeError(f"浏览器启动失败：{e}") from e

    def shutdown(self):
        """安全关闭浏览器及所有资源"""
        if self._page:
            self._page.close()
            self._page = None
        if self._context:
            self._context.close()
            self._context = None
        if self._browser:
            self._browser.close()
            self._browser = None
        if self._playwright:
            self._playwright.stop()
            self._playwright = None
        logger.info("浏览器资源已释放")

    def __enter__(self) -> Page:
        return self.launch()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.shutdown()
        return False
