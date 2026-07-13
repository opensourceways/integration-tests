"""
全局配置文件
test/config.py
存储所有页面URL、浏览器参数、等待时长、截图路径等常量
"""
import os
from pathlib import Path

# ──────────────────────────────
# 页面URL配置
# ──────────────────────────────
TARGET_URL = "https://openeuler.test.osinfra.cn/zh/sig/role-description"
LOGIN_URL = ""  # 如需登录测试，阿蓁可提供具体URL后填入

# ──────────────────────────────
# 浏览器配置（Chrome有头模式）
# ──────────────────────────────
BROWSER_CONFIG = {
    "browser_type": "chromium",   # Playwright 默认 chromium，行为接近 Chrome
    "headless": False,            # 有头模式，便于调试观察
    "channel": None,              # 如需调用系统 Chrome，可改为 "chrome"
    "viewport": {"width": 1920, "height": 1080},
    "locale": "zh-CN",
    "timezone_id": "Asia/Shanghai",
}

# ──────────────────────────────
# 超时与等待配置（单位：毫秒）
# ──────────────────────────────
DEFAULT_TIMEOUT = 30_000        # 默认操作超时 30s（与需求一致）
NAVIGATION_TIMEOUT = 30_000     # 页面导航超时 30s
EXPECT_TIMEOUT = 10_000         # expect 断言默认等待 10s
POLLING_INTERVAL = 500          # 轮询间隔 500ms（显式等待轮询）

# ──────────────────────────────
# 路径配置
# ──────────────────────────────
BASE_DIR = Path(__file__).parent.resolve()
SCREENSHOT_DIR = BASE_DIR / "screenshots"
LOG_DIR = BASE_DIR / "logs"

# 自动创建目录
SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)

SCREENSHOT_NAME_PREFIX = "openEuler_test"
LOG_FILE = LOG_DIR / "test_automation.log"

# ──────────────────────────────
# 页面关键文案（用于断言）
# ──────────────────────────────
# 注意：页面标题在部分环境中可能因编码问题导致中文乱码，优先使用英文片段做兜底断言
EXPECTED_TITLE_KEYWORD = "openEuler"          # 标题中稳定出现的英文品牌名
EXPECTED_TITLE_FALLBACK = "SIG"               # 标题中稳定出现的英文缩写（备选）
EXPECTED_URL_SUFFIX = "/zh/sig/role-description/"
BREADCRUMB_SIG_TEXT = "SIG中心"
BREADCRUMB_CURRENT_TEXT = "角色说明"

ROLE_CARDS = {
    "contributor": {"name": "贡献者", "anchor": "#contributor"},
    "committer": {"name": "审核者", "anchor": "#committer"},
    "maintainer": {"name": "维护者", "anchor": "#maintainer"},
}

COOKIE_BANNER_KEYWORDS = ["cookie", "浏览体验"]
