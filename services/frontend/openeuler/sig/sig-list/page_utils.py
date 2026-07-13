"""
page_utils.py
页面通用操作封装：等待、点击、输入、下拉框、弹窗、截图、断言
"""

import time
from pathlib import Path
from typing import Optional

from playwright.sync_api import Page, expect, Locator

from config import SCREENSHOT_DIR, MAX_RETRY, RETRY_DELAY
from logger import get_logger

logger = get_logger(__name__)


def wait_for_selector(
    page: Page,
    selector: str,
    state: str = "visible",
    timeout: Optional[int] = None,
) -> Optional[Locator]:
    """
    显式等待元素到达指定状态
    :param page: Page实例
    :param selector: CSS/XPath选择器
    :param state: 等待状态 visible|hidden|attached|detached
    :param timeout: 自定义超时(ms)
    :return: Locator对象，超时返回None
    """
    try:
        locator = page.locator(selector)
        locator.wait_for(state=state, timeout=timeout)
        logger.info(f"[等待成功] {selector} | state={state}")
        return locator
    except Exception as e:
        logger.warning(f"[等待超时] {selector} | state={state} | {e}")
        return None


def safe_click(
    page: Page,
    selector: str,
    force: bool = False,
    retry: int = MAX_RETRY,
) -> bool:
    """
    安全点击：先等待可见再点击，支持失败重试
    """
    for attempt in range(retry + 1):
        try:
            locator = page.locator(selector)
            locator.wait_for(state="visible")
            locator.click(force=force)
            logger.info(f"[点击成功] {selector} | attempt={attempt + 1}")
            return True
        except Exception as e:
            logger.warning(f"[点击失败] {selector} | attempt={attempt + 1}/{retry + 1} | {e}")
            if attempt < retry:
                time.sleep(RETRY_DELAY)
    return False


def safe_input(
    page: Page,
    selector: str,
    text: str,
    clear_first: bool = True,
    retry: int = MAX_RETRY,
) -> bool:
    """
    安全输入：清空后输入文本，支持失败重试
    """
    for attempt in range(retry + 1):
        try:
            locator = page.locator(selector)
            locator.wait_for(state="visible")
            if clear_first:
                locator.fill("")
            locator.fill(text)
            logger.info(f"[输入成功] {selector} -> '{text}' | attempt={attempt + 1}")
            return True
        except Exception as e:
            logger.warning(f"[输入失败] {selector} | attempt={attempt + 1}/{retry + 1} | {e}")
            if attempt < retry:
                time.sleep(RETRY_DELAY)
    return False


def select_dropdown_option(
    page: Page,
    dropdown_selector: str,
    option_text: str,
) -> bool:
    """
    点击下拉框并选择指定文本的选项
    """
    try:
        dropdown = page.locator(dropdown_selector)
        dropdown.wait_for(state="visible")
        dropdown.click()
        logger.info(f"[下拉框打开] {dropdown_selector}")

        option = page.locator("text=" + option_text)
        option.wait_for(state="visible")
        option.click()
        logger.info(f"[选项选择成功] {option_text}")
        return True
    except Exception as e:
        logger.error(f"[下拉框选择失败] {dropdown_selector} | {option_text} | {e}")
        return False


def take_screenshot(
    page: Page,
    filename: str,
    full_page: bool = True,
) -> Path:
    """
    保存页面截图到指定目录
    """
    timestamp = time.strftime("%H%M%S")
    safe_name = filename.replace(" ", "_").replace("/", "_")
    filepath = SCREENSHOT_DIR / f"{safe_name}_{timestamp}.png"
    page.screenshot(path=str(filepath), full_page=full_page)
    logger.info(f"[截图] {filepath}")
    return filepath


def assert_page_title(
    page: Page,
    expected_substring: str,
    timeout: Optional[int] = None,
) -> bool:
    """
    校验页面标题包含指定文本
    """
    try:
        expect(page).to_have_title(expected_substring, timeout=timeout)
        logger.info(f"[标题校验成功] 包含：{expected_substring}")
        return True
    except Exception as e:
        logger.error(f"[标题校验失败] 期望：{expected_substring} | 实际：{page.title()} | {e}")
        return False


def assert_element_visible(
    page: Page,
    selector: str,
    timeout: Optional[int] = None,
) -> bool:
    """
    校验元素可见
    """
    try:
        locator = page.locator(selector)
        expect(locator).to_be_visible(timeout=timeout)
        logger.info(f"[元素可见校验成功] {selector}")
        return True
    except Exception as e:
        logger.error(f"[元素可见校验失败] {selector} | {e}")
        return False


def screenshot_on_error(page: Page, screenshot_name: str = "error"):
    """
    上下文管理器：捕获异常后自动截图并重新抛出
    """
    class ScreenshotContext:
        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc_val, exc_tb):
            if exc_val is not None:
                filepath = take_screenshot(page, f"ERROR_{screenshot_name}", full_page=True)
                logger.error(f"[异常截图] {filepath} | {exc_type.__name__} | {exc_val}")
            return False

    return ScreenshotContext()
