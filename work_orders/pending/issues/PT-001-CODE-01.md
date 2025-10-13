---
title: "[FEATURE] PT-001-CODE-01: Implement evv.patient Model"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: PT-001-CODE-01

**Repository:** HealthRT/evv  
**Story:** PT-001 - Create Dedicated Patient Model

### Objective
Create the HIPAA-compliant `evv.patient` model, associated views, security, and documentation as defined in `PT-001`, including unique external ID enforcement and partner search disambiguation.

### Branch
`feature/PT-001-CODE-01-patient-model`

### Key Deliverables
- [ ] `evv.patient` model implemented with fields, unique constraint, and related name
- [ ] Partner search provides disambiguating info for same-name contacts
- [ ] Views allow DC/Admin to manage patients; UI aligns with mockup
- [ ] ACLs enforce role-based access per compliance section
- [ ] SavepointCase tests cover creation, duplicate prevention, access control, search behavior (0 failures)
- [ ] Documentation added/updated for patient model
- [ ] Code references Story `PT-001` as appropriate
- [ ] Odoo boots without errors (MANDATORY)
- [ ] Proof of execution logs captured (tests + boot + upgrade)

### Reference
Full work order: `aos-architecture/work_orders/pending/PT-001-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
