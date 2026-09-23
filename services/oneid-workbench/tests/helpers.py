#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试辅助函数

提供测试用例的通用断言和验证逻辑。
"""

import re
from common.debug_utils import log


def assert_datetime_format(dt_str: str, allow_seconds: bool = False):
    """
    断言日期时间格式（YYYY/MM/DD HH:mm 或 YYYY/MM/DD HH:mm:ss）。

    :param dt_str: 日期时间字符串
    :param allow_seconds: 是否允许秒（有些字段有秒，有些没有）
    """
    if allow_seconds:
        pattern = r'^\d{4}/\d{2}/\d{2} \d{2}:\d{2}(:\d{2})?$'
    else:
        pattern = r'^\d{4}/\d{2}/\d{2} \d{2}:\d{2}$'

    assert re.match(pattern, dt_str), f"日期时间格式错误: {dt_str}"


def assert_token_format(token: str):
    """
    断言令牌明文格式（32位十六进制字符串）。

    :param token: 令牌明文字符串
    """
    assert len(token) == 32, f"令牌长度错误: {len(token)} (期望 32)"
    assert token.isalnum(), f"令牌格式错误: {token[:10]}... (应只包含字母和数字)"


def verify_table_headers(page, expected_headers: list[str]):
    """
    验证表格表头。

    :param page: Playwright 页面对象
    :param expected_headers: 期望的表头文案列表
    """
    headers = page.locator(".private-token-list thead th")
    actual_headers = [headers.nth(i).inner_text().strip() for i in range(headers.count())]

    assert actual_headers == expected_headers, \
        f"表头不匹配\n期望: {expected_headers}\n实际: {actual_headers}"

    log(f"✅ 表头验证通过: {expected_headers}")
