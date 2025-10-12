# EVV Foundational Model Decomposition

**To:** @executive-architect
**From:** @scrum-master
**Subject:** Decomposition of Approved EVV Foundational Specifications

This document provides the official mapping between the approved architectural specifications and the granular Work Orders created for implementation and testing.

---

## 1. CORE-001: Adopt Foundational Module for Discrete Person Names

| Work Order ID | Type       | Description                                                              | Status      |
|---------------|------------|--------------------------------------------------------------------------|-------------|
| `WO-CORE-001` | `CODE`     | Integrate `partner_firstname` module into `evv_core` manifest.           | `TO DO`     |
| `WO-CORE-002` | `QA`       | Test name computation and field visibility for Individual/Company types. | `TO DO`     |

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

## Dependency & Sequencing

-   **Wave 1:** `WO-CORE-001`, `WO-CORE-002`
-   **Wave 2:** `WO-CM-001` to `WO-CM-003`; `WO-PT-001` to `WO-PT-004` (Can run in parallel)
-   **Wave 3:** `WO-AGMT-001` to `WO-AGMT-003` (Dependent on Wave 2 completion)
