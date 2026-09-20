#!/usr/bin/env bash
# test_email.sh — 测试邮件发送功能
#
# 用法:
#   ./test_email.sh <run-id>
#
# 示例:
#   ./test_email.sh daily-20260920-143000

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [ $# -lt 1 ]; then
    echo "用法: ./test_email.sh <run-id>"
    echo ""
    echo "可用的 run-id 列表:"
    ls -1 phase02/reports/ 2>/dev/null | grep -v "latest.txt" || echo "  (暂无报告)"
    exit 1
fi

RUN_ID="$1"

# 检查报告是否存在
if [ ! -f "phase02/reports/$RUN_ID/report.md" ]; then
    echo "❌ 错误: 报告不存在 phase02/reports/$RUN_ID/report.md"
    echo ""
    echo "可用的 run-id 列表:"
    ls -1 phase02/reports/ 2>/dev/null | grep -v "latest.txt" || echo "  (暂无报告)"
    exit 1
fi

# 探测 Python
PYTHON=""
for cmd in python3 python py; do
    if command -v "$cmd" >/dev/null 2>&1; then
        PYTHON="$cmd"
        break
    fi
done
if [ -z "$PYTHON" ]; then
    echo "❌ 错误: 未找到 Python 解释器 (python3/python/py)"
    exit 1
fi

echo "=== 测试邮件发送功能 ==="
echo "Run ID: $RUN_ID"
echo "Python: $PYTHON"
echo ""

$PYTHON phase02/scripts/email_sender.py "$RUN_ID"
