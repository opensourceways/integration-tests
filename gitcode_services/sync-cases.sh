#!/usr/bin/env bash
# sync-cases.sh — 从上游仓同步「执行引擎」到本包（用例默认不动）
#
# 本包是自包含部署单元，但两部分来源不同：
#   引擎  phase02/scripts/*.py  ← 上游 <upstream>/phase02/scripts（派生副本，可覆盖）
#   用例  cases/yaml/*.yaml     ← **本包自有**。实测与上游 phase01 各 run 的文件名交集
#                                 仅 15/249、内容一致 0 条，不是派生副本。
#
# 因此默认只同步引擎。覆盖用例必须显式 `--with-cases --run-id <id> --yes`，
# 否则会静默销毁本包 249 条原创用例。
#
# 用法:
#   ./sync-cases.sh --from /path/to/upstream           # 同步引擎
#   ./sync-cases.sh --check                            # 只检查引擎漂移（CI 用）
#   ./sync-cases.sh --with-cases --run-id <id> --yes   # 额外覆盖用例（危险）
#
# 上游路径解析顺序: --from > $GITCODE_UPSTREAM > ../../gitcode-action-foundational-tests
# 退出码: 0=一致/同步完成, 1=检测到漂移(--check) 或上游/参数错误

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

CHECK_ONLY=0
WITH_CASES=0
CONFIRMED=0
PHASE01_RUN_ID=""
UPSTREAM="${GITCODE_UPSTREAM:-$ROOT_DIR/../../gitcode-action-foundational-tests}"

# 本包独有、上游没有的引擎文件：不参与漂移比对，也不会被同步删除
LOCAL_ONLY_ENGINE=(
    "junit_export.py"      # results/*.json → JUnit XML
    "schema_check_ext.py"  # 按 test_type 分流出 4 条队列
    "api_runner.py"        # api 类执行器
    "api_assertions.py"    # api 类断言判定
    "run_api_batch.py"     # api 类批量编排
    "ui_runner.py"         # ui 类执行器 + 判定（Playwright）
    "run_ui_batch.py"      # ui 类批量编排
    "git_runner.py"        # git 类执行器 + 判定
    "run_git_batch.py"     # git 类批量编排
    "login_helper.py"      # 自动登录获取 Cookie（可选工具）
)

while [ $# -gt 0 ]; do
    case "$1" in
        --check)      CHECK_ONLY=1; shift ;;
        --with-cases) WITH_CASES=1; shift ;;
        --yes)        CONFIRMED=1; shift ;;
        --from)       UPSTREAM="$2"; shift 2 ;;
        --run-id)     PHASE01_RUN_ID="$2"; shift 2 ;;
        *)            echo "未知参数: $1"; exit 1 ;;
    esac
done

if [ ! -d "$UPSTREAM" ]; then
    echo "错误: 上游仓不存在: $UPSTREAM"
    echo "      用 --from <path> 或 GITCODE_UPSTREAM 指定"
    exit 1
fi
UPSTREAM="$(cd "$UPSTREAM" && pwd)"

SRC_ENGINE="$UPSTREAM/phase02/scripts"
DST_ENGINE="phase02/scripts"
DST_CASES="cases/yaml"

if [ ! -d "$SRC_ENGINE" ]; then
    echo "错误: 上游引擎目录不存在: $SRC_ENGINE"
    exit 1
fi

if [ "$WITH_CASES" = "1" ]; then
    if [ -z "$PHASE01_RUN_ID" ]; then
        echo "错误: --with-cases 必须同时给 --run-id <phase01-run-id>（无默认值）"
        echo "      上游可用 run: $(ls "$UPSTREAM/phase01/runs" 2>/dev/null | tr '\n' ' ')"
        exit 1
    fi
    SRC_CASES="$UPSTREAM/phase01/runs/$PHASE01_RUN_ID/cases/yaml"
    if [ ! -d "$SRC_CASES" ]; then
        echo "错误: 上游用例目录不存在: $SRC_CASES"
        exit 1
    fi
fi

is_local_only() {
    for keep in "${LOCAL_ONLY_ENGINE[@]}"; do
        [ "$1" = "$keep" ] && return 0
    done
    return 1
}

# ── 漂移检查 ──────────────────────────────────────────────────────
if [ "$CHECK_ONLY" = "1" ]; then
    DRIFT=0
    report() { echo "  $1"; DRIFT=1; }

    echo "上游: $UPSTREAM"
    echo "检查引擎 $DST_ENGINE ..."
    for f in "$SRC_ENGINE"/*.py; do
        base=$(basename "$f")
        if [ ! -f "$DST_ENGINE/$base" ]; then
            report "引擎缺失: $base"
        elif ! cmp -s "$f" "$DST_ENGINE/$base"; then
            report "引擎内容不同: $base"
        fi
    done
    for f in "$DST_ENGINE"/*.py; do
        base=$(basename "$f")
        is_local_only "$base" && continue
        [ -f "$SRC_ENGINE/$base" ] || report "引擎多余(源已删): $base"
    done

    if [ "$WITH_CASES" = "1" ]; then
        echo "检查用例 $DST_CASES （注意：本包用例本非派生，差异属预期）..."
        for f in "$SRC_CASES"/*.yaml; do
            base=$(basename "$f")
            [ -f "$DST_CASES/$base" ] || report "用例缺失: $base"
        done
    fi

    if [ "$DRIFT" = "0" ]; then
        E=$(find "$DST_ENGINE" -maxdepth 1 -name '*.py' | wc -l | tr -d ' ')
        echo "✓ 引擎与上游一致（$E 个文件，含本包独有 ${#LOCAL_ONLY_ENGINE[@]} 个）"
        exit 0
    fi
    echo "✗ 检测到漂移，请运行: ./sync-cases.sh --from $UPSTREAM"
    exit 1
fi

# ── 同步引擎 ──────────────────────────────────────────────────────
mkdir -p "$DST_ENGINE"
for f in "$DST_ENGINE"/*.py; do
    base=$(basename "$f")
    is_local_only "$base" && continue
    rm -f "$f"
done
cp "$SRC_ENGINE"/*.py "$DST_ENGINE"/
E=$(find "$DST_ENGINE" -maxdepth 1 -name '*.py' | wc -l | tr -d ' ')
echo "✓ 已同步引擎 $E 个文件: $SRC_ENGINE → $DST_ENGINE"
echo "  （本包独有保留: ${LOCAL_ONLY_ENGINE[*]}）"

# ── 同步用例（需显式确认）──────────────────────────────────────────
if [ "$WITH_CASES" = "1" ]; then
    OLD=$(find "$DST_CASES" -maxdepth 1 -name '*.yaml' 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CONFIRMED" != "1" ]; then
        echo ""
        echo "⚠️  --with-cases 将删除本包 $OLD 条自有用例，替换为 $SRC_CASES 的内容。"
        echo "    这两套用例并非同源。确认要覆盖请追加 --yes。已中止，用例未改动。"
        exit 1
    fi
    mkdir -p "$DST_CASES"
    rm -f "$DST_CASES"/*.yaml "$DST_CASES"/*.yml 2>/dev/null || true
    cp "$SRC_CASES"/*.yaml "$DST_CASES"/
    C=$(find "$DST_CASES" -maxdepth 1 -name '*.yaml' | wc -l | tr -d ' ')
    echo "✓ 已覆盖用例: $OLD 条 → $C 条（源: $SRC_CASES）"
fi
