#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
统一测试入口

直接执行本文件会跑完整套件（13 条用例），执行后数据自动恢复初始状态。
等价于：pytest tests/

用法：
    python test_cases.py              # 完整套件
    python test_cases.py -m "not slow"  # 只跑快速用例（跳过邮件验证）
    python test_cases.py -v           # 详细输出
    python test_cases.py --help       # 查看所有 pytest 选项
"""

import sys
from pathlib import Path

# 确保项目根目录在 sys.path，避免导入问题
project_root = Path(__file__).parent
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))


def main():
    import pytest

    # 默认参数：跑 tests/ 目录，生成 HTML 报告
    default_args = [
        "tests/",
        "--html=test_report.html",
        "--self-contained-html"
    ]

    # 合并用户传入的参数（如 -m "not slow"、-v 等）
    args = default_args + sys.argv[1:]

    print("=" * 60)
    print("openEuler 私人令牌 - 自动化测试套件")
    print("=" * 60)
    print(f"执行参数: {' '.join(args)}")
    print("=" * 60)
    print()

    # 执行 pytest
    exit_code = pytest.main(args)

    print()
    print("=" * 60)
    if exit_code == 0:
        print("✅ 测试通过")
        print("   HTML 报告: test_report.html")
        print("   数据已由 fixture 自动恢复初始状态")
    else:
        print(f"❌ 测试失败（退出码 {exit_code}）")
        print("   建议执行: python verify_cleanup.py")
        print("   检查是否有残留令牌")
    print("=" * 60)

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
