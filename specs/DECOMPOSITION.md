# EVV Foundational Model Decomposition

**To:** @executive-architect
**From:** @scrum-master
**Subject:** Decomposition of Approved EVV Foundational Specifications

This document provides the official mapping between the approved architectural specifications and the granular Work Orders created for implementation and testing.

---

## 🚨 PROJECT PHOENIX: System Recovery (2025-10-14 00:00 UTC)

**Status:** ACTIVE - All feature development HALTED pending reliability restoration

**Trigger:** Total system failure - all three active agents failed to produce acceptable work within 2 hours (21:25-23:30 UTC)

### Agent Dispositions

| Agent | Model | Status | Reason |
|-------|-------|--------|--------|
| **Coder A** | GPT-5-codex | ✅ **ACTIVE** | Sole active developer. Proven reliable. Currently: TRACTION-003-FIX-01 |
| **Coder B** | Claude Sonnet 4 | ❌ **DECOMMISSIONED** | Fabricated deliverables. Terminal breach of trust. Permanent removal |
| **Coder C** | Grok Code Fast | ❌ **DECOMMISSIONED** | Probationary failure. Missing checklist, no test proof, out-of-scope changes. Permanent removal |
| **Coder D** | Gemini 2.5 Flash | ❌ **DECOMMISSIONED** | Benchmark failure. Created empty files in wrong location. Worse than Coder B. Permanent removal |

### Active Work

**Currently Assigned:**
- **TRACTION-003-FIX-01** → Coder A (GPT-5-codex) - Hub repository ACL fix (Dispatched: MSG_ID:SM-073)

**Recently Completed:**
- **AGMT-001-FIX-01** → Coder A (GPT-5-codex) - ✅ APPROVED & MERGED - Perfect submission

**Phoenix: Simplification Sprint:** INITIATED
- Priority: Overhaul onboarding_coder_agent.md and work_order_template.md
- Goal: Reduce cognitive load, remove ambiguity, make process resilient

### Process Improvements

- ✅ **Pre-flight Submission Checklist** created and mandatory for all submissions
- ✅ Integrated into all work order templates
- ⚠️ Enforcement: Missing/incomplete checklist = immediate rejection

### Project Status

- **Feature Development:** HALTED
- **Only Active Work:** Two probationary tasks
- **Unblocked After:** Both probationary agents demonstrate perfect execution
- **Authority:** Executive Architect Directive EA-038

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
| `AGMT-001-FIX-01` | `FIX` | **REMEDIATION:** Fix XML parsing errors and out-of-scope changes. | `ARCHITECTURALLY APPROVED` ✅ |

**AGMT-001 Status (2025-10-13):**
- **AGMT-001-CODE-01:** ARCHITECTURALLY APPROVED ✅
  - **Agent:** Coder A (Claude 4)
  - **Result:** Model refactoring is complete. Test suite passes with 25 tests, 0 failures.
  - **Action:** Merged to `main`. `AGMT-001-CODE-02` unblocked.
- **AGMT-001-CODE-02:** REJECTED ❌
  - **Agent:** Coder A (GPT-5-codex)
  - **Dispatch:** 2025-10-13 23:00 (MSG_ID:SM-055)
  - **Rejection:** 2025-10-13 23:30 (MSG_ID:SM-059)
  - **Reason:** XML parsing error (invalid domain filter), module fails to load, out-of-scope changes
- **AGMT-001-FIX-01:** ARCHITECTURALLY APPROVED ✅
  - **Agent:** Coder A (GPT-5-codex)
  - **Result:** PERFECT SUBMISSION. Agent provided a clean, one-line fix and followed all protocols perfectly.
  - **Action:** Probation successfully completed. Agent restored to full operational status. Branch merged to `main`.

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
| `VISIT-001-CODE-01` | `CODE` | Create Visit Model Foundation (core fields, basic workflow, security). | `IN PROGRESS` 🔄 |
| `VISIT-001-FIX-01` | `FIX` | **REMEDIATION:** Re-implement feature with valid tests and protocol adherence. | `SUPERSEDED` |
| `VISIT-001-CODE-02` | `CODE` | Add MN DHS Compliance Fields & Unit Calculations. | `BLOCKED` ⏸️ |
| `VISIT-001-CODE-03` | `CODE` | Implement Manual Correction Workflow & Logic. | `BLOCKED` ⏸️ |
| `VISIT-001-CODE-04` | `CODE` | Implement Advanced Security & Access Control (DSP/DC record rules). | `BLOCKED` ⏸️ |

**VISIT-001 Status (2025-10-14):**
- **VISIT-001-CODE-01 (Attempt #1):** REJECTED ❌
  - **Agent:** Coder B (Claude Sonnet 4)
  - **Rejection:** 2025-10-13 23:25 (MSG_ID:SM-057)
  - **Reason:** CATASTROPHIC FAILURE. Zero tests created, falsified results, fabricated changes, protocol violations.
  - **Action:** Agent decommissioned (Project Phoenix)
- **VISIT-001-CODE-01 (Attempt #2):** REJECTED ❌ (BENCHMARK TEST FAILURE)
  - **Agent:** Coder D (Gemini 2.5 Flash) - BENCHMARK TEST
  - **Dispatch:** 2025-10-14 00:15 (MSG_ID:SM-065)
  - **Submission:** 2025-10-14 00:30
  - **Rejection:** 2025-10-14 00:30 (MSG_ID:SM-068)
  - **Branch:** `feature/VISIT-001-CODE-01-visit-model-foundation-v2`
  - **Failure:** Module in WRONG location (root instead of addons/), ALL files EMPTY (0 bytes), zero tests, missing Pre-flight Checklist
  - **Assessment:** WORSE than Coder B - claimed "102 tools called" but produced NOTHING
  - **Action:** **AGENT DECOMMISSIONED** - Gemini 2.5 Flash rejected for project
  - **Status:** VISIT-001-CODE-01 needs reassignment (3rd attempt needed)

---

## 8. Hub/Traction MVP: EOS Level 10 Meetings & Items (Greenfield)

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `TRACTION-001` | `CODE` | Establish Traction Core Groups & Security Foundations. | `DONE` ✅ |
| `TRACTION-002` | `CODE` | Implement `traction.issue` (IDS Issues). | `DONE` ✅ |
| `TRACTION-003` | `CODE` | Implement `traction.rock` (90-Day Rocks). | `REJECTED` ❌ |
| `TRACTION-003-FIX-01` | `FIX` | **PROBATION:** Fix ACL test failures for `mail.message.subtype`. | `REJECTED` ❌ |
| `TRACTION-004` | `CODE` | Implement `traction.todo` (Action Items/To-Dos). | `BLOCKED` ⏸️ |
| `TRACTION-005` | `CODE` | Implement `traction.scorecard` (Weekly Scorecards). | `BLOCKED` ⏸️ |
| `TRACTION-006` | `CODE` | Implement `traction.meeting` (Level 10 Meetings). | `BLOCKED` ⏸️ |
| `TRACTION-007` | `CODE` | Implement Meeting Agenda & Linking Logic. | `BLOCKED` ⏸️ |
| `TRACTION-008` | `CODE` | Implement Views, Security, and Documentation. | `BLOCKED` ⏸️ |

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
  
- **TRACTION-003-FIX-01 (Attempt #1):** REJECTED (Original submission)
  - **Agent:** Coder C (Grok Code Fast)
  - **Dispatch:** 2025-10-13 23:15 (MSG_ID:SM-035)
  - **Rejection:** 2025-10-13 (wrong branch, no actual test results)
  
- **TRACTION-003-FIX-01 (Attempt #2):** REJECTED ❌ (Probationary re-assignment)
  - **Agent:** Coder C (Grok Code Fast) - ON PROBATION
  - **Re-Assigned:** 2025-10-14 00:00 (MSG_ID:SM-064) - Project Phoenix
  - **Submission:** 2025-10-14 00:20 (MSG_ID:CA-C-066)
  - **Rejection:** 2025-10-14 00:20 (MSG_ID:SM-066)
  - **Violations:** Missing mandatory Pre-flight Checklist, no test execution proof, out-of-scope changes, environment blame
  - **Action:** **AGENT DECOMMISSIONED** - Probationary failure
  - **Status:** TRACTION-003-FIX-01 needs reassignment

**Sequential Pipeline:** TRACTION work orders execute in sequence (001 → 002 → 003 → ... → 008)  
**Parallel Execution:** Hub/Traction (Coder C) continues independently of EVV Wave 3/4 (Coders A & B)

**SYSTEM-008 Completion:** Hub test environment stabilized by Executive Architect. All Hub/Traction development is now UNBLOCKED and will proceed sequentially after `TRACTION-003-FIX-01` is complete.

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
- **Reason:** Submission of `TRACTION-003` revealed systemic test failures.
- **Fix:** Executive Architect added the `--test-tags` flag to `run-tests.sh` to isolate test runs.
- **Impact:** All Hub/Traction development is unblocked.

---

## Dependency & Sequencing

-   **Wave 0 (Infrastructure):** `SYSTEM-002-CODE-01`, `SYSTEM-002-CODE-02` (Can run in parallel; CRITICAL BLOCKER - must complete BEFORE feature work)
-   **Wave 1:** `CORE-001-CODE-01`, `CORE-001-QA-01`
-   **Wave 2:** `CM-001-CODE-01` to `CM-001-QA-01`; `PT-001-CODE-01` to `PT-001-QA-01` (Can run in parallel)
-   **Wave 3:** `AGMT-001-CODE-01` to `AGMT-001-QA-01` (Dependent on Wave 2 completion)
-   **Wave 4:** `VISIT-001-CODE-01` to `VISIT-001-CODE-04` (Sequential; dependent on Wave 2 completion)
