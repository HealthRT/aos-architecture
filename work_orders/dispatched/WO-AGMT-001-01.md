---
title: "[FEATURE] WO-AGMT-001-01: Bootstrap `evv_agreements` Module & Core Model"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-compliance"
---
# Work Order: WO-AGMT-001-01 – Bootstrap `evv_agreements` Module & Core Model

## 1. Context & Objective

Create the foundational `evv_agreements` module and implement the `service.agreement` model, including schema, business rules, and state transition methods for the Simple Bucket MVP.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** main  
**New Branch:** feature/WO-AGMT-001-01-service-agreement-model

**Setup Commands:**
```bash
git checkout main
git checkout -b feature/WO-AGMT-001-01-service-agreement-model
```

---

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/__manifest__.py`
Create module manifest declaring name, version `18.0.1.0.0`, dependencies (`base`, `contacts`, `evv_core` once available), data files (views/security placeholders), and installable metadata.

### `evv/addons/evv_agreements/__init__.py`
Import Python packages/modules to register models.

### `evv/addons/evv_agreements/models/__init__.py`
Expose the `service_agreement` model.

### `evv/addons/evv_agreements/models/service_agreement.py`
Implement the `service.agreement` model per spec: fields, SQL/name constraints, onchange/compute logic if needed, and `action_activate` / `action_cancel` methods with validation hooks.

---

## 4. Required Implementation

### Data Model
- Define `_name = "service.agreement"` with `_description`.
- Fields exactly as in spec (Many2one to `res.partner`, required dates, float units with help text, selection for `state` default `'draft'`).
- Add mixins as needed (e.g., `mail.thread`) only if justified.
- Ensure `patient_id` domain enforces patient role when possible.

### Validation Rules
- Implement model-level constraint ensuring `start_date <= end_date`.
- Enforce positive `total_units` (>= 0; use SQL constraint or Python `@api.constrains`).
- Default state to `draft` and ensure create respects defaults.

### State Methods
- `action_activate` performs:
  - `self.ensure_one()`
  - validation of mandatory fields, business rules
  - state transition to `active`
- `action_cancel` with `self.ensure_one()` sets `state = 'cancelled'`.
- Leave TODO hook/comments referencing future integration with validation engine.

### Module Scaffolding
- Ensure package has placeholder folders (`views/`, `security/`, `tests/`, `docs/`) even if empty to satisfy manifest references.
- Add README.md or blank `__init__.py` where required for packaging.

---

## 5. Acceptance Criteria

- [ ] Module scaffold installs without errors (Odoo 18.0).
- [ ] Manifest, init files, and python packages created under `evv/addons/evv_agreements`.
- [ ] `service.agreement` model matches Story schema and defaults.
- [ ] Validation errors raise `UserError` / `ValidationError` per business rules.
- [ ] `action_activate` only transitions when validations pass; otherwise raises.
- [ ] `action_cancel` transitions state to `cancelled`.
- [ ] Docstrings reference Story `AGMT-001`.
- [ ] Code committed with descriptive message.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.

---

## 6. Context Management & Iteration Limits

Follow template phases, checkpoints, and iteration limits exactly.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

---

## 7. Technical Constraints

- Odoo Version 18.0 Community.
- No deprecated APIs or enterprise-only features.

---

## 8. Proof of Execution

Provide module install output (tests optional here) and boot logs per template.


