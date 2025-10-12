# Issue Draft: [WORK ORDER] TRACTION-004 – To-Dos & Scorecard KPI Models

**Work Order ID:** TRACTION-004  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Implement `traction.todo` and `traction.scorecard.kpi` canonical models with ownership/visibility, behaviors, ACLs, views, and tests.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-003-rocks`  
**New Branch:** `feature/TRACTION-004-todos-kpis`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-003-rocks
git pull origin feature/TRACTION-003-rocks
git checkout -b feature/TRACTION-004-todos-kpis
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/todo.py`
- Fields: `name`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `assignee_id`, `due_date`, `state`, `uuid`.
- Methods: `action_mark_done()`, `action_cancel()` with chatter logging.

### `hub/addons/traction/models/scorecard_kpi.py`
- Fields: `name`, `unit`, `target`, `owner_group_id`, `visible_group_ids`, `uuid`.
- Helper `record_measurement(value, date)` placeholder raising `NotImplementedError` (document future story).

### `hub/addons/traction/models/__init__.py`
- Import new models.

### `hub/addons/traction/security/ir.model.access.csv`
- ACL entries for To-Dos and KPIs (facilitator/leadership write; visibility-driven read).

### `hub/addons/traction/security/traction_security.xml`
- Extend record rules to include new models, mirroring issues/rocks logic.

### `hub/addons/traction/views/traction_todo_views.xml`
- Tree/Form views with filters (My To-Dos, Overdue, Completed).

### `hub/addons/traction/views/traction_scorecard_kpi_views.xml`
- Tree/Form views highlighting unit/target and owner group.

### `hub/addons/traction/tests/test_traction_todo.py`
- SavepointCase tests covering state transitions, ACLs, visibility, UUID.

### `hub/addons/traction/tests/test_traction_scorecard_kpi.py`
- SavepointCase tests covering CRUD, visibility, `record_measurement` placeholder, ACLs.

### `hub/addons/traction/__manifest__.py`
- Reference new models/views/tests.

## 4. Required Implementation

### Model Behaviors
- Ensure To-Do `state` defaults to `open`; transitions to `done`/`cancelled` with logging.
- Prevent reopening closed To-Dos unless intentionally allowed (document choice).
- Scorecard `target` must be non-negative; enforce via SQL constraint.
- Keep `owner_group_id` automatically in `visible_group_ids`.

### Security & ACLs
- Reuse pattern from prior models; ensure read restricted to `visible_group_ids` or admins.
- Facilitators/leadership write/unlink; others read-only.

### Testing Requirements
- SavepointCase verifying CRUD, state transitions, ACL enforcement, visibility, and `record_measurement` raising `NotImplementedError`.
- Use synthetic data, docstrings referencing `TRACTION-ITEMS-CORE`.

### Views & UX
- Add field groups for ownership/visibility and metrics.
- Optional Kanban placeholder (document TODO if deferred).

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
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
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


