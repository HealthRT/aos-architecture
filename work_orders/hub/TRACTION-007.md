---
title: "[FEATURE] TRACTION-007: Meeting Escalation & Cascade Automation"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-007 – Meeting Escalation & Cascade Automation

## 1. Context & Objective

Finalize escalation/cascade workflows by integrating canonical item actions with meeting context, ensuring history preservation and cross-group visibility per Meetings MVP.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-006-meeting-links  
**New Branch:** feature/TRACTION-007-escalation-automation

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-006-meeting-links
git pull origin feature/TRACTION-006-meeting-links
git checkout -b feature/TRACTION-007-escalation-automation
```

**Note:** Rebase after prior work orders merge.

---

## 3. Problem Statement & Technical Details

### Canonical item models (issue/rock/todo/kpi)
- Enhance `action_escalate` and `action_cascade` to:
  - Accept optional `meeting_id` and `section` context parameters.
  - Create meeting link in destination meeting via `_create_meeting_link` helper (from TRACTION-006).
  - Update `origin_group_id` for escalations; maintain `visible_group_ids` for cascades.
  - Log chatter messages summarizing action, including meeting reference if provided.

### `hub/addons/traction/models/meeting.py`
- Add helper `escalate_item(item, to_group)` and `cascade_item(item, to_group)` for orchestrating flows from meeting UI.
- Ensure methods call item actions with meeting context, update meeting link records accordingly.

### `hub/addons/traction/controllers/meeting_controller.py` (new optional, if API needed)
- If API endpoints required for agenda navigation or linking, implement per ADR-003; otherwise document TODO.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Add buttons/actions to escalate or cascade selected linked item to another group, triggering server actions.
- Provide wizard/modal if necessary (create simple transient model `traction.meeting.escalate.wizard` for user to choose destination group). Keep under LOC limit; if too large, stub with TODO referencing future UI story.

### `hub/addons/traction/tests/test_traction_escalation.py`
- SavepointCase tests covering combined escalation/cascade scenarios from meeting context, verifying link creation, visibility updates, and chatter messages.

### `hub/addons/traction/__manifest__.py`
- Reference new tests/views/wizards if added.

---

## 4. Required Implementation

### Business Logic
- Ensure escalated items add target group to `visible_group_ids` and set `owner_group_id` to destination.
- Cascades add destination to `visible_group_ids` without changing owner.
- Meeting helper methods should:
  - Validate current user facilitator privileges.
  - Create meeting link in destination meeting if provided.
  - Update existing link’s `escalated_to` or `carried_over_from` fields.
- Preserve history by posting chatter messages on both source item and meeting (use `message_post` with summary and link to meeting).
- Ensure operations are transaction-safe; use `with self.env.cr.savepoint()` where appropriate.

### Testing Requirements
- Tests must validate:
  - Escalating an issue from meeting A to group B creates new meeting link in group B’s meeting (if provided) and updates item owner/visibility.
  - Cascading a to-do adds visibility without altering ownership; meeting link recorded correctly.
  - Chatter entries/log messages created with correct content (assert using `message_ids`).
  - Security: only facilitator can escalate/cascade via meeting helper; unauthorized user receives `AccessError`.
  - Edge cases: escalate to same group (should raise `UserError`), missing meeting context still updates item but logs note.
- Follow testing standards (docstrings, SavepointCase, synthetic data).

### UI Considerations
- If wizard added, ensure minimal fields (destination group, optional destination meeting) and respect security groups.
- Add TODO if UX flows require dedicated design beyond current scope.

---

## 5. Acceptance Criteria

- [ ] Item escalation/cascade methods accept meeting context and create/update meeting links accordingly.
- [ ] Meeting helpers allow facilitators to escalate/cascade linked items with proper ACL enforcement.
- [ ] Chatter entries/logs capture escalation/cascade history, including meeting references.
- [ ] Tests cover combined workflows, ACLs, and edge cases; 0 failures.
- [ ] Views (or wizard) enable facilitator-driven escalation from meeting UI (or TODO documented if deferred, with backend support complete).
- [ ] Code references Stories, adheres to standards, stays <500 LOC per change.
- [ ] Descriptive commits capture logic, tests, UI updates.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (tests, boot, upgrade).

---

## 6. Context Management & Iteration Limits

Standard workflow/iteration limits apply; escalate if meeting link dependencies require architecture updates.

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

- Maintain compatibility with prior work orders; avoid breaking item methods used elsewhere.
- Keep wizard/UI optional if it threatens LOC budget; backend must still support CLI/API triggers.
- Multi-tenancy readiness: ensure group and meeting references scoped to tenant.

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
- Provide logs showing successful boot and module load.

### 8.3 Module Upgrade Test
```bash
docker compose exec hub odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d hub \
  -u traction \
  --stop-after-init
```
- Confirm upgrade completes without errors; summarize.

Escalate if Docker unavailable.


