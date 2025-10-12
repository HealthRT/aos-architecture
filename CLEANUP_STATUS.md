# Repository Cleanup Status

**Date:** 2025-10-12  
**Triggered By:** User confusion during agent onboarding + duplicate directories discovered

---

## ✅ **Completed (Just Now)**

### **1. Deleted Confusing Old Versions**
- ❌ Deleted: `prompts/onboarding_coder_agent_v1_DEPRECATED.md`
- ❌ Deleted: `prompts/onboarding_coder_agent_v2.md`
- ✅ **Result:** Only `onboarding_coder_agent.md` remains (v3.0)

### **2. Created Governance Documentation**
- ✅ Created: `standards/00-repository-structure-governance.md`
  - **Purpose:** Central authority for "where does this file go?"
  - **Content:** Decision trees, naming conventions, lifecycle management
  - **Status:** DRAFT (needs approval)

- ✅ Created: `prompts/README.md`
  - **Purpose:** Index of all agent primers
  - **Content:** Master table of which file to use for each role
  - **Includes:** Versioning rules, maintenance checklist

- ✅ Created: `QUICK_REFERENCE_AGENT_ONBOARDING.md`
  - **Purpose:** Visual guide for onboarding (solves immediate confusion)
  - **Content:** Simple copy/paste dispatch format

- ✅ Created: `REORGANIZATION_PLAN.md`
  - **Purpose:** Comprehensive plan for full repository cleanup
  - **Content:** All issues identified, proposed fixes, implementation steps

- ✅ Created: `QUICK_CLEANUP_SUMMARY.md`
  - **Purpose:** Executive summary of reorganization
  - **Content:** Critical issues, proposed fixes, timing options

---

## 🔴 **Still Outstanding (Need User Decision)**

### **A. Duplicate Directories**
```
❌ ./specs/ (ACTIVE) vs. ./aos-architecture/specs/ (EMPTY)
❌ ./work_orders/ (ACTIVE) vs. ./aos-architecture/work_orders/ (EMPTY)
```
**Recommendation:** Delete empty `./aos-architecture/` nested folders

### **B. Misplaced Ephemeral Dispatches**
```
❌ prompts/dispatch_claude_WO-AGMT-001-05.md
❌ prompts/dispatch_claude_WO-AGMT-001-05_CONSOLIDATED.md
❌ prompts/coder_agent_dispatch_WO-AGMT-001-01.md
```
**Recommendation:** Move to `/sessions/2025-10-11/dispatches/`

### **C. Missing Index Files**
```
❌ /README.md (root)
❌ /specs/README.md
❌ /work_orders/README.md
❌ /sessions/README.md
```
**Recommendation:** Create all missing index files

### **D. Outdated Cross-References**
- `/USER_GUIDE.md` still references nested `./aos-architecture/` structure
- Various standards may reference old paths

---

## 📋 **Next Steps (User Decision Required)**

### **Option 1: Complete Cleanup NOW** (~90 minutes)
```bash
1. Delete empty ./aos-architecture/ folder
2. Move ephemeral dispatches to /sessions/
3. Create missing README files
4. Update USER_GUIDE.md
5. Update cross-references in standards
6. Commit everything
```
✅ **Pro:** Clean slate, no more confusion  
❌ **Con:** Delays spec field name fixes

---

### **Option 2: Finish Spec Work First, Then Cleanup** ⭐ RECOMMENDED
```bash
# Now:
1. Fix spec field names (individual, DSP, unit_rate)
2. Update implementation + tests
3. Deploy CI/CD for spec validation
4. Commit spec compliance work

# Then (separate PR):
5. Execute full repository cleanup
6. Commit cleanup work

Total: ~3 hours across two PRs
```
✅ **Pro:** Logical separation, both tasks complete  
❌ **Con:** Live with duplication for ~1 more hour

---

### **Option 3: Phased Cleanup**
```bash
# Phase 1 (Now - 5 min):
- Delete remaining deprecated files

# Phase 2 (Later - 45 min):
- Delete duplicate directories
- Move dispatches

# Phase 3 (Much Later - 30 min):
- Create all index files
```
✅ **Pro:** Incremental progress  
❌ **Con:** Duplicate folders still exist temporarily

---

## 🎯 **What User Needs to Decide**

### **Q1: Timing**
Which option above? (1, 2, or 3)

### **Q2: Spec Field Names** (Still Pending)
From earlier conversation:
- `is_patient` → `is_individual` ✅
- `patient_id` → `individual_id` ✅
- `recipient_id_external` → `individual_id_external` ✅
- Need to add: `is_dsp`, `dsp_external_id` ✅
- `rate_per_unit` → `unit_rate` ✅

**Still need clarity on:**
- Should service agreements link to assigned DSP? (Yes/No)
- Any other field names to change?

---

## 📊 **Impact Summary**

### **Immediate Fixes (Already Done)**
| Action | Files | Impact |
|--------|-------|--------|
| Deleted deprecated primers | 2 | ✅ No more version confusion |
| Created governance docs | 4 | ✅ Clear rules going forward |

### **Pending Cleanup (Awaiting Approval)**
| Action | Files | Impact |
|--------|-------|--------|
| Delete empty folders | 2 | ✅ One clear location for specs/WOs |
| Move dispatches | 3 | ✅ Clean separation of templates vs. ephemeral |
| Create index files | 5 | ✅ Clear navigation |
| Update cross-references | ~10-15 | ✅ All docs point to correct locations |

---

## ✅ **Success Criteria**

**Immediate (Achieved):**
- [x] No confusion about which onboarding file to use
- [x] Governance documentation exists

**Full Cleanup (Pending):**
- [ ] No duplicate directory structures
- [ ] All files in correct locations
- [ ] Every directory has README.md
- [ ] USER_GUIDE.md matches reality
- [ ] All cross-references valid

---

## 📞 **What to Do Next**

### **For User:**
1. **Review** `standards/00-repository-structure-governance.md` (skim it)
2. **Decide** timing: Option 1, 2, or 3?
3. **Answer** spec field name questions (from earlier)
4. **Approve** or modify the plan

### **For Me (Once Approved):**
- **If Option 1:** Execute full cleanup now
- **If Option 2:** Fix spec names first, cleanup second
- **If Option 3:** Execute Phase 1 now, rest later

---

**Current Recommendation:** **Option 2** (spec work first, cleanup second)

**Rationale:**
- Spec compliance is urgent (code consistency)
- Cleanup is important but not blocking
- Both get done, logical separation
- Total time: ~3 hours across two focused sessions

---

**Status:** ⏸️ Awaiting user decision

