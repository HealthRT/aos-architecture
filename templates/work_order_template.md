# Work Order: [WORK_ORDER_ID] - [BRIEF_TITLE]

## 1. Context & Objective

(Brief, one-sentence summary of the goal. e.g., "The API-first service layer includes event broadcasting that uses an incorrect Odoo API and will fail at runtime.")

---

## 2. Repository Setup

**Repository:** [hub | evv]
**Base Branch:** [e.g., `main` or `feature/previous-task`]
**New Branch:** [e.g., `feature/WORK_ORDER_ID-description`]

**Setup Commands:**
```bash
# Ensure you are in the correct repository before running
git checkout [Base Branch]
git checkout -b [New Branch]
```
**Note:** (Optional: Any critical information about the state of the repository, e.g., "The `main` branch does not yet contain the module source code. Service files were added in TRAC-REFACTOR-003.")

---

## 3. Problem Statement & Technical Details

(This section should contain the specific file paths, line numbers, and code snippets that need to be addressed.)

### [File 1 Path] (e.g., `hub/addons/traction_eos_odoo/services/meeting_service.py`)
**Lines:** (e.g., 37-39)
**Current Code (BROKEN):**
```python
# Paste the exact, incorrect code snippet here
```
**Issue:** (e.g., "`_sendone()` method doesn't exist in Odoo 18.")

### [File 2 Path]
**(Repeat as necessary)**

---

## 4. Required Implementation

(This section should provide a clear, technical specification for the solution.)

### [Requirement 1] (e.g., Use Correct Odoo 18 API)
```python
# Provide the correct code snippet or pattern here
self.env["bus.bus"]._sendmany([
    (channel: str, event_type: str, data: dict)
])
```

### [Requirement 2] (e.g., Add Extension Hooks)
(Describe the pattern or specific methods to be created.)

### [Requirement 3] (e.g., Enhance Event Data)
(List the required data fields for any new data structures.)

---

## 5. Acceptance Criteria

(A clear, testable checklist of what "done" looks like.)
- [ ] Requirement 1 is met.
- [ ] Requirement 2 is met.
- [ ] Code is committed with a descriptive message.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs are captured.

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Write the code per requirements
- **Checkpoint:** Commit working code (even before tests)
  ```bash
  git add .
  git commit -m "feat: implement [feature] (tests pending)"
  ```

**Phase 2: Testing**
- Write comprehensive tests (see `08-testing-requirements.md`)
- Run tests
- **Checkpoint:** Commit tests (even if failing)
  ```bash
  git add tests/
  git commit -m "test: add tests for [feature] (2 failing)"
  ```

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- Analyze test failures carefully
- Implement fix
- Run tests again
- ✅ Tests pass? → **DONE!** Proceed to Proof of Execution
- ❌ Tests still fail? → Commit attempt and continue to Iteration 2

**Iteration 2:**
- Try a **different approach** (not same fix again)
- Run tests
- ✅ Tests pass? → **DONE!** Proceed to Proof of Execution
- ❌ Tests still fail? → **STOP! ESCALATE!**

### Escalation Process (After 2 Failed Iterations)

**DO NOT continue debugging beyond 2 iterations.** Instead:

1. **Document your attempts on GitHub Issue:**
   ```markdown
   ## 🚨 Need Help: Tests Failing After 2 Attempts
   
   ### What I Built
   - Implemented X in file Y
   - Wrote tests A, B, C
   
   ### Current Problem
   Tests `test_B` and `test_C` are failing with:
   ```
   [Error message and stack trace]
   ```
   
   ### What I Tried
   
   **Attempt 1:**
   - Changed line 42 from X to Y
   - Reasoning: Thought it was a null pointer
   - Result: Same error
   - Commit: abc123
   
   **Attempt 2:**
   - Added try/except block
   - Reasoning: Catch the error
   - Result: Tests pass but code is hacky
   - Commit: def456
   
   ### My Hypothesis
   I think the issue is [explain root cause theory].
   Might need to check ADR-006 for the proper pattern.
   
   ### Files Affected
   - services/my_service.py
   - tests/test_my_service.py
   
   ### Branch
   feature/issue-X-implementation
   ```

2. **Add label:** `status:needs-help`

3. **Tag reviewer:** `@reviewer-name` or `@james-healthrt`

4. **STOP working** (don't waste more context on guessing)

### Signs You're Hitting Context Limits

**Stop immediately if you notice:**
- ❌ You're trying the same solution you already tried
- ❌ You can't remember what you tried 10 minutes ago
- ❌ You're making changes that undo your earlier fixes
- ❌ You're getting confused about what the code does
- ❌ Your responses are becoming incoherent

**→ If any of these: Document and ESCALATE**

### Context Budget Guidelines

Aim to keep each phase under these limits:
- Implementation: ~30% of your context
- Testing: ~30% of your context
- Debugging: ~30% of your context
- Buffer: ~10% reserve

**If you're over 70% context used and tests still failing: ESCALATE**

---

## 7. Required Context Documents

(A list of files the agent must read before starting.)
- `@aos-architecture/decisions/[ADR_FILE].md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)
- `@[ANALYSIS_REPORT].md` (lines [e.g., 374-389])

---

## 7. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**.
- **Prohibited Features:** Do not use deprecated fields/APIs or any features exclusive to Odoo Enterprise.

---

## 8. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS BEFORE HANDOFF.**

### 8.1 Test Execution (REQUIRED for code changes)

```bash
# Run all tests for your module
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --test-enable \
  --stop-after-init \
  -i [module_name] \
  --log-level=test:INFO
```

**Provide in handoff comment:**
- Full test output showing `0 failed, 0 error(s)`
- Number of tests run (e.g., "7 tests, 0.34s")
- Any warnings (explain if not critical)

**Example:**
```
traction_eos_odoo: 9 tests 0.27s 421 queries
0 failed, 0 error(s) of 9 tests
```

### 8.2 Boot Verification (REQUIRED)

```bash
# Boot Odoo server
cd /home/james/development/aos-development
docker compose up -d --force-recreate odoo
sleep 30
docker compose logs --tail="100" odoo
```

**Verify logs show:**
- "HTTP service (werkzeug) running"
- "Modules loaded"
- "Registry loaded in X.XXs"
- No Python import errors
- No critical errors related to your changes

**Provide:** Last 50-100 lines of boot log in handoff comment

### 8.3 Module Upgrade Test (REQUIRED)

```bash
# Test module upgrade (simulates production deployment)
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  -u [module_name] \
  --stop-after-init
```

**Verify:** No errors during upgrade

---

**If Docker is unavailable:** Request access immediately. **DO NOT** skip this step.

**Remember:** Proof of execution is not optional. Your work will be rejected without it.
