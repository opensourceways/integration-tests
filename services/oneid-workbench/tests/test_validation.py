#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
P1 空输入/校验测试

覆盖场景：
  E-01: 全空表单点「创建」
  E-01a: 名称留空
  E-01b: 有效期不选
  E-01c: 权限不勾选
"""

import pytest
from common.token_operations import open_create_form
from common.debug_utils import dump


class TestValidation:
    """P1 表单校验测试套件"""

    @pytest.mark.fast
    def test_e01_empty_form_submit(self, page):
        """E-01: 全空表单点「创建」"""
        open_create_form(page)

        # 直接点创建（不填任何字段）
        page.locator(".create-or-edit-token").get_by_role(
            "button", name="创建", exact=True).click()

        page.wait_for_timeout(2000)
        dump(page, "test_e01_empty_form")

        # 断言：三项同时报错
        danger_items = page.locator(".o-form-item-danger")
        assert danger_items.count() >= 3

        # 断言：未离开表单页
        assert page.locator(".create-or-edit-token").is_visible()

    @pytest.mark.fast
    def test_e01a_empty_name(self, page):
        """E-01a: 名称留空"""
        open_create_form(page)

        # 只填权限和有效期，名称留空
        from common.element_actions import select_dropdown_option
        select_dropdown_option(page, ".custom-day .o-select", "7天")
        page.locator(".form-checkboxgroup label.o-checkbox").first.click()

        page.locator(".create-or-edit-token").get_by_role(
            "button", name="创建", exact=True).click()

        page.wait_for_timeout(2000)

        # 断言：名称字段报错
        error_msg = page.locator(".o-form-item-message.type-danger").first.inner_text()
        assert "输入不能为空" in error_msg

    @pytest.mark.fast
    def test_e01b_empty_expiry(self, page):
        """E-01b: 有效期不选"""
        open_create_form(page)

        # 只填名称和权限
        page.locator(".form-input input.o_input-input").fill("test_name")
        page.locator(".form-checkboxgroup label.o-checkbox").first.click()

        page.locator(".create-or-edit-token").get_by_role(
            "button", name="创建", exact=True).click()

        page.wait_for_timeout(2000)

        # 断言：下拉框追加 danger class
        select_danger = page.locator(".o-select-danger")
        assert select_danger.count() > 0

    @pytest.mark.fast
    def test_e01c_empty_permissions(self, page):
        """E-01c: 权限不勾选"""
        open_create_form(page)

        # 只填名称和有效期
        page.locator(".form-input input.o_input-input").fill("test_name")
        from common.element_actions import select_dropdown_option
        select_dropdown_option(page, ".custom-day .o-select", "7天")

        page.locator(".create-or-edit-token").get_by_role(
            "button", name="创建", exact=True).click()

        page.wait_for_timeout(2000)

        # 断言：权限区报错
        error_msg = page.locator(".o-form-item-message.type-danger").inner_text()
        assert "请勾选令牌权限" in error_msg
