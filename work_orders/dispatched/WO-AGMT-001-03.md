---
title: "[FEATURE] WO-AGMT-001-03: Configure Security & Access Control"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-compliance"
---
# Work Order: WO-AGMT-001-03 – Configure Security & Access Control

## 1. Context & Objective

Implement security artifacts enforcing access for Designated Coordinators while protecting PHI per compliance rules.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** feature/WO-AGMT-001-02-service-agreement-views  
**New Branch:** feature/WO-AGMT-001-03-service-agreement-security

**Setup Commands:**
```bash
git checkout feature/WO-AGMT-001-02-service-agreement-views
git checkout -b feature/WO-AGMT-001-03-service-agreement-security
```

---

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/security/evv_agreements_security.xml`
Define security group for Designated Coordinator (if not global) and assign menus/actions.

### `evv/addons/evv_agreements/security/ir.model.access.csv`
Grant CRUD permissions only to DC group and system admin; deny others.

### `evv/addons/evv_agreements/__manifest__.py`
Ensure security files load before views.

---

## 4. Required Implementation

### Groups & Record Rules
- Create group `group_evv_designated_coordinator` (or reuse existing from shared module if canonical ID known).
- If global DC group already defined, reference existing XML ID; otherwise define and document for future reuse.
- Add record rule(s) restricting access to agreements for assigned patients if supporting models exist. If not, document assumption and default to module-wide access for DC role with TODO referencing future enhancement.

### Access Controls
- CSV entry granting `service.agreement` read/write/create/unlink to DC group and admin.
- Explicitly omit access for other roles.
- Include comments referencing HIPAA compliance requirement.

### Menu & Action Binding
- Update menus/actions created in WO-02 with `groups` restrictions.
- Ensure search views or other assets do not expose data to unauthorized roles.

### Documentation
- Inline comments referencing Story `AGMT-001` and compliance rationale.
- Document assumptions about patient assignment architecture.

---

## 5. Acceptance Criteria

- [ ] DC group defined or referenced and documented.
- [ ] `ir.model.access.csv` enforces permissions: only DC + admin can CRUD.
- [ ] Menus/actions hidden from unauthorized roles.
- [ ] Module upgrade/install loads security files without errors.
- [ ] Assumptions around patient assignment documented in code comments.
- [ ] Code committed with descriptive message.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.

---

## 6. Context Management & Iteration Limits

Follow standard workflow.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/06-role-and-permission-matrix.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

---

## 7. Technical Constraints

- Adhere to principle of least privilege; avoid record rules unless enforceable.
- Ensure CSV uses canonical model ID `service.agreement`.

---

## 8. Proof of Execution

Provide module upgrade output verifying security files load, plus boot logs.


