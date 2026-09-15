"""
pytest 共享 fixtures 与命令行选项

注意:
- --base-url 由 pytest-base-url 插件提供
- --timeout  由 pytest-timeout 插件提供
这里只注册本项目独有的选项，避免重复注册冲突。
"""
import pytest

DEFAULT_BASE_URL = "https://datastat2.test.osinfra.cn/server"


def pytest_addoption(parser):
    """注册本项目独有的命令行选项"""
    parser.addoption("--auth-token", default="", help="认证 Token")
    parser.addoption("--module", default="", help="指定测试模块（如 datastat, TTFHW）")
    parser.addoption("--run-unauthorized", action="store_true",
                     help="强制执行需鉴权的用例（默认在未提供凭证时跳过）")


def pytest_configure(config):
    """注册自定义 marker，消除 unknown mark 警告"""
    config.addinivalue_line("markers", "positive: 正向测试用例")
    config.addinivalue_line("markers", "negative: 反向测试用例")


@pytest.fixture(scope="session")
def base_url(request):
    """获取 API 基础地址（覆盖 pytest-base-url 的默认 None）"""
    return request.config.getoption("base_url") or DEFAULT_BASE_URL
