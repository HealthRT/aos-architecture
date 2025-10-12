# Issue Draft: [WORK ORDER] TRACTION-007 – Meeting Escalation & Cascade Automation

**Work Order ID:** TRACTION-007  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Enhance canonical item escalation/cascade workflows to integrate with meeting context, update meeting links, and preserve history per Stories.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-006-meeting-links`  
**New Branch:** `feature/TRACTION-007-escalation-automation`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-006-meeting-links
git pull origin feature/TRACTION-006-meeting-links
git checkout -b feature/TRACTION-007-escalation-automation
```

## 3. Problem Statement & Technical Details

### Canonical item models (issue/rock/todo/kpi)
- Update `action_escalate` / `action_cascade` to accept optional `meeting_id`, `section` context.
- Invoke `_create_meeting_link` helper to create/update meeting links in destination meeting.
- Update `origin_group_id` (escalate) and `visible_group_ids` (cascade) per requirements.
- Add chatter messages summarizing action and meeting reference.

### `hub/addons/traction/models/meeting.py`
- Add helpers `escalate_item(item, to_group, section=None)` / `cascade_item(item, to_group, section=None)` validating facilitator rights and orchestrating item methods + meeting links.

### Optional wizard (if needed)
- `hub/addons/traction/wizard/meeting_escalate_wizard.py` (if UI requires selecting target group/meeting). Keep minimal; document if deferred.

### `hub/addons/traction/views/traction_meeting_views.xml`
- Add buttons/menu entries enabling facilitators to escalate/cascade linked items.
- Hook actions to meeting helpers/wizard.

### `hub/addons/traction/tests/test_traction_escalation.py`
- SavepointCase tests covering meeting-driven escalation/cascade scenarios, verifying link creation, visibility updates, chatter.

### `hub/addons/traction/__manifest__.py`
- Reference new helpers/tests/views/wizard (if added).

## 4. Required Implementation

### Workflow Logic
- Ensure escalated items add destination to `visible_group_ids` and set `owner_group_id`.
- Cascades add destination visibility while retaining owner.
- Meeting helpers should:
  - Validate user is facilitator for meeting group.
  - Create link in destination meeting (if provided); update existing link fields (`escalated_to`, `carried_over_from`).
  - Post chatter messages on both meeting and item summarizing action.
- Handle edge cases gracefully (e.g., escalate to same group raises `UserError`).

### Testing Requirements
- SavepointCase verifying:
  - Escalation from meeting updates item owner/visibility and creates link in destination meeting.
  - Cascade adds visibility without changing owner; meeting link recorded.
  - Chatter entries with meeting references created.
  - Unauthorized user (non-facilitator) cannot execute meeting escalation.
  - Missing meeting context still updates item but logs note (document behaviour).
- Reference Stories in docstrings.

### UI/UX
- Buttons/wizard limited to facilitator group via `groups` attribute.
- Document TODO if richer UX deferred; backend must still support context parameters.

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


