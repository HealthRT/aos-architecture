# Architecture & Business Rule Decision Log

This document records key decisions made for the EVV MVP project to provide a clear, centralized history of project direction.

---

### Decision Log Workflow

This log uses a two-way synchronization process managed by an AI assistant to facilitate feedback from Subject Matter Experts (SMEs).

**Guiding Principles:**
-   **Master Document**: This Markdown file (`decision_log.md`) is the single source of truth for all questions and decisions.
-   **Worksheet File**: The `pending_decisions.csv` file is a temporary "worksheet" used to share questions with SMEs. **Do not add new questions directly to the CSV file**, as it will be overwritten.

**Workflow for Humans & AI Agents:**

1.  **Adding a New Question:**
    -   **Action**: Add a new row to the "Pending Decisions" table in *this* Markdown file.
    -   **Trigger**: Ask the AI assistant to "sync the decision log".
    -   **AI Response**: The AI will parse the "Pending Decisions" table and **overwrite** `pending_decisions.csv` with the latest list of questions.

2.  **Getting Answers from SMEs:**
    -   **Action**: After a sync, copy the contents of `pending_decisions.csv` to a shared spreadsheet for SMEs to fill out. Once complete, copy their answers back into the `pending_decisions.csv` file in this repository.
    -   **Trigger**: Ask the AI assistant to "sync the decision log".
    -   **AI Response**: The AI will read the answers from the CSV file. For each answered question, it will:
        1.  Remove the question from the "Pending Decisions" table in this Markdown file.
        2.  Add the question, details, and the SME's decision to the "Decided" table in this Markdown file.
        3.  Re-sync the `pending_decisions.csv` file, which will now be shorter as it only contains the remaining unanswered questions.

This process ensures that `decision_log.md` remains a complete and up-to-date historical record.

---

### Pending Decisions

The following topics are awaiting feedback from Subject Matter Experts (SMEs) or other stakeholders.

| Topic                        | Details                                                                                                                                                                                            | Status                       | Date Raised  |
| :--------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------- | :----------- |
| **Unit of Service Definition** | **CRITICAL**: The `mn_245d_hcbs_summary.md` states units can be variable, but our assumption has been "1 Unit = 15 minutes". Must the MVP support configurable unit definitions per payer, or is a single 15-minute rule safe? The previous decision to use a 15-minute unit is now being re-evaluated. | **High Priority - Blocking** | 2025-10-04   |
| Multi-Segment Rounding       | When a visit has multiple segments for the same service (e.g., two 7-minute segments), should we sum the total minutes *before* rounding, or round each segment individually?                                                       | Pending SME Feedback         | 2025-10-04   |
| Unit Cap Window Definitions  | Are unit caps (daily, weekly) based on calendar windows (midnight-to-midnight, Sun-Sat) or rolling windows (last 24 hours, last 7 days)?                                                                                             | Pending SME Feedback         | 2025-10-04   |
| Short-Segment Handling       | How should the system handle segments shorter than the 8-minute minimum? Should they be automatically discarded, flagged for review, or rounded up to 1 unit?                                                                       | Pending SME Feedback         | 2025-10-04   |
| Supervisor Override Policy   | 1. What user roles can override (Supervisor, Admin, DSP)? 2. If a DSP can self-correct, is there a grace period (e.g., 5 mins)? 3. Which errors are overridable? 4. Is a justification note required? 5. Do overrides use an "override bucket" or adjust balances? 6. Is a special modifier needed on the claim? | Pending SME Feedback         | 2025-10-04   |
| Supervisor Review UI         | To approve a visit, what is the most critical information to display on the supervisor review screen (e.g., remaining units, recent client visits, validation warning flags)?                                                         | Pending SME Feedback         | 2025-10-04   |
| Service Agreement Carryover  | Do service agreements support carryover (unused units roll to the next period), or is it always "use-it-or-lose-it"?                                                                                                                | Pending SME Feedback         | 2025-10-04   |
| Service Agreement Import Logic | When a new service agreement is imported, should it replace existing agreements for the client, or be added alongside them (e.g., a Jan-Jun agreement followed by a Jul-Dec agreement)?                                               | Pending SME Feedback         | 2025-10-04   |
| DSP Identifier               | The 837P guide requires a Rendering Provider NPI. Do our DSPs have individual NPIs, or is there another unique ID we must use for them on claims?                                                                                     | Pending SME Feedback         | 2025-10-05   |
| **Group Home Workflow vs. No Overlap** | **CRITICAL**: User story `WORKFLOW_GROUP_HOME_001` requires concurrent, overlapping visits for a DSP in a group home, which conflicts with our "No Overlap" rule. Does the "No Overlap" rule apply strictly to a DSP (can never have 2 visits at once), or to a DSP/Client pair (can't have 2 visits for the same client at once)? | **High Priority - Blocking** | 2025-10-05   |
| Billing Modifier Handling    | User story `WORKFLOW_GROUP_HOME_001` specifies the `U1` modifier will be inferred. For other modifiers (`HQ`, `GT`, `U2`), should they be manually selected by the DSP during a visit, or are there other workflows where they should be inferred? | Pending SME Feedback         | 2025-10-05   |
| Geo-Fencing MVP Scope        | `validation_rules.md` lists a `VISIT_OUTSIDE_GEOFENCE` rule, but there is no user story for it. Is Geo-Fencing a requirement for the MVP? If so, we will need a user story and data model updates. | Pending SME Feedback         | 2025-10-05   |
| Provider Match on Service Agreements | `validation_rules.md` requires the DSP to match the provider on the Service Agreement. Does an agreement authorize only a single provider, or can it authorize a list/team of providers? | Pending SME Feedback         | 2025-10-05   |
| Minimum Visit Duration       | What is the minimum allowed duration for a visit segment? `USER_STORIES.md` says >= 1 min, but `timecard rules.csv` says >= 15 mins. The 8-minute rounding rule also implies a different threshold. | Pending SME Feedback         | 2025-10-05   |

---

### Decided

| Topic                            | Decision                                                                                                                                                                             | Status                                 | Date Decided |
| :------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------- | :----------- |
| Service Agreement Editability    | Service Agreements must be manually editable in the back-end by authorized admin users. This allows for corrections without requiring a full replacement via import.                    | Decided                                | 2025-10-04   |
| Capture-Time Unit Validation     | A **hard block** will be enforced at capture/switch. If a provisional check shows insufficient units, the segment **cannot be started**. Overrides are post-MVP.                        | Decided                                | 2025-10-04   |
| CSV Export Strategy              | Provide two profiles: a `basic` (default, no PHI) for electronic submission and a secured `phi` profile (gated by role/MFA) for manual, internal use.                                     | Decided                                | 2025-10-04   |
| Visit Segment Concurrency        | No concurrency is allowed. Visits are composed of strictly sequential, non-overlapping segments. A DSP must stop one segment before starting another.                                  | Decided                                | 2025-10-04   |
| Future Integrations              | The MVP architecture will anticipate a future billing engine (EDI 837/835), HHAeXchange integration, and automated ingestion of PDF service agreements.                                 | Decided                                | 2025-10-04   |
| MVP Service Agreement Data Source| Service agreement data will be entered manually into Odoo by authorized staff for the MVP.                                                                                               | Decided                                | 2025-10-04   |
| MVP Logging Level                | The system will be configured for `DEBUG` level logging for the MVP period to ensure maximum visibility during rollout.                                                                  | Decided                                | 2025-10-04   |
| Authentication Method            | The specific method (Odoo standard vs. SSO) is TBD, but 2FA will be a mandatory security requirement regardless of the chosen system.                                                     | Partially Decided (2FA is confirmed)   | 2025-10-04   |
| Pavillio CSV Spec Change Process | The CSV is uploaded manually. The staff member performing the upload is responsible for immediately reporting any file rejections or UI changes to the development team.                 | Decided                                | 2025-10-04   |
