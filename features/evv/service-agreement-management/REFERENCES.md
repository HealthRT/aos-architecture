# Reference Documents for Service Agreement Management

This document links to all external reference materials that informed the design of service agreement features.

---

## 📂 Local Samples (Feature-Specific)

### Real-World Service Agreement Examples
- [MN DHS Service Agreement Sample](reference/samples/mn-dhs-service-agreement-redacted.pdf) - **Primary design reference**
  - Showed multi-line structure
  - Defined field requirements
  - Informed UI mockup

**See:** `reference/samples/README.md` for detailed analysis

---

## 📚 Shared Reference Documents

### Regulatory Requirements

#### Minnesota DHS Waiver Programs
- [DHS Waiver Program Manual](../../../docs/reference/regulatory/minnesota-dhs/waiver-program-manual.pdf) - *Pending*
  - **Relevant Sections:** 4.2 (Service Authorization), 7.1 (Documentation Requirements)
  - **Used for:** Understanding authorization approval process, required fields

- [Service Authorization Guidelines](../../../docs/reference/regulatory/minnesota-dhs/service-authorization-guidelines.pdf) - *Pending*
  - **Relevant Sections:** All
  - **Used for:** Validation rules, approval workflow

- [EVV Requirements 2024](../../../docs/reference/regulatory/minnesota-dhs/evv-requirements-2024.pdf) - *Pending*
  - **Relevant Sections:** Service agreement integration requirements
  - **Used for:** Understanding how agreements feed into EVV system

#### HIPAA Compliance
- [HIPAA Security Rule](../../../docs/reference/regulatory/hipaa/hipaa-security-rule.pdf) - *Pending*
  - **Relevant Sections:** PHI protection requirements
  - **Used for:** Identifying which service agreement fields are PHI
  - **Impact:** Access control design, audit logging requirements

### Validation Rules

#### Service Authorization Logic
- [Unit Validation Matrix](../../../docs/reference/validation-rules/service-authorization/unit-validation-matrix.xlsx) - *Pending*
  - **Used for:** Validating procedure code + modifier combinations
  - **Impact:** Future Service Validation Engine feature

- [2025 Rate Tables](../../../docs/reference/validation-rules/service-authorization/rate-tables-2025.csv) - *Pending*
  - **Used for:** Validating authorized rates
  - **Impact:** Financial validation in service agreements

---

## 🔗 Related Architecture Decisions

### ADRs Influenced by Reference Documents

#### Directly Referenced
- **ADR-003:** API-First Design
  - Service agreement data will be exposed via API for validation engine
  
- **ADR-006:** Multi-Tenancy Strategy
  - Service agreements are tenant-specific (per agency)
  - Future: Multiple counties may have different authorization rules

#### Indirectly Related
- **ADR-002:** Environment Configuration
  - External system IDs (agreement numbers, recipient IDs) handled securely
  
- **ADR-007:** Modular Independence
  - Service agreement module can function independently
  - Validation engine will be separate module

---

## 📋 Open Questions for SMEs

Reference document gaps that need SME input:

**OI-002:** Are procedure code modifiers always required?
- Sample shows all lines have modifiers
- Need confirmation: Can authorization exist without modifiers?
- **Reference needed:** Official guidance on procedure code requirements

**OI-003:** Is diagnosis code required for all authorizations?
- Sample shows ICD-10 code present
- Need confirmation: Required always, or only for specific service types?
- **Reference needed:** DHS documentation requirements

**OI-004:** Is rate per unit always provided upfront?
- Sample shows rates on all lines
- Need confirmation: Can authorization be created without rate?
- **Reference needed:** County authorization process documentation

**See:** `../../specs/evv/AGMT-001-open-items.md` for complete list

---

## 🔄 Document Status

| Document | Status | Impact on Feature |
|----------|--------|-------------------|
| MN DHS Service Agreement Sample | ✅ Available | High - Primary design reference |
| DHS Waiver Program Manual | ⏳ Pending | Medium - Validates business rules |
| Service Authorization Guidelines | ⏳ Pending | High - Defines validation logic |
| Unit Validation Matrix | ⏳ Pending | High - Future validation engine |
| Rate Tables 2025 | ⏳ Pending | Medium - Financial validation |
| HIPAA Security Rule | ⏳ Pending | Low - Already following general HIPAA practices |

---

## 📞 Document Requests

**Pending requests to external parties:**
- Minnesota DHS: Waiver Program Manual (current version)
- Minnesota DHS: Service Authorization Guidelines
- County Partners: Sample validation matrices
- County Partners: Current rate tables

**Contact:** Product Owner or Compliance Officer for document acquisition

---

## 🔄 Maintenance

**When reference documents are added/updated:**
1. Update relevant section above with link and status
2. Review specs/work orders for needed updates
3. Update related ADRs if architectural impact
4. Notify team via changelog or standup

**Review frequency:** 
- Before each major feature release
- When regulations change
- When new external documents obtained

---

**Last updated:** 2025-10-11  
**Maintained by:** EVV Executive Architect

