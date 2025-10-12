# Issue Draft: [WORK ORDER] WO-AGMT-001-02 – Build Service Agreement Views & Actions

**Work Order ID:** WO-AGMT-001-02  
**Priority:** priority:medium  
**Module:** module:evv-compliance

## 1. Context & Objective

Create end-user UI for managing Service Agreements, including list/form views, action window, menus, and UX treatments that surface all Story fields (external references, modifiers, financial totals, compliance data) while matching the mockup.

## 2. Repository Setup

**Repository:** evv  
**Base Branch:** `feature/WO-AGMT-001-01-service-agreement-model`  
**New Branch:** `feature/WO-AGMT-001-02-service-agreement-views`

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-01-service-agreement-model
git pull origin feature/WO-AGMT-001-01-service-agreement-model
git checkout -b feature/WO-AGMT-001-02-service-agreement-views
```

## 3. Problem Statement & Technical Details

### `evv/addons/evv_agreements/views/service_agreement_views.xml`
- Implement tree and form views reflecting full field list, computed aliases, `total_amount` display, and buttons (Activate, Cancel, Save & Activate) consistent with Story mockup.

### `evv/addons/evv_agreements/views/service_agreement_actions.xml`
- Define `ir.actions.act_window` for agreement records.

### `evv/addons/evv_agreements/views/service_agreement_menus.xml`
- Add menus under EVV Agreements navigation (create parent menu if needed).

### `evv/addons/evv_agreements/views/res_partner_views.xml` (if required)
- Add search filters or form elements exposing new partner flags (`is_patient`, `is_case_manager`) and external IDs when aligned with UX plan; add TODO if deferred.

### `evv/addons/evv_agreements/__manifest__.py`
- Ensure XML files are listed in `data` loading sequence.

## 4. Required Implementation

### View Definitions
- Tree view columns: patient, procedure_code, effective/through dates, total_units, total_amount, state, line_status.
- Form view organized per mockup sections (External Reference, Patient & Service, Authorization Period & Quantity, Financial, Compliance, Status) using tabs/collapsible groups.
- Display computed fields (`start_date`, `end_date`, `total_amount`) read-only; ensure `total_amount` auto-updates and shows currency.
- Ensure case manager field filters on `is_case_manager=True`; show external reference fields with helper text.
- Buttons `Activate`, `Cancel`, `Save & Activate` with `attrs` to control visibility per state.

### Actions & Menus
- `ir.actions.act_window` should open tree+form views, default sort by `effective_date` descending; include default filter for Active agreements.
- Place menu under root EVV Agreements item; if root missing, create temporary root with comment for future consolidation.
- Assign `groups_id` to Designated Coordinator group placeholder (will be defined in WO-03). Add XML comment referencing final ID.

### UI & UX Enhancements
- Add saved filters (Active Agreements, Pending County Approval) and group by patient/procedure.
- Ensure translation-ready labels and consistent naming (`view_service_agreement_tree`, etc.).
- Document any limitations or placeholders via XML comments referencing Story.

## 5. Acceptance Criteria

- [ ] All requirements implemented.
- [ ] Code follows `01-odoo-coding-standards.md`.
- [ ] Code is tenancy-aware per ADR-006.
- [ ] HIPAA compliance verified (no inadvertent exposure via menus/views).
- [ ] Tests written and passing (manual verification acceptable for pure UI but document). 
- [ ] Odoo boots without errors (MANDATORY).
- [ ] Proof of execution logs captured.
- [ ] Code committed with descriptive message.

## 6. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/02-ui-ux-and-security-principles.md`

## 7. MANDATORY: Proof of Execution Commands

```bash
cd /home/james/development/aos-development
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --stop-after-init \
  -u evv_agreements
docker compose logs --tail="100" odoo
```

**Verify logs show:**
- "HTTP service (werkzeug) running"
- "Modules loaded"
- No Python errors


