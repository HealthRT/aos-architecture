# Issue Draft: [WORK ORDER] TRACTION-003 – Rocks Model & Leadership Guardrails

**Work Order ID:** TRACTION-003  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Implement the `traction.rock` canonical model with scope management, leadership-only Company Rock guardrails, ACLs, and tests.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-002-issues-model`  
**New Branch:** `feature/TRACTION-003-rocks`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-002-issues-model
git pull origin feature/TRACTION-002-issues-model
git checkout -b feature/TRACTION-003-rocks
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/rock.py`
- Fields: `name`, `scope`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `lifecycle_state`, `responsible_id`, `due_quarter`, `is_company_rock`, `uuid`.
- Guardrails: `is_company_rock` requires leadership group membership; enforce in `create`/`write`.
- UUID auto-generation + uniqueness constraint.

### `hub/addons/traction/models/__init__.py`
- Import rock model.

### `hub/addons/traction/security/ir.model.access.csv`
- ACL mirroring issues (facilitator/leadership write, others read if visible).

### `hub/addons/traction/security/traction_security.xml`
- Record rules limiting read/write to visibility/ownership, plus rule preventing non-leadership from setting `is_company_rock` True.

### `hub/addons/traction/views/traction_rock_views.xml`
- Tree/Form views with `is_company_rock` field restricted to leadership (via `groups`).
- Filters (My Rocks, Company Rocks) aligning with ADMIN-003.

### `hub/addons/traction/tests/test_traction_rock.py`
- SavepointCase tests covering guardrails, visibility, state transitions (if implemented), UUID creation.

### `hub/addons/traction/__manifest__.py`
- Reference new views/security/tests.

## 4. Required Implementation

### Model & Guardrails
- `_name = "traction.rock"`; optionally inherit mail mixins (document decision).
- Default `scope='team'`, `lifecycle_state='planned'`.
- Override `create`/`write` to enforce leadership check for `is_company_rock`.
- Provide helper methods (`action_mark_on_track`, etc.) if feasible; document deferral if not implemented.

### UI & Security
- Ensure view-level restriction using `groups="traction.group_leadership"` for company rock checkbox.
- Record rule ensures only leadership can create/update company rocks (backend enforcement).
- Menus: stub if needed; ensure no unauthorized exposure.

### Testing Requirements
- SavepointCase verifying:
  - Leadership user can set `is_company_rock`; non-leadership raises `AccessError`.
  - Read/write rules respect visibility/ownership.
  - UUID generated and unique.
  - Optional: lifecycle transitions if implemented.
- Tests should reference `TRACTION-ITEMS-CORE` and `ADMIN-003`.

## 5. Acceptance Criteria

- [ ] All requirements implemented.  
- [ ] Code follows `01-odoo-coding-standards.md`.  
- [ ] Code is tenancy-aware per ADR-006.  
- [ ] Tests written and passing.  
- [ ] Odoo boots without errors (MANDATORY).  
- [ ] Proof of execution logs captured.  
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/user_stories/hub/traction/ADMIN-003.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec hub odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d hub \
  --test-enable \
  --stop-after-init \
  -i traction \
  --log-level=test:INFO

docker compose up -d --force-recreate hub
sleep 30
docker compose logs --tail="100" hub

docker compose exec hub odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d hub \
  -u traction \
  --stop-after-init
```

- Provide test output, boot logs, upgrade confirmation. Escalate if Docker unavailable.


