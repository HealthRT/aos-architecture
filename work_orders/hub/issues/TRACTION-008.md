# Issue Draft: [WORK ORDER] TRACTION-008 – Meeting Proof & Documentation

**Work Order ID:** TRACTION-008  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Author integration tests and documentation demonstrating end-to-end Traction/EOS MVP workflows, ensuring acceptance criteria coverage.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `feature/TRACTION-007-escalation-automation`  
**New Branch:** `feature/TRACTION-008-proof-docs`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-007-escalation-automation
git pull origin feature/TRACTION-007-escalation-automation
git checkout -b feature/TRACTION-008-proof-docs
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/tests/test_traction_end_to_end.py`
- Integration tests covering meeting lifecycle, linking items, escalation/cascade flows, notes, and completion.

### `hub/addons/traction/tests/test_security_matrix.py`
- Tests verifying key record rules/ACL permutations for canonical items and meetings.

### `hub/addons/traction/docs/meetings_mvp.md`
- Documentation summarizing canonical models, meeting agenda workflow, escalation/cascade behavior, and testing instructions.

### `hub/addons/traction/__manifest__.py`
- Reference new docs/tests if required.

## 4. Required Implementation

### Integration Testing
- Use SavepointCase/TransactionCase to orchestrate creation of groups, users, canonical items, and meetings.
- Simulate meeting start → agenda progression → linking items → escalation/cascade to another meeting → completion.
- Validate acceptance criteria (notes persistence, visibility, ownership, meeting completion).

### Security Matrix Tests
- Table-driven assertions ensuring read/write permissions align with role expectations (facilitator, leadership, standard user, admin).

### Documentation
- `docs/meetings_mvp.md` covers:
  - Overview of canonical items & meeting agenda.
  - Step-by-step facilitator workflow.
  - Escalation vs cascade explanation with meeting link snapshots.
  - Testing commands (proof-of-execution steps).
  - Future work TODOs (event emission, timers).
- Ensure ASCII formatting, references to Stories, and alignment with contributor guide.

### Self-Check
- Run lint/tests; confirm doc references added (e.g., update README or module index if necessary).

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
- `@aos-architecture/features/hub/traction/01-feature-suite-brief.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

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


