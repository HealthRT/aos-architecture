#!/usr/bin/env bash
#
# Pre-commit hook: Validate spec compliance
#
# This script runs spec-to-implementation validation before commits.
# It warns if mismatches are found but does not block the commit.
#
# To install:
#   cp scripts/pre-commit-spec-validation.sh .git/hooks/pre-commit
#   chmod +x .git/hooks/pre-commit
#
# To skip validation (emergency):
#   git commit --no-verify

set -e

# ANSI color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Running spec compliance validation...${NC}"
echo ""

# Determine repository root
if [ -d "aos-architecture" ]; then
    # Running from workspace root
    AOS_ARCH_DIR="aos-architecture"
elif [ -d "../aos-architecture" ]; then
    # Running from evv or hub directory
    AOS_ARCH_DIR="../aos-architecture"
else
    echo -e "${YELLOW}⚠️  Warning: aos-architecture directory not found${NC}"
    echo -e "${YELLOW}   Skipping spec validation${NC}"
    exit 0
fi

# Check if validation script exists
VALIDATION_SCRIPT="$AOS_ARCH_DIR/scripts/compare-spec-to-implementation.py"
if [ ! -f "$VALIDATION_SCRIPT" ]; then
    echo -e "${YELLOW}⚠️  Warning: Validation script not found${NC}"
    echo -e "${YELLOW}   Expected: $VALIDATION_SCRIPT${NC}"
    echo -e "${YELLOW}   Skipping spec validation${NC}"
    exit 0
fi

# Track validation status
VALIDATION_FAILED=0

# Validate EVV modules
if [ -d "evv/addons/evv_agreements" ] || [ -d "../evv/addons/evv_agreements" ]; then
    echo -e "${BLUE}📋 Validating EVV: AGMT-001 (Service Agreement)${NC}"
    
    if [ -d "evv" ]; then
        EVV_DIR="evv"
    else
        EVV_DIR="../evv"
    fi
    
    if python3 "$VALIDATION_SCRIPT" \
        "$AOS_ARCH_DIR/specs/evv/AGMT-001.yaml" \
        "$EVV_DIR/addons/evv_agreements/models/" > /tmp/spec-validation.log 2>&1; then
        echo -e "${GREEN}   ✅ AGMT-001: Spec compliance verified${NC}"
    else
        echo -e "${RED}   ❌ AGMT-001: Spec compliance issues found${NC}"
        cat /tmp/spec-validation.log
        VALIDATION_FAILED=1
    fi
    echo ""
fi

# Add more validations here as new specs are created

# Report results
if [ $VALIDATION_FAILED -eq 1 ]; then
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}  ⚠️  SPEC COMPLIANCE ISSUES FOUND${NC}"
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Your code does not match the spec definitions.${NC}"
    echo ""
    echo -e "${YELLOW}What to do:${NC}"
    echo "  1. Review the mismatches above"
    echo "  2. If implementation is wrong: Fix code to match spec"
    echo "  3. If spec is wrong: Update spec first, then code"
    echo "  4. Never let spec and code drift apart"
    echo ""
    echo -e "${YELLOW}To commit anyway (not recommended):${NC}"
    echo "  git commit --no-verify"
    echo ""
    echo -e "${RED}═══════════════════════════════════════════════════════════${NC}"
    
    # WARNING only - does not block commit
    # Change to "exit 1" to block commits with mismatches
    exit 0
else
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✅ All spec compliance checks passed${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    exit 0
fi

