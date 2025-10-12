# 07: Technical Architecture Overview

**Status:** Live
**Author:** Executive Architect
**Last Updated:** 2025-10-12

## 1. Purpose

This document provides a consolidated, high-level overview of the technical stacks, patterns, and automated governance functions for the Agency Operating System (AOS) project. It is intended to be the "single source of truth" for the approved technical landscape.

## 2. Core Technology Stack

All new development must be compatible with the following core stack:

-   **Backend Framework:** Odoo 18.0 Community Edition
-   **Primary Language:** Python 3.11+
-   **Database:** PostgreSQL 15+ (managed via the Odoo ORM)
-   **Frontend Framework:** Owl.js (Odoo's native framework)
-   **Environment:** Docker / Docker Compose

## 3. Architectural Patterns & Communication

Our architecture is governed by the ADRs in the `/decisions` directory. The key, system-wide patterns are:

-   **Communication Style:**
    -   **Cross-System (Hub <-> EVV):** Synchronous, RESTful APIs, formally defined in OpenAPI 3.0 specifications.
    -   **Intra-System (Internal Modules):** A combination of direct, internal API calls (as per ADR-003) for tightly coupled logic, and an asynchronous, event-driven model using the Odoo Bus (`bus.bus`) for loosely coupled "subscription" patterns (as per ADR-007).
-   **Core Principles:**
    -   **Federated Model (ADR-001):** Strict separation of Hub and EVV.
    -   **API-First Design (ADR-003):** Business logic must be decoupled from the UI.
    -   **Hard Multi-Tenancy (ADR-006):** The target architecture for commercial deployment is physically isolated instances.
    -   **Modular Independence (ADR-007):** Modules should be designed as loosely-coupled "Expansion Packs."

## 4. Automated Architectural Governance

This section tracks the status of our automated "architectural fitness functions." It defines which of our architectural principles are automatically enforced by our tooling.

-   `[✅ Implemented]` **Immutable Core Protection:**
    -   **Mechanism:** `husky` pre-commit hook.
    -   **Function:** Blocks any commit that attempts to modify files within the `/prompts/core/` directory.

-   `[✅ Planned]` **Repository Boundary Enforcement:**
    -   **Mechanism:** A future CI/CD script.
    -   **Function:** Will prevent `evv_*` modules from being committed to the `hub` repository, and vice-versa.

-   `[✅ Planned]` **Specification Compliance:**
    -   **Mechanism:** The `compare-spec-to-implementation.py` script, to be run in a future CI/CD pipeline.
    -   **Function:** Will validate that the implemented Odoo models (field names, types) exactly match the approved `Story.yaml` specification.

-   `[❌ Not Planned for MVP]` **Automated PHI Leakage Detection:**
    -   **Mechanism:** Advanced static analysis tools (e.g., Semgrep with custom rules).
    -   **Function:** Would automatically scan for code patterns that might leak PHI into logs or other insecure contexts. This is a post-MVP goal.
