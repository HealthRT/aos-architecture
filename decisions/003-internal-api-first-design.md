# 3. API-First Design for Internal Modules

**Date:** 2025-10-07

**Status:** Accepted

## Context

Our long-term vision includes the development of sophisticated AI Assistants (e.g., the "Ask IF" module) that can interact with and perform actions across the entire Agency Operating System using natural language. For this to be feasible, the assistant needs a reliable and predictable way to interact with the core business logic of other modules (e.g., Scheduling, Time Off, Asset Management).

If each module's business logic is tightly coupled to its user interface (UI), the AI assistant would have no way to programmatically trigger actions like "submitting a time off request" without resorting to brittle screen-scraping or complex UI automation.

## Decision

We will enforce an **"API-First" design principle** for all new Odoo modules developed for the AOS project.

This means that the core business logic for any given module must be encapsulated in a clean, well-documented, and reusable set of internal Python functions (an "internal API"). The module's own user interface will be the first consumer of this internal API, but it must be designed to be callable by other systems.

**Example: Time Off Module**
-   Instead of placing the logic for submitting a time off request directly within a controller tied to a button click, the developer must create a core function like `submit_pto_request(employee, start_date, end_date, reason)`.
-   The button click controller will then simply call this function.
-   Later, the "Ask IF" AI assistant can be given a "tool" that *also* calls this exact same `submit_pto_request` function.

## Consequences

-   **Positive:**
    -   **Enables AI Integration:** This is the foundational decision that makes the AI Assistant vision achievable. It provides a clear, stable interface for AI tools to interact with the system's business logic.
    -   **Promotes Reusability:** Core logic is written once and reused by both the UI and other programmatic systems, reducing code duplication.
    -   **Improves Testability:** The core business logic can be tested independently of the user interface, leading to more robust and reliable unit tests.
    -   **Future-Proofs the System:** This architectural pattern makes it significantly easier to add new interfaces (e.g., a dedicated mobile app, new automated workflows) in the future without having to refactor existing modules.

-   **Negative:**
    -   **Slight Upfront Overhead:** Requires developers to be more deliberate in separating their business logic from their presentation layer. This may add a small amount of extra time to initial development but pays significant dividends in the long run.
