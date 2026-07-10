# config.py
# 全局配置文件：统一管理页面URL、超时、路径、视窗参数

# ==================== 页面基础配置 ====================
BASE_URL = "https://openeuler.test.osinfra.cn/zh/"
EXPECTED_TITLE = "openEuler"

# ==================== 浏览器配置 ====================
BROWSER_TYPE = "chromium"      # 可选: chromium / firefox / webkit
HEADLESS = False               # 有头模式
VIEWPORT = {"width": 1920, "height": 1080}

# ==================== 超时配置（单位：毫秒） ====================
DEFAULT_TIMEOUT = 30_000
NAVIGATION_TIMEOUT = 30_000
ASSERTION_TIMEOUT = 10_000

# ==================== 日志配置 ====================
LOG_FORMAT = "%(asctime)s [%(levelname)s] %(message)s"
LOG_DATEFMT = "%Y-%m-%d %H:%M:%S"
