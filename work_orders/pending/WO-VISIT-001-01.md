---
title: "[FEATURE] WO-VISIT-001-01: Create Visit Model Foundation"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: WO-VISIT-001-01 – Create Visit Model Foundation

## 1. Context & Objective

Create the foundational `evv.visit` model with core fields for clock-in/out, service selection, and basic state workflow. This is the core transactional model for electronically verified service delivery events in the EVV system.

**Story:** VISIT-001 - Create Core Visit Record with Service Selection & Notes

---

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** evv  
**GitHub URL:** github.com/HealthRT/evv  
**Target Module:** evv_visits  
**Module Prefix:** evv_*

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /home/james/development/aos-development/evv

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/evv.git

# Step 3: Verify Docker environment exists
ls docker-compose.agent.yml
# Must exist in repository root

# Step 4: Verify module dependencies exist
ls addons/evv_core addons/evv_patients addons/evv_agreements
# All three must exist
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/evv)
- [ ] Confirmed `docker-compose.agent.yml` exists in repository root
- [ ] Confirmed dependency modules exist (evv_core, evv_patients, evv_agreements)
- [ ] Read repository's `README.md` file

### Docker Environment

For automated testing, use the `run-tests.sh` script which handles environment creation and cleanup.

**Database:** postgres

### Git Workflow

**Base Branch:** main  
**New Branch:** feature/WO-VISIT-001-01-visit-model-foundation

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/WO-VISIT-001-01-visit-model-foundation
```

---

## 3. Problem Statement & Technical Details

### Current State
No visit tracking capability exists. DSPs cannot clock in/out or record service delivery events.

### Required Artifact
Create new module `evv_visits` with the foundational `evv.visit` model.

---

## 4. Required Implementation

### A. Module Structure

Create new module:
```
evv/addons/evv_visits/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── evv_visit.py
├── views/
│   └── evv_visit_views.xml
├── security/
│   └── ir.model.access.csv
└── tests/
    ├── __init__.py
    └── test_visit_creation.py
```

### B. `__manifest__.py`

```python
{
    'name': 'EVV Visits',
    'version': '1.0',
    'category': 'Healthcare',
    'summary': 'Core visit record for electronically verified service delivery',
    'depends': ['evv_core', 'evv_patients', 'evv_agreements', 'hr'],
    'data': [
        'security/ir.model.access.csv',
        'views/evv_visit_views.xml',
    ],
    'installable': True,
    'application': False,
}
```

### C. `models/evv_visit.py`

Create `evv.visit` model with the following fields:

**Core Relationship Fields:**
- `patient_id`: Many2one to `evv.patient` (required)
- `dsp_id`: Many2one to `hr.employee` (required)
- `service_agreement_id`: Many2one to `service.agreement` (required)

**Clock-In/Out Fields:**
- `clock_in_timestamp`: Datetime (required)
- `clock_in_location`: Char (optional) - GPS coordinates format: 'LAT,LONG'
- `clock_out_timestamp`: Datetime (optional)
- `clock_out_location`: Char (optional) - GPS coordinates format: 'LAT,LONG'

**State & Notes:**
- `state`: Selection field with values:
  - `'in_progress'` (default)
  - `'pending_verification'`
  - `'pending_correction_approval'`
  - `'verified'`
  - `'rejected'`
- `visit_notes`: Text (optional) - for DSP to add notes at clock-out

**Business Logic Methods:**
- `action_start_verification()`: Changes state from `in_progress` to `pending_verification`
- `action_verify()`: Changes state from `pending_verification` to `verified`
- `action_reject()`: Changes state from any state to `rejected`

**Constraints:**
- SQL constraint: `check_clock_times` - Ensure `clock_out_timestamp` >= `clock_in_timestamp` when both are set
- Python constraint: `_check_active_service_agreement` - Validate that `service_agreement_id` has state='active'

**Name Method:**
```python
def name_get(self):
    result = []
    for visit in self:
        name = f"Visit - {visit.patient_id.name} - {visit.clock_in_timestamp.strftime('%Y-%m-%d %H:%M')}"
        result.append((visit.id, name))
    return result
```

### D. `views/evv_visit_views.xml`

Create views:

**Form View:**
- Header with state and action buttons (`Start Verification`, `Verify`, `Reject`)
- Group 1: Visit Information
  - patient_id, dsp_id, service_agreement_id
- Group 2: Clock-In/Out
  - clock_in_timestamp, clock_in_location
  - clock_out_timestamp, clock_out_location
- Group 3: Notes
  - visit_notes (multiline text widget)

**Tree View:**
- Columns: patient_id, dsp_id, clock_in_timestamp, clock_out_timestamp, state

**Search View:**
- Filter: "My Visits" (domain: `[('dsp_id.user_id', '=', uid)]`)
- Filter: "In Progress" (domain: `[('state', '=', 'in_progress')]`)
- Filter: "Pending Verification" (domain: `[('state', '=', 'pending_verification')]`)
- Group by: state, patient_id, dsp_id

**Menu Items:**
- Main Menu: "EVV Visits"
- Sub-menu: "All Visits"

### E. `security/ir.model.access.csv`

Basic access rules (detailed record rules in WO-VISIT-001-04):
```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_evv_visit_user,evv.visit.user,model_evv_visit,base.group_user,1,1,1,0
access_evv_visit_manager,evv.visit.manager,model_evv_visit,base.group_system,1,1,1,1
```

### F. `tests/test_visit_creation.py`

Comprehensive test suite:

**Test Class:** `TestVisitCreation(TransactionCase)`

**Tests Required:**
1. `test_create_visit_basic()` - Create visit with required fields
2. `test_name_get_format()` - Verify name_get returns correct format
3. `test_clock_out_before_clock_in_fails()` - Test time constraint
4. `test_inactive_service_agreement_fails()` - Test active agreement constraint
5. `test_state_transition_to_pending_verification()` - Test action_start_verification
6. `test_state_transition_to_verified()` - Test action_verify
7. `test_state_transition_to_rejected()` - Test action_reject
8. `test_visit_with_gps_coordinates()` - Test location field storage
9. `test_visit_with_notes()` - Test visit_notes field

**Workflow Test:**
10. `test_workflow_complete_visit()` - Happy path: create → clock out → verify

---

## 5. Acceptance Criteria

### Functional Requirements

**Module Setup:**
- [ ] Module `evv_visits` created with correct structure
- [ ] Dependencies on evv_core, evv_patients, evv_agreements, hr
- [ ] Module installs without errors

**Model:**
- [ ] `evv.visit` model created with all specified fields
- [ ] All field types, requirements, and help text correct
- [ ] SQL constraint prevents clock_out before clock_in
- [ ] Python constraint validates active service agreement
- [ ] `name_get` returns format: "Visit - {patient} - {timestamp}"

**State Workflow:**
- [ ] Default state is 'in_progress'
- [ ] `action_start_verification` changes state correctly
- [ ] `action_verify` changes state correctly
- [ ] `action_reject` changes state correctly

**Views:**
- [ ] Form view displays all fields in logical groups
- [ ] State-based action buttons visible in header
- [ ] Tree view shows key columns
- [ ] Search view with filters and grouping works

**Security:**
- [ ] Basic access rules grant read/write to users
- [ ] Manager role has full access

### Testing Requirements (MANDATORY)

**Unit Tests:**
- [ ] Unit tests written for all new/modified methods
- [ ] Edge cases tested:
  - [ ] Clock-out before clock-in (should fail)
  - [ ] Inactive service agreement (should fail)
  - [ ] Missing required fields (should fail)
  - [ ] GPS coordinate format validation
- [ ] Constraints tested (SQL and Python)
- [ ] State transition methods tested
- [ ] All unit tests pass (0 failed, 0 error(s))

**Workflow Tests (Backend User Journey Tests):**
- [ ] Happy path workflow test (create → clock out → verify)
- [ ] Error path workflow test (invalid times, inactive agreement)
- [ ] Multi-record scenarios tested (multiple visits per DSP)
- [ ] All workflow tests pass (0 failed, 0 error(s))

**Coverage:**
- [ ] Code coverage ≥ 80%
- [ ] All business logic methods covered
- [ ] All constraints covered

**Proof of Execution:**
- [ ] Test output committed showing all tests pass
- [ ] Code committed with descriptive message
- [ ] Proof of execution provided (see Section 9)

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Write the model, views, security files
- **Checkpoint:** Commit working code *before* writing tests. `git commit -m "feat(evv_visits): implement evv.visit model foundation (tests pending)"`

**Phase 2: Testing**
- Write comprehensive tests as per Section 5
- Run tests
- **Checkpoint:** Commit tests, even if they are failing. `git commit -m "test(evv_visits): add tests for visit creation"`

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- Analyze test failures, implement a fix, and run tests again
- If tests pass, proceed to Proof of Execution
- If tests still fail, commit your attempt and proceed to Iteration 2

**Iteration 2:**
- Try a **different approach** to fix the issue. Run tests
- If tests pass, proceed to Proof of Execution
- If tests still fail, **STOP and ESCALATE.**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document your attempts on the GitHub Issue using the standard escalation template, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/VISIT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)
- `@aos-architecture/standards/TESTING_STRATEGY.md` (MANDATORY - for workflow tests)
- `@aos-architecture/decisions/ADR-006-multi-tenancy.md`
- `@aos-architecture/decisions/ADR-007-modular-independence.md`

---

## 8. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**
- **HIPAA Compliance:** This model contains PHI. Follow ADR-006 for multi-tenancy and access control
- **Module Prefix:** Must be `evv_*` per ADR-013
- **Change Size:** Keep diff <500 LOC

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Test Execution (REQUIRED for code changes)
```bash
# Run all tests for your module
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_visits
```

**CRITICAL VERIFICATION CHECKLIST:**

Before proceeding, you MUST verify YOUR tests actually ran:

- [ ] **Check `tests/__init__.py` imports all test modules**
  ```python
  # Example: from . import test_visit_creation
  ```
  
- [ ] **Verify your module appears in test output:**
  ```bash
  grep "odoo.tests.stats: evv_visits" proof_of_execution_tests.log
  ```
  
- [ ] **Confirm test count is correct:**
  - If you wrote 10 tests, verify "10 tests" appears next to your module name
  - "0 failed, 0 errors" with ZERO tests run is NOT acceptable

**If your module doesn't appear in the output:**
- ❌ Your tests didn't run
- Fix `tests/__init__.py` imports
- Re-run tests
- DO NOT proceed until YOUR tests execute

**Provide:** Test output showing YOUR module's tests AND `0 failed, 0 error(s)`.

### 9.2 Boot Verification (REQUIRED)
```bash
# Verify module boots cleanly
cd /home/james/development/aos-development/evv
docker compose up -d
sleep 30
docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming a clean start.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
# Test module upgrade
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u evv_visits --stop-after-init
```
**Provide:** Log output showing a successful upgrade with no errors.

### 9.4 Cleanup Verification
```bash
# Verify no orphaned containers
docker ps -a | grep evv-agent-test
# Must be empty
```
**Provide:** Output showing cleanup succeeded.

