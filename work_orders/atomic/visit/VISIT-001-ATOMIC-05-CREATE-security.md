---
title: "VISIT-001-ATOMIC-05: Create evv_visits security ACL"
epic: "VISIT-001"
operation: "CREATE FILE"
sequence: 5
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: VISIT-001-ATOMIC-05

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_visits/security/ir.model.access.csv`

**Instructions:**
Create the security access control list (ACL) file for the evv.visit model.

Provide access rules for:
- `base.group_user` (Internal Users): Read-only access
- `evv_core.group_evv_manager` (EVV Managers): Full access (create, read, write, delete)

**Required Final Content:**
```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_evv_visit_user,evv.visit.user,model_evv_visit,base.group_user,1,0,0,0
access_evv_visit_manager,evv.visit.manager,model_evv_visit,evv_core.group_evv_manager,1,1,1,1
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE

File: evv/addons/evv_visits/security/ir.model.access.csv

Content:
[paste complete file content here]
```

---

**Parent Work Order:** VISIT-001-CODE-01  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 01:20:00 UTC

