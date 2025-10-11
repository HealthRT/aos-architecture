# 06: Role and Permission Matrix

**Status:** Live
**Author:** Executive Architect
**Last Updated:** 2025-10-09

## 1. Purpose

This document is the **single source of truth** for all user roles and their corresponding permissions within the Agency Operating System (AOS). It serves as the primary security blueprint for all modules.

All user stories and specifications must define their access control requirements in alignment with the roles defined here. All code and security rules (`ir.model.access.csv`, record rules) must be implemented to enforce these permissions.

## 2. Guiding Principles

-   **Principle of Least Privilege:** By default, a role has **no access**. We only grant the specific permissions necessary for the role to perform its documented responsibilities.
-   **Separation of Concerns:** Roles are defined by their business function. Access to sensitive data (e.g., PHI, pay rates) is strictly limited to roles that have a legitimate, documented need.

## 3. Role Matrix

This matrix will evolve as new modules and features are added.

### 3.1. Hub Roles (Administrative)

| Role Name             | Key Responsibilities                                          | Permissions Granted (High-Level)                                                                                                                                                             |
| :-------------------- | :------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Compliance Officer**| Manages onboarding, tracks training credentials.              | - Read/Write all `hub_credentialing` models. <br>- Read `hr.employee` records. <br>- **(DENY)** Access to any EVV data.                                                                             |
| **Wellness Leader**   | Manages engagement, recognition, and interest profiles.       | - Read/Write `if_recognition` models. <br>- Read/Write "Interest Tags" on `hr.employee`. <br>- **(DENY)** Read `hr.employee` pay rate or other core HR data.                                      |
| **HR Administrator**  | Manages payroll, and core employee data synced from Gusto.      | - Read `hr.employee` records, including pay rates. <br>- Read/Write `hub_payroll` models. <br>- **(DENY)** Access to any EVV data.                                                                |
| **Hub User (Base)**   | A standard employee with access to self-service features.     | - Read own `hr.employee` record. <br>- Participate in `if_recognition` programs. <br>- **(DENY)** Read other employee records.                                                                |

### 3.2. EVV Roles (Clinical & Operational)

| Role Name             | Key Responsibilities                                        | Permissions Granted (High-Level)                                                                                                                                                             |
| :-------------------- | :---------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **DSP (Direct Support)** | Delivers care, records visits, manages their schedule.        | - Read own assigned Patients' non-clinical data. <br>- Create/Edit own `evv.visit` records. <br>- Read/Edit own `dsp.availability.slot`. <br>- **(DENY)** Read other DSPs' schedules.             |
| **Scheduler**         | Manages the master schedule, fills open shifts.             | - Read all Patients' non-clinical data. <br>- Read all DSPs (name and qualifications only). <br>- Create/Edit all `scheduling.shift` records. <br>- **(DENY)** Read patient clinical notes.          |
| **DC (Designated Coord.)**| Supervises a team of DSPs, approves timecards, manages care plans. | - Full access to all data for assigned Patients and assigned DSPs. <br>- Read/Write `service.agreement` for assigned Patients. <br>- Approve `evv.visit` records for assigned DSPs. |

### 3.3. System Roles

| Role Name             | Key Responsibilities                                        | Permissions Granted (High-Level)                                                                                                                                                             |
| :-------------------- | :---------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **System Admin**      | Has superuser privileges for system maintenance ONLY.       | - Full access to all technical settings. This role is not intended for day-to-day business operations.                                                                                        |
