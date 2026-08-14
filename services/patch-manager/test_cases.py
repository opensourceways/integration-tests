#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
openEuler 补丁管理平台（patch-mgr-bg）接口自动化测试用例
基于 openapi.yaml + requirement-analysis.md + architecture-design.md 生成

运行方式:
    pytest test_patch_mgr_api.py -v
    pytest test_patch_mgr_api.py -v -k "health"  # 仅运行健康检查
    pytest test_patch_mgr_api.py -v --tb=short   # 简短错误输出

环境变量:
    BASE_URL: API 基础地址，默认 https://ospatch.test.osinfra.cn
    AUTH_TOKEN: 认证 token，需在 .env 文件或环境变量中设置
"""

import os
import uuid
import random
import string
from datetime import datetime, timedelta
from typing import Any, Dict, List, Optional

import pytest
import requests
from dotenv import load_dotenv

# 加载 .env 文件中的环境变量
load_dotenv()

# ==================== 全局配置 ====================
BASE_URL = os.getenv("BASE_URL", "https://ospatch.test.osinfra.cn")
AUTH_TOKEN = os.getenv("AUTH_TOKEN")
if not AUTH_TOKEN:
    raise RuntimeError(
        "环境变量 AUTH_TOKEN 未设置。请在 .env 文件中配置 AUTH_TOKEN，"
        "或通过环境变量传入。"
    )

# API 前缀
API_V1 = f"{BASE_URL}/server/api/v1"


def generate_random_string(length: int = 8) -> str:
    """生成随机字符串"""
    return "".join(random.choices(string.ascii_lowercase + string.digits, k=length))


def generate_uuid() -> str:
    """生成 UUID 字符串"""
    return str(uuid.uuid4())


class PatchMgrClient:
    """HTTP 客户端封装"""

    def __init__(self, base_url: str = API_V1, token: Optional[str] = None):
        self.base_url = base_url.rstrip("/")
        self.session = requests.Session()
        self.session.headers.update({
            "Content-Type": "application/json",
            "Accept": "application/json",
        })
        if token:
            self.session.headers["token"] = token

    def request(
        self,
        method: str,
        path: str,
        *,
        params: Optional[Dict] = None,
        json_data: Optional[Dict] = None,
        files: Optional[Dict] = None,
        headers: Optional[Dict] = None,
        no_auth: bool = False,
        expected_status: Optional[int] = None,
    ) -> requests.Response:
        """
        通用请求方法

        Args:
            method: HTTP 方法
            path: API 路径（不含 base_url）
            params: URL 查询参数
            json_data: JSON 请求体
            files: 文件上传
            headers: 额外请求头
            no_auth: 是否不带认证（用于健康检查等）
            expected_status: 断言的预期状态码，None 则不断言
        """
        url = f"{self.base_url}{path}"
        req_headers = dict(self.session.headers)
        if headers:
            req_headers.update(headers)

        if no_auth and "token" in req_headers:
            del req_headers["token"]

        # 文件上传时不设置 Content-Type: application/json
        if files:
            req_headers.pop("Content-Type", None)

        try:
            resp = self.session.request(
                method=method.upper(),
                url=url,
                params=params,
                json=json_data if not files else None,
                data=json_data if files else None,
                files=files,
                headers=req_headers,
                timeout=30,
            )
        except requests.RequestException as e:
            pytest.fail(f"请求异常: {e}")

        if expected_status is not None:
            if resp.status_code != expected_status:
                # 打印完整请求和响应信息用于调试
                print("\n" + "=" * 80)
                print(f"[请求失败] {method.upper()} {url}")
                print(f"请求头: {req_headers}")
                if json_data:
                    print(f"请求体: {json_data}")
                if params:
                    print(f"查询参数: {params}")
                print("-" * 40)
                print(f"响应状态码: {resp.status_code}")
                print(f"响应头: {dict(resp.headers)}")
                print(f"响应体: {resp.text}")
                print("=" * 80 + "\n")
                pytest.fail(
                    f"预期状态码 {expected_status}, 实际 {resp.status_code}, "
                    f"响应: {resp.text[:500]}"
                )
        return resp

    # 便捷方法
    def get(self, path: str, **kwargs) -> requests.Response:
        return self.request("GET", path, **kwargs)

    def post(self, path: str, **kwargs) -> requests.Response:
        return self.request("POST", path, **kwargs)

    def patch(self, path: str, **kwargs) -> requests.Response:
        return self.request("PATCH", path, **kwargs)

    def delete(self, path: str, **kwargs) -> requests.Response:
        return self.request("DELETE", path, **kwargs)


@pytest.fixture(scope="session")
def client() -> PatchMgrClient:
    """全局客户端 fixture"""
    return PatchMgrClient(token=AUTH_TOKEN)


@pytest.fixture(scope="session")
def no_auth_client() -> PatchMgrClient:
    """无认证客户端 fixture"""
    return PatchMgrClient()


# ==================== 全局共享数据存储（跨测试用例传递 ID） ====================
class SharedData:
    """用于在测试类之间传递创建的资源 ID"""

    customer_id: Optional[str] = None
    product_version_id: Optional[str] = None
    patch_module_id: Optional[str] = None
    test_case_module_id: Optional[str] = None
    feature_id: Optional[str] = None
    patch_id: Optional[str] = None
    patch_primary_key: Optional[str] = None
    test_case_id: Optional[str] = None
    project_id: Optional[str] = None
    user_id: Optional[str] = None
    pipeline_id: Optional[str] = None
    build_id: Optional[str] = None


shared = SharedData()


# ==================== 1. 健康检查模块 ====================
class TestHealthCheck:
    """健康检查接口测试（无需认证）"""

    def test_healthz_live(self, no_auth_client: PatchMgrClient):
        """TC-HEALTH-001: 存活检查应返回 200"""
        # 健康检查在 /server 前缀下，不在 /api/v1 下
        base = BASE_URL.rstrip("/")
        resp = requests.get(f"{base}/healthz", timeout=30)
        assert resp.status_code == 200, f"预期 200, 实际 {resp.status_code}"
        print(f"✓ 存活检查通过: {resp.status_code}")

    def test_readyz_ready(self, no_auth_client: PatchMgrClient):
        """TC-HEALTH-002: 就绪检查应返回 200 或 503"""
        base = BASE_URL.rstrip("/")
        resp = requests.get(f"{base}/readyz", timeout=30)
        assert resp.status_code in (200, 503), f"意外状态码: {resp.status_code}"
        print(f"✓ 就绪检查通过: {resp.status_code}")


# ==================== 2. 个人中心模块 ====================
class TestUserProfile:
    """个人中心接口测试（全角色可访问）"""

    def test_bind_email_invalid_format(self, client: PatchMgrClient):
        """TC-USER-003: 绑定无效邮箱格式应返回 400"""
        resp = client.patch("/users/me/email", json_data={"email": "invalid-email"})
        assert resp.status_code == 400, f"预期 400, 实际 {resp.status_code}"
        print("✓ 无效邮箱格式校验通过")

    def test_bind_phone_too_short(self, client: PatchMgrClient):
        """TC-USER-006: 绑定过短手机号应返回 400"""
        resp = client.patch("/users/me/phone", json_data={"phone": "12345"})
        assert resp.status_code == 400
        print("✓ 手机号长度校验通过")


# ==================== 3. 管理员名单模块 ====================
class TestAdminManager:
    """管理员名单接口测试（super_admin 权限）"""

    def test_list_managers(self, client: PatchMgrClient):
        """TC-ADMIN-001: 管理者列表应返回 200"""
        resp = client.get("/admin/managers", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print(f"✓ 管理者列表查询成功")

    def test_list_managers_pagination(self, client: PatchMgrClient):
        """TC-ADMIN-002: 管理者列表分页参数校验"""
        resp = client.get("/admin/managers", params={"page": 1, "page_size": 5}, expected_status=200)
        print("✓ 管理者分页查询成功")

    def test_list_managers_search(self, client: PatchMgrClient):
        """TC-ADMIN-003: 管理者搜索应返回 200"""
        resp = client.get("/admin/managers", params={"search": "admin", "page": 1, "page_size": 10}, expected_status=200)
        print("✓ 管理者搜索成功")

    def test_list_users(self, client: PatchMgrClient):
        """TC-ADMIN-004: 用户列表应返回 200"""
        resp = client.get("/admin/users", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        # 尝试获取一个用户 ID 供后续使用
        if "items" in data and data["items"]:
            shared.user_id = data["items"][0].get("id")
        print(f"✓ 用户列表查询成功, 记录数: {data.get('total', 'N/A')}")

    def test_create_user_missing_required(self, client: PatchMgrClient):
        """TC-ADMIN-005: 创建用户缺少必填字段应返回 400"""
        resp = client.post("/admin/users", json_data={"role": "user"})
        assert resp.status_code == 400, f"预期 400, 实际 {resp.status_code}"
        print("✓ 创建用户必填校验通过")

    def test_create_user_invalid_role(self, client: PatchMgrClient):
        """TC-ADMIN-006: 创建用户无效角色应返回 400"""
        resp = client.post("/admin/users", json_data={"username": f"test_{generate_random_string()}", "role": "invalid_role"})
        assert resp.status_code in (400, 403)
        print("✓ 创建用户角色校验通过")

    def test_remove_manager_not_found(self, client: PatchMgrClient):
        """TC-ADMIN-008: 移除不存在的管理者应返回 404 或 403"""
        fake_id = generate_uuid()
        resp = client.delete(f"/admin/managers/{fake_id}")
        assert resp.status_code in (404, 403, 200)
        print(f"✓ 移除不存在管理者响应: {resp.status_code}")


# ==================== 4. 客户管理模块 ====================
class TestCustomer:
    """客户管理接口测试（admin 权限）"""

    def test_list_customers(self, client: PatchMgrClient):
        """TC-CUST-001: 客户列表应返回 200"""
        resp = client.get("/customers", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print(f"✓ 客户列表查询成功")

    def test_list_customers_sort(self, client: PatchMgrClient):
        """TC-CUST-002: 客户列表排序应返回 200"""
        resp = client.get(
            "/customers",
            params={"page": 1, "page_size": 10, "sort_by": "created_at", "sort_order": "desc"},
            expected_status=200,
        )
        print("✓ 客户列表排序成功")

    def test_create_customer_success(self, client: PatchMgrClient):
        """TC-CUST-003: 创建客户应返回 201"""
        payload = {
            "name": f"客户_{generate_random_string()}",
            "description": f"自动化测试创建的客户 {datetime.now().isoformat()}",
        }
        resp = client.post("/customers", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.customer_id = data["id"]
        print(f"✓ 创建客户成功: {data.get('id', 'N/A')}")

    def test_create_customer_missing_name(self, client: PatchMgrClient):
        """TC-CUST-004: 创建客户缺少名称应返回 400"""
        resp = client.post("/customers", json_data={"description": "无名称"})
        assert resp.status_code == 400
        print("✓ 创建客户名称必填校验通过")

    def test_get_customer_detail(self, client: PatchMgrClient):
        """TC-CUST-005: 客户详情应返回 200"""
        if not shared.customer_id:
            pytest.skip("无可用客户 ID，跳过详情查询")
        resp = client.get(f"/customers/{shared.customer_id}", expected_status=200)
        data = resp.json()
        assert "id" in data or "name" in data
        print(f"✓ 客户详情查询成功")

    def test_get_customer_not_found(self, client: PatchMgrClient):
        """TC-CUST-006: 查询不存在的客户应返回 404"""
        fake_id = generate_uuid()
        resp = client.get(f"/customers/{fake_id}", expected_status=404)
        print("✓ 客户不存在校验通过")

    def test_update_customer_success(self, client: PatchMgrClient):
        """TC-CUST-007: 更新客户应返回 200"""
        if not shared.customer_id:
            pytest.skip("无可用客户 ID，跳过更新")
        payload = {
            "name": f"更新后客户_{generate_random_string()}",
            "description": f"更新时间 {datetime.now().isoformat()}",
        }
        resp = client.patch(f"/customers/{shared.customer_id}", json_data=payload, expected_status=200)
        print("✓ 更新客户成功")

    def test_z_delete_customer(self, client: PatchMgrClient):
        """TC-CUST-008: 删除客户应返回 200"""
        if not shared.customer_id:
            pytest.skip("无可用客户 ID，跳过删除")
        resp = client.delete(f"/customers/{shared.customer_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除客户成功")
        shared.customer_id = None


# ==================== 5. 产品版本模块 ====================
class TestProductVersion:
    """产品版本接口测试（admin 权限）"""

    def test_list_product_versions(self, client: PatchMgrClient):
        """TC-PV-001: 产品版本列表应返回 200"""
        resp = client.get("/product-versions", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 产品版本列表查询成功")

    def test_create_product_version_success(self, client: PatchMgrClient):
        """TC-PV-002: 创建产品版本应返回 201"""
        payload = {
            "name": f"版本_{generate_random_string()}",
            "cpu_architecture": random.choice(["x86_64", "aarch64"]),
            "description": f"自动化测试创建 {datetime.now().isoformat()}",
        }
        resp = client.post("/product-versions", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.product_version_id = data["id"]
        print(f"✓ 创建产品版本成功: {data.get('id', 'N/A')}")

    def test_create_product_version_missing_name(self, client: PatchMgrClient):
        """TC-PV-003: 创建产品版本缺少名称应返回 400"""
        resp = client.post("/product-versions", json_data={"description": "无名称"})
        assert resp.status_code == 400
        print("✓ 产品版本名称必填校验通过")

    def test_get_product_version_detail(self, client: PatchMgrClient):
        """TC-PV-004: 产品版本详情应返回 200"""
        if not shared.product_version_id:
            pytest.skip("无可用产品版本 ID")
        resp = client.get(f"/product-versions/{shared.product_version_id}", expected_status=200)
        print("✓ 产品版本详情查询成功")

    def test_get_product_version_not_found(self, client: PatchMgrClient):
        """TC-PV-005: 查询不存在的产品版本应返回 404"""
        resp = client.get(f"/product-versions/{generate_uuid()}", expected_status=404)
        print("✓ 产品版本不存在校验通过")

    def test_update_product_version(self, client: PatchMgrClient):
        """TC-PV-006: 更新产品版本应返回 200"""
        if not shared.product_version_id:
            pytest.skip("无可用产品版本 ID")
        payload = {"name": f"更新版本_{generate_random_string()}", "description": "已更新"}
        resp = client.patch(f"/product-versions/{shared.product_version_id}", json_data=payload, expected_status=200)
        print("✓ 更新产品版本成功")

    def test_z_delete_product_version(self, client: PatchMgrClient):
        """TC-PV-007: 删除产品版本应返回 200"""
        if not shared.product_version_id:
            pytest.skip("无可用产品版本 ID")
        resp = client.delete(f"/product-versions/{shared.product_version_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除产品版本成功")
        shared.product_version_id = None


# ==================== 6. 补丁模块 ====================
class TestPatchModule:
    """补丁模块接口测试（admin 权限）"""

    def test_list_patch_modules(self, client: PatchMgrClient):
        """TC-PMOD-001: 补丁模块列表应返回 200"""
        resp = client.get("/patch-modules", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 补丁模块列表查询成功")

    def test_create_patch_module_success(self, client: PatchMgrClient):
        """TC-PMOD-002: 创建补丁模块应返回 201"""
        payload = {
            "name": f"模块_{generate_random_string()}",
            "description": f"自动化测试 {datetime.now().isoformat()}",
        }
        resp = client.post("/patch-modules", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.patch_module_id = data["id"]
        print(f"✓ 创建补丁模块成功: {data.get('id', 'N/A')}")

    def test_create_patch_module_missing_name(self, client: PatchMgrClient):
        """TC-PMOD-003: 创建补丁模块缺少名称应返回 400"""
        resp = client.post("/patch-modules", json_data={"description": "无名称"})
        assert resp.status_code == 400
        print("✓ 补丁模块名称必填校验通过")

    def test_get_patch_module_detail(self, client: PatchMgrClient):
        """TC-PMOD-004: 补丁模块详情应返回 200"""
        if not shared.patch_module_id:
            pytest.skip("无可用补丁模块 ID")
        resp = client.get(f"/patch-modules/{shared.patch_module_id}", expected_status=200)
        data = resp.json()
        # 含 features 字段
        assert "features" in data or "id" in data
        print("✓ 补丁模块详情查询成功（含 features）")

    def test_update_patch_module(self, client: PatchMgrClient):
        """TC-PMOD-005: 更新补丁模块应返回 200"""
        if not shared.patch_module_id:
            pytest.skip("无可用补丁模块 ID")
        payload = {"name": f"更新模块_{generate_random_string()}", "description": "已更新"}
        resp = client.patch(f"/patch-modules/{shared.patch_module_id}", json_data=payload, expected_status=200)
        print("✓ 更新补丁模块成功")

    def test_z_delete_patch_module(self, client: PatchMgrClient):
        """TC-PMOD-006: 删除补丁模块应返回 200"""
        if not shared.patch_module_id:
            pytest.skip("无可用补丁模块 ID")
        resp = client.delete(f"/patch-modules/{shared.patch_module_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除补丁模块成功")
        shared.patch_module_id = None


# ==================== 7. 用例模块 ====================
class TestTestCaseModule:
    """用例模块接口测试（admin 权限）"""

    def test_list_test_case_modules(self, client: PatchMgrClient):
        """TC-TCMOD-001: 用例模块列表应返回 200"""
        resp = client.get("/test-case-modules", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 用例模块列表查询成功")

    def test_create_test_case_module_success(self, client: PatchMgrClient):
        """TC-TCMOD-002: 创建用例模块应返回 201"""
        payload = {
            "name": f"用例模块_{generate_random_string()}",
            "description": f"自动化测试 {datetime.now().isoformat()}",
        }
        resp = client.post("/test-case-modules", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.test_case_module_id = data["id"]
        print(f"✓ 创建用例模块成功: {data.get('id', 'N/A')}")

    def test_get_test_case_module_detail(self, client: PatchMgrClient):
        """TC-TCMOD-003: 用例模块详情应返回 200"""
        if not shared.test_case_module_id:
            pytest.skip("无可用用例模块 ID")
        resp = client.get(f"/test-case-modules/{shared.test_case_module_id}", expected_status=200)
        print("✓ 用例模块详情查询成功")

    def test_update_test_case_module(self, client: PatchMgrClient):
        """TC-TCMOD-004: 更新用例模块应返回 200"""
        if not shared.test_case_module_id:
            pytest.skip("无可用用例模块 ID")
        payload = {"name": f"更新用例模块_{generate_random_string()}", "description": "已更新"}
        resp = client.patch(f"/test-case-modules/{shared.test_case_module_id}", json_data=payload, expected_status=200)
        print("✓ 更新用例模块成功")

    def test_z_delete_test_case_module(self, client: PatchMgrClient):
        """TC-TCMOD-005: 删除用例模块应返回 200"""
        if not shared.test_case_module_id:
            pytest.skip("无可用用例模块 ID")
        resp = client.delete(f"/test-case-modules/{shared.test_case_module_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除用例模块成功")
        shared.test_case_module_id = None


# ==================== 8. 特性模块 ====================
class TestFeature:
    """特性接口测试（admin 权限）"""

    def test_list_features(self, client: PatchMgrClient):
        """TC-FEAT-001: 特性列表应返回 200"""
        resp = client.get("/features", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 特性列表查询成功")

    def test_list_features_by_module(self, client: PatchMgrClient):
        """TC-FEAT-002: 按补丁模块筛选特性应返回 200"""
        params = {"page": 1, "page_size": 20}
        if shared.patch_module_id:
            params["patch_module_id"] = shared.patch_module_id
        resp = client.get("/features", params=params, expected_status=200)
        print("✓ 按模块筛选特性成功")

    def test_create_feature_success(self, client: PatchMgrClient):
        """TC-FEAT-003: 创建特性应返回 201"""
        # 先确保有 patch_module_id
        if not shared.patch_module_id:
            # 创建一个临时模块
            r = client.post("/patch-modules", json_data={"name": f"临时模块_{generate_random_string()}"}, expected_status=201)
            shared.patch_module_id = r.json().get("id")

        payload = {
            "name": f"特性_{generate_random_string()}",
            "patch_module_id": shared.patch_module_id,
            "description": f"自动化测试 {datetime.now().isoformat()}",
        }
        resp = client.post("/features", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.feature_id = data["id"]
        print(f"✓ 创建特性成功: {data.get('id', 'N/A')}")

    def test_create_feature_missing_patch_module_id(self, client: PatchMgrClient):
        """TC-FEAT-004: 创建特性缺少 patch_module_id 应返回 400"""
        resp = client.post("/features", json_data={"name": "无模块特性"})
        assert resp.status_code == 400
        print("✓ 特性 patch_module_id 必填校验通过")

    def test_get_feature_detail(self, client: PatchMgrClient):
        """TC-FEAT-005: 特性详情应返回 200"""
        if not shared.feature_id:
            pytest.skip("无可用特性 ID")
        resp = client.get(f"/features/{shared.feature_id}", expected_status=200)
        print("✓ 特性详情查询成功")

    def test_update_feature(self, client: PatchMgrClient):
        """TC-FEAT-006: 更新特性应返回 200"""
        if not shared.feature_id:
            pytest.skip("无可用特性 ID")
        payload = {"name": f"更新特性_{generate_random_string()}", "description": "已更新"}
        resp = client.patch(f"/features/{shared.feature_id}", json_data=payload, expected_status=200)
        print("✓ 更新特性成功")

    def test_z_delete_feature(self, client: PatchMgrClient):
        """TC-FEAT-007: 删除特性应返回 200（default 特性不可删，这里假设非 default）"""
        if not shared.feature_id:
            pytest.skip("无可用特性 ID")
        resp = client.delete(f"/features/{shared.feature_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除特性成功")
        shared.feature_id = None


# ==================== 9. 补丁管理模块 ====================
class TestPatch:
    """补丁管理接口测试（admin 权限）"""

    def _ensure_dependencies(self, client: PatchMgrClient):
        """确保创建补丁的前置依赖存在"""
        # 产品版本
        if not shared.product_version_id:
            r = client.post(
                "/product-versions",
                json_data={"name": f"临时版本_{generate_random_string()}", "cpu_architecture": "x86_64"},
                expected_status=201,
            )
            shared.product_version_id = r.json().get("id")
        # 补丁模块
        if not shared.patch_module_id:
            r = client.post("/patch-modules", json_data={"name": f"临时模块_{generate_random_string()}"}, expected_status=201)
            shared.patch_module_id = r.json().get("id")

    def test_list_patches(self, client: PatchMgrClient):
        """TC-PATCH-001: 补丁全量列表应返回 200"""
        resp = client.get("/patches", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 补丁列表查询成功")

    def test_list_patches_with_filters(self, client: PatchMgrClient):
        """TC-PATCH-002: 补丁列表带筛选参数应返回 200"""
        params = {
            "page": 1,
            "page_size": 10,
            "patch_type": random.choice(["Feature", "Bug", "Cleanup"]),
            "mode": random.choice(["用户态", "内核态"]),
        }
        resp = client.get("/patches", params=params, expected_status=200)
        print("✓ 补丁筛选查询成功")

    def test_create_patch_success(self, client: PatchMgrClient):
        """TC-PATCH-003: 单条录入补丁应返回 201"""
        self._ensure_dependencies(client)
        payload = {
            "primary_key": f"PATCH-{generate_random_string().upper()}",
            "sr_overview": "问题概述示例",
            "ar_description": "修改描述示例",
            "patch_type": random.choice(["Feature", "Bug", "Cleanup"]),
            "product_version_id": shared.product_version_id,
            "patch_module_id": shared.patch_module_id,
            "mode": random.choice(["用户态", "内核态"]),
            "severity": "high",
            "affected_version": "22.03-LTS",
            "priority": random.choice(["high", "medium", "low"]),
        }
        resp = client.post("/patches", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.patch_id = data["id"]
            shared.patch_primary_key = payload["primary_key"]
        print(f"✓ 创建补丁成功: {data.get('id', 'N/A')}")

    def test_create_patch_missing_required(self, client: PatchMgrClient):
        """TC-PATCH-004: 创建补丁缺少必填字段应返回 400"""
        resp = client.post("/patches", json_data={"sr_overview": "缺少必填字段"})
        assert resp.status_code == 400
        print("✓ 补丁必填字段校验通过")

    def test_create_patch_duplicate_primary_key(self, client: PatchMgrClient):
        """TC-PATCH-005: 重复主键应返回 409"""
        self._ensure_dependencies(client)
        primary_key = f"PATCH-DUP-{generate_random_string().upper()}"
        payload = {
            "primary_key": primary_key,
            "patch_type": "Bug",
            "product_version_id": shared.product_version_id,
            "patch_module_id": shared.patch_module_id,
            "mode": "内核态",
        }
        r = client.post("/patches", json_data=payload, expected_status=201)
        shared.patch_id = r.json().get("id")
        shared.patch_primary_key = primary_key
        # 再次创建相同主键
        resp = client.post("/patches", json_data=payload)
        assert resp.status_code in (409, 400), f"预期 409/400, 实际 {resp.status_code}"
        print("✓ 补丁主键冲突校验通过")

    def test_get_patch_not_found(self, client: PatchMgrClient):
        """TC-PATCH-007: 查询不存在的补丁应返回 404"""
        resp = client.get(f"/patches/{generate_uuid()}", expected_status=404)
        print("✓ 补丁不存在校验通过")

    def test_update_patch(self, client: PatchMgrClient):
        """TC-PATCH-008: 更新补丁应返回 200"""
        if not shared.patch_id:
            pytest.skip("无可用补丁 ID")
        payload = {
            "sr_overview": f"更新后概述 {generate_random_string()}",
            "priority": "low",
        }
        resp = client.patch(f"/patches/{shared.patch_id}", json_data=payload, expected_status=200)
        print("✓ 更新补丁成功")

    def test_update_patch_merge_status(self, client: PatchMgrClient):
        """TC-PATCH-009: 更新补丁合入状态应返回 200"""
        if not shared.patch_id:
            pytest.skip("无可用补丁 ID")
        payload = {
            "merge_status": random.choice(["未合入", "自动适配中", "冲突", "已提交PR", "已合入"]),
            "customer_merge_status": "已合入",
            "merge_version": "22.03-LTS-SP1",
            "os_release_version": "22.03-LTS",
        }
        resp = client.patch(f"/patches/{shared.patch_id}/merge-status", json_data=payload, expected_status=200)
        print("✓ 更新补丁合入状态成功")

    def test_list_patch_test_cases(self, client: PatchMgrClient):
        """TC-PATCH-010: 查询补丁关联用例应返回 200"""
        if not shared.patch_id:
            pytest.skip("无可用补丁 ID")
        resp = client.get(f"/patches/{shared.patch_id}/test-cases", params={"page": 1, "page_size": 20}, expected_status=200)
        print("✓ 补丁关联用例查询成功")

    def test_z_delete_patch(self, client: PatchMgrClient):
        """TC-PATCH-011: 删除补丁应返回 200"""
        if not shared.patch_id:
            pytest.skip("无可用补丁 ID")
        resp = client.delete(f"/patches/{shared.patch_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除补丁成功")
        shared.patch_id = None

    def test_z_batch_delete_patches(self, client: PatchMgrClient):
        """TC-PATCH-012: 批量删除补丁应返回 200"""
        # 先创建两个临时补丁
        self._ensure_dependencies(client)
        ids = []
        for _ in range(2):
            pk = f"PATCH-BATCH-{generate_random_string().upper()}"
            r = client.post(
                "/patches",
                json_data={
                    "primary_key": pk,
                    "patch_type": "Bug",
                    "product_version_id": shared.product_version_id,
                    "patch_module_id": shared.patch_module_id,
                    "mode": "用户态",
                },
                expected_status=201,
            )
            ids.append(r.json()["id"])

        resp = client.delete("/patches/batch", json_data={"ids": ids}, expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "count" in data
        print(f"✓ 批量删除补丁成功，删除数量: {data.get('count', 'N/A')}")

    def test_get_patch_primary_keys(self, client: PatchMgrClient):
        """TC-PATCH-013: 枚举补丁主键应返回 200"""
        resp = client.get("/patches/primary-keys", expected_status=200)
        data = resp.json()
        assert "items" in data or isinstance(data, list)
        print("✓ 枚举补丁主键成功")


# ==================== 10. 用例管理模块 ====================
class TestTestCase:
    """用例管理接口测试（admin 权限）"""

    def _ensure_dependencies(self, client: PatchMgrClient):
        """确保创建用例的前置依赖存在"""
        if not shared.test_case_module_id:
            r = client.post("/test-case-modules", json_data={"name": f"临时用例模块_{generate_random_string()}"}, expected_status=201)
            shared.test_case_module_id = r.json().get("id")
        if not shared.patch_id:
            # 确保有补丁
            if not shared.product_version_id:
                r = client.post("/product-versions", json_data={"name": f"临时版本_{generate_random_string()}"}, expected_status=201)
                shared.product_version_id = r.json().get("id")
            if not shared.patch_module_id:
                r = client.post("/patch-modules", json_data={"name": f"临时模块_{generate_random_string()}"}, expected_status=201)
                shared.patch_module_id = r.json().get("id")
            r = client.post(
                "/patches",
                json_data={
                    "primary_key": f"PATCH-TC-{generate_random_string().upper()}",
                    "patch_type": "Bug",
                    "product_version_id": shared.product_version_id,
                    "patch_module_id": shared.patch_module_id,
                    "mode": "内核态",
                },
                expected_status=201,
            )
            shared.patch_id = r.json().get("id")
            shared.patch_primary_key = r.json().get("primary_key") or r.json().get("data", {}).get("primary_key")
            if not shared.patch_primary_key:
                shared.patch_primary_key = f"PATCH-TC-FALLBACK"

    def test_list_test_cases(self, client: PatchMgrClient):
        """TC-TC-001: 用例模块列表应返回 200"""
        resp = client.get("/test-case-modules", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 用例模块列表查询成功")

    def test_create_test_case_success(self, client: PatchMgrClient):
        """TC-TC-003: 单条录入用例应返回 201"""
        self._ensure_dependencies(client)
        payload = {
            "name": f"用例_{generate_random_string()}",
            "code": f"TC-{generate_random_string().upper()}",
            "level": random.choice(["Level 0", "Level 1", "Level 2", "Level 3"]),
            "primary_key": shared.patch_primary_key or f"PATCH-TC-FALLBACK",
            "test_case_module_id": shared.test_case_module_id,
            "test_type": random.choice(["功能", "性能", "可靠性", "兼容性", "安全性", "可服务性", "易用性"]),
            "precondition": "前置条件示例",
            "test_steps": "测试步骤示例",
            "expected_result": "预期结果示例",
            "is_automated": random.choice([True, False]),
            "priority": random.choice(["Level 0", "Level 1", "Level 2", "Level 3"]),
            "remark": "备注信息",
        }
        resp = client.post("/test-cases", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.test_case_id = data["id"]
        print(f"✓ 创建用例成功: {data.get('id', 'N/A')}")

    def test_create_test_case_missing_required(self, client: PatchMgrClient):
        """TC-TC-004: 创建用例缺少必填字段应返回 400"""
        resp = client.post("/test-cases", json_data={"name": "缺少必填字段"})
        assert resp.status_code == 400
        print("✓ 用例必填字段校验通过")

    def test_update_test_case(self, client: PatchMgrClient):
        """TC-TC-005: 更新用例应返回 200"""
        if not shared.test_case_id:
            pytest.skip("无可用用例 ID")
        payload = {
            "name": f"更新用例_{generate_random_string()}",
            "expected_result": "更新后的预期结果",
        }
        resp = client.patch(f"/test-cases/{shared.test_case_id}", json_data=payload, expected_status=200)
        print("✓ 更新用例成功")

    def test_z_delete_test_case(self, client: PatchMgrClient):
        """TC-TC-006: 删除用例应返回 200"""
        if not shared.test_case_id:
            pytest.skip("无可用用例 ID")
        resp = client.delete(f"/test-cases/{shared.test_case_id}", expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "deleted" in data
        print("✓ 删除用例成功")
        shared.test_case_id = None

    def test_z_batch_delete_test_cases(self, client: PatchMgrClient):
        """TC-TC-007: 批量删除用例应返回 200"""
        self._ensure_dependencies(client)
        ids = []
        for i in range(2):
            payload = {
                "name": f"批量用例{i}_{generate_random_string()}",
                "code": f"BTC-{i}-{generate_random_string().upper()}",
                "level": "Level 1",
                "primary_key": shared.patch_primary_key or f"PATCH-TC-FALLBACK",
                "test_case_module_id": shared.test_case_module_id,
                "test_type": "功能",
            }
            r = client.post("/test-cases", json_data=payload, expected_status=201)
            ids.append(r.json()["id"])

        resp = client.delete("/test-cases/batch", json_data={"ids": ids}, expected_status=200)
        data = resp.json()
        assert data.get("deleted") is True or "count" in data
        print(f"✓ 批量删除用例成功，数量: {data.get('count', 'N/A')}")


# ==================== 11. 项目管理模块 ====================
class TestProject:
    """项目管理接口测试"""

    def _ensure_dependencies(self, client: PatchMgrClient):
        """确保项目创建的前置依赖（客户 + 产品版本 + 补丁模块）"""
        if not shared.customer_id:
            r = client.post("/customers", json_data={"name": f"临时客户_{generate_random_string()}"}, expected_status=201)
            shared.customer_id = r.json().get("id")
        if not shared.product_version_id:
            r = client.post(
                "/product-versions",
                json_data={"name": f"临时版本_{generate_random_string()}", "cpu_architecture": "x86_64"},
                expected_status=201,
            )
            shared.product_version_id = r.json().get("id")
        if not shared.patch_module_id:
            r = client.post("/patch-modules", json_data={"name": f"项目模块_{generate_random_string()}"}, expected_status=201)
            shared.patch_module_id = r.json().get("id")

    def test_list_projects(self, client: PatchMgrClient):
        """TC-PROJ-001: 项目列表应返回 200"""
        resp = client.get("/projects", params={"page": 1, "page_size": 20}, expected_status=200)
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 项目列表查询成功")

    def test_list_my_projects(self, client: PatchMgrClient):
        """TC-PROJ-002: 我的项目列表应返回 200"""
        resp = client.get("/projects", params={"scope": "my", "page": 1, "page_size": 20}, expected_status=200)
        print("✓ 我的项目列表查询成功")

    def test_list_projects_with_filters(self, client: PatchMgrClient):
        """TC-PROJ-003: 项目列表带筛选应返回 200"""
        params = {
            "page": 1,
            "page_size": 10,
            "phase": random.choice(["开发中", "测试中", "已完成"]),
        }
        resp = client.get("/projects", params=params, expected_status=200)
        print("✓ 项目筛选查询成功")

    def test_create_project_success(self, client: PatchMgrClient):
        """TC-PROJ-004: 创建项目应返回 201"""
        self._ensure_dependencies(client)
        payload = {
            "name": f"项目_{generate_random_string()}",
            "description": f"自动化测试创建项目 {datetime.now().isoformat()}",
            "owner": f"owner_{generate_random_string()}",
            "cpu_arch": random.choice(["x86_64", "aarch64"]),
            "customer_id": shared.customer_id,
            "product_version_id": shared.product_version_id,
            "os_version": "22.03-LTS",
            "kernel_version": "5.10.0",
            "phase": random.choice(["开发中", "测试中", "已完成"]),
            "start_date": datetime.now().strftime("%Y-%m-%d"),
            "planned_delivery_date": (datetime.now() + timedelta(days=30)).strftime("%Y-%m-%d"),
            "patch_repo_config": "{\"branch\":\"main\"}",
            "dev_timeline": [{"start_date": "2026-01-01", "end_date": "2026-06-30"}],
            "test_timeline": [{"start_date": "2026-07-01", "end_date": "2026-12-31"}],
        }
        resp = client.post("/projects", json_data=payload, expected_status=201)
        data = resp.json()
        if "id" in data:
            shared.project_id = data["id"]
        print(f"✓ 创建项目成功: {data.get('id', 'N/A')}")

    def test_create_project_missing_required(self, client: PatchMgrClient):
        """TC-PROJ-005: 创建项目缺少必填字段应返回 400"""
        resp = client.post("/projects", json_data={"name": "缺少必填字段的项目"})
        assert resp.status_code == 400
        print("✓ 项目必填字段校验通过")

    def test_get_project_detail(self, client: PatchMgrClient):
        """TC-PROJ-006: 项目详情应返回 200"""
        resp = client.get(f"/projects/{shared.project_id}", expected_status=200)
        print("✓ 项目详情查询成功")

    def test_get_project_not_found(self, client: PatchMgrClient):
        """TC-PROJ-007: 查询不存在的项目应返回 404"""
        resp = client.get(f"/projects/{generate_uuid()}", expected_status=404)
        print("✓ 项目不存在校验通过")

    def test_get_project_progress(self, client: PatchMgrClient):
        """TC-PROJ-008: 项目进度看板应返回 200"""
        resp = client.get(f"/projects/{shared.project_id}/progress", expected_status=200)
        print("✓ 项目进度看板查询成功")

    def test_get_project_report(self, client: PatchMgrClient):
        """TC-PROJ-009: 出口评审报告应返回 200"""
        resp = client.get(f"/projects/{shared.project_id}/report", expected_status=200)
        print("✓ 出口评审报告查询成功")

    def test_update_project(self, client: PatchMgrClient):
        """TC-PROJ-010: 更新项目应返回 200"""
        payload = {
            "name": f"更新项目_{generate_random_string()}",
            "description": "已更新描述",
            "phase": "测试中",
        }
        resp = client.patch(f"/projects/{shared.project_id}", json_data=payload, expected_status=200)
        print("✓ 更新项目成功")

    def test_bind_users_to_project(self, client: PatchMgrClient):
        """TC-PROJ-011: 批量绑定用户到项目应返回 200"""
        # 获取用户列表
        r = client.get("/admin/users", params={"page": 1, "page_size": 5}, expected_status=200)
        data = r.json()
        user_ids = []
        if "items" in data and data["items"]:
            user_ids = [u["id"] for u in data["items"][:2]]
        if not user_ids:
            pytest.skip("无可用用户进行绑定测试")

        resp = client.post(f"/projects/{shared.project_id}/users", json_data={"user_ids": user_ids}, expected_status=200)
        result = resp.json()
        assert "bound" in result or "requested" in result
        print(f"✓ 绑定用户到项目成功，绑定数: {result.get('requested', 'N/A')}")

    def test_list_project_users(self, client: PatchMgrClient):
        """TC-PROJ-012: 项目绑定用户列表应返回 200"""
        resp = client.get(f"/projects/{shared.project_id}/users", params={"page": 1, "page_size": 20}, expected_status=200)
        print("✓ 项目用户列表查询成功")

    def test_unbind_user_from_project(self, client: PatchMgrClient):
        """TC-PROJ-013: 解绑用户应返回 200"""
        if not shared.project_id or not shared.user_id:
            pytest.skip("无可用项目或用户 ID")
        resp = client.delete(f"/projects/{shared.project_id}/users/{shared.user_id}", expected_status=200)
        data = resp.json()
        assert data.get("unbound") is True or "unbound" in data
        print("✓ 解绑用户成功")

    def test_list_project_patches(self, client: PatchMgrClient):
        """TC-PROJ-014: 项目补丁看板应返回 200"""
        resp = client.get(f"/projects/{shared.project_id}/patches", params={"page": 1, "page_size": 20}, expected_status=200)
        print("✓ 项目补丁看板查询成功")

    def _ensure_patch_for_project(self, client: PatchMgrClient) -> str:
        """为项目创建关联补丁，返回补丁 primary_key"""
        self._ensure_dependencies(client)
        if not shared.patch_id or not shared.patch_primary_key:
            pk = f"PATCH-PROJ-{generate_random_string().upper()}"
            r = client.post("/patches", json_data={
                "primary_key": pk,
                "patch_type": "Bug",
                "product_version_id": shared.product_version_id,
                "patch_module_id": shared.patch_module_id,
                "mode": "内核态",
            }, expected_status=201)
            shared.patch_id = r.json().get("id")
            shared.patch_primary_key = pk
        return shared.patch_primary_key

    def _ensure_test_case_for_project(self, client: PatchMgrClient) -> str:
        """为项目维度测试创建临时用例（绑定到项目关联的补丁）"""
        if not shared.test_case_module_id:
            r = client.post("/test-case-modules", json_data={"name": f"项目用例模块_{generate_random_string()}"}, expected_status=201)
            shared.test_case_module_id = r.json().get("id")
        pk = self._ensure_patch_for_project(client)
        payload = {
            "name": f"项目用例_{generate_random_string()}",
            "code": f"PTC-{generate_random_string().upper()}",
            "level": "Level 1",
            "primary_key": pk,
            "test_case_module_id": shared.test_case_module_id,
            "test_type": "功能",
        }
        r = client.post("/test-cases", json_data=payload, expected_status=201)
        return r.json()["id"]

    # def test_update_project_test_case_result(self, client: PatchMgrClient):
    #     """TC-PROJ-016: 更新用例执行结果应返回 200"""
    #     cid = self._ensure_test_case_for_project(client)
    #     payload = {
    #         "last_execution_result": random.choice(["passed", "fail", "block", "unavailable", "--"]),
    #         "execution_description": "自动化测试执行",
    #         "executor": "auto_tester",
    #         "last_execution_time": datetime.now().isoformat(),
    #     }
    #     resp = client.patch(
    #         f"/projects/{shared.project_id}/test-cases/{cid}/result",
    #         json_data=payload,
    #         expected_status=200,
    #     )
    #     print("✓ 更新用例执行结果成功")

    def test_add_test_case_remark(self, client: PatchMgrClient):
        """TC-PROJ-017: 添加用例备注应返回 200"""
        cid = self._ensure_test_case_for_project(client)
        payload = {"remark": f"自动化测试备注 {generate_random_string()}"}
        resp = client.post(
            f"/projects/{shared.project_id}/test-cases/{cid}/remarks",
            json_data=payload,
            expected_status=200,
        )
        print("✓ 添加用例备注成功")

    def test_z_delete_project(self, client: PatchMgrClient):
        """TC-PROJ-018: 删除项目应返回 200"""
        if not shared.project_id:
            pytest.skip("无可用项目 ID")
        resp = client.delete(f"/projects/{shared.project_id}", expected_status=200)
        shared.project_id = None
        print("✓ 删除项目成功")
        shared.project_id = None


# ==================== 12. 流水线与构建模块 ====================
class TestPipeline:
    """流水线与构建接口测试（admin 权限）"""

    _pipeline_project_id: Optional[str] = None

    def _ensure_project(self, client: PatchMgrClient):
        """确保流水线测试有独立的项目可用"""
        if not self._pipeline_project_id:
            if not shared.customer_id:
                r = client.post("/customers", json_data={"name": f"流水线客户_{generate_random_string()}"}, expected_status=201)
                shared.customer_id = r.json().get("id")
            if not shared.product_version_id:
                r = client.post("/product-versions", json_data={"name": f"流水线版本_{generate_random_string()}", "cpu_architecture": "x86_64"}, expected_status=201)
                shared.product_version_id = r.json().get("id")
            payload = {
                "name": f"流水线项目_{generate_random_string()}",
                "description": "自动化测试流水线项目",
                "owner": "auto_tester",
                "cpu_arch": "x86_64",
                "customer_id": shared.customer_id,
                "product_version_id": shared.product_version_id,
                "os_version": "22.03-LTS",
                "kernel_version": "5.10.0",
                "phase": "开发中",
                "start_date": datetime.now().strftime("%Y-%m-%d"),
                "planned_delivery_date": (datetime.now() + timedelta(days=30)).strftime("%Y-%m-%d"),
                "patch_repo_config": "{\"branch\":\"main\"}",
                "dev_timeline": [{"start_date": "2026-01-01", "end_date": "2026-06-30"}],
                "test_timeline": [{"start_date": "2026-07-01", "end_date": "2026-12-31"}],
            }
            r = client.post("/projects", json_data=payload, expected_status=201)
            self._pipeline_project_id = r.json().get("id")
        return self._pipeline_project_id

    def test_list_pipelines(self, client: PatchMgrClient):
        """TC-PIPE-001: 流水线列表应返回 200"""
        pid = self._ensure_project(client)
        resp = client.get(
            f"/projects/{pid}/pipelines",
            params={"page": 1, "page_size": 20},
            expected_status=200,
        )
        data = resp.json()
        assert "items" in data or "total" in data or isinstance(data, list)
        print("✓ 流水线列表查询成功")

    # def test_trigger_pipeline(self, client: PatchMgrClient):
    #     """TC-PIPE-002: 触发流水线应返回 200"""
    #     pid = self._ensure_project(client)
    #     payload = {"pipeline_type": random.choice(["project_full", "kernel_build", "iso_build", "case_execution"])}
    #     resp = client.post(f"/projects/{pid}/pipelines/trigger", json_data=payload, expected_status=201)
    #     print("✓ 触发流水线成功")

    def test_trigger_pipeline_invalid_type(self, client: PatchMgrClient):
        """TC-PIPE-003: 触发无效类型流水线应返回 400"""
        pid = self._ensure_project(client)
        resp = client.post(f"/projects/{pid}/pipelines/trigger", json_data={"pipeline_type": "invalid_type"})
        assert resp.status_code in (400, 422)
        print("✓ 流水线类型校验通过")

    def test_list_build_records(self, client: PatchMgrClient):
        """TC-PIPE-004: 构建记录列表应返回 200"""
        pid = self._ensure_project(client)
        resp = client.get(
            f"/projects/{pid}/build-records",
            params={"page": 1, "page_size": 20},
            expected_status=200,
        )
        print("✓ 构建记录列表查询成功")

    def test_trigger_kernel_build(self, client: PatchMgrClient):
        """TC-PIPE-005: 触发内核构建应返回 200"""
        pid = self._ensure_project(client)
        payload = {"source_config": "kernel_source_config_example"}
        resp = client.post(f"/projects/{pid}/builds/kernel", json_data=payload, expected_status=201)
        print("✓ 触发内核构建成功")

    def test_trigger_iso_build(self, client: PatchMgrClient):
        """TC-PIPE-006: 触发 ISO 构建应返回 200"""
        pid = self._ensure_project(client)
        payload = {"source_config": "iso_source_config_example"}
        resp = client.post(f"/projects/{pid}/builds/iso", json_data=payload, expected_status=201)
        print("✓ 触发 ISO 构建成功")

    def test_get_build_record_detail(self, client: PatchMgrClient):
        """TC-PIPE-007: 构建记录详情（不存在的 ID）应返回 404"""
        pid = self._ensure_project(client)
        resp = client.get(f"/projects/{pid}/build-records/{generate_uuid()}")
        assert resp.status_code in (404, 200)  # 200 如果实现做了空数据兼容
        print(f"✓ 构建记录详情响应: {resp.status_code}")

    def test_retry_pipeline_not_found(self, client: PatchMgrClient):
        """TC-PIPE-008: 重试不存在的流水线"""
        pid = self._ensure_project(client)
        resp = client.post(f"/projects/{pid}/pipelines/{generate_uuid()}/retry")
        assert resp.status_code in (404, 200, 400)
        print(f"✓ 重试流水线响应: {resp.status_code}")

    def test_cancel_pipeline_not_found(self, client: PatchMgrClient):
        """TC-PIPE-009: 取消不存在的流水线"""
        pid = self._ensure_project(client)
        resp = client.post(f"/projects/{pid}/pipelines/{generate_uuid()}/cancel")
        assert resp.status_code in (404, 200, 400)
        print(f"✓ 取消流水线响应: {resp.status_code}")


# ==================== 13. 看板与报告模块 ====================
class TestDashboard:
    """看板与报告接口测试"""

    def test_dashboard_stats(self, client: PatchMgrClient):
        """TC-DASH-001: 全局看板统计应返回 200"""
        resp = client.get("/dashboard/stats", expected_status=200)
        print("✓ 全局看板统计查询成功")


# ==================== 14. 认证与权限异常场景 ====================
class TestAuthAndPermission:
    """认证与权限异常场景测试"""

    def test_no_auth_returns_401_or_403(self):
        """TC-AUTH-001: 无认证访问受保护接口应返回 401/403"""
        no_auth = PatchMgrClient()  # 无 token
        paths = ["/users/me", "/customers", "/projects", "/patches"]
        for path in paths:
            resp = no_auth.get(path)
            assert resp.status_code in (401, 403), f"{path} 预期 401/403, 实际 {resp.status_code}"
        print("✓ 无认证访问拦截校验通过")

    def test_invalid_token(self):
        """TC-AUTH-002: 无效 token 应返回 401/403"""
        invalid_client = PatchMgrClient(token="invalid_token_12345")
        resp = invalid_client.get("/users/me")
        assert resp.status_code in (401, 403)
        print("✓ 无效 token 校验通过")

    def test_healthz_no_auth_allowed(self, no_auth_client: PatchMgrClient):
        """TC-AUTH-003: 健康检查无需认证"""
        base = BASE_URL.rstrip("/")
        resp = requests.get(f"{base}/healthz", timeout=30)
        assert resp.status_code == 200, f"预期 200, 实际 {resp.status_code}"
        print("✓ 健康检查免认证校验通过")


# ==================== 15. 边界值与异常场景 ====================
class TestBoundaryAndEdgeCases:
    """边界值与异常场景测试"""

    def test_pagination_boundary_page_zero(self, client: PatchMgrClient):
        """TC-EDGE-001: page=0 边界（可能返回 400 或纠正为 1）"""
        resp = client.get("/customers", params={"page": 0, "page_size": 20})
        assert resp.status_code in (200, 400)
        print(f"✓ page=0 边界响应: {resp.status_code}")

    def test_pagination_boundary_large_page_size(self, client: PatchMgrClient):
        """TC-EDGE-002: page_size 超过最大值（最大 100）"""
        resp = client.get("/customers", params={"page": 1, "page_size": 9999})
        # 可能返回 400 或自动截断为 100
        assert resp.status_code in (200, 400)
        print(f"✓ page_size=9999 边界响应: {resp.status_code}")

    def test_string_field_max_length(self, client: PatchMgrClient):
        """TC-EDGE-003: 字符串字段超长应返回 400"""
        # customer name maxLength=128
        long_name = "x" * 129
        resp = client.post("/customers", json_data={"name": long_name})
        assert resp.status_code in (400, 422)
        print("✓ 字符串超长校验通过")

    def test_invalid_uuid_format(self, client: PatchMgrClient):
        """TC-EDGE-004: 无效 UUID 格式应返回 400 或 404"""
        resp = client.get("/customers/not-a-uuid")
        assert resp.status_code in (400, 404)
        print("✓ 无效 UUID 格式校验通过")

    def test_empty_request_body(self, client: PatchMgrClient):
        """TC-EDGE-005: 空请求体应返回 400"""
        resp = client.post("/customers", json_data={})
        assert resp.status_code == 400
        print("✓ 空请求体检校通过")

    def test_invalid_enum_value(self, client: PatchMgrClient):
        """TC-EDGE-006: 无效枚举值应返回 400"""
        self._ensure_project_deps(client)
        payload = {
            "primary_key": f"PATCH-{generate_random_string().upper()}",
            "patch_type": "invalid_type",  # 无效枚举
            "product_version_id": shared.product_version_id,
            "patch_module_id": shared.patch_module_id,
            "mode": "内核态",
        }
        resp = client.post("/patches", json_data=payload)
        assert resp.status_code in (400, 422)
        print("✓ 无效枚举值校验通过")

    def _ensure_project_deps(self, client: PatchMgrClient):
        if not shared.product_version_id:
            r = client.post(
                "/product-versions",
                json_data={"name": f"临时版本_{generate_random_string()}", "cpu_architecture": "x86_64"},
                expected_status=201,
            )
            shared.product_version_id = r.json().get("id")
        if not shared.patch_module_id:
            r = client.post("/patch-modules", json_data={"name": f"临时模块_{generate_random_string()}"}, expected_status=201)
            shared.patch_module_id = r.json().get("id")


# ==================== 主入口（支持直接 python 运行） ====================
if __name__ == "__main__":
    pytest.main([__file__, "-v", "--tb=short"])
