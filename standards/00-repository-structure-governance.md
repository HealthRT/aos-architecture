# Standard 00: Repository Structure Governance

**Status:** DRAFT  
**Version:** 1.0  
**Last Updated:** 2025-10-12  
**Ring:** Protected Layer (Ring 1)  
**Authority:** Executive Architect + Human Overseer Approval Required

---

## Purpose

This document is the **canonical reference** for the structure and organization of the `aos-architecture` repository. It defines what each directory contains, naming conventions, file lifecycle rules, and decision trees for "where does this document go?"

**This is the master index that controls all other indexes.**

---

## 1. Repository Philosophy

### **1.1 Single Source of Truth**
The `aos-architecture` repository is the **external brain** and **constitution** for the entire AOS project. It contains:
- **The Rules** (decisions, standards, non-negotiables)
- **The Blueprints** (specs, feature briefs, work orders)
- **The Guidance** (onboarding primers, templates)
- **The History** (process improvement logs, bug tracking)

### **1.2 Governance Principles**
- **Clarity Over Cleverness:** Simple, obvious structure beats clever organization
- **One Place, One Purpose:** Each document type has exactly one home
- **Archival by Default:** Don't delete, archive (except for truly ephemeral files)
- **Index Everything:** Every directory must have a `README.md` explaining its purpose

---

## 2. Directory Structure & Purpose

### **2.1 Core Architecture (Ring 0 & 1)**

#### `/prompts/core/`
**Purpose:** The immutable core principles (Ring 0)  
**Contains:** `00_NON_NEGOTIABLES.md`  
**Authority:** Human overseer only  
**Lifecycle:** Permanent, changes require unanimous approval

#### `/decisions/`
**Purpose:** Architecture Decision Records (ADRs) - Ring 1  
**Contains:** Formal, numbered ADRs (e.g., `001-hub-evv-authentication.md`)  
**Naming Convention:** `NNN-kebab-case-title.md`  
**Authority:** Executive Architect proposes, human overseer approves  
**Lifecycle:** Permanent, superseded ADRs marked as deprecated but never deleted

#### `/standards/`
**Purpose:** Operational standards and guidelines - Ring 1/2  
**Contains:**
- Coding standards (Odoo, UI/UX)
- Process standards (AI agent workflow, testing)
- Technical guides (local development, pre-commit hooks)

**Naming Convention:** `NN-kebab-case-title.md` (numbered by category)  
**Authority:** Executive Architect proposes, human overseer approves  
**Lifecycle:** Living documents, versioned via git

---

### **2.2 Work Management (Ring 2 - Adaptive)**

#### `/features/`
**Purpose:** High-level, strategic feature briefs (pre-spec)  
**Structure:**
```
/features/
├── evv/
│   ├── service-agreement-management/
│   │   ├── 01-feature-brief.md
│   │   └── reference/ (samples, examples)
│   └── scheduling/
└── hub/
    └── traction/
```

**Contains:** Business-level feature descriptions (the "what" and "why")  
**Naming Convention:** `01-feature-brief.md` (always #01)  
**Authority:** Business Analyst creates, Architect reviews  
**Lifecycle:** Permanent reference for spec creation

---

#### `/specs/`
**Purpose:** Detailed, machine-readable feature specifications  
**Structure:**
```
/specs/
├── evv/
│   ├── AGMT-001.yaml ← Primary spec
│   ├── AGMT-001/ ← Supporting docs (subdirectory)
│   │   └── AGMT-001-pre-uat-check-2025-10-12.md
│   └── AGMT-001-open-items.md ← Spec supplements
└── hub/
    └── traction/
```

**Contains:** 
- YAML specs (canonical contract for implementation)
- Supporting documentation
- Open items / decision logs

**Naming Convention:** 
- Specs: `XXXX-NNN.yaml` (e.g., `AGMT-001.yaml`)
- Supporting: `XXXX-NNN-description.md`

**Authority:** Business Analyst creates from feature brief  
**Lifecycle:** Permanent, versioned specs for historical reference

**Index File:** `/specs/README.md` (explains YAML format, template location)

---

#### `/work_orders/`
**Purpose:** Granular, executable tasks for Coder Agents  
**Structure:**
```
/work_orders/
├── evv/
│   └── AGMT-001/
│       ├── WO-AGMT-001-01.md
│       ├── WO-AGMT-001-02.md
│       └── TRACKING.md
├── hub/
│   └── TRACTION-001/
├── dispatched/ ← Active work orders sent to agents
└── pending/ ← Decomposed but not yet dispatched
```

**Contains:** Hyper-detailed work orders derived from specs  
**Naming Convention:** `WO-XXXX-NNN-NN.md`  
**Authority:** Scrum Master decomposes from specs  
**Lifecycle:** 
- **Active:** In `/evv/` or `/hub/` during decomposition
- **Dispatched:** Moved to `/dispatched/` when sent to agent
- **Complete:** Remains in `/dispatched/` as historical reference

**Index File:** `/work_orders/README.md` (explains lifecycle, structure)

---

### **2.3 Agent Guidance (Ring 1)**

#### `/prompts/`
**Purpose:** Official, version-controlled onboarding primers for AI agents  
**Contains:** Only role-specific onboarding templates

**File Types:**
- `onboarding_[role].md` ← Current version for each role
- `core/00_NON_NEGOTIABLES.md` ← Ring 0 principles

**Naming Convention:** `onboarding_[role_name].md` (snake_case)  
**Examples:**
- `onboarding_coder_agent.md`
- `onboarding_scrum_master.md`
- `onboarding_business_analyst.md`

**Authority:** Executive Architect creates, human overseer approves  
**Lifecycle:** Versioned via git (no `v1`, `v2` in filename - use git tags)

**DOES NOT CONTAIN:**
- ❌ Ephemeral dispatch briefs (specific work orders)
- ❌ Old versions (use git history)
- ❌ Experimental drafts

**Index File:** `/prompts/README.md` (lists all primers, explains dispatch brief process)

---

#### `/templates/`
**Purpose:** Reusable document templates  
**Contains:**
- `work_order_template.md` ← For Scrum Master
- `dispatch_brief_template.md` ← For consolidating primer + WO
- `pre-uat-check-template.md` ← For testing phase

**Naming Convention:** `[artifact_type]_template.md`  
**Authority:** Executive Architect maintains  
**Lifecycle:** Permanent, updated as process evolves

---

### **2.4 Reference Materials**

#### `/docs/reference/`
**Purpose:** External reference materials (government docs, API specs, validation rules)  
**Structure:**
```
/docs/reference/
├── INDEX.md ← Master index (governed by REFERENCE_LIBRARY_GUIDE.md)
├── regulatory/
│   ├── hipaa/
│   └── minnesota-dhs/
├── api-specs/
│   ├── gusto/
│   └── county-systems/
└── validation-rules/
    ├── service-authorization/
    └── overtime-calculations/
```

**Governance:** See `/docs/REFERENCE_LIBRARY_GUIDE.md`  
**Authority:** Executive Architect curates  
**Lifecycle:** Permanent, versioned by effective date

---

### **2.5 Process Improvement (Ring 2 - Adaptive)**

#### `/process_improvement/`
**Purpose:** Append-only log of feedback and lessons learned  
**Contains:**
- `process-improvement.md` ← Master log (append-only)
- `entry_NNN_description.md` ← Detailed analysis of specific issues
- `decomposition_log.md` ← Scrum Master feedback
- `bug-analysis-*.md` ← Root cause analyses

**Naming Convention:** `entry_NNN_brief_description.md`  
**Authority:** Any agent can append, Architect reviews and proposes changes  
**Lifecycle:** Permanent, never delete entries (they're the audit trail)

---

#### `/bugs/`
**Purpose:** Active bug tracking (pre-GitHub issue)  
**Contains:**
- `BUG-NNN-brief-description.md` ← Bug ticket
- `BUG-NNN-REPAIR-INSTRUCTIONS.md` ← Repair dispatch for agent

**Naming Convention:** `BUG-NNN-description.md`  
**Authority:** Any agent can create, Architect triages  
**Lifecycle:** 
- **Active:** In `/bugs/` until resolved
- **Resolved:** Remains in `/bugs/` with status updated
- **Cross-reference:** Link to process improvement entry for lessons learned

---

#### `/testing/`
**Purpose:** Pre-UAT test plans and results  
**Structure:**
```
/testing/
└── pre-uat-checks/
    └── AGMT-001-service-agreement-pre-uat.md
```

**Contains:** Manual test plans, smoke test results, Pre-UAT checklists  
**Naming Convention:** `XXXX-NNN-feature-name-pre-uat.md`  
**Authority:** Tester Agent creates from spec acceptance criteria  
**Lifecycle:** Permanent, documents test results for each feature

---

### **2.6 Archives**

#### `/sessions/`
**Purpose:** Historical archive of development sessions  
**Structure:**
```
/sessions/
├── README.md ← Explains archival purpose
├── 2025-10-11/
│   ├── session-summary.md
│   └── dispatches/ ← Ephemeral dispatch briefs
└── 2025-10-12/
    └── strategy-docs/
```

**Contains:**
- Session summaries
- Ephemeral dispatch briefs (work-order-specific instructions)
- Strategy documents from specific development sessions

**Naming Convention:** `YYYY-MM-DD/` directories  
**Authority:** Executive Architect archives at end of session  
**Lifecycle:** Permanent archive for historical reference

**Index File:** `/sessions/README.md` (explains what's archived and why)

---

#### `/user_stories/` (DEPRECATED)
**Purpose:** Legacy prose-based user stories  
**Status:** Deprecated, replaced by `/specs/` (YAML format)  
**Lifecycle:** Keep for historical reference, no new content

---

### **2.7 Operations**

#### `/operations/`
**Purpose:** Live operational tracking (implementation status, agent evaluation)  
**Contains:**
- `implementation-status.md` ← Current feature/WO status
- `agent-evaluation-matrix.md` ← Agent performance tracking

**Authority:** Executive Architect maintains  
**Lifecycle:** Living documents, frequently updated

---

### **2.8 Root-Level Documents**

#### `/README.md` (MISSING - TO BE CREATED)
**Purpose:** Quick navigation and entry point for new users  
**Contains:**
- 1-paragraph project vision
- Links to key documents (`USER_GUIDE.md`, `00_NON_NEGOTIABLES.md`)
- Quick reference links to main directories

**Authority:** Executive Architect  
**Lifecycle:** Updated when major structure changes

---

#### `/USER_GUIDE.md` (EXISTS)
**Purpose:** Comprehensive orientation guide  
**Contains:**
- Project vision and philosophy
- Detailed explanation of each directory
- Workflow overview (Agentic Planning → Context-Engineered Development)

**Authority:** Executive Architect  
**Lifecycle:** Updated when structure or process changes

**MUST MATCH:** This governance standard (Standard 00)

---

## 3. Naming Conventions

### **3.1 Files**

| Document Type | Convention | Example |
|---------------|------------|---------|
| ADRs | `NNN-kebab-case.md` | `013-repository-boundaries.md` |
| Standards | `NN-kebab-case.md` | `03-ai-agent-workflow.md` |
| Feature Briefs | `01-feature-brief.md` | (always #01) |
| Specs | `XXXX-NNN.yaml` | `AGMT-001.yaml` |
| Work Orders | `WO-XXXX-NNN-NN.md` | `WO-AGMT-001-05.md` |
| Onboarding Primers | `onboarding_role.md` | `onboarding_coder_agent.md` |
| Templates | `type_template.md` | `work_order_template.md` |
| Process Improvement | `entry_NNN_description.md` | `entry_010_boot_test.md` |
| Bug Tickets | `BUG-NNN-description.md` | `BUG-001-xml-syntax-error.md` |
| Session Archives | `YYYY-MM-DD/` | `2025-10-12/` |

### **3.2 Directories**

- **Lowercase with hyphens:** `service-agreement-management/`
- **Organized by domain:** `/evv/`, `/hub/`
- **Dated archives:** `/sessions/2025-10-12/`

---

## 4. Decision Trees

### **4.1 "Where Does This File Go?"**

#### **Is it a rule or principle?**
- **Immutable principle** → `/prompts/core/00_NON_NEGOTIABLES.md`
- **Architectural decision** → `/decisions/NNN-title.md`
- **Operational standard** → `/standards/NN-title.md`

#### **Is it a feature or work item?**
- **High-level business requirement** → `/features/[domain]/[feature-name]/01-feature-brief.md`
- **Detailed technical spec** → `/specs/[domain]/XXXX-NNN.yaml`
- **Executable work order** → `/work_orders/[domain]/XXXX-NNN/WO-XXXX-NNN-NN.md`

#### **Is it guidance for agents?**
- **Role onboarding** → `/prompts/onboarding_[role].md`
- **Document template** → `/templates/[type]_template.md`
- **Specific work order dispatch** → Create ephemeral, archive in `/sessions/YYYY-MM-DD/dispatches/`

#### **Is it reference material?**
- **Government regulation** → `/docs/reference/regulatory/[agency]/`
- **API documentation** → `/docs/reference/api-specs/[vendor]/`
- **Validation rules** → `/docs/reference/validation-rules/[domain]/`
- **Feature-specific sample** → `/features/[domain]/[feature-name]/reference/samples/`

#### **Is it feedback or tracking?**
- **Process improvement feedback** → `/process_improvement/entry_NNN_description.md`
- **Active bug** → `/bugs/BUG-NNN-description.md`
- **Pre-UAT test plan** → `/testing/pre-uat-checks/XXXX-NNN-pre-uat.md`
- **Implementation status** → `/operations/implementation-status.md`

#### **Is it archival?**
- **Session summary** → `/sessions/YYYY-MM-DD/session-summary.md`
- **Ephemeral dispatch** → `/sessions/YYYY-MM-DD/dispatches/`
- **Strategy document** → `/sessions/YYYY-MM-DD/strategy-docs/`

---

### **4.2 "When Do I Update This Document?"**

| Trigger | Documents to Update |
|---------|---------------------|
| **New ADR created** | `/decisions/[new ADR]`, `/prompts/core/00_NON_NEGOTIABLES.md` (if Ring 0), update any affected standards |
| **New standard created** | `/standards/[new standard]`, update `/USER_GUIDE.md` and this governance doc |
| **Directory structure changes** | **THIS DOCUMENT**, `/USER_GUIDE.md`, `/README.md`, relevant index files |
| **New role added** | `/prompts/onboarding_[new role].md`, `/standards/06-role-and-permission-matrix.md` |
| **New feature approved** | `/features/[domain]/[feature]/`, `/specs/[domain]/XXXX-NNN.yaml`, `/work_orders/[domain]/XXXX-NNN/` |
| **Bug discovered** | `/bugs/BUG-NNN.md`, later `/process_improvement/entry_NNN.md` |
| **Process failure** | `/process_improvement/entry_NNN.md`, then update relevant standards/primers |
| **Reference doc added** | `/docs/reference/INDEX.md`, subdirectory `README.md` |

---

## 5. Lifecycle Management

### **5.1 Document Lifecycle States**

| State | Meaning | Action |
|-------|---------|--------|
| **DRAFT** | In development, not yet approved | No enforcement, for review only |
| **ACTIVE** | Approved and in effect | Agents must follow |
| **DEPRECATED** | Superseded by newer version | Mark status, link to replacement, keep file |
| **ARCHIVED** | Historical reference only | Move to archive location, update indexes |

### **5.2 When to Archive vs. Delete**

#### **Archive (Move to `/sessions/`):**
- Ephemeral dispatch briefs (work-order-specific)
- Session summaries and strategy documents
- Old versions of templates (if significant historical value)

#### **Delete (Actually Remove):**
- Truly experimental drafts that never went live
- Duplicate files created by mistake
- Files explicitly marked `*_DEPRECATED.md` after 90 days (if git history sufficient)

#### **Never Delete:**
- ADRs (mark deprecated instead)
- Process improvement entries (they're the audit trail)
- Bug tickets (resolved status, not deleted)
- Specs (they're contracts)

---

## 6. Index File Requirements

Every major directory **MUST** have a `README.md` that explains:

### **6.1 Minimum Requirements**
1. **Purpose:** What this directory contains (1 sentence)
2. **Structure:** Subdirectories and their purpose
3. **Naming Convention:** How files should be named
4. **Authority:** Who can create/modify files here
5. **Lifecycle:** When files are created, updated, archived

### **6.2 Current Index Files**

| Directory | Index File | Status |
|-----------|------------|--------|
| `/` | `/README.md` | ❌ MISSING |
| `/` | `/USER_GUIDE.md` | ✅ EXISTS (needs update) |
| `/prompts/` | `/prompts/README.md` | ❌ MISSING |
| `/specs/` | `/specs/README.md` | ❌ MISSING |
| `/work_orders/` | `/work_orders/README.md` | ❌ MISSING |
| `/sessions/` | `/sessions/README.md` | ❌ MISSING |
| `/docs/reference/` | `/docs/reference/INDEX.md` | ✅ EXISTS |
| `/features/` | Per-feature `README.md` | ⚠️ PARTIAL |
| `/scripts/` | `/scripts/README.md` | ✅ EXISTS |

---

## 7. Enforcement

### **7.1 Automated Checks**
- **Pre-commit hooks:** Validate file naming conventions (TODO)
- **CI/CD:** Check for missing index files (TODO)
- **Spec compliance:** Automated field name validation (IMPLEMENTED)

### **7.2 Human Review**
- **Executive Architect:** Reviews all structure changes
- **Human Overseer:** Approves changes to this governance standard
- **Agent Onboarding:** New agents must read this standard + `USER_GUIDE.md`

### **7.3 Violations**
If a file is in the wrong location or misnamed:
1. **Immediate:** Create GitHub issue
2. **Triage:** Executive Architect determines if move is needed
3. **Fix:** Move file, update cross-references, commit with explanation

---

## 8. Relationship to Other Governance Docs

### **8.1 Hierarchy**

```
Ring 0 (Immutable)
└── /prompts/core/00_NON_NEGOTIABLES.md ← Ultimate authority

Ring 1 (Protected)
├── THIS DOCUMENT (Standard 00) ← Repository structure governance
├── /decisions/* (ADRs) ← Architectural decisions
└── /standards/* ← Operational standards

Ring 2 (Adaptive)
├── /specs/* ← Feature specifications
├── /work_orders/* ← Executable tasks
└── /process_improvement/* ← Feedback loop
```

### **8.2 Cross-References**

This document is referenced by:
- `/USER_GUIDE.md` ← Must align with this standard
- `/prompts/onboarding_[role].md` ← All primers must reference this
- `/docs/REFERENCE_LIBRARY_GUIDE.md` ← Specialized governance for `/docs/reference/`
- `/REORGANIZATION_PLAN.md` ← Implementation plan for this standard

This document references:
- ADR-009 (Immutable Core Framework) ← Ring definitions
- ADR-013 (Repository Boundaries) ← Module placement rules
- Standard 03 (AI Agent Workflow) ← Work order lifecycle

---

## 9. Change Process

### **9.1 Proposing Changes**
1. **Identify Issue:** Document current problem (confusion, duplication, etc.)
2. **Propose Solution:** Draft changes to this standard
3. **Impact Analysis:** List all files that would need to move/update
4. **Submit for Review:** Executive Architect reviews, human overseer approves

### **9.2 Implementing Changes**
1. **Update This Standard First**
2. **Update `/USER_GUIDE.md`**
3. **Execute file moves/renames**
4. **Update all cross-references**
5. **Update all index files**
6. **Validate with grep searches**
7. **Commit with detailed explanation**

---

## 10. Questions & Answers

### **Q: Can I create a new top-level directory?**
**A:** Only with Executive Architect approval. Propose in `/process_improvement/` first.

### **Q: Where do I put a document that doesn't fit any category?**
**A:** Post in `/process_improvement/` to propose a new category, or use `/sessions/[date]/` for truly ephemeral content.

### **Q: Should I version my file name (e.g., `document_v2.md`)?**
**A:** No. Use git tags and commit history for versioning. Exception: When archiving deprecated files, you may append `_ARCHIVE_YYYYMMDD.md`.

### **Q: What if `USER_GUIDE.md` conflicts with this standard?**
**A:** This standard (Standard 00) is the authority. Update `USER_GUIDE.md` to match.

### **Q: Who maintains this document?**
**A:** Executive Architect proposes changes, human overseer approves. This is a Ring 1 (Protected Layer) document.

---

## Appendix A: Quick Reference Card

**Print this and put it on your wall** (or feed it to your agent):

```
┌─────────────────────────────────────────────────────────────────┐
│                   WHERE DOES MY FILE GO?                        │
├─────────────────────────────────────────────────────────────────┤
│ Rule/Principle        → /decisions/ or /standards/              │
│ Feature Requirement   → /features/ then /specs/                 │
│ Work Order            → /work_orders/[domain]/[feature]/        │
│ Agent Primer          → /prompts/onboarding_[role].md           │
│ Template              → /templates/[type]_template.md           │
│ Reference Doc         → /docs/reference/[category]/             │
│ Feedback              → /process_improvement/entry_NNN.md       │
│ Bug Ticket            → /bugs/BUG-NNN.md                        │
│ Test Plan             → /testing/pre-uat-checks/                │
│ Session Notes         → /sessions/YYYY-MM-DD/                   │
│ Ephemeral Dispatch    → Create, then archive in /sessions/      │
└─────────────────────────────────────────────────────────────────┘

NAMING CONVENTIONS:
  ADR:        013-kebab-case.md
  Standard:   03-kebab-case.md
  Spec:       AGMT-001.yaml
  Work Order: WO-AGMT-001-05.md
  Primer:     onboarding_role_name.md
  Template:   work_order_template.md

MUST HAVE README.md:
  ✅ /prompts/  ✅ /specs/  ✅ /work_orders/  ✅ /sessions/
```

---

**Version History:**
- **v1.0 (2025-10-12):** Initial creation as part of repository cleanup initiative

**Next Review:** After reorganization implementation

