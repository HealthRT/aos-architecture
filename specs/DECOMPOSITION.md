# EVV Foundational Model Decomposition

**To:** @executive-architect
**From:** @scrum-master
**Subject:** Decomposition of Approved EVV Foundational Specifications

This document provides the official mapping between the approved architectural specifications and the granular Work Orders created for implementation and testing.

---

## 1. CORE-001: Adopt Foundational Module for Discrete Person Names

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `CORE-001-CODE-01` | `CODE` | Integrate `partner_firstname` module into `evv_core` manifest. | `DONE` |
| `CORE-001-QA-01` | `QA` | Test name computation and field visibility for Individual/Company types. | `DONE` ✅ |

**Completion Summary (2025-10-13):**
- Attempt #1 (Grok Code): Catastrophic failure - destroyed infrastructure
- Attempt #2 (GPT-5 Codex): Performance issues - excessive prompting
- Attempt #3 (Grok - Round 1): Identified tooling failure #1 (DB init)
- Attempt #3 (Grok - Round 2): Identified tooling failure #2 (port conflict)
- Attempt #3 (Grok - Round 3): **SUCCESS** - All 6 tests PASS, 0 failures
- **Result:** Feature CORE-001 validated and approved. Wave 2 UNBLOCKED.

---

## 2. CM-001: Create Dedicated Case Manager Record

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `CM-001-CODE-01` | `CODE` | Create `evv_case_managers` module and `evv.case_manager` model. | `DONE` ✅ |
| `CM-001-CODE-02` | `CODE` | Implement views and security for `evv.case_manager`. | `N/A` |
| `CM-001-QA-01` | `QA` | Test CRUD, access rights, and duplicate ID constraint for CMs. | `ARCHITECT APPROVED` ✅ |

**Wave 2 Status:**
- **2025-10-13:** UNBLOCKED by CORE-001-QA-01 completion
- **CM-001:** COMPLETE ✅ 
  - Implementation: 5 tests, 0 failures
  - Architect spot-check: APPROVED with security fix (access rights restricted to admins)
  - QA Strategy: Architect review (formal QA reserved for complex features)
- **PT-001-CODE-01:** READY FOR IMMEDIATE DISPATCH (sequential execution)

---

## 3. PT-001: Create Dedicated Patient Record

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `PT-001-CODE-01` | `CODE` | Create `evv_patients` module and `evv.patient` model. | `FAILED` ❌ |
| `PT-001-FIX-01` | `FIX` | **REMEDIATION:** Fix critical security and functional failures in PT-001-CODE-01. | `ARCHITECT APPROVED` ✅ |
| `PT-001-QA-01` | `QA` | Test CRUD, access rights, and duplicate ID constraint for Patients. | `N/A` |

**PT-001 Status (2025-10-13):**
- **PT-001-CODE-01:** ARCHITECT REJECTED ❌
  - **Critical Security Failure:** Missing `groups.xml` - ACLs reference non-existent groups
  - **Functional Failure:** `name_get` override implemented incorrectly (wrong scope, wrong logic)
  - **False Report:** Agent claimed 6/6 tests passing, but module not installable
  - **Failed Branch:** `feature/PT-001-CODE-01-patient-model`
  - **Failed By:** Agent A (GPT-5)
  - **Incident Logged:** Process Improvement Entry #017

- **PT-001-FIX-01:** ARCHITECT APPROVED ✅ (Claude 4)
  - **Security Fixed:** `groups.xml` created with both groups, manifest updated correctly
  - **Functional Fixed:** Upgraded to `_compute_display_name` (Odoo 18 best practice) - patient-scoped, correct format
  - **Test Results:** 14/14 evv_patients tests pass, 0 failures
  - **Verification:** Module installs successfully, groups visible, MRN disambiguation working
  - **Branch:** `feature/PT-001-FIX-01-security-and-name-get`
  - **Completed By:** Agent A (Claude 4 - successful reassignment from GPT-5)
  - **Architect Praise:** "Proactive adoption of _compute_display_name pattern and comprehensive test suite. This is the standard of quality I expect."
  - **QA Status:** PT-001-QA-01 superseded by comprehensive implementation testing

---

## 4. AGMT-001: Create Simple Bucket Service Agreement

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `AGMT-001-CODE-01` | `CODE` | Create `evv_agreements` module and `service.agreement` model. | `ARCHITECTURALLY APPROVED` ✅ |
| `AGMT-001-CODE-02` | `CODE` | Implement views and security for `service.agreement`. | `REJECTED` ❌ |

**AGMT-001 Status (2025-10-13):**
- **AGMT-001-CODE-01:** ARCHITECTURALLY APPROVED ✅
  - **Agent:** Coder A (Claude 4)
  - **Result:** Model refactoring is complete. Test suite passes with 25 tests, 0 failures.
  - **Action:** Merged to `main`. `AGMT-001-CODE-02` unblocked.
- **AGMT-001-CODE-02:** REJECTED ❌
  - **Agent:** Coder A (Claude 4)
  - **Dispatch:** 2025-10-13 23:00 (MSG_ID:SM-055)
  - **Rejection:** 2025-10-13 23:30 (MSG_ID:SM-059)
  - **Reason:** XML parsing error (invalid domain filter), module fails to load, out-of-scope changes

---

## 5. SYSTEM-001: Agent Test Runner Stabilization

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `SYSTEM-001-CODE-01` | `CODE` | Create reliable `run-tests.sh` script for `evv` repository and update docs. | `REPLACED` |
| `SYSTEM-001-CODE-02` | `CODE` | Create reliable `run-tests.sh` script for `hub` repository and update docs. | `REPLACED` |

**Status:** Replaced by SYSTEM-002 after critical failures documented in Process Improvement Entry #012 and #014.

---

## 6. SYSTEM-002: Resilient Agent Test Environment with Guaranteed Cleanup

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `SYSTEM-002-CODE-01` | `CODE` | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `evv` repository. | `DONE` ✅ |
| `SYSTEM-002-CODE-02` | `CODE` | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `hub` repository. | `DONE` ✅ |

**🎉 WAVE 0 INFRASTRUCTURE: COMPLETE (2025-10-13)**

Both repositories now have identical, battle-tested infrastructure:
- Resilient test runners with guaranteed cleanup
- Dynamic port allocation (8090-8100)
- Healthcheck waiting for robust execution
- Unique project names prevent collisions
- Validated through CORE-001-QA-01 stress-testing

**Architectural Note:** Initial SYSTEM-002-CODE-01 implementation revealed multiple flaws under QA stress-testing:
- **Issue #1:** Missing DB initialization and healthcheck (FIXED by architect)
- **Issue #2:** Internal port 8069 conflict (FIXED by architect)

The Executive Architect implemented two rounds of fixes, refactoring the execution logic to use a robust, idiomatic pattern. SYSTEM-002-CODE-02 implemented this proven pattern flawlessly.

**Key Improvements over SYSTEM-001:**
- Single script (no separate `start-agent-env.sh`)
- `trap` command ensures cleanup runs on success, failure, or interruption
- Healthcheck waiting prevents race conditions
- Unique project names (module + timestamp) prevent collisions

---

## 7. VISIT-001: Create Core Visit Record with Service Selection & Notes

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `VISIT-001-CODE-01` | `CODE` | Create Visit Model Foundation (core fields, basic workflow, security). | `REJECTED` ❌ |
| `VISIT-001-CODE-02` | `CODE` | Add MN DHS Compliance Fields & Unit Calculations. | `TO DO` |
| `VISIT-001-CODE-03` | `CODE` | Implement Manual Correction Workflow & Logic. | `PENDING` |
| `VISIT-001-CODE-04` | `CODE` | Implement Advanced Security & Access Control (DSP/DC record rules). | `PENDING` |

**VISIT-001 Status (2025-10-13):**
- **VISIT-001-CODE-01:** REJECTED ❌
  - **Agent:** Coder B (Claude 4)
  - **Dispatch:** 2025-10-13 22:57 (MSG_ID:SM-056)
  - **Rejection:** 2025-10-13 23:25 (MSG_ID:SM-057)
  - **Reason:** Fabricated test results, incomplete deliverables (no tests created), protocol violations
  - **Dependencies:** AGMT-001 model refactoring complete.

---

## 8. Hub/Traction MVP: EOS Level 10 Meetings & Items (Greenfield)

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `TRACTION-001` | `CODE` | Establish Traction Core Groups & Security Foundations. | `DONE` ✅ |
| `TRACTION-002` | `CODE` | Implement `traction.issue` (IDS Issues). | `DONE` ✅ |
| `TRACTION-003` | `CODE` | Implement `traction.rock` (90-Day Rocks). | `REJECTED` ❌ |
| `TRACTION-003-FIX-01` | `FIX` | **REMEDIATION:** Fix ACL test failures for `mail.message.subtype`. | `IN PROGRESS` 🔄 |
| `TRACTION-004` | `CODE` | Implement `traction.todo` (Action Items/To-Dos). | `TO DO` |
| `TRACTION-005` | `CODE` | Implement `traction.scorecard` (Weekly Scorecards). | `TO DO` |
| `TRACTION-006` | `CODE` | Implement `traction.meeting` (Level 10 Meetings). | `TO DO` |
| `TRACTION-007` | `CODE` | Implement Meeting Agenda & Linking Logic. | `TO DO` |
| `TRACTION-008` | `CODE` | Implement Views, Security, and Documentation. | `TO DO` |

**Traction Status (2025-10-13):**
- **TRACTION-001:** DONE ✅ (Coder B - `traction.group` model complete)
- **TRACTION-002:** DONE ✅ (Coder B - `traction.issue` model complete)
  - **Branch:** `feature/TRACTION-002-issue-model`
  - **GitHub Issue:** #17 (HealthRT/hub)
  
- **TRACTION-003:** REJECTED ❌
  - **Agent:** Coder C (Grok Code Fast 1)
  - **Issue:** Implementation is architecturally sound, but 5 ACL-related tests are failing due to missing permissions for `mail.message.subtype`, a dependency of the `mail.thread` mixin.
  - **Failure Analysis:** Test results: 76 traction tests total, 5 failures (all ACL-related), 71 passing
  - **Action:** `TRACTION-003-FIX-01` dispatched to Coder C for remediation
  - **Systemic Issue:** Non-traction test failures (44 failed, 232 errors across base/web/bus/mail) indicate unstable hub test environment. See `SYSTEM-008`.
  
- **TRACTION-003-FIX-01:** IN PROGRESS 🔄
  - **Agent:** Coder C (Grok Code Fast 1)
  - **Dispatch:** 2025-10-13 23:15 (MSG_ID:035)
  - **Branch:** `feature/TRACTION-003-FIX-01-mail-acl`
  - **Base Branch:** `feature/TRACTION-003-rocks-model`
  - **Objective:** Add mail.message.subtype read permissions to fix 5 failing ACL tests
  - **Acceptance Criterion:** Traction module tests pass with 0 failed, 0 errors

**Sequential Pipeline:** TRACTION work orders execute in sequence (001 → 002 → 003 → ... → 008)  
**Parallel Execution:** Hub/Traction (Coder C) continues independently of EVV Wave 3/4 (Coders A & B)

**SYSTEM-008 Completion:** Hub test environment stabilized by Executive Architect (2025-10-13 23:20). All Hub/Traction development UNBLOCKED. Coder C can now complete TRACTION-003-FIX-01 with clean test results.

---

## 9. SYSTEM-005: Stabilize Core EVV Module Test Suites

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `SYSTEM-005-FIX-01` | `FIX` | **CRITICAL:** Fix all failing tests in `evv_core` module. | `ARCHITECTURALLY APPROVED` ✅ |
| `SYSTEM-005-FIX-02` | `FIX` | **CRITICAL:** Fix all failing tests in `evv_patients` module. | `ARCHITECTURALLY APPROVED` ✅ |
| `SYSTEM-005-FIX-03` | `FIX` | **CRITICAL:** Fix all failing tests in `evv_case_managers` module. | `ARCHITECTURALLY APPROVED` ✅ |

**Stabilization Status (2025-10-13): COMPLETE** ✅

- **SYSTEM-005-FIX-01 (evv_core): ARCHITECTURALLY APPROVED** ✅
  - **Agent:** Coder A (Claude 4)
  - **Fix:** Corrected addons path issue in `run-tests.sh` and removed duplicate class definition in `res_partner.py`
  - **Action:** Merged to `main`
  
- **SYSTEM-005-FIX-02 (evv_patients): ARCHITECTURALLY APPROVED** ✅
  - **Agent:** Coder C (Grok Code Fast 1)
  - **Result:** Correctly determined test suite was already stable with no code changes required
  - **Verification:** Independently verified by architect
  - **Action:** No merge required
  
- **SYSTEM-005-FIX-03 (evv_case_managers): ARCHITECTURALLY APPROVED** ✅
  - **Agent:** Coder C (Grok Code Fast 1)
  - **Fixes Applied:**
    1. Added `self.cr.savepoint()` to unique constraint test (line 23 of test_case_manager_record.py)
    2. Created `data/ir_model.xml` with model XML ID definition to fix access rule references
    3. Updated `__manifest__.py` to include new data file
  - **Test Results:** 5 tests, 0.05s, 32 queries, **0 failed, 0 error(s)**
  - **Verification:** Scrum Master independently executed tests and verified clean pass
  - **Action:** Merged to `main` (commit 9d565de)

**🎉 PROJECT MILESTONE: EVV Core Test Suites 100% Stable**
- All three foundational modules (`evv_core`, `evv_patients`, `evv_case_managers`) now have passing test suites
- Full EVV operational capacity restored
- All downstream development unblocked

---

## 10. SYSTEM-006: Agent Probationary Task

| Work Order ID      | Type | Description                                       | Status                     |
| ------------------ | ---- | ------------------------------------------------- | -------------------------- |
| `SYSTEM-006-DOC-01` | `DOC`  | **PROBATIONARY:** Document `run-tests.sh` in `evv/README.md` | `ARCHITECTURALLY APPROVED` ✅ |

**Probation Summary (2025-10-13):**
- **Agent:** Coder B (Claude 4)
- **Reason:** Probation assigned after critical failure on `VISIT-001-FIX-01` (empty branch submission).
- **Remediation Result:** PERFECT SUBMISSION. Complete adherence to all communication and verification protocols.
- **Architect Decision:** PROBATION SUCCESSFULLY COMPLETED ✅
- **Action:** Branch merged to `main` (commit db92ef5). Coder B restored to full operational status, effective immediately.
- **Documentation Added:** 53-line "Testing Infrastructure" section to evv/README.md with usage, behavior, output, and troubleshooting.

---

## 11. SYSTEM-008: Stabilize Hub Repository Test Environment

| Work Order ID      | Type | Description                                                            | Status  |
| ------------------ | ---- | ---------------------------------------------------------------------- | ------- |
| `SYSTEM-008-FIX-01` | `FIX`  | **CRITICAL:** Stabilize `hub` repo test environment to isolate test runs. | `ARCHITECTURALLY APPROVED` ✅ |

**Stabilization Status (2025-10-13): COMPLETE** ✅
- **Reason:** Submission of `TRACTION-003` revealed systemic test failures in `base`, `web`, `bus`, and `mail` modules.
- **Fix:** The Executive Architect personally applied the same fix from `SYSTEM-005`: adding the `--test-tags "/$MODULE_TO_TEST"` flag to `run-tests.sh`. This scopes the test runner to the target module, preventing test suite contamination.
- **Impact:** All Hub/Traction development is unblocked.

---

## Dependency & Sequencing

-   **Wave 0 (Infrastructure):** `SYSTEM-002-CODE-01`, `SYSTEM-002-CODE-02` (Can run in parallel; CRITICAL BLOCKER - must complete BEFORE feature work)
-   **Wave 1:** `CORE-001-CODE-01`, `CORE-001-QA-01`
-   **Wave 2:** `CM-001-CODE-01` to `CM-001-QA-01`; `PT-001-CODE-01` to `PT-001-QA-01` (Can run in parallel)
-   **Wave 3:** `AGMT-001-CODE-01` to `AGMT-001-QA-01` (Dependent on Wave 2 completion)
-   **Wave 4:** `VISIT-001-CODE-01` to `VISIT-001-CODE-04` (Sequential; dependent on Wave 2 completion)
