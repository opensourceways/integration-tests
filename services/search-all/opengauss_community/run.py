# -*- coding: utf-8 -*-
"""
统一执行入口
支持：
  1. 直接运行全部用例
  2. 按标签/模块筛选运行
  3. 生成 HTML / Allure / JUnit XML 报告
  4. 汇总最终执行统计（总用例数、成功数、失败数）

运行命令示例：
  python run.py
  python run.py --module test_search
  python run.py --env prod
  python run.py --report html
"""
import os
import sys
import argparse
import subprocess
import json
from pathlib import Path

# 将项目根目录加入 PYTHONPATH
PROJECT_ROOT = Path(__file__).parent
sys.path.insert(0, str(PROJECT_ROOT))


def parse_args():
    parser = argparse.ArgumentParser(description="API 自动化测试执行器")
    parser.add_argument(
        "--module", "-m",
        type=str,
        default="",
        help="指定测试模块，如 test_search / test_sort / test_software / test_jumper / test_sig"
    )
    parser.add_argument(
        "--env", "-e",
        type=str,
        default="",
        help="环境标识，会写入报告元数据"
    )
    parser.add_argument(
        "--report", "-r",
        type=str,
        choices=["html", "allure", "xml", ""],
        default="html",
        help="报告类型: html(默认) / allure / xml / 空(仅控制台)"
    )
    parser.add_argument(
        "--base-url",
        type=str,
        default="",
        help="覆盖默认 BASE_URL，如 https://doc-search.openeuler.org"
    )
    parser.add_argument(
        "--source",
        type=str,
        default="",
        help="覆盖 source 头，如 openeuler / opengauss / mindspore"
    )
    parser.add_argument(
        "--referer",
        type=str,
        default="",
        help="覆盖 Referer 头，如 https://www.openeuler.org/"
    )
    parser.add_argument(
        "--parallel", "-p",
        action="store_true",
        help="是否并行执行（pytest-xdist）"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="详细输出"
    )
    return parser.parse_args()


def build_pytest_args(args) -> list:
    """构造 pytest 命令行参数"""
    cmd = ["pytest"]

    # 测试路径
    if args.module:
        test_path = PROJECT_ROOT / f"{args.module}.py"
        if not test_path.exists():
            print(f"[错误] 测试模块不存在: {test_path}")
            sys.exit(1)
        cmd.append(str(test_path))
    else:
        cmd.append(str(PROJECT_ROOT))

    # 详细输出
    if args.verbose:
        cmd.append("-v")
    else:
        cmd.append("-v")

    # 失败继续（不中断整体测试）
    cmd.append("--continue-on-collection-errors")

    # 报告配置
    report_dir = PROJECT_ROOT

    if args.report == "html":
        cmd.extend([
            f"--html={report_dir / 'report.html'}",
            "--self-contained-html",
        ])
    elif args.report == "allure":
        cmd.extend([f"--alluredir={report_dir / 'allure_results'}"])
    elif args.report == "xml":
        cmd.extend([f"--junitxml={report_dir / 'junit.xml'}"])

    # 环境变量注入
    env_vars = {}
    if args.base_url:
        env_vars["BASE_URL"] = args.base_url
    if args.source:
        env_vars["SOURCE"] = args.source
    if args.referer:
        env_vars["REFERER"] = args.referer
    if args.env:
        env_vars["ENV_NAME"] = args.env

    return cmd, env_vars


def run_pytest(cmd: list, env_vars: dict):
    """执行 pytest 并捕获结果"""
    env = os.environ.copy()
    env.update(env_vars)

    print("=" * 60)
    print("[执行命令]", " ".join(cmd))
    print("[环境变量]", json.dumps(env_vars, indent=2, ensure_ascii=False))
    print("=" * 60)

    result = subprocess.run(cmd, env=env, cwd=str(PROJECT_ROOT))
    return result.returncode


def print_summary():
    """尝试读取并打印 pytest-html 的汇总信息"""
    report_path = PROJECT_ROOT / "report.html"
    if report_path.exists():
        print(f"\n[报告已生成] {report_path}")
    else:
        print("\n[提示] 报告未生成，可能 pytest-html 插件未安装")


def main():
    args = parse_args()
    cmd, env_vars = build_pytest_args(args)
    exit_code = run_pytest(cmd, env_vars)
    print_summary()
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
