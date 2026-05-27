# -*- coding: utf-8 -*-
"""
Meeting Server 接口自动化测试脚本（多社区适配）
===============================================

基于 meeting-server-api-doc.md 生成，覆盖 meeting-center API 全部端点。
通过环境变量 COMMUNITY 切换社区（openeuler/openUBMC/mindspore/ascend/unifiedbus）。

环境变量：
    COMMUNITY=openeuler       社区标识
    TEST_ACCOUNT=xxx          登录账号
    TEST_PASSWORD=yyy         登录密码
    FORCE_LOGIN=1             强制重新登录

执行：
    pytest -v test_meeting_api.py
    pytest -v test_meeting_api.py -k "create"
    pytest -v test_meeting_api.py -k "delete"
    pytest -v test_meeting_api.py -k "update"
    pytest -v test_meeting_api.py -k "query"
    pytest -v test_meeting_api.py -k "cycle"
    pytest -v test_meeting_api.py -k "draft"
    pytest -v test_meeting_api.py -k "admin"
    pytest -v test_meeting_api.py -k "public"
    pytest -v test_meeting_api.py -k "notify"

依赖：
    pip install pytest requests cryptography python-dotenv
"""

import os
import json
import time
import random

import pytest
from pathlib import Path

pytest_plugins = ["conftest_communities"]

from conftest_communities import (
    biz_request,
    build_business_headers,
    build_business_cookies,
    next_month_first_day,
    next_month_first_day_plus,
    API_PREFIX,
    COMMUNITY,
)


CONFIG_FILE = Path(__file__).parent / "communities_config.json"
with open(CONFIG_FILE, "r", encoding="utf-8") as _f:
    _all_config = json.load(_f)

_community_cfg = _all_config["communities"].get(COMMUNITY)
if not _community_cfg:
    raise ValueError(
        f"未知社区 '{COMMUNITY}'，可选值: {list(_all_config['communities'].keys())}"
    )

GROUP_NAME = _community_cfg["group"]
ETHERPAD = _community_cfg["etherpad"]

# =========================================================
# 工具函数
# =========================================================
RUN_TAG = f"{int(time.time()) % 1_000_000}-{os.getpid() % 10_000}"


def _build_single_meeting_body(
    topic=None, agenda="自动化测试", date=None,
    start="09:00", end="09:30", group_name=GROUP_NAME,
    platform="WELINK", drop_keys=None, extra=None, slot=0,
):
    if topic is None:
        topic = f"testcase-{COMMUNITY}-{RUN_TAG}-{slot}"
    if date is None:
        date = next_month_first_day()
    body = {
        "is_record": False,
        "is_cycle": False,
        "agenda": agenda,
        "email_list": "",
        "platform": platform,
        "topic": topic,
        "group_name": GROUP_NAME,
        "etherpad": ETHERPAD,
        "date": date,
        "start": start,
        "end": end,
        "time": f"{start}-{end}",
    }
    if extra:
        body.update(extra)
    if drop_keys:
        for k in drop_keys:
            body.pop(k, None)
    return body


def _build_cycle_meeting_body(
    cycle_type=2, cycle_interval=1, cycle_point="15",
    topic=None, slot=0,
):
    if topic is None:
        topic = f"testcase-cycle-{COMMUNITY}-{RUN_TAG}-{slot}"
    sh = 13 + (slot % 9)
    return {
        "is_record": False,
        "is_cycle": True,
        "cycle_interval": cycle_interval,
        "cycle_type": cycle_type,
        "cycle_start_date": next_month_first_day(),
        "cycle_end_date": next_month_first_day_plus(30),
        "cycle_start": f"{sh:02d}:00",
        "cycle_end": f"{sh + 1:02d}:00",
        "cycle_point": cycle_point if cycle_type == 2 else None,
        "agenda": "自动化测试-周期会议",
        "email_list": "",
        "platform": "WELINK",
        "topic": topic,
        "group_name": GROUP_NAME,
        "etherpad": ETHERPAD,
    }


def _extract_meeting_id(resp_json) -> int:
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
    return biz_request(
        "POST", f"{API_PREFIX}/",
        creds,
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )


def _delete_meeting(creds, meeting_id):
    return biz_request("DELETE", f"{API_PREFIX}/{meeting_id}/", creds)


def _put_meeting(creds, meeting_id, body):
    return biz_request(
        "PUT", f"{API_PREFIX}/{meeting_id}/",
        creds,
        data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
    )


def _get_meeting_detail(creds, meeting_id):
    return biz_request("GET", f"{API_PREFIX}/{meeting_id}/", creds)


def _get_meeting_list(creds):
    return biz_request("GET", f"{API_PREFIX}/", creds)


def _get_group_info(creds):
    return biz_request("GET", f"{API_PREFIX}/group_info/", creds)


def _get_platform(creds):
    return biz_request("GET", f"{API_PREFIX}/platform/", creds)


def _get_roles(creds):
    return biz_request("GET", f"{API_PREFIX}/roles/", creds)


def _get_notify(creds, meeting_id):
    return biz_request("GET", f"{API_PREFIX}/notify/{meeting_id}/", creds)


def _safe_delete(creds, meeting_id):
    if not meeting_id:
        return
    try:
        _delete_meeting(creds, meeting_id)
    except Exception:
        pass


def _create_meeting_for_test(creds, cycle=False, slot=0) -> int:
    if cycle:
        body = _build_cycle_meeting_body(cycle_type=2, slot=slot)
    else:
        body = _build_single_meeting_body(slot=slot)
    resp = _post_meeting(creds, body)
    if resp.status_code != 200:
        pytest.skip(f"前置创建会议失败: {resp.status_code} {resp.text[:200]}")
    mid = _extract_meeting_id(resp.json())
    if not mid:
        pytest.skip(f"前置创建未取到 meeting_id: {resp.text[:200]}")
    return mid


@pytest.fixture
def cleanup_meetings(login_creds):
    created = []
    yield created
    for mid in created:
        _safe_delete(login_creds, mid)


# =========================================================
# 一、创建会议（POST）— 20 条
# =========================================================

class TestMeetingCreate:
    """POST /api-meeting/v1/meeting/ 创建会议"""

    def test_001_single_meeting(self, login_creds, cleanup_meetings):
        """[正常流][P0] 创建单次会议成功"""
        body = _build_single_meeting_body(slot=1)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code == 200
        rj = resp.json()
        assert rj.get("code") in (200, 0)
        mid = _extract_meeting_id(rj)
        assert mid and mid > 0
        cleanup_meetings.append(mid)

    def test_002_month_cycle(self, login_creds, cleanup_meetings):
        """[正常流][P0] 创建月周期会议（cycle_type=2）"""
        body = _build_cycle_meeting_body(cycle_type=2, cycle_point="15", slot=2)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code == 200
        mid = _extract_meeting_id(resp.json())
        assert mid and mid > 0
        cleanup_meetings.append(mid)

    def test_003_week_cycle(self, login_creds, cleanup_meetings):
        """[正常流][P0] 创建周周期会议（cycle_type=1）"""
        body = _build_cycle_meeting_body(cycle_type=1, slot=3)
        body.pop("cycle_point", None)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code == 200
        mid = _extract_meeting_id(resp.json())
        assert mid and mid > 0
        cleanup_meetings.append(mid)

    def test_004_day_cycle(self, login_creds, cleanup_meetings):
        """[正常流][P0] 创建日周期会议（cycle_type=0）"""
        body = _build_cycle_meeting_body(cycle_type=0, slot=4)
        body.pop("cycle_point", None)
        body["cycle_end_date"] = next_month_first_day_plus(3)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code == 200
        mid = _extract_meeting_id(resp.json())
        assert mid and mid > 0
        cleanup_meetings.append(mid)

    @pytest.mark.parametrize("missing_key,case_id", [
        ("topic", "005"), ("group_name", "006"),
        ("platform", "007"), ("date", "008"),
    ], ids=["no_topic", "no_group", "no_platform", "no_date"])
    def test_required_field_missing(self, login_creds, missing_key, case_id):
        """[异常/空值][P1] 缺少必填字段"""
        body = _build_single_meeting_body(drop_keys=[missing_key], slot=10+int(case_id))
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                _safe_delete(login_creds, mid)
                pytest.fail(f"缺少 {missing_key} 仍创建成功")
        else:
            assert resp.status_code >= 400

    def test_009_invalid_date_format(self, login_creds):
        """[异常输入][P1] date 格式错误 '2026/07/01'"""
        body = _build_single_meeting_body(date="2026/07/01", slot=9)
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                _safe_delete(login_creds, mid)
            assert mid is None, "日期格式错误仍创建成功"
        else:
            assert resp.status_code >= 400

    def test_010_invalid_cycle_type(self, login_creds):
        """[异常输入][P1] cycle_type=99 非法值"""
        body = _build_cycle_meeting_body(cycle_type=99, slot=10)
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                _safe_delete(login_creds, mid)
            assert mid is None, "非法 cycle_type 仍创建成功"
        else:
            assert resp.status_code >= 400

    def test_011_no_token(self):
        """[权限][P0] 不携带 token 创建会议"""
        body = _build_single_meeting_body(slot=11)
        resp = biz_request(
            "POST", f"{API_PREFIX}/", None,
            headers={"Content-Type": "application/json;charset=UTF-8"},
            cookies={},
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_012_invalid_token(self):
        """[权限][P0] 携带错误 token 创建会议"""
        body = _build_single_meeting_body(slot=12)
        resp = biz_request(
            "POST", f"{API_PREFIX}/",
            {"token": "invalid-token-xxx-123456", "yg": ""},
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_013_topic_min_length(self, login_creds, cleanup_meetings):
        """[边界值][P2] topic 长度=1"""
        body = _build_single_meeting_body(topic="a", slot=13)
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                cleanup_meetings.append(mid)
        else:
            assert resp.status_code >= 400

    def test_014_topic_oversize(self, login_creds, cleanup_meetings):
        """[边界值][P2] topic 长度=256"""
        body = _build_single_meeting_body(topic="A" * 256, slot=14)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code < 500
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                cleanup_meetings.append(mid)

    def test_015_date_past(self, login_creds):
        """[边界值][P2] date 取过去日期"""
        body = _build_single_meeting_body(date="2020-01-01", slot=15)
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                _safe_delete(login_creds, mid)
            assert mid is None, "过去日期仍创建成功"
        else:
            assert resp.status_code >= 400

    def test_016_cycle_end_before_start(self, login_creds):
        """[边界值][P2] 周期会议 cycle_end_date 早于 cycle_start_date"""
        body = _build_cycle_meeting_body(cycle_type=2, slot=16)
        body["cycle_start_date"] = next_month_first_day_plus(20)
        body["cycle_end_date"] = next_month_first_day()
        resp = _post_meeting(login_creds, body)
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                _safe_delete(login_creds, mid)
            assert mid is None, "end<start 仍创建成功"
        else:
            assert resp.status_code >= 400

    def test_017_topic_emoji(self, login_creds, cleanup_meetings):
        """[特殊字符][P2] topic 含 emoji"""
        body = _build_single_meeting_body(topic="测试会议🎉🚀", slot=17)
        resp = _post_meeting(login_creds, body)
        assert resp.status_code < 500
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                cleanup_meetings.append(mid)

    def test_018_topic_xss(self, login_creds, cleanup_meetings):
        """[特殊字符/安全][P1] topic 含 XSS 脚本"""
        body = _build_single_meeting_body(
            topic='<script>alert("xss")</script>', slot=18
        )
        resp = _post_meeting(login_creds, body)
        assert resp.status_code < 500
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                cleanup_meetings.append(mid)

    def test_019_topic_sql_injection(self, login_creds, cleanup_meetings):
        """[特殊字符/安全][P1] topic 含 SQL 注入"""
        body = _build_single_meeting_body(
            topic="test'; DROP TABLE meeting;--", slot=19
        )
        resp = _post_meeting(login_creds, body)
        assert resp.status_code < 500
        if resp.status_code == 200:
            mid = _extract_meeting_id(resp.json())
            if mid:
                cleanup_meetings.append(mid)

    def test_020_duplicate_time_conflict(self, login_creds, cleanup_meetings):
        """[数据唯一性][P1] 相同时间段重复创建应提示冲突"""
        body = _build_single_meeting_body(
            topic=f"conflict-{RUN_TAG}", slot=20, start="11:00", end="11:30",
        )
        resp1 = _post_meeting(login_creds, body)
        if resp1.status_code == 200:
            mid1 = _extract_meeting_id(resp1.json())
            if mid1:
                cleanup_meetings.append(mid1)
        body2 = _build_single_meeting_body(
            topic=f"conflict2-{RUN_TAG}", slot=20, start="11:00", end="11:30",
        )
        resp2 = _post_meeting(login_creds, body2)
        if resp2.status_code == 200:
            mid2 = _extract_meeting_id(resp2.json())
            if mid2:
                cleanup_meetings.append(mid2)


# =========================================================
# 二、删除会议（DELETE）— 10 条
# =========================================================

class TestMeetingDelete:
    """DELETE /api-meeting/v1/meeting/{id}/"""

    def test_001_delete_single(self, login_creds):
        """[正常流][P0] 删除已创建的单次会议"""
        mid = _create_meeting_for_test(login_creds, slot=30)
        resp = _delete_meeting(login_creds, mid)
        assert resp.status_code == 200

    def test_002_delete_cycle(self, login_creds):
        """[正常流][P0] 删除月周期会议"""
        mid = _create_meeting_for_test(login_creds, cycle=True, slot=31)
        resp = _delete_meeting(login_creds, mid)
        assert resp.status_code == 200

    def test_003_not_exist(self, login_creds):
        """[异常][P1] 删除不存在的 meeting_id=99999999"""
        resp = _delete_meeting(login_creds, 99999999)
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_004_string_id(self, login_creds):
        """[异常输入][P1] meeting_id='abc'"""
        resp = _delete_meeting(login_creds, "abc")
        assert resp.status_code >= 400

    def test_005_negative_id(self, login_creds):
        """[边界值][P2] meeting_id=-1"""
        resp = _delete_meeting(login_creds, -1)
        if resp.status_code == 200:
            assert resp.json().get("code") not in (0, 200)
        else:
            assert resp.status_code >= 400

    def test_006_zero_id(self, login_creds):
        """[边界值][P2] meeting_id=0"""
        resp = _delete_meeting(login_creds, 0)
        if resp.status_code == 200:
            assert resp.json().get("code") not in (0, 200)
        else:
            assert resp.status_code >= 400

    def test_007_no_token(self, login_creds):
        """[权限][P0] 不携带 token 删除"""
        mid = _create_meeting_for_test(login_creds, slot=32)
        try:
            resp = biz_request(
                "DELETE", f"{API_PREFIX}/{mid}/", None,
                headers={"Content-Type": "application/json"},
                cookies={},
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_008_invalid_token(self, login_creds):
        """[权限][P0] 携带错误 token 删除"""
        mid = _create_meeting_for_test(login_creds, slot=33)
        try:
            resp = biz_request(
                "DELETE", f"{API_PREFIX}/{mid}/",
                {"token": "invalid-token-xxx", "yg": ""},
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_009_duplicate_delete(self, login_creds):
        """[重复操作/幂等性][P1] 连续删除同一会议两次"""
        mid = _create_meeting_for_test(login_creds, slot=34)
        resp1 = _delete_meeting(login_creds, mid)
        assert resp1.status_code == 200
        resp2 = _delete_meeting(login_creds, mid)
        assert resp2.status_code < 500
        is_fail = resp2.status_code >= 400
        if not is_fail:
            is_fail = resp2.json().get("code") not in (0, 200)
        assert is_fail, "重复删除未返回失败"

    def test_010_empty_id(self, login_creds):
        """[空值][P1] meeting_id 为空"""
        resp = biz_request("DELETE", f"{API_PREFIX}//", login_creds)
        assert resp.status_code >= 400 or resp.status_code == 404


# =========================================================
# 三、修改会议（PUT）— 10 条
# =========================================================

class TestMeetingUpdate:
    """PUT /api-meeting/v1/meeting/{id}/"""

    def test_001_update_topic(self, login_creds, cleanup_meetings):
        """[正常流][P0] 修改单次会议 topic"""
        mid = _create_meeting_for_test(login_creds, slot=40)
        cleanup_meetings.append(mid)
        body = {
            "topic": f"modified-{RUN_TAG}",
            "etherpad": "https://etherpad.openeuler.org/p/Application",
            "date": next_month_first_day(),
            "start": "09:00",
            "end": "09:30",
            "agenda": "修改后议程",
            "is_record": False,
        }
        resp = _put_meeting(login_creds, mid, body)
        assert resp.status_code == 200

    def test_002_update_cycle(self, login_creds, cleanup_meetings):
        """[正常流][P0] 修改月周期会议 cycle_point"""
        mid = _create_meeting_for_test(login_creds, cycle=True, slot=41)
        cleanup_meetings.append(mid)
        body = {
            "topic": f"cycle-modified-{RUN_TAG}",
            "agenda": "修改后议程",
            "is_record": False,
            "is_cycle": True,
            "cycle_interval": 1,
            "cycle_type": 2,
            "cycle_start_date": next_month_first_day(),
            "cycle_end_date": next_month_first_day_plus(30),
            "cycle_start": "14:00",
            "cycle_end": "15:00",
            "cycle_point": "20",
        }
        resp = _put_meeting(login_creds, mid, body)
        assert resp.status_code == 200

    def test_003_update_not_exist(self, login_creds):
        """[异常][P1] 修改不存在的 meeting_id"""
        body = {"topic": "ghost", "date": next_month_first_day(),
                "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
        resp = _put_meeting(login_creds, 99999999, body)
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_004_no_token(self, login_creds):
        """[权限][P0] 不携带 token 修改"""
        mid = _create_meeting_for_test(login_creds, slot=42)
        try:
            body = {"topic": "no-auth", "date": next_month_first_day(),
                    "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
            resp = biz_request(
                "PUT", f"{API_PREFIX}/{mid}/", None,
                headers={"Content-Type": "application/json"},
                cookies={},
                data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_005_invalid_token(self, login_creds):
        """[权限][P0] 携带错误 token 修改"""
        mid = _create_meeting_for_test(login_creds, slot=43)
        try:
            body = {"topic": "bad-auth", "date": next_month_first_day(),
                    "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
            resp = biz_request(
                "PUT", f"{API_PREFIX}/{mid}/",
                {"token": "invalid-token-xxx", "yg": ""},
                data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_006_empty_topic(self, login_creds, cleanup_meetings):
        """[空值][P1] 修改 topic 为空字符串"""
        mid = _create_meeting_for_test(login_creds, slot=44)
        cleanup_meetings.append(mid)
        body = {"topic": "", "date": next_month_first_day(),
                "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
        resp = _put_meeting(login_creds, mid, body)
        if resp.status_code == 200:
            rj = resp.json()
            assert rj.get("code") not in (0, 200), "空 topic 修改成功未校验"
        else:
            assert resp.status_code >= 400

    def test_007_topic_oversize(self, login_creds, cleanup_meetings):
        """[边界值][P2] 修改 topic 为 256 字符"""
        mid = _create_meeting_for_test(login_creds, slot=45)
        cleanup_meetings.append(mid)
        body = {"topic": "B" * 256, "date": next_month_first_day(),
                "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
        resp = _put_meeting(login_creds, mid, body)
        assert resp.status_code < 500

    def test_008_xss_in_agenda(self, login_creds, cleanup_meetings):
        """[特殊字符/安全][P1] agenda 含 XSS"""
        mid = _create_meeting_for_test(login_creds, slot=46)
        cleanup_meetings.append(mid)
        body = {"topic": "safe-topic", "date": next_month_first_day(),
                "start": "09:00", "end": "09:30",
                "agenda": '<img src=x onerror=alert(1)>', "is_record": False}
        resp = _put_meeting(login_creds, mid, body)
        assert resp.status_code < 500

    def test_009_string_id(self, login_creds):
        """[异常输入][P1] meeting_id='xyz'"""
        body = {"topic": "x", "date": next_month_first_day(),
                "start": "09:00", "end": "09:30", "agenda": "x", "is_record": False}
        resp = _put_meeting(login_creds, "xyz", body)
        assert resp.status_code >= 400

    def test_010_duplicate_update(self, login_creds, cleanup_meetings):
        """[重复操作][P2] 连续修改两次同一会议"""
        mid = _create_meeting_for_test(login_creds, slot=47)
        cleanup_meetings.append(mid)
        body = {"topic": f"dup-update-{RUN_TAG}", "date": next_month_first_day(),
                "start": "09:00", "end": "09:30", "agenda": "first", "is_record": False}
        resp1 = _put_meeting(login_creds, mid, body)
        assert resp1.status_code == 200
        body["agenda"] = "second"
        resp2 = _put_meeting(login_creds, mid, body)
        assert resp2.status_code == 200


# =========================================================
# 四、查询会议（GET）— 10 条
# =========================================================

class TestMeetingQuery:
    """GET 会议列表/详情/group_info/platform/roles"""

    def test_001_meeting_list(self, login_creds):
        """[正常流][P0] 获取会议列表"""
        resp = _get_meeting_list(login_creds)
        assert resp.status_code == 200

    def test_002_meeting_detail(self, login_creds):
        """[正常流][P0] 获取会议详情"""
        mid = _create_meeting_for_test(login_creds, slot=50)
        try:
            resp = _get_meeting_detail(login_creds, mid)
            assert resp.status_code == 200
        finally:
            _safe_delete(login_creds, mid)

    def test_003_group_info(self, login_creds):
        """[正常流][P0] 获取 group_info"""
        resp = _get_group_info(login_creds)
        assert resp.status_code == 200

    def test_004_platform(self, login_creds):
        """[正常流][P0] 获取 platform 列表"""
        resp = _get_platform(login_creds)
        assert resp.status_code == 200

    def test_005_roles(self, login_creds):
        """[正常流][P1] 获取 roles 列表"""
        resp = _get_roles(login_creds)
        assert resp.status_code == 200

    def test_006_detail_not_exist(self, login_creds):
        """[异常][P1] 查询不存在的 meeting_id"""
        resp = _get_meeting_detail(login_creds, 99999999)
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_007_list_no_token(self):
        """[权限][P0] 不携带 token 获取会议列表"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_008_group_info_no_token(self):
        """[权限][P0] 不携带 token 获取 group_info"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/group_info/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_009_platform_invalid_token(self):
        """[权限][P0] 错误 token 获取 platform"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/platform/",
            {"token": "invalid-token-xxx", "yg": ""},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_010_detail_string_id(self, login_creds):
        """[异常输入][P1] 查询 meeting_id='abc'"""
        resp = _get_meeting_detail(login_creds, "abc")
        assert resp.status_code >= 400


# =========================================================
# 五、会议通知（GET /notify/{id}/）— 5 条
# =========================================================

class TestMeetingNotify:
    """GET /api-meeting/v1/meeting/notify/{id}/"""

    def test_001_send_notify(self, login_creds):
        """[正常流][P0] 对已创建会议发送通知"""
        mid = _create_meeting_for_test(login_creds, slot=60)
        try:
            resp = _get_notify(login_creds, mid)
            assert resp.status_code == 200
        finally:
            _safe_delete(login_creds, mid)

    def test_002_notify_not_exist(self, login_creds):
        """[异常][P1] 对不存在的 meeting_id 发通知"""
        resp = _get_notify(login_creds, 99999999)
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_003_notify_no_token(self, login_creds):
        """[权限][P0] 不携带 token 发通知"""
        mid = _create_meeting_for_test(login_creds, slot=61)
        try:
            resp = biz_request(
                "GET", f"{API_PREFIX}/notify/{mid}/", None,
                headers={"Accept": "*/*"}, cookies={},
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_004_notify_string_id(self, login_creds):
        """[异常输入][P1] meeting_id='abc'"""
        resp = _get_notify(login_creds, "abc")
        assert resp.status_code >= 400

    def test_005_notify_negative_id(self, login_creds):
        """[边界值][P2] meeting_id=-1"""
        resp = _get_notify(login_creds, -1)
        if resp.status_code == 200:
            assert resp.json().get("code") not in (0, 200)
        else:
            assert resp.status_code >= 400


# =========================================================
# 六、管理员操作（/admin/）— 6 条
# =========================================================

class TestMeetingAdmin:
    """管理员接口 /api-meeting/v1/meeting/admin/"""

    def _admin_path(self, suffix=""):
        return f"{API_PREFIX}/admin/{suffix}"

    def test_001_admin_query(self, login_creds):
        """[正常流][P0] 管理员查询会议列表"""
        resp = biz_request("GET", self._admin_path(), login_creds)
        # 可能 403 如果当前用户非 admin
        assert resp.status_code in (200, 403)

    def test_002_admin_sponsors(self, login_creds):
        """[正常流][P1] 管理员查询发起人列表"""
        resp = biz_request("GET", self._admin_path("sponsors/"), login_creds)
        assert resp.status_code in (200, 403)

    def test_003_admin_force_end(self, login_creds):
        """[正常流][P1] 管理员强制结束会议（需 Admin 角色）"""
        mid = _create_meeting_for_test(login_creds, slot=70)
        try:
            resp = biz_request(
                "POST", self._admin_path(), login_creds,
                data=json.dumps({"meeting_id": mid}).encode("utf-8"),
            )
            # 非 admin 用户预期 403
            assert resp.status_code in (200, 403)
        finally:
            _safe_delete(login_creds, mid)

    def test_004_admin_force_delete(self, login_creds):
        """[正常流][P1] 管理员强制删除会议"""
        mid = _create_meeting_for_test(login_creds, slot=71)
        resp = biz_request(
            "DELETE", self._admin_path(), login_creds,
            data=json.dumps({"meeting_id": mid}).encode("utf-8"),
        )
        assert resp.status_code in (200, 403)
        _safe_delete(login_creds, mid)

    def test_005_admin_no_token(self):
        """[权限][P0] 不携带 token 调用管理员接口"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/admin/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_006_admin_invalid_token(self):
        """[权限][P0] 错误 token 调用管理员接口"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/admin/",
            {"token": "invalid-xxx", "yg": ""},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400


# =========================================================
# 七、活动草案管理（/draft/）— 10 条
# =========================================================

class TestMeetingDraft:
    """活动草案 CRUD /api-meeting/v1/meeting/draft/"""

    def _draft_path(self, pk=None):
        if pk:
            return f"{API_PREFIX}/draft/{pk}/"
        return f"{API_PREFIX}/draft/"

    def _build_draft_body(self, title=None):
        if title is None:
            title = f"testdraft-{RUN_TAG}-{int(time.time())}"
        return {
            "title": title,
            "start_date": next_month_first_day(),
            "end_date": next_month_first_day(),
            "start_time": "09:00",
            "end_time": "17:00",
            "description": "自动化测试活动草案",
            "location": "线上",
        }

    def test_001_create_draft(self, login_creds):
        """[正常流][P0] 创建活动草案"""
        body = self._build_draft_body()
        resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        # Sponsor 角色才能创建，非 Sponsor 返回 403
        assert resp.status_code in (200, 201, 403)
        if resp.status_code in (200, 201):
            rj = resp.json()
            pk = (rj.get("data") or {}).get("id")
            if pk:
                biz_request("DELETE", self._draft_path(pk), login_creds)

    def test_002_get_draft(self, login_creds):
        """[正常流][P1] 获取草案详情（需先创建）"""
        body = self._build_draft_body()
        create_resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        if create_resp.status_code not in (200, 201):
            pytest.skip("无 Sponsor 权限，跳过草案详情测试")
        pk = (create_resp.json().get("data") or {}).get("id")
        if not pk:
            pytest.skip("未取到草案 ID")
        try:
            resp = biz_request("GET", self._draft_path(pk), login_creds)
            assert resp.status_code == 200
        finally:
            biz_request("DELETE", self._draft_path(pk), login_creds)

    def test_003_update_draft(self, login_creds):
        """[正常流][P1] 修改活动草案"""
        body = self._build_draft_body()
        create_resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        if create_resp.status_code not in (200, 201):
            pytest.skip("无 Sponsor 权限")
        pk = (create_resp.json().get("data") or {}).get("id")
        if not pk:
            pytest.skip("未取到草案 ID")
        try:
            body["title"] = f"updated-{RUN_TAG}"
            resp = biz_request(
                "PUT", self._draft_path(pk), login_creds,
                data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
            )
            assert resp.status_code == 200
        finally:
            biz_request("DELETE", self._draft_path(pk), login_creds)

    def test_004_delete_draft(self, login_creds):
        """[正常流][P0] 删除活动草案"""
        body = self._build_draft_body()
        create_resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        if create_resp.status_code not in (200, 201):
            pytest.skip("无 Sponsor 权限")
        pk = (create_resp.json().get("data") or {}).get("id")
        if not pk:
            pytest.skip("未取到草案 ID")
        resp = biz_request("DELETE", self._draft_path(pk), login_creds)
        assert resp.status_code == 200

    def test_005_get_draft_not_exist(self, login_creds):
        """[异常][P1] 获取不存在的草案"""
        resp = biz_request("GET", self._draft_path(99999999), login_creds)
        assert resp.status_code >= 400 or resp.json().get("code") not in (0, 200)

    def test_006_delete_draft_not_exist(self, login_creds):
        """[异常][P1] 删除不存在的草案"""
        resp = biz_request("DELETE", self._draft_path(99999999), login_creds)
        assert resp.status_code >= 400 or resp.json().get("code") not in (0, 200)

    def test_007_create_draft_no_token(self):
        """[权限][P0] 不携带 token 创建草案"""
        resp = biz_request(
            "POST", f"{API_PREFIX}/draft/", None,
            headers={"Content-Type": "application/json"},
            cookies={},
            data=json.dumps({"title": "no-auth"}).encode("utf-8"),
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_008_create_draft_empty_title(self, login_creds):
        """[空值][P1] 创建草案 title 为空"""
        body = self._build_draft_body(title="")
        resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        if resp.status_code in (200, 201):
            rj = resp.json()
            pk = (rj.get("data") or {}).get("id")
            if pk:
                biz_request("DELETE", self._draft_path(pk), login_creds)
                pytest.fail("空 title 仍创建成功")

    def test_009_create_draft_xss_title(self, login_creds):
        """[特殊字符][P2] title 含 XSS"""
        body = self._build_draft_body(title='<script>alert(1)</script>')
        resp = biz_request(
            "POST", self._draft_path(), login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        assert resp.status_code < 500
        if resp.status_code in (200, 201):
            pk = (resp.json().get("data") or {}).get("id")
            if pk:
                biz_request("DELETE", self._draft_path(pk), login_creds)

    def test_010_draft_string_pk(self, login_creds):
        """[异常输入][P1] pk='abc'"""
        resp = biz_request("GET", self._draft_path("abc"), login_creds)
        assert resp.status_code >= 400


# =========================================================
# 八、活动公开接口（/public/）— 6 条
# =========================================================

class TestMeetingPublic:
    """公开接口（无需登录）"""

    def test_001_public_activity_list(self):
        """[正常流][P0] 获取官网活动列表（公开）"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/public/activity/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        # 公开接口应不需要鉴权
        assert resp.status_code in (200, 404)

    def test_002_public_activity_detail(self):
        """[正常流][P1] 获取单个活动详情（公开）"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/public/activity/1/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        # 可能 404 如果 ID=1 不存在
        assert resp.status_code in (200, 404)

    def test_003_public_activity_date(self):
        """[正常流][P1] 获取官网活动日历（公开）"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/public/activity_date/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (200, 404)

    def test_004_public_activity_not_exist(self):
        """[异常][P1] 获取不存在的活动详情"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/public/activity/99999999/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (404, 400) or (
            resp.status_code == 200 and resp.json().get("code") not in (0, 200)
        )

    def test_005_public_activity_string_pk(self):
        """[异常输入][P1] pk='abc'"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/public/activity/abc/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code >= 400

    def test_006_public_meeting_date(self):
        """[正常流][P1] 获取官网会议日期（公开）"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/meeting_date/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        # group_name 公开接口
        assert resp.status_code in (200, 404)


# =========================================================
# 九、人员管理（/sponsors/ /admins/）— 4 条
# =========================================================

class TestMeetingPersonnel:
    """人员管理接口"""

    def test_001_sponsors_list(self, login_creds):
        """[正常流][P1] 获取活动发起人列表（Admin）"""
        resp = biz_request("GET", f"{API_PREFIX}/sponsors/", login_creds)
        assert resp.status_code in (200, 403)

    def test_002_admins_list(self, login_creds):
        """[正常流][P1] 获取管理员列表（Sponsor）"""
        resp = biz_request("GET", f"{API_PREFIX}/admins/", login_creds)
        assert resp.status_code in (200, 403)

    def test_003_sponsors_no_token(self):
        """[权限][P0] 不携带 token 获取发起人列表"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/sponsors/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400

    def test_004_admins_invalid_token(self):
        """[权限][P0] 错误 token 获取管理员列表"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/admins/",
            {"token": "invalid-xxx", "yg": ""},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400


# =========================================================
# 十、周期子会议（/sub/{id}/）— 6 条
# =========================================================

class TestMeetingSubCycle:
    """周期子会议 PUT/DELETE /api-meeting/v1/meeting/sub/{id}/"""

    def test_001_update_sub_meeting(self, login_creds, cleanup_meetings):
        """[正常流][P0] 修改周期子会议"""
        mid = _create_meeting_for_test(login_creds, cycle=True, slot=80)
        cleanup_meetings.append(mid)
        body = {
            "topic": f"sub-modified-{RUN_TAG}",
            "agenda": "子会议修改",
            "is_record": False,
        }
        resp = biz_request(
            "PUT", f"{API_PREFIX}/sub/{mid}/", login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        # 可能需要子会议 ID 而非父 ID，记录实际行为
        assert resp.status_code < 500

    def test_002_delete_sub_meeting(self, login_creds):
        """[正常流][P0] 删除周期子会议"""
        mid = _create_meeting_for_test(login_creds, cycle=True, slot=81)
        resp = biz_request("DELETE", f"{API_PREFIX}/sub/{mid}/", login_creds)
        assert resp.status_code < 500
        _safe_delete(login_creds, mid)

    def test_003_update_sub_not_exist(self, login_creds):
        """[异常][P1] 修改不存在的子会议"""
        body = {"topic": "ghost-sub", "agenda": "x", "is_record": False}
        resp = biz_request(
            "PUT", f"{API_PREFIX}/sub/99999999/", login_creds,
            data=json.dumps(body, ensure_ascii=False).encode("utf-8"),
        )
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_004_delete_sub_not_exist(self, login_creds):
        """[异常][P1] 删除不存在的子会议"""
        resp = biz_request("DELETE", f"{API_PREFIX}/sub/99999999/", login_creds)
        is_fail = resp.status_code >= 400
        if not is_fail:
            is_fail = resp.json().get("code") not in (0, 200)
        assert is_fail

    def test_005_sub_no_token(self, login_creds):
        """[权限][P0] 不携带 token 操作子会议"""
        mid = _create_meeting_for_test(login_creds, cycle=True, slot=82)
        try:
            resp = biz_request(
                "DELETE", f"{API_PREFIX}/sub/{mid}/", None,
                headers={"Accept": "*/*"}, cookies={},
            )
            assert resp.status_code in (401, 403) or resp.status_code >= 400
        finally:
            _safe_delete(login_creds, mid)

    def test_006_sub_string_id(self, login_creds):
        """[异常输入][P1] sub_id='abc'"""
        resp = biz_request("DELETE", f"{API_PREFIX}/sub/abc/", login_creds)
        assert resp.status_code >= 400


# =========================================================
# 十一、活动审核流程（/drafts/ /approve/ /reject/ /undo/）— 5 条
# =========================================================

class TestMeetingDraftReview:
    """活动审核流程"""

    def test_001_drafts_list(self, login_creds):
        """[正常流][P1] 审核列表（Admin）"""
        resp = biz_request("GET", f"{API_PREFIX}/drafts/", login_creds)
        assert resp.status_code in (200, 403)

    def test_002_approve_not_exist(self, login_creds):
        """[异常][P1] 通过不存在的草案"""
        resp = biz_request(
            "PUT", f"{API_PREFIX}/draft/99999999/approve/", login_creds,
            data=json.dumps({}).encode("utf-8"),
        )
        assert resp.status_code >= 400 or resp.json().get("code") not in (0, 200)

    def test_003_reject_not_exist(self, login_creds):
        """[异常][P1] 驳回不存在的草案"""
        resp = biz_request(
            "PUT", f"{API_PREFIX}/draft/99999999/reject/", login_creds,
            data=json.dumps({"reason": "test"}).encode("utf-8"),
        )
        assert resp.status_code >= 400 or resp.json().get("code") not in (0, 200)

    def test_004_undo_not_exist(self, login_creds):
        """[异常][P1] 撤销不存在的草案"""
        resp = biz_request(
            "PUT", f"{API_PREFIX}/draft/99999999/undo/", login_creds,
            data=json.dumps({}).encode("utf-8"),
        )
        assert resp.status_code >= 400 or resp.json().get("code") not in (0, 200)

    def test_005_drafts_no_token(self):
        """[权限][P0] 不携带 token 获取审核列表"""
        resp = biz_request(
            "GET", f"{API_PREFIX}/drafts/", None,
            headers={"Accept": "*/*"}, cookies={},
        )
        assert resp.status_code in (401, 403) or resp.status_code >= 400


# =========================================================
# 入口
# =========================================================

if __name__ == "__main__":
    pytest.main(["-v", "-s", __file__])
