#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
P0 正常操作测试

覆盖场景：
  N-01: 登录并进入 tokens 页
  N-02: 列表首屏渲染
  N-03~N-08: 合并为两条生命周期用例（见下方说明）

【为什么合并】
每个写操作（创建/重新生成/修改/删除）都需要一次独立的邮箱验证码，
而后端限制同一邮箱 65s 内只能发一次。原先 6 条用例各自「建一个新令牌
→ 测 → 清理删掉」，15 次验证码里有 12 次耗在重复的 create/delete 上。
改为用一个令牌串起整条生命周期后降到 7 次，省约 9 分钟纯等待。

映射关系：
  test_lifecycle_basic  ← N-03（创建 7天+单权限）
                        + N-05（重新生成）
                        + N-06（改名+改权限）
                        + N-07（重设有效期）
                        + N-08（删除）
  test_lifecycle_custom ← N-04（创建 90天自定义+多权限）
"""

import pytest
from token_manager import (
    create_token, update_token, delete_token,
    regenerate_token, token_exists
)
from common.constants import TARGET_URL


class TestNormalOperations:
    """P0 正常操作测试套件"""

    def test_n01_login_and_navigate(self, page):
        """N-01: 登录并进入 tokens 页"""
        assert TARGET_URL in page.url
        assert page.locator(".private-token-list").is_visible()

    def test_n02_list_rendering(self, page):
        """N-02: 列表首屏渲染（表头 5 列）"""
        headers = page.locator(".private-token-list thead th")
        assert headers.count() == 5

        expected_headers = ["令牌名称", "权限", "到期时间", "创建时间", "操作"]
        actual_headers = [headers.nth(i).inner_text().strip() for i in range(5)]
        assert actual_headers == expected_headers

    @pytest.mark.slow
    def test_lifecycle_basic(self, page_with_cooldown, auto_cleanup_token):
        """
        N-03/05/06/07/08: 令牌完整生命周期（7天 + 单权限）

        创建 → 重新生成 → 改名改权限 → 重设有效期 → 删除
        共 5 次邮箱验证码。
        """
        page = page_with_cooldown
        name = auto_cleanup_token

        # ---- N-03: 创建（7天 + 单权限）----
        result = create_token(page, name=name, permissions=["meeting-api"], days=7)

        assert len(result["token"]) == 32, "令牌明文应为 32 位"
        assert result["token"].isalnum(), "令牌明文应只含字母数字"
        assert token_exists(page, name), "创建后列表应出现该令牌"
        old_token = result["token"]

        # ---- N-05: 重新生成 ----
        regen = regenerate_token(page, name)

        assert regen["token"] != old_token, "重新生成后明文应改变"
        assert len(regen["token"]) == 32
        assert regen["token"].isalnum()
        assert token_exists(page, name), "重新生成不应改变令牌名"

        # ---- N-06: 改名 + 改权限 ----
        renamed = f"{name}_renamed"
        update_token(page, old_name=name, new_name=renamed,
                     permissions=["oeas-api"])

        assert not token_exists(page, name), "改名后旧名应消失"
        assert token_exists(page, renamed), "改名后新名应出现"

        # ---- N-07: 重设有效期 ----
        update_token(page, old_name=renamed, days=30)

        assert token_exists(page, renamed), "改有效期不应改变令牌名"

        # ---- N-08: 删除 ----
        assert delete_token(page, renamed) is True, "删除应返回成功"
        assert not token_exists(page, renamed), "删除后列表应移除该令牌"

    @pytest.mark.slow
    def test_lifecycle_custom(self, page_with_cooldown, auto_cleanup_token):
        """
        N-04: 创建自定义天数 + 多权限令牌，然后删除

        单独保留这条，是为了覆盖「创建时直接填自定义天数、直接勾多个权限」
        这条路径（test_lifecycle_basic 里的自定义天数是「改成」而非「建成」）。
        共 2 次邮箱验证码。
        """
        page = page_with_cooldown
        name = auto_cleanup_token

        # ---- N-04: 创建（90天自定义 + 双权限）----
        result = create_token(page, name=name,
                              permissions=["meeting-api", "oeas-api"], days=90)

        assert result["created"] is True
        assert len(result["token"]) == 32, "令牌明文应为 32 位"
        assert token_exists(page, name), "创建后列表应出现该令牌"

        # ---- 收尾删除（让清理 fixture 变为空操作，省一次验证码）----
        assert delete_token(page, name) is True, "删除应返回成功"
        assert not token_exists(page, name), "删除后列表应移除该令牌"
