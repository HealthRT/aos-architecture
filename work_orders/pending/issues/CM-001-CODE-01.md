---
title: "[FEATURE] CM-001-CODE-01: Implement evv.case_manager Model"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: CM-001-CODE-01

**Repository:** HealthRT/evv  
**Story:** CM-001 - Create Dedicated Case Manager Model

### Objective
Create the dedicated `evv.case_manager` model, supporting views, access controls, and documentation as specified in `CM-001`, enabling administrators and DCs to manage case manager records securely.

### Branch
`feature/CM-001-CODE-01-case-manager-model`

### Key Deliverables
- [ ] `evv.case_manager` model implemented with required fields and unique constraint
- [ ] Tree/form views available; partner link required
- [ ] ACLs enforce Admin/DC permissions; other roles denied
- [ ] Tests cover creation, duplicate external ID, access rights (0 failures)
- [ ] Documentation updated describing model and access patterns
- [ ] Code references Story `CM-001` where appropriate
- [ ] Odoo boots without errors (MANDATORY)
- [ ] Proof of execution logs captured (tests + boot + upgrade)

### Reference
Full work order: `aos-architecture/work_orders/pending/CM-001-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
