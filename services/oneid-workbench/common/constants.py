#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
公共常量定义

消除 OUT_DIR / TARGET_URL / TIMEOUT 在多个脚本中的重复定义。
"""

from pathlib import Path

# 项目根目录
BASE_DIR = Path(__file__).parent.parent  # oneid-workbench/

# 产物输出目录
OUT_DIR = BASE_DIR / "out"
OUT_DIR.mkdir(exist_ok=True)

# 目标页面
TARGET_URL = "https://openeuler.test.osinfra.cn/zh/my/tokens"

# 全局默认超时（硬性要求：30s）
TIMEOUT = 30_000  # 毫秒

# 安全护栏
PROTECTED_TOKENS = {"software_token"}  # 绝不触碰的既有令牌
AUTO_TOKEN_PREFIX = "auto_"            # 自动化测试令牌前缀
