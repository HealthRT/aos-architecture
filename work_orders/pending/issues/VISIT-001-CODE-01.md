---
title: "[FEATURE] VISIT-001-CODE-01: Create Visit Model Foundation"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: VISIT-001-CODE-01

**Repository:** HealthRT/evv  
**Story:** VISIT-001 - Create Core Visit Record with Service Selection & Notes

### Objective
Create the foundational `evv.visit` model with core fields for clock-in/out, service selection, and basic state workflow. This is the core transactional model for electronically verified service delivery events in the EVV system.

### Branch
`feature/VISIT-001-CODE-01-visit-model-foundation`

### Key Deliverables
- [ ] Module `evv_visits` created with correct structure
- [ ] Dependencies on evv_core, evv_patients, evv_agreements, hr
- [ ] Module installs without errors
- [ ] `evv.visit` model created with all specified fields
- [ ] All field types, requirements, and help text correct
- [ ] SQL constraint prevents clock_out before clock_in
- [ ] Python constraint validates active service agreement
- [ ] `name_get` returns format: "Visit - {patient} - {timestamp}"
- [ ] Default state is 'in_progress'
- [ ] State transition methods work correctly
- [ ] Form view displays all fields in logical groups
- [ ] State-based action buttons visible in header
- [ ] Tree view shows key columns
- [ ] Search view with filters and grouping works
- [ ] Basic access rules grant read/write to users
- [ ] Manager role has full access
- [ ] All unit tests pass (0 failed, 0 error(s))
- [ ] All workflow tests pass (0 failed, 0 error(s))
- [ ] Code coverage ≥ 80%

### Reference
Full work order: `aos-architecture/work_orders/pending/VISIT-001-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
