# AOS Architecture Repository Reorganization Plan
**Date:** 2025-10-12  
**Status:** PROPOSED - Awaiting Approval

---

## 🔍 Issues Identified

### 1. **Duplicate Directory Structures**
- `./specs/` (root, **ACTIVE** with AGMT-001 content)
- `./aos-architecture/specs/` (nested, **EMPTY** - only templates)
  
- `./work_orders/` (root, **ACTIVE** with all work orders)
- `./aos-architecture/work_orders/` (nested, **EMPTY** - only "pending" folder)

**Problem:** Confusion about where to place new files. Root level is being used, but `USER_GUIDE.md` references nested structure. The `aos-architecture/` subfolder appears to be legacy.

---

### 2. **Deprecated/Duplicate Files**

#### In `/prompts/`:
- `onboarding_coder_agent_v1_DEPRECATED.md` ← **DELETE**
- `onboarding_coder_agent_v2.md` ← **CONSOLIDATE** (replaced by `onboarding_coder_agent.md`)
- `coder_agent_dispatch_WO-AGMT-001-01.md` ← **MOVE** (ephemeral dispatch, not a template)
- `dispatch_claude_WO-AGMT-001-05.md` ← **MOVE** (ephemeral dispatch)
- `dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md` ← **MOVE** (ephemeral dispatch)

**Problem:** The `/prompts/` directory is mixing:
1. **Templates** (onboarding primers) ← Should stay
2. **Ephemeral dispatches** (specific work order instructions) ← Should be archived

---

### 3. **Sessions Folder - Unclear Purpose**
- `./sessions/2025-10-11-evv-agmt-001-session-summary.md`
- `./sessions/2025-10-12/DECOMPOSITION_VALIDATION_STRATEGY.md`
- `./sessions/2025-10-12/AGENT_ONBOARDING_CONSOLIDATION_SUMMARY.md`

**Problem:** Is this archival? Ongoing? Should summaries be in `/process_improvement/` instead?

---

### 4. **No Clear Entry Point**
- No `README.md` at root
- `USER_GUIDE.md` exists but describes structure that doesn't match reality
- No clear index for navigating the repository

---

## ✅ Proposed Reorganization

### **Phase 1: Consolidate Duplicate Directories**

#### Action 1.1: Remove Empty Nested Directories
```bash
# These are empty or contain only templates that should be in /templates/
rm -rf ./aos-architecture/specs/
rm -rf ./aos-architecture/work_orders/
rm -rf ./aos-architecture/  # If now empty
```

**Rationale:** All active content is at root level. Nested `aos-architecture/` folder is legacy and causes confusion.

---

#### Action 1.2: Ensure Templates Are In `/templates/`
```bash
# Verify these exist:
./templates/work_order_template.md
./templates/dispatch_brief_template.md
./templates/pre-uat-check-template.md

# If any spec templates exist in aos-architecture/specs/templates/, move them:
# (appears none exist currently)
```

---

### **Phase 2: Clean Up Deprecated Files**

#### Action 2.1: Delete Deprecated Onboarding Files
```bash
rm ./prompts/onboarding_coder_agent_v1_DEPRECATED.md
```

#### Action 2.2: Consolidate Coder Agent Onboarding
**Current state:**
- `onboarding_coder_agent.md` ← **CURRENT** (v3.0, most recent)
- `onboarding_coder_agent_v2.md` ← **SUPERSEDED**

**Decision needed:**
- **Option A:** Delete `v2` entirely (if v3 is comprehensive)
- **Option B:** Rename to `onboarding_coder_agent_v2_ARCHIVE.md` for historical reference

**Recommendation:** Option A - Delete. Git history preserves old versions.

---

#### Action 2.3: Move Ephemeral Dispatch Files
**Current location:** `/prompts/` (wrong - they're not templates)

**Proposed location:** `/sessions/2025-10-11/dispatches/` (archival)

**Files to move:**
```bash
mv ./prompts/coder_agent_dispatch_WO-AGMT-001-01.md → ./sessions/2025-10-11/dispatches/
mv ./prompts/dispatch_claude_WO-AGMT-001-05.md → ./sessions/2025-10-11/dispatches/
mv ./prompts/dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md → ./sessions/2025-10-11/dispatches/
```

**Rationale:** These are work-order-specific, ephemeral documents. They're useful for historical reference but don't belong in the templates folder.

---

### **Phase 3: Clarify Sessions Folder Purpose**

#### Action 3.1: Create `/sessions/README.md`
Document purpose:
- **Purpose:** Archive of development session summaries, key decisions, and ephemeral documents
- **Audience:** Historical reference for process improvement
- **Lifecycle:** Permanent archive, organized by date

#### Action 3.2: Move Current Session Documents
```bash
# Ensure all session docs are dated:
./sessions/2025-10-11/ ← Session summary + dispatches
./sessions/2025-10-12/ ← Strategy docs from today's session
```

---

### **Phase 4: Create Clear Navigation**

#### Action 4.1: Create `/README.md` (Master Index)
**Content:**
- Project vision (1 paragraph)
- Link to `USER_GUIDE.md` for full orientation
- Quick links to:
  - Architecture Decisions (`/decisions/`)
  - Standards (`/standards/`)
  - Current Specs (`/specs/`)
  - Agent Onboarding (`/prompts/`)
  - Reference Library (`/docs/reference/`)

---

#### Action 4.2: Update `USER_GUIDE.md`
**Changes needed:**
- Remove references to `./aos-architecture/` nested structure
- Confirm `/specs/` is at root
- Confirm `/work_orders/` is at root
- Add section on `/sessions/` (archival)
- Add section on `/bugs/` (active bug tracking)
- Add section on `/testing/` (pre-UAT checks)

---

#### Action 4.3: Create Missing Index Files

**Create `/prompts/README.md`:**
- List all current onboarding primers
- Document versioning approach
- Explain difference between primers and dispatch briefs

**Create `/specs/README.md`:**
- Explain YAML spec format
- Link to template
- Document naming convention

**Create `/work_orders/README.md`:**
- Explain structure: `/evv/`, `/hub/`, `/dispatched/`, `/pending/`
- Document work order lifecycle
- Link to template

---

### **Phase 5: Validate Documentation Consistency**

#### Action 5.1: Cross-Reference All Index Files
Ensure these documents all agree:
- `/README.md`
- `/USER_GUIDE.md`
- `/docs/reference/INDEX.md`
- `/prompts/README.md`
- `/specs/README.md`
- `/work_orders/README.md`

#### Action 5.2: Update Standards to Reference Correct Paths
Check these files for outdated paths:
- `/standards/03-ai-agent-workflow.md`
- `/standards/SPEC_COMPLIANCE.md`
- `/prompts/onboarding_scrum_master.md`
- `/prompts/onboarding_coder_agent.md`

---

## 📊 Before/After Directory Structure

### **BEFORE (Current):**
```
/aos-architecture
├── README.md                          ← MISSING
├── USER_GUIDE.md                      ← Describes wrong structure
├── aos-architecture/                  ← DUPLICATE (legacy?)
│   ├── specs/                         ← EMPTY
│   └── work_orders/                   ← EMPTY (only pending/)
├── specs/                             ← ACTIVE (has AGMT-001)
├── work_orders/                       ← ACTIVE (has all WOs)
├── prompts/
│   ├── onboarding_*.md                ← Templates (GOOD)
│   ├── dispatch_*.md                  ← Ephemeral (WRONG LOCATION)
│   └── *_v1_DEPRECATED.md             ← Old versions (DELETE)
├── sessions/                          ← Unclear purpose
└── [other directories...]
```

### **AFTER (Proposed):**
```
/aos-architecture
├── README.md                          ← NEW: Quick navigation
├── USER_GUIDE.md                      ← UPDATED: Matches reality
├── specs/                             ← ACTIVE (consolidated)
│   ├── README.md                      ← NEW
│   └── evv/AGMT-001.yaml
├── work_orders/                       ← ACTIVE (consolidated)
│   ├── README.md                      ← NEW
│   ├── evv/
│   ├── hub/
│   ├── dispatched/
│   └── pending/
├── prompts/                           ← CLEAN (templates only)
│   ├── README.md                      ← NEW
│   ├── onboarding_*.md                ← Current versions only
│   └── core/00_NON_NEGOTIABLES.md
├── sessions/                          ← DOCUMENTED (archival)
│   ├── README.md                      ← NEW
│   ├── 2025-10-11/
│   │   ├── session-summary.md
│   │   └── dispatches/                ← Moved from /prompts/
│   └── 2025-10-12/
│       └── strategy-docs/
└── [other directories...]
```

---

## 🚀 Implementation Steps

### Step 1: Backup Current State
```bash
cd /home/james/development/aos-development/aos-architecture
git checkout -b cleanup/repository-reorganization
git add .
git commit -m "chore: checkpoint before reorganization"
```

### Step 2: Delete Empty/Legacy Directories
```bash
rm -rf ./aos-architecture/
```

### Step 3: Delete Deprecated Files
```bash
rm ./prompts/onboarding_coder_agent_v1_DEPRECATED.md
rm ./prompts/onboarding_coder_agent_v2.md
```

### Step 4: Move Ephemeral Dispatches
```bash
mkdir -p ./sessions/2025-10-11/dispatches
mv ./prompts/coder_agent_dispatch_WO-AGMT-001-01.md ./sessions/2025-10-11/dispatches/
mv ./prompts/dispatch_claude_WO-AGMT-001-05.md ./sessions/2025-10-11/dispatches/
mv ./prompts/dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md ./sessions/2025-10-11/dispatches/
```

### Step 5: Create New Documentation
- [ ] Create `/README.md`
- [ ] Update `/USER_GUIDE.md`
- [ ] Create `/prompts/README.md`
- [ ] Create `/specs/README.md`
- [ ] Create `/work_orders/README.md`
- [ ] Create `/sessions/README.md`

### Step 6: Update Cross-References
- [ ] Update all standards that reference old paths
- [ ] Update all onboarding primers that reference old paths
- [ ] Update all templates that reference old paths

### Step 7: Validate
```bash
# Check for broken links
grep -r "aos-architecture/specs" .
grep -r "aos-architecture/work_orders" .

# Verify all index files exist
ls -la README.md USER_GUIDE.md prompts/README.md specs/README.md work_orders/README.md sessions/README.md
```

### Step 8: Commit Changes
```bash
git add .
git commit -m "chore: reorganize repository structure

- Remove duplicate aos-architecture/ nested folders
- Delete deprecated onboarding files
- Move ephemeral dispatch files to sessions archive
- Create comprehensive navigation with README files
- Update USER_GUIDE to match actual structure
- Document sessions folder purpose"
```

---

## ❓ Questions for User

Before implementing, please confirm:

### **Q1: Delete or Archive?**
For `onboarding_coder_agent_v2.md`:
- **Option A:** Delete entirely (git history preserves it)
- **Option B:** Rename to `*_ARCHIVE.md`

**Recommendation:** Option A

### **Q2: Sessions Folder Purpose?**
What should the `/sessions/` folder contain?
- **Option A:** Keep for archival reference (development session summaries)
- **Option B:** Move content to `/process_improvement/` and delete folder

**Recommendation:** Option A (but document purpose clearly)

### **Q3: aos-architecture/ Nested Folder**
This appears to be legacy. Confirm deletion?
- [x] Yes, delete `./aos-architecture/` (all active content is at root)
- [ ] No, keep it for [reason]

### **Q4: Timing**
This reorganization will touch many files. Best time?
- **Option A:** Do it now (we're between features)
- **Option B:** Wait until after current spec validation work is complete
- **Option C:** Break into smaller phases

**Recommendation:** Option B (finish spec compliance work first, then clean up)

---

## 📋 Success Criteria

After reorganization:
1. ✅ No duplicate directory structures
2. ✅ No deprecated files in active directories
3. ✅ Clear README.md at root with navigation
4. ✅ USER_GUIDE.md matches actual structure
5. ✅ All index files exist and cross-reference correctly
6. ✅ All standards/prompts reference correct paths
7. ✅ Ephemeral files are in archival locations
8. ✅ Purpose of each directory is documented

---

## 🔄 Next Steps

**Immediate:**
1. User reviews this plan
2. User answers questions
3. User approves timing

**Then:**
1. Execute reorganization steps
2. Update all cross-references
3. Validate with grep searches
4. Commit changes
5. Update any active agents with new paths

---

**Prepared By:** AI Architecture Agent  
**Reviewed By:** [Pending]  
**Approved By:** [Pending]

