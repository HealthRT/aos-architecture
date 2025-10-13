---
title: "VISIT-001-ATOMIC-07: Add evv_core dependency to evv_visits"
epic: "VISIT-001"
operation: "MODIFY FILE"
sequence: 7
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: VISIT-001-ATOMIC-07

**Operation:** MODIFY FILE

**Target File Path:** `evv/addons/evv_visits/__manifest__.py`

**Original Content:**
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

**Instructions:**
The depends list already includes evv_core. No changes needed - this file is already correct.

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
ATOMIC TASK COMPLETE - VISIT-001-ATOMIC-07

File: evv/addons/evv_visits/__manifest__.py

Content:
[paste complete file content here - it should be identical to original]
```

---

**Parent Work Order:** VISIT-001  
**Authority:** Executive Architect Directive EA-044 (Operation Craftsman)  
**Created:** 2025-10-14 03:22:00 UTC

**Note:** This task verifies the dependency is present. The original ATOMIC-03 already included evv_core in the depends list, so this is a verification task.

