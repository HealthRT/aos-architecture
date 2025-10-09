# 8. Systemic Process Improvement

**Date:** 2025-10-08

**Status:** Accepted

## Context

Our development process is a "U-shaped" workflow, moving from high-level definition (planning) down to low-level implementation (coding) and back up. To create a self-improving system, we need formal feedback loops on both sides of this "U".

A "downstream" loop (from coders about their work orders) is not enough. We also need an "upstream" loop to allow the "makers" (Coder Agents) to provide feedback on the quality and feasibility of the "blueprints" (User Stories) they receive from the "planners" (Business Analyst Agents).

This must be a managed process to prevent instability and "prompt drift." Changes to our core process must be deliberate and data-driven.

## Decision

We will implement a **Bidirectional, Managed Feedback Loop** for systemic process improvement.

### 1. The "Downstream" Loop (Improving Implementation)

-   **Goal:** To improve the efficiency of the implementation phase by reducing "Discovery Tax," increasing "First-Pass Quality," and minimizing "Workflow Friction."
-   **Process:** Upon completing a work order, Coder, Tester, and DevOps agents must provide structured feedback on the clarity and completeness of their instructions.
-   **Recipient:** This feedback is intended to improve the quality of the **Work Order Template** and the Architect's decomposition process.

### 2. The "Upstream" Loop (Improving Definition)

-   **Goal:** To improve the quality of our requirements by catching technical ambiguities, infeasibilities, or missing details at the earliest possible stage.
-   **Process:** A new, mandatory **"Technical Review"** step is added to our workflow. Before a user story is approved for decomposition, it will be assigned to a Coder Agent with a `status:needs-technical-review` label. The Coder Agent's sole task is to review the story for technical clarity, feasibility, and completeness.
-   **Recipient:** This feedback is intended for the **Business Analyst Agent**. It provides the BA with the data needed to iteratively improve the quality and technical grounding of the user story *before* it becomes a work order.

### 3. The Management Framework (Applies to Both Loops)

1.  **Centralized Logging:** All feedback, both upstream and downstream, will be logged by the Executive Architect in `aos-architecture/process_improvement/process-improvement.md`. Each entry will be fully attributed.
2.  **Trend Analysis Before Action:** The Architect is responsible for analyzing this log for recurring patterns. **No action will be taken based on a single piece of feedback.**
3.  **Human-in-the-Loop Approval:** All proposed changes to our core processes or templates (e.g., the User Story template or the Work Order template) must be formally approved by the human overseer before being implemented.

## Consequences

-   **Positive:**
    -   **Creates a Full-System "Learning Loop":** We now have feedback mechanisms to improve both our planning and our execution.
    -   **Proactive Quality Control:** The "Technical Review" step is a proactive quality gate that catches requirement flaws before they become costly coding work.
    -   **Improves BA Performance:** Provides a direct feedback loop that will train the Business Analyst agent to create better, more technically sound user stories over time.
    -   **Reinforces Stability:** The "trend analysis before action" and "human-in-the-loop" principles are maintained, ensuring our process evolves deliberately.

-   **Negative:**
    -   **Adds a Step to the Workflow:** The "Technical Review" adds a new handoff to our user story definition phase. This is a deliberate trade-off of a small amount of upfront time to prevent a much larger amount of downstream rework.
