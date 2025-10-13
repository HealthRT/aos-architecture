# Work Order: VISIT-001-FIX-01

**Project:** Agency Operating System (AOS) - EVV Subsystem
**Story:** VISIT-001: Create Core Visit Record
**Type:** `FIX` (Remediation)

---

## 1. Objective

**CRITICAL: Remediate the fundamental data model failure of `VISIT-001-CODE-01`.**

The previous implementation **invented a custom, non-standard way to identify staff** by linking to `res.partner` with a category tag. This is a direct violation of Odoo's core architecture.

Your objective is to refactor the `evv.visit` model to correctly and exclusively use Odoo's standard `hr.employee` model for all staff-related links.

**THIS IS A NON-NEGOTIABLE ARCHITECTURAL REQUIREMENT.**

---

## 2. Context & Failure Analysis

**Previous Work Order:** `VISIT-001-CODE-01`
**Status:** **REJECTED / FAILED**

**Critical Failures:**
1.  **Incorrect Staff Model:** The `dsp_id` field incorrectly linked to `res.partner`. All staff, employees, and caregivers in Odoo MUST be represented by the `hr.employee` model.
2.  **Missing Dependency:** The `__manifest__.py` file failed to declare a dependency on the core `hr` module, which is the source of the `hr.employee` model.

**Your task is to correct this fundamental architectural flaw.**

---

## 3. Detailed Requirements

### 3.1. `__manifest__.py`
-   Add `'hr'` to the `depends` list.

### 3.2. `models/evv_visit.py`
-   **`dsp_id` field:**
    -   Change the `comodel_name` from `res.partner` to `hr.employee`.
    -   Remove the `domain` attribute. It is no longer needed.
    -   Update the `string` to "Employee (DSP)" to be more accurate.
-   **`dsp_name` field:**
    -   This `related` field should now point to `dsp_id.name`. This will still work correctly as `hr.employee` has a `name` field.

### 3.3. Tests
-   Update `tests/test_evv_visit.py` to use the correct models.
-   In your `setUp` method, you must now create an `hr.employee` record for the test DSP.
    ```python
    # Example for your setUp method in the test file
    self.dsp_employee = self.env['hr.employee'].create({
        'name': 'John Doe DSP',
        # Add any other required fields for hr.employee
    })
    ```
-   Update all `create` calls for `evv.visit` to pass `self.dsp_employee.id` to the `dsp_id` field.
-   Ensure all tests pass after this significant refactoring.

---

## 4. CRITICAL: IMMUTABLE TOOLING

**DO NOT MODIFY THE TEST RUNNER SCRIPT:** `scripts/run-tests.sh`.

This script is centrally managed by the Executive Architect. Any unauthorized modification will result in immediate work rejection. If the script fails, escalate immediately.

---

## 5. Acceptance Criteria

-   **AC-1:** The `__manifest__.py` file MUST include `'hr'` as a dependency.
-   **AC-2:** The `evv.visit` model's `dsp_id` field MUST be a `Many2one` to `hr.employee`.
-   **AC-3:** All unit tests MUST be updated to use `hr.employee` for the DSP record and must pass.
-   **AC-4:** The module must install cleanly (after adding the `hr` dependency) and all tests must pass when executed with `bash scripts/run-tests.sh evv_visits`.

---

## 6. Submission

Follow the standard submission process: commit your code, commit the proof of execution log, and submit your completion report.
