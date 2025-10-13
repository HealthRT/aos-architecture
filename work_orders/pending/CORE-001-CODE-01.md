---
title: "[FEATURE] CORE-001-CODE-01: Integrate partner_firstname with evv_core"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: CORE-001-CODE-01 – Integrate partner_firstname with evv_core

## 1. Context & Objective

Adopt the community `partner_firstname` module and update `evv_core` so discrete `firstname`, `middlename`, and `lastname` fields are available on `res.partner`, ensuring the legacy `name` field stays synchronized.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** main  
**New Branch:** feature/CORE-001-CODE-01-partner-firstname

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/CORE-001-CODE-01-partner-firstname
```

Ensure pre-commit hooks described in `standards/00-contributor-guide.md` are installed locally.

---

## 3. Problem Statement & Technical Details

### Module Dependency Integration
- Add `partner_firstname` to external dependencies (submodule requirement or requirements file per repository standards).
- Update `evv/addons/evv_core/__manifest__.py` to include `partner_firstname` in `depends`.

### UI Adjustments
- Confirm `partner_firstname` provides appropriate partner views; if overrides needed, ensure fields visible only for individual contacts (respect Story guidance). Document any view customizations applied.

### Tests
- Create `evv/addons/evv_core/tests/test_partner_name_fields.py` verifying field visibility and name computation (see Section 4).

### Documentation
- Update or create `evv/addons/evv_core/docs/architecture/core_modifications.md` summarizing discrete name support and dependency on `partner_firstname`.

---

## 4. Required Implementation

### Dependency Management
- Ensure repository includes `partner_firstname` source (via git submodule, vendored add-on, or documented dependency per project standards). Update README/requirements if necessary.
- Modify `__manifest__.py` `depends` list: add `'partner_firstname'`.

### Functional Verification Tests
- Implement SavepointCase tests covering acceptance criteria from `CORE-001`:
  - Creating individual contact exposes discrete fields and computes `name` as concatenation.
  - Company contact hides discrete name fields.
- Use Odoo test utilities; include docstrings referencing `CORE-001`.
- Ensure tests run with module install (`-i evv_core`).

### Documentation
- Document change in `docs/architecture/core_modifications.md` (create file if missing) explaining adoption rationale and usage.

### Linting & Standards
- Ensure code passes linters/formatters. Keep changes under 500 LOC.

---

## 5. Acceptance Criteria

- [ ] `partner_firstname` dependency integrated and recorded in repo requirements.
- [ ] `evv_core` manifest lists `partner_firstname` in `depends`.
- [ ] Discrete name fields visible for individual contacts, hidden for companies, with `name` computed correctly.
- [ ] Documentation updated describing core modification.
- [ ] SavepointCase tests cover field visibility and name computation; 0 failures.
- [ ] Code references Story `CORE-001` in docstrings/comments.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Follow standard workflow: implement → test → bug fix (max two iterations). Escalate if dependency retrieval requires infrastructure changes.

---

## 7. Required Context Documents

- `@aos-architecture/specs/core/CORE-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/TESTING_STRATEGY.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Ensure dependency handling aligns with repository packaging practices (e.g., include in `addons` path or pip requirements).
- Maintain bootability: `evv_core` must install cleanly with new dependency.

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
  -i evv_core \
  --log-level=test:INFO
```
- Provide full test output (include counts, duration, 0 failures).

### 8.2 Boot Verification
```bash
cd /home/james/development/aos-development
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
  -u evv_core \
  --stop-after-init
```
- Confirm upgrade runs without errors; summarize in handoff comment.

If Docker unavailable, escalate immediately; do **not** skip proof steps.


