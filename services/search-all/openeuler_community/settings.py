# -*- coding: utf-8 -*-
"""
全局配置文件
可根据环境变量或命令行参数覆盖默认值
"""
import os

# ==================== 基础配置 ====================
# 目标服务地址，支持通过环境变量 BASE_URL 覆盖
BASE_URL = os.getenv("BASE_URL", "https://doc-search.test.osinfra.cn")

# 默认请求头
DEFAULT_HEADERS = {
    "Content-Type": "application/json",
    "Host": "doc-search.test.osinfra.cn",
    "User-Agent": "API-Automation-Test/1.0 (pytest+requests)",
    "Accept": "application/json",
}

# 多社区接口需要的 source 头（API-common 分支）
# 可选值: opengauss / mindspore / ubmc / openfuyao / hifloat
SOURCE = os.getenv("SOURCE", "openeuler")

# ==================== 超时与重试配置 ====================
# 连接超时（秒）
CONNECT_TIMEOUT = int(os.getenv("CONNECT_TIMEOUT", "10"))
# 读取超时（秒）
READ_TIMEOUT = int(os.getenv("READ_TIMEOUT", "30"))
# 请求重试次数
MAX_RETRIES = int(os.getenv("MAX_RETRIES", "3"))
# 重试间隔（秒）
RETRY_DELAY = float(os.getenv("RETRY_DELAY", "1.0"))

# ==================== 限流相关 ====================
# 用例间执行间隔（秒），避免触发限流
CASE_INTERVAL = float(os.getenv("CASE_INTERVAL", "0.5"))

# ==================== 日志配置 ====================
# 日志级别: DEBUG / INFO / WARNING / ERROR
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
# 日志文件路径，为空则只输出到控制台
LOG_FILE = os.getenv("LOG_FILE", "")
# 日志格式
LOG_FORMAT = "%(asctime)s [%(levelname)s] [%(name)s] %(message)s"

# ==================== 测试数据配置 ====================
# 测试数据文件路径
TEST_DATA_PATH = os.getenv("TEST_DATA_PATH", os.path.join(os.path.dirname(__file__), "..", "data", "test_data.json"))

# ==================== 断言阈值配置 ====================
# 默认期望的业务状态码
EXPECTED_BUSINESS_STATUS = int(os.getenv("EXPECTED_BUSINESS_STATUS", "200"))
# 期望的 HTTP 状态码
EXPECTED_HTTP_STATUS = int(os.getenv("EXPECTED_HTTP_STATUS", "200"))

# ==================== 环境标识 ====================
# 用于区分不同环境的测试报告
ENV_NAME = os.getenv("ENV_NAME", "openeuler-prod")
