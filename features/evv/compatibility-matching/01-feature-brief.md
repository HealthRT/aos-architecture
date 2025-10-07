# Feature Brief: Compatibility Matching

**Status:** Proposed
**Author:** Executive Architect
**Date:** 2025-10-07

## 1. Vision & Strategy

This document outlines the architectural foundation for the **Compatibility Matching** feature. The vision is to enhance the `evv_scheduling` module by moving beyond simple qualification-based scheduling and into a more human-centered model that matches caregivers and patients based on shared interests and personality traits.

This feature is designed to improve the quality of care for individuals and increase work satisfaction and retention for DSPs.

## 2. Architectural Pillars

### 2.1. The "Interest Tag" System

-   **Data Location:** All data related to employee interests and engagement will be mastered in the **Hub**. This ensures the feature is available to all employees (not just DSPs) and keeps the employee profile data centrally managed.
-   **New Model:** A new `core.interest.tag` model will be created in the Hub to serve as a managed library of approved, machine-readable tags (e.g., `gardening`, `classical_music`, `dogs`).
-   **Model Extensions:**
    -   The `hr.employee` model in the **Hub** will be extended with a many-to-many relationship to `core.interest.tag` to store the interests of all staff.
    -   The patient model in the **EVV** will be extended with a many-to-many relationship to a synced version of these tags to store the interests of individuals.

### 2.2. The Hub-EVV Interface

The communication of interest data will be handled by expanding an existing API endpoint.
-   **API Contract:** The `StaffCapabilities` schema in the `Hub-API-v1.yaml` contract will be updated.
-   **New Payload:** The response for the `GET /staff/{employee_id}/capabilities` endpoint will be expanded to include a new `interests` array, containing the list of interest tags associated with the DSP.

### 2.3. The Scheduling Engine: From "Filter" to "Ranker"

The core logic of the `evv_scheduling` Matching Engine will be evolved.
-   **Current State (Filtering):** The engine currently produces a simple list of DSPs who are qualified and available for a shift.
-   **New State (Ranking):** The engine will be enhanced with a new "Scoring" step that runs *after* the hard filters. This step will compare the `interests` of the patient with the `interests` of each qualified DSP and calculate a "Compatibility Score."
-   **Output:** The Matching Engine will now return a **ranked list** of candidates, sorted from highest to lowest compatibility score, empowering the human scheduler to make a more informed, human-centered decision.

## 3. Future Enhancements ("Deeper Insights")

-   **Vision:** Post-MVP, we will explore using a HIPAA-compliant **Insight Engine** to analyze unstructured data (like DSP visit notes) to suggest new interest tags for both patients and DSPs.
-   **Workflow:** This will be a "Human-in-the-Loop" process. The AI will identify potential interests from text and create a *suggestion* for a Designated Coordinator or Wellness Leader to review and approve before the tag is formally added to a profile. This ensures data quality and ethical oversight.

## 4. Architectural Decision Summary

-   The decision to master all interest data in the Hub is critical. It supports our company philosophy of separating "HR" from "Wellness," enables the feature for all staff (not just DSPs), and maintains a clean, uni-directional `Hub -> EVV` data flow, avoiding complex circular dependencies.
