---
title: "[FEATURE] TRACTION-005: Meeting Model & Agenda Flow"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-005 – Meeting Model & Agenda Flow

## 1. Context & Objective

Implement the `traction.meeting` model, EOS agenda order handling, section notes, meeting completion workflow, and base facilitator permissions per Meetings MVP story.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-004-todos-kpis  
**New Branch:** feature/TRACTION-005-meetings

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-004-todos-kpis
git pull origin feature/TRACTION-004-todos-kpis
git checkout -b feature/TRACTION-005-meetings
```

**Note:** Rebase onto latest main once upstream work orders merge.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/meeting.py`
- Define `traction.meeting` with fields:
  - `name`, `group_id` (Many2one `traction.group`), `scheduled_date`, `agenda_state` (selection matching order), `state` (draft|in_progress|done|cancelled), `facilitator_id` (Many2one res.users), `section_notes` (JSON or separate model), `completed_at`.
- Implement method `action_start()`, `action_next_section()`, `action_prev_section()`, `action_complete()` honoring EOS order defined in Story.
- Store section notes per agenda section; consider JSON field or separate One2many (document approach). MVP may use JSON stored in `section_notes` (dict) with computed helpers.
- Enforce agenda order: `action_next_section` cannot skip sections; state machine ensures sequential flow.
- Emit TODO stub for events on completion (log message + TODO comment referencing future event implementation).

### `hub/addons/traction/models/__init__.py`
- Import meeting model.

### `hub/addons/traction/security/ir.model.access.csv`
- Add ACL entry: facilitators and leadership can create/update meetings; other group members read-only.

### `hub/addons/traction/security/traction_security.xml`
- Record rules ensuring only members of meeting’s group (or admins) can read/write; facilitators limited to own group.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Provide tree/form views reflecting EOS agenda order and section notes UI (tab per section). Buttons for Start, Next Section, Previous Section, Complete.
- Show linked items smart buttons (placeholder; actual linking delivered in TRACTION-006).

### `hub/addons/traction/data/traction_meeting_sequences.xml`
- Optional: add sequence for meeting `name` auto-generation (e.g., `L10 Meeting - {Group Code} - {Date}`).

### `hub/addons/traction/tests/test_traction_meeting.py`
- SavepointCase tests for meeting lifecycle, agenda navigation, note persistence, ACL enforcement.

### `hub/addons/traction/__manifest__.py`
- Reference new models/views/security/data/tests.

---

## 4. Required Implementation

### Meeting Lifecycle & Agenda
- Use Story agenda order: segue → scorecard → rocks_review → customer_employee_headlines → to_do_list → IDS → conclude.
- Represent order via Python list constant; enforce transitions accordingly.
- `action_start` sets `state` to `in_progress`, `agenda_state` to first section; requires facilitator.
- `action_next_section` moves to next section only if current notes captured (optional validation; document choice). Prevent beyond final section unless finishing.
- `action_prev_section` allows going back to previous section (no wrap-around).
- `action_complete` only allowed when agenda_state == conclude; sets `state` to `done`, captures `completed_at`, logs message, triggers placeholder for events.
- Provide method `write_section_notes(section, notes)` to update notes dictionary with validation that section is valid; store data in JSON field (use `fields.Serialized` or `Json` per Odoo 18). Ensure serialization respects multi-tenancy.

### Security & ACLs
- Meetings visible only to users belonging to `group_id` or leadership; facilitators can modify; others read-only.
- Record rule ensuring `group_id.member_ids` contains user for read; write restricted to facilitator of group or admin.
- Validate facilitator assigned must belong to `group_id`; enforce in create/write.

### Testing Requirements
- SavepointCase tests covering:
  - Meeting creation requires valid group and facilitator membership.
  - Agenda navigation: start → next through entire sequence → complete; previous section functionality.
  - Notes persistence: calling helper saves notes per section; retrieving them returns latest value.
  - Security: non-group members cannot read; non-facilitators cannot write.
  - `action_complete` raises error if not at conclude section.
- Ensure tests use synthetic data; docstrings reference `TRACTION-MEETINGS-MVP`.

### UX & Documentation
- Views align with Story mockup (tab per section, statusbar at top showing progression).
- Buttons should have `states` attribute to control visibility (e.g., Start visible in draft; Next/Prev in progress; Complete on final section).
- Add helper tooltips referencing EOS agenda names.
- Document in code where event emission will occur (TODO referencing acceptance criterion).

---

## 5. Acceptance Criteria

- [ ] `traction.meeting` model implemented with required fields, agenda control, notes storage.
- [ ] Start/Next/Previous/Complete actions enforce EOS order and state machine.
- [ ] Notes persist per section and survive navigation.
- [ ] Security rules restrict access to group members; facilitators manage meetings; tests cover ACLs.
- [ ] Views provide tabbed agenda interface with action buttons and statusbar.
- [ ] Unit tests cover lifecycle, notes, ACLs, error scenarios; 0 failures.
- [ ] Code references story ID, respects coding standards, <500 LOC per change.
- [ ] Descriptive commits for models, views, security, tests.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests, boot, upgrade).

---

## 6. Context Management & Iteration Limits

Follow standard workflow; escalate if JSON storage approach conflicts with data model expectations or if agenda UI requires design input.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/MEETINGS_MVP_STORY.yaml`
- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Keep agenda helper constants centralized for reuse by linking model (next work order).
- Ensure JSON/Serialized field works with Odoo 18 (use `fields.Serialized` or `fields.Json` depending on version support).
- Maintain multi-tenancy readiness; avoid cross-company data leakage.

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


