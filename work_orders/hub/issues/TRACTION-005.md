# Issue Draft: [WORK ORDER] TRACTION-005 – Meeting Model & Agenda Flow

**Work Order ID:** TRACTION-005  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Implement the `traction.meeting` model, EOS agenda progression, section notes storage, and facilitator permissions per Meetings MVP story.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-004-todos-kpis`  
**New Branch:** `feature/TRACTION-005-meetings`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-004-todos-kpis
git pull origin feature/TRACTION-004-todos-kpis
git checkout -b feature/TRACTION-005-meetings
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/meeting.py`
- Fields: `name`, `group_id`, `scheduled_date`, `agenda_state`, `state`, `facilitator_id`, `section_notes` (Serialized/JSON), `completed_at`.
- Methods: `action_start()`, `action_next_section()`, `action_prev_section()`, `action_complete()`, `write_section_notes(section, notes)` enforcing EOS order from Story.
- Validate facilitator belongs to group; log completion stub for future events.

### `hub/addons/traction/models/__init__.py`
- Import meeting model.

### `hub/addons/traction/security/ir.model.access.csv`
- ACL: facilitators/leadership write/unlink; group members read-only.

### `hub/addons/traction/security/traction_security.xml`
- Record rules restricting read/write to meeting group membership or admin; facilitators manage meetings.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Tabbed agenda sections, statusbar for EOS steps, action buttons for Start/Next/Prev/Complete, placeholder smart button for linked items.

### `hub/addons/traction/data/traction_meeting_sequences.xml`
- Optional sequence for meeting naming (document if omitted).

### `hub/addons/traction/tests/test_traction_meeting.py`
- SavepointCase tests covering lifecycle, agenda navigation, notes persistence, ACLs.

### `hub/addons/traction/__manifest__.py`
- Include new files.

## 4. Required Implementation

### Meeting Lifecycle
- Define agenda order constant: `['segue', 'scorecard', 'rocks_review', 'customer_employee_headlines', 'to_do_list', 'IDS', 'conclude']`.
- `action_start` sets `state = 'in_progress'`, `agenda_state` to first item.
- Next/Prev actions enforce sequence boundaries (raise `UserError` on invalid transitions).
- `action_complete` allowed only when `agenda_state == 'conclude'`; sets `state = 'done'`, timestamps completion, logs message (TODO for event emission).
- Store section notes in serialized dict keyed by agenda sections; include helpers to fetch/update.

### Security & ACLs
- Read restricted to meeting group members (or admins/leadership).
- Write restricted to facilitator for given group; enforce facilitator assignment on create/write.
- Ensure multi-tenancy compliance (no cross-company leakage).

### Testing Requirements
- SavepointCase verifying:
  - Meeting creation with valid group/facilitator.
  - Agenda navigation sequence, including error conditions.
  - Notes saved/retrieved per section.
  - ACL enforcement for read/write.
  - Completion allowed only at `conclude` stage.
- Docstrings reference `TRACTION-MEETINGS-MVP`.

### UX
- Views align with Story (tabs per section, actionable buttons). Document deviations if any.

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


