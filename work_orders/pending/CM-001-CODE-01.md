---
title: "[FEATURE] CM-001-CODE-01: Implement evv.case_manager Model"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: CM-001-CODE-01 – Implement evv.case_manager Model

## 1. Context & Objective

Create the dedicated `evv.case_manager` model, supporting views, access controls, and documentation as specified in `CM-001`, enabling administrators and DCs to manage case manager records securely.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** main  
**New Branch:** feature/CM-001-CODE-01-case-manager-model

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/CM-001-CODE-01-case-manager-model
```

Ensure pre-commit hooks are installed (`standards/00-contributor-guide.md`).

---

## 3. Problem Statement & Technical Details

### Model Implementation
- File: `evv/addons/evv_case_managers/models/evv_case_manager.py`
- Define `evv.case_manager` with fields:
  - `partner_id` (Many2one `res.partner`, required, non-sensitive data link)
  - `case_manager_external_id` (Char, optional, unique)
  - `name` (Related to `partner_id.name`, stored, readonly)
- Implement SQL constraint enforcing unique `case_manager_external_id` when set.
- Override `create`/`write` as needed to enforce business rules (e.g., ensure partner link present).

### Views
- File: `evv/addons/evv_case_managers/views/evv_case_manager_views.xml`
- Provide tree and form views aligning with Story (display partner, external ID, name). Ensure menu integration consistent with module design (e.g., under EVV configuration/settings menu accessible to Admin/DC). Document placeholder if menus handled elsewhere.

### Security
- File: `evv/addons/evv_case_managers/security/ir.model.access.csv`
  - Admin: create/read/write/unlink
  - DC: create/read/write (no unlink per compliance unless specified)
  - Others: no access
- Add record rules in `security/evv_case_managers_security.xml` if needed to restrict visibility (optional if ACL sufficient; document decision).

### Tests
- File: `evv/addons/evv_case_managers/tests/test_case_manager_record.py`
- SavepointCase covering creation, duplicate external ID constraint, access control for Admin/DC, access error for other roles.

### Documentation
- File: `evv/addons/evv_case_managers/docs/models/evv_case_manager.md` describing model purpose, fields, security, and relationship to `res.partner`.

### Manifest
- Update `evv/addons/evv_case_managers/__manifest__.py` to include new files in `data` and `depends` (ensure dependency on `evv_core` remains).

---

## 4. Required Implementation

### Model & Constraints
- Define `_name = "evv.case_manager"`, `_description` per Story, `_rec_name = 'name'`.
- Add `_sql_constraints` for unique external ID (allow null duplicates).
- Use mail mixins only if necessary (document decision).

### Security & Access
- Ensure ACLs align with compliance roles.
- Consider record rule to restrict read to Admin/DC if broader res.partner access could leak data (document assumption).
- Add groups to menu items if UI provided.

### Tests
- SavepointCase verifying:
  - Admin can create record with partner link.
  - Duplicate external ID raises `ValidationError`.
  - DC can create/edit; unauthorized user raises `AccessError`.
  - Related name stored correctly.
- Use synthetic data; docstrings reference `CM-001`.

### Views & UX
- Provide search view with fields (partner, external ID) to assist disambiguation.
- Ensure partner field uses `domain=[('is_company','=',False)]` if appropriate (document choice).

### Documentation
- Document fields, constraints, and access rules; include link to Story.

---

## 5. Acceptance Criteria

- [ ] `evv.case_manager` model implemented with required fields and unique constraint.
- [ ] Tree/form views available; partner link required.
- [ ] ACLs enforce Admin/DC permissions; other roles denied.
- [ ] Tests cover creation, duplicate external ID, access rights (0 failures).
- [ ] Documentation updated describing model and access patterns.
- [ ] Code references Story `CM-001` where appropriate.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Follow standard workflow with max two bug-fix iterations. Escalate if partner linking needs additional disambiguation beyond scope.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/CM-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/TESTING_STRATEGY.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Ensure unique constraint allows null but not duplicate values.
- Maintain bootability (manifest references, security in place).
- Keep total diff <500 LOC.

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
  -i evv_case_managers \
  --log-level=test:INFO
```
- Include full output (test counts, duration, 0 failures).

### 8.2 Boot Verification
```bash
docker compose up -d --force-recreate evv
sleep 30
docker compose logs --tail="100" evv
```
- Provide logs showing successful boot, no critical errors.

### 8.3 Module Upgrade Test
```bash
docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  -u evv_case_managers \
  --stop-after-init
```
- Confirm upgrade runs cleanly; summarize in handoff comment.

If Docker unavailable, escalate immediately; do **not** skip proof steps.


