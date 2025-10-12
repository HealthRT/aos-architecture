#!/usr/bin/env bash
#
# validate-module-placement.sh
# 
# Pre-commit hook to enforce ADR-013 (Repository Boundaries & Module Placement)
#
# This script validates that Odoo modules are placed in the correct repository
# according to their naming prefix:
#   - evv_* modules MUST be in the EVV repository
#   - hub_* and traction* modules MUST be in the Hub repository
#
# Usage:
#   1. Copy this script to .git/hooks/pre-commit in target repository
#   2. Make executable: chmod +x .git/hooks/pre-commit
#   3. Script runs automatically before every commit
#
# Exit codes:
#   0 = Validation passed
#   1 = Validation failed (module in wrong repository)
#
# Related: ADR-013, Process Improvement Entry #009

set -e

# ANSI color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Determine which repository we're in
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "unknown")

if [[ "$REPO_URL" == *"hub.git"* ]] || [[ "$REPO_URL" == *"hub"* ]]; then
    REPO_NAME="hub"
elif [[ "$REPO_URL" == *"evv.git"* ]] || [[ "$REPO_URL" == *"evv"* ]]; then
    REPO_NAME="evv"
else
    echo -e "${YELLOW}⚠️  WARNING: Cannot determine repository (Hub or EVV)${NC}"
    echo "   Git remote: $REPO_URL"
    echo "   Skipping module placement validation."
    exit 0
fi

echo -e "${GREEN}🔍 Validating module placement for $REPO_NAME repository...${NC}"

# Get list of staged files that are being committed
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Flag to track if violations found
VIOLATIONS_FOUND=0

# Check each staged file
while IFS= read -r FILE; do
    # Only check files in addons/ directory
    if [[ "$FILE" == addons/* ]]; then
        # Extract module name (first directory under addons/)
        MODULE_NAME=$(echo "$FILE" | cut -d'/' -f2)
        
        # Skip if not a valid module directory
        [[ -z "$MODULE_NAME" ]] && continue
        
        # Apply validation rules based on repository
        if [[ "$REPO_NAME" == "hub" ]]; then
            # Hub repository: REJECT evv_* modules
            if [[ "$MODULE_NAME" == evv_* ]]; then
                echo -e "${RED}❌ VIOLATION: EVV module detected in Hub repository${NC}"
                echo "   File: $FILE"
                echo "   Module: $MODULE_NAME"
                echo "   Rule: EVV modules (evv_*) belong in the EVV repository only"
                echo "   See: ADR-013 (Repository Boundaries)"
                echo ""
                VIOLATIONS_FOUND=1
            fi
        elif [[ "$REPO_NAME" == "evv" ]]; then
            # EVV repository: REJECT hub_* and traction* modules
            if [[ "$MODULE_NAME" == hub_* ]] || [[ "$MODULE_NAME" == traction* ]]; then
                echo -e "${RED}❌ VIOLATION: Hub module detected in EVV repository${NC}"
                echo "   File: $FILE"
                echo "   Module: $MODULE_NAME"
                echo "   Rule: Hub modules (hub_*, traction*) belong in the Hub repository only"
                echo "   See: ADR-013 (Repository Boundaries)"
                echo ""
                VIOLATIONS_FOUND=1
            fi
        fi
    fi
done <<< "$STAGED_FILES"

# Report results
if [[ $VIOLATIONS_FOUND -eq 1 ]]; then
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}  COMMIT REJECTED: Module placement violations detected${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Repository boundaries are defined in ADR-013:"
    echo ""
    echo "  Hub Repository (github.com/HealthRT/hub):"
    echo "    ✅ Allowed: hub_*, traction*"
    echo "    ❌ Prohibited: evv_*"
    echo ""
    echo "  EVV Repository (github.com/HealthRT/evv):"
    echo "    ✅ Allowed: evv_*"
    echo "    ❌ Prohibited: hub_*, traction*"
    echo ""
    echo "To fix:"
    echo "  1. Move the module to the correct repository"
    echo "  2. Remove it from this repository: git rm -r addons/[module_name]"
    echo "  3. Commit the removal"
    echo ""
    echo "If you believe this is a false positive, contact the architect."
    echo ""
    exit 1
else
    echo -e "${GREEN}✅ Module placement validation passed${NC}"
    echo ""
    exit 0
fi

