---
title: "[FEATURE] TRACTION-008: Meeting Proof & Documentation"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-008 – Meeting Proof & Documentation

## 1. Context & Objective

Produce documentation and integration tests validating end-to-end meeting workflow, ensuring all acceptance criteria from Stories are demonstrably satisfied and future teams have reference material.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** feature/TRACTION-007-escalation-automation  
**New Branch:** feature/TRACTION-008-proof-docs

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-007-escalation-automation
git pull origin feature/TRACTION-007-escalation-automation
git checkout -b feature/TRACTION-008-proof-docs
```

**Note:** Focus on tests/docs; minimal code adjustments allowed (bug fixes found during testing should be coordinated with Scrum Master).

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/tests/test_traction_end_to_end.py`
- Implement integration test(s) covering meeting creation, agenda navigation, linking items, escalation/cascade flows, and completion.
- Ensure tests reference acceptance criteria from both Story YAMLs.

### `hub/addons/traction/tests/test_security_matrix.py`
- Add tests verifying key record rules for groups/items/meetings to guard against regressions.

### `hub/addons/traction/docs/meetings_mvp.md`
- Create documentation summarizing models, workflows, and how to run tests.
- Include sequence diagrams or textual descriptions of escalation/cascade flows.

### `hub/addons/traction/__manifest__.py`
- Reference new docs/tests if required.

---

## 4. Required Implementation

### Integration Tests
- Build SavepointCase or TransactionCase that orchestrates:
  - Creating default groups (from seed), facilitator user, canonical items, and meetings.
  - Running meeting start → next → … → conclude → complete.
  - Linking issues/rocks/todos/kpis to sections, capturing notes.
  - Escalating an issue to another group and verifying new link appears in destination meeting.
  - Cascading a to-do while preserving ownership.
  - Ensuring visibility rules enforced at each step (use `with self.assertRaises(AccessError)` for unauthorized users).
- Tie assertions back to acceptance criteria with comments.

### Security Matrix Tests
- Provide table-driven tests verifying record rules for canonical items and meetings (read/write permutations).

### Documentation
- `docs/meetings_mvp.md` should include:
  - Overview of canonical models and meeting agenda.
  - Step-by-step workflow for facilitators.
  - Summary of escalation vs cascade and how meeting links capture context.
  - Testing instructions (commands from Proof of Execution).
  - Future work/TODO section referencing event emission.
- Ensure doc references `TRACTION-MEETINGS-MVP` and `TRACTION-ITEMS-CORE`.

### Self-Check & Linting
- Run `odoo-bin` tests locally and ensure docs pass any markdown linting (if configured).
- Update README or module index to link new doc if applicable.

---

## 5. Acceptance Criteria

- [ ] Integration tests cover end-to-end meeting flow, linking, escalation, cascade.
- [ ] Security matrix tests validate ACL/record rules for key roles.
- [ ] Documentation provides clear guidance on Traction MVP architecture and workflows.
- [ ] Testing instructions align with proof-of-execution steps.
- [ ] Code/doc changes follow standards and reference Stories.
- [ ] Descriptive commits capturing tests/docs additions.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (integration tests + boot + upgrade).

---

## 6. Context Management & Iteration Limits

Focus on integration coverage; escalate if missing functionality discovered that requires new development work orders.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/MEETINGS_MVP_STORY.yaml`
- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/features/hub/traction/01-feature-suite-brief.md`

---

## 7. Technical Constraints

- Keep integration test runtime reasonable; use fixtures efficiently.
- Documentation in ASCII, following contributor guide.
- Ensure tests and docs remain under 500 LOC change window.

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
- Attach full test output (0 failures, counts, duration).

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


