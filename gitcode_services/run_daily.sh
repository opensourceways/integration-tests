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

# 配置文件（凭证与调参）。缺失时不中断：环境变量也能提供全部配置，
# 真正缺凭证会在各批次如实落 ENV_ERROR，由覆盖率门禁给结论。
CONFIG_FILE="${CONFIG_FILE:-$ROOT_DIR/config.yaml}"
if [ -f "$CONFIG_FILE" ]; then
    export CONFIG_FILE
else
    echo "警告: 未找到配置文件 $CONFIG_FILE"
    echo "      可执行: cp config.yaml.example config.yaml 后填入凭证"
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
echo "配置文件     : ${CONFIG_FILE:-（未找到，仅用环境变量）}"

# 读上次 run-id（用于回归对比）
PREV_RUN=""
if [ -f "phase02/reports/latest.txt" ]; then
    PREV_RUN=$(tr -d '\n\r' < phase02/reports/latest.txt)
    echo "上次 run     : $PREV_RUN （自动回归对比）"
fi
echo ""

# 0. 登录态自检：cookie 为空时自动登录并回写 config.yaml
#    UI 用例依赖 GITCODE_COOKIE；缺失时公开页仍可跑，但 /settings/* 与
#    /dashboard/notifications 等需登录态的页面会判不可测试，压低执行覆盖率。
#    登录失败不中断整轮（可能触发验证码/登录保护），退回匿名继续，
#    由覆盖率门禁给结论。
COOKIE_STATE="config.yaml 已有"
if [ -z "${GITCODE_COOKIE:-}" ] && [ -n "${CONFIG_FILE:-}" ] \
   && ! $PYTHON -c "
import sys
sys.path.insert(0, 'phase02/scripts')
import config_loader as c
sys.exit(0 if (c.get('gitcode.cookie') or '').strip() else 1)
" 2>/dev/null; then
    echo "登录态       : config.yaml 的 gitcode.cookie 为空，尝试自动登录..."
    set +e
    $PYTHON phase02/scripts/login_helper.py 2>&1 | sed 's/^/             /'
    LOGIN_CODE=${PIPESTATUS[0]}
    set -e
    if [ "$LOGIN_CODE" -eq 0 ]; then
        COOKIE_STATE="自动登录获取"
    else
        COOKIE_STATE="无（自动登录失败，UI 私有页将判不可测试）"
        echo "警告: 自动登录失败（退出码 $LOGIN_CODE），退回匿名执行"
        echo "      可手动获取 Cookie: python phase02/scripts/login_helper.py <账号> <密码>"
    fi
elif [ -n "${GITCODE_COOKIE:-}" ]; then
    COOKIE_STATE="环境变量提供"
fi
echo "登录态       : $COOKIE_STATE"
echo ""

# 1. Schema 校验 + 按 test_type 分流（workflow/api/ui/git 各一条队列）
echo "[1/8] Schema 校验与分流..."
$PYTHON phase02/scripts/schema_check_ext.py "$CASE_SET_TAG" "$RUN_ID" --src-dir "$CASE_SET"

# 2-4. 四类批次。任一类环境不可用时会如实落 ENV_ERROR，不应中断整轮，
#      故统一容错；真正的门禁结论由第 7 步的覆盖率与阈值给出。
echo "[2/8] workflow 批量执行..."
$PYTHON phase02/scripts/run_batch.py "$RUN_ID"

echo "[3/8] api 批量执行..."
$PYTHON phase02/scripts/run_api_batch.py "$RUN_ID" || echo "警告: api 批次异常退出，继续"

echo "[4/8] ui 批量执行..."
$PYTHON phase02/scripts/run_ui_batch.py "$RUN_ID" || echo "警告: ui 批次异常退出，继续"

echo "[5/8] git 批量执行..."
$PYTHON phase02/scripts/run_git_batch.py "$RUN_ID" || echo "警告: git 批次异常退出，继续"

# 6. JUnit XML 导出（供 Jenkins 测试趋势图）
#    零结果时导出会返回 1；此处不阻断，让 report_builder 给出正式门禁结论
echo "[6/8] JUnit XML 导出..."
$PYTHON phase02/scripts/junit_export.py "$RUN_ID" || echo "警告: JUnit 导出无结果，继续生成报告"

# 7. 报告生成 + 门禁判定
#    上游 report_builder.py 只在「用法错误」(2)、「无结果」(1) 时非零退出，
#    GO/BLOCKED/INCONCLUSIVE 一律返回 0 —— 门禁退出码在上游并未实现。
#    这里不改上游文件（会被 sync-cases.sh 覆盖），而是解析它确定性打印的
#    「门禁: <GO|BLOCKED|INCONCLUSIVE>」一行，映射成真正的退出码。
echo "[7/8] 报告生成..."
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

# 8. 发送邮件报告（config.yaml 的 email.enabled 为 false 时由脚本内部跳过）
echo ""
echo "[8/8] 发送邮件报告..."
set +e
$PYTHON phase02/scripts/email_sender.py "$RUN_ID"
EMAIL_CODE=$?
set -e

if [ "$EMAIL_CODE" -eq 0 ]; then
    echo "✅ 邮件发送成功"
else
    echo "⚠️  邮件发送失败，但不影响测试结果"
fi

exit "$GATE_CODE"
