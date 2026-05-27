#!/bin/bash
# Run all base community tests (foundation; no recursion into itself)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Running Base Community Tests ==="
echo "Test directory: ${SCRIPT_DIR}"
echo ""

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
echo "=== Base Community Results ==="
echo "Total: ${TOTAL} | Pass: ${PASS} | Fail: ${FAIL}"

[[ ${FAIL} -eq 0 ]]
