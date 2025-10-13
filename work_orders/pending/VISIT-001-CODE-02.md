---
title: "[FEATURE] VISIT-001-CODE-02: Add MN DHS Compliance Fields & Unit Calculations"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: VISIT-001-CODE-02 – Add MN DHS Compliance Fields & Unit Calculations

## 1. Context & Objective

Extend the `evv.visit` model with Minnesota Department of Human Services (MN DHS) required fields: procedure code capture, unit calculations, and shared service flag. These fields are mandatory for state EVV reporting compliance.

**Story:** VISIT-001 - Create Core Visit Record with Service Selection & Notes  
**Depends On:** VISIT-001-CODE-01 (Visit Model Foundation)

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

# Step 3: Verify module exists (from WO-VISIT-001-01)
ls addons/evv_visits
# Must exist with models/, views/, security/, tests/

# Step 4: Verify WO-VISIT-001-01 merged
git log --oneline | head -10
# Should see commit from WO-VISIT-001-01
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/evv)
- [ ] Confirmed `evv_visits` module exists
- [ ] Confirmed WO-VISIT-001-01 is merged to main
- [ ] Read repository's `README.md` file

### Git Workflow

**Base Branch:** main  
**New Branch:** feature/VISIT-001-CODE-02-mndhs-compliance

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/VISIT-001-CODE-02-mndhs-compliance
```

---

## 3. Problem Statement & Technical Details

### Current State
The `evv.visit` model exists with core clock-in/out fields but lacks MN DHS required compliance fields for state reporting.

### Required Enhancement
Add three MN DHS-mandated fields and implement unit calculation logic.

---

## 4. Required Implementation

### A. Extend `models/evv_visit.py`

Add the following fields to the existing `evv.visit` model:

**MN DHS Compliance Fields:**

```python
# Add after existing fields

# --- MN DHS Compliance Fields ---
is_shared_service = fields.Boolean(
    string="Shared Service",
    default=False,
    help="True if this was a group service. Required by MN DHS."
)

procedure_code = fields.Char(
    string="Procedure Code",
    related='service_agreement_id.procedure_code',
    store=True,
    readonly=True,
    help="A read-only copy of the procedure code from the authorizing service agreement, "
         "captured at the time of visit for historical integrity. Required by MN DHS."
)

calculated_units = fields.Float(
    string="Billable Units",
    digits=(10, 2),
    compute='_compute_calculated_units',
    store=True,
    readonly=True,
    help="The number of billable units, calculated based on the visit duration "
         "and the service's defined unit increment. Required by MN DHS."
)
```

**Computed Method for Units:**

```python
@api.depends('clock_in_timestamp', 'clock_out_timestamp', 'service_agreement_id')
def _compute_calculated_units(self):
    """
    Calculate billable units based on visit duration.
    
    Business Rules (per MN DHS):
    - 1 unit = 15 minutes of service time
    - Duration = clock_out_timestamp - clock_in_timestamp
    - Round up to nearest quarter unit (0.25)
    - Only calculate when both timestamps exist
    
    Examples:
    - 15 min = 1.0 unit
    - 20 min = 1.25 units (rounded up from 1.33)
    - 45 min = 3.0 units
    - 50 min = 3.25 units (rounded up from 3.33)
    """
    for visit in self:
        if visit.clock_in_timestamp and visit.clock_out_timestamp:
            # Calculate duration in minutes
            duration = visit.clock_out_timestamp - visit.clock_in_timestamp
            minutes = duration.total_seconds() / 60.0
            
            # Calculate raw units (1 unit = 15 minutes)
            raw_units = minutes / 15.0
            
            # Round up to nearest 0.25 unit
            import math
            visit.calculated_units = math.ceil(raw_units * 4) / 4.0
        else:
            visit.calculated_units = 0.0
```

**Update `action_start_verification()` method:**

Modify the existing method to recompute units before verification:

```python
def action_start_verification(self):
    """
    Move visit to pending_verification state.
    Triggers unit recalculation per MN DHS requirements.
    """
    self.ensure_one()
    # Force recompute of calculated_units
    self._compute_calculated_units()
    self.state = 'pending_verification'
```

### B. Update `views/evv_visit_views.xml`

Modify the existing form view to include new fields:

**Add to Form View:**

After the Clock-In/Out group, add new group:

```xml
<group name="compliance" string="MN DHS Compliance">
    <field name="is_shared_service"/>
    <field name="procedure_code"/>
    <field name="calculated_units"/>
</group>
```

**Add to Tree View:**

Add column after `clock_out_timestamp`:

```xml
<field name="calculated_units"/>
```

**Add to Search View:**

Add filter:

```xml
<filter name="shared_services" string="Shared Services" 
        domain="[('is_shared_service', '=', True)]"/>
```

### C. Update `tests/test_visit_creation.py`

Add new test class for MN DHS compliance:

```python
@tagged("post_install", "-at_install", "evv_visits", "mndhs_compliance")
class TestMNDHSCompliance(TransactionCase):
    
    def setUp(self):
        super().setUp()
        # Setup test data (patient, dsp, active service agreement)
        self.patient = self.env['evv.patient'].create({...})
        self.dsp = self.env['hr.employee'].create({...})
        self.service_agreement = self.env['service.agreement'].create({
            'procedure_code': 'H2014',
            'state': 'active',
            ...
        })
    
    def test_procedure_code_copied_from_agreement(self):
        """Test that procedure code is stored from service agreement"""
        visit = self.env['evv.visit'].create({
            'patient_id': self.patient.id,
            'dsp_id': self.dsp.id,
            'service_agreement_id': self.service_agreement.id,
            'clock_in_timestamp': fields.Datetime.now(),
        })
        self.assertEqual(visit.procedure_code, 'H2014')
    
    def test_calculate_units_15_minutes(self):
        """Test: 15 minutes = 1.0 unit"""
        visit = self._create_visit_with_duration(minutes=15)
        self.assertEqual(visit.calculated_units, 1.0)
    
    def test_calculate_units_20_minutes(self):
        """Test: 20 minutes = 1.25 units (rounded up)"""
        visit = self._create_visit_with_duration(minutes=20)
        self.assertEqual(visit.calculated_units, 1.25)
    
    def test_calculate_units_45_minutes(self):
        """Test: 45 minutes = 3.0 units"""
        visit = self._create_visit_with_duration(minutes=45)
        self.assertEqual(visit.calculated_units, 3.0)
    
    def test_calculate_units_50_minutes(self):
        """Test: 50 minutes = 3.25 units (rounded up)"""
        visit = self._create_visit_with_duration(minutes=50)
        self.assertEqual(visit.calculated_units, 3.25)
    
    def test_units_zero_without_clock_out(self):
        """Test: Units = 0 when no clock-out timestamp"""
        visit = self.env['evv.visit'].create({
            'patient_id': self.patient.id,
            'dsp_id': self.dsp.id,
            'service_agreement_id': self.service_agreement.id,
            'clock_in_timestamp': fields.Datetime.now(),
            # No clock_out_timestamp
        })
        self.assertEqual(visit.calculated_units, 0.0)
    
    def test_units_recomputed_on_verification(self):
        """Test: Units recalculated when moving to pending_verification"""
        visit = self._create_visit_with_duration(minutes=30)
        initial_units = visit.calculated_units
        self.assertEqual(initial_units, 2.0)
        
        # Change clock_out time
        visit.clock_out_timestamp = visit.clock_in_timestamp + timedelta(minutes=60)
        
        # Trigger verification
        visit.action_start_verification()
        
        # Units should update
        self.assertEqual(visit.calculated_units, 4.0)
    
    def test_shared_service_flag(self):
        """Test: is_shared_service flag can be set"""
        visit = self.env['evv.visit'].create({
            'patient_id': self.patient.id,
            'dsp_id': self.dsp.id,
            'service_agreement_id': self.service_agreement.id,
            'clock_in_timestamp': fields.Datetime.now(),
            'is_shared_service': True,
        })
        self.assertTrue(visit.is_shared_service)
    
    def _create_visit_with_duration(self, minutes):
        """Helper: Create visit with specific duration"""
        clock_in = fields.Datetime.now()
        clock_out = clock_in + timedelta(minutes=minutes)
        return self.env['evv.visit'].create({
            'patient_id': self.patient.id,
            'dsp_id': self.dsp.id,
            'service_agreement_id': self.service_agreement.id,
            'clock_in_timestamp': clock_in,
            'clock_out_timestamp': clock_out,
        })
```

**Workflow Test:**

```python
def test_workflow_visit_with_unit_calculation(self):
    """
    Test: Complete visit workflow with unit calculation
    Simulates: DSP clocks in → works 32 minutes → clocks out → submits for verification
    """
    # Create visit (clock-in)
    clock_in_time = fields.Datetime.now()
    visit = self.env['evv.visit'].create({
        'patient_id': self.patient.id,
        'dsp_id': self.dsp.id,
        'service_agreement_id': self.service_agreement.id,
        'clock_in_timestamp': clock_in_time,
    })
    
    # Verify initial state
    self.assertEqual(visit.state, 'in_progress')
    self.assertEqual(visit.calculated_units, 0.0)
    self.assertEqual(visit.procedure_code, 'H2014')
    
    # Clock out after 32 minutes
    visit.clock_out_timestamp = clock_in_time + timedelta(minutes=32)
    
    # Submit for verification
    visit.action_start_verification()
    
    # Verify state and units
    self.assertEqual(visit.state, 'pending_verification')
    self.assertEqual(visit.calculated_units, 2.25)  # 32 min = 2.133... → rounds to 2.25
```

---

## 5. Acceptance Criteria

### Functional Requirements

**Fields:**
- [ ] `is_shared_service` field added with correct default (False)
- [ ] `procedure_code` field added as related/stored from service_agreement_id
- [ ] `calculated_units` field added as computed/stored

**Unit Calculation Logic:**
- [ ] 15 minutes = 1.0 unit
- [ ] 20 minutes = 1.25 units (rounded up)
- [ ] 45 minutes = 3.0 units
- [ ] 50 minutes = 3.25 units (rounded up)
- [ ] 0 units when clock_out_timestamp missing
- [ ] Units recomputed when `action_start_verification()` called

**Procedure Code:**
- [ ] Procedure code automatically copied from service agreement
- [ ] Stored in visit record (not just related)
- [ ] Read-only field in UI

**Views:**
- [ ] Form view displays compliance fields in dedicated group
- [ ] Tree view includes calculated_units column
- [ ] Search view includes "Shared Services" filter

### Testing Requirements (MANDATORY)

**Unit Tests:**
- [ ] Unit tests written for all new/modified methods
- [ ] Edge cases tested:
  - [ ] Various time durations (15, 20, 32, 45, 50, 60 minutes)
  - [ ] Missing clock-out timestamp
  - [ ] Unit recalculation on verification
  - [ ] Procedure code storage
  - [ ] Shared service flag
- [ ] Computed field logic tested
- [ ] All unit tests pass (0 failed, 0 error(s))

**Workflow Tests (Backend User Journey Tests):**
- [ ] Happy path workflow test (32-minute visit with unit calculation)
- [ ] Error path workflow test (missing timestamps)
- [ ] All workflow tests pass (0 failed, 0 error(s))

**Coverage:**
- [ ] Code coverage ≥ 80%
- [ ] `_compute_calculated_units` method fully covered

**Proof of Execution:**
- [ ] Test output committed showing all tests pass
- [ ] Code committed with descriptive message
- [ ] Proof of execution provided (see Section 9)

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Extend model with MN DHS fields
- Implement unit calculation logic
- Update views
- **Checkpoint:** `git commit -m "feat(evv_visits): add MN DHS compliance fields and unit calculations (tests pending)"`

**Phase 2: Testing**
- Write comprehensive tests as per Section 5
- Run tests
- **Checkpoint:** `git commit -m "test(evv_visits): add tests for MN DHS compliance"`

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
- `@VISIT-001-CODE-01.md` (for context on base implementation)

---

## 8. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**
- **HIPAA Compliance:** This model contains PHI. Maintain all security measures from VISIT-001-CODE-01
- **Backward Compatibility:** Do not break existing visit records or functionality
- **Change Size:** Keep diff <300 LOC

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

- [ ] **Verify your module appears in test output:**
  ```bash
  grep "odoo.tests.stats: evv_visits" proof_of_execution_tests.log
  ```
  
- [ ] **Confirm NEW test count includes your additions:**
  - Base tests from VISIT-001-CODE-01: ~10 tests
  - Your new tests: ~9 tests
  - Total expected: ~19 tests minimum

**Provide:** Test output showing YOUR module's tests AND `0 failed, 0 error(s)`.

### 9.2 Boot Verification
```bash
# This is now handled by the test runner. If boot fails, the test will fail.
# No separate action is needed unless specified for manual inspection.
```

### 9.3 Module Upgrade Test
```bash
# This is now handled by the test runner, which performs a clean install.
# No separate action is needed unless specified for manual inspection.
```

If the `run-tests.sh` script fails, do not attempt to fix it. Escalate immediately.

### 9.4 Cleanup Verification
```bash
docker ps -a | grep evv-agent-test
# Must be empty
```
**Provide:** Output showing cleanup succeeded.

