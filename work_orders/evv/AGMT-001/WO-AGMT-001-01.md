---
title: "[FEATURE] WO-AGMT-001-01: Bootstrap `evv_agreements` Module & Core Models"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-agreements"
---
# Work Order: WO-AGMT-001-01 – Bootstrap `evv_agreements` Module & Core Models

## 1. Context & Objective

Create the foundational `evv_agreements` module, extend `res.partner` to support patient/case manager flags and external IDs, and implement the full `service.agreement` data model (fields, computes, constraints, state methods) for the Simple Bucket MVP.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** main  
**New Branch:** feature/WO-AGMT-001-01-service-agreement-model

**Setup Commands:**
```bash
git checkout main
git checkout -b feature/WO-AGMT-001-01-service-agreement-model
```

---

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/__manifest__.py`
Create module manifest declaring name, version `18.0.1.0.0`, dependencies (`base`, `contacts`, `evv_core` once available), data files (views/security placeholders), and installable metadata.

### `evv/addons/evv_agreements/__init__.py`
Import Python packages/modules to register models.

### `evv/addons/evv_agreements/models/__init__.py`
Expose `partner` extension and `service_agreement` model modules.

### `evv/addons/evv_agreements/models/partner.py`
Inherit `res.partner` to add classification booleans and external ID fields per spec.

### `evv/addons/evv_agreements/models/service_agreement.py`
Implement the `service.agreement` model per spec: all declared fields, compute methods (`_compute_start_date`, `_compute_end_date`, `_compute_total_amount`), SQL/Python constraints, and `action_activate` / `action_cancel` methods with validation hooks.

---

## 4. Required Implementation

### Data Model
- Extend `res.partner` with `is_patient`, `is_case_manager`, `recipient_id_external`, `case_manager_external_id` fields and helpful tooltips.
- Define `_name = "service.agreement"` with `_description` per Story.
- Implement all fields from spec (including modifiers, financials, computed start/end aliases, currency, diagnosis code, case manager domain, etc.).
- Add mixins as needed (e.g., `mail.thread`) only if justified.
- Ensure `patient_id` domain enforces patient role via new boolean flag.

### Validation Rules
- Implement model-level constraint ensuring `effective_date <= through_date`.
- Ensure computed `start_date`/`end_date` mirror effective/through dates.
- Enforce positive `total_units` (> 0) via SQL check or Python constraint.
- Default state to `draft` and ensure create respects defaults.

### State & Compute Methods
- Implement `_compute_start_date`, `_compute_end_date`, `_compute_total_amount` exactly as specified (store=True, default 0.0 when missing inputs).
- `action_activate` performs:
  - `self.ensure_one()`
  - validation of mandatory fields, date rules, positive units
  - state transition to `active`
- `action_cancel` with `self.ensure_one()` sets `state = 'cancelled'`.
- Leave TODO hook/comments referencing future integration with validation engine and expiration automation.

### Module Scaffolding
- Ensure package has placeholder folders (`views/`, `security/`, `tests/`, `docs/`) and `models/__init__.py` imports partner + agreement modules.
- Add README.md or blank `__init__.py` where required for packaging.

---

## 5. Acceptance Criteria

### Functional Requirements
- [ ] Module scaffold installs without errors (Odoo 18.0).
- [ ] Manifest, init files, and python packages created under `evv/addons/evv_agreements`.
- [ ] `service.agreement` model matches Story schema and defaults.
- [ ] Validation errors raise `UserError` / `ValidationError` per business rules.
- [ ] `action_activate` only transitions when validations pass; otherwise raises.
- [ ] `action_cancel` transitions state to `cancelled`.
- [ ] Docstrings reference Story `AGMT-001`.
- [ ] Code committed with descriptive message.

### Testing Requirements (MANDATORY)
- [ ] Unit tests written for all new/modified methods:
  - [ ] res.partner extension fields (is_patient, is_case_manager, external IDs)
  - [ ] service.agreement CRUD operations
  - [ ] Computed methods (_compute_start_date, _compute_end_date, _compute_total_amount)
  - [ ] action_activate (valid case and validation failures)
  - [ ] action_cancel
- [ ] Edge cases tested:
  - [ ] Date constraint (effective_date <= through_date)
  - [ ] Units constraint (total_units > 0)
  - [ ] Missing required fields
  - [ ] Default values and state transitions
- [ ] All tests pass (0 failed, 0 errors)
- [ ] Test execution output captured for proof of execution

---

## 6. Context Management & Iteration Limits

Follow template phases, checkpoints, and iteration limits exactly.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)

---

## 8. Technical Constraints

- Odoo Version 18.0 Community.
- No deprecated APIs or enterprise-only features.

---

## 9. MANDATORY Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Test Execution (REQUIRED)
```bash
# Run all tests for the module
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo --test-enable --stop-after-init -i evv_agreements --log-level=test
```
**Provide:** Full test output showing `0 failed, 0 error(s)`.

### 9.2 Boot Verification (REQUIRED)
```bash
# Boot Odoo server
docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming a clean start.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
# Test module upgrade
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u evv_agreements --stop-after-init
```
**Provide:** Log output showing a successful upgrade with no errors.


