# Pre-UAT Check Template

**Purpose:** Quick technical verification by the Technical Lead before formal SME UAT. This "smoke test" ensures basic functionality works and prevents wasting SME time on broken features.

**Duration:** 15-30 minutes  
**Owner:** Technical Lead (James)  
**Gate:** Must pass before proceeding to SME UAT

---

## Checklist Instructions

1. Fill out the metadata section
2. Work through each checklist section
3. Check boxes as you complete each item
4. Document any issues found
5. Make gate decision (Pass/Fail)
6. If Pass: Schedule SME UAT
7. If Fail: Create bug issues and return to development

---

## Feature Information

**Feature/Story ID:** [e.g., AGMT-001]  
**Feature Name:** [e.g., Service Agreement Management]  
**Date:** [YYYY-MM-DD]  
**Performed By:** [Your Name]  
**Start Time:** [HH:MM]  
**End Time:** [HH:MM]  
**Actual Duration:** [XX minutes]

---

## 1. Environment Verification

**Objective:** Ensure development environment is ready for testing

- [ ] Docker containers running (`docker compose ps` shows all healthy)
- [ ] Database accessible (no connection errors)
- [ ] Odoo boots without errors (check logs)
- [ ] Test data available (or can be created)
- [ ] No startup warnings or exceptions

**Notes:**
```
[Any observations about environment]
```

---

## 2. Navigation & Access

**Objective:** Verify user can reach the feature

- [ ] Can navigate to feature via menu
- [ ] Menu item appears in correct location
- [ ] Menu item has appropriate label
- [ ] No permission/access errors
- [ ] Feature loads without delay or error

**Notes:**
```
[Navigation observations]
```

---

## 3. Create Operation (C in CRUD)

**Objective:** Verify user can create new records

- [ ] "Create" button/action exists and is accessible
- [ ] Form displays all expected fields
- [ ] Fields are organized logically (grouped, labeled)
- [ ] Required fields are marked
- [ ] Dropdowns/selections populate correctly
- [ ] Can fill form with valid data
- [ ] Save button works
- [ ] Record is created successfully
- [ ] Success message/feedback displayed (if applicable)

**Test Data Used:**
```
[Describe what record you created]
```

**Notes:**
```
[Create operation observations]
```

---

## 4. Read Operation (R in CRUD)

**Objective:** Verify user can view records

- [ ] List view displays created record
- [ ] List columns show correct data
- [ ] Can open record to view details
- [ ] Form view displays all field values correctly
- [ ] Computed fields calculate correctly
- [ ] Related records link/display properly

**Notes:**
```
[Read operation observations]
```

---

## 5. Update Operation (U in CRUD)

**Objective:** Verify user can edit existing records

- [ ] "Edit" button/action accessible
- [ ] Can modify field values
- [ ] Changes save successfully
- [ ] Updated values display correctly
- [ ] Computed fields recalculate if needed

**Notes:**
```
[Update operation observations]
```

---

## 6. Delete Operation (D in CRUD)

**Objective:** Verify user can delete records (if applicable)

- [ ] "Delete" action accessible
- [ ] Confirmation prompt appears (if expected)
- [ ] Record deletes successfully
- [ ] OR: If deletion not allowed, appropriate error/constraint shown

**Notes:**
```
[Delete operation observations]
```

---

## 7. Business Logic & Validation

**Objective:** Verify business rules and validation constraints work

**For each validation rule documented in spec:**

### Validation Test 1: [Rule Name]
- [ ] **Description:** [What rule are you testing?]
- [ ] **Test:** [What did you do to trigger validation?]
- [ ] **Expected:** [What should happen?]
- [ ] **Actual:** [What actually happened?]
- [ ] **Result:** Pass / Fail

### Validation Test 2: [Rule Name]
- [ ] **Description:** 
- [ ] **Test:** 
- [ ] **Expected:** 
- [ ] **Actual:** 
- [ ] **Result:** Pass / Fail

### Validation Test 3: [Rule Name]
- [ ] **Description:** 
- [ ] **Test:** 
- [ ] **Expected:** 
- [ ] **Actual:** 
- [ ] **Result:** Pass / Fail

**Notes:**
```
[Validation observations]
```

---

## 8. State Management (If Applicable)

**Objective:** Verify state transitions and workflows function

- [ ] Initial state is correct (e.g., "Draft")
- [ ] State transition actions exist (e.g., "Activate", "Cancel")
- [ ] Transitions work correctly
- [ ] Validation occurs before state change (if required)
- [ ] State changes are persisted
- [ ] UI updates to reflect new state

**Notes:**
```
[State management observations]
```

---

## 9. UI/UX Quick Assessment

**Objective:** Identify obvious usability issues

- [ ] Form layout is logical and clear
- [ ] Field labels are understandable
- [ ] Help text is present (where needed)
- [ ] No obvious layout issues (overlapping, misaligned)
- [ ] Buttons are clearly labeled
- [ ] Error messages are user-friendly
- [ ] Overall appearance is professional

**Notes:**
```
[UI/UX observations]
```

---

## 10. Technical Checks

**Objective:** Verify no technical issues present

- [ ] No JavaScript errors in browser console
- [ ] No Python exceptions in Odoo logs
- [ ] No database errors in logs
- [ ] Page load times are reasonable
- [ ] No broken images or missing resources

**Console/Log Errors Found:**
```
[Paste any errors]
```

**Notes:**
```
[Technical observations]
```

---

## 11. Edge Cases (Quick Checks)

**Objective:** Test a few common edge cases

- [ ] Empty/null values handled correctly
- [ ] Very long text strings don't break layout
- [ ] Special characters in text fields work
- [ ] Dates in past/future work as expected
- [ ] Zero or negative numbers handled (if relevant)

**Notes:**
```
[Edge case observations]
```

---

## Summary

### What Worked Well
1. [Positive observation]
2. [Positive observation]
3. [Positive observation]

### Issues Found

#### Critical Issues (Blockers)
1. **[Issue Description]**
   - Severity: Critical
   - Impact: [Why this blocks UAT]
   - Reproduction: [How to reproduce]

#### Medium Issues (Should Fix)
1. **[Issue Description]**
   - Severity: Medium
   - Impact: [Impact description]
   - Reproduction: [How to reproduce]

#### Minor Issues (Nice to Have)
1. **[Issue Description]**
   - Severity: Low
   - Impact: [Impact description]
   - Reproduction: [How to reproduce]

### Overall Assessment

**Functionality:** [Working / Mostly Working / Broken]  
**UI/UX:** [Good / Acceptable / Needs Work]  
**Performance:** [Fast / Acceptable / Slow]  
**Stability:** [Stable / Some Issues / Unstable]

---

## Gate Decision

**Pre-UAT Check Result:**

- [ ] ✅ **PASS** - Feature is ready for SME UAT
  - All critical functionality works
  - No blockers found
  - Issues are minor or can be noted for SME feedback
  - **Next Step:** Schedule SME UAT session

- [ ] ❌ **FAIL** - Feature needs more work before SME UAT
  - Critical issues found
  - Basic functionality broken
  - Would waste SME time
  - **Next Step:** Create bug issues, return to development

**Justification:**
```
[Explain your gate decision]
```

---

## Next Steps

**If PASS:**
1. [ ] Create SME UAT test plan (if not already exists)
2. [ ] Schedule SME UAT session
3. [ ] Prepare demo environment
4. [ ] Brief SME on what to expect

**If FAIL:**
1. [ ] Create GitHub issues for each critical/medium bug
2. [ ] Prioritize bugs
3. [ ] Assign to coder agent
4. [ ] Re-run Pre-UAT Check after fixes
5. [ ] Do not proceed to UAT until Pass

---

## Sign-Off

**Completed By:** [Your Name]  
**Date:** [YYYY-MM-DD]  
**Time Spent:** [XX minutes]  
**Recommendation:** [PASS / FAIL]

---

**File Location:** Save completed checks to:  
`/specs/[repository]/[feature-id]/[FEATURE-ID]-pre-uat-check-[date].md`

Example: `/specs/evv/AGMT-001/AGMT-001-pre-uat-check-2025-10-12.md`

