#!/usr/bin/env python3
"""login_helper.py — 自动登录 GitCode 获取 Cookie（**本包独有**）

用法 1（从 .env 读账密）：
  python phase02/scripts/login_helper.py

  从 .env 读取 GITCODE_USERNAME 和 GITCODE_PASSWORD，登录后将 Cookie
  写回 .env 的 GITCODE_COOKIE（原地更新，保留其他配置）

用法 2（命令行传参）：
  python phase02/scripts/login_helper.py <username> <password>

  成功时打印 Cookie 串到 stdout，需手动复制到 .env

环境变量：
  GITCODE_USERNAME   登录用户名/邮箱（用法 1 必填）
  GITCODE_PASSWORD   登录密码（用法 1 必填）
  UI_HEADLESS=0      有头模式看登录过程（默认 1 headless）
  LOGIN_TIMEOUT      单步超时毫秒（默认 30000）
"""
import os
import sys
import time
import re


def login_and_get_cookie(username, password, headless=True, timeout=30000):
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
        browser = p.chromium.launch(headless=headless)
        ctx = browser.new_context(viewport={"width": 1280, "height": 800})
        page = ctx.new_page()

        try:
            # 1. 打开登录页
            page.goto("https://gitcode.com/login", timeout=timeout)
            page.wait_for_load_state("domcontentloaded")
            time.sleep(1.5)  # 等表单渲染

            # 2. 填写表单（GitCode 的 selector 可能变，这里用常见模式）
            #    通常是 input[name=username] / input[type=email] 和 input[type=password]
            try:
                # 尝试找用户名框（可能是 email/username/phone）
                user_sel = (
                    'input[name="username"], input[name="email"], '
                    'input[type="email"], input[placeholder*="用户名"], '
                    'input[placeholder*="邮箱"], input[id*="user"]'
                )
                page.wait_for_selector(user_sel, timeout=10000, state="visible")
                page.locator(user_sel).first.fill(username)

                # 密码框
                pass_sel = 'input[type="password"], input[name="password"]'
                page.locator(pass_sel).first.fill(password)

            except PWTimeout:
                raise Exception("未找到登录表单（selector 可能已变），请检查 "
                                "https://gitcode.com/login 页面结构")

            # 3. 点登录按钮
            try:
                btn_sel = (
                    'button[type="submit"], button:has-text("登录"), '
                    'button:has-text("Sign in"), input[type="submit"]'
                )
                page.wait_for_selector(btn_sel, timeout=5000, state="visible")
                page.locator(btn_sel).first.click(timeout=timeout)
            except PWTimeout:
                raise Exception("未找到登录按钮")

            # 4. 等跳转（成功会到 /dashboard 或 /projects，失败留在 /login）
            time.sleep(3)
            final_url = page.url

            # 验证码拦截检测
            if "captcha" in final_url.lower() or "verify" in final_url.lower():
                raise Exception("登录触发验证码，无法自动化完成。请手动登录后"
                                "从浏览器复制 Cookie，或关闭账户的登录保护")

            # 凭证错误检测（页面仍在 /login 且有错误提示）
            if "/login" in final_url:
                try:
                    err_sel = (
                        '.alert-danger, .error-message, [class*="error"], '
                        '[class*="alert"]:has-text("错误"), '
                        '[class*="alert"]:has-text("失败")'
                    )
                    err = page.locator(err_sel).first.inner_text(timeout=2000)
                    raise Exception(f"登录失败: {err[:100]}")
                except PWTimeout:
                    # 无明显错误提示，可能是其他原因（如 JS 未完成重定向）
                    time.sleep(2)
                    if "/login" in page.url:
                        raise Exception("登录后未跳转（可能凭证错误或页面异常），"
                                        f"当前 URL: {page.url}")

            # 5. 成功 - 提取 cookies
            cookies = ctx.cookies()
            if not cookies:
                raise Exception(f"登录成功但未获取到 Cookie（URL={final_url}）")

            return cookies

        finally:
            browser.close()


def cookies_to_string(cookies):
    """Playwright cookies → `k=v; k2=v2` 格式。"""
    return "; ".join(f"{c['name']}={c['value']}" for c in cookies)


def load_dotenv(path=".env"):
    """简易 .env 加载器，返回 dict。"""
    env = {}
    if not os.path.exists(path):
        return env
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if "=" not in line:
                continue
            k, _, v = line.partition("=")
            env[k.strip()] = v.strip()
    return env


def update_dotenv(path, key, value):
    """原地更新 .env 文件的指定 key=value，保留注释与其他配置。

    如果 key 已存在则替换该行，不存在则追加到文件末尾。
    """
    if not os.path.exists(path):
        # 不存在则创建
        with open(path, "w", encoding="utf-8") as f:
            f.write(f"{key}={value}\n")
        return

    lines = []
    updated = False
    with open(path, encoding="utf-8") as f:
        for line in f:
            stripped = line.strip()
            # 匹配 key= 开头的行（忽略前后空白）
            if re.match(rf"^\s*{re.escape(key)}\s*=", line):
                lines.append(f"{key}={value}\n")
                updated = True
            else:
                lines.append(line)

    if not updated:
        # key 不存在，追加
        lines.append(f"\n{key}={value}\n")

    with open(path, "w", encoding="utf-8") as f:
        f.writelines(lines)


def find_dotenv():
    """查找项目根目录的 .env 文件。

    优先级：当前目录 → 脚本所在目录的上两级（项目根）
    """
    # 1. 当前工作目录
    if os.path.exists(".env"):
        return ".env"

    # 2. 脚本在 phase02/scripts/，项目根在 ../../
    script_dir = os.path.dirname(os.path.abspath(__file__))
    root = os.path.dirname(os.path.dirname(script_dir))
    candidate = os.path.join(root, ".env")
    if os.path.exists(candidate):
        return candidate

    return ".env"  # 兜底，不存在时让后续逻辑报错或创建


def main():
    dotenv_path = find_dotenv()

    # 优先从命令行读参数
    if len(sys.argv) >= 3:
        username = sys.argv[1]
        password = sys.argv[2]
        update_env = False
    else:
        # 从 .env 或环境变量读
        env = load_dotenv(dotenv_path)
        username = env.get("GITCODE_USERNAME") or os.environ.get("GITCODE_USERNAME")
        password = env.get("GITCODE_PASSWORD") or os.environ.get("GITCODE_PASSWORD")

        if not username or not password:
            print("错误: 未提供账密", file=sys.stderr)
            print(f"\n当前查找 .env 路径: {os.path.abspath(dotenv_path)}", file=sys.stderr)
            print("\n用法 1（从 .env）：", file=sys.stderr)
            print("  在 .env 文件中设置 GITCODE_USERNAME 和 GITCODE_PASSWORD", file=sys.stderr)
            print("  然后运行: python phase02/scripts/login_helper.py", file=sys.stderr)
            print("\n用法 2（命令行）：", file=sys.stderr)
            print("  python phase02/scripts/login_helper.py <username> <password>", file=sys.stderr)
            sys.exit(2)

        update_env = True  # 从 .env 读的，登录成功后写回

    headless = os.environ.get("UI_HEADLESS", "1") != "0"
    timeout = int(os.environ.get("LOGIN_TIMEOUT", 30000))

    try:
        print("正在登录 GitCode...", file=sys.stderr)
        cookies = login_and_get_cookie(username, password, headless, timeout)
        cookie_str = cookies_to_string(cookies)

        if update_env:
            # 写回 .env
            update_dotenv(dotenv_path, "GITCODE_COOKIE", cookie_str)
            print(f"\n✓ 登录成功，获取 {len(cookies)} 个 cookie", file=sys.stderr)
            print(f"✓ 已更新 {os.path.abspath(dotenv_path)} 的 GITCODE_COOKIE", file=sys.stderr)
        else:
            # 命令行模式，打印到 stdout
            print(cookie_str)
            print(f"\n✓ 登录成功，获取 {len(cookies)} 个 cookie", file=sys.stderr)
            print(f"✓ 请将上方 Cookie 串复制到 .env 文件的 GITCODE_COOKIE=", file=sys.stderr)

        sys.exit(0)

    except Exception as e:
        print(f"\n✗ 登录失败: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
