---
title: "[FEATURE] WO-AGMT-001-02: Build Service Agreement Views & Actions"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-agreements"
---
# Work Order: WO-AGMT-001-02 – Build Service Agreement Views & Actions

## 1. Context & Objective

Create end-user UI for managing Service Agreements, including list/form views, action window, menus, and UX elements that surface all Story fields (external references, modifiers, financials, compliance metadata) while matching the mockup experience.

---

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** feature/WO-AGMT-001-01-service-agreement-model  
**New Branch:** feature/WO-AGMT-001-02-service-agreement-views

**Setup Commands:**
```bash
git checkout feature/WO-AGMT-001-01-service-agreement-model
git checkout -b feature/WO-AGMT-001-02-service-agreement-views
```
**Note:** Rebase onto latest once WO-01 merged.

---

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/views/service_agreement_views.xml`
Create tree/form views reflecting complete field set, computed aliases, total amount display, and action buttons (Activate, Cancel, Save & Activate). Align with UI mockup using groups or notebook sections.

### `evv/addons/evv_agreements/views/service_agreement_actions.xml`
Window action for menu navigation.

### `evv/addons/evv_agreements/views/service_agreement_menus.xml`
Add menu entries under EVV Agreements navigation hierarchy (coordinate with global menu conventions).

### `evv/addons/evv_agreements/views/res_partner_views.xml` (optional, confirm with Architect)
Add search filters or form field visibility for new partner flags (`is_patient`, `is_case_manager`) and external IDs if needed to support user workflows.

### `evv/addons/evv_agreements/__manifest__.py`
Ensure `data` section includes new XML files in correct load order.

---

## 4. Required Implementation

### View Definitions
- Tree view columns: patient, procedure_code, effective/through dates, total_units, total_amount, state, line_status.
- Form view organized per mockup (External Reference, Patient & Service, Authorization Period & Quantity, Financial, Compliance, Status) via notebook/collapsible groups.
- Display computed fields (`start_date`, `end_date`, `total_amount`); ensure `total_amount` is read-only and updates automatically.
- Include case manager domain referencing `is_case_manager=True` and show external reference fields.
- Buttons `Activate`, `Cancel`, and `Save & Activate` with appropriate `attrs` to control visibility per state.

### Actions & Menus
- Create `ir.actions.act_window` listing agreements (default sort by `effective_date` descending) with search default filter for Active agreements.
- Place menu under EVV root (create base menu if missing); include submenu for Service Agreements.
- Set `groups_id` to DC role placeholder (to be defined in WO-03) with XML comment referencing final ID.

### UI & UX Enhancements
- Provide saved filters: Active Agreements, Pending County Approval (line_status).
- Add graph/kanban placeholders only if architecturally approved; otherwise document future scope.
- Document any deviations from mockup in XML comments referencing Story.

---

## 5. Acceptance Criteria

### Functional Requirements
- [ ] Tree and form views load without XML errors.
- [ ] Buttons trigger `action_activate` / `action_cancel` and respect state visibility.
- [ ] Menu items and action appear for DC role (once security applied).
- [ ] UI mirrors mockup fields order and labels.
- [ ] Manifest updated for XML files.
- [ ] Code committed with descriptive message.

### Testing Requirements (MANDATORY)
- [ ] Unit tests written for view rendering and button actions:
  - [ ] Form view loads with all fields visible
  - [ ] Tree view displays correct columns
  - [ ] Button visibility based on state
  - [ ] Menu items accessible to authorized roles
- [ ] UI/UX validation:
  - [ ] All 28 fields are accessible in form view
  - [ ] Collapsible groups work as designed
  - [ ] Computed fields are read-only
  - [ ] Domain filters on case_manager_id work correctly
- [ ] All tests pass (0 failed, 0 errors)

---

## 6. Context Management & Iteration Limits

Adhere to standard workflow phases/checkpoints.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/02-ui-ux-and-security-principles.md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)

---

## 8. Technical Constraints

- Odoo 18.0 XML conventions; no Enterprise-only widgets.
- Keep XML IDs consistent with naming standards.

---

## 9. MANDATORY Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Test Execution (REQUIRED)
```bash
# Run all tests for the module
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo --test-enable --stop-after-init -u evv_agreements --log-level=test
```
**Provide:** Full test output showing `0 failed, 0 error(s)`.

### 9.2 Boot Verification (REQUIRED)
```bash
# Boot Odoo server and verify views load
docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming views loaded without XML errors.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
# Test module upgrade
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u evv_agreements --stop-after-init
```
**Provide:** Log output showing successful upgrade with no errors.


