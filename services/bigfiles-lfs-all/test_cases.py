#!/usr/bin/env python3
"""
验证 Git LFS 功能的测试脚本
针对仓库: https://gitcode.com/lfs-org/lfs-test
"""

import os
import sys
import subprocess
import tempfile
import shutil
import argparse
from pathlib import Path


class Colors:
    """终端颜色输出"""
    GREEN = ''
    RED = ''
    YELLOW = ''
    BLUE = ''
    RESET = ''


def print_step(step_num, total, message):
    """打印步骤信息"""
    print(f"\n[{step_num}/{total}] {message}")


def print_success(message):
    """打印成功信息"""
    print(f"[PASS] {message}")


def print_error(message):
    """打印错误信息"""
    print(f"[FAIL] {message}")


def print_warning(message):
    """打印警告信息"""
    print(f"[WARN] {message}")


def print_info(message):
    """打印信息"""
    print(f"[INFO] {message}")


def run_command(cmd, cwd=None, check=True, capture_output=True, env=None):
    """
    运行 shell 命令并返回结果

    Args:
        cmd: 命令列表或字符串
        cwd: 工作目录
        check: 是否检查返回码
        capture_output: 是否捕获输出
        env: 环境变量

    Returns:
        subprocess.CompletedProcess 对象
    """
    if isinstance(cmd, str):
        cmd = cmd.split()

    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            check=check,
            capture_output=capture_output,
            text=True,
            env=env
        )
        return result
    except subprocess.CalledProcessError as e:
        if check:
            print_error(f"命令执行失败: {' '.join(cmd)}")
            print_error(f"错误输出: {e.stderr}")
            raise
        return e
    except FileNotFoundError:
        print_error(f"命令未找到: {cmd[0]}")
        raise


class LFSVerifier:
    """Git LFS 功能验证器"""

    def __init__(self, repo_url, clone_dir=None, keep_clone=False):
        """
        初始化验证器

        Args:
            repo_url: 仓库 URL
            clone_dir: 克隆目录（默认创建临时目录）
            keep_clone: 是否保留克隆目录
        """
        self.repo_url = repo_url
        self.keep_clone = keep_clone
        self.clone_dir = clone_dir
        self.temp_dir = None
        self.total_steps = 7
        self.current_step = 0

    def _next_step(self, message):
        """进入下一步"""
        self.current_step += 1
        print_step(self.current_step, self.total_steps, message)

    def check_git_installation(self):
        """检查 Git 是否安装"""
        self._next_step("检查 Git 安装")
        try:
            result = run_command(["git", "--version"], check=False)
            if result.returncode == 0:
                version = result.stdout.strip()
                print_success(f"Git 已安装: {version}")
                return True
            else:
                print_error("Git 未安装或无法执行")
                return False
        except Exception as e:
            print_error(f"检查 Git 失败: {e}")
            return False

    def check_git_lfs_installation(self):
        """检查 Git LFS 是否安装"""
        self._next_step("检查 Git LFS 安装")
        try:
            result = run_command(["git", "lfs", "version"], check=False)
            if result.returncode == 0:
                version = result.stdout.strip().split('\n')[0]
                print_success(f"Git LFS 已安装: {version}")
                return True
            else:
                print_error("Git LFS 未安装")
                print_info("请访问 https://git-lfs.com 安装 Git LFS")
                return False
        except Exception as e:
            print_error(f"检查 Git LFS 失败: {e}")
            return False

    def clone_repository(self):
        """克隆仓库"""
        self._next_step("克隆仓库")
        try:
            if self.clone_dir:
                target_dir = self.clone_dir
                os.makedirs(target_dir, exist_ok=True)
            else:
                self.temp_dir = tempfile.mkdtemp(prefix="lfs-test-")
                target_dir = self.temp_dir

            print_info(f"克隆目标目录: {target_dir}")
            print_info(f"仓库 URL: {self.repo_url}")

            # 克隆仓库（不使用 --depth=1，避免 LFS 浅克隆问题）
            result = run_command(
                ["git", "clone", self.repo_url, target_dir],
                check=False,
                capture_output=True
            )

            if result.returncode == 0:
                print_success("仓库克隆成功")
                self.repo_path = target_dir
                return True
            else:
                print_error("仓库克隆失败")
                print_error(f"错误信息: {result.stderr}")
                return False

        except Exception as e:
            print_error(f"克隆仓库时出错: {e}")
            return False

    def check_lfs_config(self):
        """检查 LFS 配置"""
        self._next_step("检查 LFS 配置")
        try:
            lfsconfig_path = os.path.join(self.repo_path, ".lfsconfig")

            if os.path.exists(lfsconfig_path):
                print_success("找到 .lfsconfig 文件")
                with open(lfsconfig_path, 'r') as f:
                    content = f.read()
                print_info(".lfsconfig 内容:")
                for line in content.strip().split('\n'):
                    print(f"  {line}")
            else:
                print_warning("未找到 .lfsconfig 文件")
                print_info("使用 Git 默认 LFS 配置")

            # 检查 Git LFS URL 配置
            result = run_command(
                ["git", "config", "--local", "lfs.url"],
                cwd=self.repo_path,
                check=False
            )
            if result.returncode == 0:
                print_info(f"本地 LFS URL: {result.stdout.strip()}")
            else:
                print_info("未设置本地 LFS URL，使用默认配置")

            return True

        except Exception as e:
            print_error(f"检查 LFS 配置失败: {e}")
            return False

    def check_lfs_files(self):
        """检查 LFS 追踪的文件"""
        self._next_step("检查 LFS 追踪文件")
        try:
            # 查找 LFS 指针文件
            lfs_files = []
            for root, dirs, files in os.walk(self.repo_path):
                # 跳过 .git 目录
                if '.git' in root:
                    continue
                for file in files:
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'rb') as f:
                            header = f.read(100)
                            if header.startswith(b'version https://git-lfs.github.com/spec/v1'):
                                rel_path = os.path.relpath(file_path, self.repo_path)
                                lfs_files.append(rel_path)
                    except:
                        pass

            if lfs_files:
                print_success(f"发现 {len(lfs_files)} 个 LFS 指针文件:")
                for f in lfs_files:
                    print(f"  - {f}")
            else:
                print_warning("未发现 LFS 指针文件")

            # 检查 git lfs ls-files
            result = run_command(
                ["git", "lfs", "ls-files"],
                cwd=self.repo_path,
                check=False
            )

            if result.returncode == 0 and result.stdout.strip():
                print_success("Git LFS 追踪文件列表:")
                lines = result.stdout.strip().splitlines()
                for line in lines[:10]:
                    print(f"  {line}")
                if len(lines) > 10:
                    print(f"  ... 及其他 {len(lines) - 10} 个文件")
                return True
            else:
                print_warning("git lfs ls-files 未返回结果或执行失败")
                return True  # 不阻断，因为可能仓库没有 LFS 文件

        except Exception as e:
            print_error(f"检查 LFS 文件失败: {e}")
            return False

    def pull_lfs_files(self):
        """拉取 LFS 文件内容"""
        self._next_step("拉取 LFS 文件内容")
        try:
            print_info("执行 git lfs pull...")
            result = run_command(
                ["git", "lfs", "pull"],
                cwd=self.repo_path,
                check=False,
                capture_output=True
            )

            if result.returncode == 0:
                print_success("LFS 文件拉取成功")
                if result.stdout.strip():
                    print_info("输出:")
                    for line in result.stdout.strip().split('\n'):
                        print(f"  {line}")
                return True
            else:
                print_error("LFS 文件拉取失败")
                print_error(f"错误信息: {result.stderr}")
                return False

        except Exception as e:
            print_error(f"拉取 LFS 文件时出错: {e}")
            return False

    def verify_lfs_content(self):
        """验证 LFS 文件内容完整性"""
        self._next_step("验证 LFS 文件内容")
        try:
            # 检查指针文件是否已被替换为实际内容
            lfs_files = []
            for root, dirs, files in os.walk(self.repo_path):
                if '.git' in root:
                    continue
                for file in files:
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'rb') as f:
                            header = f.read(100)
                            if header.startswith(b'version https://git-lfs.github.com/spec/v1'):
                                rel_path = os.path.relpath(file_path, self.repo_path)
                                lfs_files.append(rel_path)
                    except:
                        pass

            if lfs_files:
                print_warning(f"仍有 {len(lfs_files)} 个文件是 LFS 指针文件（未下载实际内容）:")
                for f in lfs_files[:5]:
                    print(f"  - {f}")
                return False
            else:
                print_success("所有 LFS 文件内容已正确下载")

            # 验证文件大小
            result = run_command(
                ["git", "lfs", "ls-files", "--size"],
                cwd=self.repo_path,
                check=False
            )

            if result.returncode == 0 and result.stdout.strip():
                print_info("LFS 文件大小信息:")
                for line in result.stdout.strip().split('\n')[:10]:
                    print(f"  {line}")

            return True

        except Exception as e:
            print_error(f"验证 LFS 内容失败: {e}")
            return False

    def cleanup(self):
        """清理临时目录"""
        if self.temp_dir and os.path.exists(self.temp_dir) and not self.keep_clone:
            print_info(f"清理临时目录: {self.temp_dir}")
            shutil.rmtree(self.temp_dir, ignore_errors=True)

    def run_verification(self):
        """运行完整的验证流程"""
        print("=" * 60)
        print("Git LFS 功能验证脚本")
        print(f"目标仓库: {self.repo_url}")
        print("=" * 60)

        results = []

        try:
            # 步骤 1: 检查 Git 安装
            results.append(("Git 安装检查", self.check_git_installation()))
            if not results[-1][1]:
                print_error("Git 未安装，无法继续验证")
                return False

            # 步骤 2: 检查 Git LFS 安装
            results.append(("Git LFS 安装检查", self.check_git_lfs_installation()))
            if not results[-1][1]:
                print_error("Git LFS 未安装，无法继续验证")
                return False

            # 步骤 3: 克隆仓库
            results.append(("仓库克隆", self.clone_repository()))
            if not results[-1][1]:
                print_error("仓库克隆失败，无法继续验证")
                return False

            # 步骤 4: 检查 LFS 配置
            results.append(("LFS 配置检查", self.check_lfs_config()))

            # 步骤 5: 检查 LFS 文件
            results.append(("LFS 文件检查", self.check_lfs_files()))

            # 步骤 6: 拉取 LFS 文件
            results.append(("LFS 文件拉取", self.pull_lfs_files()))

            # 步骤 7: 验证 LFS 内容
            results.append(("LFS 内容验证", self.verify_lfs_content()))

            # 打印总结
            print("\n" + "=" * 60)
            print("验证结果总结")
            print("=" * 60)

            passed = 0
            failed = 0

            for name, result in results:
                status = f"{Colors.GREEN}通过{Colors.RESET}" if result else f"{Colors.RED}失败{Colors.RESET}"
                print(f"  {name}: {status}")
                if result:
                    passed += 1
                else:
                    failed += 1

            print(f"\n总计: {passed} 通过, {failed} 失败")

            if failed == 0:
                print_success("所有验证通过！")
                return True
            else:
                print_error(f"有 {failed} 项验证失败")
                return False

        except KeyboardInterrupt:
            print_warning("\n用户中断验证")
            return False
        except Exception as e:
            print_error(f"验证过程中发生错误: {e}")
            return False
        finally:
            self.cleanup()


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='验证 Git LFS 功能',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  python lfs_verify.py
  python lfs_verify.py --url https://gitcode.com/lfs-org/lfs-test
  python lfs_verify.py --keep-clone --clone-dir ./lfs-test-repo
        """
    )

    parser.add_argument(
        '--url',
        default='https://gitcode.com/lfs-org/lfs-test',
        help='要验证的仓库 URL (默认: https://gitcode.com/lfs-org/lfs-test)'
    )

    parser.add_argument(
        '--clone-dir',
        help='指定克隆目录（默认创建临时目录）'
    )

    parser.add_argument(
        '--keep-clone',
        action='store_true',
        help='验证完成后保留克隆目录'
    )

    parser.add_argument(
        '--check-only',
        action='store_true',
        help='仅检查环境，不克隆和验证仓库'
    )

    args = parser.parse_args()

    verifier = LFSVerifier(
        repo_url=args.url,
        clone_dir=args.clone_dir,
        keep_clone=args.keep_clone
    )

    if args.check_only:
        print("=" * 60)
        print("环境检查模式")
        print("=" * 60)
        verifier.check_git_installation()
        verifier.check_git_lfs_installation()
    else:
        success = verifier.run_verification()
        sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
