#!/bin/bash
# Run all openEuler community specific tests (base community first)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")/base_community"

echo "=== Running openEuler Community Tests ==="
echo "Test directory: ${SCRIPT_DIR}"
echo ""

# Step 1: Run base community tests first (guard against self-reference)
if [[ "$BASE_DIR" != "$SCRIPT_DIR" && -d "$BASE_DIR" && -f "${BASE_DIR}/run_all.sh" ]]; then
    echo "--- Step 1: Running base community tests first ---"
    bash "${BASE_DIR}/run_all.sh"
    echo ""
fi

# Step 2: Run openEuler specific tests
PASS=0
FAIL=0
TOTAL=0

for test_file in "${SCRIPT_DIR}"/test_*.sh; do
    [[ -f "$test_file" ]] || continue
    TOTAL=$((TOTAL + 1))
    test_name="$(basename "$test_file")"
    echo "Running: ${test_name}"
    if bash "$test_file"; then
        echo "  PASS"
        PASS=$((PASS + 1))
    else
        echo "  FAIL"
        FAIL=$((FAIL + 1))
    fi
done

echo ""
echo "=== openEuler Specific Results ==="
echo "Total: ${TOTAL} | Pass: ${PASS} | Fail: ${FAIL}"

[[ ${FAIL} -eq 0 ]]
