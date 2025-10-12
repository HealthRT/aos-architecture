 # Regulatory & Compliance Documents

This directory contains official government regulations, compliance guidelines, and legal requirements that govern AOS operations.

---

## 📁 Subdirectories

### `hipaa/` - HIPAA Regulations
Federal Health Insurance Portability and Accountability Act requirements.

**Relevance:** Governs all EVV (clinical) system operations, PHI handling, security requirements.

**Key Documents:**
- HIPAA Security Rule - *Pending*
- HIPAA Privacy Rule - *Pending*
- PHI field definitions - *Pending*

**Referenced by:**
- ADR-002 (Environment Configuration - no credentials in code)
- ADR-006 (Multi-Tenancy - data isolation)
- All EVV features

---

### `minnesota-dhs/` - Minnesota Department of Human Services
State-level waiver program regulations, service authorization requirements, EVV mandates.

**Relevance:** Defines service agreement structure, authorization rules, EVV requirements for Minnesota waiver programs (245D, CADI, BI, CAC).

**Key Documents:**
- Waiver Program Manual - *Pending*
- Service Authorization Guidelines - *Pending*
- EVV Requirements 2024 - *Pending*

**Referenced by:**
- AGMT-001 (Service Agreement spec)
- Future EVV validation engine features

---

### `cms/` - Centers for Medicare & Medicaid Services
Federal CMS regulations and guidance (placeholder for future).

**Relevance:** May apply to billing, claims, federal compliance.

**Status:** Placeholder - populate as needed

---

## 📋 Adding Regulatory Documents

### Before Upload
1. **Verify it's public domain** (government docs usually are)
2. **Check effective date** (regulations change; keep versions)
3. **Identify relevant sections** (note in this README which parts apply to AOS)

### After Upload
1. Update this README with:
   - Document name and path
   - Effective date / version
   - Which AOS features/ADRs reference it
   - Relevant sections/pages
2. Update parent INDEX.md
3. Cite in relevant ADRs

---

## ⚠️ Important Notes

### Version Control
Regulations change over time. When a new version is released:
1. Rename old version: `document-name-v2023.pdf`
2. Add new version: `document-name-v2024.pdf` or use unversioned `document-name.pdf` for latest
3. Keep both versions (audit trail)
4. Update references in ADRs

### Effective Dates
Always note the effective date of regulations:
- Compliance requirements may vary by date
- System behavior may need to match regulation version at time of service
- Audits require showing "what rules applied when"

---

## 🔗 Cross-References

**Features affected by regulatory documents:**
- All EVV features → HIPAA + MN DHS waiver regulations
- Hub Payroll → FLSA (see `validation-rules/overtime-calculations/`)
- Hub Compliance → Various state/federal requirements

**ADRs citing regulatory requirements:**
- ADR-002 → HIPAA Security Rule (credential management)
- ADR-006 → HIPAA Security Rule (data isolation)
- Future ADRs for EVV validation engine → MN DHS authorization rules

---

**Last updated:** 2025-10-11

