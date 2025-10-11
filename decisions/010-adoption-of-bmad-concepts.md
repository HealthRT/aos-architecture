# 10. Adoption of BMAD-METHOD™ Concepts

**Date:** 2025-10-09

**Status:** Accepted

## Context

During our research, we have identified an open-source project, **BMAD-METHOD™**, which is a mature, opinionated methodology for agentic software development. Its core principles are highly aligned with the workflow we have been developing organically for the AOS project.

Adopting key terminology and role definitions from this established methodology will provide significant benefits, including:
-   **Clarity:** Using a standard, industry-recognized vocabulary makes our process easier to understand for new participants (both human and AI).
-   **Structure:** It provides a formal structure for roles and phases that we have been performing implicitly.
-   **Validation:** It validates that our architectural direction is consistent with best practices in the wider agentic development community.

## Decision

We will formally adopt the following concepts and terminology from the BMAD-METHOD™ into our own AOS workflow. This is an upgrade of our vocabulary, not a replacement of our custom architecture.

1.  **"Agentic Planning" Phase:** Our "Strategic Phase" or "Definition Phase" will now be formally referred to as **Agentic Planning**. This phase encompasses all activities from high-level ideation to the creation of detailed, technically-vetted user stories.

2.  **"Context-Engineered Development" Phase:** Our "Implementation Phase" will now be formally referred to as **Context-Engineered Development**. This phase encompasses all activities from the decomposition of a user story into Work Orders to the final merge of tested code.

3.  **"Scrum Master" Agent Role:** We are formalizing the role of the agent responsible for decomposing user stories into "hyper-detailed" Work Orders. This role will be known as the **Scrum Master Agent**. The Executive Architect will perform this role initially, but it is now a distinct, defined role that can be assigned to a specialized agent in the future.

4.  **"Expansion Packs":** The term for our optional, licensable, add-on modules (as defined in ADR-007) will now be **Expansion Packs**. This is a more user-friendly and commercially-oriented term.

## Consequences

-   **Positive:**
    -   Improves the clarity and professionalism of our documentation and communication.
    -   Provides a clearer, more scalable definition of roles within our agentic team.
    -   Aligns our project with a recognized methodology, which can aid in future onboarding and interoperability.

-   **Negative:**
    -   Requires a one-time effort to update our existing documentation (e.g., `COMPLETE_WORKFLOW_END_TO_END.md`, ADR-007) to reflect the new terminology.
