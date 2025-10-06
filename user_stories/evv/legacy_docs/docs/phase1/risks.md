# EVV MVP Risks & Unknowns

This document captures known risks, ambiguities, and open questions that need to be resolved. Each item requires input from subject matter experts (SMEs) to define the correct behavior.

## 1. Multi-Segment Rounding Ambiguities

The policy for rounding time to billable units is clear for single-segment visits but ambiguous for multi-segment visits.

-   **Risk**: Incorrectly billing (either over or under) by summing segment durations before or after rounding.
-   **Example**: A visit has three 7-minute segments (`service_A`, `service_B`, `service_A`). The total time is 21 minutes.
    -   **Option A (Round per Segment)**: Each 7-min segment rounds to 0 units (since 7 < 8 min threshold for one 15-min unit). Total billed: **0 units**.
    -   **Option B (Sum then Round)**: Total time is 21 minutes, which rounds to 1 unit (15 minutes). Total billed: **1 unit**.
    -   **Option C (Combine Adjacent then Round)**: Segments 1 and 3 for `service_A` are combined (7+7=14 mins), which rounds to 0 units. Segment 2 (`service_B`, 7 mins) rounds to 0. Total billed: **0 units**.
-   **TODO**: SME to define the authoritative policy for rounding multi-segment visits. Does it vary by service or payer?

## 2. State-Specific Cap Windows

Unit caps (e.g., max units per day) are common, but the "window" for these caps is not always a simple calendar day.

-   **Risk**: Incorrectly denying services that should be billable due to a misunderstanding of the cap window.
-   **Example**: A "daily" cap might run from midnight to midnight, or it might be a rolling 24-hour window from the time of first service. A "weekly" cap could be Sunday-Saturday or Monday-Sunday.
-   **TODO**: SMEs to provide a definitive list of cap windows for each service and payer combination. This will be a critical input for the `config_matrix.md`.

## 3. Short-Segment Policy

DSPs may accidentally create very short segments (e.g., < 1 minute) by starting and stopping a service quickly.

-   **Risk**: Polluting the billing export with meaningless data or creating rounding confusion.
-   **Question**: How should these be handled?
    -   **Option A**: Ignore/delete them automatically.
    -   **Option B**: Flag them for supervisor review.
    -   **Option C**: Merge them with an adjacent segment if the service code is the same.
-   **TODO**: SME to define the business rule for handling segments under a certain minute threshold (e.g., `min_billable_minutes`).

## 4. Override Workflow

Supervisors will need a way to override validation errors (e.g., approving a visit that is outside the service agreement window with proper justification).

-   **Risk**: Lack of a clear, auditable override process could lead to compliance issues.
-   **Questions**:
    -   Which validation errors are overridable?
    -   What justification information is required?
    -   How are overrides logged and reported on?
-   **TODO**: Define the scope and workflow for the supervisor override feature. This is likely a Phase 2 feature but needs consideration in the core architecture.

## 5. CSV Specification Drift

The Pavillio CSV format is defined now, but third-party specifications can and do change.

-   **Risk**: Our export format becomes out-of-sync with the clearinghouse, leading to rejected claims.
-   **Mitigation**:
    -   The CSV generation logic must be isolated and easy to modify.
    -   We need a clear contract test (`test_timecard_csv_contract.py`) that can be updated to match any spec changes.
    -   A business process is needed to monitor for any announced changes from Pavillio.
-   **TODO**: Confirm with the integration partner if there is a notification process for spec changes. **Update**: Confirmed that the upload is a manual process. The primary mitigation is creating a formal feedback loop where the staff member performing the upload must immediately report any file rejections, warnings, or UI changes on the Pavillio portal to the development team.
