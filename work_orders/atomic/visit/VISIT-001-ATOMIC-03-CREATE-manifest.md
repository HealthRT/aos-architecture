---
title: "VISIT-001-ATOMIC-03: Create evv_visits __manifest__.py"
epic: "VISIT-001"
operation: "CREATE FILE"
sequence: 3
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: VISIT-001-ATOMIC-03

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_visits/__manifest__.py`

**Instructions:**
Create the module manifest file for `evv_visits`. The module depends on `evv_core`, `evv_patients`, `evv_agreements`, and `hr` (for DSP employee integration).

Include data files for:
- Security ACL (security/ir.model.access.csv)
- Views (views/evv_visit_views.xml)

**Required Final Content:**
```python
{
    "name": "EVV Visits",
    "version": "18.0.1.0.0",
    "category": "Healthcare/EVV",
    "summary": "Electronic Visit Verification - Visit Tracking",
    "description": """
        Core visit tracking module for EVV system.
        Manages clock-in/out, service delivery, and compliance tracking.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "evv_core",
        "evv_patients",
        "evv_agreements",
        "hr",
    ],
    "data": [
        "security/ir.model.access.csv",
        "views/evv_visit_views.xml",
    ],
    "installable": True,
    "application": False,
    "auto_install": False,
}
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE

File: evv/addons/evv_visits/__manifest__.py

Content:
[paste complete file content here]
```

---

**Parent Work Order:** VISIT-001-CODE-01  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 01:20:00 UTC

