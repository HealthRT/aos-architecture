---
title: "CORE-002-ATOMIC-01: Create evv_core module structure"
epic: "CORE-002"
operation: "CREATE FILES"
sequence: 1
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: CORE-002-ATOMIC-01

**Operation:** CREATE FILES (2 files)

**Target Files:**
1. `evv/addons/evv_core/__init__.py`
2. `evv/addons/evv_core/__manifest__.py`

**Instructions:**
Create the foundational module structure for evv_core, which will contain shared security groups and core EVV system definitions.

**File 1: `evv/addons/evv_core/__init__.py`**
```python
# -*- coding: utf-8 -*-
```

**File 2: `evv/addons/evv_core/__manifest__.py`**
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

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - CORE-002-ATOMIC-01

File 1: evv/addons/evv_core/__init__.py
Content:
[paste complete file content]

File 2: evv/addons/evv_core/__manifest__.py
Content:
[paste complete file content]
```

---

**Parent Epic:** CORE-002 - Foundational EVV Security Groups  
**Authority:** Executive Architect Directive EA-044 (Operation Craftsman)  
**Created:** 2025-10-14 03:15:00 UTC

