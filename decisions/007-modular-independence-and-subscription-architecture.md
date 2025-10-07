# 7. Modular Independence and Subscription Architecture

**Date:** 2025-10-07

**Status:** Accepted

## Context

The long-term business model for the Agency Operating System (AOS) involves the potential to license certain modules as optional, paid add-ons. This requires an architecture that allows us to dynamically include or exclude features for different customers without breaking the core application.

A traditional approach using hard dependencies (e.g., adding a module to another's `depends` list in the Odoo manifest) is too rigid. If `Module B` has a hard dependency on `Module A`, `Module B` will crash if a customer has not purchased `Module A`. This would create a maintenance nightmare and prevent a flexible, "à la carte" business model.

## Decision

We will adopt an architectural principle of **"Modular Independence"** for all new module development. Modules will be designed as loosely-coupled components that interact via a **"Subscription"** or **"Event-Driven"** pattern, rather than as tightly-coupled dependencies.

1.  **"Core vs. Add-on" Designation:** Every new feature or module will be designated as either "Core" (provided to all tenants) or "Add-on" (optional). This will be a mandatory field in all Feature Briefs.
2.  **The Subscription Pattern:** A "Core" module must never have a hard dependency on an "Add-on" module. Instead, the Core module will "broadcast" events or provide extension points (clean internal APIs as per ADR-003). An Add-on module can then "subscribe" or "listen" for these events to add its functionality.
3.  **Graceful Degradation:** If an Add-on module is not installed, the Core module must continue to function perfectly. The system will not crash; the enhanced functionality will simply be absent. User interfaces must also be designed to gracefully hide elements that rely on an uninstalled Add-on.

**Example: Compatibility Matching**
- The core `evv_scheduling` engine will find a list of qualified DSPs.
- It will then broadcast an event: `"candidate_list_created"`, passing the list of candidates.
- If the `compatibility_matching` add-on is installed, it listens for this event, runs its scoring logic, re-ranks the list, and passes the modified list back.
- If the add-on is *not* installed, no one listens to the event, and the core engine proceeds with the original, un-ranked list.

## Consequences

-   **Positive:**
    -   **Enables Business Flexibility:** This is the foundational decision that makes a "Core + Add-ons" business model possible. It allows the business to package and price features without requiring architectural changes.
    -   **Promotes Decoupling:** Enforces a clean separation of concerns between modules, making the entire system more robust, maintainable, and easier to test.
    -   **Improved Resilience:** The system is more resilient to failure. A bug in an optional Add-on module is far less likely to crash the Core application.

-   **Negative:**
    -   **Increased Development Discipline:** Requires a more sophisticated approach from developers (and AI Coders), who must consciously design for this subscription pattern instead of taking the simpler path of adding a hard dependency.
    -   **More Complex Testing Strategy:** Our CI/CD pipelines will need to be more advanced, with test runs that validate the Core platform in isolation, as well as test runs for various combinations of Core + Add-ons.
