---
title: "CORE-002-ATOMIC-04: Update manifest to load menus"
epic: "CORE-002"
operation: "MODIFY FILE"
sequence: 4
repository: "evv"
assignee: "aos-coder-agent"
phase: "Foundation - Menu Structure"
---

# Atomic Work Order: CORE-002-ATOMIC-04

**Operation:** MODIFY FILE

**Target File Path:** `evv/addons/evv_core/__manifest__.py`

**Original Content:**
```python
{
    "name": "EVV Core",
    "version": "18.0.1.0.0",
    "category": "Healthcare/EVV",
    "summary": "Core Security Groups and Shared Definitions for EVV System",
    "description": """
        Foundational module for the Electronic Visit Verification system.
        Contains shared security groups, access rights, and core definitions.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "base",
    ],
    "data": [
        "security/groups.xml",
    ],
    "installable": True,
    "application": False,
    "auto_install": False,
}
```

**Instructions:**
Add the new `views/menus.xml` file to the `data` list, placed after `security/groups.xml`.

**Required Final Content:**
```python
{
    "name": "EVV Core",
    "version": "18.0.1.0.0",
    "category": "Healthcare/EVV",
    "summary": "Core Security Groups and Shared Definitions for EVV System",
    "description": """
        Foundational module for the Electronic Visit Verification system.
        Contains shared security groups, access rights, and core definitions.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "base",
    ],
    "data": [
        "security/groups.xml",
        "views/menus.xml",
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
✅ CORE-002-ATOMIC-03 - Created EVV root menu
✅ CORE-002-ATOMIC-04 - Updated manifest to load menus

VERIFICATION: Both files match specs exactly
Branch: feature/VISIT-001-CODE-01-visit-model-foundation-atomic
```

---

**Parent Epic:** CORE-002 - EVV Core Security Module  
**Authority:** Scrum Master (Blocker Resolution)  
**Created:** 2025-10-14 04:36:00 UTC  
**Priority:** CRITICAL - Blocks evv_visits module loading

