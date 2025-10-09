# Post-Issue #2 Workflow Plan

**Date:** 2025-10-09  
**Context:** Planning what happens after Issue #2 (Code Hygiene) completes

---

## 🎯 **Current State**

### Feature Branch Structure
```
main (mostly empty)
  ↓
feature/TRAC-REFACTOR-003-api-first-logic (has service layer)
  ↓
feature/TRAC-REFACTOR-004-event-broadcasting (has events) [COMPLETE]
  ↓
feature/TRAC-REFACTOR-005-code-hygiene (Issue #2) [IN PROGRESS]
```

### Issues Status
- **Issue #1:** Code complete on `feature/TRAC-REFACTOR-004-event-broadcasting`, needs review/merge
- **Issue #2:** In progress on `feature/TRAC-REFACTOR-005-code-hygiene`, coder working now
- **Issue #3:** Ready to execute, waiting for #1 & #2 to complete

---

## 🔄 **DECISION POINT 1: Branch Merge Strategy**

### Option A: Sequential Feature Branch Merging ⭐ **RECOMMENDED**

**Process:**
```
1. Complete Issue #2 (code hygiene)
2. Review & merge #2 → into TRAC-REFACTOR-004 (event broadcasting)
3. Review & merge combined #2+#4 → into TRAC-REFACTOR-003 (api-first)
4. Review & test combined work
5. Merge TRAC-REFACTOR-003 → main
6. Issue #3 branches from main
```

**Pros:**
- ✅ Each merge is small, easy to review
- ✅ Can test at each step
- ✅ Problems isolated to specific feature
- ✅ Clear history of changes

**Cons:**
- ⚠️ Multiple merge steps
- ⚠️ Takes more time

---

### Option B: Merge All to Main at Once

**Process:**
```
1. Complete Issue #2
2. Merge TRAC-REFACTOR-003 (with all sub-branches) → main
3. Issue #3 branches from main
```

**Pros:**
- ✅ Faster, single merge
- ✅ Less ceremony

**Cons:**
- ❌ Large diff, harder to review
- ❌ If problems, harder to isolate
- ❌ All-or-nothing approach

---

### Option C: Continue Stacking Feature Branches

**Process:**
```
1. Complete Issue #2 on TRAC-REFACTOR-005
2. Issue #3 branches from TRAC-REFACTOR-005
3. Keep stacking, merge all at end
```

**Pros:**
- ✅ Keeps momentum
- ✅ No merge friction during development

**Cons:**
- ❌ Merge conflicts compound
- ❌ Can't deploy partial features
- ❌ High risk at final merge

---

## ✅ **RECOMMENDED STRATEGY: Option A (Sequential Merging)**

**Rationale:**
1. Feature work is done (API-first complete)
2. Time to consolidate and stabilize
3. Issue #3 (documentation) can wait for clean base
4. Want to test combined features before proceeding

---

## 📋 **DETAILED POST-ISSUE #2 STEPS**

### **Step 1: Agent Completes Issue #2** ⏳ *In Progress*

**Agent will provide:**
- Git diff of changes
- Proof of execution (Odoo boot logs)
- Test results

**You/Coach will:**
- Review changes against acceptance criteria
- Verify proof of execution
- Approve or request revisions

---

### **Step 2: Create Pull Request for Issue #2**

**After approval:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRAC-REFACTOR-005-code-hygiene

gh pr create \
  --title "[REFACTOR] Code Hygiene and Test Coverage (Closes #2)" \
  --body "See Issue #2 for details. Removes dead code, fixes hardcoded user ID, adds tests." \
  --base feature/TRAC-REFACTOR-003-api-first-logic \
  --label "status:needs-review,type:refactor,module:hub-traction"
```

**Review:**
- Check git diff
- Verify acceptance criteria
- Test locally if needed
- Approve or request changes

**Merge:**
```bash
gh pr merge --squash  # or --merge or --rebase
```

---

### **Step 3: Review Issue #1 (Event Broadcasting)**

Issue #1 code exists on `feature/TRAC-REFACTOR-004-event-broadcasting`

**Actions:**
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRAC-REFACTOR-004-event-broadcasting

# Review the implementation
git log --oneline
git diff feature/TRAC-REFACTOR-003-api-first-logic..HEAD

# Test it
docker compose up -d --force-recreate odoo
docker compose logs --tail="100" odoo
```

**Verify:**
- Events are emitted correctly
- No errors in logs
- Meets acceptance criteria from Issue #1

**Create PR:**
```bash
gh pr create \
  --title "[REFACTOR] Implement Event Broadcasting (Closes #1)" \
  --body "See Issue #1 for details. Adds event emission and extension hooks." \
  --base feature/TRAC-REFACTOR-003-api-first-logic \
  --label "status:needs-review,type:refactor,module:hub-traction"
```

**After review, merge to TRAC-REFACTOR-003**

---

### **Step 4: Consolidate and Test All Features**

Now `feature/TRAC-REFACTOR-003-api-first-logic` contains:
- ✅ Service layer (original)
- ✅ Event broadcasting (Issue #1)
- ✅ Code hygiene + tests (Issue #2)

**Comprehensive Testing:**
```bash
git checkout feature/TRAC-REFACTOR-003-api-first-logic

# Full test suite
docker compose down
docker compose up -d --build odoo
sleep 30

# Run all tests
docker compose exec odoo odoo --test-enable --stop-after-init \
  -d test_db -u traction_eos_odoo

# Check logs
docker compose logs odoo | grep -i error
docker compose logs odoo | grep -i "test_meeting_service"
```

**Verify:**
- All tests pass
- Odoo boots cleanly
- No regressions
- Events work
- Service layer functions correctly

---

### **Step 5: Merge to Main (or Staging)**

**Decision: Where to merge?**

**Option 5A: Merge to Staging First** ⭐ *Recommended if you have staging*
```bash
gh pr create \
  --title "[FEATURE] Traction EOS API-First Refactoring Complete" \
  --body "Consolidates Issues #1, #2, and #3. See individual issues for details." \
  --base staging \
  --label "status:needs-review,type:feature,module:hub-traction"
```

**Then:**
1. Deploy to staging environment
2. Perform UAT testing
3. Stakeholder sign-off
4. Merge staging → main

**Option 5B: Merge Directly to Main** *If no staging*
```bash
gh pr create \
  --title "[FEATURE] Traction EOS API-First Refactoring Complete" \
  --body "Consolidates Issues #1, #2. See individual issues for details." \
  --base main \
  --label "status:needs-review,type:feature,module:hub-traction,priority:high"
```

---

### **Step 6: Close Issues #1 and #2**

**After merge to main:**
```bash
gh issue close 1 --comment "Completed and merged to main via PR #X" --repo HealthRT/hub
gh issue close 2 --comment "Completed and merged to main via PR #X" --repo HealthRT/hub
```

---

### **Step 7: Prepare for Issue #3 (Documentation)**

**Now that code is on main:**
```bash
cd /home/james/development/aos-development/hub
git checkout main
git pull origin main
git checkout -b feature/TRAC-REFACTOR-006-documentation
```

**Update Issue #3 if needed:**
- Verify base branch is now `main` (not a feature branch)
- Confirm all code to document is present
- Ready to dispatch to coder agent

**Dispatch Issue #3:**
- Open new Composer chat
- Follow same onboarding process
- Assign Issue #3

---

## 🎯 **DECISION CHECKLIST**

Before proceeding, decide:

- [ ] **Merge Strategy:** Sequential (A), All-at-once (B), or Keep stacking (C)?
  - **Recommendation:** A (Sequential)

- [ ] **Staging vs Main:** Merge to staging first or directly to main?
  - **Recommendation:** Staging if available, main if not

- [ ] **Testing Depth:** How much testing before merge?
  - **Recommendation:** Full test suite + manual smoke test

- [ ] **Issue #3 Timing:** Start immediately after #2 or wait for main merge?
  - **Recommendation:** Wait for main merge so docs reflect production code

---

## ⏱️ **TIMELINE ESTIMATE**

**If Issue #2 completes today:**

**Day 1 (Today):**
- ✅ Issue #2 code complete
- ✅ Review & create PR for #2
- ⏱️ 1-2 hours

**Day 2:**
- Review & merge Issue #1
- Comprehensive testing
- ⏱️ 2-3 hours

**Day 3:**
- Create consolidated PR to main
- Final review
- Merge
- ⏱️ 1-2 hours

**Day 4:**
- Dispatch Issue #3 (documentation)
- ⏱️ Coder works 2-3 hours

**Day 5:**
- Review Issue #3
- Merge
- All traction issues complete! 🎉

**Total:** ~5 days at a measured pace

---

## 🚨 **POTENTIAL RISKS**

### Risk 1: Merge Conflicts
**Likelihood:** Low (small, focused changes)  
**Mitigation:** Merge frequently, keep branches short-lived

### Risk 2: Test Failures
**Likelihood:** Medium (new tests being added)  
**Mitigation:** Run tests at each step, fix before proceeding

### Risk 3: Docker Issues
**Likelihood:** Medium (Odoo environment complexity)  
**Mitigation:** Document docker commands, have rollback plan

### Risk 4: Scope Creep
**Likelihood:** Medium (temptation to add "just one more thing")  
**Mitigation:** Stick to defined acceptance criteria, defer extras

---

## ✅ **SUCCESS CRITERIA**

We'll know we're done when:
- [ ] All 3 issues (#1, #2, #3) closed
- [ ] Code merged to main
- [ ] All tests passing
- [ ] Odoo boots without errors
- [ ] Documentation complete
- [ ] Feature branches cleaned up

---

## 📊 **REFERENCE COMMANDS**

Quick reference for post-Issue #2 actions:

```bash
# Check branch status
cd /home/james/development/aos-development/hub
git branch -a
git log --oneline --graph --all

# Review a feature branch
git checkout feature/TRAC-REFACTOR-XXX
git diff main..HEAD

# Create PR
gh pr create --title "..." --body "..." --base main

# Merge PR
gh pr merge PR_NUMBER --squash

# Close issue
gh issue close NUMBER --comment "..." --repo HealthRT/hub

# Clean up local branches after merge
git branch -d feature/TRAC-REFACTOR-XXX
```

---

**Created:** 2025-10-09  
**Status:** Planning Document  
**Next Update:** After Issue #2 completes

