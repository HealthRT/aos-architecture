---
title: "[FEATURE] TRACTION-002: Canonical Issues Model & Escalation Behavior"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-002 – Canonical Issues Model & Escalation Behavior

## 1. Context & Objective

Implement the `traction.issue` canonical model with ownership/visibility fields, escalation/cascade behaviors, ACLs, and comprehensive unit tests per the Items Core story.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-001-core-groups  
**New Branch:** feature/TRACTION-002-issues-model

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-001-core-groups
git pull origin feature/TRACTION-001-core-groups
git checkout -b feature/TRACTION-002-issues-model
```

**Note:** Rebase onto latest main once TRACTION-001 merges. Coordinate with Scrum Master before merging branches out of order.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/issue.py`
- Create `traction.issue` model implementing fields from Story:
  - `name`, `description`, `owner_group_id`, `visible_group_ids`, `origin_group_id`, `lifecycle_state`, `responsible_id`, `uuid`.
- Enforce UUID generation on create (use `uuid4`), ensure uniqueness via SQL constraint.
- Provide methods: `action_escalate(to_group)` and `action_cascade(to_group)` respecting business rules.
- Provide helper to link with meetings (`_create_meeting_link(meeting, section)` placeholder raising `NotImplementedError` until meeting model exists; document dependency on TRACTION-004).

### `hub/addons/traction/models/__init__.py`
- Import new issue module.

### `hub/addons/traction/security/ir.model.access.csv`
- Add ACL entries for `traction.issue` aligning with permissions (facilitator write; visibility determines read).

### `hub/addons/traction/security/traction_security.xml`
- Add record rules to enforce visibility and ownership:
  - Read: user’s groups intersect with `visible_group_ids` OR user is admin.
  - Write: user in facilitator group of `owner_group_id` OR admin.

### `hub/addons/traction/tests/test_traction_issue.py`
- Implement SavepointCase tests for CRUD, escalation/cascade behaviors, visibility rules, and UUID generation.

### `hub/addons/traction/__manifest__.py`
- Ensure new model file added under `data`/`depends` if necessary (e.g., depends on `mail` for chatter? Evaluate and document).

---

## 4. Required Implementation

### Model Implementation
- `_name = "traction.issue"`, `_description`, `_inherit = ['mail.thread', 'mail.activity.mixin']` (if communication required; confirm with Architect; otherwise document decision).
- `owner_group_id`, `visible_group_ids`, `origin_group_id` Many2one/Many2many referencing `traction.group` (from TRACTION-001).
- `lifecycle_state` selection with default `new`.
- `uuid` field auto-generated; set `tracking=True` for key fields as needed.
- Implement `action_escalate`:
  - Update `owner_group_id` to target group
  - Ensure target group added to `visible_group_ids`
  - Log message in chatter per ADR-003 guidelines
- Implement `action_cascade`:
  - Add target group to `visible_group_ids` (without changing owner)
  - Log message about cascade
- Provide guardrails for invalid inputs (e.g., escalate to same group raises `UserError`).
- Document references to Story `TRACTION-ITEMS-CORE` in docstrings.

### Security & ACLs
- ACL: facilitators/leadership can create/write/unlink; others read if visible.
- Record rule for read: domain `[('|', ('visible_group_ids', 'in', user.traction_group_ids), ('owner_group_id.member_ids', 'in', user.id))]` – adjust for performance; ensure multi-tenancy safe.
- Record rule for write: `owner_group_id.facilitator_ids` (if field exists) or user in facilitator group (use security group).
- Add TODO/ comment linking to future features for more granular ownership if not yet available.

### Testing Requirements
- Use SavepointCase to verify:
  - Creation auto-generates UUID and defaults states.
  - Escalation updates owner, adds visibility, logs message, and respects ACL (only facilitator can escalate).
  - Cascade adds visibility but does not change owner.
  - Non-visible user cannot read issue (AccessError).
  - Non-owner facilitator cannot write unless they belong to owner group.
- Include tests for invalid escalate/cascade inputs (e.g., missing group, duplicates).
- Provide factory helpers to create groups, users, and issues for tests.
- Follow testing standards: docstrings referencing acceptance criteria, `flush()` after writes where needed.

### Documentation Comments
- Inline docstrings referencing Story, highlight dependency on `traction.meeting` linking for future WOs.
- Update README or module documentation if needed (optional; note in TODO for docs work order).

---

## 5. Acceptance Criteria

- [ ] `traction.issue` model implemented with all fields and UUID generation.
- [ ] Escalate and cascade behaviors implemented with correct rules and logging.
- [ ] ACLs enforce visibility and ownership requirements (read vs write separation).
- [ ] Record rules prevent unauthorized read/write; tests cover positive/negative cases.
- [ ] Unit tests exercising CRUD, escalation, cascade, and security pass with 0 failures.
- [ ] Code references Story ID in docstrings and adheres to coding standards.
- [ ] Branch includes descriptive commits for models, security, tests.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Follow template workflow (Implementation → Testing → Bug fixing ≤2 iterations). Escalate if record rules conflict with other modules or multi-tenancy requirements.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Ensure multi-tenancy readiness (no direct references to company-specific data; void duplicates via UUID).
- Align with Odoo mail mixins usage if enabling chatter; otherwise document deviation.
- Keep file changes <500 LOC; break into multiple commits if necessary.

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
- Attach full test output (0 failures, test counts, duration).

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


