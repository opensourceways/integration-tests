# -*- coding: utf-8 -*-
"""
日志模块
统一封装日志打印，区分 INFO / ERROR 级别
支持输出到控制台和文件
"""
import logging
import sys
import os

from settings import LOG_LEVEL, LOG_FILE, LOG_FORMAT


def get_logger(name: str = "api_test") -> logging.Logger:
    """
    获取配置好的 Logger 实例
    :param name: Logger 名称，建议传入 __name__ 或模块名
    :return: logging.Logger
    """
    logger = logging.getLogger(name)

    # 避免重复添加 handler
    if logger.handlers:
        return logger

    level = getattr(logging, LOG_LEVEL.upper(), logging.INFO)
    logger.setLevel(level)

    # 控制台 Handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(level)
    console_formatter = logging.Formatter(LOG_FORMAT)
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)

    # 文件 Handler（如配置了 LOG_FILE）
    if LOG_FILE:
        log_dir = os.path.dirname(LOG_FILE)
        if log_dir and not os.path.exists(log_dir):
            os.makedirs(log_dir, exist_ok=True)
        file_handler = logging.FileHandler(LOG_FILE, encoding="utf-8")
        file_handler.setLevel(level)
        file_formatter = logging.Formatter(LOG_FORMAT)
        file_handler.setFormatter(file_formatter)
        logger.addHandler(file_handler)

    return logger
