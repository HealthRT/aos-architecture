# 4. Gusto as Employee Source of Truth

**Date:** 2025-10-07

**Status:** Accepted

## Context

For the Agency Operating System to function reliably, there must be a single, unambiguous source of truth for core employee Human Resources (HR) data. This includes employee names, contact information, and, critically, their pay rates.

Without a designated master record, we risk data becoming inconsistent between our systems (Gusto, the Hub, and the EVV). This would lead to synchronization conflicts, create an unreliable foundation for payroll calculations, and increase administrative overhead.

## Decision

**Gusto will be the "Single Source of Truth" for all employee HR data.**

1.  **Uni-Directional Data Flow:** All core HR data will flow in one direction only: from Gusto into the Hub. The `hr.employee` model within the Hub will be treated as a **read-only replica** of the data mastered in Gusto.
2.  **Onboarding Trigger:** The creation of a new employee record in our system will be triggered exclusively by a webhook from Gusto (e.g., when a new hire accepts their offer). Manual creation of employees in the Hub will be prohibited.
3.  **Payroll & HR Data:** Sensitive data required for payroll, such as pay rates, will be managed in Gusto and synced to the Hub. The Hub's payroll module will read this data but will not provide interfaces to edit it.

The overall data flow for personnel information is hereby defined as: **`Gusto -> Hub -> EVV`**.

## Consequences

-   **Positive:**
    -   **Improved Data Integrity:** Eliminates the possibility of data conflicts and ensures all systems are working from the same, authoritative employee record.
    -   **Simplified Onboarding:** Creates a clean, automated, and unambiguous workflow for employee onboarding.
    -   **Simplified Payroll Module:** The `hub_payroll` module is simplified, as it no longer needs to manage pay rate data. It becomes a pure calculation engine based on trusted, externally-managed data.
    -   **Clear Separation of Concerns:** Reinforces the Hub's role as the administrative core and Gusto's role as the HR master, which is a clean and logical separation.

-   **Negative:**
    -   **Hard Dependency:** This creates a hard dependency on the Gusto integration for a critical business process (employee onboarding). The system cannot function without a reliable connection to Gusto.
    -   **Initial Implementation Cost:** We must invest in building a robust and secure webhook listener in the Hub to handle the data synchronization from Gusto.
