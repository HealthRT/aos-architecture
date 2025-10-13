---
title: "CORE-002-ATOMIC-02: Create evv_core security groups"
epic: "CORE-002"
operation: "CREATE FILE"
sequence: 2
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: CORE-002-ATOMIC-02

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_core/security/groups.xml`

**Instructions:**
Create the security groups XML file defining the EVV Manager group. This group will have administrative permissions for EVV modules.

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data>
        <!-- EVV Security Category -->
        <record id="module_category_evv" model="ir.module.category">
            <field name="name">EVV (Electronic Visit Verification)</field>
            <field name="description">Security groups for EVV system</field>
            <field name="sequence">10</field>
        </record>

        <!-- EVV Manager Group -->
        <record id="group_evv_manager" model="res.groups">
            <field name="name">EVV Manager</field>
            <field name="category_id" ref="module_category_evv"/>
            <field name="implied_ids" eval="[(4, ref('base.group_user'))]"/>
            <field name="comment">EVV Managers have full access to all EVV modules including visits, patients, agreements, and case managers.</field>
        </record>
    </data>
</odoo>
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - CORE-002-ATOMIC-02

File: evv/addons/evv_core/security/groups.xml

Content:
[paste complete file content here]
```

---

**Parent Epic:** CORE-002 - Foundational EVV Security Groups  
**Authority:** Executive Architect Directive EA-044 (Operation Craftsman)  
**Created:** 2025-10-14 03:15:00 UTC

