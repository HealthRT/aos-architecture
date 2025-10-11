# Feature Brief: EVV Service Delivery

**Status:** Proposed
**Author:** Executive Architect
**Date:** 2025-10-09

## 1. Vision & Strategy

This document outlines the architectural foundation for the **`evv_delivery`** module. This is a **Core** module that provides the essential mobile-first interface for caregivers (DSPs) to compliantly record their service delivery.

**Vision:** To create a simple, intuitive, and highly compliant Progressive Web App (PWA) that serves as the DSP's "Mobile Care Companion." Its primary purpose is to handle Electronic Visit Verification (EVV) and the capture of all necessary service documentation.

**Strategy:** The MVP will be a "steel thread" focused on the absolute minimum, non-negotiable workflow: clocking in, writing a progress note, and clocking out. This will provide a tangible product for iterative field testing and feedback to define more advanced features.

## 2. Architectural Pillars

### 2.1. The User Experience (PWA)

-   **Platform:** A mobile-first Progressive Web App (PWA) built using Odoo's native frontend technologies (Owl framework). It must be responsive and work seamlessly on any modern mobile browser.
-   **Offline Capability:** The PWA must be designed for "offline-first" functionality. It must allow a DSP to complete their entire workflow (clock-in, document, clock-out) without an active internet connection, storing the data securely on the device and syncing it automatically when a connection is re-established.

### 2.2. The Core Workflow (MVP)

The MVP will focus on a simple, three-step process:

1.  **Clock-In:** The primary "start shift" screen. This will feature a **hybrid model**:
    -   **Primary (GPS-Aware):** If the DSP is within a geo-radius of a scheduled individual's location, the app will proactively suggest starting that specific visit.
    -   **Secondary (Manual Look-up):** The DSP will always have the ability to manually search for and select an individual from their assigned list, which is critical for off-site or community-based visits.
2.  **Documentation:** The core deliverable for the MVP is the capture of a **Progress Note**. The UI will feature a simple, clean, rich-text editor for this purpose.
3.  **Clock-Out & Sign:** A final screen that allows the DSP to review their visit details (times, note), and apply a digital signature to finalize and submit the record.

### 2.3. Data Model

-   **Primary Model:** The `evv.visit` model will be the central record created and managed by this module.
-   **MVP Fields:** `start_time`, `end_time`, `patient_id`, `dsp_id`, and a rich-text `progress_note` field.

## 3. Phased Rollout Plan (Post-MVP Features)

The following features are explicitly **out of scope for the MVP** but are planned for future iterations based on feedback:

-   Structured **eMAR (Medication Administration Record)**.
-   Structured **Care Plan Goal** tracking.
-   A dedicated **Incident Report** form and workflow.

## 4. Key Dependencies & Interactions

-   **`Service Validation Engine`:** This is the most critical dependency. The `evv_delivery` module is a **consumer** of the `Service Validation Engine` (from the `evv_agreements` module).
    -   It **must** call `service_validation_engine.check_point_of_service()` before allowing a clock-in.
    -   It **must** trigger the `service_validation_engine.verify_completed_visit()` process after a DSP submits their visit.
-   **`hub_credentialing`:** This module relies on the Hub-EVV API (`GET /staff/{employee_id}/capabilities`) to fetch DSP qualifications, which are then used by the `Matching Engine`.

## 5. Open Questions & The Research Loop

-   **UI Details:** The exact UI details for the hybrid clock-in screen will be determined by a **prototyping and end-user feedback loop**, to be conducted by a UI/UX Agent.
-   **Regulatory Compliance:** The precise, legally-mandated data points for EVV and 245D progress notes are currently based on institutional knowledge. A formal **"Research Loop"** will be initiated. The Architect will dispatch a research request to a specialist AI (e.g., Perplexity) to find the official state/federal documentation. The findings will be logged in `/references` and used to create the final, detailed `Story.yaml` specifications for this module.
