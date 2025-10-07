# Feature Brief: EVV Scheduling Module

**Status:** Proposed
**Author:** Executive Architect
**Date:** 2025-10-07

## 1. Vision & Strategy

This document outlines the architectural foundation for the **`evv_scheduling`** module. The vision is to create a sophisticated, compliance-driven care coordination and scheduling engine for the EVV system.

The development strategy is a phased rollout:
1.  **MVP (Manual "Scheduler's Workbench"):** The initial focus is to build a powerful toolkit for a human scheduler. This will include a "smart" matching engine that assists the scheduler by validating DSP qualifications, availability, and safety rules, preventing errors before they happen.
2.  **Post-MVP (Automation):** Once the core engine is proven, we will iteratively introduce automation, starting with suggested assignments and evolving towards a fully automated system for routine scheduling, with human oversight for exceptions.

## 2. Architectural Pillars

### 2.1. Data Models (The "Nouns")

The following new data models are required:
-   `scheduling.shift`: The core object representing a unit of work. Contains `patient_id`, `start_time`, `end_time`, `status` (Open, Filled, etc.), and `required_skills` (e.g., ["diabetic_trained"]).
-   `dsp.availability.slot`: A model for DSPs to define and manage their work availability.
-   `dsp.burnout.rule`: A configuration model to define safety rules (e.g., `max_consecutive_hours`, `min_rest_period`).
-   `dsp.burnout.log`: An internal log to track work hours against the defined safety rules.

This module will have critical dependencies on existing models, including `hr.employee`, `service.agreement`, and compliance data fetched from the Hub.

### 2.2. The Matching Engine (The "Brain")

This is the core logic engine responsible for identifying valid candidates for a shift. It acts as a **hard, security-like filter** for all scheduling views and notifications.

**A DSP will never be shown a shift for which they are not qualified.**

The engine will filter all available DSPs based on the following criteria:
1.  **Availability:** Does the DSP's defined availability overlap with the shift time?
2.  **Training Compliance:** Does the DSP possess all skills listed in the shift's `required_skills`? (Data from Hub)
3.  **Burnout Prevention:** Is the DSP prevented from working by an active `dsp.burnout.rule`?
4.  **Client Assignment:** Is the DSP authorized to work with the specified patient?
5.  **Proximity (Post-MVP):** Does the shift's location fall within the DSP's preferred travel time?

### 2.3. User Experiences (The Interfaces)

We will require at least two distinct user experiences:
-   **Scheduler's Dashboard (Desktop/Web):** A "mission control" interface (e.g., calendar/Gantt view) for manually creating, viewing, and filling open shifts using the Matching Engine as an assistant.
-   **DSP's Dashboard (Mobile-First):** A simplified interface for DSPs to view their schedule, manage availability, and see a pre-filtered list of "open shifts" they are qualified for.

## 3. Key Features & Dependencies

### 3.1. DSP Proximity Filter

A key feature is allowing DSPs to filter open shifts based on **driving time**, not just distance.
-   **Architectural Impact:** This introduces a formal dependency on an **external Mapping Service API** (e.g., Google Maps, Mapbox) for calculating real-world travel times.
-   **Implementation:** This will require an asynchronous background job to pre-calculate and cache travel times to manage cost and performance.

### 3.2. Communications & Alerting

The system must be able to send notifications (e.g., for new open shifts). The notification system will be designed to be "pluggable," allowing for different delivery channels (Email, Push, SMS) to be added in the future.

## 4. Open Questions

-   The precise business logic for burnout rules needs to be defined.
-   The workflow for "shift bidding" needs further definition.
