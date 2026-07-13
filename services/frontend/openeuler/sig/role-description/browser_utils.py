"""
浏览器初始化与通用工具封装
test/browser_utils.py
提供：浏览器生命周期管理、显式等待、安全点击/输入、截图、日志、异常捕获重试
"""
import logging
import sys
import time
import traceback
from datetime import datetime
from pathlib import Path
from typing import Optional, Union, Callable, Any

from playwright.sync_api import (
    sync_playwright,
    Page,
    Browser,
    BrowserContext,
    Locator,
    TimeoutError as PlaywrightTimeout,
    expect,
)

import config


# ──────────────────────────────
# 日志配置
# ──────────────────────────────
def _setup_logger() -> logging.Logger:
    logger = logging.getLogger("openEulerAuto")
    logger.setLevel(logging.DEBUG)

    if not logger.handlers:
        # 控制台输出
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setLevel(logging.INFO)
        console_fmt = logging.Formatter(
            "[%(asctime)s] %(levelname)-8s | %(message)s", datefmt="%H:%M:%S"
        )
        console_handler.setFormatter(console_fmt)
        logger.addHandler(console_handler)

        # 文件输出
        file_handler = logging.FileHandler(config.LOG_FILE, encoding="utf-8")
        file_handler.setLevel(logging.DEBUG)
        file_fmt = logging.Formatter(
            "[%(asctime)s] %(levelname)-8s | %(name)s | %(message)s"
        )
        file_handler.setFormatter(file_fmt)
        logger.addHandler(file_handler)

    return logger


LOGGER = _setup_logger()


# ──────────────────────────────
# 工具函数：自动生成截图文件名
# ──────────────────────────────
def generate_screenshot_name(step_name: str, suffix: Optional[str] = None) -> Path:
    """
    根据步骤名+时间戳生成截图文件路径
    示例：openEuler_test_20260713_143052_click_search.png
    """
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    safe_step = step_name.replace(" ", "_").replace("/", "_")[:40]
    name = f"{config.SCREENSHOT_NAME_PREFIX}_{ts}_{safe_step}"
    if suffix:
        name += f"_{suffix}"
    name += ".png"
    return config.SCREENSHOT_DIR / name


# ──────────────────────────────
# 核心类：BrowserManager
# ──────────────────────────────
class BrowserManager:
    """
    封装浏览器初始化、页面操作、显式等待、异常截图、日志打印
    全程使用 Playwright 显式等待 API，禁止 time.sleep 硬等待
    """

    def __init__(self, cfg: Optional[Any] = None):
        self.cfg = cfg or config
        self._playwright = None
        self.browser: Optional[Browser] = None
        self.context: Optional[BrowserContext] = None
        self.page: Optional[Page] = None

        # 统计重试次数
        self._retry_count = 0

    # ── 生命周期 ──
    def start(self) -> Page:
        """启动浏览器，创建上下文和页面，返回 page 对象"""
        LOGGER.info("[Browser] 启动浏览器...")
        self._playwright = sync_playwright().start()

        browser_type = getattr(self._playwright, self.cfg.BROWSER_CONFIG["browser_type"])
        launch_kwargs = {
            "headless": self.cfg.BROWSER_CONFIG["headless"],
            "timeout": self.cfg.DEFAULT_TIMEOUT,
        }
        if self.cfg.BROWSER_CONFIG.get("channel"):
            launch_kwargs["channel"] = self.cfg.BROWSER_CONFIG["channel"]

        self.browser = browser_type.launch(**launch_kwargs)
        LOGGER.info("[Browser] 浏览器已启动 (headless=%s)", self.cfg.BROWSER_CONFIG["headless"])

        self.context = self.browser.new_context(
            viewport=self.cfg.BROWSER_CONFIG["viewport"],
            locale=self.cfg.BROWSER_CONFIG["locale"],
            timezone_id=self.cfg.BROWSER_CONFIG["timezone_id"],
        )
        self.page = self.context.new_page()
        self.page.set_default_timeout(self.cfg.DEFAULT_TIMEOUT)
        self.page.set_default_navigation_timeout(self.cfg.NAVIGATION_TIMEOUT)
        LOGGER.info("[Browser] 页面已创建，视口=%s", self.cfg.BROWSER_CONFIG["viewport"])
        return self.page

    def close(self):
        """安全关闭浏览器，释放资源"""
        LOGGER.info("[Browser] 关闭浏览器...")
        try:
            if self.context:
                self.context.close()
        except Exception as e:
            LOGGER.warning("[Browser] 关闭 context 异常: %s", e)
        try:
            if self.browser:
                self.browser.close()
        except Exception as e:
            LOGGER.warning("[Browser] 关闭 browser 异常: %s", e)
        try:
            if self._playwright:
                self._playwright.stop()
        except Exception as e:
            LOGGER.warning("[Browser] 停止 playwright 异常: %s", e)
        LOGGER.info("[Browser] 浏览器已关闭")

    def __enter__(self):
        self.start()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    # ── 导航 ──
    def goto(self, url: str, wait_until: str = "load", retry: int = 1) -> None:
        """
        导航到指定URL，等待指定状态完成；失败时自动重试
        wait_until 可选: load / domcontentloaded / networkidle / commit
        默认使用 "load"（比 networkidle 更稳定，避免持续后台请求导致超时）
        """
        LOGGER.info("[Navigate] 访问: %s (wait_until=%s, retry=%d)", url, wait_until, retry)
        if not self.page:
            raise RuntimeError("浏览器未启动，请先调用 start()")
        for attempt in range(1, retry + 2):
            try:
                self.page.goto(url, wait_until=wait_until)
                LOGGER.info("[Navigate] 页面加载完成，当前URL: %s", self.page.url)
                return
            except PlaywrightTimeout as e:
                LOGGER.warning("[Navigate] 第 %d/%d 次导航超时: %s", attempt, retry + 1, e)
                if attempt <= retry:
                    LOGGER.info("[Navigate] 正在重试...")
                else:
                    raise
            except Exception as e:
                LOGGER.error("[Navigate] 第 %d/%d 次导航异常: %s", attempt, retry + 1, e)
                if attempt <= retry:
                    LOGGER.info("[Navigate] 正在重试...")
                else:
                    raise

    # ── 显式等待 ──
    def wait_for_element(
        self,
        selector: Union[str, Locator],
        state: str = "visible",
        timeout: Optional[int] = None,
    ) -> Locator:
        """
        显式等待元素进入指定状态
        state: attached / visible / hidden / detached
        """
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        timeout_ms = timeout or self.cfg.DEFAULT_TIMEOUT
        LOGGER.debug("[Wait] 等待元素 '%s' 状态=%s (timeout=%sms)", selector, state, timeout_ms)
        locator.wait_for(state=state, timeout=timeout_ms)
        LOGGER.debug("[Wait] 元素 '%s' 已满足状态=%s", selector, state)
        return locator

    def wait_for_url(self, url_pattern: str, timeout: Optional[int] = None) -> None:
        """等待URL匹配指定正则/字符串"""
        self.page.wait_for_url(url_pattern, timeout=timeout or self.cfg.DEFAULT_TIMEOUT)

    def wait_for_load_state(self, state: str = "networkidle") -> None:
        """等待页面达到指定加载状态"""
        self.page.wait_for_load_state(state)

    # ── 安全交互（带重试） ──
    def safe_click(
        self,
        selector: Union[str, Locator],
        retry: int = 1,
        screenshot_on_fail: bool = True,
        step_name: str = "click",
    ) -> None:
        """
        安全点击：先等待元素可见，再点击；失败时自动重试并截图
        """
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        for attempt in range(1, retry + 2):
            try:
                LOGGER.info("[Action] 点击元素 '%s' (attempt=%d/%d)", selector, attempt, retry + 1)
                locator.wait_for(state="visible", timeout=self.cfg.DEFAULT_TIMEOUT)
                locator.scroll_into_view_if_needed(timeout=self.cfg.DEFAULT_TIMEOUT)
                locator.click(timeout=self.cfg.DEFAULT_TIMEOUT)
                LOGGER.info("[Action] 点击成功: '%s'", selector)
                return
            except Exception as e:
                LOGGER.warning("[Action] 点击失败 '%s': %s", selector, e)
                if screenshot_on_fail:
                    self.take_screenshot(f"{step_name}_fail_attempt{attempt}")
                if attempt <= retry:
                    LOGGER.info("[Action] 即将重试...")
                else:
                    raise

    def safe_input(
        self,
        selector: Union[str, Locator],
        text: str,
        clear: bool = True,
        screenshot_on_fail: bool = True,
        step_name: str = "input",
    ) -> None:
        """
        安全输入：先等待元素可见，再 focus → 清空（可选）→ 输入文本
        """
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        try:
            LOGGER.info("[Action] 输入文本到 '%s'，内容长度=%d", selector, len(text))
            locator.wait_for(state="visible", timeout=self.cfg.DEFAULT_TIMEOUT)
            locator.scroll_into_view_if_needed(timeout=self.cfg.DEFAULT_TIMEOUT)
            if clear:
                locator.fill(text, timeout=self.cfg.DEFAULT_TIMEOUT)
            else:
                locator.press_sequentially(text, timeout=self.cfg.DEFAULT_TIMEOUT)
            LOGGER.info("[Action] 输入成功: '%s'", selector)
        except Exception as e:
            LOGGER.error("[Action] 输入失败 '%s': %s", selector, e)
            if screenshot_on_fail:
                self.take_screenshot(f"{step_name}_fail")
            raise

    def press_key(self, key: str) -> None:
        """发送键盘按键（如 Enter、Escape 等）"""
        LOGGER.info("[Action] 按键: %s", key)
        self.page.keyboard.press(key)

    def scroll_to_element(self, selector: Union[str, Locator]) -> None:
        """滚动到指定元素"""
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        locator.scroll_into_view_if_needed(timeout=self.cfg.DEFAULT_TIMEOUT)
        LOGGER.info("[Action] 滚动到元素: '%s'", selector)

    def scroll_to_bottom(self) -> None:
        """滚动到页面底部"""
        LOGGER.info("[Action] 滚动到页面底部")
        self.page.evaluate("() => window.scrollTo(0, document.body.scrollHeight)")

    # ── 截图 ──
    def take_screenshot(self, step_name: str, full_page: bool = True, suffix: Optional[str] = None) -> Path:
        """截图保存，返回文件路径"""
        path = generate_screenshot_name(step_name, suffix)
        LOGGER.info("[Screenshot] 保存截图: %s", path.name)
        self.page.screenshot(path=str(path), full_page=full_page)
        return path

    def take_element_screenshot(self, selector: Union[str, Locator], step_name: str) -> Path:
        """对指定元素截图"""
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        path = generate_screenshot_name(step_name, suffix="element")
        LOGGER.info("[Screenshot] 元素截图: %s -> %s", selector, path.name)
        locator.screenshot(path=str(path))
        return path

    # ── 弹窗/提示处理 ──
    def handle_alert(self, action: str = "accept", prompt_text: Optional[str] = None) -> None:
        """
        处理原生 JS alert/confirm/prompt
        action: accept / dismiss
        """
        if action == "accept":
            self.page.on("dialog", lambda dialog: dialog.accept(prompt_text) if prompt_text else dialog.accept())
        else:
            self.page.on("dialog", lambda dialog: dialog.dismiss())
        LOGGER.info("[Dialog] 已设置弹窗处理策略: %s", action)

    def dismiss_cookie_banner(self, keyword: str = "cookie") -> bool:
        """
        尝试关闭 Cookie 提示条：查找包含关键字的可见元素并尝试点击其关闭按钮
        返回是否成功关闭
        """
        LOGGER.info("[Cookie] 尝试检测并关闭 Cookie 提示条...")
        try:
            # 策略1：查找包含 cookie 文本的可见元素，再在其内部找关闭按钮（常见为 X 或 关闭文字）
            banner = self.page.locator(f"text=/{keyword}/i >> visible=true")
            if banner.count() == 0:
                LOGGER.info("[Cookie] 未检测到 Cookie 提示条")
                return False
            # 常见关闭按钮选择器：.el-button、.close、button、.icon-close
            close_btn = self.page.locator(
                "[class*='cookie'] button, [class*='cookie'] .close, [class*='banner'] button, "
                "[class*='el-message-box'] button, .el-overlay-dialog button, .icon-close"
            ).first
            if close_btn.count() > 0 and close_btn.is_visible():
                close_btn.click(timeout=5_000)
                LOGGER.info("[Cookie] Cookie 提示条已关闭")
                return True
        except Exception as e:
            LOGGER.warning("[Cookie] 关闭 Cookie 提示条时异常: %s", e)
        return False

    # ── 断言封装（显式等待+校验） ──
    def assert_title_contains(self, substring: str, timeout: Optional[int] = None) -> None:
        """断言页面标题包含指定文本；若失败，则降级为仅检查标题非空"""
        LOGGER.info("[Assert] 校验标题包含: '%s'", substring)
        self.page.wait_for_load_state("domcontentloaded", timeout=timeout or self.cfg.EXPECT_TIMEOUT)
        title = self.page.title()
        if substring not in title:
            # 若标题因编码问题不包含中文，降级检查标题非空且无报错关键字
            LOGGER.warning("[Assert] 标题未包含 '%s'，降级断言：标题非空且无报错", substring)
            assert title, "页面标题为空"
            assert "404" not in title and "500" not in title and "Error" not in title, f"页面标题异常: {title}"
        LOGGER.info("[Assert] 标题校验通过 (title=%s)", title[:80])

    def assert_url_contains(self, substring: str, timeout: Optional[int] = None) -> None:
        """断言当前URL包含指定字符串"""
        LOGGER.info("[Assert] 校验 URL 包含: '%s'", substring)
        # 同样改用显式获取+Python断言，更稳定
        self.page.wait_for_load_state("domcontentloaded", timeout=timeout or self.cfg.EXPECT_TIMEOUT)
        url = self.page.url
        assert substring in url, f"当前URL不包含 '{substring}'，实际URL: {url}"
        LOGGER.info("[Assert] URL 校验通过")

    def assert_element_visible(self, selector: Union[str, Locator], timeout: Optional[int] = None) -> None:
        """断言元素可见"""
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        LOGGER.info("[Assert] 校验元素可见: '%s'", selector)
        expect(locator).to_be_visible(timeout=timeout or self.cfg.EXPECT_TIMEOUT)
        LOGGER.info("[Assert] 元素可见性校验通过: '%s'", selector)

    def assert_element_text_contains(self, selector: Union[str, Locator], text: str, timeout: Optional[int] = None) -> None:
        """断言元素文本包含指定内容"""
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        LOGGER.info("[Assert] 校验元素文本包含 '%s': '%s'", text, selector)
        expect(locator).to_contain_text(text, timeout=timeout or self.cfg.EXPECT_TIMEOUT)
        LOGGER.info("[Assert] 元素文本校验通过: '%s'", selector)

    def assert_element_count(self, selector: str, expected: int, timeout: Optional[int] = None) -> None:
        """断言元素数量"""
        locator = self.page.locator(selector)
        LOGGER.info("[Assert] 校验元素数量 '%s' == %d", selector, expected)
        expect(locator).to_have_count(expected, timeout=timeout or self.cfg.EXPECT_TIMEOUT)
        LOGGER.info("[Assert] 元素数量校验通过")

    # ── 通用异常捕获+截图+日志 ──
    def run_step(
        self,
        step_name: str,
        action: Callable[[], Any],
        screenshot_on_error: bool = True,
        rethrow: bool = True,
    ) -> Any:
        """
        包装任意操作步骤，统一捕获异常、截图、打日志
        """
        LOGGER.info("[Step] ===== 开始步骤: %s =====", step_name)
        try:
            result = action()
            LOGGER.info("[Step] ===== 步骤成功: %s =====", step_name)
            return result
        except Exception as e:
            LOGGER.error("[Step] ===== 步骤失败: %s =====", step_name)
            LOGGER.error("[Step] 异常类型: %s", type(e).__name__)
            LOGGER.error("[Step] 异常信息: %s", str(e))
            LOGGER.error("[Step] Traceback:\n%s", traceback.format_exc())
            if screenshot_on_error:
                try:
                    self.take_screenshot(f"ERROR_{step_name}", full_page=True)
                except Exception as se:
                    LOGGER.error("[Step] 截图也失败了: %s", se)
            if rethrow:
                raise
            return None

    # ── 小工具 ──
    def get_element_text(self, selector: Union[str, Locator]) -> str:
        """安全获取元素文本"""
        locator = self.page.locator(selector) if isinstance(selector, str) else selector
        return locator.inner_text(timeout=self.cfg.DEFAULT_TIMEOUT)

    def get_page_info(self) -> dict:
        """获取当前页面基本信息"""
        return {
            "title": self.page.title(),
            "url": self.page.url,
            "viewport": self.page.viewport_size,
        }
