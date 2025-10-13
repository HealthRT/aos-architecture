---
title: "PT-001-ATOMIC-06: Create patient views"
epic: "PT-001B"
operation: "CREATE FILE"
sequence: 6
repository: "evv"
assignee: "aos-coder-agent"
phase: "B - Security & Views"
---

# Atomic Work Order: PT-001-ATOMIC-06

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_patients/views/evv_patient_views.xml`

**Instructions:**
Create form, tree, and search views for evv.patient model. Include chatter in form view. Form should group fields logically.

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Form View -->
    <record id="view_evv_patient_form" model="ir.ui.view">
        <field name="name">evv.patient.form</field>
        <field name="model">evv.patient</field>
        <field name="arch" type="xml">
            <form string="Patient">
                <sheet>
                    <group>
                        <group string="Patient Information">
                            <field name="partner_id"/>
                            <field name="name" readonly="1"/>
                            <field name="mrn"/>
                        </group>
                        <group string="External IDs & Assignment">
                            <field name="recipient_id_external"/>
                            <field name="case_manager_id"/>
                        </group>
                    </group>
                </sheet>
                <div class="oe_chatter">
                    <field name="message_follower_ids"/>
                    <field name="activity_ids"/>
                    <field name="message_ids"/>
                </div>
            </form>
        </field>
    </record>

    <!-- Tree View -->
    <record id="view_evv_patient_tree" model="ir.ui.view">
        <field name="name">evv.patient.tree</field>
        <field name="model">evv.patient</field>
        <field name="arch" type="xml">
            <list string="Patients">
                <field name="name"/>
                <field name="mrn"/>
                <field name="recipient_id_external"/>
                <field name="case_manager_id"/>
            </list>
        </field>
    </record>

    <!-- Search View -->
    <record id="view_evv_patient_search" model="ir.ui.view">
        <field name="name">evv.patient.search</field>
        <field name="model">evv.patient</field>
        <field name="arch" type="xml">
            <search string="Patients">
                <field name="name"/>
                <field name="mrn"/>
                <field name="recipient_id_external"/>
                <field name="case_manager_id"/>
                <group expand="0" string="Group By">
                    <filter string="Case Manager" name="group_case_manager"
                            context="{'group_by': 'case_manager_id'}"/>
                </group>
            </search>
        </field>
    </record>
</odoo>
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-06 - Created patient views (form/tree/search)

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001B - Patient Records (Phase B: Security & Views)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:56:00 UTC

