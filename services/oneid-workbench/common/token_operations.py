#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
令牌业务操作封装

封装 phase1_probe_write.py 的高频模式：
  - 打开创建/编辑表单
  - 填写表单字段
  - 抓取令牌明文
  - 定位数据行
"""

import re
from playwright.sync_api import TimeoutError as PWTimeout
from common.constants import TIMEOUT
from common.browser_helper import wait_hydrated
from common.element_actions import select_dropdown_option
from common.debug_utils import log


def open_create_form(page, attempts: int = 3) -> None:
    """
    点开创建表单，带误跳自愈（hydration 未完成时点击会跳到 settings 页）。

    内置铁律 F-11：等 hydration 收敛后再点击。

    :param page: Playwright 页面对象
    :param attempts: 最大尝试次数（默认 3 次）
    """
    from common.constants import TARGET_URL

    for i in range(1, attempts + 1):
        if "/my/tokens" not in page.url:
            log(f"  当前不在令牌页（{page.url}），导航回目标页")
            page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=TIMEOUT)
        wait_hydrated(page)

        # 关闭可能存在的对话框/遮罩层
        try:
            # 检查是否有遮罩层
            if page.locator(".o-layer-mask").is_visible():
                log("  检测到遮罩层，尝试关闭对话框")
                # 尝试点击关闭按钮
                close_btns = page.locator(".o-dialog .o-button").filter(has_text="取消")
                if close_btns.count() > 0:
                    close_btns.first.click()
                    page.wait_for_timeout(500)
        except Exception:
            pass

        page.get_by_role("button", name="创建私人令牌").click()
        try:
            page.wait_for_selector(".create-or-edit-token", timeout=8_000)
            log(f"  创建表单已打开（第 {i} 次尝试）")
            return
        except PWTimeout:
            log(f"  第 {i} 次点击未打开表单，当前 URL: {page.url}，重试")
    raise RuntimeError("多次尝试仍无法打开创建表单")


def fill_token_form(page, name: str, permissions: list[str], days: int) -> None:
    """
    填写令牌表单（创建或编辑态通用）。

    :param page: Playwright 页面对象
    :param name: 令牌名称
    :param permissions: 权限名列表（如 ["meeting-api"]）
    :param days: 有效期天数（7/30/60/365 或自定义值 1-365）

    内置铁律 F-15/F-16：下拉选项 teleport 处理（调用 element_actions.select_dropdown_option）
    """
    # 1. 填令牌名称
    page.locator(".form-input input.o_input-input").fill(name)
    log(f"  已填令牌名称: {name}")

    # 2. 选择有效期
    if days in (7, 30, 60, 365):
        select_dropdown_option(page, ".custom-day .o-select", f"{days}天")
    else:
        select_dropdown_option(page, ".custom-day .o-select", "自定义")
        page.wait_for_timeout(500)
        # 使用更通用的定位器：表单中最后一个文本输入框
        custom_input = page.locator('.o-form-item input[type="text"]').last
        custom_input.fill(str(days))
        log(f"  已填自定义天数: {days}")

    # 3. 勾选权限（支持多个）
    for perm in permissions:
        checkbox = page.locator(".form-checkboxgroup label.o-checkbox").filter(
            has_text=perm)
        if checkbox.count() > 0:
            checkbox.first.click()
            log(f"  已勾选权限: {perm}")
        else:
            log(f"  !! 权限 {perm} 未找到，跳过")


def grab_plain_token(page) -> str:
    """
    从令牌明文弹窗抓取明文（明文仅此一次可见）。

    使用 JS 评估提取所有可见 input 的 value，取长度 >= 16 的最后一个。

    :param page: Playwright 页面对象
    :return: 令牌明文字符串
    """
    vals = page.evaluate("""() => [...document.querySelectorAll('input')]
        .filter(e => { const r = e.getBoundingClientRect();
                       return r.width > 0 && r.height > 0; })
        .map(e => e.value).filter(v => v && v.length >= 16)""")
    return vals[-1] if vals else ""


def row_of(page, name: str):
    """
    按令牌名取列表数据行（名称列**精确**匹配）。

    :param page: Playwright 页面对象
    :param name: 令牌名称
    :return: Playwright Locator（可能匹配 0 个或多个行）

    ⚠ 必须精确匹配，不能用 filter(has_text=name) 的子串语义：
    「auto_128100」是「auto_128100_renamed」的子串，用子串匹配时
    改名后仍会命中新行，导致「旧名已消失」这类断言永远为假。
    这里改为要求行内存在一个文本恰好等于 name 的单元格。
    """
    return page.locator(".private-token-list tbody tr").filter(
        has=page.locator("td").filter(
            has_text=re.compile(rf"^\s*{re.escape(name)}\s*$")
        )
    )


def confirm_token_dialog(page, operate_type: str = "CREATE") -> str:
    """
    确认令牌明文弹窗并抓取明文。

    :param page: Playwright 页面对象
    :param operate_type: "CREATE" 或 "REFRESH"（决定弹窗标题校验）
    :return: 令牌明文字符串

    步骤:
      1. 等待弹窗出现（标题「私人令牌已创建」或「私人令牌已重新生成」）
      2. 抓取令牌明文
      3. 勾选「我已经了解...」复选框
      4. 点击「确认」
      5. 等待返回列表页
    """
    title = "私人令牌已创建" if operate_type == "CREATE" else "私人令牌已重新生成"

    try:
        page.wait_for_selector(f"text={title}", timeout=120_000)
        log(f"  出现「{title}」弹窗")
    except PWTimeout:
        log(f"  !! 等待「{title}」弹窗超时（120秒），尝试强制关闭遮罩层")
        # 强制关闭可能存在的遮罩层和对话框
        try:
            if page.locator(".o-layer-mask").is_visible():
                # 尝试点击关闭按钮
                close_btns = page.locator(".o-dialog .o-button").filter(has_text="取消")
                if close_btns.count() > 0:
                    close_btns.first.click()
                    page.wait_for_timeout(500)
        except Exception:
            pass
        raise PWTimeout(f"等待「{title}」弹窗超时（120秒）")

    plain = grab_plain_token(page)
    log(f"  令牌明文：{plain[:12]}...（长度 {len(plain)}）")

    # 勾选确认复选框（内置铁律 F-18：disabled 查 class）
    page.locator(".token-auth").last.click()
    page.wait_for_timeout(500)

    # 点击确认
    page.get_by_role("button", name="确认").last.click()
    log("  已点击「确认」关闭弹窗")

    # 等待返回列表
    page.wait_for_selector(".private-token-list", timeout=TIMEOUT)

    return plain
