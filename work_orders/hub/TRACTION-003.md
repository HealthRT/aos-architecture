---
title: "[FEATURE] TRACTION-003: Rocks Model & Leadership Guardrails"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-003 – Rocks Model & Leadership Guardrails

## 1. Context & Objective

Implement the `traction.rock` canonical model with company/team/personal scopes, leadership-only “Company Rock” controls per ADMIN-003, and supporting ACL/tests.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-002-issues-model  
**New Branch:** feature/TRACTION-003-rocks

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-002-issues-model
git pull origin feature/TRACTION-002-issues-model
git checkout -b feature/TRACTION-003-rocks
```

**Note:** Rebase on `main` once upstream branches merge. Coordinate with Scrum Master if conflicts arise.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/rock.py`
- Implement `traction.rock` model with fields: `name`, `scope`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `lifecycle_state`, `responsible_id`, `due_quarter`, `is_company_rock`, `uuid`.
- Default `scope` to `team`; enforce selections from Story.
- Manage `is_company_rock` guardrail requiring leadership group membership.
- Auto-generate UUID on create; unique constraint.

### `hub/addons/traction/models/__init__.py`
- Import rock model.

### `hub/addons/traction/security/ir.model.access.csv`
- Add ACL entries mirroring issues (facilitator/leadership write, others read if visible).

### `hub/addons/traction/security/traction_security.xml`
- Add record rule preventing non-leadership users from setting `is_company_rock` to True.
- Extend read/write rules to cover `traction.rock`.

### `hub/addons/traction/views/traction_rock_views.xml`
- Create minimal tree/form views with `is_company_rock` field shown only to leadership group (use `groups` attribute).
- Include filters (My Rocks, Company Rocks) to support UI acceptance criteria from ADMIN-003.

### `hub/addons/traction/tests/test_traction_rock.py`
- Add SavepointCase tests verifying ACLs, leadership guardrails, UUID generation, and scope transitions.

### `hub/addons/traction/__manifest__.py`
- Reference new views/security/test files.

---

## 4. Required Implementation

### Model & Behavior
- `_name = "traction.rock"`, `_inherit` mail mixins if communication required (document decision).
- `is_company_rock` default False; `scope` selection `company|team|personal`.
- `lifecycle_state` selection per Story; default `planned`.
- Override `write`/`create` to check if `is_company_rock` True → user must belong to `traction.group_leadership`; raise `AccessError` otherwise.
- Provide helper methods: `action_mark_on_track()`, `action_mark_off_track()` (optional but recommended). Document if deferred.
- Ensure `visible_group_ids` updated similarly to issues (pull helper from mixin if created; else mimic logic).

### UI & Security
- Views hide `is_company_rock` unless user in leadership group; add helpful tooltip referencing requirement.
- Record rule ensures read access limited to `visible_group_ids` or owner group; write limited to facilitator/leadership of owner group.
- For leadership guardrail, add separate record rule or override that blocks writes when `is_company_rock` True and user lacks leadership group.
- Update menu (if needed) to expose Rocks (can be placeholder; ensure not conflicting with later UI WOs).

### Testing Requirements
- SavepointCase tests covering:
  - Leadership user can set `is_company_rock` True; non-leadership receives `AccessError`.
  - Read/write rules respect visibility/owner.
  - UUID generated and unique.
  - Lifecycle transitions (optional) maintain audit logging (if implemented).
- UI security test verifying XML uses `groups` attribute (via `env['ir.ui.view']._check_groups()` or by loading view and verifying field attributes). Alternatively, ensure business logic test ensures field hidden for non-leadership by simulating view raise (document approach).
- Follow `08-testing-requirements` (docstrings, deterministic data, no PHI).

### Documentation Comments
- Docstrings referencing `TRACTION-ITEMS-CORE` and `ADMIN-003`.
- If helper mixins introduced, ensure they’re reusable for other item models.

---

## 5. Acceptance Criteria

- [ ] `traction.rock` model created with required fields and UUID handling.
- [ ] Leadership-only guardrail prevents unauthorized Company Rocks (backend + view restrictions).
- [ ] ACL and record rules enforce visibility/ownership correctly.
- [ ] Views expose `is_company_rock` only to leadership group.
- [ ] SavepointCase tests cover CRUD, guardrails, ACLs, and visibility.
- [ ] Code follows standards, includes Story references, under 500 LOC per diff.
- [ ] Descriptive commits for models, security, views, tests.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Use standard workflow: Implementation → Tests → Bug fixing (≤2 iterations). Escalate if leadership guardrail conflicts with global security policies.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/user_stories/hub/traction/ADMIN-003.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Maintain multi-tenancy readiness (no assumptions about single company beyond seeded data).
- Ensure security rules do not cause performance issues (index on `code` or use prefetch). Optimize domain if necessary.
- Keep changes limited (<500 LOC) by reusing helper mixins where possible.

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
- Attach test output (0 failures, counts, duration).

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

Escalate if Docker unavailable; proof steps are mandatory.


