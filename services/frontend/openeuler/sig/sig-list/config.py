"""
config.py
全局配置文件：所有与环境、页面、超时、路径相关的常量
修改此处即可适配不同环境/页面
"""

import os
from pathlib import Path

# ==================== 页面配置 ====================
BASE_URL = "https://openeuler.test.osinfra.cn"
TARGET_URL = f"{BASE_URL}/zh/sig/sig-list"

# ==================== 浏览器配置 ====================
BROWSER_TYPE = "chromium"       # chromium / firefox / webkit
HEADLESS = False                # True=无头，False=有头（推荐调试）
SLOW_MO = 100                   # 操作延迟(ms)，0=无延迟
VIEWPORT_WIDTH = 1920
VIEWPORT_HEIGHT = 1080

# ==================== 超时配置（毫秒） ====================
DEFAULT_TIMEOUT = 30_000        # 元素等待超时：30s
NAVIGATION_TIMEOUT = 30_000   # 页面导航超时：30s
API_TIMEOUT = 30_000            # API响应超时：30s

# ==================== 路径配置 ====================
PROJECT_ROOT = Path(__file__).parent.resolve()
SCREENSHOT_DIR = PROJECT_ROOT / "screenshots" / "20260713"
LOG_DIR = PROJECT_ROOT / "logs"

# 运行时自动创建目录
SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)

# ==================== 日志配置 ====================
LOG_LEVEL = "INFO"              # DEBUG / INFO / WARNING / ERROR
LOG_FILE = LOG_DIR / "automation.log"

# ==================== 重试配置 ====================
MAX_RETRY = 2                   # 操作失败最大重试次数
RETRY_DELAY = 1.0               # 重试间隔(秒)
