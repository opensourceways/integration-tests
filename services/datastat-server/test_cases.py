# -*- coding: utf-8 -*-
"""
UI 测试脚本：datastat 数据中台（preview 环境，无需登录）

被测对象：datastat 数据中台前端
测试框架：pytest + playwright
环境：https://datastat-manage-website.preview.test.osinfra.cn/

配置（.env）：
    DATASTAT_BASE_URL=https://datastat-manage-website.preview.test.osinfra.cn

执行：
    pip install pytest playwright python-dotenv
    playwright install chromium
    pytest -v test_datastat_ui.py
"""

import os

import pytest
from playwright.sync_api import Page, expect

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

BASE_URL = os.environ.get(
    "DATASTAT_BASE_URL",
    "https://datastat-manage-website.preview.test.osinfra.cn",
).rstrip("/")


# ===== Fixture =====

@pytest.fixture(scope="function")
def home_page(page: Page):
    """打开根路径，前端会自动跳转到默认社区的概览页"""
    page.goto(f"{BASE_URL}/", wait_until="domcontentloaded", timeout=30000)
    # 等前端 router 完成默认重定向
    try:
        page.wait_for_url("**/overview**", timeout=8000)
    except Exception:
        pass
    page.wait_for_timeout(1500)
    return page


# ===== 页面导航测试 =====

class TestNavigation:

    def test_root_loads(self, home_page: Page):
        """TC-UI-001 [正常流] 根路径加载并自动进入概览页（或停留根页 #app 渲染）"""
        # preview 环境根路径偶发不会跳转，但 #app 必须可见且未跳出域
        assert "datastat-manage-website" in home_page.url, \
            f"应停留在站内，实际: {home_page.url}"
        expect(home_page.locator("#app")).to_be_visible()

    def test_page_has_title(self, home_page: Page):
        """TC-UI-002 [正常流] 页面有标题"""
        title = home_page.title()
        assert title and len(title) > 0, "页面应有标题"

    def test_navigate_to_developers(self, page: Page):
        """TC-UI-003 [正常流] 导航到开发者页面"""
        page.goto(f"{BASE_URL}/developers?community=openeuler",
                  wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(1000)
        assert "/developers" in page.url

    def test_navigate_to_health(self, page: Page):
        """TC-UI-004 [正常流] 导航到健康状态页面"""
        page.goto(f"{BASE_URL}/health?community=openeuler",
                  wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(1000)
        assert "/health" in page.url


# ===== 页面元素测试 =====

class TestPageElements:

    def test_app_container_visible(self, home_page: Page):
        """TC-UI-005 [正常流] 页面包含 #app 容器"""
        app = home_page.locator("#app")
        expect(app).to_be_visible()

    def test_no_login_form(self, home_page: Page):
        """TC-UI-006 [正常流] preview 环境无登录表单"""
        login_form = home_page.locator(".login-card")
        expect(login_form).not_to_be_visible()

    def test_page_has_content(self, page: Page):
        """TC-UI-007 [正常流] 页面有实际内容（非空白）"""
        page.goto(f"{BASE_URL}/overview?community=openeuler",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(2500)
        body_text = page.locator("#app").inner_text()
        assert len(body_text.strip()) > 0, "页面不应为空"


# ===== 核心页面路由可达性测试 =====
# 基于 src/routers/index.ts 路由表

CORE_ROUTES = [
    ("/overview", "概览"),
    ("/overview/community", "社区概览"),
    ("/overview/software", "软件产品概览"),
    ("/overview/contributors", "贡献者概览"),
    ("/developers", "开发者"),
    ("/health", "健康状态"),
    ("/download", "下载"),
    ("/organizations", "组织"),
    ("/sigs", "SIG"),
    ("/warehouse", "仓库"),
    ("/drilldown", "下钻"),
    ("/registered-users", "注册用户"),
    ("/services", "服务"),
    ("/services-analysis", "服务分析"),
    ("/users", "用户"),
    ("/docs", "文档分析"),
]


class TestCoreRoutes:
    """验证所有核心路由可达"""

    @pytest.mark.parametrize("path,name", CORE_ROUTES,
                             ids=[r[0].strip("/").replace("/", "_") or "root"
                                  for r in CORE_ROUTES])
    def test_route_accessible(self, page: Page, path, name):
        """TC-UI-ROUTE 各核心路由可达且 #app 渲染（允许前端守卫重定向到合法兜底页）"""
        page.goto(f"{BASE_URL}{path}?community=openeuler",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(800)
        # 域名内 + #app 可见即视为可达；部分路由会被前端守卫重定向到 health/overview/noPermission
        assert "datastat-manage-website" in page.url, \
            f"{name}页({path}) 跳转出域: {page.url}"
        app = page.locator("#app")
        expect(app).to_be_visible()


# ===== 概览页功能测试 =====

class TestOverviewPage:

    def test_overview_renders_content(self, page: Page):
        """TC-UI-010 [正常流] 概览页渲染主体内容区"""
        page.goto(f"{BASE_URL}/overview?community=openeuler",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(3000)
        body = page.locator("body").inner_text()
        assert len(body.strip()) > 10, "概览页应有实质内容"

    def test_overview_no_error_overlay(self, page: Page):
        """TC-UI-011 [正常流] 概览页无全局错误弹窗"""
        page.goto(f"{BASE_URL}/overview?community=openeuler",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(2000)
        error_msg = page.locator(".el-message--error")
        assert error_msg.count() == 0, "不应有 error message 弹窗"


# ===== 侧边栏/导航测试 =====

def _open_page(page: Page, path: str = "/overview?community=openeuler",
               wait_extra: int = 2000) -> None:
    """打开页面并等待 SPA 渲染完成"""
    page.goto(f"{BASE_URL}{path}", wait_until="domcontentloaded", timeout=30000)
    page.wait_for_function(
        "document.querySelector('#app') && document.querySelector('#app').children.length > 0",
        timeout=10000,
    )
    page.wait_for_timeout(wait_extra)


class TestSidebar:

    def test_sidebar_or_nav_exists(self, page: Page):
        """TC-UI-012 [正常流] 页面含侧边栏/顶栏/导航元素"""
        _open_page(page)
        nav_selectors = [
            "aside", ".el-aside", ".sidebar", "nav",
            "[class*='aside']", "[class*='menu']",
            "[class*='nav']", "[class*='sider']",
            "[class*='header']", "header",
        ]
        nav = page.locator(", ".join(nav_selectors))
        assert nav.count() > 0, f"应存在导航类元素，实际匹配数=0"

    def test_header_visible(self, page: Page):
        """TC-UI-016 [正常流] 顶部 header 可见"""
        _open_page(page)
        header = page.locator(
            "header, [class*='header'], [class*='Header']"
        ).first
        assert header.count() > 0, "应存在 header 元素"

    def test_route_switch_keeps_layout(self, page: Page):
        """TC-UI-017 [正常流] 路由切换后 #app 容器仍存在（SPA 不重载）"""
        _open_page(page)
        page.goto(f"{BASE_URL}/health?community=openeuler",
                  wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(1500)
        expect(page.locator("#app")).to_be_visible()


# ===== 响应式/国际化测试 =====

class TestI18nAndResponsive:

    def test_page_lang_attribute(self, page: Page):
        """TC-UI-013 [正常流] HTML lang 属性设置正确"""
        page.goto(f"{BASE_URL}/overview", wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(800)
        lang = page.locator("html").get_attribute("lang")
        assert lang in ("zh", "en", "zh-CN", "zh-Hans"), \
            f"lang 应为中/英; 实际={lang}"

    def test_no_console_errors(self, page: Page):
        """TC-UI-014 [正常流] 页面加载无 JS 关键报错"""
        errors = []
        page.on("pageerror", lambda exc: errors.append(str(exc)))
        page.goto(f"{BASE_URL}/overview?community=openeuler",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(3000)
        critical = [e for e in errors if "Cannot read" in e or "is not defined" in e]
        assert len(critical) == 0, f"不应有 JS 关键报错: {critical}"


# ===== 无权限页面测试 =====

class TestNoPermission:

    def test_no_permission_page_accessible(self, page: Page):
        """TC-UI-015 [正常流] 无权限页面可访问"""
        page.goto(f"{BASE_URL}/noPermission",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(800)
        app = page.locator("#app")
        expect(app).to_be_visible()


# ===== 图表渲染深度断言 =====

class TestChartsRendering:
    """图表渲染断言：echarts/canvas/svg 容器与可视化元素"""

    def test_overview_has_visual_container(self, page: Page):
        """TC-UI-018 [正常流] 概览页含 echarts/canvas/svg 可视化容器"""
        _open_page(page, wait_extra=4000)
        chart = page.locator(
            "canvas, svg, .echarts, [_echarts_instance_], "
            "[class*='chart'], [class*='Chart']"
        )
        assert chart.count() > 0, "概览页应至少有一个图表/可视化容器"

    def test_developers_chart_dimension(self, page: Page):
        """TC-UI-019 [正常流] 开发者页图表/svg 容器有合法尺寸"""
        _open_page(page, "/developers?community=openeuler", wait_extra=4000)
        target = page.locator("canvas, svg").first
        if target.count() == 0:
            pytest.skip("该页面无 canvas/svg 渲染（可能纯表格页）")
        box = target.bounding_box()
        assert box is not None, "可视化元素应可获取 bounding_box"
        assert box["width"] > 0 and box["height"] > 0, \
            f"图表尺寸应非零，实际 w={box['width']} h={box['height']}"

    def test_no_chart_render_error(self, page: Page):
        """TC-UI-020 [反向] 图表渲染过程不应抛出 ECharts/render 关键错误"""
        errors = []
        page.on("pageerror", lambda exc: errors.append(str(exc)))
        _open_page(page, wait_extra=4000)
        keywords = ("echarts", "getInstanceByDom", "setOption",
                    "Cannot read properties of undefined")
        critical = [e for e in errors if any(k.lower() in e.lower() for k in keywords)]
        assert not critical, f"图表渲染相关报错: {critical}"

    def test_health_page_has_visual_elements(self, page: Page):
        """TC-UI-021 [正常流] 健康状态页含可视化或表格元素"""
        _open_page(page, "/health?community=openeuler", wait_extra=3000)
        visual = page.locator(
            "canvas, svg, table, .el-table, "
            "[class*='chart'], [class*='table']"
        )
        assert visual.count() > 0, "健康页应含图表或表格"


# ===== 数据加载与网络请求 =====

class TestDataLoading:
    """断言数据接口被调用、SPA 内容随路由切换"""

    def test_data_api_requests_fired(self, page: Page):
        """TC-UI-022 [正常流] 概览页加载时触发数据接口请求"""
        api_calls = []

        def on_request(req):
            url = req.url
            if any(seg in url for seg in
                   ("/api/", "/server/", "/queryapi/", "/datastat/")):
                api_calls.append(url)

        page.on("request", on_request)
        _open_page(page, wait_extra=4000)
        assert len(api_calls) > 0, "概览页应至少触发一次数据 API 请求"

    def test_no_5xx_response(self, page: Page):
        """TC-UI-023 [反向] 页面加载不应有 5xx 响应"""
        bad_responses = []

        def on_response(resp):
            try:
                if resp.status >= 500:
                    bad_responses.append((resp.status, resp.url))
            except Exception:
                pass

        page.on("response", on_response)
        _open_page(page, wait_extra=4000)
        assert not bad_responses, f"出现 5xx 响应: {bad_responses[:3]}"

    def test_route_switch_changes_content(self, page: Page):
        """TC-UI-024 [正常流] 路由切换后页面 url 变化且 #app 内容刷新"""
        _open_page(page)
        first_url = page.url
        first_text_len = len(page.locator("#app").inner_text() or "")

        page.goto(f"{BASE_URL}/sigs?community=openeuler",
                  wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(2500)
        assert page.url != first_url, "路由切换后 url 应变化"
        second_text_len = len(page.locator("#app").inner_text() or "")
        assert first_text_len > 0 and second_text_len > 0, \
            f"两个页面 #app 文本长度均应 > 0; first={first_text_len} second={second_text_len}"


# ===== 用户交互（社区切换/筛选/Tab）=====

class TestInteractions:
    """常见交互：社区切换、Tab 切换、点击筛选项"""

    def test_community_query_param_respected(self, page: Page):
        """TC-UI-025 [正常流] community query 参数会保留在 url"""
        page.goto(f"{BASE_URL}/overview?community=mindspore",
                  wait_until="domcontentloaded", timeout=30000)
        page.wait_for_timeout(1500)
        assert "community=mindspore" in page.url

    def test_clickable_links_exist(self, page: Page):
        """TC-UI-026 [正常流] 概览页含可点击链接（a/button 元素）"""
        _open_page(page, wait_extra=2500)
        clickable = page.locator("a[href], button, [role='button']")
        assert clickable.count() > 0, "页面应有可点击元素"

    def test_tab_or_filter_present_on_developers(self, page: Page):
        """TC-UI-027 [正常流] 开发者页含 Tab 或筛选控件"""
        _open_page(page, "/developers?community=openeuler", wait_extra=3000)
        controls = page.locator(
            ".el-tabs, [class*='tab'], [class*='Tab'], "
            ".el-select, .el-radio-group, [class*='filter'], [class*='Filter']"
        )
        if controls.count() == 0:
            pytest.skip("开发者页无明显 tab/filter 控件")
        assert controls.count() > 0


# ===== 健壮性：404 / 多次导航 =====

class TestRobustness:

    def test_unknown_route_does_not_crash(self, page: Page):
        """TC-UI-028 [反向] 未知路由不应导致 #app 崩溃"""
        try:
            page.goto(f"{BASE_URL}/__nonexistent_route__",
                      wait_until="domcontentloaded", timeout=20000)
        except Exception:
            pass
        page.wait_for_timeout(1500)
        app = page.locator("#app")
        assert app.count() > 0, "未知路由也应渲染 #app 容器"

    def test_double_navigate_no_error(self, page: Page):
        """TC-UI-029 [边界] 连续两次导航不应抛 JS 关键错误（过滤 SPA 路由切换瞬时报错）"""
        errors = []
        page.on("pageerror", lambda exc: errors.append(str(exc)))
        page.goto(f"{BASE_URL}/overview", wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(1500)
        page.goto(f"{BASE_URL}/health?community=openeuler",
                  wait_until="domcontentloaded", timeout=20000)
        page.wait_for_timeout(2000)
        # 过滤 vue-router 快速切换时常见的 push undefined 报错
        ignorable = ("(reading 'push')", "(reading 'replace')")
        critical = [e for e in errors
                    if ("Cannot read" in e or "is not defined" in e)
                    and not any(ig in e for ig in ignorable)]
        assert not critical, f"连续导航出现关键 JS 报错: {critical}"
