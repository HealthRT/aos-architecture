---
title: "CORE-002-ATOMIC-03: Create EVV root menu"
epic: "CORE-002"
operation: "CREATE FILE"
sequence: 3
repository: "evv"
assignee: "aos-coder-agent"
phase: "Foundation - Menu Structure"
---

# Atomic Work Order: CORE-002-ATOMIC-03

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_core/views/menus.xml`

**Instructions:**
Create the root menu structure for the EVV system. This menu will be the parent for all EVV module menus (visits, patients, agreements, case managers).

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data>
        <!-- EVV Root Menu -->
        <menuitem id="menu_evv_root"
                  name="EVV"
                  sequence="10"/>
    </data>
</odoo>
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ CORE-002-ATOMIC-03 - Created EVV root menu

VERIFICATION: Content matches spec exactly
Branch: feature/VISIT-001-CODE-01-visit-model-foundation-atomic
```

---

**Parent Epic:** CORE-002 - EVV Core Security Module  
**Authority:** Scrum Master (Blocker Resolution)  
**Created:** 2025-10-14 04:35:00 UTC  
**Priority:** CRITICAL - Blocks evv_visits module loading

