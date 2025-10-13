---
title: "PT-001-ATOMIC-05: Create security ACLs"
epic: "PT-001B"
operation: "CREATE FILE"
sequence: 5
repository: "evv"
assignee: "aos-coder-agent"
phase: "B - Security & Views"
---

# Atomic Work Order: PT-001-ATOMIC-05

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_patients/security/ir.model.access.csv`

**Instructions:**
Create security ACLs for evv.patient model. Use evv_core.group_evv_manager for full access and base.group_user for read-only access.

**Required Final Content:**
```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_evv_patient_user,evv.patient.user,model_evv_patient,base.group_user,1,0,0,0
access_evv_patient_manager,evv.patient.manager,model_evv_patient,evv_core.group_evv_manager,1,1,1,1
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-05 - Created security ACLs

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001B - Patient Records (Phase B: Security & Views)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:55:00 UTC

