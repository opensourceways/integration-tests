# -*- coding: utf-8 -*-
"""
pytest 自动加载的共享配置文件。

声明的 fixture 会被同目录下所有 test_*.py 自动使用，
无需各测试文件 import。
"""

import pytest

from common import (
    BASE,
    GITCODE_TOKEN,
    HTTP_VERBOSE,
    _auth_headers,
    _delete_issue,
    _send,
    set_current_case_id,
    get_created_issue_numbers,
)


@pytest.fixture(autouse=True)
def _capture_case_id(request):
    """每个用例开始/结束时打印分隔符，并更新 common._current_case_id 用于 HTTP 日志关联"""
    set_current_case_id(request.node.name)
    if HTTP_VERBOSE:
        print(f"\n========== [CASE START] {request.node.name} ==========")
    yield
    if HTTP_VERBOSE:
        print(f"========== [CASE END]   {request.node.name} ==========\n")
    set_current_case_id("<no-case>")


@pytest.fixture(scope="session", autouse=True)
def _cleanup_created_issues():
    """session 结束后批量删除本次运行中创建的所有 Issue"""
    yield
    created = get_created_issue_numbers()
    if not GITCODE_TOKEN or not created:
        return
    print(f"\n[CLEANUP] 删除本次创建的 {len(created)} 个 Issue...")
    for i, number in enumerate(created, 1):
        try:
            resp = _delete_issue(number)
            status = resp.status_code if resp else "N/A"
            print(f"  [{i}/{len(created)}] Issue#{number} → {status}")
        except Exception as e:
            print(f"  [{i}/{len(created)}] Issue#{number} → 删除失败: {e}")


@pytest.fixture(scope="session")
def my_login():
    """取当前 token 持有者 login，用于多个用例验证"""
    if not GITCODE_TOKEN:
        pytest.skip("环境变量 GITCODE_TOKEN 未设置")
    resp = _send("GET", f"{BASE}/user", headers=_auth_headers())
    assert resp.status_code == 200, f"获取当前用户失败 status={resp.status_code}"
    login = resp.json().get("login")
    assert login, "无法获取 token 持有者 login"
    return login
