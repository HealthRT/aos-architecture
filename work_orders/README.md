# Work Orders Directory

**Purpose:** This directory contains hyper-detailed, executable tasks for Coder Agents.

**Last Updated:** 2025-10-12

---

## 📋 What's a Work Order?

A **work order** is a single, focused task that a Coder Agent can execute independently. It includes:
- Exact files to create/modify
- Specific code to write
- Testing requirements
- Acceptance criteria

**Created By:** Scrum Master (from specs)  
**Executed By:** Coder Agent  
**Template:** `/templates/work_order_template.md`

---

## 📂 Directory Structure

```
/work_orders/
├── evv/                                 ← EVV system work orders
│   └── AGMT-001/                       ← Feature-specific folder
│       ├── WO-AGMT-001-01.md           ← Work order #1
│       ├── WO-AGMT-001-02.md           ← Work order #2
│       ├── TRACKING.md                 ← Status tracking
│       └── issues/                     ← GitHub issue mirrors
│           └── WO-AGMT-001-01.md
├── hub/                                 ← Hub system work orders
│   └── TRACTION-001/
│       ├── TRACTION-001.md
│       └── issues/
├── dispatched/                          ← Active work orders sent to agents
│   ├── WO-AGMT-001-01.md              ← Copy sent to agent
│   └── DEVOPS-004.md
└── pending/                             ← Decomposed but not yet dispatched
```

---

## 🔤 Naming Convention

### **Work Order Files**
```
WO-[FEATURE_CODE]-[NUMBER]-[SEQUENCE].md

Examples:
  WO-AGMT-001-01.md    (Service Agreement, WO #1)
  WO-AGMT-001-02.md    (Service Agreement, WO #2)
  WO-SCHED-002-01.md   (Scheduling, WO #1)
```

**Rules:**
- Prefix: Always `WO-`
- Feature code: Matches the spec (AGMT, SCHED, TRAC, etc.)
- Number: Matches spec number (001, 002, etc.)
- Sequence: Two-digit sequence within feature (01, 02, ..., 15)

### **Special Cases**
```
[EPIC]-[NUMBER].md     (For non-spec work)

Examples:
  TRACTION-001.md      (Traction epic, task #1)
  DEVOPS-004.md        (DevOps task #4)
```

---

## 🔄 Work Order Lifecycle

### **1. Decomposition**
```
Scrum Master reads spec
  ↓
Creates work orders in /work_orders/[domain]/[FEATURE]/
  ↓
Each WO is bootable, testable, and independent
```

### **2. Review**
```
Executive Architect reviews for:
  - Completeness (all info provided)
  - Bootability (Odoo won't crash)
  - Testability (can verify it works)
```

### **3. Dispatch**
```
Human copies WO to /work_orders/dispatched/
  ↓
Creates consolidated dispatch brief
  ↓
Sends to Coder Agent
```

### **4. Execution**
```
Coder Agent:
  - Reads WO
  - Verifies environment
  - Implements code
  - Runs tests
  - Provides proof of execution
```

### **5. Completion**
```
Code merged
  ↓
WO status updated in TRACKING.md
  ↓
WO remains in /dispatched/ as historical record
```

---

## 📊 Current Work Orders

### **EVV System**

| Feature | Spec | Work Orders | Status |
|---------|------|-------------|--------|
| Service Agreement | AGMT-001 | WO-AGMT-001-01 through 05 | ✅ Completed & Merged |

**Location:** `/work_orders/evv/AGMT-001/`

### **Hub System**

| Feature | Spec | Work Orders | Status |
|---------|------|-------------|--------|
| Traction EOS | _(in progress)_ | TRACTION-001 through 008 | 🚧 In Progress |

**Location:** `/work_orders/hub/`

### **System Infrastructure**

| Initiative | Spec | Work Orders | Status |
|------------|------|-------------|--------|
| Agent Test Runner Stabilization | SYSTEM-001 | WO-SYSTEM-001-01, WO-SYSTEM-001-02 | ❌ Replaced |
| Resilient Test Environment with Guaranteed Cleanup | SYSTEM-002 | WO-SYSTEM-002-01, WO-SYSTEM-002-02 | 📝 Pending Dispatch |

**SYSTEM-001 Status:** Replaced by SYSTEM-002 after critical failures (Process Improvement #012, #014).

**SYSTEM-002 Locations:**  
- EVV: `/work_orders/pending/WO-SYSTEM-002-01.md`  
- Hub: `/work_orders/pending/WO-SYSTEM-002-02.md`

**Key Improvements:** Single resilient script with `trap` for guaranteed cleanup, healthcheck waiting, unique project names.

---

## 🛠️ How to Create Work Orders

### **For Scrum Master Agents**

**Step 1: Read the Spec**
```
Input: /specs/[domain]/[CODE]-[NUM].yaml
Understand: Data models, business rules, acceptance criteria
```

**Step 2: Decompose into Bootable Units**
Each work order MUST be:
- **Bootable:** Odoo can start with this module
- **Testable:** Can verify it works
- **Independent:** Doesn't block other WOs

**Step 3: Use the Template**
```bash
cp /templates/work_order_template.md /work_orders/[domain]/[FEATURE]/WO-[CODE]-[NUM]-[SEQ].md
```

**Step 4: Fill in All Sections**
- **Environment Setup:** Which repo, which branch
- **Objectives:** What this WO accomplishes
- **Implementation Details:** Exact files and code
- **Testing Requirements:** Unit + workflow tests
- **Acceptance Criteria:** How to know it's done

**Step 5: Create Tracking Doc**
```bash
# In /work_orders/[domain]/[FEATURE]/TRACKING.md
Track status of all WOs for this feature
```

**Guidance:** See `/prompts/onboarding_scrum_master.md` (Section 3.1: Odoo-Aware Decomposition)

---

### **For Humans (Dispatching Work)**

**Step 1: Copy to /dispatched/**
```bash
cp /work_orders/[domain]/[FEATURE]/WO-[...].md /work_orders/dispatched/
```

**Step 2: Create Dispatch Brief**
Use `/templates/dispatch_brief_template.md` to combine:
- Agent primer
- Work order
- Any additional context

**Step 3: Send to Agent**
Provide the dispatch brief to the Coder Agent.

---

## 📖 Work Order Quality Standards

### **Must Have:**
- [x] Clear objective (what's being built)
- [x] Exact file paths and names
- [x] Specific field names and types (match spec)
- [x] Business rules to implement
- [x] Testing requirements (unit + workflow)
- [x] Acceptance criteria (testable)
- [x] Environment setup instructions

### **Red Flags (Bad Work Orders):**
- ❌ "Implement the service agreement" (too vague)
- ❌ "Create necessary fields" (not specific)
- ❌ "Add validation" (which validation?)
- ❌ Missing test requirements
- ❌ Ambiguous acceptance criteria

---

## 🔍 Finding Work Orders

### **By Feature**
```bash
# All AGMT-001 work orders:
ls work_orders/evv/AGMT-001/WO-*.md

# Tracking status:
cat work_orders/evv/AGMT-001/TRACKING.md
```

### **By Status**
```bash
# All dispatched work orders:
ls work_orders/dispatched/

# All pending:
ls work_orders/pending/
```

### **By Domain**
- EVV: `/work_orders/evv/`
- Hub: `/work_orders/hub/`

---

## 📊 Tracking Work Order Status

Each feature folder should have a `TRACKING.md` file:

```markdown
# AGMT-001 Work Order Tracking

| WO | Title | Status | Assigned | Completed |
|----|-------|--------|----------|-----------|
| 01 | Database Models | ✅ Merged | 2025-10-11 | 2025-10-11 |
| 02 | Security Rules | ✅ Merged | 2025-10-11 | 2025-10-11 |
| 03 | Views & Forms | 🚧 In Progress | 2025-10-12 | - |
```

**Statuses:**
- 📝 **Pending:** Not yet dispatched
- 🚧 **In Progress:** Assigned to agent
- ✅ **Completed:** Code merged
- ❌ **Blocked:** Waiting on dependency
- 🔄 **Revision Needed:** Sent back for fixes

---

## ⚠️ Important Rules

### **Bootability First**
Every work order must result in a bootable Odoo module:
- Include `__manifest__.py` requirements
- Include `security/ir.model.access.csv` for new models
- Test with: `odoo -i [module_name] --stop-after-init`

**See:** `/prompts/onboarding_scrum_master.md` (Section 3.1.2: Minimal Module Requirements)

### **Spec Compliance**
Work orders MUST reference the spec and use EXACT:
- Model names
- Field names
- Field types
- Business rule logic

**Validation:** `python scripts/compare-spec-to-implementation.py`

### **Testing Is Mandatory**
Every work order must include:
- Unit tests (individual functions)
- Workflow tests (complete user journeys)

**See:** `/standards/TESTING_STRATEGY.md`

---

## 🆘 Questions?

**"How big should a work order be?"**  
→ Small enough to complete in 2-4 hours. Big enough to be bootable.

**"Can one work order modify multiple files?"**  
→ Yes, as long as they're all related to the same logical unit of work.

**"What if requirements change mid-work?"**  
→ Update the work order, notify the agent, document in TRACKING.md.

**"Can I split a work order after it's created?"**  
→ Yes, create WO-XXX-01a, WO-XXX-01b, etc. Document in TRACKING.md.

---

## 📚 Related Documents

- **Work Order Template:** `/templates/work_order_template.md`
- **Dispatch Brief Template:** `/templates/dispatch_brief_template.md`
- **Scrum Master Primer:** `/prompts/onboarding_scrum_master.md`
- **Coder Agent Primer:** `/prompts/onboarding_coder_agent.md`
- **Spec Directory:** `/specs/README.md`
- **Testing Strategy:** `/standards/TESTING_STRATEGY.md`
- **Repository Governance:** `/standards/00-repository-structure-governance.md`

---

**Maintained By:** Scrum Master + Executive Architect  
**Last Review:** 2025-10-12  
**Next Review:** After first major decomposition cycle

