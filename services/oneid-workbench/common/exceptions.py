#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
业务异常定义

为令牌管理操作提供清晰的异常类型，便于错误处理和调试。
"""


class TokenManagerError(Exception):
    """令牌管理基础异常"""
    pass


class ProtectedTokenError(TokenManagerError):
    """尝试操作保护名单令牌"""
    pass


class TokenNotFoundError(TokenManagerError):
    """令牌不存在"""
    pass


class TokenNameConflictError(TokenManagerError):
    """令牌名称冲突（已存在同名令牌）"""
    pass


class IdentityVerifyError(TokenManagerError):
    """身份验证失败（滑块/邮箱验证码）"""
    pass
