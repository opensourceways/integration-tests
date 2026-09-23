#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
增强元素操作

封装 7 条铁律中涉及的元素操作：下拉选择、禁用态断言、Toast 捕获。
"""

import re
from playwright.sync_api import TimeoutError as PWTimeout
from common.constants import TIMEOUT
from common.debug_utils import log


def select_dropdown_option(page, container_selector: str, option_text: str) -> None:
    """
    选择下拉选项（处理 Vue Teleport 到 body 的情况）。

    :param container_selector: 下拉容器选择器（如 ".custom-day .o-select"）
    :param option_text: 选项文本（如 "7天"）

    内置铁律 F-15/F-16：
      - 点 .o-select 容器而非内层 readonly input
      - 等待与点击选项时不能带容器前缀（已 teleport 到 body）
    """
    page.locator(container_selector).click()
    page.wait_for_selector(".o-select-options:visible", timeout=TIMEOUT)
    page.locator(
        ".o-select-options:visible .o-option",
        has_text=re.compile(rf"^{re.escape(option_text)}$")
    ).first.click()
    page.wait_for_selector(".o-select-options:visible", state="hidden", timeout=TIMEOUT)
    log(f"  已选择 {option_text}")


def assert_button_disabled(locator, should_be_disabled: bool = True) -> bool:
    """
    断言按钮禁用态（查 CSS class 而非 disabled 属性）。

    内置铁律 F-18：禁用态只有 o-btn-disabled class，is_disabled() 恒返回 False。

    :param locator: 按钮定位器
    :param should_be_disabled: 期望的禁用态
    :return: 实际禁用态是否符合预期
    """
    cls = locator.get_attribute("class") or ""
    actual_disabled = "o-btn-disabled" in cls
    if actual_disabled != should_be_disabled:
        log(f"  !! 按钮禁用态不符：期望 {should_be_disabled}，实际 {actual_disabled}")
        return False
    return True


def wait_toast(page, text: str, timeout: int = 8_000) -> bool:
    """
    等待 Toast 出现并校验文本。

    Toast 自动消失，必须在触发动作后立刻捕获。

    :param page: Playwright 页面对象
    :param text: 期望的 Toast 文本
    :param timeout: 超时时间（毫秒）
    :return: Toast 是否出现且文本匹配
    """
    try:
        page.wait_for_selector(f".o-message-content:text-is('{text}')", timeout=timeout)
        log(f"  ✅ Toast：{text}")
        return True
    except PWTimeout:
        log(f"  未捕获 Toast「{text}」")
        return False
