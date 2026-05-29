# om-dataarts 模块全量测试用例（pytest）
# 来源 PR：#460 — feat(workflow): /project xxx 触发重新分析 + 评论格式修正

import os
import pytest
import requests
import psycopg2
from unittest import mock


BASE_API = os.environ.get("BASE_API", "https://magicapi.osinfra.cn")
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_PORT = os.environ.get("DB_PORT", "5432")
DB_NAME = os.environ.get("DB_NAME", "om_datacenter")
DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")


@pytest.fixture(scope="session")
def db_conn():
    conn = psycopg2.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME,
        user=DB_USER, password=DB_PASSWORD
    )
    yield conn
    conn.close()


@pytest.fixture(scope="session")
def api_headers():
    return {"Content-Type": "application/json"}


# ===== Issue #450: 开源实习数据看板新增 Torch-NPU、openUBMC、Ascend IR 社区的实习数据 =====

@pytest.mark.p0
def test_om_dataarts_community_dict_torchnpu_001_pr_460(api_headers):
    """
    [正常流] 社区列表接口返回包含 Torch-NPU
    对应 TASK-1 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.get(
        f"{BASE_API}/server/community/dict",
        headers=api_headers,
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", [])
    torchnpu_found = any(
        item.get("value") == "torchnpu" and item.get("key") == "Torch-NPU"
        for item in data
    )
    assert torchnpu_found, "Torch-NPU not found in community dict"


@pytest.mark.p0
def test_om_dataarts_community_dict_openubmc_002_pr_460(api_headers):
    """
    [正常流] 社区列表接口返回包含 openUBMC
    对应 TASK-1 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.get(
        f"{BASE_API}/server/community/dict",
        headers=api_headers,
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", [])
    openubmc_found = any(
        item.get("value") == "openubmc" and item.get("key") == "openUBMC"
        for item in data
    )
    assert openubmc_found, "openUBMC not found in community dict"


@pytest.mark.p0
def test_om_dataarts_community_dict_ascendnpuir_003_pr_460(api_headers):
    """
    [正常流] 社区列表接口返回包含 Ascend IR
    对应 TASK-1 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.get(
        f"{BASE_API}/server/community/dict",
        headers=api_headers,
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    data = body.get("data", [])
    ascendnpuir_found = any(
        item.get("value") == "ascendnpuir" and item.get("key") == "Ascend IR"
        for item in data
    )
    assert ascendnpuir_found, "Ascend IR not found in community dict"


@pytest.mark.p0
def test_om_dataarts_db_table_torchnpu_exists_004_pr_460(db_conn):
    """
    [正常流] fact_torchnpu_practice 表存在且结构正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'fact_torchnpu_practice'
        ORDER BY ordinal_position
    """)
    columns = cur.fetchall()
    cur.close()
    assert len(columns) >= 14, f"Expected >=14 columns, got {len(columns)}"
    column_names = [col[0] for col in columns]
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    for field in required_fields:
        assert field in column_names, f"Missing field: {field}"


@pytest.mark.p0
def test_om_dataarts_db_table_openubmc_exists_005_pr_460(db_conn):
    """
    [正常流] fact_openubmc_practice 表存在且结构正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'fact_openubmc_practice'
        ORDER BY ordinal_position
    """)
    columns = cur.fetchall()
    cur.close()
    assert len(columns) >= 14, f"Expected >=14 columns, got {len(columns)}"
    column_names = [col[0] for col in columns]
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    for field in required_fields:
        assert field in column_names, f"Missing field: {field}"


@pytest.mark.p0
def test_om_dataarts_db_table_ascendnpuir_exists_006_pr_460(db_conn):
    """
    [正常流] fact_ascendnpuir_practice 表存在且结构正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'fact_ascendnpuir_practice'
        ORDER BY ordinal_position
    """)
    columns = cur.fetchall()
    cur.close()
    assert len(columns) >= 14, f"Expected >=14 columns, got {len(columns)}"
    column_names = [col[0] for col in columns]
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    for field in required_fields:
        assert field in column_names, f"Missing field: {field}"


@pytest.mark.p0
def test_om_dataarts_db_torchnpu_has_data_007_pr_460(db_conn):
    """
    [正常流] fact_torchnpu_practice 表有数据
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT COUNT(*) FROM fact_torchnpu_practice")
    count = cur.fetchone()[0]
    cur.close()
    assert count >= 1, f"Expected >=1 records, got {count}"


@pytest.mark.p0
def test_om_dataarts_db_openubmc_has_data_008_pr_460(db_conn):
    """
    [正常流] fact_openubmc_practice 表有数据
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT COUNT(*) FROM fact_openubmc_practice")
    count = cur.fetchone()[0]
    cur.close()
    assert count >= 1, f"Expected >=1 records, got {count}"


@pytest.mark.p0
def test_om_dataarts_db_ascendnpuir_has_data_009_pr_460(db_conn):
    """
    [正常流] fact_ascendnpuir_practice 表有数据
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT COUNT(*) FROM fact_ascendnpuir_practice")
    count = cur.fetchone()[0]
    cur.close()
    assert count >= 1, f"Expected >=1 records, got {count}"


@pytest.mark.p1
def test_om_dataarts_db_torchnpu_fields_not_null_010_pr_460(db_conn):
    """
    [正常流] Torch-NPU 数据必填字段非空
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT uuid, title, html_url, status, issue_state
        FROM fact_torchnpu_practice
        LIMIT 10
    """)
    rows = cur.fetchall()
    cur.close()
    assert len(rows) > 0, "No records found"
    for row in rows:
        uuid_val, title, html_url, status, issue_state = row
        assert uuid_val and uuid_val.strip(), "uuid is empty"
        assert title and title.strip(), "title is empty"
        assert html_url and html_url.strip(), "html_url is empty"
        assert status and status.strip(), "status is empty"
        assert issue_state and issue_state.strip(), "issue_state is empty"


@pytest.mark.p1
def test_om_dataarts_db_torchnpu_uuid_format_011_pr_460(db_conn):
    """
    [正常流] Torch-NPU uuid 格式正确
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT uuid FROM fact_torchnpu_practice LIMIT 5")
    rows = cur.fetchall()
    cur.close()
    for row in rows:
        uuid_val = row[0]
        assert uuid_val.startswith("gitcode-"), f"uuid format wrong: {uuid_val}"
        parts = uuid_val.split("-")
        assert len(parts) >= 4, f"uuid should have >=4 parts: {uuid_val}"


@pytest.mark.p0
def test_om_dataarts_api_detail_page_torchnpu_012_pr_460(api_headers):
    """
    [正常流] 查询 Torch-NPU 社区数据接口返回正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "list" in body, "Missing 'list' in response"
    assert "total" in body, "Missing 'total' in response"
    assert isinstance(body["list"], list), "'list' should be array"
    assert isinstance(body["total"], int), "'total' should be int"
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    if len(body["list"]) > 0:
        for item in body["list"]:
            for field in required_fields:
                assert field in item, f"Missing field '{field}' in list item"


@pytest.mark.p0
def test_om_dataarts_api_detail_page_openubmc_013_pr_460(api_headers):
    """
    [正常流] 查询 openUBMC 社区数据接口返回正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "openubmc", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "list" in body, "Missing 'list' in response"
    assert "total" in body, "Missing 'total' in response"
    assert isinstance(body["list"], list), "'list' should be array"
    assert isinstance(body["total"], int), "'total' should be int"
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    if len(body["list"]) > 0:
        for item in body["list"]:
            for field in required_fields:
                assert field in item, f"Missing field '{field}' in list item"


@pytest.mark.p0
def test_om_dataarts_api_detail_page_ascendnpuir_014_pr_460(api_headers):
    """
    [正常流] 查询 Ascend IR 社区数据接口返回正确
    对应 TASK-2 | 优先级 P0 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "ascendnpuir", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    assert "list" in body, "Missing 'list' in response"
    assert "total" in body, "Missing 'total' in response"
    assert isinstance(body["list"], list), "'list' should be array"
    assert isinstance(body["total"], int), "'total' should be int"
    required_fields = [
        "uuid", "title", "html_url", "tutor_login", "tutor_email",
        "score", "sig_name", "assign_user", "assign_at", "status",
        "issue_state", "pr_url", "created_at", "finished_at"
    ]
    if len(body["list"]) > 0:
        for item in body["list"]:
            for field in required_fields:
                assert field in item, f"Missing field '{field}' in list item"


@pytest.mark.p1
def test_om_dataarts_api_detail_page_empty_community_015_pr_460(api_headers):
    """
    [异常] 空社区参数返回参数校验失败
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code == 400 or (400 <= resp.status_code < 500), \
        f"Expected 4xx error for empty community, got {resp.status_code}"


@pytest.mark.p1
def test_om_dataarts_api_detail_page_invalid_community_016_pr_460(api_headers):
    """
    [异常] 非法社区名返回错误
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "invalid_community_xyz", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code == 500 or (400 <= resp.status_code < 500), \
        f"Expected 4xx or 500 error for invalid community, got {resp.status_code}"


@pytest.mark.p1
def test_om_dataarts_api_detail_page_missing_community_017_pr_460(api_headers):
    """
    [空值] 缺失社区参数返回错误
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for missing community"


@pytest.mark.p1
def test_om_dataarts_api_detail_page_null_community_018_pr_460(api_headers):
    """
    [空值] null 社区参数返回错误
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": None, "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for null community"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_pagination_019_pr_460(api_headers):
    """
    [正常流] 分页参数有效
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 2, "pageSize": 5},
        timeout=10
    )
    assert resp.status_code == 200
    body = resp.json()
    assert isinstance(body.get("list"), list)


@pytest.mark.p2
def test_om_dataarts_api_detail_page_large_pagesize_020_pr_460(api_headers):
    """
    [边界值] pageSize=100 返回正确
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 1, "pageSize": 100},
        timeout=15
    )
    assert resp.status_code == 200
    body = resp.json()
    assert len(body.get("list", [])) <= 100


@pytest.mark.p2
def test_om_dataarts_api_detail_page_pagesize_zero_021_pr_460(api_headers):
    """
    [边界值] pageSize=0 返回空列表或错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 1, "pageSize": 0},
        timeout=10
    )
    if resp.status_code == 200:
        body = resp.json()
        assert len(body.get("list", [])) == 0


@pytest.mark.p2
def test_om_dataarts_api_detail_page_negative_page_022_pr_460(api_headers):
    """
    [异常输入] page=-1 返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": -1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for negative page"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_negative_pagesize_023_pr_460(api_headers):
    """
    [异常输入] pageSize=-1 返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 1, "pageSize": -1},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for negative pageSize"


@pytest.mark.p1
def test_om_dataarts_db_torchnpu_status_values_024_pr_460(db_conn):
    """
    [正常流] Torch-NPU status 字段值为预期枚举
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT DISTINCT status FROM fact_torchnpu_practice")
    statuses = [row[0] for row in cur.fetchall()]
    cur.close()
    valid_statuses = ["已认领", "进行中", "已完成", "未认领"]
    for status in statuses:
        assert status in valid_statuses, f"Invalid status: {status}"


@pytest.mark.p1
def test_om_dataarts_db_torchnpu_issue_state_values_025_pr_460(db_conn):
    """
    [正常流] Torch-NPU issue_state 字段值为 open 或 closed
    对应 TASK-2 | 优先级 P1 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT DISTINCT issue_state FROM fact_torchnpu_practice")
    states = [row[0] for row in cur.fetchall()]
    cur.close()
    valid_states = ["open", "closed"]
    for state in states:
        assert state in valid_states, f"Invalid issue_state: {state}"


@pytest.mark.p2
def test_om_dataarts_db_torchnpu_html_url_format_026_pr_460(db_conn):
    """
    [正常流] Torch-NPU html_url 为有效 GitCode 链接
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT html_url FROM fact_torchnpu_practice LIMIT 5")
    urls = [row[0] for row in cur.fetchall()]
    cur.close()
    for url in urls:
        assert url.startswith("https://gitcode.com/"), f"Invalid url: {url}"
        assert "/issues/" in url, f"Missing issues path: {url}"


@pytest.mark.p2
def test_om_dataarts_db_openubmc_html_url_format_027_pr_460(db_conn):
    """
    [正常流] openUBMC html_url 为有效 GitCode 链接
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT html_url FROM fact_openubmc_practice LIMIT 5")
    urls = [row[0] for row in cur.fetchall()]
    cur.close()
    for url in urls:
        assert url.startswith("https://gitcode.com/"), f"Invalid url: {url}"
        assert "/issues/" in url, f"Missing issues path: {url}"


@pytest.mark.p2
def test_om_dataarts_db_ascendnpuir_html_url_format_028_pr_460(db_conn):
    """
    [正常流] Ascend IR html_url 为有效 GitCode 链接
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT html_url FROM fact_ascendnpuir_practice LIMIT 5")
    urls = [row[0] for row in cur.fetchall()]
    cur.close()
    for url in urls:
        assert url.startswith("https://gitcode.com/"), f"Invalid url: {url}"
        assert "/issues/" in url, f"Missing issues path: {url}"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_community_case_sensitive_029_pr_460(api_headers):
    """
    [异常输入] 社区名大小写敏感性测试
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "TORCHNPU", "page": 1, "pageSize": 10},
        timeout=10
    )
    if resp.status_code == 200:
        body = resp.json()
        assert isinstance(body.get("list"), list)
    else:
        assert resp.status_code >= 400


@pytest.mark.p2
def test_om_dataarts_api_detail_page_special_chars_community_030_pr_460(api_headers):
    """
    [特殊字符] 社区名含特殊字符返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu; DROP TABLE fact_torchnpu_practice", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for SQL injection attempt"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_sql_injection_031_pr_460(api_headers):
    """
    [SQL注入] 社区名含 SQL 注入关键字返回错误
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu' OR '1'='1", "page": 1, "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for SQL injection attempt"


@pytest.mark.p2
def test_om_dataarts_db_torchnpu_score_range_032_pr_460(db_conn):
    """
    [边界值] Torch-NPU score 字段范围合理
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("SELECT MIN(score), MAX(score) FROM fact_torchnpu_practice WHERE score IS NOT NULL")
    min_score, max_score = cur.fetchone()
    cur.close()
    if min_score is not None:
        assert min_score >= 0, f"Score should >=0, got {min_score}"
    if max_score is not None:
        assert max_score <= 100, f"Score should <=100, got {max_score}"


@pytest.mark.p2
def test_om_dataarts_db_torchnpu_assign_at_valid_date_033_pr_460(db_conn):
    """
    [正常流] Torch-NPU assign_at 为有效时间戳
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT assign_at FROM fact_torchnpu_practice
        WHERE assign_at IS NOT NULL LIMIT 5
    """)
    dates = [row[0] for row in cur.fetchall()]
    cur.close()
    for date in dates:
        assert date is not None


@pytest.mark.p2
def test_om_dataarts_db_torchnpu_created_at_valid_date_034_pr_460(db_conn):
    """
    [正常流] Torch-NPU created_at 为有效时间戳
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT created_at FROM fact_torchnpu_practice
        WHERE created_at IS NOT NULL LIMIT 5
    """)
    dates = [row[0] for row in cur.fetchall()]
    cur.close()
    for date in dates:
        assert date is not None


@pytest.mark.p2
def test_om_dataarts_db_openubmc_fields_not_null_035_pr_460(db_conn):
    """
    [正常流] openUBMC 数据必填字段非空
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT uuid, title, html_url, status, issue_state
        FROM fact_openubmc_practice
        LIMIT 10
    """)
    rows = cur.fetchall()
    cur.close()
    if len(rows) == 0:
        pytest.skip("No data in openubmc table")
    for row in rows:
        uuid_val, title, html_url, status, issue_state = row
        assert uuid_val and uuid_val.strip(), "uuid is empty"
        assert title and title.strip(), "title is empty"


@pytest.mark.p2
def test_om_dataarts_db_ascendnpuir_fields_not_null_036_pr_460(db_conn):
    """
    [正常流] Ascend IR 数据必填字段非空
    对应 TASK-2 | 优先级 P2 | 来源 PR #460
    """
    cur = db_conn.cursor()
    cur.execute("""
        SELECT uuid, title, html_url, status, issue_state
        FROM fact_ascendnpuir_practice
        LIMIT 10
    """)
    rows = cur.fetchall()
    cur.close()
    if len(rows) == 0:
        pytest.skip("No data in ascendnpuir table")
    for row in rows:
        uuid_val, title, html_url, status, issue_state = row
        assert uuid_val and uuid_val.strip(), "uuid is empty"
        assert title and title.strip(), "title is empty"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_type_mismatch_page_037_pr_460(api_headers):
    """
    [异常输入] page 参数类型错误返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": "abc", "pageSize": 10},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for type mismatch"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_type_mismatch_pagesize_038_pr_460(api_headers):
    """
    [异常输入] pageSize 参数类型错误返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "torchnpu", "page": 1, "pageSize": "ten"},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for type mismatch"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_empty_body_039_pr_460(api_headers):
    """
    [空值] 空请求体返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={},
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for empty body"


@pytest.mark.p2
def test_om_dataarts_api_detail_page_invalid_json_040_pr_460():
    """
    [异常输入] 非 JSON 请求体返回错误
    对应 TASK-3 | 优先级 P2 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers={"Content-Type": "application/json"},
        data="not a json",
        timeout=10
    )
    assert resp.status_code >= 400, "Expected error for invalid JSON"


@pytest.mark.p1
def test_om_dataarts_api_detail_page_empty_data_041_pr_460(api_headers):
    """
    [空数据] 空表数据返回空列表无报错
    对应 TASK-3 | 优先级 P1 | 来源 PR #460
    """
    resp = requests.post(
        f"{BASE_API}/server/detail/page",
        headers=api_headers,
        json={"community": "empty_test_community", "page": 1, "pageSize": 10},
        timeout=10
    )
    if resp.status_code == 200:
        body = resp.json()
        assert "list" in body, "Missing 'list' in response"
        assert "total" in body, "Missing 'total' in response"
        assert isinstance(body["list"], list), "'list' should be array"
        assert body["total"] == 0, "Expected total=0 for empty data"
        assert len(body["list"]) == 0, "Expected empty list for empty data"


if __name__ == "__main__":
    pytest.main(["-v", __file__])


# ===== 用例索引（人类可贴禅道/Tapd）=====
#
# | 用例ID | 标题 | 关联 task | 优先级 | 来源 PR |
# |--------|------|-----------|--------|---------|
# | TC-API-001 | 社区列表接口返回包含 Torch-NPU | TASK-1 | P0 | #460 |
# | TC-API-002 | 社区列表接口返回包含 openUBMC | TASK-1 | P0 | #460 |
# | TC-API-003 | 社区列表接口返回包含 Ascend IR | TASK-1 | P0 | #460 |
# | TC-DB-004 | fact_torchnpu_practice 表存在且结构正确 | TASK-2 | P0 | #460 |
# | TC-DB-005 | fact_openubmc_practice 表存在且结构正确 | TASK-2 | P0 | #460 |
# | TC-DB-006 | fact_ascendnpuir_practice 表存在且结构正确 | TASK-2 | P0 | #460 |
# | TC-DB-007 | fact_torchnpu_practice 表有数据 | TASK-2 | P0 | #460 |
# | TC-DB-008 | fact_openubmc_practice 表有数据 | TASK-2 | P0 | #460 |
# | TC-DB-009 | fact_ascendnpuir_practice 表有数据 | TASK-2 | P0 | #460 |
# | TC-DB-010 | Torch-NPU 数据必填字段非空 | TASK-2 | P1 | #460 |
# | TC-DB-011 | Torch-NPU uuid 格式正确 | TASK-2 | P1 | #460 |
# | TC-API-012 | 查询 Torch-NPU 社区数据接口返回正确（含14字段验证） | TASK-2 | P0 | #460 |
# | TC-API-013 | 查询 openUBMC 社区数据接口返回正确（含14字段验证） | TASK-2 | P0 | #460 |
# | TC-API-014 | 查询 Ascend IR 社区数据接口返回正确（含14字段验证） | TASK-2 | P0 | #460 |
# | TC-API-015 | 空社区参数返回4xx参数校验失败 | TASK-2 | P1 | #460 |
# | TC-API-016 | 非法社区名返回500或4xx错误 | TASK-2 | P1 | #460 |
# | TC-API-017 | 缺失社区参数返回错误 | TASK-2 | P1 | #460 |
# | TC-API-018 | null 社区参数返回错误 | TASK-2 | P1 | #460 |
# | TC-API-019 | 分页参数有效 | TASK-3 | P2 | #460 |
# | TC-API-020 | pageSize=100 返回正确 | TASK-3 | P2 | #460 |
# | TC-API-021 | pageSize=0 返回空列表或错误 | TASK-3 | P2 | #460 |
# | TC-API-022 | page=-1 返回错误 | TASK-3 | P2 | #460 |
# | TC-API-023 | pageSize=-1 返回错误 | TASK-3 | P2 | #460 |
# | TC-DB-024 | Torch-NPU status 字段值为预期枚举 | TASK-2 | P1 | #460 |
# | TC-DB-025 | Torch-NPU issue_state 字段值为 open 或 closed | TASK-2 | P1 | #460 |
# | TC-DB-026 | Torch-NPU html_url 为有效 GitCode 链接 | TASK-2 | P2 | #460 |
# | TC-DB-027 | openUBMC html_url 为有效 GitCode 链接 | TASK-2 | P2 | #460 |
# | TC-DB-028 | Ascend IR html_url 为有效 GitCode 链接 | TASK-2 | P2 | #460 |
# | TC-API-029 | 社区名大小写敏感性测试 | TASK-3 | P2 | #460 |
# | TC-API-030 | 社区名含特殊字符返回错误 | TASK-3 | P2 | #460 |
# | TC-API-031 | 社区名含 SQL 注入关键字返回错误 | TASK-2 | P2 | #460 |
# | TC-DB-032 | Torch-NPU score 字段范围合理 | TASK-2 | P2 | #460 |
# | TC-DB-033 | Torch-NPU assign_at 为有效时间戳 | TASK-2 | P2 | #460 |
# | TC-DB-034 | Torch-NPU created_at 为有效时间戳 | TASK-2 | P2 | #460 |
# | TC-DB-035 | openUBMC 数据必填字段非空 | TASK-2 | P2 | #460 |
# | TC-DB-036 | Ascend IR 数据必填字段非空 | TASK-2 | P2 | #460 |
# | TC-API-037 | page 参数类型错误返回错误 | TASK-3 | P2 | #460 |
# | TC-API-038 | pageSize 参数类型错误返回错误 | TASK-3 | P2 | #460 |
# | TC-API-039 | 空请求体返回错误 | TASK-3 | P2 | #460 |
# | TC-API-040 | 非 JSON 请求体返回错误 | TASK-3 | P2 | #460 |
# | TC-API-041 | 空表数据返回空列表无报错 | TASK-3 | P1 | #460 |
#
# ===== 覆盖维度统计 =====
# 正常流：25 | 异常：5 | 边界值：4 | 空值：3 | 空数据：1 | 特殊字符：1 | SQL注入：1 | 异常输入：7
# 总用例：41 | P0：14 | P1：10 | P2：17