# 5. EVV-to-Hub Signal Emission

**Date:** 2025-10-07

**Status:** Proposed

## Context

The Employee Experience Suite, which includes our AI-driven retention and engagement modules, resides in the Hub. For this system to be effective, it needs to analyze a wide range of behavioral and operational signals, many of which are generated within the EVV system (e.g., workload, scheduling patterns, overtime).

Our core architecture prohibits the Hub from directly accessing the EVV's database. Therefore, we require a formal, secure, and one-way communication channel for the EVV to send this data to the Hub.

## Decision

We will establish a formal **"Signal Emission"** data flow from the EVV to the Hub.

1.  **Communication Channel:** The EVV will send signals to the Hub via a new, dedicated API endpoint: `POST /api/v1/signals`. Communication will be secured via OAuth 2.0 and will require a specific `write:signals` scope.
2.  **One-Way Data Flow:** This is a strictly one-way, "fire-and-forget" communication path. The EVV is the producer of signals; the Hub is the consumer. The Hub will never query the EVV for this data.
3.  **No PHI:** It is a strict requirement that **no Protected Health Information (PHI)** or any sensitive patient data is ever transmitted through this channel. Signals must be limited to anonymized or employee-centric behavioral data (e.g., `employee_id: 123` worked `hours: 45`).
4.  **Asynchronous Processing:** The Hub will acknowledge receipt of the signal immediately (`202 Accepted`) and will process it asynchronously via a background job. The EVV will not wait for the processing to be complete.

## Consequences

-   **Positive:**
    -   **Enables Retention Engine:** This decision makes the AI-driven retention and engagement features possible by providing them with a rich, near-real-time data source.
    -   **Maintains Decoupling:** It respects our federated architecture by using a formal API contract rather than allowing direct database access, keeping the two systems decoupled.
    -   **Secure and Compliant:** By explicitly prohibiting PHI and using our standard OAuth security, the interface is designed to be secure and compliant.

-   **Negative:**
    -   **Increased Network Traffic:** This introduces a new source of network communication between our two primary systems.
    -   **Implementation Overhead:** The EVV system must now be modified to identify significant events and emit the corresponding signals. The Hub must implement the endpoint and the asynchronous processing logic.
