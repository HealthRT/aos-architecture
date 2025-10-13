---
title: "[FIX] TRACTION-001-FIX-01: Create Missing Traction Security Groups"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,type:bug,module:hub-traction,priority:critical"
---
# Work Order: TRACTION-001-FIX-01 – Create Missing Traction Security Groups

## 1. Context & Objective

**CRITICAL SECURITY FAILURE REMEDIATION:** The `traction` module created in TRACTION-001, 002, and 003 references security groups (`group_facilitator`, `group_leadership`) in `ir.model.access.csv` that were never created. This makes the module **un-installable** and will crash the Odoo server. This work order corrects that failure.

**Root Cause:** The agent implemented high-quality model code but failed to create the `security/groups.xml` file that defines the security groups referenced in the ACL file. This is the same failure pattern that occurred in `PT-001-CODE-01`.

**This is a LEARNING OPPORTUNITY:** You must close this gap in your file dependency understanding.

---

## Work Order Reference

**Full Work Order:** `@aos-architecture/work_orders/hub/TRACTION-001-FIX-01.md`

**Please read the full work order file for complete implementation details, acceptance criteria, and proof of execution requirements.**

---

## Quick Summary

**What You Must Do:**
1. Create `hub/addons/traction/security/groups.xml` with the two missing security groups:
   - `traction.group_facilitator`
   - `traction.group_leadership`
2. Update `hub/addons/traction/__manifest__.py` to load `security/groups.xml` **before** `security/ir.model.access.csv`.
3. Run the test suite and confirm all 76+ tests still pass.
4. Verify the module installs cleanly without errors.

**Branch:** `feature/TRACTION-001-FIX-01-security-groups`

**Base Branch:** The branch where TRACTION-003 was completed (find with `git branch --list "feature/TRACTION-*" --sort=-committerdate | head -1`)

---

## Proof of Execution Required

**Test Execution:**
```bash
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
```

**Verification:**
- [ ] All 76+ tests pass with 0 failures
- [ ] `proof_of_execution_tests.log` created and shows clean installation
- [ ] Docker cleanup verified (`docker ps -a | grep hub-agent-test` returns empty)
- [ ] Manifest load order verified (`security/groups.xml` before `ir.model.access.csv`)

---

## Learning Objective

**Pattern to Internalize:**
```
IF writing ir.model.access.csv
  AND it references custom groups (not base.group_*)
  THEN you MUST create security/groups.xml first
  AND load it in the manifest before ir.model.access.csv
```

**You have made this mistake twice now (PT-001, TRACTION-001/002/003). This is your opportunity to close this gap permanently.**

---

## Related Work Orders

- **PT-001-FIX-01:** Example of the same failure and how it was fixed (review this!)
- **TRACTION-001, 002, 003:** The work orders that contained this failure

---

## Escalation

If you encounter blockers after 2 iterations, apply the `status:needs-help` label and tag `@james-healthrt` with a detailed explanation of your attempts.

---

**Priority:** CRITICAL - Blocking all TRACTION work  
**Estimated Time:** 1-2 hours  
**Created By:** @scrum-master  
**Incident Reference:** Process Improvement Entry #018

