"""
pytest 共享 fixtures 与命令行选项

注意:
- --base-url 由 pytest-base-url 插件提供
- --timeout  由 pytest-timeout 插件提供
这里只注册本项目独有的选项，避免重复注册冲突。
"""
import os
import sys

import pytest

# 将项目根目录加入路径，确保同目录下的 utils 可被导入
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

DEFAULT_BASE_URL = "https://datastat2.test.osinfra.cn/server"


def pytest_addoption(parser):
    """注册本项目独有的命令行选项"""
    parser.addoption("--auth-token", default="", help="认证 Token")
    parser.addoption("--module", default="", help="指定测试模块")
    parser.addoption("--api-root", default="api", help="API 定义根目录")


def pytest_configure(config):
    """注册自定义 marker，消除 unknown mark 警告"""
    config.addinivalue_line("markers", "positive: 正向测试用例")
    config.addinivalue_line("markers", "negative: 反向测试用例")


@pytest.fixture(scope="session")
def base_url(request):
    """获取 API 基础地址（覆盖 pytest-base-url 的默认 None）"""
    return request.config.getoption("base_url") or DEFAULT_BASE_URL
