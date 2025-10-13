---
title: "PT-001-ATOMIC-03: Create evv_patient model"
epic: "PT-001A"
operation: "CREATE FILE"
sequence: 3
repository: "evv"
assignee: "aos-coder-agent"
phase: "A - Foundation & Models"
---

# Atomic Work Order: PT-001-ATOMIC-03

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_patients/models/evv_patient.py`

**Instructions:**
Create the core evv.patient model with partner relationship, external ID tracking, case manager link, and MRN. Include SQL constraint for unique external ID.

**Required Final Content:**
```python
from odoo import fields, models


class EvvPatient(models.Model):
    _name = "evv.patient"
    _description = "EVV Patient Record"
    _inherit = ["mail.thread", "mail.activity.mixin"]
    _rec_name = "name"
    _order = "name"

    partner_id = fields.Many2one(
        "res.partner",
        string="Contact",
        required=True,
        ondelete="restrict",
        domain=[("is_company", "=", False)],
        tracking=True,
    )
    name = fields.Char(
        string="Name",
        related="partner_id.name",
        store=True,
        readonly=True,
    )
    recipient_id_external = fields.Char(
        string="External Recipient ID",
        help="Unique identifier from external systems (e.g., Medicaid ID)",
        tracking=True,
    )
    case_manager_id = fields.Many2one(
        "evv.case_manager",
        string="Case Manager",
        ondelete="set null",
        tracking=True,
    )
    mrn = fields.Char(
        string="Medical Record Number",
        help="Medical Record Number for patient identification",
        tracking=True,
    )

    _sql_constraints = [
        (
            "recipient_id_external_unique",
            "UNIQUE(recipient_id_external)",
            "External recipient ID must be unique if provided.",
        )
    ]
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-03 - Created evv_patient model

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001A - Patient Records (Phase A: Foundation & Models)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:52:00 UTC

