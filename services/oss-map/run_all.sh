#!/usr/bin/env bash
# 跑 oss-map 模块集成测试（范式 A：pytest + requests，打测试环境）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${SCRIPT_DIR}"

if [[ -f requirements.txt ]]; then
  python3 -m pip install -q -r requirements.txt
fi

echo "=== oss-map integration tests ==="
echo "BASE_URL=${OSS_MAP_BASE_URL:-https://oss-map.test.osinfra.cn}"
echo ""

python3 -m pytest -v test_cases.py "$@"
