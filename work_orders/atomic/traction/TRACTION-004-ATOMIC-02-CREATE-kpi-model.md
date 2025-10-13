---
title: "TRACTION-004-ATOMIC-02: Create traction.scorecard.kpi model"
epic: "TRACTION-004"
operation: "CREATE FILE"
sequence: 2
repository: "hub"
assignee: "aos-coder-agent"
---

# Atomic Work Order: TRACTION-004-ATOMIC-02

**Operation:** CREATE FILE

**Target File Path:** `hub/addons/traction/models/scorecard_kpi.py`

**Instructions:**
Create the `traction.scorecard.kpi` model for Key Performance Indicators in the Traction EOS scorecard system.

**Required Fields:**
- name (Char, required): KPI name
- unit (Char, required): Measurement unit (e.g., "calls", "dollars", "%")
- target (Float, required): Target value (must be >= 0)
- owner_group_id (Many2one to traction.group, required): Owning group
- visible_group_ids (Many2many to traction.group): Groups that can see this KPI
- uuid (Char, readonly): Auto-generated unique ID

**Required Methods:**
- record_measurement(value, date): Placeholder that raises NotImplementedError with message about future measurement model

**Required Final Content:**
```python
import uuid as uuid_lib
from odoo import models, fields, api, _
from odoo.exceptions import UserError


class TractionScorecardKPI(models.Model):
    _name = "traction.scorecard.kpi"
    _description = "Traction Scorecard KPI"
    _inherit = ["mail.thread", "mail.activity.mixin"]
    _order = "name"

    name = fields.Char(
        string="KPI Name",
        required=True,
        tracking=True,
    )
    unit = fields.Char(
        string="Unit of Measure",
        required=True,
        help="e.g., 'calls', 'dollars', '%'",
        tracking=True,
    )
    target = fields.Float(
        string="Target Value",
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
        help="Groups that can see this KPI",
    )
    uuid = fields.Char(
        string="UUID",
        readonly=True,
        copy=False,
        default=lambda self: str(uuid_lib.uuid4()),
    )

    _sql_constraints = [
        (
            "target_positive",
            "CHECK(target >= 0)",
            "Target value must be positive or zero.",
        ),
    ]

    @api.model
    def create(self, vals):
        if "uuid" not in vals:
            vals["uuid"] = str(uuid_lib.uuid4())
        return super().create(vals)

    def record_measurement(self, value, date):
        """
        Placeholder for recording KPI measurements.
        Will be implemented in future work order for measurement tracking.
        """
        raise NotImplementedError(
            _("KPI measurement recording will be implemented in a future story. "
              "This feature depends on the traction.scorecard.measurement model.")
        )
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - TRACTION-004-ATOMIC-02

File: hub/addons/traction/models/scorecard_kpi.py

Content:
[paste complete file content here]
```

---

**Parent Work Order:** TRACTION-004  
**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Created:** 2025-10-14 02:45:00 UTC

