# 8. Managed Process Improvement Loop

**Date:** 2025-10-08

**Status:** Accepted

## Context

Our development process is executed by AI agents. To improve the efficiency and quality of their output over time, we need a formal mechanism for them to provide feedback on our workflow. However, acting on every piece of individual feedback would be chaotic and lead to "prompt drift" and process instability.

We require a managed, data-driven system to collect feedback, identify trends, and make deliberate, strategic improvements to our development process.

## Decision

We will implement a **Managed Feedback Loop** for process improvement.

1.  **Goal-Oriented Feedback:** The goal of this process is to systematically reduce waste. We will target three key metrics:
    *   **"Discovery Tax"**: The time and tool calls an agent wastes discovering the context of a task.
    *   **"First-Pass Quality"**: The percentage of work that is approved on its first submission without rework.
    *   **"Workflow Friction"**: The number of blockers related to tooling and environment.

2.  **Structured Feedback Prompt:** All Coder Agents will be given a standing order to answer three specific questions upon task completion, targeting the goals above (Context, Clarity, and Efficiency).

3.  **Centralized Logging:** All feedback will be logged by the Executive Architect in a single, structured document located at `aos-architecture/process_improvement/process-improvement.md`. Each log entry will be fully attributed with the date, source agent (model and role), and the source task.

4.  **Trend Analysis Before Action:** The Architect is responsible for analyzing this log to identify recurring patterns and trends. **No action will be taken based on a single piece of feedback.** Changes to our core process (e.g., updating the `work_order_template.md`) will only be proposed after a clear trend has been established from multiple data points.

5.  **Human-in-the-Loop Approval:** All proposed changes to the core process must be formally approved by the human overseer before being implemented.

## Consequences

-   **Positive:**
    -   **Creates a "Learning" System:** Turns our development process into a self-improving virtuous cycle.
    -   **Data-Driven Decisions:** Ensures that changes to our workflow are based on evidence and patterns, not on the whim of a single agent's feedback.
    -   **Process Stability:** Prevents "prompt drift" and over-iteration by creating a formal review and approval gate for all process changes.
    -   **Quantifiable Improvement:** The structured feedback allows us to measure and track our key efficiency metrics over time.

-   **Negative:**
    -   **Manual Overhead:** The Architect has the manual responsibility of logging and analyzing the feedback. (This is a worthwhile trade-off for process stability).
    -   **Delayed Implementation:** A valid process improvement might be suggested but will not be implemented until a trend is established. This is a deliberate choice to prioritize stability over reactive changes.
