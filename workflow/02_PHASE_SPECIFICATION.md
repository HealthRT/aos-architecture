# 02: Phase 2 - Specification

**Purpose:** To translate a high-level Feature Brief into a complete, technically-vetted, and unambiguous `Story.yaml` specification that is ready for implementation.

---

### Process Flow

1.  **Trigger:** The Business Analyst (BA) Agent is assigned a `Feature Brief` to work on.
2.  **Action:** The BA reads the brief and all relevant ADRs, and creates the first draft of the `Story.yaml` file in the appropriate `/specs` directory.
3.  **Handoff (Review Trigger):** Upon completion of the draft, the BA creates or updates the "Epic" issue in the `aos-architecture` repository. It then **assigns this issue to the `@aos-architect`** and applies the `status:needs-architect-review` label. This assignment is the formal notification trigger.
4.  **Architectural Review:** The Executive Architect is notified via GitHub. It performs the formal "Technical Review" of the `Story.yaml` file.
5.  **Decision (Approval/Rejection/Clarification):** The Architect posts its verdict as a **formal comment** on the Epic issue. There are three possible outcomes:
    -   **To Clarify:** For minor, non-blocking ambiguities, the Architect can post a question and @-mention the `@aos-ba-agent`. The BA can answer in a comment, and if the answer is sufficient, the Architect can then proceed to approve.
    -   **To Approve:** The comment must be `Architectural Review: **Approved**.` The Architect then changes the label to `status:ready-for-decomposition`.
    -   **To Reject:** For significant violations, the comment must be `Architectural Review: **Rejected**.` and must include specific, actionable feedback. The Architect then re-assigns the issue to the `@aos-ba-agent`.
6.  **Iteration:** If rejected, the BA incorporates the feedback, updates the `Story.yaml`, and re-initiates the Handoff step.

### Entry Criteria
- A `Feature Brief` must exist and be approved.

### Exit Criteria
- A `Story.yaml` specification file is architecturally approved and has the `status:ready-for-decomposition` label on its corresponding Epic issue.
