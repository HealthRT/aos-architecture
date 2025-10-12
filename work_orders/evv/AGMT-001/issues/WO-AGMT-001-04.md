# Issue Draft: [WORK ORDER] WO-AGMT-001-04 – Implement Automated Tests for Service Agreements

**Work Order ID:** WO-AGMT-001-04  
**Priority:** priority:high  
**Module:** module:evv-compliance

## 1. Context & Objective

Create automated tests covering `res.partner` extensions and `service.agreement` business rules, computed fields, state transitions, and access control per the Story acceptance criteria.

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `feature/WO-AGMT-001-03-service-agreement-security`  
**New Branch:** `feature/WO-AGMT-001-04-service-agreement-tests`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-03-service-agreement-security
git pull origin feature/WO-AGMT-001-03-service-agreement-security
git checkout -b feature/WO-AGMT-001-04-service-agreement-tests
```

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/tests/test_service_agreement.py`
- Implement tests validating partner flags, agreement creation, constraints, computed fields, state transitions, and access control.

### `evv/addons/evv_agreements/tests/__init__.py`
- Ensure test package loads.

### Supporting Data
- Create helper fixtures for patient and DC user.

## 4. Required Implementation

### Test Coverage
- Partner extensions: default booleans, external ID assignments, domain filtering (`is_patient`, `is_case_manager`).
- DC can create agreement.
- Unauthorized role raises `AccessError` when attempting create.
- Missing required fields (patient, procedure_code, effective_date, through_date, total_units) raise `ValidationError`.
- `effective_date > through_date` raises `ValidationError`; same-day allowed.
- Negative or zero `total_units` raises `ValidationError`.
- Computed fields (`start_date`, `end_date`, `total_amount`) produce expected values (including zero fallback).
- `action_activate` transitions to `active` only when validations pass; ensure failure when missing required data.
- `action_cancel` transitions to `cancelled` from `active`/`draft`.
- Multiple agreements for same patient with shared `agreement_number` allowed (no uniqueness constraint collision).
- Tests reference Story `AGMT-001` in docstrings/comments.

### Test Utilities
- Use `TransactionCase` or `SavepointCase` (prefer Savepoint for performance).
- Reuse security group created in WO-03.
- Use synthetic data (no PHI).

### Test Execution
- Ensure tests run with module install command and pass.

## 5. Acceptance Criteria

- [ ] All requirements implemented.
- [ ] Code follows `01-odoo-coding-standards.md`.
- [ ] Code is tenancy-aware per ADR-006.
- [ ] HIPAA compliance verified (test data sanitized).
- [ ] Tests written and passing (MANDATORY).
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --test-enable \
  --stop-after-init \
  -i evv_agreements \
  --log-level=test:INFO
docker compose logs --tail="100" odoo
```

**Provide:**
- Full test output (0 failed, 0 errors)
- Number of tests run and duration


