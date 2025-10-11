# Feature Brief: EVV Service Agreement Management

**Status:** Proposed
**Author:** Executive Architect
**Date:** 2025-10-09

## 1. Vision & Strategy

This document outlines the architectural foundation for the **`evv_agreements`** module. This is a **Core** module and the foundational "Rule Book" for the entire EVV platform.

**Vision:** To create a centralized, auditable system for managing all patient Service Agreements and to provide a robust **Service Validation Engine** that ensures every service delivered is compliant, authorized, and billable.

**Strategy:** The module will be developed with a phased rollout, starting with a simplified MVP to enable iterative field testing and feedback on the system's behavior.

## 2. Architectural Pillars

### 2.1. The Data Model (The "Constitution")

-   **Primary Model:** A new `service.agreement` model will be created to be a digital replica of the official Service Agreement source document.
-   **Data Source (MVP):** All agreements will be manually entered into a standard Odoo form view by a Designated Coordinator (DC). Future iterations will explore automated ingestion (SFTP, OCR).

### 2.2. The Service Validation Engine (The "Referee")

This is the core component of the module. It is an internal, API-First service that will be called by other EVV modules (like Scheduling and Service Delivery). It will operate as a **three-stage guardian** for the entire service lifecycle.

**Stage 1: Pre-Authorization Check (The "Active Ledger")**
-   **When:** Called by the `evv_scheduling` module *before* a shift is created.
-   **Logic:** Proactively checks if a proposed shift is compliant with the Service Agreement, specifically verifying that there are sufficient **remaining units** in the budget.
-   **Outcome:** Returns a "go/no-go" decision. If "no-go," it provides an "Early Warning" (e.g., "Exceeds authorized units").

**Stage 2: Point-of-Service Check**
-   **When:** Called by the `evv_delivery` (PWA) module when a DSP attempts to **clock-in**.
-   **Logic:** Performs a final, real-time check of the active ledger to ensure authorization is still valid.
-   **Outcome:** Blocks the clock-in if the service is no longer authorized.

**Stage 3: Post-Visit Verification**
-   **When:** Called after a DSP **clocks-out** and submits their documentation.
-   **Logic:** Performs the final audit, verifying the total duration, completeness of documentation (e.g., "Smart Notes," eMAR), and adherence to any other care plan requirements.
-   **Outcome:** If all three stages are passed, the visit is promoted to a **"Verified Billable Event."** The engine then formally **debits the used units** from the Service Agreement's ledger.

## 3. Phased Rollout Plan (Engine Logic)

-   **MVP:** The `Service Validation Engine` will initially only support a **"Simple Bucket"** model (e.g., 100 total units for a 3-month period).
-   **Post-MVP:** The engine will be extended to support more complex rules, such as granular cadences (units per week/day) and multiple, independent budgets for different service types.

## 4. Key Features & Dependencies

### 4.1. The Override Process

-   **Requirement:** The system must support an override process for "Early Warnings."
-   **Implementation (MVP):** The ability to override a validation warning will be a **configurable permission**. Initially, this permission will be granted only to the **Designated Coordinator (DC)** role.
-   **Auditability:** All override actions must be logged with the user, timestamp, and a mandatory justification note.

### 4.2. Dependencies

-   This module is a foundational service and has minimal dependencies.
-   It will be a **provider** of services to other EVV modules, including `evv_scheduling`, `evv_delivery`, and `evv_billing`. The internal API it exposes is critical.

## 5. Architectural Decision Summary

-   This module is the **single source of truth for service authorization.**
-   Its core component is the **`Service Validation Engine`**, which acts as a proactive, three-stage guardian.
-   The design explicitly separates the "rules" of validation (this module) from the "people" of matching (`evv_scheduling`).
-   The MVP is scoped to support manual data entry and a "Simple Bucket" ledger to facilitate rapid field testing and iterative feedback on the system's behavior.
