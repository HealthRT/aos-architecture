# Work Order: SYSTEM-005-FIX-03

**Project:** Agency Operating System (AOS) - EVV Subsystem
**Story:** SYSTEM-005: Stabilize Core EVV Module Test Suites
**Type:** `FIX` (Critical Remediation)

---

## 1. Objective

**CRITICAL: Fix all failing tests in the `evv_case_managers` module.**

The `evv_case_managers` module has failing tests that contaminate downstream module testing. Your objective is to investigate these failures and remediate them until the test suite passes cleanly with `0 failed, 0 error(s)`.

**THIS IS THE HIGHEST PRIORITY TASK IN THE EVV REPOSITORY.**

---

## 2. Context

**Problem:** Wave 2 foundational modules have unstable test suites
**Impact:** Blocks all downstream development (Wave 3, Wave 4)
**Root Cause:** Tests failing in core modules contaminate dependency installation

**Your task:** Fix the `evv_case_managers` test suite so it passes cleanly.

---

## 3. Requirements

### 3.1. Investigation

Run the test suite for `evv_case_managers`:
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/SYSTEM-005-FIX-03-evv-case-managers-tests
bash scripts/run-tests.sh evv_case_managers
```

Review the test output and identify all failures.

### 3.2. Remediation

**Fix ONLY existing tests within `evv_case_managers`.** Do NOT:
- Add new features
- Add new tests
- Modify other modules
- Modify `run-tests.sh`

**Focus:** Make existing tests pass.

### 3.3. Verification

After fixing:
```bash
bash scripts/run-tests.sh evv_case_managers
```

**Required Result:** `0 failed, 0 error(s)`

---

## 4. Acceptance Criteria

- AC-1: All `evv_case_managers` tests pass
- AC-2: Test log shows `0 failed, 0 error(s)`
- AC-3: No new features or tests added
- AC-4: Only `evv_case_managers` module files modified

---

## 5. Submission

1. Commit fixes
2. Commit proof logs showing clean test results
3. Push branch: `feature/SYSTEM-005-FIX-03-evv-case-managers-tests`
4. Report completion with GitHub URL

