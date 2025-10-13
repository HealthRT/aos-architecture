---
title: "[FEATURE] CORE-001-CODE-01: Integrate partner_firstname with evv_core"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: CORE-001-CODE-01

**Repository:** HealthRT/evv  
**Story:** CORE-001 - Adopt Foundational Module for Discrete Person Names

### Objective
Adopt the community `partner_firstname` module and update `evv_core` so discrete `firstname`, `middlename`, and `lastname` fields are available on `res.partner`, ensuring the legacy `name` field stays synchronized.

### Branch
`feature/CORE-001-CODE-01-partner-firstname`

### Key Deliverables
- [ ] `partner_firstname` dependency integrated into evv repository
- [ ] `evv_core` manifest updated with `partner_firstname` dependency
- [ ] Discrete name fields visible for individuals, hidden for companies
- [ ] Name computed correctly from discrete fields
- [ ] SavepointCase tests cover field visibility and name computation
- [ ] Documentation updated describing core modification
- [ ] Module boots cleanly and upgrades without errors

### Reference
Full work order: `aos-architecture/work_orders/pending/CORE-001-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments.
