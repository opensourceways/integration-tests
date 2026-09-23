#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
令牌管理主脚本

提供令牌 CRUD 的高级 API，供 pytest 用例直接调用。
"""

import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from common.constants import TARGET_URL, TIMEOUT, OUT_DIR, PROTECTED_TOKENS
from common.config import config
from common.browser_helper import BrowserManager, settle_landing, wait_hydrated
from common.auth_helper import do_login
from common.identity_verify import pass_identity_verify
from common.token_operations import (
    open_create_form, fill_token_form, grab_plain_token,
    row_of, confirm_token_dialog
)
from common.element_actions import wait_toast
from common.debug_utils import log, dump
from common.exceptions import (
    TokenManagerError, ProtectedTokenError, TokenNotFoundError,
    TokenNameConflictError
)


def setup_session(headless: bool = False) -> tuple:
    """
    启动浏览器并登录到令牌列表页。

    :param headless: 是否使用无头模式
    :return: (pw, browser, ctx, page)
    """
    log("=" * 60)
    log("初始化浏览器会话")

    pw, browser, ctx, page = BrowserManager.launch(headless=headless)

    settle_landing(page)

    if "login" in page.url:
        if not do_login(page):
            raise RuntimeError("登录失败")

    wait_hydrated(page)
    log("✅ 会话已就绪：令牌列表页")

    return pw, browser, ctx, page


def teardown_session(pw, browser, ctx):
    """关闭浏览器会话"""
    ctx.close()
    browser.close()
    pw.stop()
    log("浏览器会话已关闭")


def list_tokens(page) -> list[dict]:
    """
    读取当前令牌列表。

    :param page: Playwright 页面对象
    :return: 令牌列表，每个令牌包含 name/permissions/expire_at/create_at
    """
    rows = page.locator(".private-token-list tbody tr")
    count = rows.count()

    tokens = []
    for i in range(count):
        row = rows.nth(i)
        cells = row.locator("td")

        name = cells.nth(0).inner_text().strip()
        perms_text = cells.nth(1).inner_text().strip()
        permissions = [p.strip() for p in perms_text.split("\n") if p.strip()]
        expire_at = cells.nth(2).inner_text().strip()
        create_at = cells.nth(3).inner_text().strip()

        tokens.append({
            "name": name,
            "permissions": permissions,
            "expire_at": expire_at,
            "create_at": create_at
        })

    log(f"列表中共 {count} 个令牌")
    return tokens


def token_exists(page, name: str) -> bool:
    """
    检查令牌是否存在（即时读取，不等待）。

    :param page: Playwright 页面对象
    :param name: 令牌名称
    :return: True/False
    """
    return row_of(page, name).count() > 0


def wait_for_token_state(page, present: str = None, absent: str = None,
                         timeout: int = 15_000) -> bool:
    """
    轮询等待列表收敛到预期状态。

    写操作成功后前端列表刷新有延迟，读一次就断言会踩竞态：
    实测出现过「后端改名已生效、但紧接着查列表仍是旧快照」，
    导致把成功误判为失败。故凡是「写完立刻校验列表」的场景都应走这里。

    :param present: 期望**存在**的令牌名（可选）
    :param absent:  期望**不存在**的令牌名（可选）
    :param timeout: 最长等待毫秒数
    :return: 是否在超时前收敛到预期状态
    """
    deadline = time.time() + timeout / 1000
    while time.time() < deadline:
        ok = True
        if present is not None and not token_exists(page, present):
            ok = False
        if absent is not None and token_exists(page, absent):
            ok = False
        if ok:
            return True
        page.wait_for_timeout(500)
    return False


def create_token(page, name: str, permissions: list[str],
                 days: int = 7) -> dict:
    """
    创建令牌（含身份验证）。

    :param page: Playwright 页面对象
    :param name: 令牌名称（1-20字符，字母数字汉字或_-）
    :param permissions: 权限名列表，如 ["meeting-api", "oeas-api"]
    :param days: 有效期天数（7/30/60/365 或自定义 1-365）
    :return: {"name": name, "token": "oepat_...", "created": True}
    :raises TokenNameConflictError: 令牌名称已存在
    """
    log("=" * 60)
    log(f"创建令牌: {name}, 权限: {permissions}, 有效期: {days}天")

    # 安全检查
    if token_exists(page, name):
        raise TokenNameConflictError(f"令牌 {name} 已存在")

    open_create_form(page)
    fill_token_form(page, name, permissions, days)
    dump(page, f"create_{name}_filled")

    # 提交
    page.locator(".create-or-edit-token").get_by_role(
        "button", name="创建", exact=True).click()
    log("  已点击「创建」")

    # 身份验证
    pass_identity_verify(page, f"create_{name}")

    # 抓取令牌明文
    plain = confirm_token_dialog(page, "CREATE")

    # 落盘
    token_file = OUT_DIR / f"{name}.token"
    token_file.write_text(f"{name}\t{plain}\n", encoding="utf-8")
    log(f"  令牌明文已保存到: {token_file}")

    # 校验列表
    # 轮询等列表刷新（前端刷新有延迟，直接读会踩竞态）
    if not wait_for_token_state(page, present=name):
        raise TokenManagerError(f"创建后 15s 内列表未出现令牌 {name}")
    log(f"  ✅ 列表已新增 {name}")

    return {"name": name, "token": plain, "created": True}


def update_token(page, old_name: str, new_name: str = None,
                 permissions: list[str] = None, days: int = None) -> bool:
    """
    修改令牌（含身份验证）。

    :param page: Playwright 页面对象
    :param old_name: 当前令牌名
    :param new_name: 新名称（可选，不传则不改名）。⚠ 名称上限 20 字符，
                     超长会被前端校验拦住（不发请求、不弹验证框、静默停在表单）
    :param permissions: 新权限列表（可选，不传则不改权限）
    :param days: 新有效期（可选，不传则保留原有效期）
    :return: True/False
    :raises ProtectedTokenError: 尝试修改保护名单令牌
    :raises TokenNotFoundError: 令牌不存在
    """
    log("=" * 60)
    log(f"修改令牌: {old_name}")

    # 安全检查
    if old_name in PROTECTED_TOKENS:
        raise ProtectedTokenError(f"拒绝修改保护名单令牌 {old_name}")

    if not token_exists(page, old_name):
        raise TokenNotFoundError(f"令牌 {old_name} 不存在")

    # 打开编辑表单
    row_of(page, old_name).get_by_text("修改", exact=True).click()
    page.wait_for_selector(".create-or-edit-token", timeout=TIMEOUT)
    log("  编辑表单已打开")

    # 填写变更项
    if new_name:
        page.locator(".form-input input.o_input-input").fill(new_name)
        log(f"  改名为: {new_name}")

    if permissions:
        # 勾选新权限（简化版：直接勾选，不处理取消已选）
        for perm in permissions:
            checkbox = page.locator(".form-checkboxgroup label.o-checkbox").filter(
                has_text=perm)
            if checkbox.count() > 0:
                checkbox.first.click()
        log(f"  改权限为: {permissions}")

    # 有效期：编辑态该下拉不预填原值（placeholder 为「重新设定时间」、value 为空），
    # 但留空**不会**触发校验错误——实测 .o-select-danger 为 0，且 .form-item-extra
    # 仍显示原到期时间，说明不传 days 时后端保留原有效期。故此处不做任何兜底补选，
    # 以免在调用方只想改名时悄悄重置有效期。
    if days:
        from common.element_actions import select_dropdown_option
        if days in (7, 30, 60, 365):
            select_dropdown_option(page, ".custom-day .o-select", f"{days}天")
        else:
            select_dropdown_option(page, ".custom-day .o-select", "自定义")
            page.wait_for_timeout(500)
            page.locator('.o-form-item input[type="text"]').last.fill(str(days))
        log(f"  改有效期为: {days}天")

    dump(page, f"update_{old_name}_filled")

    # 提交
    page.get_by_role("button", name="保存").click()
    log("  已点击「保存」")

    # 身份验证（emailToken 仍在有效期内时不会弹框，属正常）
    pass_identity_verify(page, f"update_{old_name}")

    toast_seen = wait_toast(page, "修改成功")

    # 判定成功的依据：
    #   - 不能只靠 Toast——可能一闪而过被漏捕获；
    #   - 不能用「已离开编辑表单」当代理信号——实测该启发式会把失败误报成成功；
    #   - 也不能读一次列表就断言——后端改名已生效但前端列表尚未刷新时会误判失败
    #     （实测过这个竞态：update_token 返回后立刻查，旧名仍在旧快照里）。
    # 故改为**轮询等待**列表收敛到预期状态。
    if new_name:
        if wait_for_token_state(page, present=new_name, absent=old_name):
            log(f"  ✅ 修改成功（新名已生效"
                f"{'，Toast 已捕获' if toast_seen else '，Toast 未捕获'}）")
            return True
        log(f"  !! 修改未生效：新名存在={token_exists(page, new_name)}  "
            f"旧名已消失={not token_exists(page, old_name)}")
        return False

    # 未改名（只改权限/有效期）：列表上无可校验的显式变化，退回 Toast 判定
    if toast_seen:
        log("  ✅ 修改成功")
        return True
    log("  !! 未捕获「修改成功」Toast，修改可能未生效")
    return False


def delete_token(page, name: str, force: bool = False) -> bool:
    """
    删除令牌（含身份验证）。

    :param page: Playwright 页面对象
    :param name: 令牌名称
    :param force: 强制删除（跳过二次确认，如果有）
    :return: True/False
    :raises ProtectedTokenError: 尝试删除保护名单令牌
    """
    log("=" * 60)
    log(f"删除令牌: {name}")

    # 安全检查
    if name in PROTECTED_TOKENS:
        raise ProtectedTokenError(f"拒绝删除保护名单令牌 {name}")

    if not token_exists(page, name):
        log(f"  令牌 {name} 不存在，跳过删除")
        return True  # 幂等性：已删除视为成功

    # 点击删除
    row_of(page, name).get_by_text("删除", exact=True).click()
    page.wait_for_timeout(1200)

    # 可能有二次确认框
    try:
        page.get_by_role("button", name="确认").last.click(timeout=5_000)
        log("  已点击删除二次确认")
    except Exception:
        pass

    # 身份验证
    pass_identity_verify(page, f"delete_{name}")

    # 校验 Toast
    if wait_toast(page, "删除成功", timeout=30_000):
        log(f"  ✅ 删除成功")

    # 校验列表（轮询等刷新，勿用固定 sleep 后读一次——会踩竞态）
    if wait_for_token_state(page, absent=name):
        log(f"  ✅ 列表已移除 {name}")
        return True
    log(f"  !! 列表中仍有 {row_of(page, name).count()} 个 {name}")
    return False


def regenerate_token(page, name: str) -> dict:
    """
    重新生成令牌（含身份验证）。

    :param page: Playwright 页面对象
    :param name: 令牌名称
    :return: {"name": name, "token": "oepat_...", "regenerated": True}
    :raises TokenNotFoundError: 令牌不存在
    """
    log("=" * 60)
    log(f"重新生成令牌: {name}")

    if not token_exists(page, name):
        raise TokenNotFoundError(f"令牌 {name} 不存在")

    # 点击重新生成
    row_of(page, name).get_by_text("重新生成", exact=True).click()
    page.wait_for_timeout(1200)

    # 身份验证
    pass_identity_verify(page, f"regen_{name}")

    # 抓取新令牌明文
    plain = confirm_token_dialog(page, "REFRESH")

    # 落盘
    token_file = OUT_DIR / f"{name}_regenerated.token"
    token_file.write_text(f"{name}\t{plain}\n", encoding="utf-8")
    log(f"  新令牌明文已保存到: {token_file}")

    return {"name": name, "token": plain, "regenerated": True}


if __name__ == "__main__":
    # 简单的命令行测试接口
    print("token_manager.py 加载成功")
    print("使用方式：在其他脚本中 import token_manager")

