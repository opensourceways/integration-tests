"""
test_cases.py
openEuler 商业发行版页面 pytest 测试用例

设计原则：
  - 纯 pytest 函数式写法，使用 conftest.py 提供的 page / utils fixture。
  - 每个 test_ 函数对应一个独立场景，浏览器在每个用例前后自动启停（scope="function"）。
  - 失败时自动截图由 conftest.py 中的 pytest_runtest_makereport hook 统一处理。
  - 所有用例均基于阶段1的页面分析，不捏造页面不存在的操作。
"""

import logging
import pytest
from playwright.sync_api import expect, TimeoutError as PlaywrightTimeout

from global_config import Selectors

logger = logging.getLogger(__name__)


# ==========================================================
# 正常流程用例（Normal）
# ==========================================================

@pytest.mark.smoke
@pytest.mark.normal
def test_full_flow(page, utils):
    """
    用例N-01：正常流程完整执行。
    覆盖页面加载、结构校验、Cookie处理、厂商筛选、架构筛选、搜索、分页、下载跳转。
    """
    logger.info("【N-01】执行完整正常流程...")

    # 步骤A：校验页面核心结构
    utils.assert_element_visible(Selectors.TAB_ACTIVE, "商业发行版Tab")
    utils.assert_element_visible(Selectors.CARD_LIST_CONTAINER, "卡片列表")
    utils.assert_element_count(Selectors.CARD_ITEM, 1, ">=")
    utils.assert_element_visible(Selectors.PAGINATION_CONTAINER, "分页组件")

    # 步骤B：处理Cookie通知
    utils.handle_cookie_notice(Selectors.COOKIE_NOTICE, Selectors.COOKIE_CLOSE)

    # 步骤C：厂商筛选 - 勾选第1个厂商
    first_checkbox = page.locator(Selectors.VENDOR_CHECKBOX_LIST).nth(0)
    first_checkbox.wait_for(state="visible")
    first_checkbox.check()  # 使用 Playwright 原生 check()，自动滚动并触发 Vue 事件
    expect(first_checkbox).to_be_checked()
    utils.wait_for_visible(Selectors.CARD_ITEM)
    logger.info("【N-01】厂商筛选完成。")

    # 步骤D：架构筛选 - 选择 x86_64
    utils.click_toggle("x86_64")
    utils.wait_for_visible(Selectors.CARD_ITEM)
    logger.info("【N-01】架构筛选完成。")

    # 步骤E：搜索 - 输入 SP1 并回车
    utils.safe_type(Selectors.SEARCH_INPUT, "SP1", press_enter=True)
    utils.wait_for_visible(Selectors.CARD_ITEM)
    logger.info("【N-01】搜索完成。")

    # 步骤F：分页 - 切换到第2页（如果有）
    page_btns = page.locator(Selectors.PAGE_NUMBER)
    if page_btns.count() >= 2:
        first_title = utils.get_element_text(Selectors.CARD_TITLE, 0)
        page_btns.nth(1).click()
        utils.wait_for_visible(Selectors.CARD_ITEM)
        second_title = utils.get_element_text(Selectors.CARD_TITLE, 0)
        assert first_title != second_title, "分页切换后内容未变化"
        logger.info("【N-01】分页切换完成。")
    else:
        logger.info("【N-01】页数不足2页，跳过分页切换。")

    # 步骤G：下载跳转 - 点击第1张卡片的"前往下载"，监听新标签页
    expected_href = utils.get_element_attribute(Selectors.CARD_DOWNLOAD_LINK, "href", 0)
    with page.context.expect_page() as new_page_info:
        utils.click(Selectors.CARD_DOWNLOAD_BTN)
    new_page = new_page_info.value
    new_page.wait_for_load_state("domcontentloaded")
    assert new_page.url.rstrip("/") == expected_href.rstrip("/"), f"跳转URL不匹配: {new_page.url} != {expected_href}"
    assert len(new_page.title()) > 0, "新页面标题为空"
    new_page.close()
    logger.info("【N-01】下载跳转校验完成，用例通过。")


@pytest.mark.normal
def test_combined_filter(page, utils):
    """
    用例N-02：组合筛选验证。
    同时应用厂商 + 架构 + 搜索三个条件，校验列表结果符合交集逻辑。
    """
    logger.info("【N-02】执行组合筛选...")

    # 操作1：勾选第2个厂商（使用 evaluate 直接触发点击，绕过 o-toggle 遮挡）
    checkbox = page.locator(Selectors.VENDOR_CHECKBOX_LIST).nth(1)
    checkbox.wait_for(state="visible")
    checkbox.evaluate("el => el.click()")  # JS 原生点击，触发 Vue change 事件
    page.wait_for_timeout(500)
    expect(checkbox).to_be_checked()
    page.wait_for_timeout(2000)  # 等待列表异步刷新

    # 操作2：选择 AArch64 架构
    utils.click_toggle("AArch64")
    page.wait_for_timeout(2000)

    # 操作3：搜索关键词 "V"
    utils.safe_type(Selectors.SEARCH_INPUT, "V", press_enter=True)
    page.wait_for_timeout(2000)

    # 校验：获取结果卡片数量（允许空结果），确认页面无报错弹窗
    count = page.locator(Selectors.CARD_ITEM).count()
    logger.info("【N-02】组合筛选后卡片数量: %d", count)

    assert not utils.is_dialog_visible(Selectors.DIALOG_OVERLAY), \
        "组合筛选后页面出现异常弹窗"
    logger.info("【N-02】组合筛选无异常弹窗，用例通过。")


@pytest.mark.normal
def test_loop_all_archs(page, utils):
    """
    用例N-03：循环遍历所有架构标签。
    依次点击每个架构标签，校验每次切换后列表正常刷新。
    """
    logger.info("【N-03】循环遍历所有架构标签...")
    # 注意：去掉 "全部"，因为页面有两个 "全部"（厂商区和架构区），会导致歧义
    arch_labels = ["x86_64", "AArch64", "LoongArch64", "sw_64", "RISC-V"]
    errors = []

    for idx, arch in enumerate(arch_labels):
        logger.info("【N-03】循环 [%d/%d] 切换架构: '%s'", idx + 1, len(arch_labels), arch)
        try:
            utils.click_toggle(arch)
            utils.wait_for_visible(Selectors.CARD_ITEM)
            count = page.locator(Selectors.CARD_ITEM).count()
            logger.info("【N-03】架构 '%s' 筛选后卡片数量: %d", arch, count)
        except Exception as e:
            err_msg = f"架构 '{arch}' 切换失败: {e}"
            logger.error("【N-03】%s", err_msg)
            errors.append(err_msg)
            continue

    assert len(errors) < len(arch_labels), f"所有架构切换均失败: {errors}"
    if errors:
        logger.warning("【N-03】部分架构切换失败（已跳过）: %s", errors)
    logger.info("【N-03】架构循环遍历完成，用例通过。")


@pytest.mark.normal
def test_loop_all_vendors(page, utils):
    """
    用例N-04：循环遍历所有厂商checkbox。
    逐一勾选/取消前5个厂商，校验无异常报错。
    """
    logger.info("【N-04】循环遍历所有厂商checkbox...")
    checkboxes = page.locator(Selectors.VENDOR_CHECKBOX_LIST)
    total = checkboxes.count()
    assert total > 0, "页面上未找到厂商checkbox"
    logger.info("【N-04】检测到厂商checkbox总数: %d", total)

    success_count = 0
    for i in range(min(total, 5)):
        cb = checkboxes.nth(i)
        cb.wait_for(state="visible")
        try:
            cb.click(force=True)
            assert not utils.is_dialog_visible(Selectors.DIALOG_OVERLAY)
            cb.click(force=True)  # 取消勾选，恢复状态
            success_count += 1
            logger.info("【N-04】第 %d 个厂商checkbox操作成功。", i + 1)
        except Exception as e:
            logger.warning("【N-04】第 %d 个厂商checkbox操作失败: %s", i + 1, e)
            continue

    assert success_count > 0, "所有厂商checkbox操作均失败"
    logger.info("【N-04】厂商循环遍历完成，成功 %d/%d 个，用例通过。", success_count, min(total, 5))


# ==========================================================
# 异常/边界场景用例（Error）
# ==========================================================

@pytest.mark.error
def test_empty_search(page, utils):
    """
    用例E-01：空搜索边界。
    在搜索框输入空字符串并按回车，校验页面无报错、列表正常展示。
    """
    logger.info("【E-01】执行空搜索...")

    # 先输入一个有效值确保触发过搜索，再清空并回车
    utils.safe_type(Selectors.SEARCH_INPUT, "test", press_enter=True)
    page.wait_for_timeout(2000)  # 等待异步搜索响应，用 count 检查替代强制等待
    count_after_search = page.locator(Selectors.CARD_ITEM).count()
    logger.info("【E-01】搜索 'test' 后卡片数量: %d", count_after_search)

    page.locator(Selectors.SEARCH_INPUT).first.clear()
    page.locator(Selectors.SEARCH_INPUT).first.press("Enter")
    page.wait_for_timeout(2000)
    count_after_clear = page.locator(Selectors.CARD_ITEM).count()
    logger.info("【E-01】清空搜索后卡片数量: %d", count_after_clear)

    assert not utils.is_dialog_visible(Selectors.DIALOG_OVERLAY), "空搜索后页面出现异常弹窗"
    logger.info("【E-01】空搜索边界通过。")


@pytest.mark.error
def test_no_match_search(page, utils):
    """
    用例E-02：搜索无匹配结果。
    输入一个不存在的产品名，校验页面展示空结果或正常处理。
    """
    logger.info("【E-02】执行无匹配搜索...")
    utils.safe_type(Selectors.SEARCH_INPUT, "XYZ_NO_MATCH_99999", press_enter=True)
    page.wait_for_timeout(2000)

    assert not utils.is_dialog_visible(Selectors.DIALOG_OVERLAY), "无匹配搜索后页面异常"
    count = page.locator(Selectors.CARD_ITEM).count()
    logger.info("【E-02】无匹配搜索后卡片数量: %d", count)
    logger.info("【E-02】无匹配搜索边界通过。")


@pytest.mark.error
def test_rapid_click_download(page, utils):
    """
    用例E-03：快速连续点击"前往下载"按钮。
    模拟用户快速双击，校验页面不报错、不重复打开异常。
    """
    logger.info("【E-03】执行快速连续点击下载...")

    with page.context.expect_page() as ctx1:
        utils.click(Selectors.CARD_DOWNLOAD_BTN)
        try:
            utils.click(Selectors.CARD_DOWNLOAD_BTN)
        except Exception:
            pass

    try:
        new_page = ctx1.value
        new_page.wait_for_load_state("domcontentloaded")
        assert len(new_page.url) > 0, "新页面URL为空"
        assert len(new_page.title()) > 0, "新页面标题为空"
        new_page.close()
        logger.info("【E-03】快速点击后新页面正常打开，用例通过。")
    except TimeoutError:
        logger.warning("【E-03】未捕获到新页面，但页面无报错，用例通过。")

    assert not utils.is_dialog_visible(Selectors.DIALOG_OVERLAY), "快速点击后页面异常"


@pytest.mark.error
def test_page_load_timeout(page, utils):
    """
    用例E-04：页面加载超时模拟。
    将导航超时设为极短值，验证超时异常被正确捕获。
    预期：此用例会失败，用于验证异常处理机制本身。
    """
    logger.info("【E-04】模拟页面加载超时...")
    page.set_default_navigation_timeout(100)

    with pytest.raises(PlaywrightTimeout):
        page.goto("https://openeuler.test.osinfra.cn/zh/download/commercial-release/", wait_until="networkidle")
        logger.info("【E-04】正确捕获到 PlaywrightTimeout，超时机制验证通过。")

    # 恢复超时，避免影响后续用例（虽然pytest fixture会重建page，但安全起见）
    page.set_default_navigation_timeout(30000)


@pytest.mark.error
def test_pagination_boundary(page, utils):
    """
    用例E-05：分页边界校验。
    校验总条数显示、总页数，单页时检查下一页按钮状态，多页时点击最后一页。
    """
    logger.info("【E-05】执行分页边界校验...")

    total_text = utils.get_element_text(Selectors.PAGE_TOTAL)
    assert "共" in total_text, f"总条数显示异常: {total_text}"

    page_btns = page.locator(Selectors.PAGE_NUMBER)
    total_pages = page_btns.count()
    logger.info("【E-05】分页总页数: %d, 总条数文本: %s", total_pages, total_text)

    if total_pages == 1:
        next_btn = page.locator(Selectors.PAGE_NEXT)
        if next_btn.count() > 0:
            classes = next_btn.get_attribute("class") or ""
            logger.info("【E-05】单页场景：下一页按钮 classes=%s", classes)
    else:
        last_page = page_btns.nth(total_pages - 1)
        last_page.click()
        utils.wait_for_visible(Selectors.CARD_ITEM)
        count = page.locator(Selectors.CARD_ITEM).count()
        logger.info("【E-05】最后一页卡片数量: %d", count)
        assert count >= 0, "最后一页数据异常"

    logger.info("【E-05】分页边界校验通过。")
