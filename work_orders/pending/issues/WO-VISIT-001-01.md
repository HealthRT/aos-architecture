---
title: "[WORK ORDER] WO-VISIT-001-01 – Create Visit Model Foundation"
labels: ["agent:coder", "module:evv-compliance", "priority:high"]
assignee: "aos-coder-agent"
---

# Work Order: WO-VISIT-001-01 – Create Visit Model Foundation

## 📋 Context & Objective

Create the foundational `evv.visit` model with core fields for clock-in/out, service selection, and basic state workflow. This is the core transactional model for electronically verified service delivery events in the EVV system.

**Story:** `VISIT-001` - Create Core Visit Record with Service Selection & Notes

---

## 🎯 Deliverables

### 1. New Module: `evv_visits`
- Complete module structure (models, views, security, tests)
- Dependencies on evv_core, evv_patients, evv_agreements, hr

### 2. `evv.visit` Model
- **Core relationships:** patient_id, dsp_id, service_agreement_id
- **Clock-in/out:** timestamps and GPS locations
- **State workflow:** in_progress → pending_verification → verified/rejected
- **Notes:** visit_notes field for DSP observations

### 3. Business Logic
- `action_start_verification()` - Move to pending verification
- `action_verify()` - Mark as verified
- `action_reject()` - Mark as rejected
- SQL constraint: clock_out >= clock_in
- Python constraint: validate active service agreement

### 4. Views & UI
- Form view with state buttons and field groups
- Tree view with key columns
- Search view with filters (My Visits, In Progress, etc.)

### 5. Security
- Basic access rules (user/manager roles)

### 6. Comprehensive Tests
- 10+ unit tests covering all methods and constraints
- Workflow test: complete visit creation → verification

---

## ✅ Acceptance Criteria

**Module:**
- [ ] `evv_visits` module installs without errors
- [ ] All dependencies declared correctly

**Model:**
- [ ] All fields created with correct types and requirements
- [ ] SQL constraint prevents invalid clock times
- [ ] Python constraint validates active agreements
- [ ] `name_get` returns: "Visit - {patient} - {timestamp}"

**Workflow:**
- [ ] Default state is 'in_progress'
- [ ] All state transition methods work correctly
- [ ] State-based buttons visible in form view

**Tests:**
- [ ] 10+ tests written and passing (0 failed, 0 errors)
- [ ] Unit tests cover all methods and constraints
- [ ] Workflow test covers happy path
- [ ] Test coverage ≥ 80%

**Security:**
- [ ] Access rules grant appropriate permissions
- [ ] PHI fields properly controlled

---

## 🧪 Testing Requirements

**Unit Tests Required:**
- Visit creation with required fields
- name_get format verification
- Clock-out before clock-in validation
- Inactive service agreement validation
- State transition methods (3 tests)
- GPS coordinate storage
- Visit notes field
- Workflow test (complete visit)

**Proof of Execution:**
```bash
bash scripts/run-tests.sh evv_visits
# Verify: evv_visits appears in test stats
# Verify: 10+ tests, 0 failed, 0 errors
```

---

## 📚 Required Context

- `@aos-architecture/specs/evv/VISIT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/TESTING_STRATEGY.md`
- `@aos-architecture/decisions/ADR-006-multi-tenancy.md`

---

## 🔧 Technical Constraints

- **Repository:** HealthRT/evv
- **Base Branch:** main
- **New Branch:** `feature/WO-VISIT-001-01-visit-model-foundation`
- **Odoo Version:** 18.0 Community Edition
- **HIPAA:** This model contains PHI - follow ADR-006
- **Change Size:** <500 LOC

---

## 📝 Proof of Execution Checklist

When complete, post to this issue:

- [ ] Test execution output (evv_visits: X tests, 0 failed)
- [ ] Boot verification (clean logs)
- [ ] Module upgrade test (successful)
- [ ] Cleanup verification (no orphaned containers)
- [ ] Link to Pull Request

---

**Full Work Order:** `@aos-architecture/work_orders/pending/WO-VISIT-001-01.md`

