---
title: "TRACTION-004-ATOMIC-01: Create traction.todo model"
epic: "TRACTION-004"
operation: "CREATE FILE"
sequence: 1
repository: "hub"
assignee: "aos-coder-agent"
---

# Atomic Work Order: TRACTION-004-ATOMIC-01

**Operation:** CREATE FILE

**Target File Path:** `hub/addons/traction/models/todo.py`

**Instructions:**
Create the `traction.todo` model with fields for to-do items in the Traction EOS system.

**Required Fields:**
- name (Char, required): To-do description
- owner_group_id (Many2one to traction.group, required): Owning group
- visible_group_ids (Many2many to traction.group): Groups that can see this to-do
- origin_group_id (Many2one to traction.group): Group where to-do originated
- assignee_id (Many2one to res.users): Person assigned
- due_date (Date): Optional deadline
- state (Selection): open, done, cancelled (default: open)
- uuid (Char, readonly): Auto-generated unique ID

**Required Methods:**
- action_mark_done(): Set state to done, log message
- action_cancel(): Set state to cancelled, log message

**Required Final Content:**
```python
import uuid as uuid_lib
from odoo import models, fields, api, _
from odoo.exceptions import UserError


class TractionTodo(models.Model):
    _name = "traction.todo"
    _description = "Traction To-Do Item"
    _inherit = ["mail.thread", "mail.activity.mixin"]
    _order = "due_date asc, id desc"

    name = fields.Char(
        string="To-Do",
        required=True,
        tracking=True,
    )
    owner_group_id = fields.Many2one(
        "traction.group",
        string="Owner Group",
        required=True,
        ondelete="restrict",
        tracking=True,
    )
    visible_group_ids = fields.Many2many(
        "traction.group",
        string="Visible To Groups",
        help="Groups that can see this to-do",
    )
    origin_group_id = fields.Many2one(
        "traction.group",
        string="Origin Group",
        help="Group where this to-do originated",
        ondelete="set null",
    )
    assignee_id = fields.Many2one(
        "res.users",
        string="Assigned To",
        ondelete="set null",
        tracking=True,
    )
    due_date = fields.Date(
        string="Due Date",
        tracking=True,
    )
    state = fields.Selection(
        [
            ("open", "Open"),
            ("done", "Done"),
            ("cancelled", "Cancelled"),
        ],
        string="Status",
        default="open",
        required=True,
        tracking=True,
    )
    uuid = fields.Char(
        string="UUID",
        readonly=True,
        copy=False,
        default=lambda self: str(uuid_lib.uuid4()),
    )

    @api.model
    def create(self, vals):
        if "uuid" not in vals:
            vals["uuid"] = str(uuid_lib.uuid4())
        return super().create(vals)

    def action_mark_done(self):
        """Mark to-do as done"""
        for record in self:
            if record.state == "done":
                raise UserError(_("To-do is already marked as done."))
            record.state = "done"
            record.message_post(
                body=_("To-do marked as done by %s") % self.env.user.name
            )
        return True

    def action_cancel(self):
        """Cancel the to-do"""
        for record in self:
            if record.state == "cancelled":
                raise UserError(_("To-do is already cancelled."))
            record.state = "cancelled"
            record.message_post(
                body=_("To-do cancelled by %s") % self.env.user.name
            )
        return True
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - TRACTION-004-ATOMIC-01

File: hub/addons/traction/models/todo.py

Content:
[paste complete file content here]
```

---

**Parent Work Order:** TRACTION-004  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 02:45:00 UTC

