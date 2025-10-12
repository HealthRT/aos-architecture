# Open Items & SME Questions: AGMT-001

**Story:** AGMT-001 - Create Simple Bucket Service Agreement  
**Module:** evv_agreements  
**Status:** In Development (MVP)  
**Last Updated:** 2025-10-11  
**Document Owner:** Executive Architect

---

## Purpose

This document tracks pending questions and clarifications needed from Subject Matter Experts (SMEs) regarding the Service Agreement model. Development will proceed with reasonable defaults while awaiting SME input, and adjustments will be made based on SME decisions.

---

## How to Use This Document

**For SMEs:**
1. Review each open question below
2. Provide your answer/decision in the designated space
3. Add any notes or context that might help implementation
4. Return completed document to Project Manager

**For Development Team:**
1. Questions marked "Non-Blocker" - proceed with noted default implementation
2. Questions marked "Blocker" - wait for SME decision before proceeding
3. Create follow-up work orders for any changes needed based on SME decisions

---

## Open Questions

### OI-001: PHI Classification - Case Manager Assignment

**Category:** Compliance / HIPAA  
**Priority:** Medium  
**Blocker:** No

**Question:**  
Should the `case_manager_id` field be classified as Protected Health Information (PHI)? This field links a service authorization to the county case manager assigned to that patient.

**Current Implementation:**  
Field is currently marked as PHI with a note: "OPEN ITEM: Confirm with compliance if case manager assignment is PHI"

**Rationale for PHI:**  
- Links specific patient to their case manager (reveals patient has services)
- Could be considered part of treatment/payment relationship

**Rationale for Non-PHI:**  
- Case manager is a county employee, not patient data
- Doesn't reveal patient identity or health information directly

**Impact if Changed:**  
If removed from PHI classification, this field could be included in logs, API responses, and less-restricted reports. If kept as PHI, stricter access controls and logging restrictions apply.

**SME Decision:**
[ ] Mark as PHI (more restrictive)  
[ ] Do NOT mark as PHI  
[ ] Other: _____________________

**SME Notes:**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

### OI-002: Required Fields - Procedure Code Modifiers

**Category:** Field Validation  
**Priority:** Low  
**Blocker:** No

**Question:**  
Can a service authorization exist with just a procedure code (e.g., "H2014") and no modifiers, or should the system require at least one modifier to be entered?

**Current Implementation:**  
All modifier fields (modifier_1, modifier_2, modifier_3, modifier_4) are optional. User can save a service authorization with only a procedure code.

**Background:**  
Real-world example from provided document shows:
- Line 04: H2014 + UC + U3 (2 modifiers)
- Line 05: H2014 + UC + U3 + U4 (3 modifiers)

**Impact if Changed:**  
If we require at least one modifier, the system would prevent saving service authorizations without modifiers. This could block legitimate use cases if some authorizations truly don't have modifiers.

**SME Decision:**
[ ] Keep all modifiers optional (current)  
[ ] Require at least modifier_1 to be filled  
[ ] Other: _____________________

**SME Notes:**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

### OI-003: Required Fields - Diagnosis Code

**Category:** Field Validation / Compliance  
**Priority:** Medium  
**Blocker:** No

**Question:**  
Is the ICD-10 diagnosis code mandatory for billing/compliance purposes, or can service authorizations be created in "draft" state without it initially?

**Current Implementation:**  
`diagnosis_code` field is optional. User can create and save service authorizations without entering a diagnosis code.

**Use Case Scenarios:**
- **Scenario A:** User enters service authorization from county letter → all data available → diagnosis code should be required
- **Scenario B:** User creates "draft" authorization while awaiting county approval → diagnosis code not yet known → should be optional until activation

**Impact if Changed:**  
- If made always required: Blocks draft creation when diagnosis unknown
- If required only for activation: Allows draft creation, enforces on action_activate

**SME Decision:**
[ ] Keep optional (current - allows drafts)  
[ ] Make required always (blocks drafts without diagnosis)  
[ ] Make required for activation only (validation in action_activate)  
[ ] Other: _____________________

**SME Notes:**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

### OI-004: Financial Fields - Rate Per Unit

**Category:** Field Validation / Business Rules  
**Priority:** Low  
**Blocker:** No

**Question:**  
Should `rate_per_unit` be required? Is it acceptable to have service authorizations in the system without rate information?

**Current Implementation:**  
`rate_per_unit` is optional. User can create service authorizations without entering a rate. `total_amount` will compute as $0.00 if rate is not provided.

**Use Case Scenarios:**
- **Scenario A:** Rate is always known from county authorization → should be required
- **Scenario B:** Rate may be determined later or updated → should be optional initially
- **Scenario C:** Some authorizations are tracked for compliance only, not billing → rate not applicable

**Impact if Changed:**  
If made required, system would prevent saving service authorizations without rate information.

**SME Decision:**
[ ] Keep optional (current)  
[ ] Make required always  
[ ] Make required for activation only  
[ ] Other: _____________________

**SME Notes:**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

### OI-005: Contact Organization - Additional Classification

**Category:** System Design / User Experience  
**Priority:** Low  
**Blocker:** No

**Question:**  
Beyond `is_patient` and `is_case_manager` boolean flags, should we implement additional contact classification mechanisms such as:
- Contact categories/tags (Odoo's `res.partner.category`)
- Additional boolean flags (is_employee, is_guardian, is_emergency_contact)
- Contact subtypes

**Current Implementation:**  
Only `is_patient` and `is_case_manager` boolean flags are implemented on res.partner.

**Potential Benefits:**
- More granular filtering and searching
- Support for multi-role contacts (e.g., someone who is both employee and patient)
- Better handling of family members, guardians, emergency contacts
- Program-based grouping (245D, CADI, BI, CAC, etc.)

**Impact if Changed:**  
Low impact for MVP - additional classification can be added incrementally without changing existing data structure.

**SME Decision:**
[ ] MVP is sufficient (just is_patient and is_case_manager)  
[ ] Add contact categories for programs: _____________________  
[ ] Add boolean flags for: _____________________  
[ ] Other: _____________________

**SME Notes:**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

### OI-006: Data Entry Workflow - Preferred Method

**Category:** User Experience / Process  
**Priority:** Medium (informs UI design)  
**Blocker:** No

**Question:**  
How will users typically enter service authorization data? This will help us optimize the user interface and determine what validation/helpers to provide.

**Current Implementation:**  
Standard Odoo form with all fields available for manual entry.

**Possible Workflows:**
- **Option A:** Manual transcription from PDF letter (county mails authorization)
- **Option B:** Copy/paste from county email
- **Option C:** Future: Automated import from SFTP/API (out of scope for MVP, but good to know)
- **Option D:** Mix of above

**Impact on Design:**
- Manual entry → Need clear labels, field validation, helpful error messages
- Copy/paste → Need bulk entry helpers, format conversion
- Import preparation → Structure data for easy import mapping

**SME Input Requested:**
What is the typical workflow today? (Check all that apply)

[ ] Receive paper letter, manually enter data  
[ ] Receive PDF via email, manually enter data  
[ ] Receive Excel/CSV from county  
[ ] Receive data via county portal/system  
[ ] Other: _____________________

**How many service authorizations does a typical user enter per day?**  
_____________________________________________________________________________

**What are the most common errors or frustrations with current data entry?**  
_____________________________________________________________________________  
_____________________________________________________________________________  
_____________________________________________________________________________

**Implementation Status:** ☐ Not Started  |  ☐ In Progress  |  ☐ Completed

---

## Resolved Items

(Items will be moved here once SME provides answer and implementation is updated)

---

## Summary Statistics

**Total Open Items:** 6  
**Blockers:** 0  
**High Priority:** 0  
**Medium Priority:** 3  
**Low Priority:** 3

---

## Document Revision History

| Date | Change | By |
|------|--------|-----|
| 2025-10-11 | Initial creation with 6 open items | Executive Architect |
|  |  |  |
|  |  |  |

---

## Contact Information

**For Questions About This Document:**  
Executive Architect - aos-architecture repository

**For SME Coordination:**  
Project Manager / Designated Coordinator

**To Submit Completed Form:**  
[Provide email/upload location]

---

**End of Open Items Document**

