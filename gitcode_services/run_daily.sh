#!/usr/bin/env bash
# run_daily.sh — 每日调度入口（自动回归对比 + 门禁退出码）
#
# 用法（可在任意目录调用，路径自适应）:
#   <包目录>/run_daily.sh [case-set-dir] [run-id-prefix]
# 例:
#   ./run_daily.sh                      # 默认 cases/yaml 全量
#   ./run_daily.sh cases/yaml nightly
#
# case-set-dir 为「本包根目录」的相对路径，也接受绝对路径。
#
# 路径模型（自包含，不依赖上级目录名）:
#   本脚本所在目录即包根 = 引擎的 ROOT。
#   phase02/scripts/*.py 由 __file__ 推导 ROOT，与此天然一致。
#
# 自动行为：
#   - run-id 取当前日期时间戳（可复现、可排序）
#   - 从 phase02/reports/latest.txt 读上次 run-id，自动 --compare
#   - 按门禁判定返回退出码（GO=0, BLOCKED=1, INCONCLUSIVE=2）

set -euo pipefail

# 包根 = 本脚本所在目录（不再假设自己叫 deploy/ 或位于某个固定父目录下）
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

CASE_SET="${1:-cases/yaml}"
RUN_PREFIX="${2:-daily}"
RUN_ID="${RUN_PREFIX}-$(date +%Y%m%d-%H%M%S)"
CASE_SET_TAG="${CASE_SET_TAG:-vendored}"  # 用例来源标记（仅元信息）

if [ ! -d "$CASE_SET" ]; then
    echo "错误: 用例目录不存在: $ROOT_DIR/$CASE_SET"
    exit 1
fi

if [ ! -d "phase02/scripts" ]; then
    echo "错误: 缺少执行引擎 phase02/scripts/"
    echo "      请先同步引擎: ./sync-cases.sh --from <上游仓路径>"
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
    echo "错误: 未找到 Python 解释器 (python3/python/py)"
    exit 1
fi

CASE_COUNT=$(find "$CASE_SET" -maxdepth 1 \( -name '*.yaml' -o -name '*.yml' \) | wc -l | tr -d ' ')

echo "=== GitCode 每日回归测试 ==="
echo "Run ID       : $RUN_ID"
echo "用例集       : $CASE_SET （$CASE_COUNT 条）"
echo "Python       : $PYTHON"
echo "包根目录     : $ROOT_DIR"

# 读上次 run-id（用于回归对比）
PREV_RUN=""
if [ -f "phase02/reports/latest.txt" ]; then
    PREV_RUN=$(tr -d '\n\r' < phase02/reports/latest.txt)
    echo "上次 run     : $PREV_RUN （自动回归对比）"
fi
echo ""

# 1. Schema 校验 + 按 test_type 分流（workflow/api/ui/git 各一条队列）
echo "[1/7] Schema 校验与分流..."
$PYTHON phase02/scripts/schema_check_ext.py "$CASE_SET_TAG" "$RUN_ID" --src-dir "$CASE_SET"

# 2-4. 四类批次。任一类环境不可用时会如实落 ENV_ERROR，不应中断整轮，
#      故统一容错；真正的门禁结论由第 7 步的覆盖率与阈值给出。
echo "[2/7] workflow 批量执行..."
$PYTHON phase02/scripts/run_batch.py "$RUN_ID"

echo "[3/7] api 批量执行..."
$PYTHON phase02/scripts/run_api_batch.py "$RUN_ID" || echo "警告: api 批次异常退出，继续"

echo "[4/7] ui 批量执行..."
$PYTHON phase02/scripts/run_ui_batch.py "$RUN_ID" || echo "警告: ui 批次异常退出，继续"

echo "[5/7] git 批量执行..."
$PYTHON phase02/scripts/run_git_batch.py "$RUN_ID" || echo "警告: git 批次异常退出，继续"

# 6. JUnit XML 导出（供 Jenkins 测试趋势图）
#    零结果时导出会返回 1；此处不阻断，让 report_builder 给出正式门禁结论
echo "[6/7] JUnit XML 导出..."
$PYTHON phase02/scripts/junit_export.py "$RUN_ID" || echo "警告: JUnit 导出无结果，继续生成报告"

# 5. 报告生成 + 门禁判定
#    上游 report_builder.py 只在「用法错误」(2)、「无结果」(1) 时非零退出，
#    GO/BLOCKED/INCONCLUSIVE 一律返回 0 —— 门禁退出码在上游并未实现。
#    这里不改上游文件（会被 sync-cases.sh 覆盖），而是解析它确定性打印的
#    「门禁: <GO|BLOCKED|INCONCLUSIVE>」一行，映射成真正的退出码。
echo "[7/7] 报告生成..."
set +e
REPORT_LOG="phase02/runs/$RUN_ID/report.log"
if [ -n "$PREV_RUN" ]; then
    $PYTHON phase02/scripts/report_builder.py "$RUN_ID" --compare "$PREV_RUN" 2>&1 | tee "$REPORT_LOG"
else
    $PYTHON phase02/scripts/report_builder.py "$RUN_ID" 2>&1 | tee "$REPORT_LOG"
fi
BUILD_CODE=${PIPESTATUS[0]}
set -e

if [ "$BUILD_CODE" -ne 0 ]; then
    GATE_CODE=$BUILD_CODE          # 1=无结果, 2=用法错误
else
    case "$(grep -oE '门禁: (GO|BLOCKED|INCONCLUSIVE)' "$REPORT_LOG" | tail -1)" in
        *GO)            GATE_CODE=0 ;;
        *BLOCKED)       GATE_CODE=1 ;;
        *INCONCLUSIVE)  GATE_CODE=2 ;;
        *)              echo "警告: 未能从报告中解析门禁结论，按 INCONCLUSIVE 处理"
                        GATE_CODE=2 ;;
    esac
fi

case "$GATE_CODE" in
    0) GATE_TEXT="GO（可上线）" ;;
    1) GATE_TEXT="BLOCKED（不可上线）" ;;
    2) GATE_TEXT="INCONCLUSIVE（样本不足，无法给结论）" ;;
    *) GATE_TEXT="报告生成失败" ;;
esac

echo ""
echo "=== 完成 ==="
echo "📄 Markdown 报告 : phase02/reports/$RUN_ID/report.md"
echo "📊 JSON 汇总     : phase02/runs/$RUN_ID/summary.json"
echo "🧪 JUnit XML     : phase02/runs/$RUN_ID/junit.xml"
echo "📁 详细结果      : phase02/runs/$RUN_ID/results/"
echo ""
echo "门禁判定: $GATE_TEXT (退出码 $GATE_CODE)"

exit "$GATE_CODE"
