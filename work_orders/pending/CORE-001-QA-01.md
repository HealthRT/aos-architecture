---
title: "[QA] CORE-001-QA-01: QA Validation for CORE-001 (Discrete Person Names)"
repo: "HealthRT/evv"
assignee: "aos-tester-agent"
labels: "agent:tester,module:evv-compliance,priority:high"
---
# Work Order: CORE-001-QA-01 – QA Validation for CORE-001

## 1. Context & Objective

Perform comprehensive QA validation on the implemented CORE-001 feature (`partner_firstname` integration). Verify that discrete name fields (firstname, lastname, middlename) function correctly for Individual contacts, name computation works as specified, and field visibility follows business rules.

**Story:** CORE-001 - Adopt Foundational Module for Discrete Person Names  
**Depends On:** CORE-001-CODE-01 (DONE), SYSTEM-002-CODE-01 (DONE - test runner stable)

---

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** evv  
**GitHub URL:** github.com/HealthRT/evv  
**Target Module:** evv_core  
**Module Prefix:** evv_*

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /home/james/development/aos-development/evv

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/evv.git

# Step 3: Verify WO-CORE-001 is merged
git log --oneline --grep="CORE-001" | head -5

# Step 4: Verify evv_core module exists
ls addons/evv_core
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/evv)
- [ ] Confirmed WO-CORE-001 is merged to main
- [ ] Confirmed `evv_core` module exists
- [ ] Read repository's `README.md` file

### Docker Environment

Use the new resilient test runner (from SYSTEM-002-01):
```bash
bash scripts/run-tests.sh evv_core
```

### Git Workflow

**Base Branch:** main  
**New Branch:** feature/CORE-001-QA-01-validate-core-001

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/CORE-001-QA-01-validate-core-001
```

---

## 3. Problem Statement & Technical Details

### Current State
CORE-001-CODE-01 has integrated `partner_firstname` module into `evv_core`. Implementation needs validation to confirm:
1. Name computation is correct
2. Field visibility follows business rules
3. Existing tests pass
4. No regressions introduced

### QA Scope
Review existing tests, add any missing test coverage, and provide comprehensive validation report.

---

## 4. Required Implementation

### A. Review Existing Tests

**File:** `addons/evv_core/tests/test_core_name_computation.py`

Review existing test implementation from CORE-001-CODE-01. Verify it covers:

1. **Name Computation:**
   - firstname + middlename + lastname → name
   - firstname + lastname (no middlename) → name
   - Edge cases (empty strings, special characters)

2. **Field Visibility:**
   - Individual contacts show firstname/lastname/middlename
   - Company contacts do NOT show firstname/lastname/middlename

3. **Backward Compatibility:**
   - Existing `name` field still works
   - No breaking changes to standard Odoo functionality

### B. Add Missing Test Coverage (If Needed)

If existing tests are insufficient, add tests to cover:

**Test Class:** `TestPartnerNameFieldsQA(TransactionCase)`

```python
@tagged("post_install", "-at_install", "evv_core", "qa_validation")
class TestPartnerNameFieldsQA(TransactionCase):
    """QA validation tests for CORE-001 discrete name fields"""
    
    def test_name_computation_all_fields(self):
        """
        QA Test: Verify name computed from all three fields
        Specification: firstname='John', middlename='Michael', lastname='Doe'
        Expected: name='John Michael Doe'
        """
        partner = self.env['res.partner'].create({
            'is_company': False,  # Individual
            'firstname': 'John',
            'middlename': 'Michael',
            'lastname': 'Doe',
        })
        self.assertEqual(partner.name, 'John Michael Doe')
    
    def test_name_computation_no_middlename(self):
        """
        QA Test: Verify name computed without middlename
        Specification: firstname='Jane', lastname='Smith'
        Expected: name='Jane Smith'
        """
        partner = self.env['res.partner'].create({
            'is_company': False,
            'firstname': 'Jane',
            'lastname': 'Smith',
        })
        self.assertEqual(partner.name, 'Jane Smith')
    
    def test_company_uses_standard_name_field(self):
        """
        QA Test: Verify companies use standard name field (not computed)
        Specification: is_company=True, name='Acme Corp'
        Expected: name='Acme Corp' (not affected by firstname/lastname)
        """
        partner = self.env['res.partner'].create({
            'is_company': True,
            'name': 'Acme Corp',
        })
        self.assertEqual(partner.name, 'Acme Corp')
        # Ensure discrete name fields are not used
        self.assertFalse(partner.firstname)
        self.assertFalse(partner.lastname)
    
    def test_field_visibility_individual(self):
        """
        QA Test: Verify firstname/lastname/middlename visible for individuals
        This tests the UI configuration (can only verify field existence in model)
        """
        partner = self.env['res.partner'].create({
            'is_company': False,
            'firstname': 'Test',
            'lastname': 'User',
        })
        # Verify fields exist and are accessible
        self.assertTrue(hasattr(partner, 'firstname'))
        self.assertTrue(hasattr(partner, 'lastname'))
        self.assertTrue(hasattr(partner, 'middlename'))
    
    def test_backward_compatibility_name_search(self):
        """
        QA Test: Verify existing name search still works
        """
        partner = self.env['res.partner'].create({
            'is_company': False,
            'firstname': 'Alice',
            'lastname': 'Johnson',
        })
        # Search by full name should work
        results = self.env['res.partner'].name_search('Alice Johnson')
        partner_ids = [r[0] for r in results]
        self.assertIn(partner.id, partner_ids)
    
    def test_special_characters_in_names(self):
        """
        QA Test: Verify special characters handled correctly
        """
        partner = self.env['res.partner'].create({
            'is_company': False,
            'firstname': "O'Brien",
            'lastname': 'Smith-Jones',
        })
        self.assertEqual(partner.name, "O'Brien Smith-Jones")
```

### C. Validation Report

Create comprehensive validation report documenting:

**File:** `qa_reports/CORE-001-QA-01-validation-report.md`

```markdown
# QA Validation Report: CORE-001-QA-01 (CORE-001)

**Date:** [DATE]  
**QA Agent:** [AGENT]  
**Work Order:** CORE-001-QA-01  
**Feature Under Test:** CORE-001 - Discrete Person Names

## Test Execution Summary

**Total Tests:** X  
**Passed:** X  
**Failed:** X  
**Coverage:** X%

## Test Results

### 1. Name Computation Tests
- [ ] All three fields (firstname, middlename, lastname) → PASS/FAIL
- [ ] Two fields (firstname, lastname) → PASS/FAIL
- [ ] Edge cases (special characters) → PASS/FAIL

### 2. Field Visibility Tests
- [ ] Individual contacts show discrete name fields → PASS/FAIL
- [ ] Company contacts use standard name field → PASS/FAIL

### 3. Backward Compatibility Tests
- [ ] Name search functionality works → PASS/FAIL
- [ ] Existing Odoo features unaffected → PASS/FAIL

## Issues Found

[List any bugs, regressions, or issues discovered]

## Recommendations

[List any recommendations for improvements or follow-up work]

## Sign-Off

- [ ] All acceptance criteria met
- [ ] No critical issues found
- [ ] Feature approved for production
```

---

## 5. Acceptance Criteria

### QA Validation Requirements

**Test Review:**
- [ ] Existing tests from CORE-001-CODE-01 reviewed
- [ ] Test coverage adequate (≥80%)
- [ ] All existing tests pass (0 failed, 0 errors)

**Additional Testing:**
- [ ] Missing test coverage identified and added
- [ ] QA validation tests written and passing
- [ ] Edge cases covered (special characters, empty fields)

**Validation Report:**
- [ ] Comprehensive validation report created
- [ ] All acceptance criteria from CORE-001.yaml verified
- [ ] Issues documented (if any)
- [ ] Sign-off provided (PASS/FAIL)

**Acceptance Criteria from CORE-001.yaml:**
- [ ] firstname/lastname/middlename visible for Individual contacts
- [ ] Name computed correctly: 'John Michael Doe' format
- [ ] firstname/lastname/middlename NOT visible for Company contacts

**Integration Testing:**
- [ ] Module installs cleanly
- [ ] Module upgrades cleanly
- [ ] No conflicts with other modules
- [ ] Performance acceptable

### Testing Requirements (MANDATORY)

**QA Tests:**
- [ ] All QA validation tests written
- [ ] Tests cover all acceptance criteria
- [ ] Tests include edge cases
- [ ] All tests pass (0 failed, 0 error(s))

**Proof of Execution:**
- [ ] Test output committed showing all tests pass
- [ ] Validation report committed
- [ ] Code committed with descriptive message
- [ ] Proof of execution provided (see Section 9)

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Test Review**
- Review existing tests from WO-CORE-001
- Identify gaps in coverage
- **Checkpoint:** Document findings in notes

**Phase 2: Additional Testing**
- Write any missing QA tests
- Run full test suite
- **Checkpoint:** `git commit -m "test(evv_core): add QA validation tests for CORE-001"`

**Phase 3: Validation & Reporting**
- Create validation report
- Document all findings
- Provide PASS/FAIL sign-off
- **Checkpoint:** `git commit -m "docs(evv_core): add QA validation report for CORE-001"`

**Phase 4: Bug Fixing (If Needed) - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- If issues found, work with development to fix
- Re-run tests
- If tests pass, update report and proceed to Sign-Off
- If tests still fail, proceed to Iteration 2

**Iteration 2:**
- Try **different approach** to resolve issues
- Re-run tests
- If tests pass, update report and proceed to Sign-Off
- If tests still fail, **ESCALATE**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document findings on the GitHub Issue, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

- `@aos-architecture/specs/core/CORE-001.yaml`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)
- `@aos-architecture/standards/TESTING_STRATEGY.md` (MANDATORY)
- `@CORE-001-CODE-01.md` (for implementation context)

---

## 8. Technical Constraints

- **Odoo Version:** All code and XML must be compatible with **Odoo 18.0 Community Edition**
- **Module:** evv_core (with partner_firstname dependency)
- **Test Runner:** Use new resilient test runner from SYSTEM-002-01
- **Change Size:** Keep diff <300 LOC (QA tests + validation report)

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE MARKING COMPLETE.**

### 9.1 Test Execution (REQUIRED)
```bash
# Run all tests for evv_core using resilient test runner
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_core
```

**CRITICAL VERIFICATION CHECKLIST:**

- [ ] **Verify evv_core appears in test output:**
  ```bash
  grep "odoo.tests.stats: evv_core" proof_of_execution_tests.log
  ```
  
- [ ] **Confirm all tests pass:**
  - Total tests: X tests
  - 0 failed, 0 errors
  - Coverage ≥ 80%

**Provide:** Test output showing YOUR tests AND `0 failed, 0 error(s)`.

### 9.2 Boot Verification (REQUIRED)
```bash
cd /home/james/development/aos-development/evv
docker compose up -d
sleep 30
docker compose logs --tail="100" odoo
```
**Provide:** Last 50-100 lines of boot log, confirming clean start.

### 9.3 Module Upgrade Test (REQUIRED)
```bash
docker compose exec odoo odoo-bin -c /etc/odoo/odoo.conf -d odoo -u evv_core --stop-after-init
```
**Provide:** Log output showing successful upgrade with no errors.

### 9.4 Cleanup Verification
```bash
docker ps -a | grep evv-agent-test
# Must be empty
```
**Provide:** Output showing cleanup succeeded.

### 9.5 Validation Report
**Provide:** Complete validation report with PASS/FAIL sign-off.

---

## CRITICAL: First Test with New Tooling

**Executive Architect Note:** This is the first work order executed with the stabilized SYSTEM-002-CODE-01 test runner. Definitive PASS/FAIL report required.

**Success Criteria:**
- ✅ Test runner executes without errors
- ✅ All tests complete successfully
- ✅ Cleanup verification confirms no orphaned resources
- ✅ Validation report provides clear PASS/FAIL determination

**Report to:** @executive-architect with final determination.

