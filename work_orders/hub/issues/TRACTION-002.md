# Issue Draft: [WORK ORDER] TRACTION-002 – Canonical Issues Model & Escalation Behavior

**Work Order ID:** TRACTION-002  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Implement the `traction.issue` canonical model with ownership/visibility controls, escalation/cascade behaviors, ACLs, and unit tests.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-001-core-groups`  
**New Branch:** `feature/TRACTION-002-issues-model`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-001-core-groups
git pull origin feature/TRACTION-001-core-groups
git checkout -b feature/TRACTION-002-issues-model
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/issue.py`
- Define `traction.issue` fields: `name`, `description`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `lifecycle_state`, `responsible_id`, `uuid`.
- Auto-generate `uuid` (ensure uniqueness via SQL constraint) and default `lifecycle_state = 'new'`.
- Implement `action_escalate(to_group)` and `action_cascade(to_group)` as per Story, logging chatter messages.
- Provide helper `_create_meeting_link(meeting, section)` raising NotImplementedError until TRACTION-006 (document dependency).

### `hub/addons/traction/models/__init__.py`
- Import issue model.

### `hub/addons/traction/security/ir.model.access.csv`
- ACL entries for `traction.issue` (facilitator/leadership write; others read based on visibility).

### `hub/addons/traction/security/traction_security.xml`
- Record rules enforcing visibility: read allowed if user’s groups intersect `visible_group_ids` or user is admin.
- Write allowed only if user in facilitator group of `owner_group_id` or admin.

### `hub/addons/traction/tests/test_traction_issue.py`
- SavepointCase tests covering CRUD, escalation/cascade behavior, visibility, and ACL enforcement.

### `hub/addons/traction/__manifest__.py`
- Reference new model and security/test files.

## 4. Required Implementation

### Model Implementation
- Consider inheriting `mail.thread` / `mail.activity.mixin` (docstring documenting decision).  
- Validation: escalate/cascade cannot target same group; raise `UserError`.
- Ensure `visible_group_ids` always contains `owner_group_id`.
- Provide helper to ensure multi-tenancy compliance (no cross-company data).

### Security & ACLs
- ACL entries mirror patterns from TRACTION-001.
- Record rule domains optimized for performance (use partner groups caching if required).
- Document assumptions if facilitator-user mapping requires additional model fields.

### Testing Requirements
- SavepointCase tests must validate:
  - Creation auto-generates UUID.
  - Escalation updates owner, adds destination to visibility, logs message.
  - Cascades add visibility without changing owner.
  - Non-visible user raises `AccessError` on read.
  - Non-facilitator cannot write/escalate.
  - Invalid inputs raise `UserError`.
- Use synthetic users/groups; docstrings reference `TRACTION-ITEMS-CORE`.

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


