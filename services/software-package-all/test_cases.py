# -*- coding: utf-8 -*-
"""
API 测试脚本：easysoftware 软件包仓（由 easysoftware.jmx 转化）

被测对象：easysoftware API 查询服务
测试框架：pytest + requests
环境：https://easysoftware.openeuler.org（JMeter 用户变量 ${url}）

对应 JMeter 线程组「es-api-query」（1 线程 / 1 循环 / 出错继续），
线程组内所有 HeaderManager 均为禁用状态，故本脚本不附加自定义请求头。

转化说明：
    1. JMX 中路径前缀为 /api-query（原测试环境前端 dev-proxy 路径），
       现网实际 API 前缀为 /server（已实测验证），可通过环境变量覆盖。
    2. JMX 中「field?name=rpmpkg」重复出现两次且参数一致，合并为一条用例。
    3. JMX 中「apppkg」详情接口现网已不可用（服务端变更），用例未保留；
       禁用的线程组「线程组」及 gitcode 调试请求（含明文 access_token）亦未转化。

配置（.env 或环境变量）：
    EASYSOFTWARE_BASE_URL=https://easysoftware.openeuler.org
    EASYSOFTWARE_API_PREFIX=/server

执行：
    pip install pytest requests python-dotenv
    pytest -v test_cases.py
"""

import os

import pytest
import requests

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# JMX 用户变量 ${url}=easysoftware.test.osinfra.cn（测试环境）。
# 注意：JMX 中的 /api-query 前缀是录制时 dev-server 的代理路径，部署后不存在
# （命中 SPA 回退返回 HTML）；该域名上实际 API 前缀为 /server（已实测验证）。
BASE_URL = os.environ.get(
    "EASYSOFTWARE_BASE_URL",
    "https://easysoftware.test.osinfra.cn",
).rstrip("/")

# JMX 中记录为 /api-query（测试环境 dev-proxy 路径），实际 API 前缀为 /server
API_PREFIX = os.environ.get("EASYSOFTWARE_API_PREFIX", "/server").rstrip("/")

TIMEOUT = 30


# ===== Fixture =====

@pytest.fixture(scope="session")
def session():
    """对应 JMeter 的 use_keepalive=true：同一会话复用连接"""
    s = requests.Session()
    yield s
    s.close()


def _assert_ok(resp: requests.Response, name: str):
    """公共断言：HTTP 200、响应为 JSON 且业务码 code == 200"""
    assert resp.status_code == 200, \
        f"[{name}] 状态码应为 200，实际: {resp.status_code}，响应: {resp.text[:200]}"
    try:
        body = resp.json()
    except ValueError:
        pytest.fail(f"[{name}] 响应应为 JSON，实际: {resp.text[:200]}")
    code = body.get("code")
    assert code == 200, \
        f"[{name}] 业务码应为 200，实际: {code}，响应: {resp.text[:200]}"


# ===== 线程组 es-api-query：应用包（apppkg）=====

class TestAppPkg:

    def test_apppkg_eulerver(self, session):
        """对应 JMeter「apppkg/eulerver」：GET /apppkg/eulerver?name=mysql"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/apppkg/eulerver",
            params={"name": "mysql"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "apppkg/eulerver")

    def test_apppkg_tags(self, session):
        """对应 JMeter「apppkg/tags」：GET /apppkg/tags?name=zooKeeper"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/apppkg/tags",
            params={"name": "zooKeeper"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "apppkg/tags")


# ===== 线程组 es-api-query：应用版本（appVersion）=====

class TestAppVersion:

    def test_appversion_list(self, session):
        """对应 JMeter「appVersion」：GET /appVersion?pageNum=1&pageSize=10&nameOrder=asc"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/appVersion",
            params={"pageNum": 1, "pageSize": 10, "nameOrder": "asc"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "appVersion")

    def test_appversion_column(self, session):
        """对应 JMeter「appVersion/column」：GET /appVersion/column?column=eulerOsVersion"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/appVersion/column",
            params={"column": "eulerOsVersion"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "appVersion/column")


# ===== 线程组 es-api-query：epkg 包（epkgpkg）=====

class TestEpkgPkg:

    def test_epkgpkg_detail(self, session):
        """对应 JMeter「epkgpkg」：GET /epkgpkg?pkgId=..."""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/epkgpkg",
            params={"pkgId": "openEuler-22.03-LTS-SP1389-ds-base-debuginfo1.4.3.36-3aarch64"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "epkgpkg")

    def test_epkgpkg_eulerver(self, session):
        """对应 JMeter「epkgpkg/eulerver」：GET /epkgpkg/eulerver?name=389-ds-base-debuginfo"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/epkgpkg/eulerver",
            params={"name": "389-ds-base-debuginfo"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "epkgpkg/eulerver")


# ===== 线程组 es-api-query：rpm 包（rpmpkg）=====

class TestRpmPkg:

    def test_rpmpkg_detail(self, session):
        """对应 JMeter「rpmpkg」：GET /rpmpkg?pkgId=..."""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/rpmpkg",
            params={"pkgId": "openEuler-20.03-LTS-SP1debuginfoaarch64acl-debuginfo2.2.53-8.oe1aarch64"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "rpmpkg")

    def test_rpmpkg_eulerver(self, session):
        """对应 JMeter「rpmpkg/eulerver」：GET /rpmpkg/eulerver?name=acl-debuginfo"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/rpmpkg/eulerver",
            params={"name": "acl-debuginfo"},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "rpmpkg/eulerver")


# ===== 线程组 es-api-query：字段查询（field）=====

class TestField:

    def test_field_rpmpkg(self, session):
        """对应 JMeter「field?name=rpmpkg」：GET /field?name=rpmpkg&pageNum=1&pageSize=10
        （JMX 中该请求出现两次且参数完全一致，此处合并为一条用例）"""
        resp = session.get(
            f"{BASE_URL}{API_PREFIX}/field",
            params={"name": "rpmpkg", "pageNum": 1, "pageSize": 10},
            timeout=TIMEOUT,
        )
        _assert_ok(resp, "field?name=rpmpkg")
