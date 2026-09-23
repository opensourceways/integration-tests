#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pytest fixtures 配置

提供测试会话管理、页面对象、自动清理等共享资源。
"""

import pytest
import time
from token_manager import setup_session, teardown_session, delete_token
from common.constants import AUTO_TOKEN_PREFIX, PROTECTED_TOKENS
from common.debug_utils import log


# 全局变量：记录上次发送验证码的时间
_last_verification_time = 0
_VERIFICATION_COOLDOWN = 65  # 验证码发送间隔（秒），设置为65秒以确保超过1分钟限制


def wait_for_verification_cooldown():
    """
    等待验证码冷却时间（1分钟）。
    如果距离上次发送验证码不足65秒，则等待至65秒。
    """
    global _last_verification_time

    current_time = time.time()
    elapsed = current_time - _last_verification_time

    if _last_verification_time > 0 and elapsed < _VERIFICATION_COOLDOWN:
        wait_time = _VERIFICATION_COOLDOWN - elapsed
        log(f"  ⏱️  验证码冷却中，等待 {wait_time:.1f} 秒...")
        time.sleep(wait_time)

    # 更新最后发送时间
    _last_verification_time = time.time()


@pytest.fixture(scope="session")
def browser_session():
    """
    会话级 fixture：整个测试套件共用一个浏览器会话。

    优点：避免重复登录，节省时间（登录 1 次 vs 每个测试 1 次）
    缺点：测试间有状态共享，需要严格的清理机制
    """
    log("=" * 60)
    log("启动测试会话（session 级别）")
    pw, browser, ctx, page = setup_session(headless=False)

    yield (pw, browser, ctx, page)

    log("=" * 60)
    log("关闭测试会话")
    teardown_session(pw, browser, ctx)


def reset_to_clean_list(page, phase: str = ""):
    """
    把页面恢复到「干净的令牌列表态」。

    用**整页重载**而非「找取消按钮点掉」：实测后者不可靠——某次用例中途
    失败留下 .o-layer-mask 后，点取消并未清掉遮罩，导致后续 5 条用例
    （含此前从未失败的纯前端校验用例）全部因遮罩拦截点击而级联失败。
    reload 能无条件清掉任何弹窗/遮罩/表单态，代价仅几秒，值得。
    """
    from common.constants import TARGET_URL, TIMEOUT
    from common.browser_helper import wait_hydrated

    dirty = False
    try:
        if page.locator(".o-layer-mask").is_visible():
            log(f"  [{phase}] 检测到遮罩层，整页重载以彻底复位")
            dirty = True
        elif page.locator(".create-or-edit-token").is_visible():
            log(f"  [{phase}] 检测到未关闭的表单，整页重载以彻底复位")
            dirty = True
    except Exception:
        dirty = True  # 状态探测本身失败，说明页面已不可靠

    off_page = "/my/tokens" not in page.url
    try:
        list_gone = not page.locator(".private-token-list").is_visible()
    except Exception:
        list_gone = True

    if dirty or off_page or list_gone:
        if not dirty:
            log(f"  [{phase}] 不在干净列表态（URL 偏离={off_page} 列表不可见={list_gone}），复位")
        page.goto(TARGET_URL, wait_until="domcontentloaded", timeout=TIMEOUT)
        wait_hydrated(page)


@pytest.fixture(scope="function")
def page(browser_session):
    """
    函数级 fixture：每个测试函数获取 page 对象。

    测试前：确保在令牌列表页，记录初始令牌列表
    测试后：清理所有 AUTO_TOKEN_PREFIX 开头的令牌
    """
    _, _, _, page_obj = browser_session

    reset_to_clean_list(page_obj, phase="测试前")

    # 记录测试前的令牌名称
    from token_manager import list_tokens
    try:
        tokens_before = {t["name"] for t in list_tokens(page_obj)}
    except Exception:
        # 如果读取失败，假设列表为空
        tokens_before = set()
        log("  !! 无法读取初始令牌列表，假设为空")

    yield page_obj

    # 清理：删除所有测试创建的令牌。
    # 先复位——用例可能在任意中间态失败（弹窗/遮罩/表单未关），
    # 不复位则连清理动作本身都会被遮罩拦住。
    reset_to_clean_list(page_obj, phase="清理前")

    try:
        tokens_after = {t["name"] for t in list_tokens(page_obj)}
        new_tokens = tokens_after - tokens_before

        for name in new_tokens:
            if name.startswith(AUTO_TOKEN_PREFIX) and name not in PROTECTED_TOKENS:
                try:
                    delete_token(page_obj, name)
                    log(f"  清理测试令牌: {name}")
                except Exception as exc:
                    log(f"  !! 清理失败 {name}: {exc}")
    except Exception as exc:
        log(f"  !! 清理阶段无法读取令牌列表: {exc}")


@pytest.fixture
def unique_token_name():
    """
    生成唯一的测试令牌名称。

    ⚠ 长度必须控制在 12 字符以内：令牌名上限 20 字符，而用例会给它加
    「_renamed」（8 字符）后缀做改名测试，超长会被前端校验静默拦住。
    这里用 auto_ + 时间戳后 6 位 = 11 字符，改名后 19 字符，均在限内。
    """
    import time
    suffix = int(time.time()) % 1_000_000
    return f"auto_{suffix:06d}"


@pytest.fixture
def auto_cleanup_token(page_with_cooldown, unique_token_name):
    """
    自动清理测试令牌的 fixture。

    用法：将需要清理的测试的 unique_token_name 参数改为 auto_cleanup_token
    测试结束后会自动删除创建的令牌（包括可能改名后的令牌）
    """
    from token_manager import token_exists

    # 记录可能创建的令牌名称
    token_names_to_cleanup = [
        unique_token_name,
        f"{unique_token_name}_renamed"  # 可能被改名
    ]

    yield unique_token_name

    # 测试结束后清理。
    # 先复位：本 fixture 的 teardown 早于 page fixture 的 teardown 执行，
    # 若用例中途失败留下遮罩，这里的删除动作会被遮罩拦住而全部失败。
    log("  🧹 开始清理测试令牌...")
    reset_to_clean_list(page_with_cooldown, phase="令牌清理前")

    for token_name in token_names_to_cleanup:
        try:
            if token_exists(page_with_cooldown, token_name):
                log(f"  🧹 清理令牌: {token_name}")
                delete_token(page_with_cooldown, token_name)
        except Exception as e:
            log(f"  ⚠️  清理令牌失败 {token_name}: {e}")
            reset_to_clean_list(page_with_cooldown, phase="清理失败后")


@pytest.fixture
def page_with_cooldown(page):
    """
    需要邮箱验证码的测试使用此 fixture。
    自动等待验证码冷却时间（65秒），避免"1分钟内不能多次发送"的限制。
    """
    wait_for_verification_cooldown()
    return page
