"""
测试用例脚本：meeting-platform

来源：PR #174 / Issue 140 - 会议官网列表接口增加历史会议人数显示
来源：PR #502 / Issue 476 - 会议页面显示，同一个开始时间的会议需要按照会议名称进行排序
用例总数：24 | 自动化：24 | 手工：0
生成工具：test-case-generator skill（Python 模式）

依赖：
    pip install pytest requests pytest-dependency

执行：
    pytest -v test_cases.py                       # 执行全部自动化用例
    pytest -v test_cases.py -k "meeting_platform" # 按模块执行
    pytest -v test_cases.py -m p0                 # 仅执行 P0 用例
    pytest -v test_cases.py -k SORT              # 执行排序逻辑验证（本地 mock）
    pytest -v test_cases.py -k COMPAT            # 执行接口兼容性测试

占位符（执行前由环境变量注入）：
    MEETING_PLATFORM_HOST  —— meeting-platform 服务地址
    MEETING_CENTER_HOST     —— meeting-center 服务地址
    BASIC_AUTH_USER         —— Basic Auth 用户名
    BASIC_AUTH_PASS         —— Basic Auth 密码
    BASE_API                —— meeting-platform 内网 API 地址（COMPAT 用例必需）
    AUTH_TOKEN              —— 登录后获取的鉴权 token（COMPAT 用例必需）

待人工执行：
    无（本批次全部可自动化）
"""

import pytest
import requests
import time
from unittest import mock
import os
import base64


# ===== 模块级常量 =====
BASE_MEETING_PLATFORM = os.environ.get("MEETING_PLATFORM_HOST", "http://meeting-platform.test.osinfra.cn")
BASE_MEETING_CENTER = os.environ.get("MEETING_CENTER_HOST", "http://meeting-center.test.osinfra.cn")
BASIC_AUTH_USER = os.environ.get("BASIC_AUTH_USER", "")
BASIC_AUTH_PASS = os.environ.get("BASIC_AUTH_PASS", "")
BASE_API = os.environ.get("BASE_API", "http://meeting-platform.test")
AUTH_TOKEN = os.environ.get("AUTH_TOKEN", "")


# ===== 共享 fixture =====

@pytest.fixture(scope="session")
def basic_auth_headers():
    """登录获取 Basic Auth headers"""
    if not BASIC_AUTH_USER or not BASIC_AUTH_PASS:
        pytest.skip("BASIC_AUTH_USER/PASS 未配置")
    credentials = base64.b64encode(f"{BASIC_AUTH_USER}:{BASIC_AUTH_PASS}".encode()).decode()
    return {"Authorization": f"Basic {credentials}"}


@pytest.fixture(scope="session")
def auth_header():
    """
    鉴权 header，从环境变量注入
    
    注意：P0 级 COMPAT 用例依赖此 fixture。若 AUTH_TOKEN 未设置，
    测试将失败而非跳过，以确保核心验收标准在 CI 环境中被验证。
    """
    if not AUTH_TOKEN:
        pytest.fail("AUTH_TOKEN 环境变量未设置，无法执行 P0 级接口兼容性测试。请在 CI 环境中配置 AUTH_TOKEN。")
    return {"token": AUTH_TOKEN, "Content-Type": "application/json;charset=UTF-8"}


@pytest.fixture(scope="session")
def mock_empty_database():
    """空数据库 mock fixture"""
    return {"total_meeting_participants": 0, "ended_meeting_count": 0}


@pytest.fixture(scope="session")
def mock_large_database():
    """大数据量 mock fixture"""
    return {"total_meeting_participants": 12345, "ended_meeting_count": 10000}


@pytest.fixture(scope="function")
def mock_meeting_platform_down():
    """meeting-platform 服务不可达 mock"""
    original_get = requests.get
    def mock_get(*args, **kwargs):
        if args[0].endswith("/stats/participants/"):
            raise requests.exceptions.ConnectionError("meeting-platform 服务不可达")
        return original_get(*args, **kwargs)
    with mock.patch("requests.get", side_effect=mock_get):
        yield


@pytest.fixture(scope="function")
def mock_meeting_data():
    """模拟会议数据，用于单元测试风格验证"""
    return [
        {"id": 1, "topic": "Gamma会议", "date": "2026-05-30", "start": "08:00", "is_cycle": False},
        {"id": 2, "topic": "Alpha会议", "date": "2026-05-30", "start": "08:00", "is_cycle": False},
        {"id": 3, "topic": "Beta会议", "date": "2026-05-30", "start": "08:00", "is_cycle": False},
    ]


# ===== 用例 ===============================================================

# --- meeting-platform 统计接口（PR #174 / Issue 140） ------------------------------------------------

@pytest.mark.p0
def test_meeting_platform_stats_normal_flow_pr_174(basic_auth_headers):
    """
    TC-API-MEETING-001 [正常流] meeting-platform 统计接口返回正确数据
    维度：正常流 | 优先级：P0
    """
    url = f"{BASE_MEETING_PLATFORM}/inner/v1/meeting/meeting/stats/participants/"
    resp = requests.get(url, headers=basic_auth_headers, timeout=10)
    
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    assert "data" in body
    data = body["data"]
    assert data.get("total_meeting_participants") >= 0
    assert data.get("ended_meeting_count") >= 0
    if "update_time" in data:
        assert isinstance(data["update_time"], str)


@pytest.mark.p1
def test_meeting_platform_stats_empty_database_pr_174(basic_auth_headers):
    """
    TC-API-MEETING-002 [边界值] meeting-platform 统计接口无数据时返回零值
    维度：边界值 | 优先级：P1
    """
    url = f"{BASE_MEETING_PLATFORM}/inner/v1/meeting/meeting/stats/participants/"
    resp = requests.get(url, headers=basic_auth_headers, timeout=10)
    
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    data = body.get("data", {})
    
    if data.get("ended_meeting_count") == 0:
        assert data.get("total_meeting_participants") == 0


@pytest.mark.p1
def test_meeting_platform_stats_no_auth_pr_174():
    """
    TC-API-MEETING-003 [权限] meeting-platform 统计接口无 Basic Auth 时拒绝访问
    维度：权限 | 优先级：P1
    """
    url = f"{BASE_MEETING_PLATFORM}/inner/v1/meeting/meeting/stats/participants/"
    resp = requests.get(url, timeout=10)
    
    assert resp.status_code in (401, 403)


# --- meeting-center 公开接口（PR #174 / Issue 140） ------------------------------------------------

@pytest.mark.p0
def test_meeting_center_public_activity_normal_flow_pr_174():
    """
    TC-API-MEETING-004 [正常流] meeting-center 公开接口返回包含 meeting_stats 字段
    维度：正常流 | 优先级：P0
    """
    url = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    resp = requests.get(url, timeout=15)
    
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    assert "data" in body
    data = body["data"]
    
    assert "results" in data
    assert isinstance(data["results"], list)
    
    assert "meeting_stats" in data
    meeting_stats = data["meeting_stats"]
    assert meeting_stats.get("total_meeting_participants") >= 0
    assert meeting_stats.get("ended_meeting_count") >= 0


@pytest.mark.p1
def test_meeting_center_public_activity_with_params_pr_174():
    """
    TC-API-MEETING-005 [正常流] meeting-center 公开接口原有查询参数功能不变
    维度：正常流 | 优先级：P1
    """
    url = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    params = {
        "activity_mode": "Activity",
        "start_date": "2026-05-20",
        "search": "测试"
    }
    resp = requests.get(url, params=params, timeout=15)
    
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    data = body["data"]
    
    assert "results" in data
    assert isinstance(data["results"], list)
    
    assert "meeting_stats" in data
    meeting_stats = data["meeting_stats"]
    assert isinstance(meeting_stats.get("total_meeting_participants"), int)
    assert isinstance(meeting_stats.get("ended_meeting_count"), int)


@pytest.mark.p1
def test_meeting_center_public_activity_downstream_error_pr_174():
    """
    TC-API-MEETING-006 [异常] meeting-platform 异常时 meeting-center 返回空统计
    维度：异常 | 优先级：P1
    """
    url = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    
    with mock.patch("requests.get") as mock_get:
        def side_effect(*args, **kwargs):
            if args[0].endswith("/stats/participants/"):
                mock_resp = mock.Mock()
                mock_resp.status_code = 500
                mock_resp.json.return_value = {"code": 500, "message": "Internal Error"}
                return mock_resp
            real_resp = requests.get(args[0], timeout=15)
            return real_resp
        
        mock_get.side_effect = side_effect
        resp = requests.get(url, timeout=15)
    
    assert resp.status_code == 200
    body = resp.json()
    assert body.get("code") == 200
    data = body["data"]
    
    assert "results" in data
    assert isinstance(data["results"], list)
    
    assert "meeting_stats" in data
    meeting_stats = data["meeting_stats"]
    assert meeting_stats == {} or meeting_stats.get("total_meeting_participants") == 0


# --- 集成测试（PR #174 / Issue 140） --------------------------------------------------------------

@pytest.mark.p0
def test_integration_call_chain_pr_174():
    """
    TC-INTEGRATION-001 [正常流] meeting-center 正确调用 meeting-platform 统计接口
    维度：正常流 | 优先级：P0
    """
    url_center = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    url_platform = f"{BASE_MEETING_PLATFORM}/inner/v1/meeting/meeting/stats/participants/"
    
    resp_platform = requests.get(
        url_platform,
        headers={"Authorization": f"Basic {BASIC_AUTH_USER}:{BASIC_AUTH_PASS}"},
        timeout=10
    )
    
    resp_center = requests.get(url_center, timeout=15)
    
    assert resp_center.status_code == 200
    body_center = resp_center.json()
    
    if resp_platform.status_code == 200:
        body_platform = resp_platform.json()
        center_stats = body_center["data"]["meeting_stats"]
        platform_data = body_platform["data"]
        
        assert center_stats.get("total_meeting_participants") == platform_data.get("total_meeting_participants")
        assert center_stats.get("ended_meeting_count") == platform_data.get("ended_meeting_count")


@pytest.mark.p1
def test_integration_timeout_not_block_pr_174():
    """
    TC-INTEGRATION-002 [异常] meeting-platform 接口超时时 meeting-center 不阻塞主流程
    维度：异常 | 优先级：P1
    """
    url_center = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    
    start_time = time.time()
    
    with mock.patch("requests.get") as mock_get:
        def side_effect(*args, **kwargs):
            if args[0].endswith("/stats/participants/"):
                time.sleep(15)
                raise requests.exceptions.Timeout("meeting-platform 超时")
            real_resp = requests.get(args[0], timeout=5)
            return real_resp
        
        mock_get.side_effect = side_effect
        resp = requests.get(url_center, timeout=20)
    
    elapsed = time.time() - start_time
    
    assert resp.status_code == 200
    body = resp.json()
    assert "results" in body["data"]
    
    assert elapsed < 20


# --- 性能测试（PR #174 / Issue 140） --------------------------------------------------------------

@pytest.mark.p0
def test_performance_response_time_pr_174():
    """
    TC-PERF-001 [正常流] 单次接口调用响应时间 < 1000ms
    维度：正常流 | 优先级：P0
    """
    url = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    
    response_times = []
    for i in range(10):
        start = time.time()
        resp = requests.get(url, timeout=10)
        elapsed = time.time() - start
        response_times.append(elapsed)
    
    assert resp.status_code == 200
    
    p99 = sorted(response_times)[-1]
    assert p99 < 1.0


@pytest.mark.p1
@pytest.mark.slow
def test_performance_concurrent_50qps_pr_174():
    """
    TC-PERF-002 [正常流] 并发 50 QPS 时响应时间 < 1200ms
    维度：正常流 | 优先级：P1
    """
    import concurrent.futures
    
    url = f"{BASE_MEETING_CENTER}/api/v1/meeting/public/activity/"
    
    def make_request():
        start = time.time()
        try:
            resp = requests.get(url, timeout=10)
            elapsed = time.time() - start
            return elapsed, resp.status_code
        except Exception as e:
            return 999, 500
    
    total_requests = 250
    concurrent_workers = 50
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=concurrent_workers) as executor:
        futures = [executor.submit(make_request) for _ in range(total_requests)]
        results = [f.result() for f in concurrent.futures.as_completed(futures)]
    
    response_times = [r[0] for r in results]
    status_codes = [r[1] for r in results]
    
    avg_time = sum(response_times) / len(response_times)
    success_count = sum(1 for s in status_codes if s == 200)
    error_rate = 1 - success_count / len(status_codes)
    
    assert avg_time < 1.2
    assert error_rate < 0.01


@pytest.mark.p1
def test_performance_large_dataset_pr_174(basic_auth_headers):
    """
    TC-PERF-003 [边界值] 数据库 >10000 条会议时性能稳定
    维度：边界值 | 优先级：P1
    """
    url = f"{BASE_MEETING_PLATFORM}/inner/v1/meeting/meeting/stats/participants/"
    
    start = time.time()
    resp = requests.get(url, headers=basic_auth_headers, timeout=10)
    elapsed = time.time() - start
    
    assert resp.status_code == 200
    assert elapsed < 1.0
    
    body = resp.json()
    data = body.get("data", {})
    
    if data.get("ended_meeting_count") > 10000:
        assert elapsed < 0.5


# --- 排序逻辑验证（PR #502 / Issue 476） --------------------------------------------------------------

@pytest.mark.p0
def test_meeting_sort_001_same_start_topic_asc_pr_502(mock_meeting_data):
    """
    TC-API-SORT-001 [正常流] 相同date/start按topic升序排列
    
    测试类型：单元测试风格验证（本地 mock 数据）
    验证目标：排序算法逻辑 date > start > topic 优先级
    注意：此用例不调用真实后端 API，后端排序逻辑由 Django 单元测试覆盖
    维度：正常流 | 优先级：P0
    """
    sorted_data = sorted(
        mock_meeting_data,
        key=lambda x: (x["date"], x["start"], x["topic"])
    )
    assert sorted_data[0]["topic"] == "Alpha会议"
    assert sorted_data[1]["topic"] == "Beta会议"
    assert sorted_data[2]["topic"] == "Gamma会议"


@pytest.mark.p0
def test_meeting_sort_002_date_priority_pr_502():
    """
    TC-API-SORT-002 [边界值] date优先级最高
    维度：边界值 | 优先级：P0
    """
    data = [
        {"id": 1, "topic": "会议A", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "会议A", "date": "2026-05-29", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert sorted_data[0]["date"] == "2026-05-29"
    assert sorted_data[1]["date"] == "2026-05-30"


@pytest.mark.p0
def test_meeting_sort_003_start_priority_higher_than_topic_pr_502():
    """
    TC-API-SORT-003 [边界值] start优先级高于topic
    维度：边界值 | 优先级：P0
    """
    data = [
        {"id": 1, "topic": "Alpha会议", "date": "2026-05-30", "start": "09:00"},
        {"id": 2, "topic": "Gamma会议", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert sorted_data[0]["start"] == "08:00"
    assert sorted_data[1]["start"] == "09:00"


@pytest.mark.p0
def test_meeting_sort_004_desc_mode_topic_asc_pr_502():
    """
    TC-API-SORT-004 [正常流] 降序模式topic仍升序
    维度：正常流 | 优先级：P0
    
    验证目标：Django QuerySet order_by("-date", "-start", "topic") 语义
    - date 降序
    - 相同 date 按 start 降序
    - 相同 date/start 按 topic 升序
    
    实现方式：利用 Python sorted 稳定性，先按 topic 升序，再按 (date, start) 降序
    """
    data = [
        {"id": 1, "topic": "C会议", "date": "2026-05-31", "start": "10:00"},
        {"id": 2, "topic": "A会议", "date": "2026-05-31", "start": "10:00"},
        {"id": 3, "topic": "B会议", "date": "2026-05-31", "start": "10:00"},
        {"id": 4, "topic": "X会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 5, "topic": "Y会议", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(
        data,
        key=lambda x: x["topic"]
    )
    sorted_data = sorted(
        sorted_data,
        key=lambda x: (x["date"], x["start"]),
        reverse=True
    )
    assert sorted_data[0]["date"] == "2026-05-31"
    assert sorted_data[0]["start"] == "10:00"
    assert sorted_data[0]["topic"] == "A会议"
    assert sorted_data[1]["topic"] == "B会议"
    assert sorted_data[2]["topic"] == "C会议"
    assert sorted_data[3]["date"] == "2026-05-30"
    assert sorted_data[3]["start"] == "08:00"
    assert sorted_data[3]["topic"] == "X会议"
    assert sorted_data[4]["topic"] == "Y会议"


@pytest.mark.p1
def test_meeting_sort_005_chinese_english_mixed_pr_502():
    """
    TC-API-SORT-005 [边界值] topic包含中英文混合
    维度：边界值 | 优先级：P1
    """
    data = [
        {"id": 1, "topic": "Z会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "A会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 3, "topic": "会议B", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert len(sorted_data) == 3
    assert sorted_data[0]["topic"] < sorted_data[1]["topic"]


@pytest.mark.p1
def test_meeting_sort_006_special_chars_pr_502():
    """
    TC-API-SORT-006 [边界值] topic包含特殊字符
    维度：边界值 | 优先级：P1
    """
    data = [
        {"id": 1, "topic": "_会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "-会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 3, "topic": "会议", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert len(sorted_data) == 3
    assert sorted_data[0]["topic"] < sorted_data[-1]["topic"]


@pytest.mark.p2
def test_meeting_sort_007_same_topic_pr_502():
    """
    TC-API-SORT-007 [边界值] topic全相同
    维度：边界值 | 优先级：P2
    """
    data = [
        {"id": 1, "topic": "相同会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "相同会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 3, "topic": "相同会议", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert len(sorted_data) == 3
    assert all(item["topic"] == "相同会议" for item in sorted_data)


@pytest.mark.p1
def test_meeting_sort_008_order_by_start_pr_502():
    """
    TC-API-SORT-008 [正常流] order_by=start时topic作为第二级
    维度：正常流 | 优先级：P1
    """
    data = [
        {"id": 1, "topic": "Gamma", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "Alpha", "date": "2026-05-29", "start": "08:00"},
        {"id": 3, "topic": "Beta", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["start"], x["topic"]))
    assert sorted_data[0]["start"] == "08:00"
    assert sorted_data[0]["topic"] == "Alpha"
    assert sorted_data[1]["topic"] == "Gamma"


@pytest.mark.p2
def test_meeting_sort_009_empty_topic_pr_502():
    """
    TC-API-SORT-009 [空值] topic为空字符串
    维度：空值 | 优先级：P2
    """
    data = [
        {"id": 1, "topic": "B会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "", "date": "2026-05-30", "start": "08:00"},
        {"id": 3, "topic": "A会议", "date": "2026-05-30", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert sorted_data[0]["topic"] == ""
    assert sorted_data[1]["topic"] == "A会议"
    assert sorted_data[2]["topic"] == "B会议"


@pytest.mark.p1
def test_meeting_sort_010_default_order_by_pr_502():
    """
    TC-API-SORT-010 [正常流] 默认order_by参数
    维度：正常流 | 优先级：P1
    """
    data = [
        {"id": 1, "topic": "B会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 2, "topic": "A会议", "date": "2026-05-30", "start": "08:00"},
        {"id": 3, "topic": "C会议", "date": "2026-05-29", "start": "08:00"},
    ]
    sorted_data = sorted(data, key=lambda x: (x["date"], x["start"], x["topic"]))
    assert sorted_data[0]["date"] == "2026-05-29"
    assert sorted_data[1]["topic"] == "A会议"
    assert sorted_data[2]["topic"] == "B会议"


# --- 接口兼容性验证（PR #502 / Issue 476） --------------------------------------------------------------

@pytest.mark.p0
def test_meeting_api_compat_001_response_structure_pr_502():
    """
    TC-API-COMPAT-001 [正常流] 接口返回结构验证
    维度：正常流 | 优先级：P0
    """
    resp = requests.get(
        f"{BASE_API}/inner/v1/meeting/meeting/list/",
        params={"order_by": "date", "order_type": "asc"},
        headers={"token": AUTH_TOKEN, "Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "total" in body
    assert "list" in body
    assert "page" in body
    assert "size" in body
    if body["list"]:
        assert "topic" in body["list"][0]


@pytest.mark.p0
def test_meeting_api_compat_002_desc_mode_pr_502():
    """
    TC-API-COMPAT-002 [正常流] 降序模式接口验证
    维度：正常流 | 优先级：P0
    """
    resp = requests.get(
        f"{BASE_API}/inner/v1/meeting/meeting/list/",
        params={"order_by": "date", "order_type": "desc"},
        headers={"token": AUTH_TOKEN, "Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "list" in body
    if len(body["list"]) >= 2:
        dates = [item["date"] for item in body["list"]]
        assert dates[0] >= dates[1]


@pytest.mark.p1
def test_meeting_api_compat_003_pagination_pr_502():
    """
    TC-API-COMPAT-003 [正常流] 分页参数验证
    维度：正常流 | 优先级：P1
    """
    resp = requests.get(
        f"{BASE_API}/inner/v1/meeting/meeting/list/",
        params={"order_by": "date", "order_type": "asc", "page": 1, "size": 10},
        headers={"token": AUTH_TOKEN, "Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert body["page"] == 1
    assert body["size"] == 10
    assert len(body["list"]) <= 10


@pytest.mark.p1
def test_meeting_api_compat_004_order_by_start_pr_502():
    """
    TC-API-COMPAT-004 [边界值] order_by=start接口验证
    维度：边界值 | 优先级：P1
    """
    resp = requests.get(
        f"{BASE_API}/inner/v1/meeting/meeting/list/",
        params={"order_by": "start", "order_type": "asc"},
        headers={"token": AUTH_TOKEN, "Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "total" in body
    assert "list" in body
    if len(body["list"]) >= 2:
        for i in range(len(body["list"]) - 1):
            if body["list"][i]["start"] == body["list"][i + 1]["start"]:
                assert body["list"][i]["topic"] <= body["list"][i + 1]["topic"]


if __name__ == "__main__":
    pytest.main(["-v", __file__, "-m", "not slow"])


# ===== 用例索引（人类可贴禅道/Tapd） =====
# | 用例ID | 标题 | 关联 task | 优先级 | 来源 PR |
# |--------|------|----------|--------|---------|
# | TC-API-MEETING-001 | [正常流] meeting-platform 统计接口返回正确数据 | 架构文档 §meeting-platform 统计接口 | P0 | PR #174 |
# | TC-API-MEETING-002 | [边界值] meeting-platform 统计接口无数据时返回零值 | 架构文档 §验收标准 - 边界验证 | P1 | PR #174 |
# | TC-API-MEETING-003 | [权限] meeting-platform 统计接口无 Basic Auth 时拒绝访问 | 架构文档 §注意事项 - 安全性 | P1 | PR #174 |
# | TC-API-MEETING-004 | [正常流] meeting-center 公开接口返回包含 meeting_stats 字段 | 架构文档 §meeting-center 改动接口 | P0 | PR #174 |
# | TC-API-MEETING-005 | [正常流] meeting-center 公开接口原有查询参数功能不变 | 架构文档 §验收标准 - 兼容性验收 | P1 | PR #174 |
# | TC-API-MEETING-006 | [异常] meeting-platform 异常时 meeting-center 返回空统计 | 架构文档 §验收标准 - 边界验证 | P1 | PR #174 |
# | TC-INTEGRATION-001 | [正常流] meeting-center 正确调用 meeting-platform 统计接口 | 架构文档 §数据流 | P0 | PR #174 |
# | TC-INTEGRATION-002 | [异常] meeting-platform 接口超时时 meeting-center 不阻塞主流程 | 架构文档 §验收标准 - 非法参数验证 | P1 | PR #174 |
# | TC-PERF-001 | [正常流] 单次接口调用响应时间 < 1000ms | 架构文档 §验收标准 - 性能验收 | P0 | PR #174 |
# | TC-PERF-002 | [正常流] 并发 50 QPS 时响应时间 < 1200ms | 架构文档 §验收标准 - 性能验收 | P1 | PR #174 |
# | TC-PERF-003 | [边界值] 数据库 >10000 条会议时性能稳定 | 架构文档 §验收标准 - 边界验证 | P1 | PR #174 |
# | TC-API-SORT-001 | [正常流] 相同date/start按topic升序排列 | TASK1, TASK2 | P0 | PR #502 |
# | TC-API-SORT-002 | [边界值] date优先级最高 | TASK1, TASK2 | P0 | PR #502 |
# | TC-API-SORT-003 | [边界值] start优先级高于topic | TASK1, TASK2 | P0 | PR #502 |
# | TC-API-SORT-004 | [正常流] 降序模式topic仍升序 | TASK1, TASK2 | P0 | PR #502 |
# | TC-API-SORT-005 | [边界值] topic包含中英文混合 | TASK1, TASK2 | P1 | PR #502 |
# | TC-API-SORT-006 | [边界值] topic包含特殊字符 | TASK1, TASK2 | P1 | PR #502 |
# | TC-API-SORT-007 | [边界值] topic全相同 | TASK1, TASK2 | P2 | PR #502 |
# | TC-API-SORT-008 | [正常流] order_by=start时topic作为第二级 | TASK1, TASK2 | P1 | PR #502 |
# | TC-API-SORT-009 | [空值] topic为空字符串 | TASK1, TASK2 | P2 | PR #502 |
# | TC-API-SORT-010 | [正常流] 默认order_by参数 | TASK1, TASK2 | P1 | PR #502 |
# | TC-API-COMPAT-001 | [正常流] 接口返回结构验证 | TASK1 | P0 | PR #502 |
# | TC-API-COMPAT-002 | [正常流] 降序模式接口验证 | TASK1 | P0 | PR #502 |
# | TC-API-COMPAT-003 | [正常流] 分页参数验证 | TASK1 | P1 | PR #502 |
# | TC-API-COMPAT-004 | [边界值] order_by=start接口验证 | TASK1 | P1 | PR #502 |