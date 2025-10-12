# Issue Draft: [WORK ORDER] TRACTION-006 – Meeting Item Linking & Snapshot Context

**Work Order ID:** TRACTION-006  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Implement the `traction.meeting_item_link` junction model to connect meetings with canonical items, capture per-meeting context, and support escalations/cascades.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-005-meetings`  
**New Branch:** `feature/TRACTION-006-meeting-links`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-005-meetings
git pull origin feature/TRACTION-005-meetings
git checkout -b feature/TRACTION-006-meeting-links
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/meeting_item_link.py`
- Fields per Story: `meeting_id`, `item_model`, `item_id` (Reference), `section`, `status_at_meeting`, `assignee_at_meeting`, `notes_snapshot`, `escalated_from`, `escalated_to`, `carried_over_from`.
- Unique constraint on (`meeting_id`, `item_model`, `item_id`, `section`).
- Methods `link_item(item_record, section)` and `cascade_to(meeting)` capturing snapshot data and escalation metadata.

### `hub/addons/traction/models/__init__.py`
- Import link model.

### Canonical item models (issues/rocks/todos/kpi)
- Implement helper `_create_meeting_link(meeting, section, **kwargs)` to instantiate link.
- Update escalation/cascade methods to optionally accept meeting context and call helper (document if implemented here or deferred to TRACTION-007).

### `hub/addons/traction/security/ir.model.access.csv`
- ACL entries allowing facilitators/leadership to create/write links; others read if part of meeting.

### `hub/addons/traction/security/traction_security.xml`
- Record rules restricting read/write to meeting group members or admins; writes limited to facilitators.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Add embedded tree or smart button showing linked items with columns (section, item, status, assignee).
- Provide action to create link referencing canonical items.

### `hub/addons/traction/tests/test_traction_meeting_link.py`
- SavepointCase tests covering linking, uniqueness, snapshot capture, cascade creation, and ACL enforcement.

### `hub/addons/traction/__manifest__.py`
- Reference new files.

## 4. Required Implementation

### Linking Behaviour
- Use `fields.Reference` limited to canonical models.
- Validate `section` against meeting agenda constant; raise `UserError` on invalid values.
- Snapshot relevant fields (status, assignee, notes) from canonical item.
- `cascade_to` should create link in destination meeting, copying snapshot data and updating escalation fields.
- Ensure helper on canonical models handles meeting context gracefully (may stub for TRACTION-007 if needed; document).

### Security & ACLs
- Read restricted to meeting group members/leaders; write restricted to facilitators.
- Enforce uniqueness via SQL constraint.

### Testing Requirements
- SavepointCase verifying:
  - Linking each item type to meeting.
  - Duplicate link prevented.
  - Snapshot data captured correctly.
  - Cascading to new meeting replicates link with updated metadata.
  - ACL behavior (non-facilitator cannot create link; non-member cannot read).
- Docstrings reference `TRACTION-MEETINGS-MVP` and `TRACTION-ITEMS-CORE`.

### UI Integration
- Meeting form displays linked items; allow open canonical item action.
- Provide tooltip summarizing escalation status.

## 5. Acceptance Criteria

- [ ] All requirements implemented.  
- [ ] Code follows `01-odoo-coding-standards.md`.  
- [ ] Code is tenancy-aware per ADR-006.  
- [ ] Tests written and passing.  
- [ ] Odoo boots without errors (MANDATORY).  
- [ ] Proof of execution logs captured.  
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/hub/traction/MEETINGS_MVP_STORY.yaml`
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


