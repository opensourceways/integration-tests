"""
global_config.py
全局配置文件：集中管理所有页面URL、超时时间、截图路径等常量。
修改此文件即可适配不同环境或需求变更。
"""

import os
from pathlib import Path

# ========== 1. 页面基础配置 ==========
TARGET_URL = "https://openeuler.test.osinfra.cn/zh/download/commercial-release/"
"""目标页面URL：openEuler商业发行版"""

LOCALE = "zh-CN"
"""浏览器语言环境"""

VIEWPORT = {"width": 1920, "height": 1080}
"""浏览器视口分辨率，确保元素可见性一致"""

# ========== 2. 超时配置（单位：毫秒）==========
TIMEOUT_PAGE_LOAD = 30000
"""页面整体加载超时时间，30秒"""

TIMEOUT_ELEMENT = 10000
"""单个元素显式等待超时时间，10秒"""

TIMEOUT_NAVIGATION = 30000
"""页面跳转导航超时时间，30秒"""

TIMEOUT_NETWORK_IDLE = 10000
"""等待网络空闲超时时间，10秒"""

# ========== 3. 截图与日志配置 ==========
BASE_DIR = Path(__file__).parent.resolve()
SCREENSHOT_DIR = BASE_DIR / "screenshots"
LOG_DIR = BASE_DIR / "logs"

# 自动创建目录
SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
LOG_DIR.mkdir(parents=True, exist_ok=True)

SCREENSHOT_PREFIX = "openeuler_automation"
"""截图文件名前缀，便于批量识别"""

# ========== 4. 重试配置 ==========
MAX_RETRY = 3
"""通用操作失败后的最大重试次数"""

RETRY_DELAY = 1.0
"""重试间隔时间（秒），使用显式等待替代sleep"""

# ========== 5. 断言关键词配置 ==========
EXPECTED_TITLE_KEYWORDS = ["openEuler商业发行版", "openEuler下载"]
"""页面标题中必须包含的核心关键词"""

# ========== 6. 页面元素选择器常量（阶段1分析结果）==========
class Selectors:
    """集中维护所有页面元素CSS选择器，便于统一维护"""

    # Tab导航
    TAB_ACTIVE = ".pane-content.active"
    TAB_COMMUNITY = ".pane-content:not(.active)"

    # 筛选区域
    VENDOR_CHECKBOX_LIST = '.commercial-release input[type="checkbox"]'
    ARCH_TAG_LIST = ".commercial-release .filter-arch .tag"  # 需按文本细化
    SEARCH_INPUT = 'input[placeholder="请输入产品名称"]'

    # 卡片列表
    CARD_LIST_CONTAINER = ".commercial-release .download-list"
    CARD_ITEM = ".o-card"
    CARD_TITLE = ".o-card .title"
    CARD_DOWNLOAD_BTN = ".o-card .footer-link button"
    CARD_DOWNLOAD_LINK = ".o-card .footer-link"
    CARD_VENDOR = ".o-card .vendor"
    CARD_DATE = ".o-card .date"
    CARD_ARCH_TAG = ".o-card .arch-tag"

    # 分页
    PAGINATION_CONTAINER = ".o-pagination"
    PAGE_NUMBER = ".o-pagination-item"
    PAGE_NEXT = ".o-pagination-next"
    PAGE_TOTAL = ".o-pagination-total"

    # Cookie通知
    COOKIE_NOTICE = ".cookie-notice"
    COOKIE_CLOSE = ".cookie-notice .close"

    # 弹窗/遮罩（Element UI）
    DIALOG_OVERLAY = ".el-overlay-dialog"
