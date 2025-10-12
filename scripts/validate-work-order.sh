#!/bin/bash
# Work Order Quality Validation Script
# Usage: ./validate-work-order.sh path/to/WO-XXX.md

set -e

WORK_ORDER_FILE="$1"

if [ -z "$WORK_ORDER_FILE" ]; then
    echo "Usage: $0 <work-order-file.md>"
    exit 1
fi

if [ ! -f "$WORK_ORDER_FILE" ]; then
    echo "❌ ERROR: File not found: $WORK_ORDER_FILE"
    exit 1
fi

echo "🔍 Validating work order: $WORK_ORDER_FILE"
echo ""

ERRORS=0

# Check 1: Prohibited testing phrases
echo "Check 1: Prohibited phrases..."
if grep -iE "(tests?\s+(are\s+)?optional|tests?\s+can\s+be\s+added\s+later|bootstrap.*doesn'?t\s+need\s+tests?|testing.*not\s+required)" "$WORK_ORDER_FILE"; then
    echo "❌ FAIL: Prohibited testing phrase found (see above)"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ PASS: No prohibited phrases"
fi
echo ""

# Check 2: Testing Requirements section
echo "Check 2: Testing Requirements section..."
if grep -q "### Testing Requirements (MANDATORY)" "$WORK_ORDER_FILE"; then
    echo "✅ PASS: Testing Requirements section found"
else
    echo "❌ FAIL: Missing '### Testing Requirements (MANDATORY)' section"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 3: Required context document (08-testing-requirements.md)
echo "Check 3: Testing standards reference..."
if grep -q "08-testing-requirements.md" "$WORK_ORDER_FILE"; then
    echo "✅ PASS: Testing standards document referenced"
else
    echo "❌ FAIL: Missing reference to '08-testing-requirements.md'"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 4: Proof of Execution section
echo "Check 4: Proof of Execution section..."
if grep -qE "(##\s+[0-9]+\.\s+.*Proof of Execution|## 9\. MANDATORY Proof of Execution)" "$WORK_ORDER_FILE"; then
    echo "✅ PASS: Proof of Execution section found"
else
    echo "❌ FAIL: Missing Proof of Execution section"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 5: Test execution command
echo "Check 5: Test execution command..."
if grep -q "docker compose exec odoo odoo-bin.*--test-enable" "$WORK_ORDER_FILE"; then
    echo "✅ PASS: Test execution command found"
else
    echo "⚠️  WARNING: No test execution command found (may be acceptable for docs-only work orders)"
fi
echo ""

# Check 6: All required sections present
echo "Check 6: Required sections..."
REQUIRED_SECTIONS=(
    "Context & Objective"
    "Repository Setup"
    "Problem Statement"
    "Required Implementation"
    "Acceptance Criteria"
    "Context Management"
    "Required Context Documents"
    "Technical Constraints"
)

MISSING_SECTIONS=0
for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -qE "##\s+[0-9]+\.\s+$section" "$WORK_ORDER_FILE"; then
        echo "⚠️  WARNING: Section '$section' may be missing or named differently"
        MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
    fi
done

if [ $MISSING_SECTIONS -eq 0 ]; then
    echo "✅ PASS: All required sections found"
else
    echo "⚠️  WARNING: $MISSING_SECTIONS section(s) may be missing (review manually)"
fi
echo ""

# Final verdict
echo "═══════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo "✅ VALIDATION PASSED: Work order meets quality standards"
    echo "═══════════════════════════════════════════"
    exit 0
else
    echo "❌ VALIDATION FAILED: $ERRORS critical error(s) found"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Work order must be corrected before dispatch."
    echo "Review the errors above and regenerate."
    exit 1
fi

