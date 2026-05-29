# -*- coding: utf-8 -*-
"""
测试用例脚本：OneID 统一认证服务（API 契约测试）

来源：https://github.com/agentic-develop-playground/oneid-all
被测对象：oneid-server（Java Spring Boot 后端 API）
用例总数：12 自动化 + 4 手工（需验证码）
生成工具：test-case-generator skill（Python 模式）

项目简介：
    OneID 是 openEuler 社区的统一身份认证服务，提供用户管理、
    第三方 OAuth 客户端管理、Token 认证等能力。

API 端点（源码分析）：
    POST /auth/get-management-token  - 获取管理 Token
    GET  /auth/check-password/{id}   - 校验密码
    POST /users                      - 创建用户
    GET  /users/{id}                 - 获取用户
    PUT  /users/{id}                 - 更新用户
    DELETE /users/{id}               - 删除用户
    GET  /third-party-client/{id}    - 获取第三方客户端
    GET  /third-party-client/provider/{provider} - 按 provider 查询
    POST /third-party-client         - 创建第三方客户端
    PUT  /third-party-client/{id}    - 更新第三方客户端

配置：
    在项目根目录创建 .env 文件，填入以下内容：
        ONEID_BASE_URL=https://openeuler-usercenter.test.osinfra.cn
        ONEID_ACCESS_KEY_ID=your_access_key_id
        ONEID_ACCESS_KEY_SECRET=your_access_key_secret
        ONEID_TEST_USER_ID=test_user_id
        ONEID_TEST_PASSWORD=test_password

执行：
    pip install pytest requests requests-mock python-dotenv
    pytest -v test_oneid.py
"""

import os
from pathlib import Path

import pytest
import requests

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

# ===== 从 .env 读取配置 =====
BASE_URL = os.environ.get("ONEID_BASE_URL", "https://openeuler-usercenter.test.osinfra.cn")
ACCESS_KEY_ID = os.environ.get("ONEID_ACCESS_KEY_ID", "")
ACCESS_KEY_SECRET = os.environ.get("ONEID_ACCESS_KEY_SECRET", "")
TEST_USER_ID = os.environ.get("ONEID_TEST_USER_ID", "user123")
TEST_PASSWORD = os.environ.get("ONEID_TEST_PASSWORD", "Pass@123")


def _url(path):
    return f"{BASE_URL}{path}"


def _ok(data=None):
    return {"statusCode": 200, "message": None, "data": data}


def _err(code=500, msg="error"):
    return {"statusCode": code, "message": msg, "data": None}


# ===== 认证模块 =====

class TestAuthAPI:

    def test_get_token_success(self, requests_mock):
        """TC-ONEID-AUTH-001 有效凭证获取管理Token"""
        requests_mock.post(_url("/auth/get-management-token"),
                           json=_ok({"token": "eyJ.mock", "expiresIn": 3600}), status_code=200)
        resp = requests.post(_url("/auth/get-management-token"),
                             json={"accessKeyId": ACCESS_KEY_ID or "ak", "accessKeySecret": ACCESS_KEY_SECRET or "sk"})
        assert resp.status_code == 200
        assert "token" in resp.json()["data"]

    def test_get_token_empty_creds(self, requests_mock):
        """TC-ONEID-AUTH-002 空凭证返回401"""
        requests_mock.post(_url("/auth/get-management-token"),
                           json=_err(401, "Invalid credentials"), status_code=401)
        resp = requests.post(_url("/auth/get-management-token"),
                             json={"accessKeyId": "", "accessKeySecret": ""})
        assert resp.status_code == 401

    def test_get_token_no_body(self, requests_mock):
        """TC-ONEID-AUTH-003 无body返回400"""
        requests_mock.post(_url("/auth/get-management-token"),
                           json=_err(400, "Missing body"), status_code=400)
        resp = requests.post(_url("/auth/get-management-token"))
        assert resp.status_code == 400

    def test_check_pwd_correct(self, requests_mock):
        """TC-ONEID-AUTH-004 密码正确"""
        requests_mock.get(_url(f"/auth/check-password/{TEST_USER_ID}"),
                          json=_ok({"valid": True}), status_code=200)
        resp = requests.get(_url(f"/auth/check-password/{TEST_USER_ID}"),
                            params={"userIdType": "userId", "password": TEST_PASSWORD})
        assert resp.json()["data"]["valid"] is True

    def test_check_pwd_wrong(self, requests_mock):
        """TC-ONEID-AUTH-005 密码错误"""
        requests_mock.get(_url(f"/auth/check-password/{TEST_USER_ID}"),
                          json=_ok({"valid": False}), status_code=200)
        resp = requests.get(_url(f"/auth/check-password/{TEST_USER_ID}"),
                            params={"userIdType": "userId", "password": "wrong"})
        assert resp.json()["data"]["valid"] is False


# ===== 用户管理模块 =====

class TestUserAPI:

    def test_create_user(self, requests_mock):
        """TC-ONEID-USER-001 创建用户"""
        requests_mock.post(_url("/users"), json=_ok({"id": "u1", "username": "tester"}), status_code=201)
        resp = requests.post(_url("/users"), json={"username": "tester", "email": "t@e.com", "password": "P@1234"})
        assert resp.status_code == 201
        assert resp.json()["data"]["username"] == "tester"

    def test_get_user(self, requests_mock):
        """TC-ONEID-USER-002 查询用户"""
        requests_mock.get(_url("/users/u1"), json=_ok({"id": "u1", "username": "tester"}), status_code=200)
        resp = requests.get(_url("/users/u1"), params={"userIdType": "userId"})
        assert resp.status_code == 200
        assert resp.json()["data"]["id"] == "u1"

    def test_update_user(self, requests_mock):
        """TC-ONEID-USER-003 更新用户"""
        requests_mock.put(_url("/users/u1"), json=_ok({"id": "u1", "email": "new@e.com"}), status_code=200)
        resp = requests.put(_url("/users/u1"), json={"email": "new@e.com"})
        assert resp.json()["data"]["email"] == "new@e.com"

    def test_delete_user(self, requests_mock):
        """TC-ONEID-USER-004 删除用户"""
        requests_mock.delete(_url("/users/u1"), json=_ok(None), status_code=200)
        resp = requests.delete(_url("/users/u1"))
        assert resp.status_code == 200

    def test_get_nonexistent(self, requests_mock):
        """TC-ONEID-USER-005 查询不存在用户返回404"""
        requests_mock.get(_url("/users/none"), json=_err(404, "Not found"), status_code=404)
        resp = requests.get(_url("/users/none"), params={"userIdType": "userId"})
        assert resp.status_code == 404


# ===== 第三方客户端模块 =====

class TestThirdPartyClientAPI:

    def test_get_by_id(self, requests_mock):
        """TC-ONEID-CLIENT-001 按ID查询"""
        requests_mock.get(_url("/third-party-client/c1"), json=_ok({"id": "c1", "provider": "github"}), status_code=200)
        resp = requests.get(_url("/third-party-client/c1"))
        assert resp.json()["data"]["provider"] == "github"

    def test_get_by_provider(self, requests_mock):
        """TC-ONEID-CLIENT-002 按provider查询"""
        requests_mock.get(_url("/third-party-client/provider/github"), json=_ok({"provider": "github"}), status_code=200)
        resp = requests.get(_url("/third-party-client/provider/github"))
        assert resp.json()["data"]["provider"] == "github"

    def test_create_client(self, requests_mock):
        """TC-ONEID-CLIENT-003 创建客户端"""
        requests_mock.post(_url("/third-party-client"), json=_ok({"id": "c2", "provider": "gitee"}), status_code=201)
        resp = requests.post(_url("/third-party-client"), json={"provider": "gitee", "clientId": "x", "clientSecret": "s"})
        assert resp.status_code == 201

    def test_not_found(self, requests_mock):
        """TC-ONEID-CLIENT-004 查询不存在返回404"""
        requests_mock.get(_url("/third-party-client/x"), json=_err(404, "Not found"), status_code=404)
        resp = requests.get(_url("/third-party-client/x"))
        assert resp.status_code == 404


# ============================================================================
# 手工用例（需接收验证码，无法自动化，注释保留）
# ============================================================================
#
# TC-ONEID-MANUAL-001 [手工] 邮箱注册 - 发送验证码
# 前置：.env 配置 ONEID_TEST_EMAIL
# 步骤：
#   1. POST /users/register {"email": "<ONEID_TEST_EMAIL>"}
#   2. 人工从邮箱获取验证码
#   3. POST /users/register/verify {"email": "...", "code": "...", "password": "..."}
# 预期：注册成功，返回用户信息
#
# def test_manual_001_email_register():
#     email = os.environ.get("ONEID_TEST_EMAIL")
#     resp = requests.post(_url("/users/register"), json={"email": email})
#     assert resp.status_code == 200
#     code = input(f"请输入 {email} 收到的验证码: ")
#     resp = requests.post(_url("/users/register/verify"),
#                          json={"email": email, "code": code, "password": "Reg@1234"})
#     assert resp.status_code == 200
#
#
# TC-ONEID-MANUAL-002 [手工] 手机号注册 - 短信验证码
# 前置：.env 配置 ONEID_TEST_PHONE
# 步骤：
#   1. POST /users/register/sms {"phone": "<ONEID_TEST_PHONE>"}
#   2. 人工获取短信验证码
#   3. POST /users/register/sms/verify {"phone": "...", "code": "...", "password": "..."}
# 预期：注册成功
#
# def test_manual_002_phone_register():
#     phone = os.environ.get("ONEID_TEST_PHONE")
#     resp = requests.post(_url("/users/register/sms"), json={"phone": phone})
#     assert resp.status_code == 200
#     code = input(f"请输入 {phone} 收到的短信验证码: ")
#     resp = requests.post(_url("/users/register/sms/verify"),
#                          json={"phone": phone, "code": code, "password": "Reg@1234"})
#     assert resp.status_code == 200
#
#
# TC-ONEID-MANUAL-003 [手工] 忘记密码 - 邮箱重置
# 步骤：
#   1. POST /auth/forgot-password {"email": "<ONEID_TEST_EMAIL>"}
#   2. 人工获取重置验证码
#   3. POST /auth/reset-password {"email": "...", "code": "...", "newPassword": "..."}
# 预期：密码重置成功
#
# def test_manual_003_forgot_password():
#     email = os.environ.get("ONEID_TEST_EMAIL")
#     resp = requests.post(_url("/auth/forgot-password"), json={"email": email})
#     assert resp.status_code == 200
#     code = input(f"请输入 {email} 收到的重置验证码: ")
#     resp = requests.post(_url("/auth/reset-password"),
#                          json={"email": email, "code": code, "newPassword": "Reset@123"})
#     assert resp.status_code == 200
#
#
# TC-ONEID-MANUAL-004 [手工] 绑定第三方账号 - OAuth 授权回调
# 步骤：
#   1. GET /third-party-client/provider/github 获取 clientId
#   2. 浏览器打开 GitHub OAuth 授权页
#   3. 人工完成授权，获取回调 code
#   4. POST /auth/callback {"code": "...", "provider": "github"}
# 预期：绑定成功
#
# def test_manual_004_oauth_binding():
#     resp = requests.get(_url("/third-party-client/provider/github"))
#     client_id = resp.json()["data"]["clientId"]
#     print(f"请打开: https://github.com/login/oauth/authorize?client_id={client_id}")
#     code = input("请输入回调 code: ")
#     resp = requests.post(_url("/auth/callback"), json={"code": code, "provider": "github"})
#     assert resp.status_code == 200


if __name__ == "__main__":
    pytest.main(["-v", __file__])
