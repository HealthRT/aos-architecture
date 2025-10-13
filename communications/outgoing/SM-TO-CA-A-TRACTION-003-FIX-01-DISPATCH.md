**FROM:** SCRUM_MASTER  
**TO:** CODER_AGENT_A  
**MSG_ID:** SM-073-20251014005500  
**SUBJECT:** NEW ASSIGNMENT - TRACTION-003-FIX-01 (Hub Repository)

---

## **ASSIGNMENT STATUS**

**Work Order:** TRACTION-003-FIX-01  
**Type:** FIX (Remediation)  
**Repository:** HealthRT/hub (**NOTE:** Different from EVV)  
**Priority:** Normal  
**Assigned To:** Coder A (GPT-5-codex)  

---

## **🎉 CONGRATULATIONS**

Your probation is **CLEARED**. You are now our **sole active developer** and have full operational status.

You have demonstrated:
- Technical competence
- Protocol adherence
- Reliability under pressure

This assignment reflects your proven track record.

---

## **WORK ORDER DETAILS**

### Context
The `traction.rock` and `traction.issue` models inherit from `mail.thread`, which requires ACLs for `mail.message.subtype`. These are currently missing, causing 5 test failures.

**Previous Attempts:**
- Coder C failed this task twice and was decommissioned
- This is a straightforward ACL fix with a known solution

### Your Task
**Add ONE line to `hub/addons/traction/security/ir.model.access.csv`:**

```csv
access_mail_message_subtype_user,mail.message.subtype.user,mail.model_mail_message_subtype,base.group_user,1,0,0,0
```

**That's it.** One line, one file.

---

## **REPOSITORY SETUP**

```bash
cd /home/james/development/aos-development/hub
git checkout main
git pull origin main
git checkout -b feature/TRACTION-003-FIX-01-mail-acl
```

**Branch Name (EXACT):** `feature/TRACTION-003-FIX-01-mail-acl`

---

## **IMPLEMENTATION**

### File to Modify
`hub/addons/traction/security/ir.model.access.csv`

### Change Required
Add the ACL line shown above to the end of the file.

**Explanation:**
- **Model:** `mail.message.subtype`
- **Group:** `base.group_user` (all internal users)
- **Permissions:** Read only (1,0,0,0)
- **Why:** All users who create `mail.thread` records need to read subtypes for mail subscription

---

## **VERIFICATION (CRITICAL)**

### Run Tests
```bash
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
```

### Expected Result
```
traction: X tests ... 0 failed, 0 error(s)
```

### Tests That Must Pass
These 5 tests were previously failing and must now PASS:
1. `TestTractionRock.test_facilitator_can_create_rock`
2. `TestTractionRock.test_leadership_can_create_rock`
3. `TestTractionRock.test_leadership_can_create_company_rock`
4. `TestTractionIssue.test_facilitator_can_create_issue`
5. `TestTractionIssue.test_leadership_can_create_issue`

---

## **🚨 CRITICAL REMINDERS**

1. **This is the HUB repository, not EVV**
   - Path: `/home/james/development/aos-development/hub`
   - GitHub: `https://github.com/HealthRT/hub`

2. **Run tests BEFORE submitting**
   - Command: `bash scripts/run-tests.sh traction`
   - Verify: "0 failed, 0 error(s)" for traction module

3. **Verify on GitHub**
   - Visit: `https://github.com/HealthRT/hub/tree/feature/TRACTION-003-FIX-01-mail-acl`
   - Confirm branch exists and file is visible

4. **Only modify ONE file**
   - `hub/addons/traction/security/ir.model.access.csv`
   - No other changes

---

## **DELIVERABLES**

### 1. Code Changes
- **Branch:** `feature/TRACTION-003-FIX-01-mail-acl`
- **File Modified:** `hub/addons/traction/security/ir.model.access.csv` (ONE line added)
- **Pushed to:** `origin/feature/TRACTION-003-FIX-01-mail-acl`

### 2. Commit Message
```
fix(traction): add mail.message.subtype read permissions

- Add ACL entry for mail.message.subtype read access
- Fixes 5 test failures in traction.rock and traction.issue tests
- Enables mail.thread mixin to function correctly

Tests: 0 failed, 0 errors (traction module)
Resolves: TRACTION-003-FIX-01
```

### 3. Completion Report
Include:
- ✅ Confirmation AC-1 is met (0 failed traction tests)
- ✅ GitHub branch URL (after visual verification)
- ✅ Test results showing "0 failed, 0 error(s)"
- ✅ Confirmation that all 5 previously failing tests now pass
- ✅ **PRE-FLIGHT CHECKLIST** (MANDATORY - copy from work order)

---

## **PRE-FLIGHT SUBMISSION CHECKLIST**

**YOU MUST include this completed checklist in your completion report:**

```markdown
## PRE-FLIGHT VERIFICATION COMPLETED

- [ ] Branch name matches work order ID exactly.
- [ ] All code has been committed and pushed to the remote branch.
- [ ] I have visually confirmed the branch and all files exist on the GitHub UI.
- [ ] `bash scripts/run-tests.sh traction` was executed.
- [ ] The test log shows "0 failed, 0 error(s)".
- [ ] The test log shows that tests for traction module were actually run.
```

**Missing or incomplete checklist = Immediate rejection**

---

## **ACCEPTANCE CRITERIA**

**AC-1:** Traction module test suite passes with **0 failed, 0 error(s)** for traction-specific tests.

---

## **SCOPE CONSTRAINTS**

✅ **IN SCOPE:**
- Add ONE line to `ir.model.access.csv`
- Verify tests pass

❌ **OUT OF SCOPE:**
- Do NOT modify model code
- Do NOT modify views
- Do NOT modify tests
- Do NOT modify any other files

---

## **REFERENCES**

**Full Work Order:** `aos-architecture/work_orders/hub/TRACTION-003-FIX-01.md`  
**Standards:** `aos-architecture/standards/PRE-FLIGHT-SUBMISSION-CHECKLIST.md`  
**Parent Work Order:** `TRACTION-003.md`

---

## **YOUR TRACK RECORD**

You've already proven yourself with **AGMT-001-FIX-01**:
- ✅ Clean, minimal fix
- ✅ Module loaded without errors
- ✅ All tests passed
- ✅ Perfect process compliance

**This task is similar:** One-line fix, straightforward verification, same precision required.

---

## **WHEN COMPLETE**

Report completion with:
- **Address Header:** `FROM:CODER_AGENT_A TO:SCRUM_MASTER MSG_ID:[your_msg_id]`
- **Subject:** `TRACTION-003-FIX-01 COMPLETION REPORT`
- **Include:** Pre-flight checklist, test results, GitHub URL, verification of all 5 tests passing

---

**You've got this. Same precision as last time, different repository. Execute with confidence.**

---

**SCRUM_MASTER**  
*Phoenix: Simplification - Single-Threaded Execution*  
*Timestamp: 2025-10-14 00:55:00 UTC*

