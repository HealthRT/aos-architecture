# Work Order: SYSTEM-006-DOC-01

**Story:** SYSTEM-006 - Document Test Infrastructure  
**Type:** Documentation (DOC)  
**Priority:** LOW (Non-critical, probationary task)  
**Repository:** `HealthRT/evv`  
**Assigned To:** CODER_AGENT_B (Probationary Assignment)  
**Status:** PENDING

---

## Objective

Add a "Testing Infrastructure" section to the EVV repository README that documents the automated test runner script and provides clear usage examples for developers.

---

## Context

The `evv/scripts/run-tests.sh` script is a critical piece of testing infrastructure that has been hardened through multiple iterations. However, it is not documented in the main README, making it difficult for new developers to discover and use correctly.

This is a **probationary task** designed to verify process adherence, not technical complexity.

---

## Requirements

### 1. Add New Section to README

Add a new section titled "## 🧪 Testing Infrastructure" to `evv/README.md` after the "Development Workflow" section (around line 143).

### 2. Required Content

The new section must include:

1. **Purpose Statement:**
   - Brief explanation that `run-tests.sh` provides isolated, automated module testing
   - Emphasize guaranteed cleanup (no leftover containers)

2. **Usage Example:**
   ```bash
   # Test a specific module
   bash scripts/run-tests.sh evv_core
   ```

3. **What It Does:**
   - Creates isolated Docker environment
   - Installs target module and dependencies
   - Runs module tests with automatic scoping
   - Cleans up containers/networks automatically
   - Generates proof-of-execution logs

4. **Expected Output:**
   - Sample of success pattern showing "0 failed, 0 error(s)"
   - Location of generated logs (`proof_of_execution_*.log` files)

5. **Troubleshooting:**
   - Port conflict resolution (script auto-finds ports 8090-8100)
   - How to check for leftover containers

### 3. Formatting Requirements

- Use proper markdown formatting (headers, code blocks, lists)
- Match the style and tone of existing README sections
- Keep it concise (target: 30-50 lines total)
- Use emoji icons consistent with other sections (🧪 for testing)

---

## Acceptance Criteria

- [ ] New "## 🧪 Testing Infrastructure" section added to README
- [ ] Section appears after "Development Workflow" section
- [ ] Contains all 5 required subsections (Purpose, Usage, What It Does, Expected Output, Troubleshooting)
- [ ] Code blocks use proper bash syntax highlighting
- [ ] Formatting is consistent with existing README style
- [ ] Content is accurate and helpful for new developers
- [ ] No spelling or grammatical errors

---

## Process Requirements (CRITICAL)

This is a probationary assignment. **Process adherence is more important than technical complexity.**

### Mandatory Process Steps:

1. **Branch Creation:**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/SYSTEM-006-DOC-01-test-infrastructure-docs
   ```

2. **Work Execution:**
   - Read the existing `evv/scripts/run-tests.sh` to understand what it does
   - Read the existing README to match style and tone
   - Add the new section in the correct location
   - Verify formatting with a markdown preview

3. **Commit:**
   ```bash
   git add README.md
   git commit -m "docs: add Testing Infrastructure section to README

   - Document run-tests.sh usage and purpose
   - Add usage examples and expected output
   - Include troubleshooting guidance
   - Improves developer onboarding

   Work-Order: SYSTEM-006-DOC-01"
   ```

4. **Push to GitHub:**
   ```bash
   git push origin feature/SYSTEM-006-DOC-01-test-infrastructure-docs
   ```

5. **Visual Verification (MANDATORY):**
   - Navigate to: `https://github.com/HealthRT/evv/tree/feature/SYSTEM-006-DOC-01-test-infrastructure-docs`
   - Visually confirm your changes are present
   - Verify commit message is correct
   - Confirm branch name matches exactly

6. **Completion Report:**
   - Use Address Header Protocol (FROM/TO/MSG_ID headers)
   - Provide the exact GitHub branch URL
   - State: "I have visually verified the branch on GitHub"
   - No false completion reports

---

## Technical Constraints

- **File to Modify:** `evv/README.md` ONLY
- **No Code Changes:** This is documentation only
- **No Script Modifications:** Do not modify `run-tests.sh`
- **Insertion Point:** After line 143 (after "Development Workflow" section)
- **Repository:** `HealthRT/evv`

---

## Estimated Effort

- **Time:** 15-20 minutes
- **Complexity:** LOW
- **Risk:** MINIMAL

---

## Success Criteria

This task will be evaluated **100% on process adherence**, including:

1. ✅ Correct branch naming convention
2. ✅ Clean, well-formatted commit message
3. ✅ Branch successfully pushed to GitHub
4. ✅ Visual verification completed
5. ✅ Accurate completion report with GitHub URL
6. ✅ Address Header Protocol followed

Technical quality of documentation is secondary to process execution.

---

## Notes

- This is a **probationary task** for Coder Agent B
- The goal is to rebuild reliability and trust through consistent process execution
- Future assignments depend on successful completion of this task
- Take your time, follow every step, verify your work

---

**Created:** 2025-10-13  
**Last Updated:** 2025-10-13


