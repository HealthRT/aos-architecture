---
title: "[FEATURE] WO-AGMT-001-02: Build Service Agreement Views & Actions"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,type:feature,priority:medium,module:evv-compliance"
---
# Work Order: WO-AGMT-001-02 – Build Service Agreement Views & Actions

## 1. Context & Objective

Create end-user UI for managing Service Agreements, including list/form views, action window, and menu entries matching the Simple Bucket mockup.

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
Create tree/form views reflecting fields and action buttons (Activate, Cancel). Align with UI mockup.

### `evv/addons/evv_agreements/views/service_agreement_actions.xml`
Window action for menu navigation.

### `evv/addons/evv_agreements/views/service_agreement_menus.xml`
Add menu entries under EVV Agreements navigation hierarchy (coordinate with global menu conventions).

### `evv/addons/evv_agreements/__manifest__.py`
Ensure `data` section includes new XML files in correct load order.

---

## 4. Required Implementation

### View Definitions
- List view showing patient, start/end dates, total units, state.
- Form view with fields in order: patient, start/end dates, total units, state (read-only), buttons `Save`, `Activate`, `Cancel`.
- Button definitions calling Python methods; ensure attrs hide buttons depending on state (e.g., only show Activate in `draft`, Cancel in `active`/`draft`).
- Add statusbar for `state` field and include help tooltips matching business meaning.

### Actions & Menus
- Create `ir.actions.act_window` listing agreements (default sort by start_date desc).
- Place menu under EVV root (create base menu if one does not exist yet).
- Set `groups_id` to DC role placeholder (to be defined in WO-03) but add TODO comment referencing XML ID once available.

### UI Polishing
- Provide default filters (e.g., Active Agreements).
- Ensure buttons appear per mockup; include `attrs` to disable Activate when validations fail if feasible via python state.
- Document deviations from mockup in XML comments if necessary.

---

## 5. Acceptance Criteria

- [ ] Tree and form views load without XML errors.
- [ ] Buttons trigger `action_activate` / `action_cancel` and respect state visibility.
- [ ] Menu items and action appear for DC role (once security applied).
- [ ] UI mirrors mockup fields order and labels.
- [ ] Manifest updated for XML files.
- [ ] Code committed with descriptive message.
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.

---

## 6. Context Management & Iteration Limits

Adhere to standard workflow phases/checkpoints.

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/02-ui-ux-and-security-principles.md`

---

## 7. Technical Constraints

- Odoo 18.0 XML conventions; no Enterprise-only widgets.
- Keep XML IDs consistent with naming standards.

---

## 8. Proof of Execution

Provide boot logs demonstrating views rendered (e.g., module install with `-i evv_agreements`).


