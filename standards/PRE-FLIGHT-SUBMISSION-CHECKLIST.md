# Pre-flight Submission Checklist

**MANDATORY FOR ALL WORK ORDER SUBMISSIONS**

This checklist MUST be completed and included in your final completion report. A missing or incomplete checklist is grounds for immediate rejection.

---

## **Pre-Submission Verification Checklist**

Before reporting completion, I have verified the following:

### **Git & Branch Verification**
- [ ] Branch name matches work order ID exactly (e.g., `feature/AGMT-001-CODE-02-description`)
- [ ] All code has been committed to the branch
- [ ] All commits have been pushed to the remote repository
- [ ] I have visually confirmed the branch exists on GitHub UI
- [ ] I have visually confirmed all my files are visible on GitHub UI

### **Test Execution Verification**
- [ ] I executed `bash scripts/run-tests.sh <my_module_name>` command
- [ ] The command completed without script errors
- [ ] I have reviewed the complete test log output
- [ ] The test log shows "0 failed, 0 error(s)"
- [ ] The test log shows tests for MY SPECIFIC module were executed (e.g., "evv_visits: 10 tests")
- [ ] The test count in the log matches the number of tests I wrote

### **Module Load Verification**
- [ ] The test log shows my module loaded without errors
- [ ] No ParseError, ImportError, or AttributeError messages appear for my module
- [ ] All my XML files loaded successfully (if applicable)
- [ ] All my Python files imported successfully

### **Work Order Compliance**
- [ ] I completed ALL deliverables listed in the work order
- [ ] I followed ALL technical constraints specified
- [ ] I stayed within the scope defined in the work order
- [ ] My changes only affect files/modules specified in the work order

### **Proof of Execution**
- [ ] Test log file committed to my branch OR pasted in completion report
- [ ] Commit messages follow the specified format
- [ ] All acceptance criteria from work order are met

---

## **Completion Report Format**

Include this completed checklist in your completion report under a section titled:

```markdown
## **PRE-FLIGHT VERIFICATION COMPLETED**

[X] Branch name matches work order ID exactly
[X] All code committed and pushed to remote
[X] Branch and files confirmed on GitHub UI
[X] Executed: bash scripts/run-tests.sh <module_name>
[X] Test log shows: 0 failed, 0 error(s)
[X] Test log shows MY module's tests executed (module_name: X tests)
[X] Module loaded without errors
[X] All deliverables completed
[X] Work order scope maintained
[X] Proof of execution included
```

---

## **Example: Correct Checklist in Completion Report**

```markdown
## **PRE-FLIGHT VERIFICATION COMPLETED**

[X] Branch name matches work order ID exactly: feature/AGMT-001-CODE-02-views-actions
[X] All code committed and pushed to remote: Confirmed
[X] Branch and files confirmed on GitHub UI: https://github.com/HealthRT/evv/tree/feature/AGMT-001-CODE-02-views-actions
[X] Executed: bash scripts/run-tests.sh evv_agreements
[X] Test log shows: 0 failed, 0 error(s) - See proof_of_execution_tests.log
[X] Test log shows MY module's tests executed: "evv_agreements: 12 tests 0.45s 247 queries"
[X] Module loaded without errors: Confirmed in test log
[X] All deliverables completed: Form view, tree view, search view, 12 tests
[X] Work order scope maintained: Only modified addons/evv_agreements/
[X] Proof of execution included: proof_of_execution_tests.log committed
```

---

## **Enforcement**

**Missing Checklist:** Immediate rejection  
**Incomplete Checklist:** Immediate rejection  
**False Checklist Items:** Grounds for decommissioning

**This is not optional. This is mandatory.**

---

**Effective Date:** 2025-10-13 (Project Phoenix)  
**Authority:** Executive Architect Directive EA-038

