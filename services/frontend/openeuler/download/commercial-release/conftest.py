"""
conftest.py
pytest 共享 fixture 定义文件。

作用域说明：
  - scope="function"：每个 test_ 函数执行前后都会重新创建和销毁，
    确保每个用例的浏览器状态完全独立，避免筛选条件、新标签页等状态污染。
"""

import pytest
import logging
import sys
from browser_utils import BrowserManager
from page_utils import PageUtils
from global_config import TARGET_URL, EXPECTED_TITLE_KEYWORDS

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)


@pytest.fixture(scope="function")
def browser_manager():
    """
    fixture：提供 BrowserManager 实例。
    yield 前启动，yield 后自动关闭（四级安全关闭）。
    """
    bm = BrowserManager(headless=False)
    yield bm
    bm.close()


@pytest.fixture(scope="function")
def page(browser_manager):
    """
    fixture：提供已加载目标页面的 Playwright Page 对象。
    每个用例独立启动浏览器、访问页面、校验标题。
    """
    p = browser_manager.start()
    browser_manager.goto(TARGET_URL, wait_until="domcontentloaded")
    # 额外等待网络请求稳定（使用 page.wait_for_load_state 替代 networkidle，更宽松）
    try:
        p.wait_for_load_state("networkidle", timeout=15000)
    except Exception:
        pass  # 网络idle非强制，domcontentloaded已确保页面结构就绪
    # 基础断言：页面标题校验
    title = p.title()
    logger.info("[Fixture] 页面加载完成，标题: %s", title)
    assert any(kw in title for kw in EXPECTED_TITLE_KEYWORDS), \
        f"页面标题断言失败: {title}"
    yield p
    # page 在 browser_manager.close() 中会被关闭，无需单独处理


@pytest.fixture(scope="function")
def utils(page):
    """
    fixture：提供基于当前 Page 的 PageUtils 工具实例。
    """
    return PageUtils(page)


# ==================== pytest hook：测试失败时自动截图 ====================
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    """
    pytest hook：当测试用例失败时，自动截取页面截图。
    截图文件名格式：FAIL_{test函数名}.png
    """
    outcome = yield
    report = outcome.get_result()
    if report.when == "call" and report.failed:
        page = item.funcargs.get("page")
        if page:
            try:
                u = PageUtils(page)
                u.take_screenshot(name=f"FAIL_{item.name}")
                logger.error("[pytest hook] 用例 %s 失败，已自动截图。", item.name)
            except Exception as e:
                logger.error("[pytest hook] 截图失败: %s", e)
