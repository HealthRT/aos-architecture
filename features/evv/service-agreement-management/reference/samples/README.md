# Service Agreement Samples

This directory contains redacted samples of real-world Service Agreement documents that informed the AGMT-001 specification.

---

## 📄 Documents

### `mn-dhs-service-agreement-redacted.pdf` (or .png)

**Source:** Minnesota Department of Human Services  
**Document Type:** Waiver Service Agreement Authorization Letter  
**Date Received:** 2025-10-11  
**Effective Period:** Sample shows authorization for 09/01/23 - 08/31/24  

**Redactions Applied:**
- ✅ Patient name replaced with "[REDACTED]"
- ✅ Case manager name replaced with generic "LAUREN OTANEZ" (or similar)
- ✅ Specific dates genericized
- ✅ External IDs modified/redacted where sensitive

**Used For:**
- AGMT-001 specification field design
- Understanding real-world data structure
- Identifying required vs. optional fields
- Designing UI mockup

---

## 🔑 Key Insights from This Sample

### Document Structure Discovered
1. **Header Information:**
   - Provider ID (e.g., 1316610249)
   - Agreement Number (e.g., 32229002314)
   - Recipient/Patient ID (e.g., 02002516)

2. **Multiple Service Lines:**
   - Each agreement can contain multiple service authorizations
   - Each line has: Line number, Status, Procedure code, Modifiers (up to 4), Quantity, Rate, Date range
   
3. **Service Line Fields:**
   - Line Number (e.g., 04, 05)
   - Status (APPROVED, DENIED, PENDING)
   - Procedure Code (e.g., H2014)
   - Modifiers (e.g., UC, U3, U4)
   - Total Units (e.g., 3,509)
   - Rate Per Unit (e.g., $11.66)
   - Start Date / End Date
   - Total Amount (computed: rate × units)

4. **Supporting Information:**
   - Diagnosis code (ICD-10, e.g., F70)
   - Case manager name, phone, ID
   - Instructions for provider

---

## 💡 Design Decisions Informed by This Sample

### Field Additions
Based on this sample, we added to AGMT-001 spec:
- `agreement_number` - External traceability
- `line_number` - Multiple lines per agreement
- `line_status` - County approval status (separate from internal state)
- `procedure_code` + 4 modifiers - Service identification
- `rate_per_unit` + computed `total_amount` - Financial tracking
- `diagnosis_code` - Compliance requirement
- `case_manager_id` - Many2one relationship (not text)

### Architectural Insights
- **One service.agreement record = One line** (not one agreement header)
- Multiple records can share same `agreement_number`
- Modifiers differentiate service types (e.g., in-person vs. remote training)
- External IDs critical for preventing duplicates

---

## 📝 Adding More Samples

When adding new samples:

1. **Redact ALL PHI:**
   - Patient names, addresses, DOB
   - Provider names (unless public/generic)
   - Specific service dates
   - Phone numbers, emails
   - Any other identifiable information

2. **Name files descriptively:**
   - `service-agreement-denial-example.pdf`
   - `service-agreement-multiple-lines.pdf`
   - `service-agreement-modification.pdf`

3. **Document in this README:**
   - What's unique about this sample
   - What design insights it provides
   - Which spec/feature it informed

4. **Reference in specs:**
   ```yaml
   # In AGMT-001.yaml
   reference_documents:
     - "@features/evv/service-agreement-management/reference/samples/mn-dhs-service-agreement-redacted.pdf"
   ```

---

## ⚠️ PHI Warning

**Before uploading ANY document to this directory:**

- [ ] Remove all patient names
- [ ] Remove all specific dates of birth
- [ ] Remove all addresses
- [ ] Replace with generic/placeholder values
- [ ] Verify no medical information present
- [ ] Confirm no other identifiable data

**If unsure whether something is PHI, ask Compliance Officer.**

---

**Last updated:** 2025-10-11

