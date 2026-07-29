"""
全局配置文件
test/config.py
存储页面URL、超时参数、截图路径、浏览器初始化参数等常量
"""
import os

# 项目根目录 (test目录的父目录)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# 测试输出目录
TEST_DIR = os.path.join(BASE_DIR, "test")
# 截图保存目录
SCREENSHOT_DIR = os.path.join(TEST_DIR, "screenshots")
# 日志保存目录
LOG_DIR = os.path.join(TEST_DIR, "logs")

# 自动创建必要目录
os.makedirs(SCREENSHOT_DIR, exist_ok=True)
os.makedirs(LOG_DIR, exist_ok=True)

# ==================== 页面配置 ====================
# 目标测试页面URL
TARGET_URL = "https://openeuler.test.osinfra.cn/zh/sig/meeting-guide/"

# 浏览器视口分辨率
VIEWPORT_WIDTH = 1920
VIEWPORT_HEIGHT = 1080

# 全局默认超时 (毫秒)
DEFAULT_TIMEOUT = 30000  # 30秒

# 显式等待轮询间隔 (毫秒)
POLLING_INTERVAL = 500   # 0.5秒

# ==================== 浏览器配置 ====================
BROWSER_CONFIG = {
    "headless": False,              # 有头模式 (阿蓁要求)
    "args": [
        "--no-sandbox",              # 禁用沙箱，部分CI/容器环境需要
        "--disable-dev-shm-usage",   # 禁用/dev/shm，防止内存不足
        "--disable-gpu",             # 禁用GPU加速，提升兼容性
        "--window-size=1920,1080",   # 固定窗口尺寸
    ],
}

# 浏览器上下文配置 (语言、时区等)
CONTEXT_CONFIG = {
    "viewport": {"width": VIEWPORT_WIDTH, "height": VIEWPORT_HEIGHT},
    "locale": "zh-CN",              # 固定中文环境，避免多语言干扰
    "timezone_id": "Asia/Shanghai", # 东八区时区
}

# ==================== 页面关键校验文本配置 ====================
# 页面标题必须包含的关键字 (用于正则匹配)
EXPECTED_TITLE_PATTERN = r".*会议指南.*"

# 页面URL必须包含的路径片段
EXPECTED_URL_PATH = "/zh/sig/meeting-guide/"

# 页面必须存在的板块标题 (H1/H2层级)
EXPECTED_SECTIONS = ["会议规划", "会议类型", "组织会议"]

# 面包屑导航必须包含的文本
EXPECTED_BREADCRUMB = ["SIG中心", "会议指南"]

# 页脚必须包含的关键链接文本
EXPECTED_FOOTER_LINKS = ["隐私声明", "法律声明", "关于cookies"]

# ==================== 截图与日志配置 ====================
# 截图文件名时间格式
SCREENSHOT_TIME_FORMAT = "%Y%m%d_%H%M%S"

# 日志文件名时间格式
LOG_TIME_FORMAT = "%Y%m%d_%H%M%S"

# 日志级别
LOG_LEVEL = "INFO"
