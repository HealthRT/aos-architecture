---
title: "[FIX] TRACTION-003-FIX-01: Fix Mail Message Subtype ACL Permissions (PROBATIONARY)"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:critical,type:fix,status:probation"
---
# Work Order: TRACTION-003-FIX-01 – Fix Mail Message Subtype ACL Permissions (PROBATIONARY)

## ⚠️ PROBATIONARY STATUS - RE-ASSIGNED

**This work order has been RE-ASSIGNED as a probationary task following protocol violations in your previous submission.**

**Reason for Probation:** Your previous submission reported completion from the wrong branch and provided "expected results" instead of actual test execution proof.

**Standard Required:** PERFECTION in both technical fix AND protocol adherence.

**Consequences:**
- ✅ Perfect execution → Probation cleared, return to normal work
- ❌ Any failure → Decommissioning from roster

---

## 1. Context & Objective

**CRITICAL REMEDIATION:** Fix ACL permission failures in the traction module test suite.

**Root Cause:** The `traction.rock` and `traction.issue` models inherit from `mail.thread`, but test users lack read permissions for `mail.message.subtype`, causing 5 test failures.

**Parent Work Order:** TRACTION-003 (rejected due to failing tests)

---

## 2. Development Environment

### Target Repository
**Repository:** hub  
**Base Branch:** `feature/TRACTION-003-rocks-model`  
**New Branch:** `feature/TRACTION-003-FIX-01-mail-acl`

### Setup Commands
```bash
cd /home/james/development/aos-development/hub
git checkout feature/TRACTION-003-rocks-model
git pull origin feature/TRACTION-003-rocks-model
git checkout -b feature/TRACTION-003-FIX-01-mail-acl
```

---

## 3. Problem Statement

**Test Failures (5 tests):**
1. `TestTractionRock.test_facilitator_can_create_rock` - ERROR
2. `TestTractionRock.test_leadership_can_create_rock` - ERROR
3. `TestTractionRock.test_leadership_can_create_company_rock` - ERROR
4. `TestTractionIssue.test_facilitator_can_create_issue` - ERROR
5. `TestTractionIssue.test_leadership_can_create_issue` - ERROR

**Error Message:**
```
Access Denied by ACLs for operation: read, uid: XXX, model: mail.message.subtype
```

**Cause:** When creating traction.rock or traction.issue records (which inherit mail.thread), Odoo automatically tries to subscribe users to mail channels and needs to read `mail.message.subtype`. Test users (facilitator_user, leadership_user) lack this permission.

---

## 4. Required Implementation

### A. Update `hub/addons/traction/security/ir.model.access.csv`

Add read permissions for `mail.message.subtype` to the base user group:

```csv
access_mail_message_subtype_user,mail.message.subtype.user,mail.model_mail_message_subtype,base.group_user,1,0,0,0
```

**Explanation:**
- Model: `mail.message.subtype`
- Group: `base.group_user` (all internal users)
- Permissions: Read only (1,0,0,0)
- Why: All users who create mail.thread records need to read subtypes for mail subscription

**Alternative (if more restrictive access desired):**
Add read permissions to facilitator and leadership groups specifically:

```csv
access_mail_message_subtype_facilitator,mail.message.subtype.facilitator,mail.model_mail_message_subtype,traction.group_facilitator,1,0,0,0
access_mail_message_subtype_leadership,mail.message.subtype.leadership,mail.model_mail_message_subtype,traction.group_leadership,1,0,0,0
```

---

## 5. Testing

### Run Full Traction Test Suite
```bash
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
```

**Required Result:**
- `traction: X tests` where X = 76
- **0 failed, 0 error(s)** for traction module tests
- Previously failing 5 tests now PASS

**Critical Verification:**
- [ ] Verify `test_facilitator_can_create_rock` PASSES
- [ ] Verify `test_leadership_can_create_rock` PASSES
- [ ] Verify `test_leadership_can_create_company_rock` PASSES
- [ ] Verify `test_facilitator_can_create_issue` PASSES
- [ ] Verify `test_leadership_can_create_issue` PASSES

---

## 6. Acceptance Criteria

**Single Acceptance Criterion:**
- AC-1: Traction module test suite passes with **0 failed, 0 error(s)** for traction-specific tests

**Note:** Other module test failures (base, web, bus, mail) are out of scope for this work order. They are systemic test environment issues addressed by SYSTEM-008.

---

## 7. MANDATORY: Pre-Flight Submission Checklist

**YOU MUST complete and include this checklist in your completion report.**

Reference: `@aos-architecture/standards/PRE-FLIGHT-SUBMISSION-CHECKLIST.md`

Copy the checklist into your completion report under the section:
```markdown
## **PRE-FLIGHT VERIFICATION COMPLETED**
```

**Missing or incomplete checklist = Immediate rejection**

---

## 8. Submission

### Commit Message Format
```
fix(traction): add mail.message.subtype read permissions for test users

- Add ACL entry for mail.message.subtype read access
- Fixes 5 test failures in traction.rock and traction.issue tests
- Enables mail.thread mixin to function correctly for all users
- Tests now pass: 76 tests, 0 failed, 0 errors (traction module)

Resolves: TRACTION-003-FIX-01 (Probationary)
```

### Submission Format

**Subject Line:** "TRACTION-003-FIX-01 - PROBATIONARY TASK COMPLETED"

When complete, report with:
1. Mandatory address header: `FROM:CODER_AGENT_C TO:SCRUM_MASTER RE: TRACTION-003-FIX-01`
2. **PRE-FLIGHT VERIFICATION COMPLETED** section (MANDATORY)
3. Confirmation that AC-1 is met (0 failed traction tests)
4. GitHub branch URL (after visual verification on GitHub UI)
5. ACTUAL test results showing: `traction: 76 tests` with `0 failed, 0 error(s)`
6. Confirmation that all 5 previously failing tests now pass
7. Proof that you executed tests from correct branch (not speculated results)

---

## 9. Context Documents

- `TRACTION-003.md` (parent work order)
- `@aos-architecture/standards/PRE-FLIGHT-SUBMISSION-CHECKLIST.md` (MANDATORY)
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- Odoo mail module documentation (for mail.thread, mail.message.subtype)

---

## 10. Technical Constraints

- **Scope:** Fix ACL only. Do NOT modify any model code, views, or tests.
- **Change Size:** Single line addition to `ir.model.access.csv`
- **Testing:** Must verify all 5 previously failing tests now pass

---

## 11. PROBATIONARY STANDARDS

**What "Perfection" Means:**

✅ **Technical:**
- Module loads without errors
- All 5 failing tests now pass
- Test result: 0 failed, 0 error(s) for traction module
- Only the specified file modified

✅ **Process:**
- Correct branch name: `feature/TRACTION-003-FIX-01-mail-acl`
- Branch created from correct base branch
- All verification steps completed
- Pre-flight checklist included and ACCURATE

✅ **Protocol:**
- "Verify Then Report" followed
- Only verified facts in completion report
- No speculation or "expected results"
- Actual test logs provided (not anticipated results)
- Report submitted from correct branch (verified on GitHub)

**Any failure in ANY of these areas = Decommissioning**

---

**This is your opportunity to demonstrate reliable execution. Follow the protocols exactly.**

---

**Authority:** Executive Architect Directive EA-038 (Project Phoenix)  
**Updated:** 2025-10-14 00:00:00 UTC

