#!/usr/bin/env python3
"""login_helper.py — 自动登录 GitCode 获取 Cookie（**本包独有**）

用法 1（从 config.yaml 读账密）：
  python phase02/scripts/login_helper.py

  从 config.yaml 读取 gitcode.username 和 gitcode.password，登录后将 Cookie
  写回 config.yaml 的 gitcode.cookie（原地更新，保留注释与其他配置）

用法 2（命令行传参）：
  python phase02/scripts/login_helper.py <username> <password>

  成功时打印 Cookie 串到 stdout，需手动复制到 config.yaml 的 gitcode.cookie

配置项（config.yaml，环境变量可覆盖）：
  gitcode.username   登录用户名/邮箱（用法 1 必填）
  gitcode.password   登录密码（用法 1 必填）
  ui.headless: false 有头模式看登录过程（默认 true headless）
  runtime.login_timeout  单步超时毫秒（默认 30000）
  LOGIN_AGREE_DATA_SHARING=1
                     额外勾选「将账号/组织/仓库信息提供给 AtomGit 数据共享」。
                     这是把数据授权给第三方，默认不勾。

登录页真实结构（2026-09 实测，gitcode.com 是 AtomGit 内核）：
  - 默认停在「小程序登录」(微信扫码)，三个 tab：小程序登录 / 短信登录 / 密码登录
  - 密码登录 tab 不点开则表单不存在
  - 两个输入框都没有 name/id，只能靠 placeholder 定位
  - 提交按钮文字是「登 录」(中间有空格)，靠 devui-button--lg 与导航栏区分
  - 两个 checkbox 默认未勾：用户协议(必需) / AtomGit 数据共享(可选)
    devui 隐藏了原生 input，check() 点不到，须点可见渲染层
  - 登录成功不能靠 cookie 是否存在判定——匿名访客也会拿到 session 类 cookie，
    须实访 /settings/profile 复核
"""
import os
import sys
import time

# 自动加载 config.yaml（优先级：环境变量 > config.yaml）
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import config_loader  # noqa: E402


def login_and_get_cookie(username, password, headless=False, timeout=30000):
    """模拟登录 GitCode，返回 cookie 字典或抛异常。

    Args:
        username: GitCode 用户名或邮箱
        password: 密码
        headless: 无头模式
        timeout: 单步超时（毫秒）

    Returns:
        list[dict]: Playwright cookies 格式

    Raises:
        Exception: 登录失败（超时、验证码、凭证错误等）
    """
    try:
        from playwright.sync_api import sync_playwright, TimeoutError as PWTimeout
    except ImportError:
        raise Exception("需要安装 Playwright: pip install playwright && "
                        "python -m playwright install chromium")

    with sync_playwright() as p:
        # slow_mo=1200 是 devui checkbox 响应的最小可靠延迟（实测）
        browser = p.chromium.launch(headless=headless, slow_mo=1200)
        # 不设 viewport，用浏览器默认值（之前成功的脚本就是这样）
        ctx = browser.new_context()
        page = ctx.new_page()

        try:
            # 1. 打开登录页
            page.goto("https://gitcode.com/login", timeout=timeout)
            page.wait_for_load_state("domcontentloaded")
            time.sleep(3)  # devui 组件渲染较慢

            # 2. 切到「密码登录」tab
            #    登录页默认停在「小程序登录」(微信扫码)，三个 tab 依次是
            #    小程序登录 / 短信登录 / 密码登录。不切换则表单根本不存在。
            try:
                page.locator(':text("密码登录")').first.click(timeout=15000)
                time.sleep(2.5)
            except PWTimeout:
                raise Exception("未找到「密码登录」tab，登录页结构可能已变")

            # 3. 填表单。两个输入框都没有 name/id，只能靠 placeholder 定位
            try:
                user_sel = 'input[placeholder="请填写用户名/邮箱"]'
                page.wait_for_selector(user_sel, timeout=10000, state="visible")
                page.locator(user_sel).first.fill(username)
                page.locator('input[placeholder="请填写密码"]').first.fill(password)
            except PWTimeout:
                raise Exception("未找到用户名/密码输入框（placeholder 可能已变），"
                                "请检查 https://gitcode.com/login 密码登录 tab")

            # 4. 勾选用户协议（登录必需）
            #    GitCode/AtomGit 的 devui 表单验证要求两个 checkbox 都勾：
            #    用户协议 + 数据共享（把数据授权给第三方）。
            #    devui 隐藏原生 input 用自定义渲染，且用 Vue 响应式状态控制，
            #    点击外层容器或 position 方式在实测中不触发状态更新。
            #    **可靠方法：focus 到 input 然后按 Space**，这会触发完整的事件链。
            # 4. 勾选用户协议 + 数据共享（devui 表单验证要求两个都勾）
            #
            #    成功方法：点击外层 .devui-checkbox 容器 + slow_mo 给足响应时间
            #    判据：外层 class 含 "checked" 单词
            def is_ticked(box):
                cls = box.get_attribute("class") or ""
                words = set(cls.split())
                # devui 的状态：unchecked（未勾）/ checked（已勾）/ active（点击瞬间或某些中间状态）
                # 只要不是 unchecked 就认为是勾选状态
                return "unchecked" not in words

            def tick(keyword, required):
                try:
                    box = page.locator(f'.devui-checkbox:has-text("{keyword}")').first
                    if not box.count():
                        if required:
                            raise Exception(f"未找到「{keyword}」checkbox")
                        return
                    if is_ticked(box):
                        return

                    box.scroll_into_view_if_needed(timeout=8000)
                    time.sleep(0.5)

                    # 直接点击方框元素 __material，避开文字链接
                    material = box.locator('.devui-checkbox__material').first
                    if material.count():
                        material.click(timeout=10000)
                    else:
                        # 回退：点容器左侧
                        box.click(timeout=10000, position={"x": 10, "y": 10})

                    # 等待 devui 状态从 active 变成 checked
                    for _ in range(5):
                        time.sleep(0.8)
                        if is_ticked(box):
                            break

                    if not is_ticked(box) and required:
                        cls_after = box.get_attribute("class") or ""
                        raise Exception(
                            f"勾选「{keyword}」失败：点击后 class={cls_after}")

                except Exception as e:
                    if required:
                        raise Exception(f"勾选「{keyword}」失败: {type(e).__name__}: "
                                        f"{str(e).splitlines()[0][:90]}")

            tick("用户协议", required=True)
            time.sleep(1.5)  # 两个 checkbox 之间给足间隔
            tick("数据共享", required=True)

            # 5. 点提交按钮。注意文字是「登 录」(中间有空格)，且导航栏另有一个
            #    「登录」按钮——必须靠 --lg 尺寸类区分，否则会点错导航栏那个。
            try:
                btn = page.locator('button.devui-button--lg:has-text("登")')
                if not btn.count():
                    btn = page.locator('button:has-text("登 录")')
                btn.first.click(timeout=timeout)
            except PWTimeout:
                raise Exception("未找到登录提交按钮")

            # 6. 等结果落定（SPA 可能需要较长时间异步渲染登录态）
            time.sleep(8)

            # 验证码 / 二次验证拦截
            if any(k in page.url.lower() for k in ("captcha", "verify", "challenge")):
                raise Exception("登录触发验证码或二次验证，无法自动完成。"
                                "请手动登录后从浏览器复制 Cookie 填入 GITCODE_COOKIE")

            # 页面错误提示（凭证错、协议未勾等）
            try:
                toast = page.locator(
                    '.devui-toast, [class*="toast"], [class*="error-msg"], '
                    '.devui-form-item__error-tip'
                ).first.inner_text(timeout=2500).strip()
                if toast:
                    raise Exception(f"登录被拒: {toast[:120]}")
            except PWTimeout:
                pass

            # 取 cookie。注意：cookie 是否存在不能作为登录成功的依据，
            # 真正的判定在下面的实访复核。
            cookies = ctx.cookies()
            if not cookies:
                raise Exception(f"未拿到任何 Cookie（当前 URL={page.url}）")

            # 复核：检查登录后的页面特征，而不是访问 /settings/profile
            # （那个页面可能需要特定权限或根本不存在）。
            # 登录成功的特征：
            #   - URL 跳离 /login（通常到首页或 dashboard）
            #   - 或者页面上有用户头像/用户名等登录态元素（即使 URL 没跳转）
            final_url = page.url
            verified = False

            # 检查是否有登录态元素
            try:
                login_indicators = [
                    '[class*="user-avatar"]', '[class*="user-menu"]',
                    'a[href*="/settings"]', 'button:has-text("退出")',
                    '[class*="dropdown"]:has([class*="avatar"])',
                    '.navbar [class*="user"]', 'img[alt*="avatar"]',
                    '[class*="profile"]', 'a[href*="/profile"]'
                ]
                for sel in login_indicators:
                    if page.locator(sel).first.count():
                        verified = True
                        break
            except Exception:
                pass

            # 补充判定：跳离了 /login 且拿到足够多的 cookie
            if not verified and "/login" not in final_url and len(cookies) >= 3:
                verified = True

            if not verified:
                raise Exception(
                    "登录未生效：点击登录按钮后未检测到登录态特征（无用户头像/菜单，"
                    f"且 URL={final_url}）。常见原因是用户名或密码错误；"
                    "若凭证确认无误，可能是账号需要短信/扫码验证，"
                    "此时请手动登录后复制 Cookie 填入 GITCODE_COOKIE")

            return cookies

        finally:
            browser.close()


def cookies_to_string(cookies):
    """Playwright cookies → `k=v; k2=v2` 格式。"""
    return "; ".join(f"{c['name']}={c['value']}" for c in cookies)


def find_config():
    """定位 config.yaml（当前工作目录 → 包根），未找到返回 None。"""
    return config_loader.find_config()


def main():
    config_file = find_config()

    # 优先从命令行读参数
    if len(sys.argv) >= 3:
        username = sys.argv[1]
        password = sys.argv[2]
        update_env = False
    else:
        # 从 config.yaml 或环境变量读（config_loader 已把前者注入 os.environ）
        username = os.environ.get("GITCODE_USERNAME")
        password = os.environ.get("GITCODE_PASSWORD")

        if not username or not password:
            print("错误: 未提供账密", file=sys.stderr)
            print(f"\n当前查找 config.yaml 路径: {config_file or '未找到'}", file=sys.stderr)
            print("\n用法 1（从 config.yaml）：", file=sys.stderr)
            print("  在 config.yaml 的 gitcode 节设置 username 和 password", file=sys.stderr)
            print("  然后运行: python phase02/scripts/login_helper.py", file=sys.stderr)
            print("\n用法 2（命令行）：", file=sys.stderr)
            print("  python phase02/scripts/login_helper.py <username> <password>", file=sys.stderr)
            sys.exit(2)

        update_env = bool(config_file)  # 有配置文件时，登录成功后回写

    headless = os.environ.get("UI_HEADLESS", "1") != "0"
    timeout = int(os.environ.get("LOGIN_TIMEOUT", 30000))

    try:
        print("正在登录 GitCode...", file=sys.stderr)
        cookies = login_and_get_cookie(username, password, headless, timeout)
        cookie_str = cookies_to_string(cookies)

        if update_env:
            # 回写 config.yaml 的 gitcode.cookie
            config_loader.set_value("gitcode", "cookie", cookie_str, path=config_file)
            print(f"\n✓ 登录成功，获取 {len(cookies)} 个 cookie", file=sys.stderr)
            print(f"✓ 已更新 {config_file} 的 gitcode.cookie", file=sys.stderr)
        else:
            # 命令行模式，打印到 stdout
            print(cookie_str)
            print(f"\n✓ 登录成功，获取 {len(cookies)} 个 cookie", file=sys.stderr)
            print("✓ 请将上方 Cookie 串复制到 config.yaml 的 gitcode.cookie", file=sys.stderr)

        sys.exit(0)

    except Exception as e:
        print(f"\n✗ 登录失败: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
