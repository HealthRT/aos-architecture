# Issue Draft: [WORK ORDER] TRACTION-001 – Establish Traction Core Groups & Security Foundations

**Work Order ID:** TRACTION-001  
**Priority:** priority:high  
**Module:** module:hub-traction

## 1. Context & Objective

Introduce the foundational `traction.group` model, Traction security groups, and base ACL scaffolding needed for all later Traction/EOS items and meetings work.

## 2. Repository Setup

**Repository:** hub  
**Base Branch:** `main`  
**New Branch:** `feature/TRACTION-001-core-groups`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout main
git pull origin main
git checkout -b feature/TRACTION-001-core-groups
```

## 3. Problem Statement & Technical Details

### `hub/addons/traction/models/traction_group.py`
- Define `traction.group` with fields `name`, `code`, `member_ids` (Many2many `res.users`).
- Implement helper `is_member(user)` (docstring references `TRACTION-ITEMS-CORE`).

### `hub/addons/traction/models/__init__.py`
- Import the new module.

### `hub/addons/traction/security/traction_security.xml`
- Create security groups `traction.group_facilitator` and `traction.group_leadership` (align with ADMIN-003 expectations).

### `hub/addons/traction/security/ir.model.access.csv`
- ACL entries for `traction.group`: facilitators/leadership = create/write/unlink/read; others read-only if required (document assumption).

### `hub/addons/traction/data/traction_groups_data.xml`
- Seed `executive_leadership` and `management` groups with stable XML IDs for reuse.

### `hub/addons/traction/tests/test_traction_group.py`
- Tests covering creation, uniqueness constraint on `code`, membership helper, and ACL enforcement.

### `hub/addons/traction/__manifest__.py`
- Add new files under `data`/`security` sections in proper order.

## 4. Required Implementation

### Data & Security Foundations
- `_name = "traction.group"`, `_description`, `_rec_name = 'name'`.
- SQL constraint for unique uppercase `code`; enforce uppercase conversion on create/write.
- Many2many relation table `traction_group_res_users_rel`.
- Seed default groups; assign placeholder facilitator user if appropriate (document assumption).
- Security groups categorized under Traction.

### Testing Requirements
- Follow `standards/08-testing-requirements.md` (SavepointCase, docstrings, deterministic data).
- Validate group creation, uniqueness enforcement, helper behavior, ACL (facilitator vs non-facilitator).
- Ensure seeded groups exist (search by `code`).

### Documentation & Linting
- Docstrings reference `TRACTION-ITEMS-CORE`.
- Adhere to `01-odoo-coding-standards.md`; run `black`/linters.
- Update `__init__.py` imports cleanly.

## 5. Acceptance Criteria

- [ ] All requirements implemented.  
- [ ] Code follows `01-odoo-coding-standards.md`.  
- [ ] Code is tenancy-aware per ADR-006.  
- [ ] Tests written and passing.  
- [ ] Odoo boots without errors (MANDATORY).  
- [ ] Proof of execution logs captured.  
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

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

- Provide test output (0 failures, duration) and boot/upgrade logs in issue handoff. Escalate if Docker unavailable.


