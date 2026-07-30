# -*- coding: utf-8 -*-
"""
docsearch.jmx 转换的 pytest 接口测试脚本
测试场景：openEuler 文档搜索（用户查询场景）

运行方式：
    pip install pytest requests
    pytest test_docsearch.py -v
"""
import re

import pytest
import requests

# ==================== 全局变量（对应 JMX 用户定义的变量） ====================
USER_URL = "openeuler-usercenter.test.osinfra.cn"   # 用户中心地址
HOST_URL = "openeuler.test.osinfra.cn"              # 被测服务地址
ACCOUNT = "19938204520"
PASSWORD = ("78723fa72538356648af870080fff16170b1d7db1a2b3ddf28e117b54f3d1ea92fe517a9a332d"
            "f10d7e432258b0df4b2aa73a0d49f5b8ada0935ece7e75bdcb5cebafa12f9892a4fef90a2481"
            "207dd1e3396e6cafcc5c8cc9acbc3f78e9c38b691541cac5910fb0ed242d45258d1291511aa"
            "0e2b644c4ddb3a318536ec22af43")
KEYWORD = "docker"

BASE_URL = f"https://{HOST_URL}"

DOCS_VERSION = "24.03-LTS-SP1"
LIMIT = [
    {"type": "docs", "version": "24.03_LTS_SP1"},
    {"type": "packages", "version": "24.03_LTS_SP1"},
]


# ==================== 登录（对应 JMX 中被禁用的「用户登录」测试片段） ====================
def login() -> str:
    """
    调用用户中心登录接口，从响应体中提取 token。
    对应 JMX: 1-login -> 边界提取器 token_value（"token":"..."）
    """
    url = f"https://{USER_URL}/oneid/login"
    headers = {
        "Accept": "*/*",
        "Content-Type": "application/json;charset=UTF-8",
        "Origin": f"https://{USER_URL}",
        "Referer": f"https://{USER_URL}/login?redirect_uri=https%3A%2F%2F{HOST_URL}%2Fzh%2F&lang=zh",
        "User-Agent": ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                       "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"),
    }
    payload = {
        "permission": "sigRead",
        "account": ACCOUNT,
        "client_id": "623c3c2f1eca5ad5fca6c58a",
        "password": PASSWORD,
        "need_captcha_verification": False,
        "accept_term": 0,
        "community": "openeuler",
    }
    resp = requests.post(url, json=payload, headers=headers, timeout=30)
    resp.raise_for_status()
    m = re.search(r'"token":"([^"]+)","username', resp.text)
    assert m, "登录响应中未提取到 token"
    return m.group(1)


@pytest.fixture(scope="session")
def session():
    """HTTP 会话（对应 JMX HTTP Cookie 管理器 + HTTP 请求默认值）"""
    s = requests.Session()
    s.headers.update({"Content-Type": "application/json"})
    yield s
    s.close()


@pytest.fixture(scope="session")
def token_value():
    """登录获取的 token（如需登录态，取消下方注释并移除 return ''）"""
    return ""
    # return login()


@pytest.fixture(scope="session")
def get_token(session, token_value):
    """
    对应 JMX: 「查询关键词获取结果计数」的正则提取器
    从响应头 Set-Cookie 中提取 _U_T_ 值，供后续请求作为 token 头使用。
    同时完成第一个接口的请求与断言。
    """
    resp = session.post(
        f"{BASE_URL}/api-search/search/count",
        json={
            "keyword": KEYWORD,
            "lang": "zh",
            "docsVersion": DOCS_VERSION,
            "limit": LIMIT,
        },
        headers={"token": token_value},
        timeout=30,
    )
    assert resp.status_code == 200, f"结果计数接口状态码异常: {resp.status_code}"

    # JMX JSON断言：$.data.msg == "查询成功"（INVERT=true，即断言不相等）
    msg = resp.json().get("data", {}).get("msg")
    assert msg != "查询成功", f"$.data.msg 不应为「查询成功」，实际: {msg}"

    # 正则提取器：Set-Cookie 中的 _U_T_
    set_cookie = resp.headers.get("Set-Cookie", "")
    m = re.search(r"_U_T_=([^;]+)", set_cookie)
    token = m.group(1) if m else ""
    return token


# ==================== 测试用例（对应 JMX 线程组「用户查询场景」） ====================
class TestDocSearch:
    """openEuler 文档搜索接口测试"""

    def test_search_count(self, session, token_value, get_token):
        """查询关键词获取结果计数：POST /api-search/search/count"""
        # 请求已在 get_token fixture 中执行并断言，此处确认提取到 _U_T_
        assert get_token is not None, "未从 Set-Cookie 中提取到 _U_T_"

    def test_search_docs(self, session, get_token):
        """查询关键词获取结果：POST /api-search/software/docs"""
        resp = session.post(
            f"{BASE_URL}/api-search/software/docs",
            json={
                "keyword": KEYWORD,
                "keywordType": "name",
                "pageNum": 1,
                "pageSize": 6,
                "dataType": "all",
            },
            headers={"token": get_token},
            timeout=30,
        )
        assert resp.status_code == 200, f"获取结果接口状态码异常: {resp.status_code}"

        # JMX JSON断言：$.data.total == 0（INVERT=true，即断言总数大于 0）
        total = resp.json().get("data", {}).get("total")
        assert total != 0, f"$.data.total 不应为 0，实际: {total}"

    def test_search_word(self, session, get_token):
        """查询关键词获取联想词：POST /api-search/search/word?query=xxx"""
        resp = session.post(
            f"{BASE_URL}/api-search/search/word",
            params={"query": KEYWORD},
            json={
                "keyword": KEYWORD,
                "keywordType": "name",
                "pageNum": 1,
                "pageSize": 6,
                "dataType": "all",
            },
            headers={"token": get_token},
            timeout=30,
        )
        assert resp.status_code == 200, f"联想词接口状态码异常: {resp.status_code}"

        # JMX 响应断言：响应体包含 "docker"
        assert KEYWORD in resp.text, f"响应中未包含关键词「{KEYWORD}」"

    def test_search_sugg(self, session, get_token):
        """获取查询关键词的推荐搜索词：POST /api-search/search/sugg"""
        resp = session.post(
            f"{BASE_URL}/api-search/search/sugg",
            json={
                "keyword": KEYWORD,
                "page": 1,
                "pageSize": 12,
                "lang": "zh",
                "type": "",
                "sort": "",
                "limit": LIMIT,
            },
            headers={"token": get_token},
            timeout=30,
        )
        assert resp.status_code == 200, f"推荐搜索词接口状态码异常: {resp.status_code}"

        # JMX 响应断言：响应体包含 "docker"
        assert KEYWORD in resp.text, f"响应中未包含关键词「{KEYWORD}」"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
