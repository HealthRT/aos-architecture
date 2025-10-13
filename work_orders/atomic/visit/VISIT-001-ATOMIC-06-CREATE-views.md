---
title: "VISIT-001-ATOMIC-06: Create evv.visit views"
epic: "VISIT-001"
operation: "CREATE FILE"
sequence: 6
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: VISIT-001-ATOMIC-06

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_visits/views/evv_visit_views.xml`

**Instructions:**
Create XML views file for the evv.visit model including:

1. **Form View**: Display all fields with state-based action buttons
2. **Tree View**: List view with key fields
3. **Search View**: Filters and group by options
4. **Window Action**: Link to views
5. **Menu Item**: Main menu entry under EVV application

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Form View -->
    <record id="view_evv_visit_form" model="ir.ui.view">
        <field name="name">evv.visit.form</field>
        <field name="model">evv.visit</field>
        <field name="arch" type="xml">
            <form string="Visit">
                <header>
                    <button name="action_start_visit" string="Start Visit" 
                            type="object" class="btn-primary"
                            invisible="state != 'draft'"/>
                    <button name="action_complete_visit" string="Complete Visit" 
                            type="object" class="btn-success"
                            invisible="state != 'in_progress'"/>
                    <button name="action_cancel" string="Cancel" 
                            type="object" class="btn-warning"
                            invisible="state in ['completed', 'cancelled']"/>
                    <field name="state" widget="statusbar" 
                           statusbar_visible="draft,in_progress,completed"/>
                </header>
                <sheet>
                    <group>
                        <group string="Visit Information">
                            <field name="name" readonly="1"/>
                            <field name="patient_id"/>
                            <field name="dsp_id"/>
                            <field name="service_agreement_id"/>
                        </group>
                        <group string="Time Tracking">
                            <field name="clock_in_time"/>
                            <field name="clock_in_location"/>
                            <field name="clock_out_time"/>
                            <field name="clock_out_location"/>
                        </group>
                    </group>
                    <group string="Notes">
                        <field name="notes" nolabel="1"/>
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
    <record id="view_evv_visit_tree" model="ir.ui.view">
        <field name="name">evv.visit.tree</field>
        <field name="model">evv.visit</field>
        <field name="arch" type="xml">
            <list string="Visits">
                <field name="name"/>
                <field name="patient_id"/>
                <field name="dsp_id"/>
                <field name="clock_in_time"/>
                <field name="clock_out_time"/>
                <field name="state" decoration-info="state == 'draft'" 
                       decoration-warning="state == 'in_progress'"
                       decoration-success="state == 'completed'"
                       decoration-danger="state == 'cancelled'"/>
            </list>
        </field>
    </record>

    <!-- Search View -->
    <record id="view_evv_visit_search" model="ir.ui.view">
        <field name="name">evv.visit.search</field>
        <field name="model">evv.visit</field>
        <field name="arch" type="xml">
            <search string="Visits">
                <field name="patient_id"/>
                <field name="dsp_id"/>
                <field name="service_agreement_id"/>
                <filter string="Draft" name="filter_draft" 
                        domain="[('state', '=', 'draft')]"/>
                <filter string="In Progress" name="filter_in_progress" 
                        domain="[('state', '=', 'in_progress')]"/>
                <filter string="Completed" name="filter_completed" 
                        domain="[('state', '=', 'completed')]"/>
                <group expand="0" string="Group By">
                    <filter string="Patient" name="group_patient" 
                            context="{'group_by': 'patient_id'}"/>
                    <filter string="DSP" name="group_dsp" 
                            context="{'group_by': 'dsp_id'}"/>
                    <filter string="Status" name="group_state" 
                            context="{'group_by': 'state'}"/>
                </group>
            </search>
        </field>
    </record>

    <!-- Window Action -->
    <record id="action_evv_visit" model="ir.actions.act_window">
        <field name="name">Visits</field>
        <field name="res_model">evv.visit</field>
        <field name="view_mode">list,form</field>
        <field name="context">{}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                Create a new visit record
            </p>
            <p>
                Track service delivery visits with clock-in/out times.
            </p>
        </field>
    </record>

    <!-- Menu Item -->
    <menuitem id="menu_evv_visit"
              name="Visits"
              parent="evv_core.menu_evv_root"
              action="action_evv_visit"
              sequence="30"/>
</odoo>
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE

File: evv/addons/evv_visits/views/evv_visit_views.xml

Content:
[paste complete file content here]
```

---

**Parent Work Order:** VISIT-001-CODE-01  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 01:20:00 UTC

