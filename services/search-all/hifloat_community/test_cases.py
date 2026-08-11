# -*- coding: utf-8 -*-
"""
API-common 接口自动化测试用例 - hifloat 社区
根据 API-common.md 端点 x 社区支持矩阵生成
"""
import json
import pytest

from request_client import RequestClient
from assertions import (
    AssertionGroup,
    assert_http_status,
    assert_business_status,
    assert_field_exists,
    assert_field_type,
    assert_not_none,
    assert_list_not_empty,
)
from logger import get_logger

logger = get_logger(__name__)

def _load_test_data() -> dict:
    """统一加载测试数据"""
    with open("test_data.json", "r", encoding="utf-8") as f:
        return json.load(f)

class TestSearchDocs:
    """POST /search/docs - 文档检索"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("docs", {}).get("positive_cases", []))
    def test_docs_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/docs", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_field_exists(resp.json_data or {}, "obj", group)
        assert_not_none(resp.data, name="data/obj", group=group)
        if resp.business_status == 200 and isinstance(resp.data, dict):
            assert_field_exists(resp.data, "records", group)
            if "records" in resp.data:
                assert_field_type(resp.data["records"], list, "records", group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchCount:
    """POST /search/count - 结果数量统计"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("count", {}).get("positive_cases", []))
    def test_count_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/count", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_not_none(resp.data, name="count_data", group=group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchTags:
    """POST /search/tags - 文档标签聚合"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("tags", {}).get("positive_cases", []))
    def test_tags_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/tags", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_not_none(resp.data, name="tags_data", group=group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchSugg:
    """POST /search/sugg - 搜索建议词"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("sugg", {}).get("positive_cases", []))
    def test_sugg_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/sugg", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_not_none(resp.data, name="sugg_data", group=group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchPop:
    """POST /search/pop - 热门搜索词（query 参数）"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("pop", {}).get("positive_cases", []))
    def test_pop_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/pop", params=case.get("params"))
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        if resp.business_status == 200:
            assert_field_type(resp.data, list, "pop_list", group)
            if isinstance(resp.data, list):
                assert_list_not_empty(resp.data, "pop_list", group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchSortType:
    """POST /search/sort/{type} - 按分类高级搜索"""

    @pytest.mark.parametrize("case", _load_test_data().get("sort", {}).get("sort_type", {}).get("positive_cases", []))
    def test_sort_type_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        path = f"/search/sort/{case['path_type']}"
        resp = client.post(path, json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_not_none(resp.data, name="sort_data", group=group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestSearchSortDocs:
    """POST /search/sort/docs - 分类文档搜索"""

    @pytest.mark.parametrize("case", _load_test_data().get("sort", {}).get("sort_docs", {}).get("positive_cases", []))
    def test_sort_docs_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/sort/docs", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        assert_not_none(resp.data, name="sort_docs_data", group=group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestJumperSigName:
    """GET /search/sig/name - SIG 名称列表"""

class TestJumperSigReadme:
    """GET /search/sig/readme - SIG README"""

    def test_sig_readme_missing_sig(self, client: RequestClient):
        case_id = "JUMPER-SIG-README-101"
        logger.info(f"[{case_id}] 开始执行: 缺少 sig 参数")
        group = AssertionGroup(case_id=case_id)
        resp = client.get("/search/sig/readme", params={"lang": "zh"})
        assert_http_status(resp.http_status, 200, group)
        if resp.business_status is not None:
            assert resp.business_status in (200, 201, 400), f"异常状态码: {resp.business_status}"
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestJumperAll:
    """GET /search/all - 全部数据概览"""

class TestJumperStars:
    """GET /search/stars - 星标统计"""

class TestJumperEcosystemRepoInfo:
    """GET /search/ecosystem/repo/info - 生态仓库信息"""

    @pytest.mark.parametrize("case", _load_test_data().get("jumper", {}).get("ecosystem_repo_info", {}).get("positive_cases", []))
    def test_ecosystem_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.get("/search/ecosystem/repo/info", params=case.get("params"))
        assert_http_status(resp.http_status, case.get("expected_http_status", 200), group)
        if resp.http_status == 200:
            assert resp.text, "响应体为空"
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

    def test_ecosystem_missing_type(self, client: RequestClient):
        case_id = "JUMPER-ECO-101"
        logger.info(f"[{case_id}] 开始执行: 缺少 ecosystem_type")
        group = AssertionGroup(case_id=case_id)
        resp = client.get("/search/ecosystem/repo/info", params={"lang": "zh"})
        assert_http_status(resp.http_status, 200, group)
        if resp.business_status is not None:
            assert resp.business_status in (200, 201, 400), f"异常状态码: {resp.business_status}"
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

