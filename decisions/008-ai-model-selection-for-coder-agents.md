# 8. AI Model Selection for Coder Agents

**Date:** 2025-10-07

**Status:** Accepted

## Context

The Agency Operating System (AOS) project relies on AI Coder Agents to perform analysis and development tasks. The quality and reliability of these agents are critical to the project's success. To ensure we are using the most capable models, we conducted a formal "bake-off" evaluation.

Multiple AI models were given the same complex task: to analyze the pre-existing `Traction` Odoo modules and produce a detailed report assessing their quality and compliance with our project's specific architectural standards.

## Decision

Based on a formal evaluation against the criteria in our **`04-ai-agent-performance-rubric.md`**, we have made a decisive selection for our primary Coder Agents.

1.  **Top-Tier Selection:** The **Claude 4.5 Sonnet** and **GPT-5 Codex** models demonstrated a superior, architect-level ability to comprehend our specific architectural principles, identify critical flaws, and provide insightful, strategic recommendations. These models are approved for all primary development and analysis tasks.

2.  **Tier 2 (Not for Primary Use):** Other models tested (including Gemini 2.5 Pro, Claude 4 Sonnet, Grok, and DeepSeek) performed the task at a lower level of architectural comprehension. While capable of summarizing code, they consistently failed to identify the most critical, blocking architectural violations, and in some cases provided dangerously incorrect assessments. These models are not approved for primary architectural analysis or refactoring tasks.

This decision is not about brand, but about demonstrated capability on a real-world project task. Future models can be evaluated against the same rubric to determine their suitability.

## Consequences

-   **Positive:**
    -   **Increased Quality & Reliability:** By selecting agents that have proven their ability to understand and apply our architecture, we significantly increase the quality of the first draft of code and reduce the number of review cycles.
    -   **Improved Velocity:** Using more capable agents allows us to operate at a higher level of abstraction, reducing the need for micro-management and correction.
    -   **Formalized Standard:** We now have a formal process (the bake-off against the rubric) for evaluating and selecting the best tools for our project.

-   **Negative:**
    -   **Potential Cost:** The top-tier models may have a higher operational cost. This is a deliberate trade-off of cost for quality and velocity.
    -   **Model Dependency:** We are dependent on the continued availability and performance of these specific, high-end models.
