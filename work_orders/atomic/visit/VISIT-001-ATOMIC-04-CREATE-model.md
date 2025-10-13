---
title: "VISIT-001-ATOMIC-04: Create evv.visit model"
epic: "VISIT-001"
operation: "CREATE FILE"
sequence: 4
repository: "evv"
assignee: "aos-coder-agent"
---

# Atomic Work Order: VISIT-001-ATOMIC-04

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_visits/models/evv_visit.py`

**Instructions:**
Create the `evv.visit` model with the following specifications:

**Required Fields:**
- `patient_id` (Many2one to evv.patient) - Required
- `dsp_id` (Many2one to hr.employee) - Required, represents Direct Support Professional
- `service_agreement_id` (Many2one to service.agreement) - Required
- `clock_in_time` (Datetime) - Required
- `clock_out_time` (Datetime)
- `clock_in_location` (Char) - GPS coordinates
- `clock_out_location` (Char) - GPS coordinates
- `state` (Selection) - States: draft, in_progress, completed, cancelled - Default: draft
- `notes` (Text) - Service delivery notes

**Computed Fields:**
- `name` (Char, compute='_compute_name', store=True) - Computed from patient name and clock-in time

**Business Logic Methods:**
- `action_start_visit()` - Transition from draft to in_progress
- `action_complete_visit()` - Transition from in_progress to completed
- `action_cancel()` - Cancel visit

**Constraints:**
- SQL constraint: clock_out_time must be after clock_in_time (if both present)
- Python constraint: Cannot complete visit without clock_out_time

**Inheritance:**
- Inherit from `mail.thread` for communication features

**Required Final Content:**
```python
from odoo import models, fields, api, _
from odoo.exceptions import ValidationError


class EvvVisit(models.Model):
    _name = "evv.visit"
    _description = "EVV Visit Record"
    _inherit = ["mail.thread", "mail.activity.mixin"]
    _order = "clock_in_time desc"

    # Required fields
    name = fields.Char(
        string="Visit Reference",
        compute="_compute_name",
        store=True,
        readonly=True,
    )
    patient_id = fields.Many2one(
        "evv.patient",
        string="Patient",
        required=True,
        ondelete="restrict",
        tracking=True,
    )
    dsp_id = fields.Many2one(
        "hr.employee",
        string="DSP (Direct Support Professional)",
        required=True,
        ondelete="restrict",
        tracking=True,
    )
    service_agreement_id = fields.Many2one(
        "service.agreement",
        string="Service Agreement",
        required=True,
        ondelete="restrict",
        tracking=True,
    )

    # Time tracking
    clock_in_time = fields.Datetime(
        string="Clock In",
        required=True,
        default=fields.Datetime.now,
        tracking=True,
    )
    clock_out_time = fields.Datetime(
        string="Clock Out",
        tracking=True,
    )
    clock_in_location = fields.Char(
        string="Clock In Location (GPS)",
        help="GPS coordinates: latitude,longitude",
    )
    clock_out_location = fields.Char(
        string="Clock Out Location (GPS)",
        help="GPS coordinates: latitude,longitude",
    )

    # State and notes
    state = fields.Selection(
        [
            ("draft", "Draft"),
            ("in_progress", "In Progress"),
            ("completed", "Completed"),
            ("cancelled", "Cancelled"),
        ],
        string="Status",
        default="draft",
        required=True,
        tracking=True,
    )
    notes = fields.Text(
        string="Service Notes",
        tracking=True,
    )

    # Computed name field
    @api.depends("patient_id", "clock_in_time")
    def _compute_name(self):
        for record in self:
            if record.patient_id and record.clock_in_time:
                clock_in_str = fields.Datetime.to_string(record.clock_in_time)
                record.name = f"{record.patient_id.name} - {clock_in_str}"
            else:
                record.name = "New Visit"

    # SQL Constraints
    _sql_constraints = [
        (
            "check_clock_times",
            "CHECK(clock_out_time IS NULL OR clock_out_time > clock_in_time)",
            "Clock out time must be after clock in time.",
        ),
    ]

    # Python Constraints
    @api.constrains("state", "clock_out_time")
    def _check_completed_has_clock_out(self):
        for record in self:
            if record.state == "completed" and not record.clock_out_time:
                raise ValidationError(
                    _("Cannot complete visit without clock out time.")
                )

    # Business Logic Methods
    def action_start_visit(self):
        """Transition visit from draft to in_progress"""
        for record in self:
            if record.state != "draft":
                raise ValidationError(
                    _("Only draft visits can be started.")
                )
            record.state = "in_progress"
        return True

    def action_complete_visit(self):
        """Transition visit from in_progress to completed"""
        for record in self:
            if record.state != "in_progress":
                raise ValidationError(
                    _("Only in-progress visits can be completed.")
                )
            if not record.clock_out_time:
                raise ValidationError(
                    _("Clock out time is required to complete the visit.")
                )
            record.state = "completed"
        return True

    def action_cancel(self):
        """Cancel the visit"""
        for record in self:
            if record.state == "completed":
                raise ValidationError(
                    _("Cannot cancel a completed visit.")
                )
            record.state = "cancelled"
        return True
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE

File: evv/addons/evv_visits/models/evv_visit.py

Content:
[paste complete file content here]
```

---

**Parent Work Order:** VISIT-001-CODE-01  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 01:20:00 UTC

