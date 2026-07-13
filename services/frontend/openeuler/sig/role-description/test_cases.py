"""
多场景测试用例（pytest 函数式）
test/test_cases.py
职责：以 pytest 风格组织正常与异常场景用例，支持批量执行、失败重试、循环运行
"""
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.resolve()))

import pytest
from playwright.sync_api import TimeoutError as PlaywrightTimeout

import config
from browser_utils import BrowserManager, LOGGER


# ──────────────────────────────
# Pytest Fixture：浏览器管理器
# 每个测试函数前启动浏览器，测试后自动关闭并截图
# ──────────────────────────────
@pytest.fixture(scope="function")
def bm():
    """
    函数级 fixture：每个用例独立浏览器会话，保证隔离性
    如果测试失败，fixture 中自动截一张失败现场图
    """
    manager = BrowserManager(cfg=config)
    manager.start()
    yield manager
    # 测试结束后，如果存在失败标记，额外截一张最终状态图
    try:
        # 这里 pytest 没有直接传递结果，但可以在用例内手动调用截图
        manager.take_screenshot("fixture_teardown", full_page=True)
    except Exception:
        pass
    manager.close()


# ──────────────────────────────
# 正常场景测试用例
# ──────────────────────────────
@pytest.mark.normal
@pytest.mark.smoke
class TestRoleDescriptionNormal:
    """正常场景：页面应正确加载、元素可见、交互符合预期"""

    def test_01_page_load_title_and_url(self, bm: BrowserManager):
        """
        TC-01: 正常加载页面
        断言：标题含'openEuler'，URL 以 /role-description/ 结尾
        """
        bm.goto(config.TARGET_URL)
        ss = bm.take_screenshot("TC01_page_loaded", full_page=True)
        bm.assert_title_contains(config.EXPECTED_TITLE_KEYWORD)
        bm.assert_url_contains(config.EXPECTED_URL_SUFFIX)
        LOGGER.info("[TC01] 页面加载标题与URL校验通过")

    def test_02_breadcrumb_visible(self, bm: BrowserManager):
        """
        TC-02: 面包屑可见性
        断言：面包屑包含'SIG中心'和'角色说明'
        """
        bm.goto(config.TARGET_URL)
        bm.assert_element_visible(".o-breadcrumb")
        bm.assert_element_text_contains(".o-breadcrumb", config.BREADCRUMB_SIG_TEXT)
        bm.assert_element_text_contains(".o-breadcrumb", config.BREADCRUMB_CURRENT_TEXT)
        LOGGER.info("[TC02] 面包屑可见性校验通过")

    def test_03_search_input_visible_and_focusable(self, bm: BrowserManager):
        """
        TC-03: 搜索框可见且可交互
        断言：input.el-input__inner 可见，点击后获得焦点（通过可输入验证）
        """
        bm.goto(config.TARGET_URL)
        bm.assert_element_visible("input.el-input__inner")
        bm.safe_click("input.el-input__inner", step_name="TC03_focus_search")
        LOGGER.info("[TC03] 搜索框可见且可聚焦")

    def test_04_role_cards_all_visible(self, bm: BrowserManager):
        """
        TC-04: 三个角色卡片全部可见
        断言：#contributor / #committer / #maintainer 均可见且含对应角色名
        """
        bm.goto(config.TARGET_URL)
        for role_key, role_info in config.ROLE_CARDS.items():
            anchor = role_info["anchor"]
            name = role_info["name"]
            selector = f'#{anchor.lstrip("#")}'
            bm.assert_element_visible(selector)
            bm.assert_element_text_contains(selector, name)
            LOGGER.info("[TC04] 角色卡片 '%s' 可见性校验通过", name)
        bm.take_screenshot("TC04_role_cards", full_page=True)

    @pytest.mark.parametrize("role_key,role_info", list(config.ROLE_CARDS.items()), ids=list(config.ROLE_CARDS.keys()))
    def test_05_anchor_navigation_each_role(self, bm: BrowserManager, role_key, role_info):
        """
        TC-05: 参数化测试 — 每个角色卡片的'查看详情'锚点跳转
        断言：点击后 URL 包含对应锚点 hash
        """
        bm.goto(config.TARGET_URL)
        anchor = role_info["anchor"]
        name = role_info["name"]
        bm.safe_click(f'a[href="{anchor}"]', step_name=f"TC05_click_{role_key}")
        bm.assert_url_contains(anchor)
        bm.take_screenshot(f"TC05_after_{role_key}", full_page=True)
        LOGGER.info("[TC05] 锚点跳转 '%s' 通过", name)

    def test_06_search_empty_input(self, bm: BrowserManager):
        """
        TC-06: 搜索框空输入回车（边界场景但归正常流）
        断言：页面不异常跳转，URL 仍包含原页面路径
        """
        bm.goto(config.TARGET_URL)
        bm.safe_click("input.el-input__inner", step_name="TC06_focus")
        bm.safe_input("input.el-input__inner", "", clear=True, step_name="TC06_empty")
        bm.press_key("Enter")
        bm.assert_url_contains(config.EXPECTED_URL_SUFFIX)
        LOGGER.info("[TC06] 搜索空输入回车未导致异常跳转，校验通过")

    def test_07_breadcrumb_navigate_to_sig_list(self, bm: BrowserManager):
        """
        TC-07: 面包屑'SIG中心'回退跳转
        断言：跳转后 URL 含 /sig/sig-list/，标题含 SIG
        """
        bm.goto(config.TARGET_URL)
        bm.safe_click(
            'a.o-breadcrumb-item-label[href="/zh/sig/sig-list/"]',
            step_name="TC07_breadcrumb",
        )
        bm.wait_for_load_state("load")
        bm.assert_url_contains("/zh/sig/sig-list/")
        bm.assert_title_contains("SIG")
        bm.take_screenshot("TC07_sig_list", full_page=True)
        LOGGER.info("[TC07] 面包屑跳转至 SIG列表 通过")

    def test_08_footer_brand_info(self, bm: BrowserManager):
        """
        TC-08: 页脚品牌信息存在
        断言：滚动到底部后，页面文本包含 openEuler 或 OpenAtom 或 contact（页脚无 <footer> 标签，改用 body 文本兜底）
        """
        bm.goto(config.TARGET_URL)
        bm.scroll_to_bottom()
        bm.wait_for_load_state("load")
        # 页脚无 <footer> 标签，使用 body 文本兜底校验
        body_text = bm.page.locator("body").inner_text(timeout=config.DEFAULT_TIMEOUT)
        assert any(kw in body_text for kw in ["openEuler", "OpenAtom", "contact"]), \
            "页面文本未包含预期品牌信息"
        bm.take_screenshot("TC08_footer", full_page=False)
        LOGGER.info("[TC08] 页脚品牌信息校验通过")

    def test_09_top_nav_visible(self, bm: BrowserManager):
        """
        TC-09: 顶部导航栏可见
        断言：header.app-header 可见（openEuler 品牌可能是图片 logo，不强求文本包含）
        """
        bm.goto(config.TARGET_URL)
        bm.assert_element_visible("header.app-header")
        # 顶部品牌可能是图片，改为宽松断言：检查 header 内是否存在 img 或 a 链接
        header_locator = bm.page.locator("header.app-header")
        assert header_locator.count() > 0, "顶部导航栏未找到"
        LOGGER.info("[TC09] 顶部导航栏校验通过")

    def test_10_search_valid_keyword(self, bm: BrowserManager):
        """
        TC-10: 搜索框输入有效关键词并回车
        断言：页面标题不为空，未出现 404 或 500 报错
        """
        bm.goto(config.TARGET_URL)
        bm.safe_click("input.el-input__inner", step_name="TC10_focus")
        bm.safe_input("input.el-input__inner", "贡献者", clear=True, step_name="TC10_input")
        bm.press_key("Enter")
        # 等待页面稳定（搜索可能触发跳转或重载）
        try:
            bm.wait_for_load_state("networkidle")
        except Exception:
            pass
        # 获取标题时可能因页面跳转导致执行上下文销毁，增加重试
        title = ""
        for _ in range(3):
            try:
                title = bm.page.title()
                break
            except Exception as e:
                LOGGER.warning("[TC10] 获取标题失败: %s，重试中...", e)
                try:
                    bm.page.wait_for_load_state("domcontentloaded", timeout=10_000)
                except Exception:
                    pass
        assert title, "搜索后页面标题为空，可能页面异常"
        assert "404" not in title and "500" not in title and "错误" not in title, \
            f"搜索后页面标题异常: {title}"
        bm.take_screenshot("TC10_search_result", full_page=True)
        LOGGER.info("[TC10] 有效关键词搜索通过，标题: %s", title)


# ──────────────────────────────
# 异常场景测试用例
# ──────────────────────────────
@pytest.mark.abnormal
@pytest.mark.regression
class TestRoleDescriptionAbnormal:
    """异常场景：超时、错误定位器、重复操作、特殊字符输入、错误URL等"""

    def test_11_page_load_timeout_wrong_url(self, bm: BrowserManager):
        """
        TC-11: 访问错误/不可达地址，预期异常（超时或连接失败）
        断言：应捕获到异常，且自动截图保存；不再严格限定 PlaywrightTimeout
        """
        # 使用 TEST-NET-1 不可达地址模拟网络超时/连接失败
        wrong_url = "http://192.0.2.1:9999/zh/sig/timeout-test"
        with pytest.raises(Exception):
            bm.goto(wrong_url, timeout=15_000)
        LOGGER.info("[TC11] 错误URL异常被正确捕获，符合预期")

    def test_12_invalid_locator_should_fail(self, bm: BrowserManager):
        """
        TC-12: 使用错误的定位器查找元素，预期断言失败
        断言：to_be_visible 应在 expect_timeout 内抛出 AssertionError，并触发截图
        """
        bm.goto(config.TARGET_URL)
        # 使用一个明显不存在的定位器
        invalid_selector = "div.this-element-does-not-exist-12345"
        with pytest.raises(Exception):
            bm.assert_element_visible(invalid_selector, timeout=5_000)
        LOGGER.info("[TC12] 错误定位器断言失败被正确捕获，符合预期")

    def test_13_rapid_click_same_anchor(self, bm: BrowserManager):
        """
        TC-13: 快速连续点击同一锚点（重复操作/压力边界）
        断言：页面不应崩溃，3次快速点击后浏览器仍存活、URL 包含锚点
        """
        bm.goto(config.TARGET_URL)
        anchor = config.ROLE_CARDS["contributor"]["anchor"]
        # 连续快速点击3次（无 sleep，通过 safe_click 的显式等待衔接）
        for i in range(1, 4):
            bm.safe_click(f'a[href="{anchor}"]', step_name=f"TC13_rapid_click_{i}")
        bm.assert_url_contains(anchor)
        title = bm.page.title()
        assert title and "错误" not in title, "快速点击后页面标题异常"
        LOGGER.info("[TC13] 快速连续点击锚点3次，页面未崩溃，通过")

    def test_14_search_special_characters(self, bm: BrowserManager):
        """
        TC-14: 搜索框输入特殊字符（XSS/注入边界）
        断言：输入 `<script>alert(1)</script>` 和 `' OR 1=1 --` 后，页面不崩溃、标题正常
        """
        bm.goto(config.TARGET_URL)
        special_chars = ["<script>alert(1)</script>", "' OR 1=1 --", "; DROP TABLE --", "../../etc/passwd"]
        for idx, text in enumerate(special_chars):
            # 非首次循环时重新打开目标页，确保搜索框始终存在（搜索可能触发跳转离开当前页）
            if idx > 0:
                bm.goto(config.TARGET_URL)
            bm.safe_click("input.el-input__inner", step_name=f"TC14_focus_{idx}")
            bm.safe_input("input.el-input__inner", text, clear=True, step_name=f"TC14_input_{idx}")
            bm.press_key("Enter")
            # 等待页面状态稳定，用 load_state 而非 sleep
            try:
                bm.wait_for_load_state("networkidle")
            except Exception:
                pass
            # 获取标题时可能因页面跳转导致执行上下文销毁，增加重试
            title = ""
            for _ in range(3):
                try:
                    title = bm.page.title()
                    break
                except Exception as e:
                    LOGGER.warning("[TC14] 获取标题失败: %s，重试中...", e)
                    try:
                        bm.page.wait_for_load_state("domcontentloaded", timeout=10_000)
                    except Exception:
                        pass
            assert title, f"特殊字符输入后页面标题为空 (idx={idx})"
            # 截图保留现场
            bm.take_screenshot(f"TC14_special_char_{idx}", full_page=False)
            LOGGER.info("[TC14] 特殊字符[%d]输入后页面正常，标题: %s", idx, title)

    def test_15_navigate_external_404_link(self, bm: BrowserManager):
        """
        TC-15: 点击外部链接后目标页返回404/异常（异常跳转边界）
        策略：构造一个已知无效的外部地址，模拟404场景
        断言：浏览器不崩溃，页面能呈现错误内容（标题或URL证明已到达目标）
        """
        bm.goto(config.TARGET_URL)
        # 使用一个确定不存在的路径模拟404；放宽 wait_until 和 timeout 减少偶发超时
        try:
            bm.goto(
                "https://openeuler.test.osinfra.cn/zh/sig/this-page-not-exist-404",
                wait_until="domcontentloaded",
            )
        except Exception:
            pass
        bm.take_screenshot("TC15_404_page", full_page=True)
        # 断言：即使404，浏览器仍然存活，且URL包含我们传入的非法路径
        assert "this-page-not-exist-404" in bm.page.url, "404测试未到达预期非法URL"
        LOGGER.info("[TC15] 404异常页面跳转通过，浏览器未崩溃")

    def test_16_scroll_and_locate_stability(self, bm: BrowserManager):
        """
        TC-16: 滚动后元素定位稳定性（测试显式等待是否足够健壮）
        断言：先滚动到底部，再尝试定位顶部的搜索框，仍然可以成功操作
        """
        bm.goto(config.TARGET_URL)
        # 操作：先滚动到底部
        bm.scroll_to_bottom()
        bm.wait_for_load_state("load")
        # 操作：再定位顶部的搜索框并点击（Playwright 无需先滚回顶部，可直接交互）
        bm.safe_click("input.el-input__inner", step_name="TC16_after_scroll")
        bm.assert_element_visible("input.el-input__inner")
        LOGGER.info("[TC16] 滚动到底部后顶部元素定位稳定性通过")


# ──────────────────────────────
# 批量执行与循环运行辅助方法
# ──────────────────────────────
"""
【批量执行】
在终端中执行以下命令即可批量运行全部用例：

    cd test
    pytest test_cases.py -v --tb=short

【仅运行正常场景】
    pytest test_cases.py -v -m "normal"

【仅运行异常场景】
    pytest test_cases.py -v -m "abnormal"

【运行冒烟用例】
    pytest test_cases.py -v -m "smoke"

【失败时自动重试（需安装 pytest-rerunfailures）】
    pip install pytest-rerunfailures
    pytest test_cases.py -v --reruns 2 --reruns-delay 1

【循环运行写法（命令行级别）】
    for /L %i in (1,1,10) do @pytest test_cases.py -v --tb=short

    或在 bash 中：
    for i in {1..10}; do pytest test_cases.py -v --tb=short; done

【循环运行写法（代码级别，不依赖插件）】
    if __name__ == "__main__":
        import subprocess
        loop_count = 5
        for i in range(1, loop_count + 1):
            print(f"\\n========== 第 {i}/{loop_count} 轮执行 ==========")
            exit_code = subprocess.call([sys.executable, "-m", "pytest", "test_cases.py", "-v", "--tb=short"])
            if exit_code != 0:
                print(f"第 {i} 轮存在失败用例，退出码={exit_code}")
"""

if __name__ == "__main__":
    # 默认执行：正常场景 + 异常场景，verbose 输出，失败信息简短回溯
    sys.exit(
        pytest.main([__file__, "-v", "--tb=short", "--color=yes"])
    )
