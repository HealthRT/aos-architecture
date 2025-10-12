# Pre-UAT Check: AGMT-001 - Service Agreement Management

**Feature/Story ID:** AGMT-001  
**Feature Name:** Service Agreement Management (Simple Bucket MVP)  
**Date:** 2025-10-12  
**Performed By:** James  
**Start Time:** ______  
**End Time:** ______  
**Actual Duration:** ______ minutes

---

## 1. Environment Verification

**Objective:** Ensure development environment is ready for testing

- [ ] Docker containers running (`docker compose ps` shows all healthy)
- [ ] Database accessible (no connection errors)
- [ ] Odoo boots without errors (check logs)
- [ ] Test data available (sample patient and case manager contacts exist)
- [ ] No startup warnings or exceptions

**Notes:**
```
[Check docker compose logs for clean boot]
```

---

## 2. Navigation & Access

**Objective:** Verify user can reach the feature

- [ ] Can navigate to EVV → Service Agreements via menu
- [ ] Menu item appears in correct location
- [ ] Menu item has appropriate label ("Service Agreements")
- [ ] No permission/access errors
- [ ] List view loads without delay or error

**Notes:**
```
[Menu path verification]
```

---

## 3. Create Operation (C in CRUD)

**Objective:** Verify user can create new service agreements

- [ ] "Create" button exists and is accessible
- [ ] Form displays all expected field groups:
  - [ ] External Reference (agreement_number, provider_id, line_number, line_status, recipient_id_external)
  - [ ] Patient & Service (patient_id, procedure_code, modifiers 1-4, service_description)
  - [ ] Authorization Period & Quantity (effective_date, through_date, total_units)
  - [ ] Financial Information (rate_per_unit, currency_id)
  - [ ] Compliance (diagnosis_code, case_manager_id)
- [ ] Required fields are marked with asterisk or similar
- [ ] Patient dropdown filters to show only patients (is_patient=True)
- [ ] Case Manager dropdown filters to show only case managers (is_case_manager=True)
- [ ] Can fill form with valid data
- [ ] Save button works
- [ ] Record is created successfully (state = 'draft')
- [ ] Success message/feedback displayed

**Test Data Used:**
```
Patient: [Name of test patient]
Procedure Code: H2014
Modifiers: UC, U3
Effective Date: [Today's date]
Through Date: [30 days from today]
Total Units: 100
Rate Per Unit: 11.66
```

**Notes:**
```
[Create operation observations]
```

---

## 4. Read Operation (R in CRUD)

**Objective:** Verify user can view service agreements

- [ ] List view displays created service agreement
- [ ] List columns show correct data (patient, procedure code, dates, units)
- [ ] Can open record to view details
- [ ] Form view displays all field values correctly
- [ ] Computed fields calculate correctly:
  - [ ] start_date = effective_date
  - [ ] end_date = through_date
  - [ ] total_amount = rate_per_unit × total_units (e.g., 11.66 × 100 = 1,166.00)
- [ ] Patient relationship displays correctly (name shown)
- [ ] Case manager relationship displays correctly (if assigned)

**Notes:**
```
[Read operation observations]
```

---

## 5. Update Operation (U in CRUD)

**Objective:** Verify user can edit existing service agreements

- [ ] "Edit" button/action accessible
- [ ] Can modify field values (e.g., change total_units from 100 to 150)
- [ ] Changes save successfully
- [ ] Updated values display correctly
- [ ] Computed fields recalculate (total_amount should update if rate or units change)

**Notes:**
```
[Update operation observations]
```

---

## 6. Delete Operation (D in CRUD)

**Objective:** Verify user can delete service agreements

- [ ] "Delete" action accessible (Action → Delete menu)
- [ ] Confirmation prompt appears
- [ ] Record deletes successfully (if in draft state)
- [ ] OR: If deletion constraints exist, appropriate error shown

**Notes:**
```
[Delete operation observations - test with draft record]
```

---

## 7. Business Logic & Validation

**Objective:** Verify business rules and validation constraints work

### Validation Test 1: Date Range Validation
- [ ] **Description:** Effective date must be on or before through date
- [ ] **Test:** Create agreement with through_date < effective_date (e.g., effective=2025-12-31, through=2025-01-01)
- [ ] **Expected:** ValidationError with message "Effective Date must be on or before Through Date."
- [ ] **Actual:** ______
- [ ] **Result:** Pass / Fail

### Validation Test 2: Positive Units Validation
- [ ] **Description:** Total units must be > 0
- [ ] **Test:** Create agreement with total_units = 0 or negative
- [ ] **Expected:** ValidationError with message "Total Units must be a positive number (> 0)."
- [ ] **Actual:** ______
- [ ] **Result:** Pass / Fail

### Validation Test 3: Required Fields on Activation
- [ ] **Description:** action_activate validates required fields
- [ ] **Test:** Create agreement without total_units, try to activate
- [ ] **Expected:** ValidationError about missing required field
- [ ] **Actual:** ______
- [ ] **Result:** Pass / Fail

### Validation Test 4: Multiple Service Lines
- [ ] **Description:** Same patient can have multiple agreements
- [ ] **Test:** Create 2 agreements for same patient with different procedure codes/modifiers
- [ ] **Expected:** Both agreements save successfully
- [ ] **Actual:** ______
- [ ] **Result:** Pass / Fail

**Notes:**
```
[Validation observations]
```

---

## 8. State Management

**Objective:** Verify state transitions and workflows function

- [ ] Initial state is 'draft' when created
- [ ] State transition actions exist:
  - [ ] "Activate" button/action visible
  - [ ] "Cancel" button/action visible
- [ ] action_activate() works:
  - [ ] Validates required fields before transition
  - [ ] Changes state from 'draft' to 'active'
  - [ ] State persists after save
- [ ] action_cancel() works:
  - [ ] Changes state to 'cancelled'
  - [ ] No validation required (always allowed)
- [ ] UI updates to reflect current state

**Notes:**
```
[State management observations]
```

---

## 9. UI/UX Quick Assessment

**Objective:** Identify obvious usability issues

- [ ] Form layout is logical and clear
- [ ] Field groups make sense (External Reference, Patient & Service, etc.)
- [ ] Field labels are understandable (no technical jargon where business terms needed)
- [ ] Help text is present on complex fields
- [ ] No obvious layout issues (overlapping, misaligned fields)
- [ ] Buttons are clearly labeled ("Activate", "Cancel", "Save")
- [ ] Error messages are user-friendly (not raw Python exceptions)
- [ ] Overall appearance is professional (standard Odoo styling)

**Notes:**
```
[UI/UX observations - note anything confusing or awkward]
```

---

## 10. Technical Checks

**Objective:** Verify no technical issues present

- [ ] No JavaScript errors in browser console (F12 → Console tab)
- [ ] No Python exceptions in Odoo logs (`docker compose logs odoo`)
- [ ] No database errors in logs
- [ ] Page load times are reasonable (<2 seconds)
- [ ] No broken images or missing resources

**Console/Log Errors Found:**
```
[Paste any errors - if none, write "None"]
```

**Notes:**
```
[Technical observations]
```

---

## 11. Edge Cases (Quick Checks)

**Objective:** Test a few common edge cases

- [ ] Empty optional fields handled correctly (can save with only required fields)
- [ ] Very long service_description doesn't break layout (test with 200+ characters)
- [ ] Special characters in text fields work (test &, <, >, quotes)
- [ ] Dates in past work (effective_date = yesterday)
- [ ] Large total_units value works (test 10,000 units)
- [ ] High rate_per_unit works (test $999.99)

**Notes:**
```
[Edge case observations]
```

---

## Summary

### What Worked Well
1. ______
2. ______
3. ______

### Issues Found

#### Critical Issues (Blockers)
1. **[Issue Description if any]**
   - Severity: Critical
   - Impact: ______
   - Reproduction: ______

*(If none, write "None found")*

#### Medium Issues (Should Fix)
1. **[Issue Description if any]**
   - Severity: Medium
   - Impact: ______
   - Reproduction: ______

*(If none, write "None found")*

#### Minor Issues (Nice to Have)
1. **[Issue Description if any]**
   - Severity: Low
   - Impact: ______
   - Reproduction: ______

*(If none, write "None found")*

### Overall Assessment

**Functionality:** ______ [Working / Mostly Working / Broken]  
**UI/UX:** ______ [Good / Acceptable / Needs Work]  
**Performance:** ______ [Fast / Acceptable / Slow]  
**Stability:** ______ [Stable / Some Issues / Unstable]

---

## Gate Decision

**Pre-UAT Check Result:**

- [ ] ✅ **PASS** - Feature is ready for SME UAT
  - All critical functionality works
  - No blockers found
  - Issues are minor or can be noted for SME feedback
  - **Next Step:** Schedule SME UAT session to address open items and get business sign-off

- [ ] ❌ **FAIL** - Feature needs more work before SME UAT
  - Critical issues found
  - Basic functionality broken
  - Would waste SME time
  - **Next Step:** Create bug issues, return to development

**Justification:**
```
[Explain your gate decision - what made you choose Pass or Fail?]
```

---

## Next Steps

**If PASS:**
1. [ ] Review open items document (`AGMT-001-open-items.md`) - 6 questions need SME input
2. [ ] Convert open items to PDF for SME review (per guide in `AGMT-001-open-items-pdf-guide.md`)
3. [ ] Schedule SME UAT session (1-2 hours)
4. [ ] Create formal UAT test plan (if needed beyond open items discussion)

**If FAIL:**
1. [ ] Create GitHub issues for each critical/medium bug
2. [ ] Prioritize bugs
3. [ ] Assign to coder agent (Claude or GPT-5)
4. [ ] Re-run Pre-UAT Check after fixes
5. [ ] Do not proceed to UAT until Pass

---

## Sign-Off

**Completed By:** James  
**Date:** 2025-10-12  
**Time Spent:** ______ minutes  
**Recommendation:** [PASS / FAIL]

---

## Reference Documents

- **Specification:** `@aos-architecture/specs/evv/AGMT-001.yaml`
- **Feature Brief:** `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md`
- **Documentation:** `@evv/addons/evv_agreements/docs/models/service_agreement.md`
- **Open Items:** `@aos-architecture/specs/evv/AGMT-001-open-items.md`

