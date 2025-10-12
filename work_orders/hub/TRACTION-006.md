---
title: "[FEATURE] TRACTION-006: Meeting Item Linking & Escalation Cascade"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-006 – Meeting Item Linking & Escalation Cascade

## 1. Context & Objective

Implement the `traction.meeting_item_link` junction model to connect meetings with canonical items, support escalations/cascades, and ensure per-meeting context snapshots per Meetings MVP.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-005-meetings  
**New Branch:** feature/TRACTION-006-meeting-links

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-005-meetings
git pull origin feature/TRACTION-005-meetings
git checkout -b feature/TRACTION-006-meeting-links
```

**Note:** Rebase onto main once prior work orders merge.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/meeting_item_link.py`
- Implement `traction.meeting_item_link` with fields per Story:
  - `meeting_id` (Many2one `traction.meeting`)
  - `item_model` (selection: issue|rock|todo|scorecard_kpi)
  - `item_id` (Reference or dynamic Many2one via computed field; consider using `fields.Reference`)
  - `section` (selection matching agenda order constant from meeting model)
  - `status_at_meeting` (selection or char)
  - `assignee_at_meeting` (Many2one `res.users`)
  - `notes_snapshot` (Text)
  - `escalated_from` (Many2one `traction.group`)
  - `escalated_to` (Many2one `traction.group`)
  - `carried_over_from` (Many2one `traction.meeting`)
- Provide constraints ensuring `item_model`/`item_id` combination unique per meeting and valid combination.
- Provide methods `link_item(item_record, section)` and `cascade_to(meeting)` to populate snapshot data, respecting escalate/cascade behaviours.

### `hub/addons/traction/models/__init__.py`
- Import meeting item link model.

### Update canonical item models (issues/rocks/todos/kpis)
- Implement helper method `_create_meeting_link(meeting, section, **kwargs)` to instantiate link using new model.
- Update escalation/cascade methods to optionally create links in destination meetings as per Story (for cascades). Document behaviour where meeting passed in context.

### `hub/addons/traction/security/ir.model.access.csv`
- ACL entry allowing facilitators/leadership to create/update meeting links; others read if part of meeting.

### `hub/addons/traction/security/traction_security.xml`
- Record rules ensuring only members of meeting’s group (or admin) can read links; write restricted to facilitators.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Add smart button or embedded tree within meeting form to display linked items (with section field). Integrate basic create button linking existing items.

### `hub/addons/traction/tests/test_traction_meeting_links.py`
- SavepointCase tests covering linking, cascades, escalations, visibility, and uniqueness.

### `hub/addons/traction/__manifest__.py`
- Reference new model, views, security, tests.

---

## 4. Required Implementation

### Linking Behaviour
- Use `fields.Reference` for `item_id` referencing canonical models; ensure domain limits to allowed models.
- Provide computed helper `_get_item_record()` to retrieve actual record from reference.
- `link_item` should:
  - Validate section matches meeting agenda constant.
  - Snapshot current status/assignee/notes (call methods on item model if available; else read fields directly).
  - Record `escalated_from` default `item.origin_group_id`, `escalated_to` if provided.
  - Optionally set `carried_over_from` when linking repeated item.
- `cascade_to` should create link in destination meeting (passed as argument), copying snapshot and updating escalated fields.
- Ensure escalate/cascade methods on item models call into meeting link helper when meeting context provided (e.g., via context key `meeting_id`). Document expected usage.

### Security & ACLs
- Visibility: only users belonging to meeting’s group or leadership view links.
- Write: facilitators in meeting’s group only.
- Add SQL constraint to avoid duplicate link for same item+meeting+section.

### Testing Requirements
- Tests must cover:
  - Linking each item type to a meeting; section validation; snapshot values captured.
  - Escalation cascades create links in destination meeting with preserved history (carried_over_from, escalated fields).
  - ACL: non-facilitator cannot create link; non-group member cannot read.
  - Duplicate link creation prevented.
- Use SavepointCase, synthetic data, docstrings referencing stories.
- Ensure tests integrate with earlier models (issues/rocks/todos/kpi). Use helpers to create items and meetings.

### UI Integration
- Meeting form should display linked items in sub-tree or smart button; layout includes section column for quick navigation.
- Add action to open canonical item from link (context `active_id`).
- Provide tooltip summarizing cascade/escalation status.

---

## 5. Acceptance Criteria

- [ ] `traction.meeting_item_link` model implemented with fields, constraints, helper methods.
- [ ] Canonical item models expose helper to create meeting links and integrate with escalate/cascade flows.
- [ ] Meeting form displays linked items; facilitators can add/remove links per permissions.
- [ ] ACLs enforce visibility/write restrictions; tests cover positive/negative cases.
- [ ] SavepointCase tests cover linking, snapshotting, cascade/escalation, uniqueness, and ACLs.
- [ ] Code references Stories (`TRACTION-MEETINGS-MVP`, `TRACTION-ITEMS-CORE`) and adheres to standards.
- [ ] Descriptive commits for models, security, views, tests.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests, boot, upgrade).

---

## 6. Context Management & Iteration Limits

Standard workflow applies; escalate if reference field approach conflicts with ORM constraints or if cascade behaviour needs clarification from Architect.

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

- Ensure reference field only allows canonical models; use `_compute_allowed_models` or selection constant.
- Maintain consistent multi-tenancy safeguards; avoid cross-group leakage.
- Keep modifications <500 LOC; reuse base mixins/helpers where possible.

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
cd /home/james/development/aos-development
docker compose up -d --force-recreate hub
sleep 30
docker compose logs --tail="100" hub
```
- Provide logs showing successful boot, no errors.

### 8.3 Module Upgrade Test
```bash
docker compose exec hub odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d hub \
  -u traction \
  --stop-after-init
```
- Confirm upgrade completes without errors; summarize in handoff.

If Docker unavailable, escalate immediately.


