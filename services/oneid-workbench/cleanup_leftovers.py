#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
清理测试残留令牌

删除所有 AUTO_TOKEN_PREFIX 开头的令牌，跳过 PROTECTED_TOKENS。
用于测试中断后手工收尾。
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from token_manager import (
    setup_session, teardown_session, list_tokens, delete_token
)
from common.constants import AUTO_TOKEN_PREFIX, PROTECTED_TOKENS
from common.debug_utils import log


def main() -> int:
    pw, browser, ctx, page = setup_session(headless=False)
    try:
        targets = [t["name"] for t in list_tokens(page)
                   if t["name"].startswith(AUTO_TOKEN_PREFIX)
                   and t["name"] not in PROTECTED_TOKENS]

        if not targets:
            log("✅ 无残留令牌，无需清理")
            return 0

        log(f"待清理 {len(targets)} 个：{targets}")
        failed = []
        for name in targets:
            try:
                if not delete_token(page, name):
                    failed.append(name)
            except Exception as exc:
                log(f"  !! 删除 {name} 失败: {exc}")
                failed.append(name)

        log("=" * 60)
        if failed:
            log(f"❌ {len(failed)} 个未能删除：{failed}")
            return 1
        log(f"✅ 已清理 {len(targets)} 个残留令牌")
        return 0
    finally:
        teardown_session(pw, browser, ctx)


if __name__ == "__main__":
    sys.exit(main())
