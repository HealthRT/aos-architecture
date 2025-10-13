FROM: SCRUM_MASTER
TO: CODER_AGENT_E
MSG_ID: SM-107-20251014050000

Subject: NEW ASSIGNMENT - PT-001A (Phase A: Patient Foundation & Models)

---

## WORK ASSIGNMENT: PT-001A - Patient Records Foundation

**Repository:** evv (HealthRT/evv)
**Base Branch:** `main`
**Your Branch:** `feature/PT-001-ATOMIC-patients-rebuild`
**Batch Size:** 4 atomic tasks (ATOMIC-01 through ATOMIC-04)

This is a **complete rebuild** of evv_patients module using phased atomic workflow. The existing module has architectural issues (duplicate menus, wrong security groups).

---

## PHASE A TASKS (4 tasks - Foundation & Models):

### TASK 1: PT-001-ATOMIC-01 - Module __init__.py
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/__init__.py`  
**Content:** Import models subpackage

### TASK 2: PT-001-ATOMIC-02 - Models __init__.py
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/models/__init__.py`  
**Content:** Import evv_patient and partner models

### TASK 3: PT-001-ATOMIC-03 - Patient Model
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/models/evv_patient.py`  
**Content:** Core patient model with partner_id, mrn, recipient_id_external, case_manager_id, mail.thread, tracking, SQL constraint

### TASK 4: PT-001-ATOMIC-04 - Partner Extension
**Operation:** CREATE FILE  
**File:** `evv/addons/evv_patients/models/partner.py`  
**Content:** Extend res.partner._compute_display_name to add patient MRN context

Full work orders:
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-01-CREATE-module-init.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-02-CREATE-models-init.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-03-CREATE-patient-model.md`
- `aos-architecture/work_orders/atomic/patients/PT-001-ATOMIC-04-CREATE-partner-extension.md`

---

## SUBMISSION FORMAT

Streamlined format:

```
FROM: CODER_AGENT_E
TO: SCRUM_MASTER

TASKS COMPLETE:
✅ PT-001-ATOMIC-01 - Created module init
✅ PT-001-ATOMIC-02 - Created models init
✅ PT-001-ATOMIC-03 - Created evv_patient model
✅ PT-001-ATOMIC-04 - Created partner extension

VERIFICATION: All files match specs exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

## NOTES

- Phase A establishes model foundation (4 tasks)
- Phase B will add security & views (4 tasks)
- Total: 8 atomic tasks for complete module rebuild
- This replaces the old evv_patients module with proper architecture

Context: `aos-architecture/work_orders/atomic/README.md`

