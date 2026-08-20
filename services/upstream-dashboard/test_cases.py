"""
软件列表 API 接口自动化测试脚本（pytest + FastAPI TestClient）

测试范围：
    - GET  /software                    获取软件列表
    - GET  /software/levels             返回等级筛选值域
    - POST /software/{id}/manual-evidence    人工录入证据
    - GET  /software/{id}/evidences     获取证据链
    - GET  /software/{id}/collect-sources    获取采集来源
    - POST /software/{id}/collect-sources    新增采集来源
    - PATCH /software/{id}/collect-sources/{source_id} 启用/禁用采集来源

运行方式：
    pytest tests/test_software_api.py -v
    pytest tests/test_software_api.py -v --cov=app.api.v1.software
"""

from __future__ import annotations

import json
import sys
import types
from http import HTTPStatus
from typing import Any
from unittest.mock import MagicMock, patch

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from pydantic import BaseModel, Field

# ═══════════════════════════════════════════════════════════════════════════
#  0) 预注入 app 子模块，避免 software.py 导入时因缺失 app 包而崩溃
#     注意：FastAPI 的 response_model 必须是合法的 Pydantic 模型，
#     因此 app.schemas 中导出的类必须用真正的 BaseModel 子类替代。
# ═══════════════════════════════════════════════════════════════════════════


class _SoftwareListResponse(BaseModel):
    items: list[dict] = []
    total: int = 0
    page: int = 1
    page_size: int = 100


class _CollectSourceItem(BaseModel):
    id: int
    software_id: int
    dimension: str
    source_url: str
    is_enabled: bool
    remark: str = ""


class _AddManualEvidenceRequest(BaseModel):
    version: str | None = None
    support_level: str
    dimension: str
    result: str = "supported"
    excerpt: str | None = None
    source_url: str | None = None


class _AddCollectSourceRequest(BaseModel):
    dimension: str
    source_url: str
    is_enabled: bool = True
    remark: str | None = None


class _SetCollectSourceEnabledRequest(BaseModel):
    is_enabled: bool


# 构造伪模块并注入 sys.modules
_app_schemas = types.ModuleType("app.schemas")
_app_schemas.SoftwareListResponse = _SoftwareListResponse
_app_schemas.CollectSourceItem = _CollectSourceItem
_app_schemas.AddManualEvidenceRequest = _AddManualEvidenceRequest
_app_schemas.AddCollectSourceRequest = _AddCollectSourceRequest
_app_schemas.SetCollectSourceEnabledRequest = _SetCollectSourceEnabledRequest

_app_services_software = types.ModuleType("app.services.software")
_app_services_software.COLLECT_SOURCE_DIMENSIONS = ["ci", "doc", "plugin"]
_app_services_software.MANUAL_DIMENSIONS = ["ci", "doc", "plugin", "release", "binary", "other"]
_app_services_software.RESULT_CATALOG = ["supported", "partial", "not_supported"]
_app_services_software.FILTER_LEVELS = {
    "kunpeng": ["L1", "L2", "L3", "L5"],
    "ascend": ["upstream", "non_upstream", "unsupported"],
}
_app_services_software.software_service = MagicMock()

_app_database = types.ModuleType("app.database")
_app_database.get_dao = MagicMock()

_app = types.ModuleType("app")
_app.schemas = _app_schemas
_app.services = types.ModuleType("app.services")
_app.services.software = _app_services_software
_app.database = _app_database

sys.modules["app"] = _app
sys.modules["app.schemas"] = _app_schemas
sys.modules["app.services"] = _app.services
sys.modules["app.services.software"] = _app_services_software
sys.modules["app.database"] = _app_database

# 被测路由（此时 software.py 的导入环境已完备）
from software import router as software_router


# ────────────────────────────── Fixtures ──────────────────────────────


@pytest.fixture(scope="module")
def app() -> FastAPI:
    """构建包含被测路由的 FastAPI 应用实例。"""
    _app = FastAPI()
    _app.include_router(software_router)
    return _app


@pytest.fixture(scope="module")
def client(app: FastAPI) -> TestClient:
    """提供 TestClient，所有测试共享同一个 client。"""
    return TestClient(app)


@pytest.fixture(autouse=True)
def mock_dependencies():
    """
    自动在每个测试用例前 mock 所有外部依赖，
    避免真实的数据库 / 服务调用。
    """
    with (
        patch("software.software_service") as mock_svc,
        patch("software.get_dao") as mock_dao,
    ):
        # 统一挂载到 yield 返回的 dict 中，方便用例直接取用
        yield {"service": mock_svc, "dao": mock_dao}


# ────────────────────────────── 测试数据构造 ──────────────────────────────


def _make_software_item(software_id: int = 1, name: str = "test-soft") -> dict[str, Any]:
    """构造一条软件列表项的伪数据。"""
    return {
        "id": software_id,
        "name": name,
        "domain": "kunpeng",
        "category": "basic",
        "current_level": "L1",
        "versions": [
            {"version": "1.0.0", "level": "L1", "assessed_at": "2026-08-18T12:00:00"}
        ],
    }


def _make_collect_source(source_id: int = 10, dimension: str = "ci") -> dict[str, Any]:
    """构造一条采集来源的伪数据。"""
    return {
        "id": source_id,
        "software_id": 1,
        "dimension": dimension,
        "source_url": "https://github.com/org/repo/.github/workflows/ci.yml",
        "is_enabled": True,
        "remark": "自动采集",
    }


# ────────────────────────────── GET /software ──────────────────────────────


class TestListSoftware:
    """测试获取软件列表接口。"""

    endpoint = "/software"

    def test_list_software_success(self, client: TestClient, mock_dependencies: dict):
        """正常分页查询，返回软件列表与分页元信息。"""
        mock_svc = mock_dependencies["service"]
        mock_svc.list_software.return_value = (
            [_make_software_item(1, "soft-a"), _make_software_item(2, "soft-b")],
            2,
        )

        resp = client.get(self.endpoint, params={"page": 1, "page_size": 10})

        assert resp.status_code == HTTPStatus.OK
        body = resp.json()
        assert body["total"] == 2
        assert len(body["items"]) == 2
        assert body["page"] == 1
        assert body["page_size"] == 10
        mock_svc.list_software.assert_called_once_with(
            domain=None,
            category=None,
            support_level=None,
            name=None,
            sort_by=None,
            sort_order="asc",
            page=1,
            page_size=10,
        )

    def test_list_software_with_filters(self, client: TestClient, mock_dependencies: dict):
        """携带全部可选筛选项，验证参数透传正确。"""
        mock_svc = mock_dependencies["service"]
        mock_svc.list_software.return_value = ([], 0)

        resp = client.get(
            self.endpoint,
            params={
                "domain": "ascend",
                "category": "native",
                "support_level": "upstream",
                "name": "nginx",
                "sort_by": "level",
                "sort_order": "desc",
                "page": 2,
                "page_size": 50,
            },
        )

        assert resp.status_code == HTTPStatus.OK
        mock_svc.list_software.assert_called_once_with(
            domain="ascend",
            category="native",
            support_level="upstream",
            name="nginx",
            sort_by="level",
            sort_order="desc",
            page=2,
            page_size=50,
        )

    @pytest.mark.parametrize(
        "bad_page_size,expected_detail",
        [
            (0, "Input should be greater than or equal to 1"),
            (501, "Input should be less than or equal to 500"),
            (-1, "Input should be greater than or equal to 1"),
        ],
    )
    def test_list_software_invalid_page_size(
        self, client: TestClient, bad_page_size: int, expected_detail: str
    ):
        """page_size 超出边界时应返回 422 校验错误。"""
        resp = client.get(self.endpoint, params={"page_size": bad_page_size})
        assert resp.status_code == HTTPStatus.UNPROCESSABLE_ENTITY
        # FastAPI/Pydantic v2 的校验错误详情在 detail[].msg
        errors = resp.json().get("detail", [])
        assert any(expected_detail in err.get("msg", "") for err in errors)

    def test_list_software_empty_result(self, client: TestClient, mock_dependencies: dict):
        """查询结果为空时，返回空数组且 total 为 0。"""
        mock_svc = mock_dependencies["service"]
        mock_svc.list_software.return_value = ([], 0)

        resp = client.get(self.endpoint)
        body = resp.json()
        assert body["items"] == []
        assert body["total"] == 0


# ────────────────────────────── GET /software/levels ──────────────────────────────


class TestGetLevels:
    """测试等级筛选值域接口。"""

    endpoint = "/software/levels"

    @patch("software.FILTER_LEVELS", {"kunpeng": ["L1", "L2", "L3", "L5"], "ascend": ["upstream", "non_upstream", "unsupported"]})
    def test_get_levels_success(self, client: TestClient, mock_dependencies: dict):
        """正常返回两域的等级值域。"""
        resp = client.get(self.endpoint)
        assert resp.status_code == HTTPStatus.OK
        body = resp.json()
        assert "domains" in body
        assert "kunpeng" in body["domains"]
        assert "ascend" in body["domains"]


# ────────────────────────────── POST /software/{id}/manual-evidence ──────────────────────────────


class TestAddManualEvidence:
    """测试人工录入证据接口。"""

    endpoint_template = "/software/{software_id}/manual-evidence"

    def _payload(self, **overrides: Any) -> dict[str, Any]:
        defaults = {
            "version": "1.0.0",
            "support_level": "L1",
            "dimension": "ci",
            "result": "supported",
            "excerpt": "在 README 中声明支持鲲鹏",
            "source_url": "https://github.com/org/repo/blob/main/README.md",
        }
        defaults.update(overrides)
        return defaults

    def test_add_manual_evidence_success(self, client: TestClient, mock_dependencies: dict):
        """正常录入人工证据，返回 ok。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_dao.return_value.get_versions_for_software_ids.return_value = {
            1: [{"version": "1.0.0"}, {"version": "2.0.0"}]
        }
        mock_svc.add_manual_evidence.return_value = None

        resp = client.post(self.endpoint_template.format(software_id=1), json=self._payload())
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["ok"] is True
        mock_svc.add_manual_evidence.assert_called_once()

    def test_add_manual_evidence_software_not_found(self, client: TestClient, mock_dependencies: dict):
        """software_id 不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = None

        resp = client.post(self.endpoint_template.format(software_id=9999), json=self._payload())
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "软件不存在" in resp.json()["detail"]

    @pytest.mark.parametrize(
        "field,bad_value,expected_substring",
        [
            ("version", "", "版本不能为空"),
            ("version", "   ", "版本不能为空"),
            ("support_level", "L0", "非法"),
            ("support_level", "L6", "非法"),
            ("dimension", "invalid_dim", "非法"),
            ("result", "invalid_result", "非法"),
        ],
    )
    def test_add_manual_evidence_invalid_field(
        self,
        client: TestClient,
        mock_dependencies: dict,
        field: str,
        bad_value: str,
        expected_substring: str,
    ):
        """各字段非法值场景，应返回 400 并携带对应错误提示。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_dao.return_value.get_versions_for_software_ids.return_value = {
            1: [{"version": "1.0.0"}]
        }

        payload = self._payload(**{field: bad_value})
        resp = client.post(self.endpoint_template.format(software_id=1), json=payload)
        assert resp.status_code == HTTPStatus.BAD_REQUEST
        assert expected_substring in resp.json()["detail"]

    def test_add_manual_evidence_version_not_exist(self, client: TestClient, mock_dependencies: dict):
        """版本不在已有版本列表中时返回 400。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_dao.return_value.get_versions_for_software_ids.return_value = {
            1: [{"version": "2.0.0"}]
        }

        payload = self._payload(version="99.99.99")
        resp = client.post(self.endpoint_template.format(software_id=1), json=payload)
        assert resp.status_code == HTTPStatus.BAD_REQUEST
        assert "不属于该软件已有版本" in resp.json()["detail"]


# ────────────────────────────── GET /software/{id}/evidences ──────────────────────────────


class TestGetEvidences:
    """测试获取证据链接口。"""

    endpoint_template = "/software/{software_id}/evidences"

    def test_get_evidences_success(self, client: TestClient, mock_dependencies: dict):
        """正常获取证据链，返回按版本分组的结构。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.get_evidence_detail.return_value = {
            "1.0.0": [
                {
                    "check_id": "kp.l1.arm_ci",
                    "result": "found",
                    "source_url": "https://github.com/org/repo/actions",
                    "excerpt": "CI passed on ARM",
                }
            ]
        }

        resp = client.get(self.endpoint_template.format(software_id=1))
        assert resp.status_code == HTTPStatus.OK
        body = resp.json()
        assert "versions" in body
        assert "1.0.0" in body["versions"]

    def test_get_evidences_software_not_found(self, client: TestClient, mock_dependencies: dict):
        """software_id 不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = None

        resp = client.get(self.endpoint_template.format(software_id=9999))
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "软件不存在" in resp.json()["detail"]


# ────────────────────────────── GET /software/{id}/collect-sources ──────────────────────────────


class TestListCollectSources:
    """测试获取采集来源接口。"""

    endpoint_template = "/software/{software_id}/collect-sources"

    def test_list_collect_sources_success(self, client: TestClient, mock_dependencies: dict):
        """正常返回采集来源列表。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.list_collect_sources.return_value = [
            _make_collect_source(10, "ci"),
            _make_collect_source(11, "doc"),
        ]

        resp = client.get(self.endpoint_template.format(software_id=1))
        assert resp.status_code == HTTPStatus.OK
        body = resp.json()
        assert len(body) == 2
        assert body[0]["dimension"] == "ci"

    def test_list_collect_sources_software_not_found(self, client: TestClient, mock_dependencies: dict):
        """software_id 不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = None

        resp = client.get(self.endpoint_template.format(software_id=9999))
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "软件不存在" in resp.json()["detail"]


# ────────────────────────────── POST /software/{id}/collect-sources ──────────────────────────────


class TestAddCollectSource:
    """测试新增采集来源接口。"""

    endpoint_template = "/software/{software_id}/collect-sources"

    def _payload(self, **overrides: Any) -> dict[str, Any]:
        defaults = {
            "dimension": "ci",
            "source_url": "https://github.com/org/repo/.github/workflows/build.yml",
            "is_enabled": True,
            "remark": "手工添加",
        }
        defaults.update(overrides)
        return defaults

    def test_add_collect_source_success(self, client: TestClient, mock_dependencies: dict):
        """正常新增采集来源，返回新增对象。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        expected_item = _make_collect_source(20, "ci")
        mock_svc.add_collect_source.return_value = expected_item

        resp = client.post(self.endpoint_template.format(software_id=1), json=self._payload())
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["id"] == 20
        mock_svc.add_collect_source.assert_called_once_with(
            1, "ci", self._payload()["source_url"], True, "手工添加"
        )

    def test_add_collect_source_duplicate(self, client: TestClient, mock_dependencies: dict):
        """相同（软件、维度、地址）已存在时返回 409。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.add_collect_source.return_value = None

        resp = client.post(self.endpoint_template.format(software_id=1), json=self._payload())
        assert resp.status_code == HTTPStatus.CONFLICT
        assert "采集来源已存在" in resp.json()["detail"]

    def test_add_collect_source_software_not_found(self, client: TestClient, mock_dependencies: dict):
        """software_id 不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = None

        resp = client.post(self.endpoint_template.format(software_id=9999), json=self._payload())
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "软件不存在" in resp.json()["detail"]

    @pytest.mark.parametrize(
        "field,bad_value,expected_substring",
        [
            ("dimension", "invalid", "维度"),
            ("source_url", "", "source_url 不能为空"),
            ("source_url", "   ", "source_url 不能为空"),
        ],
    )
    def test_add_collect_source_invalid_field(
        self,
        client: TestClient,
        mock_dependencies: dict,
        field: str,
        bad_value: str,
        expected_substring: str,
    ):
        """维度非法或 source_url 为空时返回 400。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}

        payload = self._payload(**{field: bad_value})
        resp = client.post(self.endpoint_template.format(software_id=1), json=payload)
        assert resp.status_code == HTTPStatus.BAD_REQUEST
        assert expected_substring in resp.json()["detail"]


# ────────────────────────────── PATCH /software/{id}/collect-sources/{source_id} ──────────────────────────────


class TestSetCollectSourceEnabled:
    """测试启用/禁用采集来源接口。"""

    endpoint_template = "/software/{software_id}/collect-sources/{source_id}"

    def test_enable_collect_source(self, client: TestClient, mock_dependencies: dict):
        """正常启用采集来源，返回 ok。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.set_collect_source_enabled.return_value = True

        resp = client.patch(
            self.endpoint_template.format(software_id=1, source_id=10),
            json={"is_enabled": True},
        )
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["ok"] is True
        mock_svc.set_collect_source_enabled.assert_called_once_with(1, 10, True)

    def test_disable_collect_source(self, client: TestClient, mock_dependencies: dict):
        """正常禁用采集来源，返回 ok。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.set_collect_source_enabled.return_value = True

        resp = client.patch(
            self.endpoint_template.format(software_id=1, source_id=10),
            json={"is_enabled": False},
        )
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["ok"] is True
        mock_svc.set_collect_source_enabled.assert_called_once_with(1, 10, False)

    def test_set_collect_source_not_found(self, client: TestClient, mock_dependencies: dict):
        """采集来源不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_svc.set_collect_source_enabled.return_value = False

        resp = client.patch(
            self.endpoint_template.format(software_id=1, source_id=9999),
            json={"is_enabled": False},
        )
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "采集来源不存在" in resp.json()["detail"]

    def test_set_collect_source_software_not_found(self, client: TestClient, mock_dependencies: dict):
        """software_id 不存在时返回 404。"""
        mock_dao = mock_dependencies["dao"]
        mock_dao.return_value.find_by_id.return_value = None

        resp = client.patch(
            self.endpoint_template.format(software_id=9999, source_id=10),
            json={"is_enabled": True},
        )
        assert resp.status_code == HTTPStatus.NOT_FOUND
        assert "软件不存在" in resp.json()["detail"]


# ────────────────────────────── 端到端流水线测试（可选） ──────────────────────────────


class TestSoftwareApiIntegration:
    """
    轻量级端到端场景，验证同一软件下证据与采集来源的联动。
    所有外部依赖仍被 mock，但模拟一次完整业务流程。
    """

    def test_full_flow_for_single_software(self, client: TestClient, mock_dependencies: dict):
        """
        场景：查询软件 → 获取等级值域 → 录入人工证据 → 查看证据 → 新增采集来源 → 禁用来源
        """
        mock_dao = mock_dependencies["dao"]
        mock_svc = mock_dependencies["service"]

        # 前置：软件存在
        mock_dao.return_value.find_by_id.return_value = {"id": 1, "name": "soft-a"}
        mock_dao.return_value.get_versions_for_software_ids.return_value = {
            1: [{"version": "1.0.0"}]
        }
        mock_svc.list_software.return_value = ([_make_software_item(1, "soft-a")], 1)
        mock_svc.get_evidence_detail.return_value = {"1.0.0": []}
        mock_svc.add_manual_evidence.return_value = None
        mock_svc.add_collect_source.return_value = _make_collect_source(30, "ci")
        mock_svc.set_collect_source_enabled.return_value = True
        mock_svc.list_collect_sources.return_value = [_make_collect_source(30, "ci")]

        # 1. 查询软件列表
        resp = client.get("/software")
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["items"][0]["name"] == "soft-a"

        # 2. 获取等级值域
        with patch("software.FILTER_LEVELS", {"kunpeng": ["L1", "L2", "L3", "L5"]}):
            resp = client.get("/software/levels")
            assert resp.status_code == HTTPStatus.OK

        # 3. 录入人工证据
        resp = client.post(
            "/software/1/manual-evidence",
            json={
                "version": "1.0.0",
                "support_level": "L2",
                "dimension": "ci",
                "result": "supported",
                "excerpt": "新增支持",
                "source_url": "https://example.com/evidence",
            },
        )
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["ok"] is True

        # 4. 查看证据链
        resp = client.get("/software/1/evidences")
        assert resp.status_code == HTTPStatus.OK
        assert "versions" in resp.json()

        # 5. 新增采集来源
        resp = client.post(
            "/software/1/collect-sources",
            json={
                "dimension": "ci",
                "source_url": "https://github.com/org/repo/.github/workflows/ci.yml",
                "is_enabled": True,
                "remark": "",
            },
        )
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["id"] == 30

        # 6. 禁用采集来源
        resp = client.patch("/software/1/collect-sources/30", json={"is_enabled": False})
        assert resp.status_code == HTTPStatus.OK
        assert resp.json()["ok"] is True

        # 验证交互次数
        assert mock_svc.add_manual_evidence.call_count == 1
        assert mock_svc.add_collect_source.call_count == 1
        assert mock_svc.set_collect_source_enabled.call_count == 1
