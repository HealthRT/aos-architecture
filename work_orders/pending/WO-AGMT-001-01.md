---
title: "[FEATURE] WO-AGMT-001-01: Implement service.agreement Data Model"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: WO-AGMT-001-01 – Implement service.agreement Data Model

## 1. Context & Objective

Create the `service.agreement` model with core fields, constraints, and documentation per `AGMT-001`, building on dependencies (`evv_core`, `evv_patients`, `evv_case_managers`).

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** main  
**New Branch:** feature/WO-AGMT-001-01-service-agreement-model

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/WO-AGMT-001-01-service-agreement-model
```

Ensure pre-commit hooks are installed.

---

## 3. Problem Statement & Technical Details

### Model Definition
- File: `evv/addons/evv_agreements/models/service_agreement.py`
- Implement `service.agreement` with fields defined in Story (agreement metadata, patient link, procedure info, modifiers, dates, units, financials, compliance fields).
- Provide computed fields `_compute_start_date`, `_compute_end_date`, `_compute_total_amount` storing results.
- Implement SQL constraint ensuring `total_units > 0` and date constraints via `_check_dates` (Python constraint).
- Provide helper `_check_unique_active_agreement()` to enforce single active agreement per patient.

### State Methods
- Implement `action_activate` with validation: required fields, date order, positive units, no other active agreements; sets state to `active`.
- Implement `action_cancel` setting state to `cancelled`.
- Ensure default state `draft`, handle `expired` separately (future automation can set).

### Related Fields
- `recipient_id_external` related to patient.
- Ensure `case_manager_id` Many2one to `evv.case_manager`.
- `currency_id` defaults to company currency.

### Security
- File: `evv/addons/evv_agreements/security/ir.model.access.csv`
  - DC: create/read/write/delete
  - Admin: full access
- File: `evv/addons/evv_agreements/security/evv_agreements_security.xml`
  - Record rules ensuring only authorized roles access agreements (DC, Admin). Document assumption if using group-based ACL only.

### Tests
- File: `evv/addons/evv_agreements/tests/test_service_agreement_model.py`
- SavepointCase covering creation, validations (required fields, date checks, total_units > 0), activation workflow, cancellation, single active agreement enforcement, computed fields.

### Documentation
- File: `evv/addons/evv_agreements/docs/models/service_agreement.md`
- Document fields, computations, workflow, dependencies, security.

### Manifest
- Update `evv/addons/evv_agreements/__manifest__.py` with dependencies (`evv_patients`, `evv_case_managers`), include new security/data/test files.

---

## 4. Required Implementation

### Model & Constraints
- `_name = "service.agreement"`, `_description`, `_rec_name = 'agreement_number'` or patient-based (document choice).
- Add `_sql_constraints` for positive units (CHECK) and optionally unique active per patient (enforce via Python for state-dependent logic).
- Provide `@api.constrains` for dates and required fields.
- Ensure computed fields handle missing data gracefully (return 0.0 for total_amount when inputs missing).

### Workflow Methods
- `action_activate`: Ensure validations run, raise `ValidationError` when failing ACs, set `state = 'active'`.
- `action_cancel`: Setting state to `cancelled` with minimal validation.
- Optionally add helper to mark expired (document TODO if not implemented now).

### Security
- Ensure appropriate groups exist (DC role). Reuse existing group definitions or create if necessary.
- Record rules may restrict to DC/Administrators; confirm with compliance. Document assumption if simple ACL sufficient.

### Tests
- SavepointCase verifying:
  - Creating draft agreement with required fields.
  - Activation success/failure scenarios (missing required data, mismatched dates, zero/negative units, existing active agreement).
  - Computed `total_amount`, `start_date`, `end_date` values.
  - Access control (DC allowed, unauthorized user raises `AccessError`).
- Use synthetic data; docstrings reference `AGMT-001`.

### Documentation
- Detail dependencies, state transitions, field descriptions, validation logic, security.

---

## 5. Acceptance Criteria

- [ ] `service.agreement` model implemented with specified fields and computations.
- [ ] Activation enforces required validations and single active agreement constraint.
- [ ] Cancellation transitions state appropriately.
- [ ] Security/ACLs follow compliance guidance (DC + Admin access).
- [ ] SavepointCase tests cover model creation, activation, cancellation, validations (0 failures).
- [ ] Documentation updated describing model, fields, and workflow.
- [ ] Code references Story `AGMT-001` where applicable.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Follow standard implementation/testing workflow, max two bug-fix iterations. Escalate if constraints conflict with business rules.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/specs/evv/PT-001.yaml`
- `@aos-architecture/specs/evv/CM-001.yaml`
- `@aos-architecture/specs/core/CORE-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/TESTING_STRATEGY.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Maintain HIPAA compliance; ensure patient/case manager links rely on secure models.
- Ensure module is bootable with manifest/security updates.
- Keep code size manageable (<500 LOC) by focusing on model layer; subsequent WOs will cover views/tests/ACL details if needed.

---

## 8. MANDATORY: Proof of Execution

### 8.1 Test Execution
```bash
cd /home/james/development/aos-development
docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  --test-enable \
  --stop-after-init \
  -i evv_agreements \
  --log-level=test:INFO
```
- Provide full test output (counts, duration, 0 failures).

### 8.2 Boot Verification
```bash
docker compose up -d --force-recreate evv
sleep 30
docker compose logs --tail="100" evv
```
- Supply last 100 log lines showing successful boot, no errors.

### 8.3 Module Upgrade Test
```bash
docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  -u evv_agreements \
  --stop-after-init
```
- Confirm upgrade runs cleanly; summarize output in handoff comment.

If Docker unavailable, escalate immediately; proof steps mandatory.


