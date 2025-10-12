# Issue Draft: [WORK ORDER] WO-AGMT-001-01 – Bootstrap `evv_agreements` Module & Core Models

**Work Order ID:** WO-AGMT-001-01  
**Priority:** priority:medium  
**Module:** module:evv-compliance

## 1. Context & Objective

Create the foundational `evv_agreements` module, extend `res.partner` with patient/case manager classification and external IDs, and implement the full `service.agreement` model (fields, computes, constraints, state transitions) for the Simple Bucket MVP.

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

### `evv/addons/evv_agreements/__manifest__.py`
- Create module manifest declaring name, version `18.0.1.0.0`, dependencies (`base`, `contacts`, `evv_core` once available), and placeholder data files.

### `evv/addons/evv_agreements/__init__.py`
- Register models package for import.

### `evv/addons/evv_agreements/models/__init__.py`
- Expose partner extension and `service_agreement` model modules.

### `evv/addons/evv_agreements/models/partner.py`
- Inherit `res.partner` to add `is_patient`, `is_case_manager`, `recipient_id_external`, `case_manager_external_id` fields with help texts.

### `evv/addons/evv_agreements/models/service_agreement.py`
- Implement `service.agreement` model per Story `AGMT-001`, including all fields, computed methods (`_compute_start_date`, `_compute_end_date`, `_compute_total_amount`), constraints, and `action_activate` / `action_cancel` methods.

## 4. Required Implementation

### Data Model
- Extend `res.partner` with Story fields, defaults, and help tooltips; ensure booleans default to False.
- Define `_name = "service.agreement"`, `_description = "Service Agreement"`.
- Implement fields exactly as specified (external references, modifiers, dates, financials, compliance, computed aliases, state selection default `draft`).
- Add optional mixins only if justified (e.g., chatter deferred for MVP).
- Add domain/constraints ensuring `patient_id` references `is_patient=True` partner and `case_manager_id` references `is_case_manager=True` partner.

### Validation Rules
- Enforce `effective_date <= through_date` via `@api.constrains`.
- Ensure computed `start_date`/`end_date` mirror effective/through dates.
- Enforce `total_units` positive using constraint or SQL check.
- Default state to `draft` on create.

### Compute & State Methods
- Implement `_compute_start_date`, `_compute_end_date`, `_compute_total_amount` (store results, handle missing values).
- `action_activate` must validate record, ensure single record, and set `state` to `active`; allow same-day date ranges.
- `action_cancel` must ensure single record and set `state` to `cancelled`.
- Leave TODO/comment hooks for upcoming validation engine integration per feature brief.

### Module Scaffolding
- Ensure package includes empty `views/`, `security/`, `tests/`, and `docs/` directories (with `__init__.py` files where required) referenced appropriately by manifest.

## 5. Acceptance Criteria

- [ ] All requirements implemented.
- [ ] Code follows `01-odoo-coding-standards.md`.
- [ ] Code is tenancy-aware per ADR-006 (no tenant-specific assumptions).
- [ ] HIPAA compliance verified (PHI protected, no unnecessary exposure).
- [ ] Tests written and passing (if applicable for model validations).
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

## 7. MANDATORY: Proof of Execution Commands

**YOU MUST COMPLETE THIS BEFORE HANDOFF.**

```bash
cd /home/james/development/aos-development
docker compose up -d --force-recreate odoo
sleep 30
docker compose logs --tail="100" odoo
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --stop-after-init \
  -i evv_agreements
```

**Verify logs show:**
- "HTTP service (werkzeug) running"
- "Modules loaded"
- No Python errors

**If Docker unavailable:** Request access immediately. DO NOT skip this step.


