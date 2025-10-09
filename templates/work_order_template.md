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

## 6. Required Context Documents

(A list of files the agent must read before starting.)
- `@aos-architecture/decisions/[ADR_FILE].md`
- `@[ANALYSIS_REPORT].md` (lines [e.g., 374-389])

---

## 7. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS BEFORE HANDOFF.**

1.  **Boot Odoo server:**
    ```bash
    cd /home/james/development/aos-development
    docker compose up -d --force-recreate odoo
    # Allow time for the server to fully start
    sleep 30
    docker compose logs --tail="50" odoo
    ```
2.  **Verify logs show:**
    - "HTTP service (werkzeug) running"
    - "Modules loaded"
    - No Python import errors
    - No other critical errors related to your changes.
3.  **Include the clean log output** in your handoff documentation.

**If Docker is unavailable:** Request access. **DO NOT** skip this step. The Tester AI will **REJECT** your work if proof of execution is missing.
