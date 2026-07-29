"""
公共基础工具封装
test/browser_utils.py
包含：浏览器初始化、通用元素操作、截图、日志、异常重试
"""
import os
import sys
import time
import traceback
import logging
import re
from datetime import datetime
from functools import wraps
from typing import Optional, Callable, Any, List

from playwright.sync_api import (
    sync_playwright,
    Page,
    Browser,
    BrowserContext,
    Locator,
    expect,
    TimeoutError as PlaywrightTimeoutError,
)

# 导入全局配置
from test.config import (
    SCREENSHOT_DIR,
    LOG_DIR,
    LOG_TIME_FORMAT,
    SCREENSHOT_TIME_FORMAT,
    BROWSER_CONFIG,
    CONTEXT_CONFIG,
    DEFAULT_TIMEOUT,
    POLLING_INTERVAL,
    LOG_LEVEL,
)

# ============================ 日志配置 ============================
def _ensure_logger() -> logging.Logger:
    """
    初始化并返回一个结构化 Logger，同时输出到控制台和日志文件。
    Windows 环境下强制使用 UTF-8 编码，避免 GBK 乱码。
    """
    logger = logging.getLogger("openeuler_automation")
    if logger.handlers:
        return logger

    logger.setLevel(getattr(logging, LOG_LEVEL.upper(), logging.INFO))

    # 统一格式：时间 [级别] 消息
    formatter = logging.Formatter(
        "%(asctime)s [%(levelname)s] %(message)s",
        datefmt="%H:%M:%S",
    )

    # 控制台 Handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    # 文件 Handler (按天/按次运行均可，这里按次生成文件名)
    log_filename = os.path.join(
        LOG_DIR, f"run_{datetime.now().strftime(LOG_TIME_FORMAT)}.log"
    )
    file_handler = logging.FileHandler(log_filename, encoding="utf-8")
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    logger.info(f"日志文件已创建: {log_filename}")
    return logger


logger = _ensure_logger()


# ============================ 截图工具 ============================
def take_screenshot(page: Page, name: str = "", output_dir: str = SCREENSHOT_DIR) -> str:
    """
    自动截图保存工具。

    Args:
        page: Playwright Page 对象
        name: 截图文件名前缀（为空则自动生成）
        output_dir: 截图保存目录

    Returns:
        保存的文件绝对路径
    """
    timestamp = datetime.now().strftime(SCREENSHOT_TIME_FORMAT)
    prefix = f"{name}_" if name else ""
    filename = f"{prefix}{timestamp}.png"
    filepath = os.path.join(output_dir, filename)

    try:
        page.screenshot(path=filepath, full_page=True)
        logger.info(f"[Screenshot] 已保存全页截图: {filepath}")
    except Exception as e:
        logger.error(f"[Screenshot] 截图失败: {e}")
        # 尝试保存失败时的降级截图（仅当前视口）
        try:
            fallback = os.path.join(output_dir, f"{prefix}{timestamp}_fallback.png")
            page.screenshot(path=fallback, full_page=False)
            logger.info(f"[Screenshot] 降级视口截图已保存: {fallback}")
            return fallback
        except Exception as e2:
            logger.error(f"[Screenshot] 降级截图也失败: {e2}")
    return filepath


# ============================ 通用重试装饰器 ============================
def retry(max_retries: int = 3, delay: float = 1.0, on_retry: Optional[Callable] = None):
    """
    通用重试装饰器，用于包裹不稳定的操作（如网络抖动导致的元素未就绪）。

    Args:
        max_retries: 最大重试次数（不含首次）
        delay: 每次重试间隔（秒）
        on_retry: 每次重试前执行的回调函数，签名为 func(exception, attempt)
    """
    def decorator(func: Callable) -> Callable:
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None
            for attempt in range(1, max_retries + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    logger.warning(
                        f"[Retry] {func.__name__} 第 {attempt}/{max_retries} 次尝试失败: {e}"
                    )
                    if on_retry:
                        try:
                            on_retry(e, attempt)
                        except Exception as cb_err:
                            logger.warning(f"[Retry] on_retry 回调异常: {cb_err}")
                    if attempt < max_retries:
                        time.sleep(delay)
            # 所有重试耗尽
            logger.error(f"[Retry] {func.__name__} 在 {max_retries} 次尝试后最终失败")
            raise last_exception
        return wrapper
    return decorator


# ============================ 浏览器管理器 ============================
class BrowserManager:
    """
    Playwright 浏览器生命周期管理器。
    支持 `with` 上下文管理器，确保资源一定释放。
    """

    def __init__(
        self,
        browser_config: dict = None,
        context_config: dict = None,
        default_timeout: int = DEFAULT_TIMEOUT,
    ):
        self.browser_config = browser_config or BROWSER_CONFIG
        self.context_config = context_config or CONTEXT_CONFIG
        self.default_timeout = default_timeout

        self._playwright = None
        self._browser: Optional[Browser] = None
        self._context: Optional[BrowserContext] = None
        self._page: Optional[Page] = None

    # ---------- 生命周期 ----------
    def start(self) -> Page:
        """启动 Playwright -> Browser -> Context -> Page，返回 Page 对象。"""
        logger.info("[BrowserManager] 启动 Playwright 浏览器...")
        self._playwright = sync_playwright().start()

        self._browser = self._playwright.chromium.launch(**self.browser_config)
        logger.info(f"[BrowserManager] Browser 已启动 (headless={self.browser_config.get('headless')})")

        self._context = self._browser.new_context(**self.context_config)
        logger.info(f"[BrowserManager] Context 已创建 (viewport={self.context_config.get('viewport')})")

        self._page = self._context.new_page()
        self._page.set_default_timeout(self.default_timeout)
        logger.info(f"[BrowserManager] Page 已创建，默认超时 {self.default_timeout}ms")

        return self._page

    def close(self):
        """按逆序关闭 Page -> Context -> Browser -> Playwright，避免资源泄漏。"""
        logger.info("[BrowserManager] 开始关闭浏览器资源...")
        if self._page:
            try:
                self._page.close()
                logger.info("[BrowserManager] Page 已关闭")
            except Exception as e:
                logger.warning(f"[BrowserManager] 关闭 Page 异常: {e}")
            self._page = None

        if self._context:
            try:
                self._context.close()
                logger.info("[BrowserManager] Context 已关闭")
            except Exception as e:
                logger.warning(f"[BrowserManager] 关闭 Context 异常: {e}")
            self._context = None

        if self._browser:
            try:
                self._browser.close()
                logger.info("[BrowserManager] Browser 已关闭")
            except Exception as e:
                logger.warning(f"[BrowserManager] 关闭 Browser 异常: {e}")
            self._browser = None

        if self._playwright:
            try:
                self._playwright.stop()
                logger.info("[BrowserManager] Playwright 已停止")
            except Exception as e:
                logger.warning(f"[BrowserManager] 停止 Playwright 异常: {e}")
            self._playwright = None

    @property
    def page(self) -> Optional[Page]:
        """获取当前 Page 对象，未启动则返回 None。"""
        return self._page

    # ---------- 上下文管理器支持 ----------
    def __enter__(self):
        self.start()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """
        退出 with 块时，若发生异常则自动截图，然后关闭浏览器。
        """
        if exc_type and self._page:
            logger.error("[BrowserManager] with块内发生异常，自动截图...")
            take_screenshot(self._page, name="exception_auto")
            logger.error(f"[BrowserManager] 异常类型: {exc_type.__name__}, 详情: {exc_val}")
        self.close()
        # 不吞异常，返回 None 让异常继续抛出

    # ---------- 快捷导航 ----------
    def goto(self, url: str, wait_until: str = "networkidle", timeout: int = None) -> Any:
        """
        封装 page.goto，统一等待策略与超时，并自动截图记录。

        Args:
            url: 目标地址
            wait_until: 等待策略 (load / domcontentloaded / networkidle / commit)
            timeout: 覆盖默认超时

        Returns:
            Response 对象
        """
        page = self._page
        if not page:
            raise RuntimeError("BrowserManager 未启动，请先调用 start() 或在 with 语句中使用")

        to = timeout or self.default_timeout
        logger.info(f"[BrowserManager] 导航至: {url} (wait_until={wait_until}, timeout={to}ms)")
        try:
            response = page.goto(url, wait_until=wait_until, timeout=to)
            status = response.status if response else "N/A"
            logger.info(f"[BrowserManager] 导航完成，HTTP状态: {status}")
            return response
        except PlaywrightTimeoutError:
            logger.warning(f"[BrowserManager] 等待 '{wait_until}' 超时，尝试降级到 'domcontentloaded'...")
            response = page.goto(url, wait_until="domcontentloaded", timeout=to)
            logger.info(f"[BrowserManager] 降级导航完成，HTTP状态: {response.status if response else 'N/A'}")
            return response


# ============================ 元素操作封装 ============================
class ActionUtils:
    """
    页面通用操作封装类，所有方法均包含：
    - 显式等待（Playwright expect / wait_for）
    - 异常捕获
    - 失败自动截图
    - 结构化日志
    """

    def __init__(self, page: Page, screenshot_dir: str = SCREENSHOT_DIR):
        self.page = page
        self.screenshot_dir = screenshot_dir

    # ---------- 私有辅助：异常处理+截图 ----------
    def _handle_exception(self, action_name: str, locator_desc: str, exception: Exception):
        """统一处理异常：打印日志、自动截图、抛出异常。"""
        logger.error(f"[ActionUtils][{action_name}] 失败 | 目标: {locator_desc} | 错误: {exception}")
        take_screenshot(self.page, name=f"fail_{action_name}")
        raise

    # ---------- 1. 等待元素可见 ----------
    def wait_visible(self, locator: Locator, timeout: int = DEFAULT_TIMEOUT, description: str = "") -> Locator:
        """
        显式等待元素变为可见（Visible）。

        Args:
            locator: Playwright Locator 对象
            timeout: 超时毫秒数
            description: 元素描述（用于日志）

        Returns:
            Locator 自身（链式调用）
        """
        desc = description or str(locator)
        logger.info(f"[WaitVisible] 等待元素可见: {desc} (timeout={timeout}ms)")
        try:
            expect(locator).to_be_visible(timeout=timeout)
            logger.info(f"[WaitVisible] 元素已可见: {desc}")
        except Exception as e:
            self._handle_exception("wait_visible", desc, e)
        return locator

    def wait_hidden(self, locator: Locator, timeout: int = DEFAULT_TIMEOUT, description: str = "") -> Locator:
        """显式等待元素隐藏（Hidden）。"""
        desc = description or str(locator)
        logger.info(f"[WaitHidden] 等待元素隐藏: {desc} (timeout={timeout}ms)")
        try:
            expect(locator).to_be_hidden(timeout=timeout)
            logger.info(f"[WaitHidden] 元素已隐藏: {desc}")
        except Exception as e:
            self._handle_exception("wait_hidden", desc, e)
        return locator

    # ---------- 2. 安全点击 ----------
    def safe_click(self, locator: Locator, timeout: int = DEFAULT_TIMEOUT, description: str = "", force: bool = False):
        """
        安全点击：先等待元素可见，再执行 click，支持 force 强制点击（覆盖元素遮挡）。

        Args:
            locator: 目标 Locator
            timeout: 超时
            description: 元素描述
            force: 是否强制点击（Playwright force=True）
        """
        desc = description or str(locator)
        logger.info(f"[SafeClick] 准备点击: {desc} (force={force})")
        try:
            self.wait_visible(locator, timeout=timeout, description=desc)
            locator.click(force=force, timeout=timeout)
            logger.info(f"[SafeClick] 点击成功: {desc}")
        except Exception as e:
            self._handle_exception("safe_click", desc, e)

    # ---------- 3. 安全输入 ----------
    def safe_input(self, locator: Locator, text: str, timeout: int = DEFAULT_TIMEOUT, description: str = "", clear: bool = True):
        """
        安全输入文本：先等待元素可见，清空（可选），再 fill。

        Args:
            locator: 输入框 Locator
            text: 待输入文本
            timeout: 超时
            description: 元素描述
            clear: 是否先清空已有内容
        """
        desc = description or str(locator)
        logger.info(f"[SafeInput] 准备输入: '{text}' -> {desc}")
        try:
            self.wait_visible(locator, timeout=timeout, description=desc)
            if clear:
                locator.clear(timeout=timeout)
                logger.info(f"[SafeInput] 已清空原内容: {desc}")
            locator.fill(text, timeout=timeout)
            logger.info(f"[SafeInput] 输入完成: {desc}")
        except Exception as e:
            self._handle_exception("safe_input", desc, e)

    # ---------- 4. 获取元素文本 ----------
    def get_text(self, locator: Locator, timeout: int = DEFAULT_TIMEOUT, description: str = "") -> str:
        """等待元素可见并返回 inner_text()。"""
        desc = description or str(locator)
        try:
            self.wait_visible(locator, timeout=timeout, description=desc)
            text = locator.inner_text(timeout=timeout)
            logger.info(f"[GetText] 获取文本: {desc} = '{text[:50]}...' " if len(text) > 50 else f"[GetText] 获取文本: {desc} = '{text}'")
            return text
        except Exception as e:
            self._handle_exception("get_text", desc, e)

    def get_attribute(self, locator: Locator, attr: str, timeout: int = DEFAULT_TIMEOUT, description: str = "") -> str:
        """等待元素存在并返回指定属性值。"""
        desc = description or str(locator)
        try:
            locator.wait_for(state="attached", timeout=timeout)
            val = locator.get_attribute(attr, timeout=timeout)
            logger.info(f"[GetAttr] 获取属性: {desc} @{attr} = '{val}'")
            return val
        except Exception as e:
            self._handle_exception("get_attribute", desc, e)

    # ---------- 5. 断言封装 ----------
    def assert_title_contains(self, pattern: str, timeout: int = DEFAULT_TIMEOUT):
        """断言页面标题匹配正则表达式。"""
        logger.info(f"[AssertTitle] 校验标题包含正则: {pattern}")
        try:
            expect(self.page).to_have_title(re.compile(pattern), timeout=timeout)
            logger.info("[AssertTitle] 标题校验通过")
        except Exception as e:
            actual = self.page.title()
            logger.error(f"[AssertTitle] 标题校验失败 | 期望正则: {pattern} | 实际: {actual}")
            take_screenshot(self.page, name="assert_title_fail")
            raise

    def assert_url_contains(self, path: str, timeout: int = DEFAULT_TIMEOUT):
        """断言当前URL包含指定路径。"""
        logger.info(f"[AssertURL] 校验URL包含: {path}")
        try:
            expect(self.page).to_have_url(re.compile(".*" + re.escape(path) + ".*"), timeout=timeout)
            logger.info("[AssertURL] URL校验通过")
        except Exception as e:
            actual = self.page.url
            logger.error(f"[AssertURL] URL校验失败 | 期望包含: {path} | 实际: {actual}")
            take_screenshot(self.page, name="assert_url_fail")
            raise

    def assert_text_visible(self, locator: Locator, expected: str, timeout: int = DEFAULT_TIMEOUT, description: str = ""):
        """断言 Locator 包含指定文本。"""
        desc = description or str(locator)
        logger.info(f"[AssertText] 校验元素文本包含: '{expected}' | 目标: {desc}")
        try:
            expect(locator).to_contain_text(expected, timeout=timeout)
            logger.info("[AssertText] 文本校验通过")
        except Exception as e:
            actual = locator.inner_text()
            logger.error(f"[AssertText] 文本校验失败 | 期望: {expected} | 实际: {actual}")
            take_screenshot(self.page, name="assert_text_fail")
            raise

    def assert_element_visible(self, locator: Locator, timeout: int = DEFAULT_TIMEOUT, description: str = ""):
        """断言元素可见。"""
        desc = description or str(locator)
        logger.info(f"[AssertVisible] 校验元素可见: {desc}")
        try:
            expect(locator).to_be_visible(timeout=timeout)
            logger.info("[AssertVisible] 可见性校验通过")
        except Exception as e:
            logger.error(f"[AssertVisible] 可见性校验失败: {desc}")
            take_screenshot(self.page, name="assert_visible_fail")
            raise

    # ---------- 6. 弹窗/遮罩处理 ----------
    def dismiss_modal_if_visible(self, modal_locator: Locator, description: str = "弹窗/遮罩"):
        """
        若指定弹窗可见，则尝试关闭或点击背景关闭。
        适用于 Element Plus / Ant Design 等框架的遮罩层。
        """
        logger.info(f"[ModalDismiss] 检查并关闭弹窗: {description}")
        try:
            if modal_locator.is_visible(timeout=3000):
                logger.warning(f"[ModalDismiss] 发现可见弹窗，尝试关闭...")
                # 策略1：尝试点击弹窗内的关闭按钮（常见 class: .close, .el-dialog__close, .icon-close）
                close_btn = self.page.locator(
                    ".el-dialog__close, .icon-close, .close, [aria-label='close']"
                ).first
                if close_btn.is_visible(timeout=2000):
                    close_btn.click()
                    logger.info("[ModalDismiss] 已点击关闭按钮")
                    return
                # 策略2：点击遮罩背景（若支持 close-on-click-modal）
                modal_locator.click(position={"x": 10, "y": 10})
                logger.info("[ModalDismiss] 已点击遮罩背景关闭")
            else:
                logger.info(f"[ModalDismiss] 弹窗未显示，无需关闭: {description}")
        except Exception as e:
            logger.warning(f"[ModalDismiss] 关闭弹窗时发生异常（非致命）: {e}")
            # 弹窗关闭失败不应阻断主流程，仅记录日志

    def assert_no_blocking_modal(self, modal_locator: Locator, description: str = "弹窗/遮罩"):
        """断言无阻塞业务弹窗（如登录弹窗、提示弹窗）。"""
        logger.info(f"[AssertNoModal] 断言无阻塞弹窗: {description}")
        try:
            expect(modal_locator).to_be_hidden(timeout=5000)
            logger.info("[AssertNoModal] 无阻塞弹窗，校验通过")
        except Exception as e:
            logger.error(f"[AssertNoModal] 发现阻塞弹窗未关闭: {description}")
            take_screenshot(self.page, name="blocking_modal_fail")
            raise

    # ---------- 7. 截图快捷 ----------
    def screenshot(self, name: str = "") -> str:
        """快捷调用截图工具。"""
        return take_screenshot(self.page, name=name)

    # ---------- 8. 滚动到元素 ----------
    def scroll_to(self, locator: Locator, description: str = ""):
        """将元素滚动到视口内。"""
        desc = description or str(locator)
        logger.info(f"[ScrollTo] 滚动至元素: {desc}")
        try:
            locator.scroll_into_view_if_needed()
            logger.info(f"[ScrollTo] 滚动完成: {desc}")
        except Exception as e:
            logger.warning(f"[ScrollTo] 滚动异常（非致命）: {e}")

    # ---------- 9. 新标签页处理 ----------
    def wait_for_new_tab(self, action: Callable, timeout: int = DEFAULT_TIMEOUT) -> Page:
        """
        执行一个会打开新标签页的操作，并等待返回新 Page。
        常用于点击 `target="_blank"` 的链接。

        Args:
            action: 无参函数，内部执行触发新标签页的操作
            timeout: 等待新页面超时

        Returns:
            新打开的 Page 对象
        """
        logger.info("[WaitNewTab] 等待新标签页打开...")
        try:
            with self.page.context.expect_page(timeout=timeout) as new_page_info:
                action()
            new_page = new_page_info.value
            new_page.wait_for_load_state("domcontentloaded", timeout=timeout)
            logger.info(f"[WaitNewTab] 新标签页已打开: {new_page.url}")
            return new_page
        except Exception as e:
            logger.error(f"[WaitNewTab] 等待新标签页失败: {e}")
            take_screenshot(self.page, name="wait_new_tab_fail")
            raise
