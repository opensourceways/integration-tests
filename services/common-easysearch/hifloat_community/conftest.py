# -*- coding: utf-8 -*-
"""
Pytest 全局配置与共享 Fixture
"""
import time
import pytest

from request_client import RequestClient
from logger import get_logger
import settings

logger = get_logger(__name__)


@pytest.fixture(scope="session")
def client():
    """
    全局唯一的 RequestClient session fixture
    所有测试用例共享同一个连接池
    """
    c = RequestClient()
    yield c
    c.close()
    logger.info("[Fixture] RequestClient session closed")


@pytest.fixture(autouse=True)
def case_interval():
    """
    每条用例执行后自动等待，避免触发限流
    """
    yield
    if settings.CASE_INTERVAL > 0:
        time.sleep(settings.CASE_INTERVAL)


@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    """
    自定义测试报告钩子，用例失败时额外记录 ERROR 日志
    """
    outcome = yield
    report = outcome.get_result()

    if report.when == "call" and report.failed:
        logger.error(
            f"[用例失败] {item.nodeid} | "
            f"原因: {report.longreprtext[:500] if report.longreprtext else '未知'}"
        )


def pytest_collection_modifyitems(config, items):
    """
    测试收集完成后，按用例名称排序，保证执行顺序稳定
    """
    items.sort(key=lambda x: x.nodeid)
