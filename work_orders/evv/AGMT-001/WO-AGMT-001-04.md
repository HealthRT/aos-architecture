---
title: "[TESTING] WO-AGMT-001-04: Implement Automated Tests for Service Agreements"
repo: "HealthRT/evv"
assignee: "aos-tester-agent"
labels: "agent:tester,type:feature,priority:medium,module:evv-agreements"
---
# Work Order: WO-AGMT-001-04 – Implement Automated Tests for Service Agreements

## 1. Context & Objective

Create automated tests covering `res.partner` field enhancements and `service.agreement` business rules, computed fields, state transitions, and access control per acceptance criteria.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** feature/WO-AGMT-001-03-service-agreement-security  
**New Branch:** feature/WO-AGMT-001-04-service-agreement-tests

**Setup Commands:**
```bash
git checkout feature/WO-AGMT-001-03-service-agreement-security
git checkout -b feature/WO-AGMT-001-04-service-agreement-tests
```

---

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/tests/test_service_agreement.py`
Implement unit tests verifying partner extensions, agreement creation, validation, computed fields, activation, cancellation, and permissions.

### `evv/addons/evv_agreements/tests/__init__.py`
Ensure test package loads.

### `evv/addons/evv_agreements/__manifest__.py`
Confirm test module is discoverable (no direct changes unless necessary for data loading).

---

## 4. Required Implementation

### Test Coverage
- Use `TransactionCase` or `SavepointCase` as appropriate.
- Scenarios:
  - Partner extension fields (`is_patient`, `is_case_manager`, external IDs) default values and domains work as expected.
  - DC user can create agreement; unauthorized role raises `AccessError`.
  - Required field validations (patient, procedure_code, effective_date, through_date, total_units) enforced on create.
  - Date constraint (`effective_date <= through_date`) enforced.
  - Units constraint (positive total_units) enforced.
  - Computed fields `start_date`, `end_date`, `total_amount` produce expected values.
  - Activation transitions state to `active` only when validations pass; ensure same-day dates allowed.
  - Activation blocked when validations fail (missing fields, zero units, etc.).
  - Cancel sets state to `cancelled` from `active`/`draft`.
  - Multiple agreements per patient with shared `agreement_number` allowed.
- Seed minimal patient/case manager records with new partner flags.
- Reference Story ID in docstrings/comments.

### Test Utilities
- Helper to create DC user with correct group assignments.
- Use `with self.assertRaises` for error scenarios.
- Ensure each acceptance criterion has explicit test coverage.

### Test Data Hygiene
- Use synthetic names; avoid PHI.
- Clean up created records if using `TransactionCase`.

---

## 5. Acceptance Criteria

### Testing Requirements (MANDATORY)
- [ ] Unit tests written for all scenarios listed in Section 4
- [ ] Edge cases tested (nulls, empty recordsets, validation failures)
- [ ] All tests pass (0 failed, 0 errors)
- [ ] Test coverage includes all acceptance criteria from Story AGMT-001

### Functional Requirements
- [ ] Tests cover all Story acceptance criteria and rules
- [ ] Unauthorized user creation triggers `AccessError`
- [ ] Validation errors enforced (dates, units)
- [ ] State transitions validated
- [ ] Tests registered under `tests/` and runnable via `odoo-bin`
- [ ] Code committed with descriptive message
- [ ] Proof of execution: test output showing 0 failures (MANDATORY)
- [ ] Odoo boots without errors (MANDATORY)

---

## 6. Context Management & Iteration Limits

Follow standard workflow; escalate after two failing attempts.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

---

## 8. Technical Constraints

- Tests must run via `docker compose exec odoo odoo-bin ... -i evv_agreements --test-enable`.
- No PHI in test data.

---

## 9. MANDATORY Proof of Execution

Provide full test command output (showing zero failures) and boot logs per template.


