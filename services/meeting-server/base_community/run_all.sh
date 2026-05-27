#!/bin/bash
# Run base community integration tests (foundation; pytest test_cases.py)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== Running Base Community Tests ==="
echo "Test directory: ${SCRIPT_DIR}"
echo ""
if [[ -f "${SCRIPT_DIR}/test_cases.py" ]]; then
    echo "--- Running pytest test_cases.py ---"
    pytest "${SCRIPT_DIR}/test_cases.py" -v -ra
else
    echo "(base_community 暂无 test_cases.py，本社区无可执行用例)"
fi
