# -*- coding: utf-8 -*-
"""
断言工具模块
封装基础断言与业务断言，统一失败信息格式
"""
import json
from typing import Any, Optional, List, Type

from logger import get_logger

logger = get_logger(__name__)


class AssertionResult:
    """单条断言结果"""

    def __init__(self, name: str, passed: bool, message: str = ""):
        self.name = name
        self.passed = passed
        self.message = message

    def __repr__(self) -> str:
        status = "PASS" if self.passed else "FAIL"
        return f"[{status}] {self.name}: {self.message}"


class AssertionGroup:
    """一组断言的汇总结果"""

    def __init__(self, case_id: str = ""):
        self.case_id = case_id
        self.results: List[AssertionResult] = []

    def add(self, result: AssertionResult):
        self.results.append(result)

    @property
    def all_passed(self) -> bool:
        return all(r.passed for r in self.results)

    @property
    def failures(self) -> List[AssertionResult]:
        return [r for r in self.results if not r.passed]

    def summary(self) -> str:
        total = len(self.results)
        passed = sum(1 for r in self.results if r.passed)
        lines = [f"用例 {self.case_id} 断言汇总: 通过 {passed}/{total}"]
        for r in self.results:
            icon = "✓" if r.passed else "✗"
            lines.append(f"  {icon} {r.name}: {r.message}")
        return "\n".join(lines)


def assert_http_status(actual: int, expected: int = 200, group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言 HTTP 响应状态码
    """
    passed = actual == expected
    msg = f"期望 HTTP status={expected}, 实际={actual}" if not passed else f"HTTP status={actual}"
    result = AssertionResult(name="HTTP状态码断言", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result


def assert_business_status(actual: Optional[int], expected: int = 200, group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言业务状态码（response body 中的 status / code 字段）
    """
    passed = actual == expected
    msg = f"期望业务 status={expected}, 实际={actual}" if not passed else f"业务 status={actual}"
    result = AssertionResult(name="业务状态码断言", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result


def assert_field_exists(data: dict, field: str, group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言字段存在
    """
    passed = isinstance(data, dict) and field in data
    msg = f"字段 '{field}' {'存在' if passed else '缺失'}"
    result = AssertionResult(name=f"字段存在性断言[{field}]", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg} | data={json.dumps(data, ensure_ascii=False)[:200]}")
    return result


def assert_field_type(value: Any, expected_type: Type, field_name: str = "", group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言字段数据类型
    """
    passed = isinstance(value, expected_type)
    msg = f"字段 '{field_name}' 期望类型 {expected_type.__name__}, 实际类型 {type(value).__name__}"
    if passed:
        msg = f"字段 '{field_name}' 类型正确: {expected_type.__name__}"
    result = AssertionResult(name=f"字段类型断言[{field_name}]", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result


def assert_not_none(value: Any, name: str = "value", group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言值不为 None
    """
    passed = value is not None
    msg = f"{name} {'不为 None' if passed else '为 None'}"
    result = AssertionResult(name=f"非空断言[{name}]", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result


def assert_contains(text: str, substring: str, group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言字符串包含子串
    """
    passed = substring in text
    msg = f"'{substring}' {'包含于' if passed else '不包含于'} 文本"
    result = AssertionResult(name=f"包含断言[{substring}]", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result


def assert_list_not_empty(lst: list, name: str = "list", group: Optional[AssertionGroup] = None) -> AssertionResult:
    """
    断言列表非空
    """
    passed = isinstance(lst, list) and len(lst) > 0
    msg = f"{name} {'非空 (长度={})'.format(len(lst)) if passed else '为空或类型错误'}"
    result = AssertionResult(name=f"列表非空断言[{name}]", passed=passed, message=msg)
    if group:
        group.add(result)
    if not passed:
        logger.error(f"[断言失败] {msg}")
    return result
