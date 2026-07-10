# conftest.py
# pytest 核心配置：浏览器生命周期管理、日志集成

import sys
from pathlib import Path

# 将项目根目录加入 sys.path，确保能导入 config / utils
PROJECT_ROOT = Path(__file__).parent.resolve()
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

import pytest
from playwright.sync_api import sync_playwright
from frontend.openeuler.home import config
from frontend.openeuler.home.utils import logger


# ==================== Session 级别：浏览器实例 ====================
@pytest.fixture(scope="session")
def browser():
    """
    Session 级别 fixture：整个测试会话共享一个浏览器进程
    所有测试用例（无论模块）共用此浏览器实例
    """
    logger.info(f"🚀 启动浏览器 [{config.BROWSER_TYPE}] headless={config.HEADLESS}")
    p = sync_playwright().start()
    browser_type = getattr(p, config.BROWSER_TYPE)
    browser = browser_type.launch(headless=config.HEADLESS)
    yield browser
    logger.info("🛑 关闭浏览器")
    browser.close()
    p.stop()


# ==================== Module 级别：共享页面（首页浏览）====================
@pytest.fixture(scope="module")
def module_page(browser):
    """
    Module 级别 fixture：同一模块内的测试共享一个页面上下文
    适用于首页浏览校验（无需重复 goto），提升执行效率
    """
    context = browser.new_context(viewport=config.VIEWPORT, locale="zh-CN")
    page = context.new_page()
    page.set_default_timeout(config.DEFAULT_TIMEOUT)
    page.set_default_navigation_timeout(config.NAVIGATION_TIMEOUT)
    page.goto(config.BASE_URL, wait_until="networkidle")
    yield page
    context.close()


# ==================== Function 级别：独立页面（隔离用例）====================
@pytest.fixture(scope="function")
def page(browser):
    """
    Function 级别 fixture：每个测试函数独享新页面
    适用于异常场景测试（超时、404、元素缺失等），保证用例隔离
    """
    context = browser.new_context(viewport=config.VIEWPORT, locale="zh-CN")
    page = context.new_page()
    page.set_default_timeout(config.DEFAULT_TIMEOUT)
    page.set_default_navigation_timeout(config.NAVIGATION_TIMEOUT)
    yield page
    context.close()


@pytest.fixture(scope="function")
def op(page):
    """基于 page 的 PageOperator 工具实例"""
    return PageOperator(page)


# ==================== pytest 配置钩子 ====================
def pytest_configure(config):
    """在 pytest 启动时配置日志"""
    logger.info("📦 pytest 测试会话启动")


def pytest_sessionfinish(session, exitstatus):
    """在 pytest 结束时打印汇总信息"""
    logger.info(f"🏁 pytest 会话结束，退出码: {exitstatus}")
