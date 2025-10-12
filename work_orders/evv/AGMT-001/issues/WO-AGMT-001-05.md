# Issue Draft: [WORK ORDER] WO-AGMT-001-05 – Author Documentation for Service Agreements

**Work Order ID:** WO-AGMT-001-05  
**Priority:** priority:medium  
**Module:** module:evv-compliance

## 1. Context & Objective

Document the `res.partner` extensions and `service.agreement` model behaviors in `docs/models/service_agreement.md`, ensuring clarity for future maintainers and auditors.

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `feature/WO-AGMT-001-04-service-agreement-tests`  
**New Branch:** `feature/WO-AGMT-001-05-service-agreement-docs`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-04-service-agreement-tests
git pull origin feature/WO-AGMT-001-04-service-agreement-tests
git checkout -b feature/WO-AGMT-001-05-service-agreement-docs
```

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/docs/models/service_agreement.md`
- Author documentation covering partner extensions, agreement model overview, field definitions, computed fields, state machine, business rules, security, and future integration notes.

### `evv/addons/evv_agreements/__manifest__.py`
- Update description or documentation references if required to note new doc.

## 4. Required Implementation

### Documentation Content
- Introduction referencing Story `AGMT-001` and module intent.
- Detail partner classification fields (`is_patient`, `is_case_manager`, external IDs) and how they integrate with domains/search.
- Field reference table for `service.agreement` including computed fields (`start_date`, `end_date`, `total_amount`) with formulas and storage notes.
- State lifecycle narrative for `draft → active → cancelled/expired` with notes on expiration automation (future scope).
- Business rule section covering required fields, date ordering, unit validations, activation checks, multiple service lines scenario.
- Security section summarizing DC-only management, PHI handling, and references to security files.
- Integration roadmap (Service Validation Engine, override process, reporting feeds).
- Tests reference including how to execute automated suite.
- Future scope clearly labeled (no TODO markers).

### Compliance
- Avoid PHI examples; use placeholders.
- Highlight HIPAA alignment and audit logging expectations.

### Formatting
- Follow documentation conventions (headings, bullet style, ASCII only).

## 5. Acceptance Criteria

- [ ] All requirements implemented.
- [ ] Code follows `00-contributor-guide.md` documentation standards.
- [ ] Code is tenancy-aware per ADR-006 (mention in doc context where relevant).
- [ ] HIPAA compliance verified (documentation handles PHI guidance correctly).
- [ ] Tests written and passing (no new tests required, but reference existing).
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md`
- `@aos-architecture/standards/00-contributor-guide.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose up -d --force-recreate odoo
sleep 30
docker compose logs --tail="100" odoo
```

**Verify logs show:**
- "HTTP service (werkzeug) running"
- "Modules loaded"
- No Python errors


