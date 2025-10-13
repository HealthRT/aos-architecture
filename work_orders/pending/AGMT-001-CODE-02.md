---
title: "[FEATURE] AGMT-001-CODE-02: Implement Views & Actions for Service Agreements"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: AGMT-001-CODE-02 – Implement Views & Actions for Service Agreements

## 1. Context & Objective

Implement user interface views and actions for the `service.agreement` model. This work order builds on AGMT-001-CODE-01 (model implementation) to provide DCs with a complete UI for managing service authorization lines.

**Story:** AGMT-001 - Create Service Agreement Line  
**Dependency:** AGMT-001-CODE-01 (model implementation) must be complete

---

## 2. Development Environment

### Target Repository
**Repository:** evv  
**GitHub URL:** github.com/HealthRT/evv  
**Target Module:** evv_agreements  
**Base Branch:** main  
**New Branch:** feature/AGMT-001-CODE-02-views-actions

### Setup Commands
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/AGMT-001-CODE-02-views-actions
```

---

## 3. Problem Statement

**Current State:** The `service.agreement` model exists but has no user interface. DCs cannot interact with service agreements through the Odoo UI.

**Required Artifact:** Complete view implementation with form, tree, search views, and menu items organized per AGMT-001.yaml specification.

---

## 4. Required Implementation

### A. Form View (`views/service_agreement_views.xml`)

**Layout Requirements (per spec):**

The form MUST use a tabbed interface (Odoo 'notebook') with three tabs:

**Header:**
- State field with statusbar widget showing: draft, active, expired, cancelled
- Action buttons:
  - "Activate" (visible in draft state) → calls `action_activate`
  - "Cancel" (visible in active/expired states) → calls `action_cancel`

**Tab 1: Service Details**
- Group: Patient & Service
  - `patient_id` (required)
  - `procedure_code` (required)
  - `modifier_1`, `modifier_2`, `modifier_3`, `modifier_4`
  - `service_description` (text widget, multiline)

**Tab 2: Authorization**
- Group: Date Range
  - `effective_date` (required)
  - `through_date` (required)
  - `start_date` (readonly, computed)
  - `end_date` (readonly, computed)
- Group: Units & Financial
  - `total_units` (required)
  - `unit_of_measure` (required, default: 'minutes')
  - `minutes_per_unit`
  - `rate_per_unit` (monetary widget)
  - `total_amount` (readonly, computed, monetary widget)
  - `currency_id` (invisible, used by monetary fields)

**Tab 3: Compliance & References**
- Group: External References
  - `agreement_number`
  - `provider_id_external`
  - `line_number`
  - `line_status` (selection: approved/denied/pending)
  - `recipient_id_external` (readonly, related)
- Group: Compliance
  - `diagnosis_code`
  - `case_manager_id`

**Field Widgets:**
- `state`: statusbar widget
- `patient_id`: many2one widget with domain filter
- `service_description`: text widget
- `rate_per_unit`, `total_amount`: monetary widget
- All date fields: date widget
- Readonly fields: `readonly="1"` attribute

### B. Tree View (`views/service_agreement_views.xml`)

**Columns (in order):**
1. `patient_id`
2. `procedure_code`
3. `effective_date`
4. `through_date`
5. `total_units`
6. `total_amount`
7. `state` (with decoration for visual feedback)

**Decorations:**
```xml
decoration-success="state == 'active'"
decoration-muted="state in ('cancelled', 'expired')"
decoration-info="state == 'draft'"
```

### C. Search View (`views/service_agreement_views.xml`)

**Filters:**
- "Active Agreements" → domain: `[('state', '=', 'active')]`
- "Draft Agreements" → domain: `[('state', '=', 'draft')]`
- "Expired Agreements" → domain: `[('state', '=', 'expired')]`
- "My Patient Agreements" → domain: TBD based on user role

**Group By:**
- Group by State
- Group by Patient
- Group by Case Manager

**Search Fields:**
- `patient_id`
- `procedure_code`
- `agreement_number`

### D. Actions (`views/service_agreement_views.xml`)

**Window Action:**
```xml
<record id="action_service_agreement" model="ir.actions.act_window">
    <field name="name">Service Agreements</field>
    <field name="res_model">service.agreement</field>
    <field name="view_mode">tree,form</field>
    <field name="context">{}</field>
    <field name="help" type="html">
        <p class="o_view_nocontent_smiling_face">
            Create your first Service Agreement Line
        </p>
        <p>
            Service agreements define authorized services, dates, and units for patient care.
        </p>
    </field>
</record>
```

### E. Menu Items (`views/service_agreement_views.xml`)

**Menu Structure:**
```
EVV (root menu)
└── Service Agreements
    └── All Agreements (action: action_service_agreement)
```

**Implementation:**
```xml
<menuitem id="menu_evv_root" name="EVV" sequence="10"/>

<menuitem id="menu_service_agreements" 
          name="Service Agreements" 
          parent="menu_evv_root" 
          sequence="20"/>

<menuitem id="menu_service_agreements_all" 
          name="All Agreements" 
          parent="menu_service_agreements" 
          action="action_service_agreement" 
          sequence="10"/>
```

### F. Update Manifest

Ensure `__manifest__.py` includes the views file:
```python
'data': [
    'security/ir.model.access.csv',
    'views/service_agreement_views.xml',  # ADD THIS
],
```

### G. Tests (`tests/test_service_agreement_views.py`)

Create comprehensive view tests:

**Test Class:** `TestServiceAgreementViews(TransactionCase)`

**Tests Required:**
1. `test_form_view_exists()` - Verify form view is defined
2. `test_tree_view_exists()` - Verify tree view is defined
3. `test_search_view_exists()` - Verify search view is defined
4. `test_action_window_exists()` - Verify action is defined
5. `test_menu_items_exist()` - Verify menu structure
6. `test_form_view_readonly_fields()` - Verify computed fields are readonly
7. `test_activate_button_workflow()` - Test UI action button for activation
8. `test_cancel_button_workflow()` - Test UI action button for cancellation
9. `test_search_by_patient()` - Test search functionality
10. `test_filter_by_state()` - Test filter functionality

---

## 5. Acceptance Criteria

### View Implementation
- [ ] Form view uses tabbed interface (notebook) with 3 tabs
- [ ] All fields from spec are present in appropriate tabs
- [ ] Computed fields (`start_date`, `end_date`, `total_amount`) are readonly
- [ ] State field uses statusbar widget
- [ ] Action buttons (Activate, Cancel) visible in form header
- [ ] Tree view displays key columns with appropriate decorations
- [ ] Search view includes filters for state and grouping options

### UI/UX
- [ ] Form view is organized and logical
- [ ] Required fields are clearly marked
- [ ] Monetary fields use monetary widget with currency
- [ ] Help text visible for complex fields
- [ ] Empty state message appears when no records exist

### Functional
- [ ] Views can be opened without errors
- [ ] Records can be created, edited, and deleted via UI
- [ ] Action buttons trigger correct methods
- [ ] Filters and search work correctly
- [ ] Menu items navigate to correct views

### Testing (MANDATORY)
- [ ] All view tests pass (0 failed, 0 error(s))
- [ ] Tests verify view existence and structure
- [ ] Tests verify workflow actions via UI
- [ ] Module installs and upgrades without errors
- [ ] Test output committed showing clean results

---

## 6. Testing Execution

### Run Tests
```bash
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_agreements
```

**Verification:**
- [ ] Tests show: `evv_agreements: X tests 0.XXs XX queries`
- [ ] Result shows: `0 failed, 0 error(s)`
- [ ] Your new view tests appear in output

### Cleanup Verification
```bash
docker ps -a | grep evv-agent-test
# Must be empty
```

---

## 7. Required Context Documents

- `@aos-architecture/specs/evv/AGMT-001.yaml` (PRIMARY SPEC)
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md`
- `@aos-architecture/decisions/ADR-006-multi-tenancy.md`
- `@aos-architecture/decisions/ADR-013-repository-boundaries.md`

---

## 8. Technical Constraints

- **Odoo Version:** 18.0 Community Edition
- **HIPAA Compliance:** Follow ADR-006 for PHI field handling
- **Module Prefix:** `evv_*` per ADR-013
- **Change Size:** Keep diff < 500 LOC
- **Dependencies:** Requires AGMT-001-CODE-01 completion

---

## 9. Submission

### Commit Message Format
```
feat(evv_agreements): implement service agreement views and actions

- Add form view with tabbed interface (Service Details, Authorization, Compliance)
- Add tree view with state decorations
- Add search view with filters and grouping
- Add menu structure under EVV root menu
- Add comprehensive view tests
- All tests pass: X tests, 0 failed, 0 errors
```

### Before Creating PR
- [ ] All tests pass
- [ ] Module installs without errors
- [ ] Views accessible via menu
- [ ] Action buttons work correctly
- [ ] Test proof committed to branch
- [ ] Branch pushed to GitHub

---

## 10. Dependencies & Blockers

**Requires Completion:**
- AGMT-001-CODE-01 (service.agreement model) - MUST BE MERGED TO MAIN

**Unblocks:**
- AGMT-001-QA-01 (comprehensive testing)

**Note:** With SYSTEM-005 complete, all core module test suites are now stable. You can proceed with confidence.

