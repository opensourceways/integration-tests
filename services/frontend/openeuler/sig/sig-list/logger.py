"""
logger.py
统一日志封装：文件+控制台双输出，自动记录执行轨迹
"""

import logging
import sys

from config import LOG_FILE, LOG_LEVEL


def get_logger(name: str = "playwright-auto") -> logging.Logger:
    """
    获取配置好的Logger实例
    :param name: logger名称
    :return: 配置好的Logger
    """
    logger = logging.getLogger(name)
    logger.setLevel(getattr(logging, LOG_LEVEL.upper()))

    # 避免重复添加handler
    if logger.handlers:
        return logger

    formatter = logging.Formatter(
        "[%(asctime)s] [%(levelname)-7s] [%(name)s] %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    # 控制台输出
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    # 文件输出
    file_handler = logging.FileHandler(LOG_FILE, encoding="utf-8")
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    return logger
