---
title: "[FEATURE] TRACTION-004: To-Dos & Scorecard KPI Models"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-004 – To-Dos & Scorecard KPI Models

## 1. Context & Objective

Implement the remaining canonical item models `traction.todo` and `traction.scorecard.kpi`, with ownership/visibility attributes, behaviors, ACLs, and tests, building atop TRACTION-001/002/003 foundations.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-003-rocks  
**New Branch:** feature/TRACTION-004-todos-kpis

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-003-rocks
git pull origin feature/TRACTION-003-rocks
git checkout -b feature/TRACTION-004-todos-kpis
```

**Note:** Rebase onto latest main once upstream branches merge.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/todo.py`
- Define `traction.todo` model fields: `name`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `assignee_id`, `due_date`, `state`, `uuid`.
- Auto-generate UUID, default `state='open'`, maintain state transitions (complete/cancel).
- Provide methods `action_mark_done()` and `action_cancel()` with audit logging.

### `hub/addons/traction/models/scorecard_kpi.py`
- Define `traction.scorecard.kpi` model fields: `name`, `unit`, `target`, `owner_group_id`, `visible_group_ids`, `uuid`.
- Provide helper `record_measurement(value, date)` stub (raise NotImplementedError) with TODO referencing future measurement model.

### `hub/addons/traction/models/__init__.py`
- Import new models.

### `hub/addons/traction/security/ir.model.access.csv`
- Add ACL entries for new models matching patterns (facilitator write; visibility-based read).

### `hub/addons/traction/security/traction_security.xml`
- Extend record rules from previous WOs to include todo and scorecard models.

### `hub/addons/traction/views/traction_todo_views.xml`
- Provide basic tree/form views for To-Dos with filters (My To-Dos, Overdue, Completed).

### `hub/addons/traction/views/traction_scorecard_kpi_views.xml`
- Provide tree/form views for KPIs showing name, unit, target, owner group.

### `hub/addons/traction/tests/test_traction_todo.py`
- SavepointCase tests covering state transitions, ACLs, visibility, UUIDs.

### `hub/addons/traction/tests/test_traction_scorecard_kpi.py`
- SavepointCase tests covering creation, visibility, helper stub raising NotImplementedError, ACL checks.

### `hub/addons/traction/__manifest__.py`
- Reference new models/views/tests.

---

## 4. Required Implementation

### Model Behaviors
- Use mail mixins if notes/logging required; otherwise document omission.
- For To-Dos:
  - Default due_date optional; ensure timezone-safe handling.
  - `action_mark_done` sets `state` to `done`, logs message, enforces only owner/facilitator can call.
  - `action_cancel` sets `state` to `cancelled`, logs message.
  - Prevent reopening done/cancelled via constraints or raise `UserError` unless explicitly allowed.
- For KPIs:
  - `target` positive float; add SQL constraint `target >= 0`.
  - Provide computed field or method placeholder for performance metrics (document future scope).
  - `record_measurement` placeholder raises NotImplementedError with message referencing upcoming story.

### Security & ACLs
- Reuse existing record rule patterns; ensure new models referenced.
- Confirm visibility logic via tests (users not in `visible_group_ids` cannot read, etc.).
- Facilitators/leadership groups can create/write/unlink; others read-only if visible.

### Testing Requirements
- SavepointCase tests must cover:
  - CRUD for to-dos and KPIs.
  - To-Do state transitions (open → done, open → cancelled) with ACL enforcement.
  - ACL restrictions for non-facilitators.
  - `record_measurement` raising NotImplementedError (with explicit assert message) to document dependency.
  - Visibility rules for both models.
  - UUID uniqueness.
- Follow `08-testing-requirements` (docstrings, synthetic data, no PHI).

### Views & UX
- Basic forms include sections for ownership/visibility and additional fields.
- Add Kanban/TODO view placeholders only if manageable within LOC budget; else comment referencing future UI story.

---

## 5. Acceptance Criteria

- [ ] `traction.todo` and `traction.scorecard.kpi` models implemented with required fields and behaviors.
- [ ] State transition helpers (`action_mark_done`, `action_cancel`) operational with logging.
- [ ] Security/ACLs mirror prior canonical models and enforce visibility/ownership.
- [ ] Views allow CRUD while respecting security (group visibility on fields/menus where appropriate).
- [ ] SavepointCase tests cover behaviors, ACLs, visibility, and measurement stub.
- [ ] Code references Story ID, adheres to standards, <500 LOC per changeset.
- [ ] Descriptive commits covering models, security, views, tests.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Follow standard workflow with max two bug-fix iterations. Escalate if ACL rules conflict with prior models or multi-tenancy requirements.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Maintain consistent visibility logic across all item models.
- Use mixins/utilities from earlier work orders to avoid duplication (consider abstract base class for canonical items; document if added).
- Keep code under 500 LOC; split features if necessary.

---

## 8. MANDATORY: Proof of Execution

### 8.1 Test Execution
```bash
cd /home/james/development/aos-development
docker compose exec hub odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d hub \
  --test-enable \
  --stop-after-init \
  -i traction \
  --log-level=test:INFO
```
- Attach test results (0 failures, counts, duration).

### 8.2 Boot Verification
```bash
# This is now handled by the test runner. If boot fails, the test will fail.
# No separate action is needed unless specified for manual inspection.
```

### 8.3 Module Upgrade Test
```bash
# This is now handled by the test runner, which performs a clean install.
# No separate action is needed unless specified for manual inspection.
```

If the `run-tests.sh` script fails, do not attempt to fix it. Escalate immediately.

Escalate if Docker unavailable.


