---
title: "PT-001-ATOMIC-04: Create partner extension"
epic: "PT-001A"
operation: "CREATE FILE"
sequence: 4
repository: "evv"
assignee: "aos-coder-agent"
phase: "A - Foundation & Models"
---

# Atomic Work Order: PT-001-ATOMIC-04

**Operation:** CREATE FILE

**Target File Path:** `evv/addons/evv_patients/models/partner.py`

**Instructions:**
Create res.partner extension that overrides display_name computation to add patient context (MRN) when a partner is linked to a patient record.

**Required Final Content:**
```python
from odoo import api, models


class ResPartner(models.Model):
    _inherit = "res.partner"

    def _compute_display_name(self):
        """
        Override to disambiguate partners linked to EVV patients.
        Display format: "Partner Name (Patient, MRN: 12345)"
        Only applies to partners that have an associated evv.patient record.
        """
        super()._compute_display_name()
        for partner in self:
            # Check if this partner is linked to a patient record
            patient = self.env["evv.patient"].search(
                [("partner_id", "=", partner.id)], limit=1
            )

            if patient and patient.mrn:
                # Disambiguate with patient context
                partner.display_name = f"{partner.display_name} (Patient, MRN: {patient.mrn})"
```

---

## Submission Format

Use the streamlined format:

```
TASKS COMPLETE:
✅ PT-001-ATOMIC-04 - Created partner extension

VERIFICATION: Content matches spec exactly
Branch: feature/PT-001-ATOMIC-patients-rebuild
```

---

**Parent Epic:** PT-001A - Patient Records (Phase A: Foundation & Models)  
**Authority:** Scrum Master (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:53:00 UTC

