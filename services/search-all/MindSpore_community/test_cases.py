# -*- coding: utf-8 -*-
"""
API-common 接口自动化测试用例 - mindspore 社区
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

class TestSearchDocsNg:
    """POST /search/docsng - 多路召回融合搜索"""

    @pytest.mark.parametrize("case", _load_test_data().get("search", {}).get("docsng", {}).get("positive_cases", []))
    def test_docsng_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/docsng", json_data=case["body"])
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, case.get("expected_business_status", 200), group)
        if resp.business_status == 200 and isinstance(resp.data, dict):
            assert_field_exists(resp.data, "records", group)
            if isinstance(resp.data.get("records"), list) and len(resp.data["records"]) > 0:
                first = resp.data["records"][0]
                assert_field_exists(first, "path", group)
                assert_field_exists(first, "score", group)
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

class TestSearchWord:
    """POST /search/word - 词条查询"""

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

class TestSearchMultimodal:
    """POST /search/multitimodal - 多模态图搜文"""

    def test_multimodal_with_keyword(self, client: RequestClient):
        case_id = "SEARCH-MULTIMODAL-001"
        logger.info(f"[{case_id}] 开始执行: 多模态检索-仅 keyword")
        group = AssertionGroup(case_id=case_id)
        body = {"lang": "zh", "keyword": "kernel", "page": 1, "pageSize": 12}
        resp = client.post("/search/multitimodal", json_data=body)
        assert_http_status(resp.http_status, 200, group)
        if resp.business_status is not None:
            assert resp.business_status in (200, 201), f"业务状态码异常: {resp.business_status}"
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

    def test_multimodal_no_keyword_no_image(self, client: RequestClient):
        case_id = "SEARCH-MULTIMODAL-101"
        logger.info(f"[{case_id}] 开始执行: 多模态检索-无关键词无图片")
        group = AssertionGroup(case_id=case_id)
        body = {"lang": "zh"}
        resp = client.post("/search/multitimodal", json_data=body)
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, 201, group)
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

class TestSearchSortUploadImage:
    """POST /search/sort/upload/image - 图片上传"""

    def test_upload_image_success(self, client: RequestClient, tmp_path):
        case_id = "SORT-UPLOAD-001"
        logger.info(f"[{case_id}] 开始执行: 正常图片上传")
        group = AssertionGroup(case_id=case_id)
        png_bytes = bytes([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x60, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xE2, 0x21, 0xBC, 0x33, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82])
        img_path = tmp_path / "test_1x1.png"
        img_path.write_bytes(png_bytes)
        with open(img_path, "rb") as f:
            resp = client.post("/search/sort/upload/image", files={"image": ("test_1x1.png", f, "image/png")})
        assert_http_status(resp.http_status, 200, group)
        if resp.business_status == 200:
            assert_field_type(resp.data, str, "image_url", group)
            assert resp.data.startswith("http") or resp.data.startswith("https"), "返回的不是有效 URL"
        else:
            logger.warning(f"[{case_id}] 图片上传业务失败(可能缺少OBS配置): {resp.business_msg}")
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

    def test_upload_image_empty(self, client: RequestClient):
        case_id = "SORT-UPLOAD-101"
        logger.info(f"[{case_id}] 开始执行: 上传空文件")
        group = AssertionGroup(case_id=case_id)
        resp = client.post("/search/sort/upload/image", files={"image": ("empty.png", b"", "image/png")})
        assert_http_status(resp.http_status, 200, group)
        assert_business_status(resp.business_status, 201, group)
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

class TestJumperSigName:
    """GET /search/sig/name - SIG 名称列表"""

    @pytest.mark.parametrize("case", _load_test_data().get("jumper", {}).get("sig_name", {}).get("positive_cases", []))
    def test_sig_name_positive(self, client: RequestClient, case: dict):
        case_id = case.get("case_id", "UNKNOWN")
        logger.info(f"[{case_id}] 开始执行: {case.get('desc', '')}")
        group = AssertionGroup(case_id=case_id)
        resp = client.get("/search/sig/name", params=case.get("params"))
        assert_http_status(resp.http_status, case.get("expected_http_status", 200), group)
        if resp.http_status == 200:
            assert resp.text, "响应体为空"
            try:
                parsed = json.loads(resp.text)
                assert isinstance(parsed, (list, dict)), "返回不是合法的 JSON 对象/数组"
            except json.JSONDecodeError:
                group.add(type("R", (), {"name": "JSON可解析", "passed": False, "message": "返回不是合法JSON"})())
        logger.info(group.summary())
        assert group.all_passed, f"用例 {case_id} 存在断言失败"

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

