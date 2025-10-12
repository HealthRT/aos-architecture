# Reference Documentation Library - Quick Start Guide

**Created:** 2025-10-11  
**Purpose:** Guide to using the AOS reference documentation system

---

## 🎯 What Problem Does This Solve?

As AOS grows, we need to manage:
- Government regulations (HIPAA, MN DHS waivers, FLSA)
- External API specifications (Gusto, county systems)
- Business validation rules (rate tables, authorization logic)
- Real-world samples (service agreements, timesheets)

**Challenge:** These documents serve different purposes, have different lifecycles, and are used by different people.

**Solution:** Structured reference library with clear organization, cross-referencing, and version control.

---

## 📁 Complete Directory Structure

```
aos-architecture/
├── docs/
│   └── reference/                           # SHARED reference library
│       ├── INDEX.md                         # START HERE - Master index
│       ├── README.md                        # How to use this library
│       │
│       ├── regulatory/                      # Government & compliance
│       │   ├── README.md
│       │   ├── hipaa/
│       │   ├── minnesota-dhs/
│       │   └── cms/
│       │
│       ├── api-specs/                       # External API docs
│       │   ├── README.md
│       │   ├── gusto/
│       │   └── county-systems/
│       │
│       └── validation-rules/                # Business logic
│           ├── README.md
│           ├── service-authorization/
│           └── overtime-calculations/
│
└── features/[domain]/[feature]/
    └── reference/                           # FEATURE-SPECIFIC references
        ├── samples/                         # Real-world examples
        │   └── README.md
        └── REFERENCES.md                    # Links to shared docs
```

---

## 🚀 Quick Start: Common Tasks

### Task 1: Find a Government Regulation

1. Start at `docs/reference/INDEX.md`
2. Check "Quick Reference by Topic"
3. Navigate to specific document
4. Or browse `docs/reference/regulatory/[agency]/README.md`

**Example:** Finding HIPAA Security Rule
```
docs/reference/INDEX.md
  → Quick Reference → HIPAA Compliance
    → docs/reference/regulatory/hipaa/hipaa-security-rule.pdf
```

---

### Task 2: Find External API Documentation

1. Go to `docs/reference/api-specs/README.md`
2. Find vendor subdirectory
3. Check vendor README for specific endpoints

**Example:** Gusto API authentication
```
docs/reference/api-specs/gusto/
  → gusto-api-v1.yaml
  → authentication.md
```

---

### Task 3: Find Feature-Specific Samples

1. Navigate to feature directory
2. Check `reference/samples/` subdirectory
3. Read `samples/README.md` for context

**Example:** Service Agreement sample
```
features/evv/service-agreement-management/
  → reference/samples/mn-dhs-service-agreement-redacted.pdf
  → reference/samples/README.md (explains what sample shows)
```

---

### Task 4: See All Docs Related to a Feature

1. Navigate to feature directory
2. Open `REFERENCES.md`
3. Follow links to both local and shared docs

**Example:** All docs for Service Agreement feature
```
features/evv/service-agreement-management/REFERENCES.md
  → Local samples
  → Links to shared regulatory docs
  → Links to shared validation rules
  → Related ADRs
```

---

## 📋 Adding Documents: Decision Tree

```
Is this document...

┌─ SHARED by multiple features?
│  ├─ Government regulation? → docs/reference/regulatory/[agency]/
│  ├─ External API? → docs/reference/api-specs/[vendor]/
│  └─ Validation rule? → docs/reference/validation-rules/[domain]/
│
└─ SPECIFIC to one feature?
   └─ Real-world sample? → features/[domain]/[feature]/reference/samples/
```

---

## 🔗 Cross-Referencing System

### In ADRs (Architecture Decisions)
```markdown
**Regulatory Requirement:** Per DHS Waiver Program Manual Section 4.2...

**Reference:** `@docs/reference/regulatory/minnesota-dhs/waiver-program-manual.pdf`
```

### In Specs (Feature Specifications)
```yaml
validation_source: "@docs/reference/validation-rules/service-authorization/unit-validation-matrix.xlsx"
```

### In Work Orders
```markdown
## 7. Required Context Documents
- @docs/reference/api-specs/gusto/gusto-api-v1.yaml
- @features/evv/service-agreement-management/reference/samples/mn-dhs-service-agreement-redacted.pdf
```

### In Feature REFERENCES.md
```markdown
- [DHS Waiver Manual](../../../docs/reference/regulatory/minnesota-dhs/waiver-program-manual.pdf)
```

---

## ⚠️ Critical Rules

### Rule 1: NO PHI
**NEVER upload documents containing real Protected Health Information.**

Before uploading ANY sample document:
- [ ] Remove patient names, DOB, addresses
- [ ] Remove provider identification (unless public)
- [ ] Replace with generic placeholders
- [ ] Document redactions in README

### Rule 2: Version Control
Regulations and APIs change over time:
- Keep multiple versions: `document-name-v2024.pdf`
- Document effective dates
- Update references when new version added

### Rule 3: Update Cross-References
When adding/updating a document:
- [ ] Update `docs/reference/INDEX.md`
- [ ] Update subdirectory README
- [ ] Update feature REFERENCES.md (if applicable)
- [ ] Update related ADRs (if architectural impact)

---

## 📊 Document Status

Check INDEX.md for current status of all documents:
- **Available** ✅ - Uploaded and ready
- **Pending** ⏳ - Identified but not uploaded
- **Requested** 📧 - Awaiting from external party
- **N/A** - Not applicable

---

## 🎓 Examples in Action

### Example 1: Service Agreement Feature

**Feature:** `features/evv/service-agreement-management/`

**Uses:**
- Local sample: `reference/samples/mn-dhs-service-agreement-redacted.pdf`
- Shared regulation: `docs/reference/regulatory/minnesota-dhs/waiver-program-manual.pdf`
- Shared validation: `docs/reference/validation-rules/service-authorization/unit-validation-matrix.xlsx`

**Cross-referenced in:**
- `AGMT-001.yaml` spec (cites sample)
- Feature `REFERENCES.md` (links to all docs)
- Future ADR for validation engine (will cite validation rules)

---

### Example 2: Hub Payroll Feature (Future)

**Feature:** `features/hub/payroll/` (not created yet)

**Will use:**
- Shared API: `docs/reference/api-specs/gusto/gusto-api-v1.yaml`
- Shared validation: `docs/reference/validation-rules/overtime-calculations/flsa-overtime-rules.md`
- ADR-004 already references Gusto as source of truth

**Will create:**
- Local samples: `features/hub/payroll/reference/samples/timesheet-examples.pdf`
- Feature `REFERENCES.md` linking to shared docs

---

## 🔍 Finding Documents: Cheat Sheet

| I need... | Go to... |
|-----------|----------|
| HIPAA rules | `docs/reference/regulatory/hipaa/` |
| MN DHS waiver rules | `docs/reference/regulatory/minnesota-dhs/` |
| Gusto API | `docs/reference/api-specs/gusto/` |
| Rate tables | `docs/reference/validation-rules/service-authorization/` |
| Overtime formulas | `docs/reference/validation-rules/overtime-calculations/` |
| Service Agreement sample | `features/evv/service-agreement-management/reference/samples/` |
| All docs for a feature | Feature's `REFERENCES.md` file |
| Complete index | `docs/reference/INDEX.md` |

---

## 📞 Questions?

- **What category?** → Check `docs/reference/README.md`
- **Is this PHI?** → Contact Compliance Officer
- **Can't find it?** → Check feature-specific `reference/` folders
- **Need a document?** → Contact Product Owner

---

## 🎯 Success Criteria

You'll know the system is working when:
- ✅ ADRs cite specific documents (not vague "regulatory requirements")
- ✅ Specs reference validation rules with file paths
- ✅ Work orders link to API docs
- ✅ New features easily find relevant reference materials
- ✅ Team knows where to put new documents without asking

---

**This system scales with the project. As AOS grows, the reference library grows in parallel, always organized and accessible.**

---

**Created by:** EVV Executive Architect  
**Date:** 2025-10-11  
**Status:** v1.0 - Ready for use

