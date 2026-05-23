# -*- coding: utf-8 -*-
"""
openUBMC 会议中心 —— 创建会议 + 删除会议 接口测试脚本
=========================================================

依据：
    1. D:/gxz/ai_gxz/meeting/meeting_api_doc.md 接口文档
    2. D:/gxz/ai_gxz/meeting/test_oneid_login.py 实测过的登录链路
    3. conftest.py 中 biz_request 提供的 token + _U_T_ + _Y_G_ 完整鉴权

覆盖接口：
    1. POST   /api-meeting/v1/meeting/                  （创建会议）
    2. DELETE /api-meeting/v1/meeting/{meetingId}/      （删除/取消会议）

共享配置：
    - 全局常量、登录链路、凭据缓存、login_creds fixture 全部抽到 conftest.py
    - 本文件仅包含会议业务相关 helper 与 30 条用例
    - 所有业务调用走 biz_request()，确保自动注入 _U_T_ + _Y_G_ Cookie

依赖：
    pip install pytest requests cryptography python-dotenv

执行：
    set PASSWORD=Aa123456@
    pytest -v -s test_meeting_create_delete.py
    pytest -v -s test_meeting_create_delete.py -k "create"
    pytest -v -s test_meeting_create_delete.py -k "delete"

用例统计：
    - 总数: 30 自动化 + 1 不可自动化注释
    - P0: 8  ｜ P1: 14  ｜ P2: 8
"""

import json
import os
import random
import time
from datetime import datetime, timedelta

import pytest

from conftest import (
    biz_request,
    build_business_headers,
)


# =========================================================
# 一、会议业务常量
# =========================================================
DEFAULT_GROUP = "infrastructure"
DEFAULT_PLATFORM = "WELINK"
DEFAULT_ETHERPAD = "https://etherpad.openubmc.cn/p/infrastructrue"

PATH_MEETING = "/api-meeting/v1/meeting/"
PATH_MEETING_DETAIL = "/api-meeting/v1/meeting/{meeting_id}/"

# 运行级唯一后缀：跨用例同主题不会撞「会议已存在」
RUN_TAG = f"{int(time.time()) % 1_000_000}-{os.getpid() % 10_000}"
# 同一会议室+日期+时间窗±30min 会冲突；每次运行轮换起始时间
_HOUR_OFFSET = (int(time.time()) // 60) % 10  # 0..9
DEFAULT_START_HOUR = 8 + _HOUR_OFFSET
DEFAULT_START_MIN = random.choice([0, 15, 30, 45])


# =========================================================
# 二、会议业务工具函数
# =========================================================
def _date_offset(days: int) -> str:
    return (datetime.now() + timedelta(days=days)).strftime("%Y-%m-%d")


def _default_time_window(idx: int = 0):
    """为每条用例分配错峰 15 分钟时间窗，避免「时间冲突」"""
    base_min = DEFAULT_START_HOUR * 60 + DEFAULT_START_MIN + idx * 30
    sh, sm = base_min // 60, base_min % 60
    eh, em = (base_min + 15) // 60, (base_min + 15) % 60
    return f"{sh:02d}:{sm:02d}", f"{eh:02d}:{em:02d}"


def _build_single_meeting_body(
    topic: str = None,
    agenda: str = "自动化测试内容",
    date: str = None,
    start: str = None,
    end: str = None,
    group_name: str = None,
    platform: str = None,
    drop_keys: list = None,
    extra: dict = None,
    slot: int = 0,
) -> dict:
    if start is None or end is None:
        s, e = _default_time_window(slot)
        start = start or s
        end = end or e
    if topic is None:
        topic = f"测试会议-自动化-{RUN_TAG}-{slot}"
    body = {
        "is_record": False,
        "is_cycle": False,
        "agenda": agenda,
        "email_list": "",
        "platform": platform if platform is not None else DEFAULT_PLATFORM,
        "topic": topic,
        "group_name": group_name if group_name is not None else DEFAULT_GROUP,
        "etherpad": DEFAULT_ETHERPAD,
        "date": date if date is not None else _date_offset(2),
        "start": start,
        "time": f"{start}-{end}",
        "end": end,
    }
    if extra:
        body.update(extra)
    if drop_keys:
        for k in drop_keys:
            body.pop(k, None)
    return body


def _build_cycle_meeting_body(
    cycle_type: int,
    cycle_interval: int = 1,
    cycle_start_date: str = None,
    cycle_end_date: str = None,
    cycle_start: str = None,
    cycle_end: str = None,
    cycle_point: str = "15",
    topic: str = None,
    extra: dict = None,
    slot: int = 0,
) -> dict:
    # 周期会议平台只接受整小时时间点；用 slot 在 13~22 时段错峰
    if cycle_start is None or cycle_end is None:
        sh = 13 + (slot % 9)  # 13..21
        cycle_start = cycle_start or f"{sh:02d}:00"
        cycle_end = cycle_end or f"{sh + 1:02d}:00"
    if topic is None:
        topic = f"测试会议-周期-自动化-{RUN_TAG}-{slot}"
    body = {
        "is_record": False,
        "is_cycle": True,
        "cycle_interval": cycle_interval,
        "cycle_type": cycle_type,
        "cycle_start_date": cycle_start_date if cycle_start_date else _date_offset(2),
        "cycle_end_date": cycle_end_date if cycle_end_date else _date_offset(32),
        "cycle_start": cycle_start,
        "cycle_end": cycle_end,
        "agenda": "自动化测试内容",
        "email_list": "",
        "platform": DEFAULT_PLATFORM,
        "topic": topic,
        "group_name": DEFAULT_GROUP,
        "etherpad": DEFAULT_ETHERPAD,
    }
    if cycle_type == 2:
        body["cycle_point"] = cycle_point
    if extra:
        body.update(extra)
    return body


def _extract_meeting_id(resp_json) -> int:
    """从创建接口响应中提取 meeting_id；兼容多种结构"""
    if not isinstance(resp_json, dict):
        return None
    data = resp_json.get("data")
    if isinstance(data, int):
        return data
    if isinstance(data, str) and data.isdigit():
        return int(data)
    if isinstance(data, dict):
        for k in ("id", "meeting_id", "mid"):
            v = data.get(k)
            if isinstance(v, int):
                return v
            if isinstance(v, str) and v.isdigit():
                return int(v)
    return None


def _post_meeting(creds, body):
    """业务封装：POST /api-meeting/v1/meeting/"""
    return biz_request(
        "POST",
        PATH_MEETING,
        creds,
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )


def _delete_meeting(creds, meeting_id):
    """业务封装：DELETE /api-meeting/v1/meeting/{id}/"""
    return biz_request(
        "DELETE",
        PATH_MEETING_DETAIL.format(meeting_id=meeting_id),
        creds,
    )


def _safe_delete(creds, meeting_id):
    """工具函数：尽力删除指定 meeting，避免脏数据；忽略所有异常"""
    if not meeting_id:
        return
    try:
        _delete_meeting(creds, meeting_id)
    except Exception:
        pass


def _create_meeting_for_delete(creds, cycle: bool = False) -> int:
    """工具：创建一个会议供删除用例使用"""
    if cycle:
        body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15")
    else:
        body = _build_single_meeting_body()
    resp = _post_meeting(creds, body)
    if resp.status_code != 200:
        pytest.skip(f"前置创建会议失败，跳过删除用例：{resp.status_code} {resp.text[:200]}")
    mid = _extract_meeting_id(resp.json())
    if not mid:
        pytest.skip(f"前置创建未取到 meeting_id：{resp.text[:200]}")
    return mid


@pytest.fixture
def cleanup_meetings(login_creds):
    """用例级 fixture：用例结束自动清理脏数据"""
    created = []
    yield created
    for mid in created:
        _safe_delete(login_creds, mid)


def _create_or_skip(creds, body, case_label):
    """统一处理创建会议结果：

    - 成功 → 返回 meeting_id
    - 400 + 环境性消息（会议已存在 / 时间冲突 / 今日创建已超限制） → pytest.skip
    - 其他失败 → pytest.fail（含状态码和响应）
    """
    resp = _post_meeting(creds, body)
    try:
        rj = resp.json()
    except Exception:
        rj = None

    if resp.status_code == 200 and isinstance(rj, dict):
        mid = _extract_meeting_id(rj)
        if mid:
            return mid

    msg = str((rj or {}).get("msg", "")) if rj else ""
    env_blockers = ("已超限制", "已经存在", "时间冲突", "请调整会议预定时间")
    if resp.status_code in (400, 403, 429) and any(blocker in msg for blocker in env_blockers):
        pytest.skip(f"[{case_label}] 环境限制无法继续（非脚本鉴权问题）：{rj}")

    pytest.fail(f"[{case_label}] 创建会议失败：status={resp.status_code} body={resp.text[:300]}")


# =========================================================
# 三、创建会议接口（POST /api-meeting/v1/meeting/）测试用例
# =========================================================

# ---------------- 3.1 正常流程 ----------------
def test_TC_API_MEETING_CREATE_001_single_meeting(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-001
    维度  : [正常流] 优先级 P0
    描述  : 创建 T+2 的单次会议成功
    预期  : HTTP 200 / 响应含 data 字段且为有效 meeting_id
    """
    body = _build_single_meeting_body(slot=1)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-001")
    assert mid > 0
    cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_002_month_cycle(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-002
    维度  : [正常流] 优先级 P0
    描述  : 创建月周期会议成功（cycle_type=2，每月 15 号）
    """
    body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15", slot=2)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-002")
    assert mid > 0
    cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_003_day_cycle(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-003
    维度  : [正常流] 优先级 P0
    描述  : 创建日周期会议成功（cycle_type=0，每日）
    """
    body = _build_cycle_meeting_body(
        cycle_type=0,
        cycle_start_date=_date_offset(2),
        cycle_end_date=_date_offset(5),
        slot=3,
    )
    body.pop("cycle_point", None)
    mid = _create_or_skip(login_creds, body, "TC-API-MEETING-CREATE-003")
    assert mid > 0
    cleanup_meetings.append(mid)


# ---------------- 3.2 异常场景：必填字段缺失 ----------------
@pytest.mark.parametrize(
    "missing_key, case_id",
    [
        ("topic", "TC-API-MEETING-CREATE-004"),
        ("agenda", "TC-API-MEETING-CREATE-005"),
        ("group_name", "TC-API-MEETING-CREATE-006"),
        ("platform", "TC-API-MEETING-CREATE-007"),
        ("date", "TC-API-MEETING-CREATE-008"),
    ],
    ids=["missing_topic", "missing_agenda", "missing_group_name", "missing_platform", "missing_date"],
)
def test_TC_API_MEETING_CREATE_required_field_missing(login_creds, missing_key, case_id):
    """
    用例ID: TC-API-MEETING-CREATE-004 ~ 008
    维度  : [异常][空值] 优先级 P1
    描述  : 创建会议时缺失必填字段
    预期  : HTTP 4xx 或业务码非成功
    """
    body = _build_single_meeting_body(drop_keys=[missing_key])
    resp = _post_meeting(login_creds, body)
    is_negative = resp.status_code >= 400
    if not is_negative:
        try:
            rj = resp.json()
            code = rj.get("code")
            is_negative = code not in (0, 200, "0", "200", None)
            if not is_negative:
                mid = _extract_meeting_id(rj)
                if mid:
                    _safe_delete(login_creds, mid)
                    pytest.fail(
                        f"[{case_id}] 缺少 {missing_key} 仍创建成功 meeting_id={mid}，校验未生效"
                    )
        except ValueError:
            is_negative = True
    assert is_negative, f"[{case_id}] 缺少 {missing_key} 但接口未拒绝: status={resp.status_code} body={resp.text[:300]}"


# ---------------- 3.3 异常场景：日期格式错误 ----------------
def test_TC_API_MEETING_CREATE_009_invalid_date_format(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-009
    维度  : [异常输入] 优先级 P1
    描述  : 创建会议时 date 使用错误格式 "2026/05/25"
    """
    body = _build_single_meeting_body(date="2026/05/25")
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"日期格式错误仍创建成功 meeting_id={mid}, body={resp.text[:300]}"
    else:
        assert resp.status_code >= 400


# ---------------- 3.4 异常场景：cycle_type 非法值 ----------------
def test_TC_API_MEETING_CREATE_010_invalid_cycle_type(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-010
    维度  : [异常输入] 优先级 P1
    描述  : 周期会议 cycle_type=99（合法值仅 0/1/2）
    """
    body = _build_cycle_meeting_body(cycle_type=99)
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"非法 cycle_type=99 仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


# ---------------- 3.5 权限校验：未登录 / 错误 token ----------------
def test_TC_API_MEETING_CREATE_011_no_token():
    """
    用例ID: TC-API-MEETING-CREATE-011
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用创建会议接口
    """
    body = _build_single_meeting_body()
    headers = build_business_headers(token="")
    headers.pop("token", None)
    # 显式传 None creds + 空 headers，确保不携带任何鉴权信息
    resp = biz_request(
        "POST",
        PATH_MEETING,
        None,
        headers=headers,
        cookies={},
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"无 token 调用未被拒: status={resp.status_code} body={resp.text[:300]}"
    )


def test_TC_API_MEETING_CREATE_012_invalid_token():
    """
    用例ID: TC-API-MEETING-CREATE-012
    维度  : [权限] 优先级 P0
    描述  : 携带错误的 token 调用创建会议接口
    """
    body = _build_single_meeting_body()
    # 错 token + 不带 cookie：业务接口必拒
    resp = biz_request(
        "POST",
        PATH_MEETING,
        {"token": "invalid-token-xxx-1234567890", "yg": ""},
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )
    assert resp.status_code in (401, 403) or resp.status_code >= 400, (
        f"错误 token 未被拒: status={resp.status_code} body={resp.text[:300]}"
    )


# ---------------- 3.6 边界值 ----------------
def test_TC_API_MEETING_CREATE_013_topic_min_length(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-013
    维度  : [边界值] 优先级 P2
    描述  : topic 长度=1
    """
    body = _build_single_meeting_body(topic="a")
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_CREATE_014_topic_oversize(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-014
    维度  : [边界值] 优先级 P2
    描述  : topic 长度=256
    """
    body = _build_single_meeting_body(topic="A" * 256)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"超长 topic 触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_015_date_today(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-015
    维度  : [边界值] 优先级 P2
    描述  : date 取今天
    """
    body = _build_single_meeting_body(date=_date_offset(0))
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_016_date_past(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-016
    维度  : [边界值][异常] 优先级 P2
    描述  : date 取过去 5 天
    """
    body = _build_single_meeting_body(date=_date_offset(-5))
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"过去日期仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_CREATE_017_cycle_end_before_start(login_creds):
    """
    用例ID: TC-API-MEETING-CREATE-017
    维度  : [边界值][异常] 优先级 P2
    描述  : 周期会议 cycle_end_date 早于 cycle_start_date
    """
    body = _build_cycle_meeting_body(
        cycle_type=2,
        cycle_start_date=_date_offset(10),
        cycle_end_date=_date_offset(2),
        cycle_point="15",
    )
    resp = _post_meeting(login_creds, body)
    if resp.status_code == 200:
        rj = resp.json()
        mid = _extract_meeting_id(rj)
        if mid:
            _safe_delete(login_creds, mid)
        assert mid is None, f"end<start 仍创建成功 meeting_id={mid}"
    else:
        assert resp.status_code >= 400


# ---------------- 3.7 特殊字符 ----------------
def test_TC_API_MEETING_CREATE_018_topic_emoji(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-018
    维度  : [特殊字符] 优先级 P2
    描述  : topic 含 emoji
    """
    body = _build_single_meeting_body(topic="测试会议🎉🚀-自动化")
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"emoji 触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_019_topic_xss(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-019
    维度  : [XSS][安全] 优先级 P2
    描述  : topic 含 <script> 脚本
    """
    payload = '<script>alert("xss")</script>'
    body = _build_single_meeting_body(topic=payload)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"XSS 输入触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


def test_TC_API_MEETING_CREATE_020_topic_sql_injection(login_creds, cleanup_meetings):
    """
    用例ID: TC-API-MEETING-CREATE-020
    维度  : [SQL注入][安全] 优先级 P2
    描述  : topic 含 SQL 关键字
    """
    payload = "test'; DROP TABLE meeting;--"
    body = _build_single_meeting_body(topic=payload)
    resp = _post_meeting(login_creds, body)
    assert resp.status_code < 500, f"SQL 注入触发 5xx: {resp.status_code}"
    if resp.status_code == 200:
        mid = _extract_meeting_id(resp.json())
        if mid:
            cleanup_meetings.append(mid)


# =========================================================
# 四、删除会议接口（DELETE /api-meeting/v1/meeting/{id}/）测试用例
# =========================================================

# ---------------- 4.1 正常流程 ----------------
def test_TC_API_MEETING_DELETE_001_delete_single(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-001
    维度  : [正常流] 优先级 P0
    描述  : 删除已创建的单次会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    resp = _delete_meeting(login_creds, mid)
    assert resp.status_code == 200, f"删除失败 status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_002_delete_month_cycle(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-002
    维度  : [正常流] 优先级 P0
    描述  : 删除已创建的月周期会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=True)
    resp = _delete_meeting(login_creds, mid)
    assert resp.status_code == 200, f"删除月周期会议失败 status={resp.status_code} body={resp.text[:300]}"


# ---------------- 4.2 异常场景 ----------------
def test_TC_API_MEETING_DELETE_003_not_exist(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-003
    维度  : [异常] 优先级 P1
    描述  : 删除不存在的 meetingId（极大值 99999999）
    """
    resp = _delete_meeting(login_creds, 99999999)
    is_negative = resp.status_code >= 400
    if not is_negative:
        try:
            rj = resp.json()
            is_negative = rj.get("code") not in (0, 200, "0", "200", None)
        except ValueError:
            is_negative = True
    assert is_negative, f"删除不存在的会议未被拒: status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_004_string_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-004
    维度  : [异常输入] 优先级 P1
    描述  : meetingId 为字符串 "abc"
    """
    resp = _delete_meeting(login_creds, "abc")
    assert resp.status_code >= 400, f"字符串 ID 未被拒: status={resp.status_code} body={resp.text[:300]}"


def test_TC_API_MEETING_DELETE_005_negative_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-005
    维度  : [异常输入][边界值] 优先级 P1
    描述  : meetingId 为负数 -1
    """
    resp = _delete_meeting(login_creds, -1)
    if resp.status_code == 200:
        rj = resp.json()
        assert rj.get("code") not in (0, 200, "0", "200", None), f"负数 ID 删除成功: {rj}"
    else:
        assert resp.status_code >= 400


def test_TC_API_MEETING_DELETE_006_zero_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-006
    维度  : [异常输入][边界值] 优先级 P1
    描述  : meetingId 为 0
    """
    resp = _delete_meeting(login_creds, 0)
    if resp.status_code == 200:
        rj = resp.json()
        assert rj.get("code") not in (0, 200, "0", "200", None), f"meeting_id=0 删除成功: {rj}"
    else:
        assert resp.status_code >= 400


# ---------------- 4.3 权限校验 ----------------
def test_TC_API_MEETING_DELETE_007_no_token(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-007
    维度  : [权限] 优先级 P0
    描述  : 不携带 token 调用删除接口
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    try:
        headers = build_business_headers(token="")
        headers.pop("token", None)
        resp = biz_request(
            "DELETE",
            f"/api-meeting/v1/meeting/{mid}/",
            None,
            headers=headers,
            cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"无 token 删除未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


def test_TC_API_MEETING_DELETE_008_invalid_token(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-008
    维度  : [权限] 优先级 P0
    描述  : 携带错误 token 调用删除接口
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)
    try:
        resp = biz_request(
            "DELETE",
            f"/api-meeting/v1/meeting/{mid}/",
            {"token": "invalid-token-xxx-1234567890", "yg": ""},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400, (
            f"错误 token 删除未被拒: status={resp.status_code}"
        )
    finally:
        _safe_delete(login_creds, mid)


# ---------------- 4.4 重复操作（幂等性） ----------------
def test_TC_API_MEETING_DELETE_009_duplicate_delete(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-009
    维度  : [重复][幂等性] 优先级 P1
    描述  : 创建后连续删除两次同一会议
    """
    mid = _create_meeting_for_delete(login_creds, cycle=False)

    resp1 = _delete_meeting(login_creds, mid)
    assert resp1.status_code == 200, f"首次删除失败: {resp1.status_code} {resp1.text[:200]}"

    resp2 = _delete_meeting(login_creds, mid)
    assert resp2.status_code < 500, f"重复删除触发 5xx: {resp2.status_code}"
    is_negative = resp2.status_code >= 400
    if not is_negative:
        try:
            is_negative = resp2.json().get("code") not in (0, 200, "0", "200", None)
        except ValueError:
            is_negative = True
    assert is_negative, f"重复删除未返回失败状态: status={resp2.status_code} body={resp2.text[:300]}"


# ---------------- 4.5 边界值 ----------------
def test_TC_API_MEETING_DELETE_010_huge_id(login_creds):
    """
    用例ID: TC-API-MEETING-DELETE-010
    维度  : [边界值] 优先级 P2
    描述  : meetingId 为超大值 9999999999999
    """
    resp = _delete_meeting(login_creds, 9999999999999)
    assert resp.status_code < 500, f"超大 ID 触发 5xx: {resp.status_code}"


# =========================================================
# 五、不可自动化用例（注释块说明）
# =========================================================
# === TC-API-MEETING-CREATE-MANUAL-001 [SKIP-MANUAL] ===
# 用例标题: [安全] 验证创建会议接口在 OneID 触发图形验证码后的鉴权链路
# 维度    : [安全] 优先级 P1
#
# 不可自动化原因:
#   OneID 登录在连续登录失败若干次后会触发图形验证码（need_captcha_verification=True），
#   该图形验证码无可编程获取的 token，必须人工识别。
#
# 人工执行步骤:
#   1. 浏览器打开 https://usercenter.openubmc.test.osinfra.cn/login
#   2. 故意输错密码 5 次以触发图形验证码
#   3. 输入正确密码 + 图形验证码登录
#   4. 抓取登录响应 body.data.token
#   5. 通过环境变量 INJECT_TOKEN=<token> 注入后人工调用 POST /api-meeting/v1/meeting/
#
# 预期结果:
#   登录成功后 token 有效，创建会议接口正常返回 meeting_id。
# === END SKIP-MANUAL ===


if __name__ == "__main__":
    pytest.main(["-v", "-s", __file__])
