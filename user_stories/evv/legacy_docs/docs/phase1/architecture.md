# Odoo EVV MVP Architecture

This document outlines the high-level architecture for the Odoo Electronic Visit Verification (EVV) Minimum Viable Product (MVP).

## 1. Module Map

The system is composed of four primary Odoo modules:

| Module              | Responsibility                                                                 | Key Components                                        |
| ------------------- | ------------------------------------------------------------------------------ | ----------------------------------------------------- |
| **EVV Core**        | Data models, business logic, validation engine, and core services. **MVP Scope**: PCA and 245D Employment Services. Service Agreements must be manually editable by administrators. | `visit`, `visit.segment`, `service.agreement` models  |
| **Mobile App**      | DSP-facing interface for clocking in/out and switching services.               | Odoo Web App (PWA), Offline mode, Geolocation capture |
| **Supervisor Review** | Back-office interface for visit approval, exception handling, and reporting. Must provide a distinct UI tailored to the needs of a supervisor (DC), as opposed to a DSP.   | Odoo Views, Approval workflow, Dashboards             |
| **CSV Export**      | Generates compliant CSV files for Pavillio. Must support **batching/pagination** for large datasets.          | Scheduled actions, CSV generation engine              |
| **Data Archival**   | Manages the long-term storage and eventual purging of historical data in compliance with HIPAA. | `archive` flag on models, automated archival/deletion jobs |

## 2. Data Models

The core data models are designed to support the multi-segment visit requirement.

### `visit`
Represents a single client visit performed by a DSP. Acts as a container for segments.

- `client_id` (Many2one: `res.partner`)
- `dsp_id` (Many2one: `hr.employee`)
- `visit_date` (Date)
- `status` (Selection: `draft`, `pending_approval`, `approved`, `exported`, `error`)
- `segment_ids` (One2many: `visit.segment`)

### `visit.segment`
Represents a continuous period of service delivery within a single visit. Segments are sequential, meaning only one can be active at a time and they cannot overlap. A visit must have at least one segment.

- `visit_id` (Many2one: `visit`)
- `service_code` (Many2one: `product.product`)
- `start_time` (Datetime)
- `end_time` (Datetime)
- `duration_minutes_raw` (Integer, Computed)
- `units_billed` (Float, Computed at export)

### `service.agreement`
Defines the services, date ranges, and unit allowances for a client.

- `client_id` (Many2one: `res.partner`)
- `service_code` (Many2one: `product.product`)
- `authorized_units` (Float)
- `start_date` (Date)
- `end_date` (Date)

### `unit.ledger`
A transactional log of all unit debits against a service agreement. This provides a clear audit trail.

- `agreement_id` (Many2one: `service.agreement`)
- `visit_segment_id` (Many2one: `visit.segment`)
- `units_debited` (Float)
- `transaction_date` (Datetime)

## 3. Core Flow: Capture → Approval → Export

The visit lifecycle follows a three-step process.

1.  **Capture (Mobile App)**: The DSP uses the mobile interface to clock in, which creates a `visit` and the first `visit.segment`. When switching services, the current segment is stopped, and a new one is started. At each step, provisional validations are performed to give the DSP immediate feedback.
2.  **Approval (Supervisor Review)**: The completed visit is submitted and enters a `pending_approval` state. A supervisor reviews the visit's segments, notes, and any validation flags. They can approve the visit or send it back for correction.
3.  **Export (CSV Export)**: A scheduled Odoo action gathers all `approved` visits. It performs authoritative validation, re-computes and rounds units, enforces caps, and generates the final CSV file for upload to Pavillio.

## 4. Validations: Capture vs. Export

Validation occurs at two key points to balance immediate feedback with authoritative accuracy.

-   **At Capture (Provisional)**: Checks are performed in real-time on the mobile device to guide the DSP. These are "soft" checks, meaning they warn the user but do not block data capture.
    -   Is the service part of the client's plan?
    -   Is there a provisional unit balance?
-   **At Export (Authoritative)**: These are "hard" checks performed in the back-end. Failures are logged, and depending on the export mode (`strict` vs. `lenient`), may prevent a visit segment from being billed.
    -   Re-compute all segment durations.
    -   Apply official rounding rules.
    -   Enforce hard unit caps from the `service.agreement`.

## 5. Design Principles

-   **Sequential Multi-Segment Visits**: The core design principle is that a `visit` is a container for one or more **sequential** `visit.segment` records. A DSP must explicitly stop one service segment before starting another. This "stop-then-start" process ensures there is no concurrent service delivery and allows for accurate tracking of different services.
-   **No Concurrency via Overlap Prevention**: Business logic will strictly enforce that segments within a single visit (or across visits for a single DSP) cannot have overlapping `start_time`/`end_time` values. This is the primary mechanism for preventing concurrent billing and is enforced with the `EVV_CONFLICT_OVERLAP` validation rule.

## 6. Future Considerations

While the MVP is focused on a manual CSV export, the architecture should be designed to accommodate future, more advanced integrations. The `CSV Export` module should be seen as the first component of a larger `Billing & Integration Engine`. The design of these components should be guided by the principles outlined in `docs/phase1/billing_design_principles.md`.

Key post-MVP features to anticipate include:

-   **EDI Billing Engine**: Evolve the export module into a full "claim workbench". This includes support for generating EDI 837 (claims) and, critically, **parsing EDI 835 (remittance advice)** for automated reconciliation.
-   **EDI Message History**: Implement a new model to store and track all inbound and outbound EDI X12 messages (837, 835, 271, etc.) for audit and history purposes.
-   **Claim Splitting Mechanism**: To handle complex scenarios like **shared care**, the billing engine must support the ability to split a single visit's claim.
-   **On-Demand Eligibility Checks**: Integrate a mechanism to perform on-demand 271 eligibility checks and store the responses.
-   **HHAeXchange Integration**: Direct API or file-based integration for submitting EVV data to the HHAeXchange aggregator.
-   **Trading Partner Connectivity**: Establish direct EDI connectivity for 837/835 messages with key trading partners like Claim.MD where possible.
-   **Service Agreement Ingestion**: An automated process to ingest service agreements from sources like `mn-its` via SFTP. **Viability of OCR for this process has been confirmed.**
-   **Legacy Data Ingestion**: To support migration from existing systems, the system should provide a mechanism to ingest historical data from the legacy Pavillio "Service Record Import" format.
-   **ICD-10 Code Imports**: Provide a mechanism for bulk-importing ICD-10 codes, likely via CSV.

## 7. Data Retention & Archival Strategy

-   **Requirement**: Per HIPAA and MN DHS regulations, all records related to service delivery (including visits, service agreements, notes, and audit logs) must be retained for a minimum of **six years** from the date of service.
-   **Architectural Implications**:
    -   **No Hard Deletes**: The system must not allow for the permanent, physical deletion of any compliance-related records (e.g., `evv.visit`, `service.agreement`).
    -   **Archival Mechanism**: All core models must include an `archive` flag (a standard Odoo feature). Deleting a record from the UI should only set this flag to `true`, removing it from active views and searches but preserving it in the database.
    -   **Automated Purging (Post-MVP)**: A future automated job will be responsible for permanently deleting records only after they have been archived for more than six years. This job will be heavily logged and require explicit activation.
-   **Scope of "Soft-Delete" Policy**: The archival/no-hard-delete policy applies to the following core models:
    -   `evv.visit`
    -   `visit.segment`
    -   `service.agreement`
    -   `unit.ledger`
-   **Logging Requirements**: To ensure a complete audit trail for the 6-year retention period, the system must generate immutable log entries for the following events:
    -   Creation, modification, and archival of any record in the "soft-delete" scope.
    -   All supervisor actions (approval, rejection, edits, overrides).
    -   Generation of any export file (CSV, 837P).
    -   All user authentication events (successful logins and failed attempts).

## 8. Security & HIPAA Compliance

The system will be designed to meet the Technical Safeguards of the HIPAA Security Rule.

-   **Access Control**:
    -   **Authentication**: Standard Odoo user authentication will be enforced. All users must have a unique login. **Two-Factor Authentication (2FA)** is mandatory for all users with access to PHI.
    -   **Authorization**: Odoo's role-based access control (RBAC) model will be used extensively. Access Control Lists (ACLs) and Record Rules will be implemented to ensure that a user (e.g., a DC) can only view or edit records (e.g., visits, clients) for which they are explicitly authorized.

-   **Audit Controls**:
    -   The logging requirements detailed in the "Data Retention" section will serve as the primary audit trail. All sensitive data access and modifications will be logged.

-   **Integrity Controls**:
    -   The "soft-delete" (archival) policy and the detailed audit logs will ensure that no data is improperly altered or destroyed without a clear record.
    -   File checksums will be generated and logged for all claim file exports to ensure the integrity of transmitted data.

-   **Transmission Security**:
    -   All communication between the user's browser (or the mobile app) and the Odoo server must be encrypted using **TLS 1.2 or higher**. The system must be configured to disallow older, insecure protocols.

-   **Encryption at Rest**:
    -   All database backups must be encrypted.
    -   While Odoo does not encrypt the entire database by default, sensitive PHI fields (e.g., client names, notes) should be stored using field-level encryption where feasible, or the underlying PostgreSQL database server should be configured for full disk encryption. This is a critical infrastructure requirement.
