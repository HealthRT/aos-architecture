# Reference Documentation Index

**Purpose:** This directory contains all external reference materials that inform AOS features and compliance requirements.

**Last Updated:** 2025-10-11  
**Maintained By:** Executive Architect

---

## 📂 Directory Structure

### `regulatory/` - Government & Compliance Documents
Official regulations, guidelines, and compliance requirements from government agencies.

**When to use:** Cite these when making architectural decisions about compliance, data handling, or business rules mandated by law.

**Current Categories:**
- `hipaa/` - Federal HIPAA regulations and guidance
- `minnesota-dhs/` - Minnesota Department of Human Services waiver programs
- `cms/` - Centers for Medicare & Medicaid Services (placeholder for future)

### `api-specs/` - External API Documentation
Technical specifications for third-party APIs we integrate with.

**When to use:** Reference when designing integrations, creating work orders for API clients, or troubleshooting integration issues.

**Current Categories:**
- `gusto/` - Gusto payroll and HR API documentation
- `county-systems/` - County-specific integration specifications

### `validation-rules/` - Business Logic from External Sources
Rate tables, validation matrices, calculation formulas provided by external authorities.

**When to use:** Implement validation logic, define acceptance criteria, create test cases.

**Current Categories:**
- `service-authorization/` - Service authorization validation rules, rate tables
- `overtime-calculations/` - FLSA and state overtime calculation rules

---

## 📑 Quick Reference by Topic

### HIPAA Compliance & PHI
- [HIPAA Security Rule](regulatory/hipaa/hipaa-security-rule.pdf) - *Pending*
- [PHI Field Definitions](regulatory/hipaa/phi-definitions.md) - *Pending*
- **Status:** Awaiting upload of official documents

### Minnesota DHS Waiver Programs
- [Waiver Program Manual](regulatory/minnesota-dhs/waiver-program-manual.pdf) - *Pending*
- [Service Authorization Guidelines](regulatory/minnesota-dhs/service-authorization-guidelines.pdf) - *Pending*
- [EVV Requirements 2024](regulatory/minnesota-dhs/evv-requirements-2024.pdf) - *Pending*
- **Status:** Awaiting upload of official documents

### Payroll & Time Tracking
- [Gusto API Specification](api-specs/gusto/gusto-api-v1.yaml) - *Pending*
- [FLSA Overtime Rules](validation-rules/overtime-calculations/flsa-overtime-rules.md) - *Pending*
- [Minnesota State Overtime Rules](validation-rules/overtime-calculations/mn-state-overtime-rules.md) - *Pending*
- **Status:** ADR-004 references Gusto as source of truth; documentation pending

### Service Authorization & EVV
- [Unit Validation Matrix](validation-rules/service-authorization/unit-validation-matrix.xlsx) - *Pending*
- [2025 Rate Tables](validation-rules/service-authorization/rate-tables-2025.csv) - *Pending*
- **Status:** See feature-specific samples in `features/evv/service-agreement-management/reference/`

---

## 📋 Document Naming Conventions

### File Names
- Use lowercase with hyphens: `hipaa-security-rule.pdf`
- Include version/year when relevant: `rate-tables-2025.csv`
- Use descriptive names: `service-authorization-guidelines.pdf` not `doc1.pdf`

### Formats
- **Regulatory PDFs:** Keep original government-issued PDFs
- **API Specs:** Use OpenAPI/Swagger YAML when possible
- **Validation Rules:** Use Markdown tables or CSV for structured data
- **Samples:** Redact all PHI, keep original format

### Metadata
Each subdirectory should have a `README.md` documenting:
- Source of documents
- Date obtained
- Relevant sections/pages for AOS features
- Version/effective date
- Related ADRs or features

---

## 🔄 Maintenance Procedures

### Adding a New Document

1. **Determine Category:**
   - Regulatory? → `regulatory/[agency]/`
   - API? → `api-specs/[vendor]/`
   - Validation? → `validation-rules/[domain]/`

2. **Add File:**
   - Place in appropriate subdirectory
   - Follow naming conventions
   - Redact PHI if sample document

3. **Update Documentation:**
   - Add entry to this INDEX.md (Quick Reference section)
   - Update subdirectory README.md
   - Note status: *Available* or *Pending*

4. **Cross-Reference:**
   - Update relevant ADRs if decision based on this document
   - Add to feature REFERENCES.md if feature-specific

5. **Version Control:**
   - Commit with descriptive message: `docs: add DHS waiver program manual v2024`
   - Note effective date in commit message

### Updating an Existing Document

1. **Keep Old Version:**
   - Rename old version: `document-name-v2023.pdf`
   - Add new version: `document-name.pdf` (latest is always unversioned)
   - Or use subdirectory: `document-name/v2024.pdf`

2. **Update References:**
   - Update INDEX.md with new version date
   - Check ADRs for references to old version
   - Notify team of changes via changelog

3. **Rationale:**
   - Regulatory compliance may require referencing historical versions
   - Audit trail for "what did we know when we made that decision?"

---

## 🔍 How to Find Documents

### By Feature
1. Check feature's `REFERENCES.md` file
2. Follow links to `docs/reference/`

### By Regulation/Compliance
1. Check `regulatory/[agency]/README.md`
2. See which features reference that regulation

### By Integration
1. Check `api-specs/[vendor]/README.md`
2. See related ADRs (e.g., ADR-004 for Gusto)

---

## 📊 Document Status Legend

- **Available:** Document uploaded and ready for reference
- **Pending:** Document identified but not yet uploaded
- **Requested:** Document requested from external party
- **N/A:** Document not applicable or not required

---

## ⚠️ Important Notes

### PHI Handling
**NEVER upload documents containing real PHI to this repository.**

- Always redact patient names, addresses, SSNs, medical info
- Use samples like "REDACTED" or "John Doe" for examples
- Document redactions in subdirectory README

### Copyright & Distribution
- Government documents (regulations, forms) are public domain
- Vendor API specs may have license restrictions
- Note copyright/license in subdirectory README

### Access Control
This repository is the "single source of truth" for architecture. All documents here should be:
- Non-proprietary OR properly licensed
- Redacted of PHI
- Relevant to architectural decisions

---

## 📞 Questions?

**Document Classification:** Contact Executive Architect  
**PHI Concerns:** Contact Compliance Officer  
**Missing Documents:** Check with Product Owner or external stakeholders

---

**Last Review:** 2025-10-11  
**Next Review:** When significant documents added or regulatory changes occur

