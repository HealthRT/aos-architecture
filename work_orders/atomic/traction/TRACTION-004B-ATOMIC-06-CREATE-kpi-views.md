---
title: "TRACTION-004B-ATOMIC-06: Create KPI views"
epic: "TRACTION-004B"
operation: "CREATE FILE"
sequence: 6
repository: "hub"
assignee: "aos-coder-agent"
phase: "B - KPI Views & Integration"
---

# Atomic Work Order: TRACTION-004B-ATOMIC-06

**Operation:** CREATE FILE

**Target File Path:** `hub/addons/traction/views/traction_scorecard_kpi_views.xml`

**Instructions:**
Create the UI views for the `traction.scorecard.kpi` model. Include form view (with computed field display and tracking fields), tree view, search view (with filters and group-by), window action, and menu item under the main traction menu.

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Form View -->
    <record id="view_traction_scorecard_kpi_form" model="ir.ui.view">
        <field name="name">traction.scorecard.kpi.form</field>
        <field name="model">traction.scorecard.kpi</field>
        <field name="arch" type="xml">
            <form string="Scorecard KPI">
                <sheet>
                    <group>
                        <group string="KPI Definition">
                            <field name="name"/>
                            <field name="unit"/>
                            <field name="target"/>
                        </group>
                        <group string="Group Ownership">
                            <field name="owner_group_id"/>
                            <field name="visible_group_ids" widget="many2many_tags"/>
                        </group>
                    </group>
                    <group string="Tracking">
                        <field name="uuid" readonly="1"/>
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
    <record id="view_traction_scorecard_kpi_tree" model="ir.ui.view">
        <field name="name">traction.scorecard.kpi.tree</field>
        <field name="model">traction.scorecard.kpi</field>
        <field name="arch" type="xml">
            <list string="Scorecard KPIs">
                <field name="name"/>
                <field name="unit"/>
                <field name="target"/>
                <field name="owner_group_id"/>
            </list>
        </field>
    </record>

    <!-- Search View -->
    <record id="view_traction_scorecard_kpi_search" model="ir.ui.view">
        <field name="name">traction.scorecard.kpi.search</field>
        <field name="model">traction.scorecard.kpi</field>
        <field name="arch" type="xml">
            <search string="Scorecard KPIs">
                <field name="name"/>
                <field name="owner_group_id"/>
                <field name="unit"/>
                <group expand="0" string="Group By">
                    <filter string="Owner Group" name="group_owner"
                            context="{'group_by': 'owner_group_id'}"/>
                    <filter string="Unit of Measure" name="group_unit"
                            context="{'group_by': 'unit'}"/>
                </group>
            </search>
        </field>
    </record>

    <!-- Window Action -->
    <record id="action_traction_scorecard_kpi" model="ir.actions.act_window">
        <field name="name">Scorecard KPIs</field>
        <field name="res_model">traction.scorecard.kpi</field>
        <field name="view_mode">list,form</field>
        <field name="context">{}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                Create your first Scorecard KPI
            </p>
            <p>
                Define measurable key performance indicators for your traction groups.
            </p>
        </field>
    </record>

    <!-- Menu Item -->
    <menuitem id="menu_traction_scorecard_kpi"
              name="Scorecard KPIs"
              parent="menu_traction_root"
              action="action_traction_scorecard_kpi"
              sequence="30"/>
</odoo>
```

---

## Submission Format

Use the new streamlined format:

```
TASKS COMPLETE:
✅ TRACTION-004B-ATOMIC-06 - Created KPI views XML

VERIFICATION: Content matches spec exactly
Branch: feature/TRACTION-004-todos-kpis-atomic
```

---

**Parent Epic:** TRACTION-004B - KPI Views & Integration (Phase B)  
**Authority:** Executive Architect Directive EA-046 (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:05:00 UTC

