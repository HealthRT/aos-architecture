# Quick Reference: Which Agent Onboarding File?

**Problem Solved:** No more confusion about which version to use!

---

## ✅ **FIXED: Always Use Files WITHOUT Version Numbers**

### **Current Onboarding Files**

```
📁 /prompts/

  🎯 CORE (All Agents Must Read)
  └── core/00_NON_NEGOTIABLES.md

  👨‍💻 ROLE-SPECIFIC (Use These)
  ├── onboarding_coder_agent.md          ← USE THIS (v3.0)
  ├── onboarding_scrum_master.md         ← USE THIS
  ├── onboarding_business_analyst.md     ← USE THIS
  ├── onboarding_ui_ux_agent.md          ← USE THIS
  ├── onboarding_architect_hub.md        ← USE THIS
  ├── onboarding_github_coach.md         ← USE THIS
  └── onboarding_document_retrieval_agent.md  ← USE THIS

  ❌ DELETED (No Longer Confusing)
  ├── onboarding_coder_agent_v1_DEPRECATED.md  ← DELETED
  └── onboarding_coder_agent_v2.md             ← DELETED
```

---

## 🚀 **How to Onboard a Coder Agent (Simple!)**

### **Standard Dispatch (Copy/Paste This)**

```markdown
You are a Coder Agent for the AOS project.

Read these onboarding documents:
1. @aos-architecture/prompts/core/00_NON_NEGOTIABLES.md
2. @aos-architecture/prompts/onboarding_coder_agent.md

Your work order:
@aos-architecture/work_orders/[path-to-work-order].md
```

**That's it!** No version numbers to remember.

---

## 📋 **Rule: ONE File Per Role**

| ✅ Correct | ❌ Wrong |
|-----------|---------|
| `onboarding_coder_agent.md` | `onboarding_coder_agent_v2.md` |
| Version in file header: `Version: 3.0` | Version in filename |
| Always edit existing file | Create new versioned file |
| Use git history for old versions | Keep old files around |

---

## 🔄 **What Changed?**

### **Before (Confusing):**
```
onboarding_coder_agent.md          ← Which one?!
onboarding_coder_agent_v2.md       ← Is this current?
onboarding_coder_agent_v1_DEPRECATED.md  ← Okay, not this one...
```
**Result:** Paralysis. Which do I use?

### **After (Clear):**
```
onboarding_coder_agent.md          ← This is always current!
```
**Result:** No confusion. Always use the file without version suffix.

---

## 📚 **For More Details**

**Full guide:** `/prompts/README.md`  
**Repository structure:** `/standards/00-repository-structure-governance.md`  
**All primers list:** `/prompts/README.md` (table at top)

---

## 💡 **Pro Tips**

**Tip 1:** Bookmark `/prompts/README.md` - it has the master table of all primers.

**Tip 2:** Version numbers are IN the file header, not in the filename.

**Tip 3:** If you see a file with `_v2` or `_DEPRECATED` in the name, delete it (after checking git history).

**Tip 4:** Use `/templates/dispatch_brief_template.md` for complex dispatches that need extra context.

---

**Created:** 2025-10-12  
**Problem:** User confused by multiple coder agent files during onboarding  
**Solution:** Delete old versions, enforce "one file per role" rule, create this guide

