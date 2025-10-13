---
title: "PT-001-ATOMIC-07: Create window action and menu"
epic: "PT-001B"
operation: "MODIFY FILE"
sequence: 7
repository: "evv"
assignee: "aos-coder-agent"
phase: "B - Security & Views"
---

# Atomic Work Order: PT-001-ATOMIC-07

**Operation:** MODIFY FILE

**Target File Path:** `evv/addons/evv_patients/views/evv_patient_views.xml`

**Original Content:**
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

**Instructions:**
Add window action and menu item to the end of the file. Menu should be under evv_core.menu_evv_root.

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

    <!-- Window Action -->
    <record id="action_evv_patient" model="ir.actions.act_window">
        <field name="name">Patients</field>
        <field name="res_model">evv.patient</field>
        <field name="view_mode">list,form</field>
        <field name="context">{}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                Create your first patient record
            </p>
            <p>
                Manage patient information, medical record numbers, and case manager assignments.
            </p>
        </field>
    </record>

    <!-- Menu Item -->
    <menuitem id="menu_evv_patient"
              name="Patients"
              parent="evv_core.menu_evv_root"
              action="action_evv_patient"
              sequence="10"/>
</odoo>
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-07 - Added action and menu to views

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001B - Patient Records (Phase B: Security & Views)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:57:00 UTC

