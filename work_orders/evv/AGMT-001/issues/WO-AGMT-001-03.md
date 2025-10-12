# Issue Draft: [WORK ORDER] WO-AGMT-001-03 – Configure Security & Access Control

**Work Order ID:** WO-AGMT-001-03  
**Priority:** priority:high  
**Module:** module:evv-compliance

## 1. Context & Objective

Implement security artifacts enforcing access for Designated Coordinators while protecting PHI per compliance requirements, covering both `service.agreement` and the new `res.partner` classification fields.

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `feature/WO-AGMT-001-02-service-agreement-views`  
**New Branch:** `feature/WO-AGMT-001-03-service-agreement-security`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-02-service-agreement-views
git pull origin feature/WO-AGMT-001-02-service-agreement-views
git checkout -b feature/WO-AGMT-001-03-service-agreement-security
```

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/security/evv_agreements_security.xml`
- Define Designated Coordinator security group and bind menus/actions; add TODO for future record rules filtering by patient assignment.

### `evv/addons/evv_agreements/security/ir.model.access.csv`
- Grant CRUD on `service.agreement` only to DC group and admin; confirm whether additional access for partner fields is needed (likely not since they inherit from contacts).

### `evv/addons/evv_agreements/__manifest__.py`
- Ensure security files load before views.

## 4. Required Implementation

### Groups & Record Rules
- Create/reuse group `group_evv_designated_coordinator`; comment if referencing external module.
- Add record rule scaffolding/TODO to limit access to assigned patients when data model allows; for MVP, document assumption of full access for DC group.

### Access Controls
- CSV entry granting read/create/write/unlink to DC group and admin; deny others.
- Confirm DC users inherit partner edit rights for patient classification fields; document assumption.
- Include comments referencing HIPAA compliance and PHI field list.

### Menu & Action Binding
- Restrict menus/actions via `groups` attribute to DC group.
- Ensure UI elements from previous WOs respect group restrictions.

### Documentation
- Inline XML comments referencing Story `AGMT-001` and compliance rationale.
- Document assumptions about patient assignment relationships.

## 5. Acceptance Criteria

- [ ] All requirements implemented.
- [ ] Code follows `01-odoo-coding-standards.md`.
- [ ] Code is tenancy-aware per ADR-006.
- [ ] HIPAA compliance verified (access restricted appropriately).
- [ ] Tests written and passing (security checks if feasible).
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/06-role-and-permission-matrix.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --stop-after-init \
  -u evv_agreements
docker compose logs --tail="100" odoo
```

**Verify logs show:**
- Security files loaded without errors
- "HTTP service (werkzeug) running"
- No Python errors


