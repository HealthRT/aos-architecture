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

For manual development or inspection, a separate script may be provided. For automated testing, the `run-tests.sh` script handles its own environment creation and cleanup.

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

**Unit Tests:**
- [ ] Unit tests written for all new/modified methods
- [ ] Edge cases tested (empty recordsets, null values, validation failures)
- [ ] Constraints and validations tested
- [ ] All unit tests pass (`0 failed, 0 error(s)`)

**Workflow Tests (Backend User Journey Tests):**
- [ ] Happy path workflow test (complete user journey end-to-end)
- [ ] Error path workflow test (invalid inputs rejected properly)
- [ ] State transition tests (if model has state field)
- [ ] Multi-record scenarios tested (if applicable)
- [ ] All workflow tests pass (`0 failed, 0 error(s)`)

**Example Workflow Test Structure:**
```python
# File: tests/test_<model_name>_workflows.py

@tagged("post_install", "-at_install", "<module_name>", "workflow")
class Test<ModelName>Workflows(TransactionCase):
    """End-to-end workflow tests simulating user activities"""
    
    def test_workflow_happy_path(self):
        """Test: User creates record → performs action → verifies result"""
        # 1. User creates record (simulates filling form)
        record = self.Model.create({...})
        
        # 2. User clicks action button
        record.action_method()
        
        # 3. Verify expected state
        self.assertEqual(record.state, 'expected')
    
    def test_workflow_error_path(self):
        """Test: User tries invalid action → system rejects properly"""
        with self.assertRaises(ValidationError):
            self.Model.create({...})  # Missing required field
```

**Coverage:**
- [ ] Code coverage ≥ 80%
- [ ] Security considerations tested (if applicable)

**Proof of Execution:**
- [ ] Test output committed showing all tests pass
- [ ] Code committed with descriptive message
- [ ] Proof of execution provided (see Section 9)

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
- `@aos-architecture/standards/TESTING_STRATEGY.md` (MANDATORY - for workflow tests)
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
# From within the target repository directory (hub/ or evv/)
bash scripts/run-tests.sh [module_name]
```

**CRITICAL VERIFICATION CHECKLIST:**
- [ ] Tests executed successfully OR
- [ ] Tests failed (expected for validation)
- [ ] Verify `proof_of_execution_tests.log` created
- [ ] **VERIFY CLEANUP:** Run `docker ps -a | grep [repo]-agent-test` → Must be empty

### 9.2 Boot Verification (If Required by Work Order)

If required, follow specific instructions in the work order for manually starting an environment to capture boot logs. This is not part of the standard automated test run.

### 9.3 Module Upgrade Test (If Required by Work Order)

If required, follow specific instructions in the work order for manually starting an environment to capture upgrade logs.
