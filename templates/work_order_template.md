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

### Functional Requirements
- [ ] Requirement 1 is met.
- [ ] Requirement 2 is met.

### Testing Requirements (MANDATORY - See Section 8)
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
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo --test-enable --stop-after-init -i [module_name] --log-level=test
```
**Provide:** Full test output showing `0 failed, 0 error(s)`.

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
