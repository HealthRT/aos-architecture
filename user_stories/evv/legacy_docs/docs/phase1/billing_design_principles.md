# Billing Design Principles & MVP Scope

_Last updated: 2025-10-04_

This document captures the strategic principles and "lessons learned" from the existing claims process. It should guide the design of the MVP's export functionality and the post-MVP billing engine to ensure the system is resilient, auditable, and user-friendly.

---

## 1. Feedback Evaluation Framework

To ensure we make agnostic and logical decisions, all new feedback, ideas, and SME recommendations must be evaluated against this framework before being committed to the development plan. The default action is to document feedback here, not to immediately create implementation tasks.

| Triage Question                           | Description                                                                                               |
| :---------------------------------------- | :-------------------------------------------------------------------------------------------------------- |
| **1. Is this MVP or Post-MVP?**           | Does this solve a problem essential for the initial launch, or is it an enhancement for a future workflow?    |
| **2. Is this a Core Requirement or an Optimization?** | Is this mandated by regulation (HIPAA, 245D) or fundamental to the process, or does it make an existing process better/faster? |
| **3. Is this a Blocker or a Nice-to-Have?**   | Will the MVP fail to meet its primary objective without this, or can the system function without it?        |

Only after a piece of feedback has been explicitly evaluated and approved against this framework will it be added to the formal task list.

---

## 2. Core Design Principles

This feedback was provided by Christine Everson based on an analysis of current claim rejections and billing workflow challenges.

| Issue                                | Recommendation                                                                                                            |
| :----------------------------------- | :------------------------------------------------------------------------------------------------------------------------ |
| **Shared care rejections**           | The system must be designed to handle shared care scenarios. A **claim splitting mechanism** should be planned for Post-MVP. |
| **False positives in validation**    | Avoid overly rigid validation. The system should allow for **agency-configurable validation thresholds** to reduce noise.   |
| **Service Agreement is truth**       | The Service Agreement must be the authoritative source for all validation logic (authorized units, dates, service codes).   |
| **Lack of audit detail**             | All billing-related actions must have a clear and detailed audit trail, including who approved, what changed, and when.     |
| **Failures on large exports**        | The export mechanism must use **batching and pagination** to reliably handle large datasets (>100 rows).                    |
| **Missing change history**           | Implement a full, immutable log of all export events, corrections, remits, and rejections.                                  |

---

## 3. MVP Service Scope & Roadmap

The following decisions guide the initial focus for the MVP and the roadmap for the post-MVP billing engine.

| Area                       | Decision / Note                                                                     |
| :------------------------- | :---------------------------------------------------------------------------------- |
| **PCA Services**           | This is the primary service line for the MVP. It's well-understood and a good baseline. |
| **CFSS Services**          | **Out of scope for MVP**. This program is not yet active.                           |
| **245D Employment Services** | **In scope for MVP**. These services are required now and must be supported.          |
| **Service Line Export**    | The long-term vision for the export module is to become a "claim workbench".          |
| **Remittance Auto-Filing** | **Post-MVP**. The future billing engine must support **835 parsing** for auto-filing.   |
