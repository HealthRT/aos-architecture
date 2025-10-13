---
title: "[FEATURE] TRACTION-001: Establish Traction Core Groups & Security"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: TRACTION-001 – Establish Traction Core Groups & Security Foundations

## 1. Context & Objective

Introduce the foundational `traction.group` model, Traction security groups, and base ACL scaffolding needed for all later Traction/EOS items and meetings work.

---

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** main  
**New Branch:** feature/TRACTION-001-core-groups

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout main
git pull origin main
git checkout -b feature/TRACTION-001-core-groups
```

**Note:** Ensure pre-commit hooks from `standards/00-contributor-guide.md` are installed locally.

---

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/traction_group.py`
- Define `traction.group` model with fields: `name`, `code`, `member_ids` (Many2many `res.users`).
- Implement helper methods for membership checks (e.g., `is_member(user)`), ensuring docstrings reference Story IDs (`TRACTION-ITEMS-CORE`).

### `hub/addons/traction/models/__init__.py`
- Import the new `traction_group` module.

### `hub/addons/traction/security/traction_security.xml`
- Create base security groups for Traction roles:
  - `traction.group_facilitator`
  - `traction.group_leadership` (align with ADMIN-003 story hints)

### `hub/addons/traction/security/ir.model.access.csv`
- Add ACL entries granting read/write access to `traction.group` for facilitators/leadership, read-only for other Traction users if applicable.

### `hub/addons/traction/data/traction_groups_data.xml`
- Seed initial groups (`executive_leadership`, `management`) per Story assumptions; include XML IDs reused in later work orders (tests should reference these IDs).

### `hub/addons/traction/__manifest__.py`
- Ensure new files are listed under `data` and `security` with correct load order.

### `hub/addons/traction/tests/test_traction_group.py`
- Add unit tests covering create/read flows, membership helpers, and ACL enforcement.

---

## 4. Required Implementation

### Data & Security Foundations
- Implement `traction.group` with `_name`, `_description`, `_rec_name = 'name'`, unique constraint on `code`.
- Provide SQL constraint to ensure `code` uniqueness and uppercase transformation on create/write.
- Configure Many2many relation (`member_ids`) using dedicated relation table `traction_group_res_users_rel`.
- Seed default groups (executive leadership, management) and assign placeholder facilitator users via data file (use `base.user_admin` or create test users in tests only).
- Create security groups with proper category (Traction) and short descriptions.
- ACL: facilitators and leadership have create/write/unlink/read on `traction.group`; other users read-only if business rules require (document assumption).

### Testing Requirements
- Follow `standards/08-testing-requirements.md` (SavepointCase, docstrings, `flush()` as needed).
- Tests must cover:
  - Creation of groups via ORM, uniqueness constraint on `code`.
  - Membership helper returns True/False based on `member_ids`.
  - User in facilitator group can create/update `traction.group`; user outside receives `AccessError`.
  - Data seeding ensures default groups exist (assert search by `code`).
- Provide dedicated test users/groups as fixtures; isolate modifications via SavepointCase.

### Documentation & Linting
- Add docstrings referencing `TRACTION-ITEMS-CORE`.
- Ensure all new Python files respect `01-odoo-coding-standards.md` (Black formatting, type hints where appropriate).
- Update `__init__.py` to import modules cleanly.

---

## 5. Acceptance Criteria

- [ ] `traction.group` model created with required fields, constraints, and helper methods.
- [ ] Traction facilitator and leadership security groups defined.
- [ ] Seed data creates `executive_leadership` and `management` groups.
- [ ] ACLs enforce create/write permissions for facilitators/leadership only.
- [ ] Unit tests cover creation, membership helper, ACL enforcement, and data availability.
- [ ] Code follows Odoo and project standards; docstrings reference Story ID.
- [ ] Git history includes descriptive commits for model, security, tests, data.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured (boot + tests).

---

## 6. Context Management & Iteration Limits

Follow standard workflow phases and checkpoints:
- Implementation → commit partial changes when stable
- Testing → commit dedicated test updates
- Bug fixing (max 2 iterations) → escalate after repeated failures per template

Document any blockers or architectural questions in issue comments.

---

## 7. Required Context Documents

- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/003-internal-api-first-design.md`
- `@aos-architecture/decisions/006-multi-tenancy-strategy.md`

---

## 7. Technical Constraints

- Odoo 18.0 Community compatibility required.
- Respect multi-tenancy strategy (use UUID/constraints as needed; avoid hard-coded IDs beyond seeded data).
- Security groups must not grant unintended global access.

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
- Attach full test output (0 failures, counts, duration) in issue handoff.

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


