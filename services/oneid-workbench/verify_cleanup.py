#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
清理验证脚本（只读）

登录后列出当前所有令牌，检查是否有 auto_test_ 残留。
不做任何写操作。
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from token_manager import setup_session, teardown_session, list_tokens
from common.constants import AUTO_TOKEN_PREFIX, PROTECTED_TOKENS
from common.debug_utils import log


def main() -> int:
    pw, browser, ctx, page = setup_session(headless=True)
    try:
        tokens = list_tokens(page)
        log("=" * 60)
        log(f"当前令牌总数：{len(tokens)}")
        for t in tokens:
            log(f"  - {t['name']}  | 权限: {', '.join(t['permissions'])}")

        leftovers = [t["name"] for t in tokens
                     if t["name"].startswith(AUTO_TOKEN_PREFIX)
                     and t["name"] not in PROTECTED_TOKENS]
        log("=" * 60)
        if leftovers:
            log(f"❌ 发现 {len(leftovers)} 个测试残留令牌：")
            for name in leftovers:
                log(f"  - {name}")
            return 1
        log(f"✅ 无 {AUTO_TOKEN_PREFIX}* 残留，数据已恢复初始状态")
        return 0
    finally:
        teardown_session(pw, browser, ctx)


if __name__ == "__main__":
    sys.exit(main())
