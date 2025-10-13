# Issue Draft: [WORK ORDER] WO-CORE-001-01 – Integrate partner_firstname with evv_core

**Work Order ID:** WO-CORE-001-01  
**Priority:** priority:high  
**Module:** module:evv-compliance

## 1. Context & Objective

Adopt the community `partner_firstname` module and update `evv_core` so discrete `firstname`, `middlename`, and `lastname` fields are exposed on `res.partner`, keeping the aggregate `name` field synchronized.

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `main`  
**New Branch:** `feature/WO-CORE-001-01-partner-firstname`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/WO-CORE-001-01-partner-firstname
```

## 3. Problem Statement & Technical Details

### Dependency Integration
- Ensure `partner_firstname` source is available (vendored add-on, submodule, or documented dependency) and update any requirements files.
- Add `'partner_firstname'` to `evv/addons/evv_core/__manifest__.py` `depends` list.

### UI & Behavior
- Verify discrete fields display for individual contacts and remain hidden for companies; document any view override required.

### Testing
- Add `evv/addons/evv_core/tests/test_partner_name_fields.py` SavepointCase covering field visibility and `name` computation.

### Documentation
- Update `evv/addons/evv_core/docs/architecture/core_modifications.md` describing adoption of discrete name fields.

## 4. Required Implementation

- Manage dependency retrieval consistent with repo standards.
- Modify manifest to include dependency.
- Implement tests ensuring:
  - Individual contacts show discrete fields and compute concatenated `name`.
  - Company contacts hide discrete fields.
- Keep code formatted per `01-odoo-coding-standards.md` and reference Story `CORE-001` in docstrings.

## 5. Acceptance Criteria

- [ ] All requirements implemented.  
- [ ] Code follows `01-odoo-coding-standards.md`.  
- [ ] Code is tenancy-aware per ADR-006.  
- [ ] Tests written and passing.  
- [ ] Odoo boots without errors (MANDATORY).  
- [ ] Proof of execution logs captured.  
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/core/CORE-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  --test-enable \
  --stop-after-init \
  -i evv_core \
  --log-level=test:INFO

docker compose up -d --force-recreate evv
sleep 30
docker compose logs --tail="100" evv

docker compose exec evv odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d evv \
  -u evv_core \
  --stop-after-init
```

- Attach test output, boot logs, and upgrade confirmation. Escalate if Docker unavailable.


