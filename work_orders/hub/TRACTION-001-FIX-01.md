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

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** hub  
**GitHub URL:** github.com/HealthRT/hub  
**Target Module:** traction  
**Module Prefix:** traction*

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /home/james/development/aos-development/hub

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/hub.git

# Step 3: Verify Docker environment exists
ls docker-compose.yml
# Must exist in repository root

# Step 4: Verify module exists
ls addons/traction
# Should show existing module directory
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/hub)
- [ ] Confirmed `docker-compose.yml` exists in repository root
- [ ] Confirmed `traction` module exists in `addons/`
- [ ] Read repository's `README.md` file

### Docker Environment

**Database:** postgres

### Git Workflow

**Base Branch:** The branch where TRACTION-003 was completed (likely `feature/TRACTION-003-rock-model` or similar)  
**New Branch:** `feature/TRACTION-001-FIX-01-security-groups`

**Branch Naming Convention (ADR-014):**
```
feature/{STORY_ID}-{TYPE}-{SEQUENCE}-{short-description}
```

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
# Find the most recent TRACTION branch
git branch --list "feature/TRACTION-*" --sort=-committerdate | head -1
# Checkout that branch as your base
git checkout [base-branch-name]
git checkout -b feature/TRACTION-001-FIX-01-security-groups
```

---

## 3. Problem Statement & Technical Details

### MISSING FILE: `hub/addons/traction/security/groups.xml`

**Current State:** This file does not exist.

**Problem:** The `ir.model.access.csv` file references two security groups:
- `traction.group_facilitator`
- `traction.group_leadership`

These groups are never created, which causes Odoo to fail during module installation with an error like:
```
ValueError: External ID not found in the system: traction.group_facilitator
```

### `hub/addons/traction/security/ir.model.access.csv`

**Current State:** This file already exists and references the missing groups.

**Issue:** The groups must exist before the ACL file is loaded.

### `hub/addons/traction/__manifest__.py`

**Current State:** The manifest likely loads files in this order:
```python
'data': [
    'security/ir.model.access.csv',
    # other files...
],
```

**Issue:** The manifest must load `security/groups.xml` **before** `security/ir.model.access.csv`.

---

## 4. Required Implementation

### 4.1 Create `hub/addons/traction/security/groups.xml`

**You MUST create this file with the following content:**

```xml
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <!-- Traction Security Groups (TRACTION-ITEMS-CORE) -->
    
    <record id="module_category_traction" model="ir.module.category">
        <field name="name">Traction/EOS</field>
        <field name="description">Security groups for Traction/EOS functionality</field>
        <field name="sequence">20</field>
    </record>

    <record id="group_facilitator" model="res.groups">
        <field name="name">Facilitator</field>
        <field name="category_id" ref="module_category_traction"/>
        <field name="comment">Can manage Traction items (Issues, Rocks, To-Dos, Scorecards) and facilitate Level 10 meetings.</field>
    </record>

    <record id="group_leadership" model="res.groups">
        <field name="name">Leadership</field>
        <field name="category_id" ref="module_category_traction"/>
        <field name="comment">Leadership team members with full visibility across all Traction groups and items.</field>
    </record>

</odoo>
```

**Critical Details:**
- The XML IDs (`group_facilitator`, `group_leadership`) must match exactly what is referenced in `ir.model.access.csv`.
- The category helps organize these groups in the Odoo UI under Settings > Users & Companies > Groups.
- The comments document the purpose of each group.

### 4.2 Update `hub/addons/traction/__manifest__.py`

**You MUST update the manifest to load the security files in the correct order:**

```python
'data': [
    'security/groups.xml',           # MUST BE FIRST - defines the groups
    'security/ir.model.access.csv',  # THEN load ACLs that reference those groups
    # ... other data files in their existing order ...
],
```

**Critical Rule:** Security groups must be defined before they are referenced.

### 4.3 Verification Strategy

After making these changes, you MUST verify:

1. **Clean Install Test:** The module must install without errors.
2. **Security Groups Visible:** The groups must appear in Settings > Users & Companies > Groups.
3. **All Tests Pass:** The existing 76 tests must still pass (or more, if you added new tests).
4. **No Tracebacks:** The boot log must show no errors related to security groups.

---

## 5. Acceptance Criteria

⚠️ **CRITICAL WARNING - READ THIS FIRST** ⚠️

**Testing is NEVER optional for ANY work order involving code changes.**

---

### Functional Requirements
- [ ] `security/groups.xml` file created with correct XML IDs and structure.
- [ ] Manifest updated to load `security/groups.xml` before `ir.model.access.csv`.
- [ ] Module installs cleanly without errors.
- [ ] Security groups appear in Odoo UI under Settings > Users & Companies > Groups.

### Testing Requirements (MANDATORY)

**Unit Tests:**
- [ ] All existing tests still pass (minimum 76 tests from TRACTION-001, 002, 003).
- [ ] If you write new tests for security group creation, they must pass.
- [ ] All unit tests pass (`0 failed, 0 error(s)`).

**Integration Validation:**
- [ ] Clean install test confirms module loads without errors.
- [ ] Boot log shows no tracebacks related to security groups.
- [ ] ACL file loads successfully after groups are defined.

**Proof of Execution:**
- [ ] Test output showing all tests pass.
- [ ] Boot log showing clean module installation.
- [ ] Code committed with descriptive message.
- [ ] Proof of execution provided (see Section 9).

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Create `security/groups.xml`.
- Update manifest file order.
- **Checkpoint:** Commit your changes. `git commit -m "fix(traction): add missing security groups definition"`

**Phase 2: Testing**
- Run the test suite using `run-tests.sh`.
- **Checkpoint:** If tests pass, proceed to Proof of Execution.

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- If tests fail, analyze the error, fix it, and rerun tests.
- If tests pass, proceed to Proof of Execution.
- If tests still fail, commit your attempt and proceed to Iteration 2.

**Iteration 2:**
- Try a **different approach**. Run tests.
- If tests pass, proceed to Proof of Execution.
- If tests still fail, **STOP and ESCALATE.**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document your attempts on the GitHub Issue, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

**MANDATORY READING:**
- `@aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml` (security model)
- `@aos-architecture/standards/01-odoo-coding-standards.md` (XML formatting)
- `@aos-architecture/standards/08-testing-requirements.md` (testing standards)
- `@aos-architecture/work_orders/hub/TRACTION-001.md` (original work order that should have created this)
- `@aos-architecture/work_orders/pending/PT-001-FIX-01.md` (example of the same failure and how it was fixed)

**CRITICAL LEARNING:**
Review `PT-001-FIX-01` to understand the same mistake you made there and how it was corrected. You must internalize the pattern: **ACL files reference groups → groups must be defined first → manifest must load groups.xml before ir.model.access.csv.**

---

## 8. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**.
- **XML Formatting:** Follow Odoo's standard XML indentation (4 spaces).
- **Security Group Naming:** Use clear, descriptive names that match the business domain (Facilitator, Leadership).
- **Module Category:** Security groups must be organized under a logical category for UI navigation.

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CLAIMING COMPLETION.**

### 9.1 Test Execution (REQUIRED)
```bash
# From within the hub repository directory
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
```

**CRITICAL VERIFICATION CHECKLIST:**
- [ ] Tests executed successfully
- [ ] Verify `proof_of_execution_tests.log` created
- [ ] **Confirm all 76+ tests pass with 0 failures**
- [ ] **VERIFY CLEANUP:** Run `docker ps -a | grep hub-agent-test` → Must be empty

### 9.2 Security Groups Verification (REQUIRED)

After tests pass, you MUST verify the groups were created. Add this to your proof of execution:

```bash
# Manually start Odoo (optional, for visual confirmation)
# Or check the test logs for group creation messages
grep "group_facilitator" proof_of_execution_tests.log
grep "group_leadership" proof_of_execution_tests.log
```

**Expected:** Both groups should appear in the logs during module installation.

### 9.3 Manifest Load Order Verification (REQUIRED)

Verify the manifest loads files in the correct order:

```bash
cat addons/traction/__manifest__.py | grep -A 10 "'data'"
```

**Expected Output:**
```python
'data': [
    'security/groups.xml',
    'security/ir.model.access.csv',
    # ... other files ...
],
```

---

## 10. Post-Completion Self-Assessment

**BEFORE you claim this work order is complete, answer these questions:**

1. ✅ Did you create the `security/groups.xml` file with the correct XML IDs?
2. ✅ Did you update the manifest to load `groups.xml` before `ir.model.access.csv`?
3. ✅ Did all 76+ tests pass with 0 failures?
4. ✅ Did you verify that the module installs cleanly without errors?
5. ✅ Did you understand **why** this failure happened and how to prevent it in the future?

**If you answered NO to any of these, DO NOT claim completion. Escalate immediately.**

---

## 11. Learning Objective

**Why This Work Order Exists:**

This is not just a bug fix. This is a critical learning moment. You have now made the **same mistake twice** (PT-001 and TRACTION-001/002/003):

1. You wrote ACL files that reference security groups.
2. You forgot to create the security groups.
3. The module became un-installable.

**The Pattern You MUST Internalize:**

```
IF writing ir.model.access.csv
  AND it references custom groups (not base.group_*)
  THEN you MUST create security/groups.xml first
  AND load it in the manifest before ir.model.access.csv
```

**This is your opportunity to close this gap in your understanding.** The Executive Architect is giving you this work order to force you to confront and correct your blind spot.

**After completing this work order, you should be able to:**
- Recognize when an ACL file requires a corresponding groups.xml file.
- Understand the dependency between security group definitions and ACL references.
- Always verify manifest load order for security files.
- Validate that your module can actually be installed (not just that tests "pass" in isolation).

**If you do not learn from this, you will make the same mistake a third time, and the consequences will be severe.**

---

## 12. Final Notes

**This is a HIGH-PRIORITY CRITICAL work order.** All other TRACTION work is BLOCKED until this is complete.

**You are expected to complete this work order quickly** (1-2 hours maximum). This is not a complex implementation; it's a simple file creation and manifest update.

**The Executive Architect will review this work personally.** Do not submit this until you are confident it meets every criterion.

**If you have ANY questions, ask them immediately on the GitHub Issue.** Do not guess. Do not assume. Ask.

---

**Work Order Created By:** @scrum-master  
**Incident Reference:** Process Improvement Entry #018 (TRACTION-001/002/003 Security Failure)  
**Related Failures:** PT-001-CODE-01 (same root cause)  
**Priority:** CRITICAL - Blocking all TRACTION work  
**Estimated Time:** 1-2 hours

