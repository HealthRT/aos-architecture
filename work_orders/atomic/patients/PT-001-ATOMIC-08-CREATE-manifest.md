---
title: "PT-001-ATOMIC-08: Create module manifest"
epic: "PT-001B"
operation: "CREATE FILE"
sequence: 8
repository: "evv"
assignee: "aos-coder-agent"
phase: "B - Security & Views"
---

# Atomic Work Order: PT-001-ATOMIC-08

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_patients/__manifest__.py`

**Instructions:**
Create the module manifest with proper Odoo 18 metadata. Depends on evv_core and evv_case_managers. Load security ACLs before views.

**Required Final Content:**
```python
{
    "name": "EVV Patients",
    "version": "18.0.1.0.0",
    "category": "Healthcare/EVV",
    "summary": "HIPAA-compliant patient record model for EVV",
    "description": """
        Electronic Visit Verification - Patient Records
        
        Manages patient demographics, external IDs, case manager assignments,
        and medical record numbers for EVV system.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "evv_core",
        "evv_case_managers",
    ],
    "data": [
        "security/ir.model.access.csv",
        "views/evv_patient_views.xml",
    ],
    "installable": True,
    "application": False,
    "auto_install": False,
}
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-08 - Created module manifest

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001B - Patient Records (Phase B: Security & Views)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:58:00 UTC

