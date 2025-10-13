# Issue Draft: [WORK ORDER] WO-AGMT-001-01 – Implement service.agreement Data Model

**Work Order ID:** WO-AGMT-001-01  
**Priority:** priority:high  
**Module:** module:evv-compliance

## 1. Context & Objective

Create the `service.agreement` data model with required fields, computations, state methods, security, and documentation per `AGMT-001`, leveraging dependencies (`evv_core`, `evv_patients`, `evv_case_managers`).

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `main`  
**New Branch:** `feature/WO-AGMT-001-01-service-agreement-model`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/WO-AGMT-001-01-service-agreement-model
```

## 3. Problem Statement & Technical Details

- Implement model in `evv/addons/evv_agreements/models/service_agreement.py` with fields defined in Story (agreement metadata, patient link, procedure details, modifiers, dates, units, financials, compliance).
- Computed fields: `_compute_start_date`, `_compute_end_date`, `_compute_total_amount` (store results, handle missing inputs).
- Constraints: enforce date order (`effective_date <= through_date`), positive `total_units`, required fields on activation, and single active agreement per patient (Python logic).
- Workflow methods: `action_activate` (validate + set state `active`), `action_cancel` (set state `cancelled`). Default `state='draft'`.
- Security: update `security/ir.model.access.csv` and add record rules (if needed) to restrict to DC/Admin roles.
- Tests: `evv/addons/evv_agreements/tests/test_service_agreement_model.py` covering creation, validations, activation, cancellation, computed fields, single active constraint, access control.
- Documentation: `evv/addons/evv_agreements/docs/models/service_agreement.md` summarizing fields, workflow, dependencies, security.
- Manifest: update `__manifest__.py` dependencies and data references.

## 4. Required Implementation

- Implement model with docstrings referencing `AGMT-001`.
- Provide validations to satisfy acceptance criteria (required fields, date checks, units, unique active agreement).
- Ensure computed fields and monetary values handle currency properly.
- Configure ACLs/groups for DC/Admin access.
- Write SavepointCase tests verifying scenarios.
- Update documentation accordingly.

## 5. Acceptance Criteria

- [ ] All requirements implemented.  
- [ ] Code follows `01-odoo-coding-standards.md`.  
- [ ] Code is tenancy-aware per ADR-006.  
- [ ] Tests written and passing.  
- [ ] Odoo boots without errors (MANDATORY).  
- [ ] Proof of execution logs captured.  
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/specs/evv/PT-001.yaml`
- `@aos-architecture/specs/evv/CM-001.yaml`
- `@aos-architecture/specs/core/CORE-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  --test-enable \
  --stop-after-init \
  -i evv_agreements \
  --log-level=test:INFO

docker compose up -d --force-recreate evv
sleep 30
docker compose logs --tail="100" evv

docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  -u evv_agreements \
  --stop-after-init
```

- Provide test results, boot logs, upgrade confirmation. Escalate if Docker unavailable.


