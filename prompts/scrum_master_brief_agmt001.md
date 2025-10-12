# Scrum Master Agent Brief: Regenerate AGMT-001 Work Orders

**Date:** 2025-10-11  
**Assigned To:** Scrum Master Agent (`aos-scrum-master`)  
**Priority:** High  
**Context:** First production run - Updated spec with complete field schema

---

## Your Task

Regenerate all work orders for Story AGMT-001 based on the **updated specification**. The previous work orders were created from an incomplete spec and must be replaced.

---

## Input Document

**Primary Source:** `@aos-architecture/specs/evv/AGMT-001.yaml`

**Important:** The spec has been significantly updated since the original work orders were created. Key changes:

### **Changes from Original Spec:**

1. **Field count increased:** 5 fields → 28 fields (complete schema matching real-world Service Agreement)

2. **New model added:** `res.partner` extensions for contact organization
   - Added: `is_patient`, `is_case_manager` (boolean flags)
   - Added: `recipient_id_external`, `case_manager_external_id` (external IDs)

3. **Case manager implementation changed:**
   - **Was:** Three text fields (`case_manager_name`, `case_manager_phone`, `case_manager_id`)
   - **Now:** One Many2one relationship field (`case_manager_id` → `res.partner`)

4. **Comprehensive validation rules:** 12 business rules documented in spec

5. **Extensive acceptance criteria:** 22 test scenarios defined

---

## Critical Reminders (From Process Improvement)

### **Testing Requirements (MANDATORY)**

Per Process Improvement Entry #005 and your updated onboarding primer:

**EVERY work order MUST include:**

```markdown
### Testing Requirements (MANDATORY)
- [ ] Unit tests written for all new/modified methods
- [ ] Edge cases tested (empty recordsets, null values, validation failures)
- [ ] Security considerations tested (if applicable)
- [ ] All tests pass (0 failed, 0 errors)
```

**NEVER use phrases like:**
- ❌ "tests optional"
- ❌ "tests can be added later"
- ❌ "bootstrap work doesn't need tests"

### **Context Documents Required**

Every work order MUST list in Section 7:
- `@aos-architecture/standards/08-testing-requirements.md` (MANDATORY)
- `@aos-architecture/specs/evv/AGMT-001.yaml` (primary spec)
- Any relevant ADRs

---

## Expected Deliverables

Generate **4 work orders** (or adjust count based on logical decomposition):

### **Suggested Breakdown:**

**WO-AGMT-001-01:** Bootstrap Module & res.partner Extensions
- Create `evv_agreements` module scaffold
- Extend `res.partner` with classification fields
- Create security groups/rules
- Write tests for res.partner extensions

**WO-AGMT-001-02:** service.agreement Model (Core Fields)
- Implement model with all 28 fields
- Implement computed methods (_compute_start_date, _compute_end_date, _compute_total_amount)
- Implement constraints (date range, positive units)
- Write comprehensive unit tests (all 22 acceptance criteria)

**WO-AGMT-001-03:** service.agreement Business Logic
- Implement action_activate method with validation
- Implement action_cancel method
- Write unit tests for state transitions
- Write tests for validation rules

**WO-AGMT-001-04:** User Interface Views
- Create form view with collapsible groups (per UI mockup)
- Create tree/list view
- Create search view with filters (by patient, case manager, state, procedure code)
- Create menu items and actions
- Test UI responsiveness and field visibility

**Note:** You may adjust this breakdown if a different decomposition is more logical. The key is ensuring each work order is:
- Appropriately sized (< 500 lines of changes)
- Has clear acceptance criteria
- Includes comprehensive testing requirements
- Can be completed independently (or dependencies are clearly documented)

---

## Work Order Template Requirements

Use the official `@aos-architecture/templates/work_order_template.md` and fill in **ALL 9 sections:**

1. Context & Objective
2. Repository Setup (branch naming, git commands)
3. Problem Statement & Technical Details (specific file paths, code snippets from spec)
4. Required Implementation (detailed technical specification)
5. **Acceptance Criteria (including MANDATORY testing requirements)**
6. Context Management & Iteration Limits (2-iteration rule)
7. Required Context Documents
8. Technical Constraints (Odoo 18 Community)
9. **MANDATORY Proof of Execution** (test output, boot logs, upgrade logs)

---

## Target Repository

**Repository:** `evv`  
**Base Branch:** `main`  
**Branch Naming Pattern:** `feature/WO-AGMT-001-0X-description`

---

## Output Location

Place completed work order files in:
`@aos-architecture/work_orders/pending/`

**Filename pattern:** `WO-AGMT-001-0X.md` (e.g., `WO-AGMT-001-01.md`)

---

## Quality Checklist

Before submitting, verify each work order has:

- [ ] All 9 template sections completed
- [ ] Specific file paths and code examples from spec
- [ ] Clear, testable acceptance criteria
- [ ] **MANDATORY testing requirements section**
- [ ] Reference to `08-testing-requirements.md`
- [ ] Git checkpoint strategy documented
- [ ] 2-iteration limit and escalation process explained
- [ ] Complete "Proof of Execution" commands provided
- [ ] No phrases like "tests optional" anywhere

---

## Success Criteria

Your work orders will be considered complete when:

1. ✅ All fields from updated spec are included
2. ✅ res.partner extensions are properly specified
3. ✅ case_manager_id is Many2one (not text fields)
4. ✅ All 22 acceptance criteria are testable
5. ✅ Comprehensive testing requirements in every work order
6. ✅ Coder Agent can execute without clarification questions

---

## Questions?

If you have questions about the spec or need clarification:
1. Review the spec's "Business Logic & Validation" section (12 rules)
2. Review the "Acceptance Criteria" section (22 scenarios)
3. Consult `@aos-architecture/standards/01-odoo-coding-standards.md`
4. If still unclear, add a note in the work order for human review

---

## Timeline

**Target Completion:** ASAP (first production run)

---

**Ready? Begin generation!**

**Confirm when complete by listing the work order files created.**

