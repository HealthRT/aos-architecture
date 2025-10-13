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
| `PT-001-CODE-01` | `CODE` | Create `evv_patients` module and `evv.patient` model. | `IN PROGRESS` |
| `PT-001-CODE-02` | `CODE` | Implement views and security for `evv.patient`. | `TO DO` |
| `PT-001-CODE-03` | `CODE` | Implement disambiguated search for `partner_id` linking. | `TO DO` |
| `PT-001-QA-01` | `QA` | Test CRUD, access rights, and duplicate ID constraint for Patients. | `TO DO` |

---

## 4. AGMT-001: Create Simple Bucket Service Agreement

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `AGMT-001-CODE-01` | `CODE` | Create `evv_agreements` module and `service.agreement` model. | `TO DO` |
| `AGMT-001-CODE-02` | `CODE` | Implement views and security for `service.agreement`. | `TO DO` |
| `AGMT-001-QA-01` | `QA` | Test CRUD, computed fields, state transitions, and validation rules. | `TO DO` |

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
| `SYSTEM-002-CODE-01` | `CODE` | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `evv` repository. | `DONE` |
| `SYSTEM-002-CODE-02` | `CODE` | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `hub` repository. | `IN PROGRESS` |

**Architectural Note (2025-10-13):** Initial implementation of `SYSTEM-002-CODE-01` was incomplete and revealed multiple flaws under QA stress-testing (`CORE-001-QA-01`):
- **Issue #1:** Missing DB initialization commands and healthcheck configuration (FIXED)
- **Issue #2:** Internal port conflict - container Odoo server conflicted with test execution (FIXED)

The Executive Architect implemented two rounds of fixes, refactoring the execution logic to use a robust, idiomatic pattern for containerized test commands. The test infrastructure is now validated, hardened, and complete.

**Key Improvements over SYSTEM-001:**
- Single script (no separate `start-agent-env.sh`)
- `trap` command ensures cleanup runs on success, failure, or interruption
- Healthcheck waiting prevents race conditions
- Unique project names (module + timestamp) prevent collisions

---

## 7. VISIT-001: Create Core Visit Record with Service Selection & Notes

| Work Order ID | Type | Description | Status |
|---|---|---|---|
| `VISIT-001-CODE-01` | `CODE` | Create Visit Model Foundation (core fields, basic workflow, security). | `TO DO` |
| `VISIT-001-CODE-02` | `CODE` | Add MN DHS Compliance Fields & Unit Calculations. | `TO DO` |
| `VISIT-001-CODE-03` | `CODE` | Implement Manual Correction Workflow & Logic. | `PENDING` |
| `VISIT-001-CODE-04` | `CODE` | Implement Advanced Security & Access Control (DSP/DC record rules). | `PENDING` |

**Dependencies:** Requires evv_core, evv_patients, evv_agreements (Wave 2)

---

## Dependency & Sequencing

-   **Wave 0 (Infrastructure):** `SYSTEM-002-CODE-01`, `SYSTEM-002-CODE-02` (Can run in parallel; CRITICAL BLOCKER - must complete BEFORE feature work)
-   **Wave 1:** `CORE-001-CODE-01`, `CORE-001-QA-01`
-   **Wave 2:** `CM-001-CODE-01` to `CM-001-QA-01`; `PT-001-CODE-01` to `PT-001-QA-01` (Can run in parallel)
-   **Wave 3:** `AGMT-001-CODE-01` to `AGMT-001-QA-01` (Dependent on Wave 2 completion)
-   **Wave 4:** `VISIT-001-CODE-01` to `VISIT-001-CODE-04` (Sequential; dependent on Wave 2 completion)
