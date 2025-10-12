---
title: "[TYPE] WORK_ORDER_ID: Brief Title"
repo: "[e.g., HealthRT/hub or HealthRT/evv]"
assignee: "[e.g., aos-coder-agent]"
labels: "agent:[agent-type],type:[work-type],module:[module-name],priority:[high|medium|low]"
---
# Work Order: [WORK_ORDER_ID] - [BRIEF_TITLE]

## 1. Context & Objective

(Brief, one-sentence summary of the goal. e.g., "The API-first service layer includes event broadcasting that uses an incorrect Odoo API and will fail at runtime.")

---

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** [hub | evv]
**GitHub URL:** [github.com/HealthRT/hub | github.com/HealthRT/evv]
**Target Module:** [module_name]
**Module Prefix:** [hub_* | evv_* | traction*]

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /path/to/[hub | evv]/

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/[hub|evv].git

# Step 3: Verify Docker environment exists
ls docker-compose.yml
# Must exist in repository root

# Step 4: Verify module prefix matches repository
# For Hub: module must be hub_* or traction*
# For EVV: module must be evv_*
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/[hub|evv])
- [ ] Confirmed `docker-compose.yml` exists in repository root
- [ ] Confirmed module prefix matches repository per ADR-013
- [ ] Read repository's `README.md` file

### Docker Environment

**Start Command:**
```bash
cd [repository_path]/
docker compose up -d
```

**Access URL:**
- Hub: `http://localhost:8090`
- EVV: `http://localhost:8091`

**Database:** postgres

### Git Workflow

**Base Branch:** [e.g., `main` or `feature/previous-task`]
**New Branch:** [e.g., `feature/WO-XXX-description`]

**Branch Naming Convention (ADR-014):**
```
feature/WO-{ID}-{short-description}
bugfix/ISSUE-{NUM}-{short-description}
docs/WO-{ID}-{short-description}
```

**Setup Commands:**
```bash
# After verifying you're in the correct repository
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

⚠️ **CRITICAL WARNING - READ THIS FIRST** ⚠️

**Testing is NEVER optional for ANY work order involving code changes.**

❌ **PROHIBITED PHRASES - DO NOT USE:**
- "tests optional"
- "tests can be added later"  
- "bootstrap work doesn't need tests"
- "testing not required"

✅ **REQUIRED:** Unit tests for ALL code changes with 0 failures.

If you are creating a work order and considering making tests optional, **STOP**. Re-read `@aos-architecture/standards/08-testing-requirements.md` and understand why this is non-negotiable.

---

(A clear, testable checklist of what "done" looks like.)

### Functional Requirements
- [ ] Requirement 1 is met.
- [ ] Requirement 2 is met.

### Testing Requirements (MANDATORY)
- [ ] Unit tests are written for all new/modified methods.
- [ ] All tests pass (`0 failed, 0 error(s)`).
- [ ] Code is committed with a descriptive message.
- [ ] Proof of execution (including test output) is provided.

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Write the code per requirements.
- **Checkpoint:** Commit working code *before* writing tests. `git commit -m "feat: implement [feature] (tests pending)"`

**Phase 2: Testing**
- Write comprehensive tests as per `08-testing-requirements.md`.
- Run tests.
- **Checkpoint:** Commit tests, even if they are failing. `git commit -m "test: add tests for [feature]"`

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- Analyze test failures, implement a fix, and run tests again.
- If tests pass, proceed to Proof of Execution.
- If tests still fail, commit your attempt and proceed to Iteration 2.

**Iteration 2:**
- Try a **different approach** to fix the issue. Run tests.
- If tests pass, proceed to Proof of Execution.
- If tests still fail, **STOP and ESCALATE.**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document your attempts on the GitHub Issue using the standard escalation template, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

(A list of files the agent must read before starting.)
- `@aos-architecture/decisions/[ADR_FILE].md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)
- `@[ANALYSIS_REPORT].md` (lines [e.g., 374-389])

---

## 8. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**.
- **Prohibited Features:** Do not use deprecated fields/APIs or any features exclusive to Odoo Enterprise.

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Test Execution (REQUIRED for code changes)
```bash
# Run all tests for your module
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo --test-enable --stop-after-init -i [module_name] --log-level=test 2>&1 | tee proof_of_execution_tests.log
```

**CRITICAL VERIFICATION CHECKLIST:**

Before proceeding, you MUST verify YOUR tests actually ran:

- [ ] **Check `tests/__init__.py` imports all test modules**
  ```python
  # Example: from . import test_model_name, test_other
  ```
  
- [ ] **Verify your module appears in test output:**
  ```bash
  grep "odoo.tests.stats: [your_module_name]" proof_of_execution_tests.log
  ```
  
- [ ] **Confirm test count is correct:**
  - If you wrote 7 tests, verify "7 tests" appears next to your module name
  - "0 failed, 0 errors" with ZERO tests run is NOT acceptable

**If your module doesn't appear in the output:**
- ❌ Your tests didn't run
- Fix `tests/__init__.py` imports
- Re-run tests
- DO NOT proceed until YOUR tests execute

**Provide:** Test output showing YOUR module's tests AND `0 failed, 0 error(s)`.

### 9.2 Boot Verification (REQUIRED)
```bash
# Boot Odoo server
docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming a clean start.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
# Test module upgrade
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u [module_name] --stop-after-init
```
**Provide:** Log output showing a successful upgrade with no errors.
