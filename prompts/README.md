# AI Agent Onboarding Primers

**Purpose:** This directory contains the official, version-controlled onboarding documents for all AI agents working on the AOS project.

**Last Updated:** 2025-10-12

---

## 🎯 Quick Start: Which File Do I Use?

### **For Onboarding a New Agent**

| Agent Role | Use This File | Version |
|------------|---------------|---------|
| **Coder Agent** | `onboarding_coder_agent.md` | v3.0 (2025-10-12) |
| **Scrum Master** | `onboarding_scrum_master.md` | Latest |
| **Business Analyst** | `onboarding_business_analyst.md` | Latest |
| **UI/UX Agent** | `onboarding_ui_ux_agent.md` | Latest |
| **Architect** | `onboarding_architect_hub.md` | Latest |
| **GitHub Coach** | `onboarding_github_coach.md` | Latest |
| **Document Retrieval** | `onboarding_document_retrieval_agent.md` | Latest |

### **Core Principles (All Agents Must Read)**
- `core/00_NON_NEGOTIABLES.md` ← Ring 0 principles (immutable)

---

## 📋 File Naming Convention

**Rule:** ONE file per role, NO version numbers in filename.

- ✅ `onboarding_coder_agent.md` ← Current version
- ❌ `onboarding_coder_agent_v2.md` ← DO NOT CREATE
- ❌ `onboarding_coder_agent_v1_DEPRECATED.md` ← DELETE (use git history)

**Rationale:**
- **Clarity:** Always obvious which file is current
- **Versioning:** Use git tags and commit history instead of filename suffixes
- **Simplicity:** Agents (and humans) don't have to guess

---

## 🔄 Document Lifecycle

### **Creating a New Primer**
1. Use snake_case: `onboarding_[role_name].md`
2. Include version number in file header (e.g., `Version: 1.0`)
3. Commit with message: `docs: add [Role] primer v1.0`

### **Updating an Existing Primer**
1. **Edit the existing file** (don't create a new one)
2. Update version number in header: `Version: X.Y`
3. Add changelog at bottom of file (optional)
4. Commit with message: `docs: update [Role] primer to vX.Y - [brief description]`

### **Major Overhaul (Breaking Changes)**
1. If you need to keep old version temporarily:
   - Rename old: `onboarding_[role]_ARCHIVE_YYYYMMDD.md`
   - Create new: `onboarding_[role].md`
2. After 90 days, delete archived version (git preserves history)

---

## 📂 What This Directory Contains

### **Onboarding Primers (Templates)**
These are **role-specific templates** that define an agent's:
- Mission and responsibilities
- Architecture principles to follow
- Standards and processes
- Testing requirements
- Checklist for starting work

**Examples:**
- `onboarding_coder_agent.md`
- `onboarding_scrum_master.md`
- `onboarding_business_analyst.md`

---

### **What This Directory Does NOT Contain**

❌ **Work-Order-Specific Dispatches**  
These are ephemeral documents like:
- `dispatch_claude_WO-AGMT-001-05.md`
- `coder_agent_dispatch_WO-AGMT-001-01.md`

**Where they go:** Archive in `/sessions/YYYY-MM-DD/dispatches/` after use

❌ **Old Versions**  
Don't keep `v1`, `v2`, `v3` files around. Use git history.

❌ **Experimental Drafts**  
Use branches or personal workspaces, not this directory.

---

## 🛠️ How to Use These Primers

### **For Humans (Onboarding an Agent)**

**Standard Dispatch Format:**
```markdown
You are a [ROLE] for the AOS project.

Read these onboarding documents:
1. @aos-architecture/prompts/core/00_NON_NEGOTIABLES.md
2. @aos-architecture/prompts/onboarding_[role].md

Your work order:
[Paste work order content or link]
```

**Advanced (Consolidated Dispatch):**
Use `/templates/dispatch_brief_template.md` to combine:
- Role primer
- Specific work order
- Context-specific notes

---

### **For Agents (Reading This)**

**Step 1:** Read `/prompts/core/00_NON_NEGOTIABLES.md`  
**Step 2:** Read your role-specific primer from the table above  
**Step 3:** Read your work order (provided by human)  
**Step 4:** Verify environment setup (see primer's pre-work checklist)  
**Step 5:** Execute work order  
**Step 6:** Provide feedback in `/process_improvement/`

---

## 📊 Current Inventory

### **Active Primers**

| File | Role | Last Updated | Status |
|------|------|--------------|--------|
| `core/00_NON_NEGOTIABLES.md` | All Agents | 2025-10-11 | ✅ Active |
| `onboarding_coder_agent.md` | Coder | 2025-10-12 | ✅ Active (v3.0) |
| `onboarding_scrum_master.md` | Scrum Master | 2025-10-11 | ✅ Active |
| `onboarding_business_analyst.md` | BA | 2025-10-10 | ✅ Active |
| `onboarding_ui_ux_agent.md` | UI/UX | 2025-10-09 | ✅ Active |
| `onboarding_architect_hub.md` | Architect | 2025-10-11 | ✅ Active |
| `onboarding_github_coach.md` | GitHub Coach | 2025-10-10 | ✅ Active |
| `onboarding_document_retrieval_agent.md` | Doc Retrieval | 2025-10-11 | ✅ Active |

### **Deprecated Files (To Be Deleted)**

| File | Reason | Action |
|------|--------|--------|
| `onboarding_coder_agent_v1_DEPRECATED.md` | Superseded by v3.0 | Delete (git history preserves) |
| `onboarding_coder_agent_v2.md` | Superseded by v3.0 | Delete (git history preserves) |

### **Ephemeral Dispatches (To Be Archived)**

| File | Destination |
|------|-------------|
| `dispatch_claude_WO-AGMT-001-05.md` | `/sessions/2025-10-11/dispatches/` |
| `dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md` | `/sessions/2025-10-11/dispatches/` |
| `coder_agent_dispatch_WO-AGMT-001-01.md` | `/sessions/2025-10-11/dispatches/` |

---

## 🔍 Finding the Right Primer

### **By Role**
See the table at the top of this README.

### **By Feature**
All primers reference the same architecture:
- ADRs: `/decisions/`
- Standards: `/standards/`
- Core principles: `/prompts/core/00_NON_NEGOTIABLES.md`

### **By Work Order**
Your work order will tell you which role you need (e.g., "This is a Coder Agent work order").

---

## ✅ Maintenance Checklist

**When creating a new primer:**
- [ ] Use naming convention: `onboarding_[role].md`
- [ ] Include version in header: `Version: 1.0`
- [ ] Add to the table in this README
- [ ] Update `/standards/06-role-and-permission-matrix.md` if new role

**When updating a primer:**
- [ ] Edit existing file (don't create new version)
- [ ] Increment version number in header
- [ ] Update "Last Updated" in this README
- [ ] Commit with descriptive message

**Quarterly Review:**
- [ ] Verify all primers still reflect current architecture
- [ ] Check for outdated references to deprecated standards
- [ ] Update examples if new features added
- [ ] Delete archived files older than 90 days

---

## 📞 Questions?

**"Which file do I use for onboarding a Coder Agent?"**  
→ `onboarding_coder_agent.md` (no version suffix)

**"Should I create `onboarding_coder_agent_v4.md`?"**  
→ No! Edit the existing file and increment the version number in the header.

**"Where did the old versions go?"**  
→ Git history. Run: `git log --all -- prompts/onboarding_coder_agent.md`

**"What if I need both primers for a hybrid role?"**  
→ Reference both in the dispatch brief. Example: "You are a Coder+Tester hybrid. Read both `onboarding_coder_agent.md` and `onboarding_tester_agent.md`."

**"Where do dispatch briefs go?"**  
→ They're ephemeral. Create inline or use `/templates/dispatch_brief_template.md`, then archive in `/sessions/YYYY-MM-DD/dispatches/` after completion.

---

## 📚 Related Documents

- **Repository Structure:** `/standards/00-repository-structure-governance.md`
- **AI Agent Workflow:** `/standards/03-ai-agent-workflow.md`
- **Role Matrix:** `/standards/06-role-and-permission-matrix.md`
- **Dispatch Template:** `/templates/dispatch_brief_template.md`

---

**Maintained By:** Executive Architect  
**Last Review:** 2025-10-12  
**Next Review:** When new role added or major process change

