#!/bin/bash
# Run openEuler community integration tests (base community first, then pytest)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")/base_community"
echo "=== Running openEuler Community Tests ==="
echo "Test directory: ${SCRIPT_DIR}"
echo ""
# Step 1: base community first (guard against self-reference)
if [[ "$BASE_DIR" != "$SCRIPT_DIR" && -f "${BASE_DIR}/run_all.sh" ]]; then
    echo "--- Step 1: Running base community tests first ---"
    bash "${BASE_DIR}/run_all.sh"
    echo ""
fi
# Step 2: this community's pytest suite (conftest 在无可用服务/凭据时 pytest.skip，不会 FAIL)
if [[ -f "${SCRIPT_DIR}/test_cases.py" ]]; then
    echo "--- Step 2: Running pytest test_cases.py ---"
    pytest "${SCRIPT_DIR}/test_cases.py" -v -ra
else
    echo "(openeuler_community 暂无 test_cases.py)"
fi
