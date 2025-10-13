FROM: SCRUM_MASTER
TO: CODER_AGENT_A
MSG_ID: SM-108-20251014051500

Subject: NEW ASSIGNMENT - PT-001B (Phase B: Security & Views) - PARALLEL WORK

---

## WORK ASSIGNMENT: PT-001B - Patient Records Security & Views

**Repository:** evv (HealthRT/evv)
**Base Branch:** `main`
**Your Branch:** `feature/PT-001B-ATOMIC-patients-security-views`
**Batch Size:** 4 atomic tasks (ATOMIC-05 through ATOMIC-08)

**PARALLEL WORK:** Coder E is building Phase A (models) simultaneously. Your Phase B (security & views) will be integrated with Phase A once both are complete.

---

## PHASE B TASKS (4 tasks - Security & Views):

### TASK 1: PT-001-ATOMIC-05 - Security ACLs
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/security/ir.model.access.csv`  
**Content:** ACLs for evv.patient model using evv_core.group_evv_manager and base.group_user

### TASK 2: PT-001-ATOMIC-06 - Patient Views
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/views/evv_patient_views.xml`  
**Content:** Form, tree, search views with chatter, grouped fields

### TASK 3: PT-001-ATOMIC-07 - Action & Menu
**Operation:** MODIFY FILE  
**File:** `evv/addons/evv_patients/views/evv_patient_views.xml`  
**Content:** Add window action and menu item (parent: evv_core.menu_evv_root)

### TASK 4: PT-001-ATOMIC-08 - Module Manifest
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/__manifest__.py`  
**Content:** Odoo 18 manifest with proper dependencies (evv_core, evv_case_managers)

Full work orders:
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-05-CREATE-security-acls.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-06-CREATE-patient-views.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-07-CREATE-action-menu.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-08-CREATE-manifest.md`

---

## SUBMISSION FORMAT

Streamlined format:

```
FROM: CODER_AGENT_A
TO: SCRUM_MASTER

TASKS COMPLETE:
✅ PT-001-ATOMIC-05 - Created security ACLs
✅ PT-001-ATOMIC-06 - Created patient views (form/tree/search)
✅ PT-001-ATOMIC-07 - Added action and menu
✅ PT-001-ATOMIC-08 - Created module manifest

VERIFICATION: All files match specs exactly
Branch: feature/PT-001B-ATOMIC-patients-security-views
```

---

## NOTES

- **Phase B is independent** - Security & views don't depend on Phase A model internals
- **Separate branches** - You're on PT-001B branch, Coder E is on PT-001A branch
- **Integration** - SM will merge both phases when complete and test together
- **Architecture** - Uses evv_core security groups (not custom groups like old module)
- **Menu** - Parent is evv_core.menu_evv_root (no duplicate menus)

This is a module **rebuild** - cleaner architecture than the old evv_patients.

Context: `aos-architecture/work_orders/atomic/README.md`

