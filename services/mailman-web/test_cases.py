"""
QuickIssue API 自动化测试脚本
=============================
Base URL: https://quickissue.openeuler.org
用例总数: 34 条 | 可自动化: 34 | 手工: 0
P0: 14 | P1: 12 | P2: 8
覆盖维度: 正常流程、边界值、空值、异常输入、特殊字符、重复操作

依赖:
  pip install pytest requests

推荐执行命令:
  pytest test_quickissue_api.py -v --tb=short
"""

import pytest
import requests

BASE_URL = "https://quickissue.openeuler.org"
HEADERS = {"Content-Type": "application/json"}


class TestIssueList:
    """Issue 列表接口测试"""

    def test_get_all_issues_normal(self):
        """[正常流] 获取全部 Issue 列表 - 默认分页排序"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "direction": "desc", "sort": "created_at"},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["total"] != 0

    def test_get_issues_search_by_number(self):
        """[正常流] 按 Issue 编号搜索"""
        search_value = "3860992"
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "search": search_value},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert str(data["data"][0]["number"]) == search_value

    def test_get_issues_page_zero(self):
        """[边界值] page=0 时接口应正常响应"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 0, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_issues_per_page_zero(self):
        """[边界值] per_page=0 时接口应正常响应"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 0},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_issues_per_page_large(self):
        """[边界值] per_page=9999 超大值，服务端应返回 400 拒绝"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 9999},
            headers=HEADERS,
        )
        assert resp.status_code == 400

    def test_get_issues_invalid_direction(self):
        """[异常输入] direction 传非法值"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "direction": "invalid_xyz"},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_issues_invalid_sort(self):
        """[异常输入] sort 传非法字段"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "sort": "nonexist_field"},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_issues_search_not_found(self):
        """[异常输入] search 传不存在的编号，接口为模糊搜索可能仍返回结果"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "search": "0000000"},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert "total" in data

    def test_get_issues_search_special_chars(self):
        """[特殊字符] search 含 XSS 字符，WAF 拦截返回 418"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues",
            params={"page": 1, "per_page": 10, "search": "<script>alert(1)</script>"},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 403, 418)

    def test_get_issues_repeat_request(self):
        """[重复操作] 连续两次相同请求结果一致（幂等性）"""
        params = {"page": 1, "per_page": 10, "direction": "desc", "sort": "created_at"}
        resp1 = requests.get(f"{BASE_URL}/api-issues/issues", params=params, headers=HEADERS)
        resp2 = requests.get(f"{BASE_URL}/api-issues/issues", params=params, headers=HEADERS)
        assert resp1.status_code == resp2.status_code == 200
        assert resp1.json()["total"] == resp2.json()["total"]


class TestIssueFields:
    """Issue 相关字段接口测试"""

    def test_get_issue_authors_normal(self):
        """[正常流] 获取全部 Issue 提交人名称"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/authors",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_issue_labels_normal(self):
        """[正常流] 获取全部 Issue 标签"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/labels",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_issue_branches_normal(self):
        """[正常流] 获取全部 Issue 分支（当前数据可能为空）"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/branches",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert "total" in resp.json()

    def test_get_issue_types_normal(self):
        """[正常流] 获取全部 Issue 类型（返回结构为 code/msg/data）"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/types",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["code"] == 200
        assert len(data["data"]) > 0

    def test_get_issue_repos_normal(self):
        """[正常流] 获取全部 Issue 仓库"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/repos",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_issue_milestones_normal(self):
        """[正常流] 获取全部 Issue 里程碑"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/milestones",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_issue_authors_page_negative(self):
        """[边界值] authors 接口 page=-1"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/authors",
            params={"page": -1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_issue_labels_no_params(self):
        """[空值] labels 接口不传任何参数"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/issues/labels",
            headers=HEADERS,
        )
        assert resp.status_code == 200


class TestPullRequestList:
    """PR 列表接口测试"""

    def test_get_all_pulls_normal(self):
        """[正常流] 获取全部 PR 列表 - 默认分页排序"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls",
            params={"page": 1, "per_page": 10, "direction": "desc", "sort": "created_at"},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["total"] != 0

    def test_get_pulls_direction_asc(self):
        """[正常流] PR 列表升序排列"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls",
            params={"page": 1, "per_page": 10, "direction": "asc", "sort": "created_at"},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_pulls_page_zero(self):
        """[边界值] PR 列表 page=0"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls",
            params={"page": 0, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_pulls_invalid_direction(self):
        """[异常输入] PR 列表 direction 传非法值"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls",
            params={"page": 1, "per_page": 10, "direction": "WRONG"},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_pulls_no_params(self):
        """[空值] PR 列表不传任何参数"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls",
            headers=HEADERS,
        )
        assert resp.status_code == 200

    def test_get_pulls_repeat_request(self):
        """[重复操作] PR 列表连续请求结果一致"""
        params = {"page": 1, "per_page": 10, "direction": "desc", "sort": "created_at"}
        resp1 = requests.get(f"{BASE_URL}/api-issues/pulls", params=params, headers=HEADERS)
        resp2 = requests.get(f"{BASE_URL}/api-issues/pulls", params=params, headers=HEADERS)
        assert resp1.status_code == resp2.status_code == 200
        assert resp1.json()["total"] == resp2.json()["total"]


class TestPullRequestFields:
    """PR 相关字段接口测试"""

    def test_get_pr_authors_normal(self):
        """[正常流] 获取全部 PR 提交人名称"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/authors",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_pr_labels_normal(self):
        """[正常流] 获取全部 PR 标签"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/labels",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_pr_refs_normal(self):
        """[正常流] 获取全部 PR 版本"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/refs",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_pr_repos_normal(self):
        """[正常流] 获取全部 PR 仓库"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/repos",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        assert resp.json()["total"] != 0

    def test_get_pr_sigs_normal(self):
        """[正常流] 获取全部 PR 的 SIG 组（返回结构为 code/msg/data）"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/sigs",
            params={"page": 1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code == 200
        data = resp.json()
        assert data["code"] == 200
        assert len(data["data"]) > 0

    def test_get_pr_authors_page_negative(self):
        """[边界值] PR authors 接口 page=-1"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/authors",
            params={"page": -1, "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_pr_repos_no_params(self):
        """[空值] PR repos 接口不传任何参数"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/repos",
            headers=HEADERS,
        )
        assert resp.status_code == 200

    def test_get_pr_labels_per_page_string(self):
        """[异常输入] PR labels per_page 传字符串"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/labels",
            params={"page": 1, "per_page": "abc"},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)

    def test_get_pr_refs_special_chars_page(self):
        """[特殊字符] PR refs page 含特殊字符"""
        resp = requests.get(
            f"{BASE_URL}/api-issues/pulls/refs",
            params={"page": "<>", "per_page": 10},
            headers=HEADERS,
        )
        assert resp.status_code in (200, 400, 422)
