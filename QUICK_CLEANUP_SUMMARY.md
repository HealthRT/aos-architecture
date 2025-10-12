# Quick Cleanup Summary - What You Found

## 🔴 **Critical Issues**

### 1. **Duplicate Folders That Confuse Agents**
```
❌ ./specs/                  ← ACTIVE (has AGMT-001.yaml)
❌ ./aos-architecture/specs/ ← EMPTY (legacy?)

❌ ./work_orders/                  ← ACTIVE (has all WOs)
❌ ./aos-architecture/work_orders/ ← EMPTY (only pending/)
```
**Impact:** Agents don't know where to put new files.

---

### 2. **Deprecated Files Still Present**
```
❌ onboarding_coder_agent_v1_DEPRECATED.md  ← Should be deleted
❌ onboarding_coder_agent_v2.md             ← Superseded by main file
```
**Impact:** Agents might use old onboarding instructions.

---

### 3. **Wrong Files in Wrong Places**
```
❌ /prompts/dispatch_claude_WO-AGMT-001-05.md
❌ /prompts/coder_agent_dispatch_WO-AGMT-001-01.md
```
**These are ephemeral work order dispatches, not templates.**

**Should be:** Archived in `/sessions/2025-10-11/dispatches/`

---

## ✅ **Proposed Fixes**

### **Fix 1: Delete Empty Legacy Folders**
```bash
rm -rf ./aos-architecture/specs/
rm -rf ./aos-architecture/work_orders/
```
**Result:** One clear location for specs and work orders (root level).

---

### **Fix 2: Delete Deprecated Files**
```bash
rm ./prompts/onboarding_coder_agent_v1_DEPRECATED.md
rm ./prompts/onboarding_coder_agent_v2.md
```
**Result:** Only current onboarding files in `/prompts/`.

---

### **Fix 3: Move Dispatches to Archive**
```bash
mkdir -p ./sessions/2025-10-11/dispatches
mv ./prompts/dispatch_*.md ./sessions/2025-10-11/dispatches/
```
**Result:** `/prompts/` contains only templates, not ephemeral docs.

---

### **Fix 4: Add Navigation**
Create these missing files:
- `/README.md` ← Quick navigation for new users
- `/prompts/README.md` ← Index of all primers
- `/specs/README.md` ← Spec format guide
- `/work_orders/README.md` ← WO lifecycle guide
- `/sessions/README.md` ← Archive purpose

Update:
- `/USER_GUIDE.md` ← Remove references to nested `aos-architecture/`

---

## 📊 **Impact Analysis**

### **Files to Delete:** 4
- `aos-architecture/specs/` (empty folder)
- `aos-architecture/work_orders/` (empty folder)
- `onboarding_coder_agent_v1_DEPRECATED.md`
- `onboarding_coder_agent_v2.md`

### **Files to Move:** 3
- Dispatch files from `/prompts/` to `/sessions/2025-10-11/dispatches/`

### **Files to Create:** 6
- 5 new README.md files
- Update 1 existing USER_GUIDE.md

### **Files to Update (cross-references):** ~10-15
- Standards that reference old paths
- Onboarding primers that reference old paths

---

## ⏱️ **Estimated Time**

- **Manual cleanup:** 15 minutes
- **Create README files:** 30 minutes
- **Update cross-references:** 30 minutes
- **Testing/validation:** 15 minutes

**Total:** ~90 minutes

---

## 🎯 **Your Decision**

### **Option A: Do It Now**
✅ We're between features  
✅ Fresh start before next work order  
❌ Delays spec field name fixes by ~90 min

### **Option B: Do It After Spec Compliance** ⭐ RECOMMENDED
✅ Complete spec validation work first  
✅ Then clean up repository  
✅ Both tasks done in one PR

### **Option C: Do It in Phases**
✅ Delete deprecated files now (5 min)  
✅ Full reorganization later  
❌ Still leaves duplicate folders temporarily

---

## 📝 **Quick Questions**

**Q1:** Delete or archive `onboarding_coder_agent_v2.md`?
- [x] **Delete** (git history preserves it)
- [ ] Archive (rename to `*_ARCHIVE.md`)

**Q2:** Keep `/sessions/` folder?
- [x] **Yes** (document it as archival reference)
- [ ] No (move to process_improvement, delete folder)

**Q3:** When to do this?
- [ ] Now (delay spec work)
- [x] **After spec compliance** (recommended)
- [ ] In phases

---

## 🚀 **If You Approve Option B (Recommended):**

**Now:**
1. I'll fix the spec field names (individual, DSP, unit_rate)
2. Update implementation
3. Update tests
4. Deploy CI/CD

**Then (Next Session):**
1. Execute this reorganization
2. Clean up all cross-references
3. One comprehensive commit

**Total Time:** ~3 hours (both tasks)

---

**What's your preference?**
- Just tell me: "**Option B**" (or A or C)
- I'll proceed accordingly

