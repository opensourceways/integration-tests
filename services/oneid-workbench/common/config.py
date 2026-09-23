#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
配置管理

统一 .env 读取，并注入环境变量供 email_verify.py 使用。
"""

import os
from pathlib import Path


class Config:
    """配置单例，自动加载 .env 并注入环境变量"""

    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._load()
        return cls._instance

    def _load(self):
        """加载 .env 文件"""
        env_path = Path(__file__).parent.parent / ".env"

        if not env_path.exists():
            raise FileNotFoundError(
                f".env 文件不存在: {env_path}\n"
                "请创建 .env 文件并配置测试账号信息"
            )

        # 手动解析 .env（避免引入 python-dotenv 依赖）
        env_vars = {}
        for line in env_path.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            # 跳过空行和注释
            if not line or line.startswith("#"):
                continue
            # 解析 KEY = VALUE 或 KEY=VALUE
            if "=" in line:
                key, _, value = line.partition("=")
                key = key.strip()
                value = value.strip().strip('"').strip("'")  # 去除引号
                env_vars[key] = value

        # 读取配置项（带默认值）
        self.account = env_vars.get("TEST_ACCOUNT", "")
        self.password = env_vars.get("TEST_PASSWORD", "")
        self.login_mode = env_vars.get("LOGIN_MODE", "code")

        # 邮箱验证码配置
        self.mail_user = env_vars.get("MAIL_USER") or self.account
        self.mail_auth_code = env_vars.get("MAIL_AUTH_CODE", "")
        self.mail_code_timeout = int(env_vars.get("MAIL_CODE_TIMEOUT", "150"))

        # 滑块配置
        self.slider_auto = env_vars.get("SLIDER_AUTO", "1") == "1"
        self.slider_auto_attempts = int(env_vars.get("SLIDER_AUTO_ATTEMPTS", "3"))
        self.slider_wait = int(env_vars.get("SLIDER_WAIT", "300"))

        # MFA 人工兜底
        self.mfa_manual = env_vars.get("MFA_MANUAL", "0") == "1"
        self.mfa_manual_wait = int(env_vars.get("MFA_MANUAL_WAIT", "180"))

        # 校验必填项
        if not self.account:
            raise ValueError(".env 中 TEST_ACCOUNT 不能为空")
        if self.login_mode == "password" and not self.password:
            raise ValueError(".env 中 LOGIN_MODE=password 时 TEST_PASSWORD 不能为空")
        if self.login_mode == "code" and not self.mail_auth_code:
            raise ValueError(
                ".env 中 LOGIN_MODE=code 时 MAIL_AUTH_CODE 不能为空\n"
                "请填写邮箱客户端授权码（不是登录密码）"
            )

        # 注入环境变量（供 email_verify.py 使用）
        os.environ["MAIL_USER"] = self.mail_user
        os.environ["MAIL_AUTH_CODE"] = self.mail_auth_code
        os.environ["MAIL_CODE_TIMEOUT"] = str(self.mail_code_timeout)


# 单例导出
config = Config()
