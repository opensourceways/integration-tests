# -*- coding: utf-8 -*-
"""
测试用例脚本：oss-map（范式 A · REST 只读集成测试）

被测对象：OSS 全景地图测试环境
默认 Base URL：https://oss-map.test.osinfra.cn
用例定位：简单、安全——只读 GET + 鉴权负向；不写库、不触发采集

依赖：
    pip install -r requirements.txt

执行：
    pytest -v test_cases.py
    bash run_all.sh

环境变量（可选）：
    OSS_MAP_BASE_URL           覆盖被测根地址（默认 https://oss-map.test.osinfra.cn）
    OSS_MAP_TEST_ACCOUNT       可选；与 PASSWORD 同时设置时跑正向登录
    OSS_MAP_TEST_PASSWORD      可选；切勿把真实密码写进仓库

安全边界：
    - 禁止 POST/PUT/DELETE 业务写接口（登录负向与可选登录除外）
    - 禁止调用 MCP 写工具、Issue 刷新、人员合并、Token 池写入等
"""

from __future__ import annotations

import os
from typing import Any

import pytest
import requests

try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:
    pass

BASE_URL = os.environ.get("OSS_MAP_BASE_URL", "https://oss-map.test.osinfra.cn").rstrip("/")
API = f"{BASE_URL}/api/v1"
TIMEOUT = 30

TEST_ACCOUNT = os.environ.get("OSS_MAP_TEST_ACCOUNT", "").strip()
TEST_PASSWORD = os.environ.get("OSS_MAP_TEST_PASSWORD", "").strip()


# ===== fixtures =====


@pytest.fixture(scope="session")
def http() -> requests.Session:
    session = requests.Session()
    session.headers.update({"Accept": "application/json"})
    yield session
    session.close()


def _get(http: requests.Session, path: str, **kwargs: Any) -> requests.Response:
    url = path if path.startswith("http") else f"{API}{path}"
    return http.get(url, timeout=TIMEOUT, **kwargs)


def _assert_json_object(resp: requests.Response, name: str) -> dict[str, Any]:
    assert resp.status_code == 200, f"[{name}] 期望 200，实际 {resp.status_code}：{resp.text[:300]}"
    try:
        body = resp.json()
    except ValueError:
        pytest.fail(f"[{name}] 响应不是 JSON：{resp.text[:300]}")
    assert isinstance(body, dict), f"[{name}] 期望 JSON object，实际 {type(body)}"
    return body


# ===== 健康与前端入口 =====


class TestHealth:
    def test_health_ok(self, http: requests.Session) -> None:
        """[正常流] GET /api/v1/health 返回 status=ok"""
        resp = _get(http, "/health")
        body = _assert_json_object(resp, "health")
        assert body.get("status") == "ok", f"health.status 异常：{body}"

    def test_health_idempotent(self, http: requests.Session) -> None:
        """[重复] 连续两次 health 均成功且 status 一致"""
        r1 = _get(http, "/health")
        r2 = _get(http, "/health")
        assert r1.status_code == r2.status_code == 200
        assert r1.json().get("status") == r2.json().get("status") == "ok"

    def test_frontend_index_html(self, http: requests.Session) -> None:
        """[正常流] 站点根路径返回前端 HTML（非 API JSON）"""
        resp = http.get(f"{BASE_URL}/", timeout=TIMEOUT)
        assert resp.status_code == 200, f"首页状态码异常：{resp.status_code}"
        ctype = (resp.headers.get("Content-Type") or "").lower()
        assert "text/html" in ctype or "<html" in resp.text.lower(), (
            f"首页应返回 HTML，Content-Type={ctype!r}"
        )


# ===== 项目只读 =====


class TestProjectsRead:
    def test_list_projects_shape(self, http: requests.Session) -> None:
        """[正常流] 项目列表分页结构合法且有数据"""
        resp = _get(http, "/projects", params={"page": 1, "page_size": 5})
        body = _assert_json_object(resp, "list_projects")
        for key in ("items", "total", "page", "page_size"):
            assert key in body, f"列表缺少字段 {key}：{body.keys()}"
        assert isinstance(body["items"], list)
        assert body["total"] >= 1, "测试环境应至少有 1 个项目"
        assert body["page"] == 1
        assert body["page_size"] == 5
        assert len(body["items"]) >= 1
        first = body["items"][0]
        for key in ("id", "name"):
            assert key in first, f"列表项缺少 {key}"

    def test_list_projects_pagination_bounds(self, http: requests.Session) -> None:
        """[边界值] page_size=1 时最多返回 1 条"""
        resp = _get(http, "/projects", params={"page": 1, "page_size": 1})
        body = _assert_json_object(resp, "list_page_size_1")
        assert len(body["items"]) <= 1
        assert body["page_size"] == 1

    def test_search_projects_by_q(self, http: requests.Session) -> None:
        """[正常流] q=vllm 搜索返回合法分页结构"""
        resp = _get(http, "/projects", params={"q": "vllm", "page": 1, "page_size": 10})
        body = _assert_json_object(resp, "search_projects")
        assert isinstance(body["items"], list)
        assert isinstance(body["total"], int)
        assert body["total"] >= 0

    def test_get_project_detail(self, http: requests.Session) -> None:
        """[正常流] 用列表首条 id 拉详情，id/name 一致"""
        listing = _assert_json_object(
            _get(http, "/projects", params={"page": 1, "page_size": 1}),
            "list_for_detail",
        )
        project_id = listing["items"][0]["id"]
        name = listing["items"][0]["name"]

        resp = _get(http, f"/projects/{project_id}")
        body = _assert_json_object(resp, "project_detail")
        assert body.get("id") == project_id
        assert body.get("name") == name

    def test_get_project_not_found(self, http: requests.Session) -> None:
        """[异常] 不存在的 project_id 返回 404"""
        resp = _get(http, "/projects/999999999")
        assert resp.status_code == 404, f"期望 404，实际 {resp.status_code}：{resp.text[:200]}"

    def test_project_meta_options(self, http: requests.Session) -> None:
        """[正常流] category-options / license-options / category-values 可读"""
        for path in (
            "/projects/category-options",
            "/projects/license-options",
            "/projects/category-values",
        ):
            resp = _get(http, path)
            assert resp.status_code == 200, f"{path} 期望 200，实际 {resp.status_code}"
            data = resp.json()
            assert isinstance(data, list), f"{path} 期望数组"
            assert len(data) >= 1, f"{path} 不应为空"

    def test_project_maintainers_and_orgs_readable(self, http: requests.Session) -> None:
        """[正常流] 项目 maintainers / orgs 子资源可读（结构宽松断言）"""
        listing = _assert_json_object(
            _get(http, "/projects", params={"page": 1, "page_size": 1}),
            "list_for_subs",
        )
        project_id = listing["items"][0]["id"]

        for path in (f"/projects/{project_id}/maintainers", f"/projects/{project_id}/orgs"):
            resp = _get(http, path)
            assert resp.status_code == 200, f"{path} 期望 200，实际 {resp.status_code}"
            body = resp.json()
            assert isinstance(body, dict) and "items" in body, f"{path} 期望含 items：{body}"


# ===== 搜索 / 组织 =====


class TestSearchAndOrgs:
    def test_global_search(self, http: requests.Session) -> None:
        """[正常流] GET /search?q=vllm 返回 projects/people/organizations"""
        resp = _get(http, "/search", params={"q": "vllm"})
        body = _assert_json_object(resp, "global_search")
        for key in ("projects", "people", "organizations"):
            assert key in body, f"search 缺少 {key}"
            assert isinstance(body[key], list), f"search.{key} 应为数组"

    def test_list_orgs(self, http: requests.Session) -> None:
        """[正常流] GET /orgs 返回组织简表"""
        resp = _get(http, "/orgs")
        assert resp.status_code == 200, f"orgs 期望 200，实际 {resp.status_code}"
        data = resp.json()
        assert isinstance(data, list)
        assert len(data) >= 1, "测试环境应至少有组织数据"
        assert "id" in data[0] and "name" in data[0]


# ===== 鉴权负向（安全、不改数据）=====


class TestAuthNegative:
    def test_me_without_token(self, http: requests.Session) -> None:
        """[权限] 无 Token 访问 /me → 401"""
        resp = _get(http, "/me")
        assert resp.status_code == 401, f"期望 401，实际 {resp.status_code}：{resp.text[:200]}"

    def test_login_wrong_password(self, http: requests.Session) -> None:
        """[权限][异常] 错误账号密码登录 → 401"""
        resp = http.post(
            f"{API}/login",
            data={
                "username": "ossmap_it_nonexistent_user",
                "password": "definitely-wrong-password",
            },
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=TIMEOUT,
        )
        assert resp.status_code == 401, f"期望 401，实际 {resp.status_code}：{resp.text[:200]}"

    def test_export_without_token(self, http: requests.Session) -> None:
        """[权限] 未登录访问项目导出 → 401（不下载、不落盘）"""
        resp = _get(http, "/projects/export")
        assert resp.status_code == 401, f"期望 401，实际 {resp.status_code}：{resp.text[:200]}"


# ===== 可选：环境变量提供测试账号时的正向登录 =====


@pytest.mark.skipif(
    not (TEST_ACCOUNT and TEST_PASSWORD),
    reason="未设置 OSS_MAP_TEST_ACCOUNT / OSS_MAP_TEST_PASSWORD，跳过正向登录",
)
class TestAuthOptionalPositive:
    def test_login_and_me(self, http: requests.Session) -> None:
        """[正常流] 合法账号登录拿 JWT，再调 /me"""
        login = http.post(
            f"{API}/login",
            data={"username": TEST_ACCOUNT, "password": TEST_PASSWORD},
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=TIMEOUT,
        )
        assert login.status_code == 200, f"登录失败：{login.status_code} {login.text[:300]}"
        token_body = login.json()
        token = token_body.get("access_token")
        assert token and isinstance(token, str), f"缺少 access_token：{token_body}"

        me = http.get(
            f"{API}/me",
            headers={"Authorization": f"Bearer {token}"},
            timeout=TIMEOUT,
        )
        assert me.status_code == 200, f"/me 失败：{me.status_code} {me.text[:300]}"
        profile = me.json()
        assert profile.get("username") == TEST_ACCOUNT


# ===== 用例索引（人类可贴禅道/Tapd）=====
#
# | 用例 ID | 标题 | 优先级 | 来源 |
# |---------|------|--------|------|
# | test_health_ok | health status=ok | P0 | 首版 |
# | test_health_idempotent | health 幂等 | P1 | 首版 |
# | test_frontend_index_html | 首页 HTML | P1 | 首版 |
# | test_list_projects_shape | 项目列表结构 | P0 | 首版 |
# | test_list_projects_pagination_bounds | page_size 边界 | P1 | 首版 |
# | test_search_projects_by_q | 项目 q 搜索 | P0 | 首版 |
# | test_get_project_detail | 项目详情 | P0 | 首版 |
# | test_get_project_not_found | 详情 404 | P1 | 首版 |
# | test_project_meta_options | 分类/协议选项 | P1 | 首版 |
# | test_project_maintainers_and_orgs_readable | 子资源可读 | P1 | 首版 |
# | test_global_search | 全局搜索 | P0 | 首版 |
# | test_list_orgs | 组织列表 | P1 | 首版 |
# | test_me_without_token | /me 401 | P0 | 首版 |
# | test_login_wrong_password | 错误登录 401 | P0 | 首版 |
# | test_export_without_token | 导出 401 | P1 | 首版 |
# | test_login_and_me | 可选正向登录 | P1 | 首版（需 env） |
