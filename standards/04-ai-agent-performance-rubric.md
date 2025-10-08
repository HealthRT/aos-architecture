# 4. AI Agent Performance Rubric

**Status:** Accepted
**Author:** Executive Architect
**Date:** 2025-10-07

## 1. Purpose

This document defines the formal criteria for evaluating the performance of AI Coder Agents working on the Agency Operating System (AOS) project. Its purpose is to provide a consistent and transparent framework for "bake-offs" and ongoing quality assessment.

All agents assigned a task should expect their output to be judged against these four key pillars. This rubric should be referenced in prompts given to agents to ensure they have a clear understanding of the requirements for a high-quality response.

## 2. Evaluation Criteria

### 2.1. File System Accuracy & Grounding

-   **Description:** The agent's ability to correctly interpret, locate, and use files and directories within the project workspace.
-   **High-Quality Response:** The agent uses the precise file paths provided in prompts or documentation. It does not "hallucinate" or guess the location of critical files like ADRs or standards documents.
-   **Low-Quality Response:** The agent fails to find files, invents incorrect paths, or requires manual correction to locate its source material.

### 2.2. Architectural Comprehension

-   **Description:** The agent's ability to understand and correctly apply the project's formal architectural principles (as defined in the `/decisions` and `/standards` directories).
-   **High-Quality Response:** The agent's analysis or generated code explicitly and correctly references the relevant ADRs. It demonstrates *understanding* by explaining how its work complies with a principle (e.g., "This design uses a separate function to be API-First, as per ADR-003.").
-   **Low-Quality Response:** The agent ignores the architectural standards, misinterprets them, or mentions them generically without demonstrating actual application.

### 2.3. Code Analysis Depth

-   **Description:** When analyzing existing code, the agent's ability to move beyond a superficial summary and provide deep, meaningful insights into the code's structure, quality, and patterns.
-   **High-Quality Response:** The agent identifies specific Odoo patterns (e.g., use of `api.depends`, controller routing), points out potential bugs or performance issues, and reasons about the overall design of the module.
-   **Low-Quality Response:** The agent simply lists the files and models it found without providing any deeper analysis of *how* the code works or how well it is written.

### 2.4. Actionable & Insightful Recommendations

-   **Description:** The agent's ability to act as a proactive partner by providing valuable, context-aware suggestions that align with the project's strategic goals.
-   **High-Quality Response:** The agent's recommendations are specific, creative, and directly tied to our documented future plans (e.g., suggesting specific "seams" for integrating with the Employee Experience suite). The recommendations help us move forward.
-   **Low-Quality Response:** The agent's recommendations are generic ("follow best practices"), obvious, or not relevant to the specific context of the AOS project.
