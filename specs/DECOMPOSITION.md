# EVV Foundational Model Decomposition

**To:** @executive-architect
**From:** @scrum-master
**Subject:** Decomposition of Approved EVV Foundational Specifications

This document provides the official mapping between the approved architectural specifications and the granular Work Orders created for implementation and testing.

---

## 1. CORE-001: Adopt Foundational Module for Discrete Person Names

| Work Order ID | Type       | Description                                                              | Status      |
|---------------|------------|--------------------------------------------------------------------------|-------------|
| `WO-CORE-001` | `CODE`     | Integrate `partner_firstname` module into `evv_core` manifest.           | `DONE`      |
| `WO-CORE-002` | `QA`       | Test name computation and field visibility for Individual/Company types. | `BLOCKED`   |

---

## 2. CM-001: Create Dedicated Case Manager Record

| Work Order ID | Type       | Description                                                     | Status      |
|---------------|------------|-----------------------------------------------------------------|-------------|
| `WO-CM-001`   | `CODE`     | Create `evv_case_managers` module and `evv.case_manager` model. | `TO DO`     |
| `WO-CM-002`   | `CODE`     | Implement views and security for `evv.case_manager`.            | `TO DO`     |
| `WO-CM-003`   | `QA`       | Test CRUD, access rights, and duplicate ID constraint for CMs.  | `TO DO`     |

---

## 3. PT-001: Create Dedicated Patient Record

| Work Order ID | Type       | Description                                                 | Status      |
|---------------|------------|-------------------------------------------------------------|-------------|
| `WO-PT-001`   | `CODE`     | Create `evv_patients` module and `evv.patient` model.       | `TO DO`     |
| `WO-PT-002`   | `CODE`     | Implement views and security for `evv.patient`.             | `TO DO`     |
| `WO-PT-003`   | `CODE`     | Implement disambiguated search for `partner_id` linking.    | `TO DO`     |
| `WO-PT-004`   | `QA`       | Test CRUD, access rights, and duplicate ID constraint for Patients. | `TO DO`     |

---

## 4. AGMT-001: Create Simple Bucket Service Agreement

| Work Order ID | Type       | Description                                                          | Status      |
|---------------|------------|----------------------------------------------------------------------|-------------|
| `WO-AGMT-001` | `CODE`     | Create `evv_agreements` module and `service.agreement` model.        | `TO DO`     |
| `WO-AGMT-002` | `CODE`     | Implement views and security for `service.agreement`.                | `TO DO`     |
| `WO-AGMT-003` | `QA`       | Test CRUD, computed fields, state transitions, and validation rules. | `TO DO`     |

---

## 5. SYSTEM-001: Agent Test Runner Stabilization

| Work Order ID        | Type       | Description                                                                    | Status      |
|----------------------|------------|--------------------------------------------------------------------------------|-------------|
| `WO-SYSTEM-001-01`   | `CODE`     | Create reliable `run-tests.sh` script for `evv` repository and update docs.   | `REPLACED`  |
| `WO-SYSTEM-001-02`   | `CODE`     | Create reliable `run-tests.sh` script for `hub` repository and update docs.   | `REPLACED`  |

**Status:** Replaced by SYSTEM-002 after critical failures documented in Process Improvement Entry #012 and #014.

---

## 6. SYSTEM-002: Resilient Agent Test Environment with Guaranteed Cleanup

| Work Order ID        | Type       | Description                                                                                      | Status      |
|----------------------|------------|--------------------------------------------------------------------------------------------------|-------------|
| `WO-SYSTEM-002-01`   | `CODE`     | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `evv` repository.     | `TO DO`     |
| `WO-SYSTEM-002-02`   | `CODE`     | Create resilient single-script `run-tests.sh` with guaranteed cleanup for `hub` repository.     | `TO DO`     |

**Key Improvements over SYSTEM-001:**
- Single script (no separate `start-agent-env.sh`)
- `trap` command ensures cleanup runs on success, failure, or interruption
- Healthcheck waiting prevents race conditions
- Unique project names (module + timestamp) prevent collisions

---

## Dependency & Sequencing

-   **Wave 0 (Infrastructure):** `WO-SYSTEM-002-01`, `WO-SYSTEM-002-02` (Can run in parallel; CRITICAL BLOCKER - must complete BEFORE feature work)
-   **Wave 1:** `WO-CORE-001`, `WO-CORE-002`
-   **Wave 2:** `WO-CM-001` to `WO-CM-003`; `WO-PT-001` to `WO-PT-004` (Can run in parallel)
-   **Wave 3:** `WO-AGMT-001` to `WO-AGMT-003` (Dependent on Wave 2 completion)
