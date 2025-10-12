# Sessions Archive

**Purpose:** Historical archive of development session summaries, decisions, and ephemeral documents.

**Last Updated:** 2025-10-12

---

## 📋 What's Archived Here?

This directory contains **ephemeral documents** that are valuable for historical reference but don't belong in active directories:

1. **Session Summaries:** High-level recap of what was accomplished in a development session
2. **Dispatch Briefs:** Work-order-specific instructions sent to agents (not reusable templates)
3. **Strategy Documents:** Decision logs, approach documents, planning notes from specific sessions
4. **Ad-hoc Analysis:** One-time investigations or troubleshooting documents

---

## 📂 Directory Structure

```
/sessions/
├── README.md                                  ← You are here
├── 2025-10-11/
│   ├── evv-agmt-001-session-summary.md       ← What we built
│   └── dispatches/                            ← Ephemeral work order briefs
│       ├── dispatch_claude_WO-AGMT-001-05.md
│       ├── dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md
│       └── coder_agent_dispatch_WO-AGMT-001-01.md
└── 2025-10-12/
    ├── DECOMPOSITION_VALIDATION_STRATEGY.md   ← Planning doc
    ├── AGENT_ONBOARDING_CONSOLIDATION_SUMMARY.md
    └── dispatches/                            ← (If any created today)
```

**Naming Convention:** `YYYY-MM-DD/` directories, organized by session date

---

## 🔄 What Gets Archived Here?

### **✅ DO Archive:**

| Document Type | Example | Why Archive? |
|---------------|---------|--------------|
| **Session Summaries** | `evv-agmt-001-session-summary.md` | Historical record of progress |
| **Ephemeral Dispatches** | `dispatch_claude_WO-AGMT-001-05.md` | Work-order-specific, not reusable |
| **Strategy Documents** | `DECOMPOSITION_VALIDATION_STRATEGY.md` | Session-specific planning |
| **Decision Logs** | `field-naming-decisions-2025-10-12.md` | Captures in-session decisions |
| **Ad-hoc Analysis** | `bug-triage-notes-2025-10-11.md` | One-time investigation |

### **❌ DO NOT Archive:**

| Document Type | Correct Location | Why Not Here? |
|---------------|------------------|---------------|
| **ADRs** | `/decisions/` | Permanent architectural decisions |
| **Standards** | `/standards/` | Living operational guidelines |
| **Templates** | `/templates/` or `/prompts/` | Reusable, not session-specific |
| **Process Improvement** | `/process_improvement/` | Systemic lessons learned |
| **Bug Tickets** | `/bugs/` | Active tracking |
| **Specs** | `/specs/` | Feature specifications |
| **Work Orders** | `/work_orders/` | Executable tasks |

---

## 📝 Session Summary Format

Each session should have a high-level summary document:

```markdown
# Session Summary: [Feature/Topic] - YYYY-MM-DD

**Date:** 2025-10-11  
**Participants:** Human (James), AI Architect  
**Focus:** Service Agreement Feature (AGMT-001)

## What We Accomplished
- Completed work orders 01-05
- Fixed XML syntax error (BUG-001)
- Implemented workflow tests
- Merged to main

## Key Decisions
- Decided to implement workflow testing standard
- Created spec compliance validation

## Issues Encountered
- Database selector issue (unresolved)
- Boot test run on wrong environment

## Next Steps
- Complete Pre-UAT testing
- Implement spec field name corrections

## Related Documents
- Work Orders: /work_orders/evv/AGMT-001/
- Spec: /specs/evv/AGMT-001.yaml
- Bug Ticket: /bugs/BUG-001-xml-syntax-error.md
```

---

## 🗂️ Subdirectory Structure

### **`/dispatches/`**
Contains **ephemeral dispatch briefs** - work-order-specific instructions that combine:
- Role primer excerpt
- Specific work order
- Context-specific notes

**Why here?**
- They're not reusable templates
- They're tied to a specific work order instance
- Historical value for "what instructions did we give?"

**Example:**
```
/sessions/2025-10-11/dispatches/
  └── dispatch_claude_WO-AGMT-001-05.md
```

### **`/strategy-docs/` (Optional)**
If a session generates multiple planning or strategy documents:
```
/sessions/2025-10-12/strategy-docs/
  ├── DECOMPOSITION_VALIDATION_STRATEGY.md
  └── AGENT_ONBOARDING_CONSOLIDATION_SUMMARY.md
```

---

## 🔍 Finding Archived Documents

### **By Date**
```bash
# All documents from October 11:
ls sessions/2025-10-11/
```

### **By Type**
```bash
# All dispatch briefs:
find sessions/ -path "*/dispatches/*"

# All summaries:
find sessions/ -name "*summary.md"
```

### **By Content (Full-Text Search)**
```bash
# Find sessions related to AGMT-001:
grep -r "AGMT-001" sessions/
```

---

## 📊 When to Create a New Session Directory

**Create a new dated directory when:**
- Starting a new development day
- Beginning a new major feature
- After a significant milestone (e.g., feature merge)

**Reuse an existing directory when:**
- Continuing work on the same feature
- Same calendar day
- Logically connected to earlier session

---

## 🔄 Archive Lifecycle

### **During the Session**
- Create ephemeral documents as needed
- Don't worry about organizing yet

### **End of Session**
1. Create session summary
2. Move ephemeral documents to `/sessions/YYYY-MM-DD/`
3. Update this README if new document types added

### **Long-Term**
- Keep all archives (disk space is cheap)
- Useful for:
  - "What instructions did we give Agent X for WO Y?"
  - "When did we decide to do Z?"
  - "What was the context for this bug?"

---

## ⚠️ Privacy & Security

**PHI WARNING:**  
Session documents may reference feature work, but they must NEVER contain:
- Real patient names
- Real addresses
- Real medical information
- Any actual PHI

**Use placeholders:**
- "John Doe" for patient names
- "123 Main St" for addresses
- "REDACTED" for sensitive data

---

## 🆘 Questions?

**"Should I archive this document?"**  
→ Ask: Is it reusable? If no, archive. If yes, put in appropriate active directory.

**"Can I delete old sessions?"**  
→ No. Disk space is cheap, historical context is valuable.

**"Where should I put my dispatch brief?"**  
→ If it's a template (reusable), put in `/prompts/` or `/templates/`.  
→ If it's work-order-specific, create inline and archive here after completion.

**"What if I need to reference an archived document?"**  
→ Link to it! Example: `See /sessions/2025-10-11/evv-agmt-001-session-summary.md`

---

## 📚 Related Documents

- **Repository Governance:** `/standards/00-repository-structure-governance.md`
- **Process Improvement:** `/process_improvement/process-improvement.md`
- **Work Orders:** `/work_orders/README.md`
- **Dispatch Template:** `/templates/dispatch_brief_template.md`

---

**Maintained By:** Executive Architect  
**Last Review:** 2025-10-12  
**Next Review:** When new session document types emerge

