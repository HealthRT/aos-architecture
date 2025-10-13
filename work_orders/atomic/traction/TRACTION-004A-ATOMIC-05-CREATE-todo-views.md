---
title: "TRACTION-004A-ATOMIC-05: Create to-do views"
epic: "TRACTION-004A"
operation: "CREATE FILE"
sequence: 5
repository: "hub"
assignee: "aos-coder-agent"
phase: "A - To-Do Model & Views"
---

# Atomic Work Order: TRACTION-004A-ATOMIC-05

**Operation:** CREATE FILE

**Target File Path:** `hub/addons/traction/views/traction_todo_views.xml`

**Instructions:**
Create the UI views for the `traction.todo` model. Include form view (with header buttons for mark_done/cancel and statusbar), tree view (with state decorations), search view (with filters by state and group-by assignee/state), window action, and menu item under the main traction menu.

**Required Final Content:**
```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Form View -->
    <record id="view_traction_todo_form" model="ir.ui.view">
        <field name="name">traction.todo.form</field>
        <field name="model">traction.todo</field>
        <field name="arch" type="xml">
            <form string="To-Do">
                <header>
                    <button name="action_mark_done" string="Mark Done"
                            type="object" class="btn-success"
                            invisible="state != 'open'"/>
                    <button name="action_cancel" string="Cancel"
                            type="object" class="btn-warning"
                            invisible="state in ['done', 'cancelled']"/>
                    <field name="state" widget="statusbar"
                           statusbar_visible="open,done"/>
                </header>
                <sheet>
                    <group>
                        <group string="To-Do Details">
                            <field name="name"/>
                            <field name="assignee_id"/>
                            <field name="due_date"/>
                        </group>
                        <group string="Group Ownership">
                            <field name="owner_group_id"/>
                            <field name="visible_group_ids" widget="many2many_tags"/>
                            <field name="origin_group_id"/>
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
    <record id="view_traction_todo_tree" model="ir.ui.view">
        <field name="name">traction.todo.tree</field>
        <field name="model">traction.todo</field>
        <field name="arch" type="xml">
            <list string="To-Dos">
                <field name="name"/>
                <field name="assignee_id"/>
                <field name="owner_group_id"/>
                <field name="due_date"/>
                <field name="state"
                       decoration-success="state == 'done'"
                       decoration-danger="state == 'cancelled'"
                       decoration-info="state == 'open'"/>
            </list>
        </field>
    </record>

    <!-- Search View -->
    <record id="view_traction_todo_search" model="ir.ui.view">
        <field name="name">traction.todo.search</field>
        <field name="model">traction.todo</field>
        <field name="arch" type="xml">
            <search string="To-Dos">
                <field name="name"/>
                <field name="assignee_id"/>
                <field name="owner_group_id"/>
                <filter string="Open" name="filter_open"
                        domain="[('state', '=', 'open')]"/>
                <filter string="Done" name="filter_done"
                        domain="[('state', '=', 'done')]"/>
                <filter string="Overdue" name="filter_overdue"
                        domain="[('due_date', '&lt;', context_today().strftime('%Y-%m-%d')), ('state', '=', 'open')]"/>
                <group expand="0" string="Group By">
                    <filter string="Assignee" name="group_assignee"
                            context="{'group_by': 'assignee_id'}"/>
                    <filter string="Owner Group" name="group_owner"
                            context="{'group_by': 'owner_group_id'}"/>
                    <filter string="Status" name="group_state"
                            context="{'group_by': 'state'}"/>
                </group>
            </search>
        </field>
    </record>

    <!-- Window Action -->
    <record id="action_traction_todo" model="ir.actions.act_window">
        <field name="name">To-Dos</field>
        <field name="res_model">traction.todo</field>
        <field name="view_mode">list,form</field>
        <field name="context">{'search_default_filter_open': 1}</field>
        <field name="help" type="html">
            <p class="o_view_nocontent_smiling_face">
                Create your first To-Do
            </p>
            <p>
                Track action items and assignments for your traction groups.
            </p>
        </field>
    </record>

    <!-- Menu Item -->
    <menuitem id="menu_traction_todo"
              name="To-Dos"
              parent="menu_traction_root"
              action="action_traction_todo"
              sequence="20"/>
</odoo>
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - TRACTION-004A-ATOMIC-05

File: hub/addons/traction/views/traction_todo_views.xml

Content:
[paste complete file content here]
```

---

**Parent Epic:** TRACTION-004A - To-Do Model & Views (Phase A)  
**Authority:** Executive Architect Directive EA-046 (Phased Atomic Decomposition)  
**Created:** 2025-10-14 03:42:00 UTC

