---
title: "[FEATURE] VISIT-001-CODE-02: Add MN DHS Compliance Fields & Unit Calculations"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: VISIT-001-CODE-02

**Repository:** HealthRT/evv  
**Story:** VISIT-001 - Create Core Visit Record with Service Selection & Notes  
**Depends On:** VISIT-001-CODE-01 (Visit Model Foundation)

### Objective
Extend the `evv.visit` model with Minnesota Department of Human Services (MN DHS) required fields: procedure code capture, unit calculations, and shared service flag. These fields are mandatory for state EVV reporting compliance.

### Branch
`feature/VISIT-001-CODE-02-mndhs-compliance`

### Key Deliverables
- [ ] `is_shared_service` field added with correct default (False)
- [ ] `procedure_code` field added as related/stored from service_agreement_id
- [ ] `calculated_units` field added as computed/stored
- [ ] 15 minutes = 1.0 unit
- [ ] 20 minutes = 1.25 units (rounded up)
- [ ] 45 minutes = 3.0 units
- [ ] 50 minutes = 3.25 units (rounded up)
- [ ] 0 units when clock_out_timestamp missing
- [ ] Units recomputed when `action_start_verification()` called
- [ ] Procedure code automatically copied from service agreement
- [ ] Stored in visit record (not just related)
- [ ] Read-only field in UI
- [ ] Form view displays compliance fields in dedicated group
- [ ] Tree view includes calculated_units column
- [ ] Search view includes "Shared Services" filter
- [ ] All unit tests pass (0 failed, 0 error(s))
- [ ] All workflow tests pass (0 failed, 0 error(s))
- [ ] Code coverage ≥ 80%
- [ ] `_compute_calculated_units` method fully covered

### Reference
Full work order: `aos-architecture/work_orders/pending/VISIT-001-CODE-02.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
