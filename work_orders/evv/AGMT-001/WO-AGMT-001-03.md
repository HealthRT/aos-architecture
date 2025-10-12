---
title: "[FEATURE] WO-AGMT-001-03: Configure Security & Access Control"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-agreements"
---
# Work Order: WO-AGMT-001-03 – Configure Security & Access Control

## 1. Context & Objective

Implement security artifacts enforcing access for Designated Coordinators while protecting PHI per compliance rules, covering both `service.agreement` and newly extended `res.partner` fields (patient/case manager classification).

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
Define security group for Designated Coordinator (if not global) and assign menus/actions. Optionally add record rule scaffolding for future patient assignment filtering with TODO references.

### `evv/addons/evv_agreements/security/ir.model.access.csv`
Grant CRUD permissions only to DC group and system admin; deny others. Confirm no additional access needed for `res.partner` fields beyond existing rights.

### `evv/addons/evv_agreements/__manifest__.py`
Ensure security files load before views.

---

## 4. Required Implementation

### Groups & Record Rules
- Create group `group_evv_designated_coordinator` (or reuse existing from shared module if canonical ID known).
- If global DC group already defined, reference existing XML ID; otherwise define and document for future reuse.
- Add record rule stubs or TODO comments for restricting access based on patient assignment once data model exists; for MVP, document assumption of full access by DC role.

### Access Controls
- CSV entry granting `service.agreement` read/write/create/unlink to DC group and admin.
- Confirm `res.partner` access inherits from `contacts`; ensure new fields respect least-privilege (no extra access required).
- Explicitly omit access for other roles.
- Include comments referencing HIPAA compliance requirement and PHI fields list.

### Menu & Action Binding
- Update menus/actions created in WO-02 with `groups` restrictions.
- Ensure search views or other assets do not expose PHI to unauthorized roles.

### Documentation
- Inline comments referencing Story `AGMT-001` and compliance rationale.
- Document assumptions about patient assignment architecture and future record rules.

---

## 5. Acceptance Criteria

### Functional Requirements
- [ ] DC group defined or referenced and documented.
- [ ] `ir.model.access.csv` enforces permissions: only DC + admin can CRUD.
- [ ] Menus/actions hidden from unauthorized roles.
- [ ] Module upgrade/install loads security files without errors.
- [ ] Assumptions around patient assignment documented in code comments.
- [ ] Code committed with descriptive message.

### Testing Requirements (MANDATORY)
- [ ] Unit tests written for access control:
  - [ ] DC user can create/read/write/delete service agreements
  - [ ] Non-DC user receives AccessError when attempting CRUD operations
  - [ ] Admin user can access service agreements
  - [ ] Menu items visible to DC, hidden from others
- [ ] Security validation:
  - [ ] ir.model.access.csv entries verified
  - [ ] Group assignments tested
  - [ ] Record rules (if implemented) tested
- [ ] All tests pass (0 failed, 0 errors)

---

## 6. Context Management & Iteration Limits

Follow standard workflow.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/06-role-and-permission-matrix.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)

---

## 8. Technical Constraints

- Adhere to principle of least privilege; avoid record rules unless enforceable.
- Ensure CSV uses canonical model ID `service.agreement`.

---

## 9. MANDATORY Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Test Execution (REQUIRED)
```bash
# Run all tests including security tests
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo --test-enable --stop-after-init -u evv_agreements --log-level=test
```
**Provide:** Full test output showing `0 failed, 0 error(s)`, including AccessError tests.

### 9.2 Boot Verification (REQUIRED)
```bash
# Boot Odoo server and verify security loaded
docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming security files loaded without errors.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
# Test module upgrade with security
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u evv_agreements --stop-after-init
```
**Provide:** Log output showing successful security file loading and upgrade.


