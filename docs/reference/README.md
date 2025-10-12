# Reference Documentation Library

This directory contains external reference materials that inform AOS architectural decisions, feature specifications, and compliance requirements.

---

## 📚 What Goes Here

This library is for **external** documents that:
- Come from government agencies, regulatory bodies, or third-party vendors
- Inform architectural decisions (cite in ADRs)
- Define business rules we must implement
- Provide compliance requirements we must meet
- Specify external APIs we integrate with

**This is NOT for:**
- Internal specifications (those go in `/specs`)
- Feature briefs (those go in `/features`)
- ADRs (those go in `/decisions`)
- Work orders (those go in `/work_orders`)

---

## 🗂️ Organization

Documents are organized by **type**, not by feature:

```
reference/
├── regulatory/          # Government regulations & compliance
├── api-specs/           # External API documentation
├── validation-rules/    # Business logic from external sources
└── INDEX.md             # Master index (START HERE)
```

---

## 🚀 Quick Start

### Finding a Document

1. **Start with [INDEX.md](INDEX.md)** - Organized by topic
2. Check the "Quick Reference" section for common documents
3. Navigate to specific subdirectory for full listing

### Adding a Document

1. Determine category (regulatory, api-spec, validation-rule)
2. Place in appropriate subdirectory
3. Update INDEX.md
4. Update subdirectory README.md
5. Commit with descriptive message

### Using a Document

1. **In ADRs:** Cite as basis for decisions
   ```markdown
   **Regulatory Requirement:** Per DHS Waiver Program Manual Section 4.2...
   See: `@docs/reference/regulatory/minnesota-dhs/waiver-program-manual.pdf`
   ```

2. **In Specs:** Reference in validation rules
   ```yaml
   validation_source: "@docs/reference/validation-rules/service-authorization/unit-validation-matrix.xlsx"
   ```

3. **In Work Orders:** List in "Required Context Documents"
   ```markdown
   ## 7. Required Context Documents
   - @docs/reference/api-specs/gusto/gusto-api-v1.yaml
   ```

---

## ⚠️ Critical Guidelines

### PHI Protection
**NEVER upload documents with real Protected Health Information.**

Before uploading any sample document:
- [ ] Remove patient names, addresses, dates of birth
- [ ] Remove provider identification (unless public)
- [ ] Remove specific dates (use placeholders like "XX/XX/XXXX")
- [ ] Replace with generic values (e.g., "John Doe", "Sample Agency")
- [ ] Note redactions in subdirectory README

### Copyright & Licensing
- Government documents → Generally public domain (safe to include)
- Vendor API docs → Check license terms
- Third-party materials → May require permission
- Note copyright status in subdirectory README

### Version Control
- Keep historical versions (regulations change over time)
- Name files with version/year when applicable
- Document version in subdirectory README
- Commit messages should note version: `docs: add DHS manual v2024`

---

## 📋 Document Status Tracking

Check [INDEX.md](INDEX.md) for status of all documents:
- **Available** - Uploaded and ready
- **Pending** - Identified but not uploaded yet
- **Requested** - Awaiting from external party
- **N/A** - Not applicable

---

## 🔗 Related Directories

### For Feature-Specific Samples
Place in feature folder:
```
features/[domain]/[feature]/reference/samples/
```

Create `REFERENCES.md` in feature folder to link to shared docs here.

### For Internal Specifications
Those belong in:
```
specs/[domain]/STORY-XXX.yaml
```

### For Architecture Decisions
Document in:
```
decisions/ADR-XXX-title.md
```

---

## 📞 Questions?

- **What category?** → Check INDEX.md organization
- **PHI concerns?** → Contact Compliance Officer
- **Can't find a document?** → Check feature-specific `reference/` folders
- **Need a document?** → Contact Product Owner or external stakeholders

---

**Maintained by:** Executive Architect  
**Last updated:** 2025-10-11

