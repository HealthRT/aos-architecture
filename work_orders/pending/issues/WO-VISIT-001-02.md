---
title: "[WORK ORDER] WO-VISIT-001-02 – Add MN DHS Compliance Fields & Unit Calculations"
labels: ["agent:coder", "module:evv-compliance", "priority:high"]
assignee: "aos-coder-agent"
---

# Work Order: WO-VISIT-001-02 – Add MN DHS Compliance Fields & Unit Calculations

## 📋 Context & Objective

Extend the `evv.visit` model with Minnesota Department of Human Services (MN DHS) required fields: procedure code capture, unit calculations, and shared service flag. These fields are mandatory for state EVV reporting compliance.

**Story:** `VISIT-001` - Create Core Visit Record with Service Selection & Notes  
**Depends On:** WO-VISIT-001-01 (Visit Model Foundation)

---

## 🎯 Deliverables

### 1. MN DHS Compliance Fields
- `is_shared_service`: Boolean flag for group services
- `procedure_code`: Stored copy from service agreement
- `calculated_units`: Computed billable units

### 2. Unit Calculation Logic
- Formula: 1 unit = 15 minutes
- Round up to nearest 0.25 unit
- Recompute on verification

### 3. Enhanced Views
- Compliance fields group in form view
- calculated_units column in tree view
- "Shared Services" filter in search view

### 4. Comprehensive Tests
- 9+ tests for unit calculations (various durations)
- Procedure code storage test
- Unit recalculation workflow test

---

## ✅ Acceptance Criteria

**Fields:**
- [ ] `is_shared_service` field with default False
- [ ] `procedure_code` related/stored from agreement
- [ ] `calculated_units` computed/stored correctly

**Unit Calculation:**
- [ ] 15 min = 1.0 unit
- [ ] 20 min = 1.25 units (rounded up)
- [ ] 32 min = 2.25 units
- [ ] 45 min = 3.0 units
- [ ] 50 min = 3.25 units
- [ ] 0 units when clock_out missing
- [ ] Recomputed on `action_start_verification()`

**Views:**
- [ ] Compliance fields group in form
- [ ] calculated_units in tree view
- [ ] Shared services filter works

**Tests:**
- [ ] 9+ new tests passing (0 failed, 0 errors)
- [ ] All unit calculation scenarios covered
- [ ] Workflow test with 32-minute visit
- [ ] Total test count: ~19 tests (10 from WO-01 + 9 new)

---

## 🧪 Testing Requirements

**Unit Tests Required:**
- Procedure code copied from agreement
- Unit calculations for: 15, 20, 32, 45, 50, 60 minutes
- Units = 0 when clock_out missing
- Units recomputed on verification
- Shared service flag test
- Workflow test (32-minute visit)

**Proof of Execution:**
```bash
bash scripts/run-tests.sh evv_visits
# Verify: evv_visits appears in test stats
# Verify: ~19 tests, 0 failed, 0 errors
```

---

## 📚 Required Context

- `@aos-architecture/specs/evv/VISIT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/TESTING_STRATEGY.md`
- `@WO-VISIT-001-01.md` (for base context)

---

## 🔧 Technical Constraints

- **Repository:** HealthRT/evv
- **Base Branch:** main
- **New Branch:** `feature/WO-VISIT-001-02-mndhs-compliance`
- **Odoo Version:** 18.0 Community Edition
- **Depends On:** WO-VISIT-001-01 must be merged
- **Change Size:** <300 LOC

---

## 📝 Proof of Execution Checklist

When complete, post to this issue:

- [ ] Test execution output (~19 tests, 0 failed)
- [ ] Boot verification (clean logs)
- [ ] Module upgrade test (successful)
- [ ] Cleanup verification (no orphaned containers)
- [ ] Link to Pull Request

---

**Full Work Order:** `@aos-architecture/work_orders/pending/WO-VISIT-001-02.md`

