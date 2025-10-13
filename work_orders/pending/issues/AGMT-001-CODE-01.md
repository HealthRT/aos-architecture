---
title: "[FEATURE] AGMT-001-CODE-01: Implement service.agreement Data Model"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: AGMT-001-CODE-01

**Repository:** HealthRT/evv  
**Story:** AGMT-001 - Simple Bucket Service Agreement

### Objective
Create the `service.agreement` model with core fields, constraints, and documentation per `AGMT-001`, building on dependencies (`evv_core`, `evv_patients`, `evv_case_managers`).

### Branch
`feature/AGMT-001-CODE-01-service-agreement-model`

### Key Deliverables
- [ ] `service.agreement` model implemented with specified fields and computations
- [ ] Activation enforces required validations and single active agreement constraint
- [ ] Cancellation transitions state appropriately
- [ ] Security/ACLs follow compliance guidance (DC + Admin access)
- [ ] SavepointCase tests cover model creation, activation, cancellation, validations (0 failures)
- [ ] Documentation updated describing model, fields, and workflow
- [ ] Code references Story `AGMT-001` where applicable
- [ ] Odoo boots without errors (MANDATORY)
- [ ] Proof of execution logs captured (tests + boot + upgrade)

### Reference
Full work order: `aos-architecture/work_orders/pending/AGMT-001-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
