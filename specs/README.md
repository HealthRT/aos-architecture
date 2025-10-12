# Feature Specifications Directory

**Purpose:** This directory contains detailed, machine-readable specifications for all AOS features.

**Last Updated:** 2025-10-12

---

## 📋 What's a Spec?

A **spec** is a detailed technical blueprint that serves as the contract between:
- **Business requirements** (what we're building)
- **Implementation** (how developers build it)
- **Testing** (how we validate it works)

**Format:** YAML (structured, machine-readable)  
**Authority:** Business Analyst creates from Feature Brief, Architect reviews

---

## 📂 Directory Structure

```
/specs/
├── evv/                          ← EVV system specifications
│   ├── AGMT-001.yaml            ← Service Agreement spec
│   ├── AGMT-001/                ← Supporting documents
│   │   └── AGMT-001-pre-uat-check-2025-10-12.md
│   └── AGMT-001-open-items.md   ← Decisions pending
├── hub/                          ← Hub system specifications
│   └── traction/
└── templates/                    ← Spec templates
    └── STORY.yaml.tpl
```

---

## 🔤 Naming Convention

### **Primary Spec File**
```
[FEATURE_CODE]-[NUMBER].yaml

Examples:
  AGMT-001.yaml    (Service Agreement - Feature 001)
  SCHED-002.yaml   (Scheduling - Feature 002)
  TRAC-001.yaml    (Traction - Feature 001)
```

**Rules:**
- Feature code: 3-5 uppercase letters
- Number: Zero-padded 3 digits (001, 002, etc.)
- Extension: `.yaml` (always lowercase)

### **Supporting Documents**
```
[FEATURE_CODE]-[NUMBER]-description.md

Examples:
  AGMT-001-open-items.md
  AGMT-001-decision-log.md
  SCHED-002-constraints.md
```

### **Subdirectories (Optional)**
If a spec has many supporting files:
```
[FEATURE_CODE]-[NUMBER]/
  └── various-supporting-docs.md
```

---

## 📝 Spec Structure

Every spec YAML file follows this template: `/specs/templates/STORY.yaml.tpl`

### **Key Sections:**
1. **metadata:** Feature ID, title, epic, status
2. **context:** Business problem and solution overview
3. **data_models:** Database tables and fields
4. **business_rules:** Validation logic and constraints
5. **user_stories:** As-a/I-want/So-that format
6. **acceptance_criteria:** Testable conditions for "done"
7. **dependencies:** Prerequisites and integrations
8. **technical_notes:** Implementation guidance

---

## 🔄 Spec Lifecycle

### **1. Feature Brief → Spec**
- Business Analyst reads `/features/[domain]/[feature-name]/01-feature-brief.md`
- Creates detailed YAML spec using template
- Architect reviews for technical feasibility

### **2. Spec Approval**
- Spec is committed to this directory
- Becomes the **immutable contract** for implementation
- Any changes require formal amendment process

### **3. Work Order Decomposition**
- Scrum Master reads spec
- Breaks into executable work orders
- Work orders placed in `/work_orders/[domain]/[feature-code]/`

### **4. Implementation**
- Coder Agents implement per spec
- **Spec compliance validation** runs in CI/CD
- Tests verify acceptance criteria

### **5. Completion**
- Spec marked as "Implemented" in metadata
- Remains as permanent reference

---

## ✅ Spec Compliance

**Rule:** Code MUST match the spec exactly, especially:
- Model names
- Field names and types
- Business rule logic
- Acceptance criteria

**Automation:** CI/CD runs `scripts/compare-spec-to-implementation.py` on every PR.

**See:** `/standards/SPEC_COMPLIANCE.md` for full details.

---

## 📊 Current Specs

### **EVV System**

| Spec | Title | Status | Work Orders |
|------|-------|--------|-------------|
| `AGMT-001.yaml` | Service Agreement Management | ✅ Implemented | WO-AGMT-001-01 through 05 |

### **Hub System**

| Spec | Title | Status | Work Orders |
|------|-------|--------|-------------|
| _(Coming soon)_ | Traction EOS Integration | 🚧 In Progress | TRACTION-001 through 008 |

---

## 🛠️ How to Create a New Spec

### **Step 1: Read the Feature Brief**
Location: `/features/[domain]/[feature-name]/01-feature-brief.md`

### **Step 2: Copy the Template**
```bash
cp /specs/templates/STORY.yaml.tpl /specs/[domain]/[CODE]-[NUM].yaml
```

### **Step 3: Fill in All Sections**
- Don't skip sections (use "N/A" if truly not applicable)
- Be specific with field names and types
- Include all business rules
- Write testable acceptance criteria

### **Step 4: Review**
- Executive Architect reviews technical approach
- Product Owner confirms business requirements
- Adjust as needed

### **Step 5: Commit**
```bash
git add specs/[domain]/[CODE]-[NUM].yaml
git commit -m "feat: add [Feature Name] spec ([CODE]-[NUM])"
```

---

## 📖 Relationship to Other Docs

### **Upstream (Inputs)**
- **Feature Briefs** (`/features/`) → High-level business requirements
- **Reference Docs** (`/docs/reference/`) → Government regs, API specs

### **Downstream (Outputs)**
- **Work Orders** (`/work_orders/`) → Executable tasks for developers
- **Tests** (`/testing/`) → Pre-UAT test plans based on acceptance criteria

### **Governance**
- **ADRs** (`/decisions/`) → Architectural constraints
- **Standards** (`/standards/`) → Implementation guidelines

---

## 🔍 Finding a Spec

### **By Feature Name**
- Check the tables above
- Or search: `grep -r "title:" specs/`

### **By Domain**
- EVV features: `/specs/evv/`
- Hub features: `/specs/hub/`

### **By Work Order**
Work orders reference their spec:
```yaml
# In work order header:
Spec: @aos-architecture/specs/evv/AGMT-001.yaml
```

---

## ⚠️ Important Rules

### **Immutability**
Once a spec is approved and implementation begins:
- **Minor clarifications:** Update the spec with amendment note
- **Major changes:** Create a new version or amendment document
- **Never:** Silently change field names or business rules

### **Single Source of Truth**
The spec is THE authority for:
- What fields exist
- What they're called
- What types they are
- What rules apply

**Not authoritative for:**
- How to implement (see `/standards/`)
- Why we're building it (see `/features/`)

### **Version Control**
- Specs are versioned via git
- Tag major releases: `v1.0-AGMT-001`
- Keep old specs for historical reference

---

## 🆘 Questions?

**"My spec seems too detailed, is that okay?"**  
→ Yes! Detailed is good. Ambiguity causes bugs.

**"Can I reference external documents?"**  
→ Yes, link to `/docs/reference/` for regulations or API specs.

**"What if requirements change mid-implementation?"**  
→ Create an amendment document: `[CODE]-[NUM]-amendment-[DATE].md`

**"How do I validate my code matches the spec?"**  
→ Run: `python scripts/compare-spec-to-implementation.py [CODE]-[NUM]`

---

## 📚 Related Documents

- **Spec Template:** `/specs/templates/STORY.yaml.tpl`
- **Spec Compliance Standard:** `/standards/SPEC_COMPLIANCE.md`
- **Feature Briefs Directory:** `/features/README.md` _(TODO)_
- **Work Orders Directory:** `/work_orders/README.md`
- **Repository Governance:** `/standards/00-repository-structure-governance.md`

---

**Maintained By:** Business Analyst + Executive Architect  
**Last Review:** 2025-10-12  
**Next Review:** When new spec template changes are needed

