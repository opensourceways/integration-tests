# pytest 标准格式：首页标准浏览校验

import pytest
import re
from playwright.sync_api import expect
import config
from utils import logger


# ============================================================
# 基础信息校验
# ============================================================
def test_01_page_title(module_page):
    """校验页面标题包含 openEuler"""
    title = module_page.title()
    assert "openEuler" in title, f"标题不包含 openEuler，实际: {title}"
    logger.info(f"✅ 标题校验通过: {title}")


def test_02_page_url(module_page):
    """校验当前 URL 正确"""
    url = module_page.url
    assert url == config.BASE_URL, f"URL 不匹配，实际: {url}"
    logger.info(f"✅ URL校验通过: {url}")


# ============================================================
# Header 导航栏校验
# ============================================================
def test_03_header_visible(module_page):
    """校验 Header 和 Logo 可见"""
    header = module_page.locator("header.app-header")
    expect(header).to_be_visible()
    logger.info("✅ Header 可见性校验通过")

    logo = module_page.locator("header img.logo")
    expect(logo).to_be_visible()
    logger.info("✅ Logo 可见性校验通过")


# ============================================================
# Banner 轮播区校验
# ============================================================
def test_04_banner_carousel(module_page):
    """校验 Banner 容器、首张 Banner、下载按钮、指示器"""
    banner = module_page.locator(".home-banner")
    expect(banner).to_be_visible()
    logger.info("✅ Banner 容器可见")

    banner_item = module_page.locator(".banner-item0")
    expect(banner_item).to_be_visible()
    logger.info("✅ 首张 Banner 项可见")

    download_btn = module_page.locator("a[href*='/zh/download']").first
    expect(download_btn).to_be_visible()
    logger.info("✅ Banner 下载按钮可见")

    indicators = module_page.locator(".o-carousel-indicator-wrap")
    expect(indicators).to_be_visible()
    logger.info("✅ 轮播指示器可见")


# ============================================================
# 展示区域校验（4个入口）
# ============================================================
@pytest.mark.parametrize("href,name", [
    ("/zh/showcase/technical-white-paper/", "技术白皮书"),
    ("/zh/security/security-bulletins/", "安全公告"),
    ("/zh/migration/", "迁移"),
    ("/zh/interaction/event-list/", "活动列表"),
])
def test_05_display_zone_entries(module_page, href, name):
    """校验展示区域 4 个入口可见"""
    link = module_page.locator(f'a[href="{href}"]')
    expect(link.first).to_be_visible()
    logger.info(f"✅ [{name}] 入口可见: {href}")


# ============================================================
# 社区介绍区校验
# ============================================================
def test_06_intro_section(module_page):
    """校验社区介绍区块、标题、特性卡片、下载链接"""
    intro_section = module_page.locator(".home-intro")
    expect(intro_section).to_be_visible()
    logger.info("✅ 社区介绍区块可见")

    title_text = module_page.get_by_text("面向数字基础设施的开源操作系统")
    expect(title_text.first).to_be_visible()
    logger.info("✅ 社区介绍标题文本校验通过")

    intro_items = module_page.locator(".intro-list-item")
    count = intro_items.count()
    assert count >= 3, f"特性列表项数量不足，实际: {count}"
    logger.info(f"✅ 特性列表项数量校验通过: {count} 个")

    download_link = module_page.locator('a[href*="/zh/download/#get-openeuler"]')
    expect(download_link.first).to_be_visible()
    logger.info("✅ 社区介绍区下载链接可见")


# ============================================================
# 加入社区区校验
# ============================================================
def test_07_community_section(module_page):
    """校验加入社区区块、按钮、数据展示"""
    section = module_page.locator(".home-play-community")
    expect(section).to_be_visible()
    logger.info("✅ 加入社区区块可见")

    buttons = [
        ("/zh/community/contribution/detail.html", "贡献"),
        ("/zh/sig/sig-list/", "SIG"),
        ("/zh/community/member/", "成员"),
        ("https://datastat.openeuler.org/zh/overview", "数据概览"),
    ]
    for href, name in buttons:
        btn = module_page.locator(f'a[href="{href}"]')
        expect(btn.first).to_be_visible()
        logger.info(f"✅ [{name}] 按钮可见: {href}")

    data_items = module_page.locator(".home-play-community .data-item")
    data_count = data_items.count()
    assert data_count >= 1, "社区数据展示项未加载"
    logger.info(f"✅ 社区数据展示项校验通过: {data_count} 个")


# ============================================================
# 日历/会议区校验
# ============================================================
def test_08_calendar_section(module_page):
    """校验日历区块、按钮、Tab、会议列表/空态"""
    calendar = module_page.locator(".home-calendar")
    expect(calendar).to_be_visible()
    logger.info("✅ 日历区块可见")

    calendar_btn = calendar.locator("button.o-btn").first
    expect(calendar_btn).to_be_visible()
    logger.info("✅ 日历按钮可见")

    tab_nav = calendar.locator(".o-tab-nav-list")
    expect(tab_nav).to_be_visible()
    logger.info("✅ 日历 Tab 导航可见")

    meeting_list = calendar.locator(".meeting-list")
    empty_tip = calendar.locator(".empty")
    has_list = meeting_list.count() > 0 and meeting_list.first.is_visible()
    has_empty = empty_tip.count() > 0 and empty_tip.first.is_visible()
    assert has_list or has_empty, "会议列表与空态提示均未加载"
    if has_list:
        logger.info("✅ 会议列表区域可见")
    else:
        logger.info("✅ 空态提示可见（当前无会议数据）")


# ============================================================
# 用户案例区校验
# ============================================================
def test_09_user_case_section(module_page):
    """校验用户案例区块、Tab、案例列表"""
    case_section = module_page.locator(".user-case")
    expect(case_section).to_be_visible()
    logger.info("✅ 用户案例区块可见")

    tab_list = case_section.locator(".tab-list")
    expect(tab_list).to_be_visible()
    logger.info("✅ 案例 Tab 列表可见")

    content_items = case_section.locator(".content .case-list")
    assert content_items.count() >= 1, "案例内容未加载"
    logger.info(f"✅ 案例内容项数量校验通过: {content_items.count()} 个")


# ============================================================
# Footer 底部校验
# ============================================================
def test_10_footer(module_page):
    """校验 Footer 容器、备案信息、友情链接"""
    footer = module_page.locator("#tour_footer.footer")
    expect(footer).to_be_visible()
    logger.info("✅ Footer 容器可见")

    beian_text = module_page.get_by_text("京公网安备")
    expect(beian_text.first).to_be_visible()
    logger.info("✅ 备案信息文本可见")

    friend_links = module_page.locator(".friendship-link-item")
    if friend_links.count() > 0:
        logger.info(f"✅ 友情链接项存在: {friend_links.count()} 个")
    else:
        logger.info("ℹ️ 友情链接项未检测到（可能不显示在当前页面）")
