"""
browser_utils.py
浏览器生命周期管理：启动、上下文创建、关闭、基础配置。
所有浏览器级别的操作封装在此，主脚本只需调用简洁的API。
"""

import logging
from pathlib import Path
from playwright.sync_api import sync_playwright, Browser, BrowserContext, Page, TimeoutError as PlaywrightTimeout

# 导入全局配置
from global_config import (
    TARGET_URL,
    LOCALE,
    VIEWPORT,
    TIMEOUT_PAGE_LOAD,
    TIMEOUT_ELEMENT,
    TIMEOUT_NAVIGATION,
)

# 配置日志
logger = logging.getLogger(__name__)


class BrowserManager:
    """
    浏览器管理器：封装Playwright浏览器启动、关闭、上下文管理。
    使用上下文管理器（with语句）确保浏览器进程被正确释放。
    """

    def __init__(self, headless: bool = False, browser_type: str = "chromium"):
        """
        初始化浏览器管理器。

        :param headless: 是否无头模式（默认False，即有头模式，方便调试和截图）
        :param browser_type: 浏览器类型，仅支持chromium（Chrome内核）
        """
        self.headless = headless
        self.browser_type = browser_type
        self._playwright = None
        self._browser: Browser | None = None
        self._context: BrowserContext | None = None
        self.page: Page | None = None

    def start(self) -> Page:
        """
        启动浏览器并创建新页面，返回Page对象供后续操作。

        流程：启动Playwright → 启动Chromium → 新建Context（视口+超时）→ 新建Page
        """
        logger.info("[Browser] 正在启动 %s 浏览器（headless=%s）...", self.browser_type, self.headless)
        self._playwright = sync_playwright().start()

        # 启动Chromium浏览器实例
        browser_launcher = getattr(self._playwright, self.browser_type)
        self._browser = browser_launcher.launch(
            headless=self.headless,
            timeout=TIMEOUT_PAGE_LOAD,
        )
        logger.info("[Browser] 浏览器进程已启动。")

        # 创建浏览器上下文（隔离的cookie、localStorage等）
        self._context = self._browser.new_context(
            viewport=VIEWPORT,
            locale=LOCALE,
        )

        # 新建页面并设置默认超时
        self.page = self._context.new_page()
        self.page.set_default_timeout(TIMEOUT_ELEMENT)
        self.page.set_default_navigation_timeout(TIMEOUT_NAVIGATION)
        logger.info("[Browser] 新页面已创建，视口=%s，默认元素超时=%dms", VIEWPORT, TIMEOUT_ELEMENT)

        return self.page

    def goto(self, url: str = TARGET_URL, wait_until: str = "networkidle") -> None:
        """
        导航到指定URL，并等待页面加载到指定状态。

        :param url: 目标地址（默认从global_config读取）
        :param wait_until: 加载完成状态：load/domcontentloaded/networkidle（默认networkidle，等待网络空闲）
        """
        if not self.page:
            raise RuntimeError("浏览器未启动，请先调用 start()")

        logger.info("[Browser] 正在访问: %s (wait_until=%s)", url, wait_until)
        try:
            self.page.goto(url, wait_until=wait_until)
            # 额外等待DOM渲染完成，确保Vue/React等前端框架已挂载
            self.page.wait_for_load_state("domcontentloaded")
            logger.info("[Browser] 页面加载完成，当前URL: %s", self.page.url)
        except PlaywrightTimeout as e:
            logger.error("[Browser] 页面加载超时: %s", e)
            raise

    def close(self) -> None:
        """
        安全关闭浏览器：先关闭页面 → 关闭Context → 关闭Browser → 停止Playwright。
        任何阶段的异常都不会阻止后续清理操作。
        """
        logger.info("[Browser] 正在关闭浏览器...")
        try:
            if self.page and not self.page.is_closed():
                self.page.close()
                logger.info("[Browser] 页面已关闭。")
        except Exception as e:
            logger.warning("[Browser] 关闭页面时发生异常: %s", e)

        try:
            if self._context:
                self._context.close()
                logger.info("[Browser] Context已关闭。")
        except Exception as e:
            logger.warning("[Browser] 关闭Context时发生异常: %s", e)

        try:
            if self._browser:
                self._browser.close()
                logger.info("[Browser] 浏览器进程已关闭。")
        except Exception as e:
            logger.warning("[Browser] 关闭浏览器时发生异常: %s", e)

        try:
            if self._playwright:
                self._playwright.stop()
                logger.info("[Browser] Playwright已停止。")
        except Exception as e:
            logger.warning("[Browser] 停止Playwright时发生异常: %s", e)

        self.page = None
        self._context = None
        self._browser = None
        self._playwright = None

    def __enter__(self):
        """上下文管理器入口：with BrowserManager() as bm:"""
        self.start()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """上下文管理器出口：确保无论是否异常都关闭浏览器"""
        self.close()
        return False  # 不吞掉异常，让上层继续处理
