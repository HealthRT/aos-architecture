# 6. Multi-Tenancy Strategy

**Date:** 2025-10-07

**Status:** Accepted

## Context

The long-term vision for the Agency Operating System (AOS) is to offer it as a commercial, Software-as-a-Service (SaaS) product to other agencies. This requires a formal architecture for managing multiple customers ("tenants") in a secure and scalable way. A poor choice here could lead to catastrophic data breaches, poor performance, and unsustainable operational costs.

We have considered two primary models:
1.  **Soft Multi-Tenancy:** A single, shared application and database where tenant data is separated by a software flag (e.g., `company_id`).
2.  **Hard Multi-Tenancy (Hard Isolation):** A completely separate and independent application stack (Odoo container, database container) for each tenant.

## Decision

Given the extreme sensitivity of the data (HIPAA, PII) and the need for high security and performance isolation, we will adopt a phased approach that culminates in a **Hard Multi-Tenancy** architecture.

1.  **Phase 1 (Internal MVP):** For our initial internal use at Inclusion Factor, we will build for a **Single-Tenant** architecture. The code, however, must be written to be **"tenancy-aware."** This means it must not contain hardcoded, tenant-specific values (e.g., company names, IDs) and must be architected in a way that would not prevent a future transition to a multi-tenant model.

2.  **Phase 2 (First Commercial Customer & Beyond):** From the very first external customer, we will exclusively use a **Hard Multi-Tenancy** model. Each tenant will receive their own fully isolated application and database stack.

The operational overhead of managing this "fleet" of instances will be mitigated through a heavy investment in DevOps automation for provisioning, deployment, and monitoring. Soft multi-tenancy is explicitly prohibited for any production environment hosting external customer data due to the unacceptable security risks.

## Consequences

-   **Positive:**
    -   **Maximum Security & Compliance:** Hard isolation is the gold standard for security and eliminates the risk of cross-tenant data leakage at the application layer, which is critical for HIPAA.
    -   **Performance Isolation:** The "noisy neighbor" problem is completely avoided. One tenant's high usage has no impact on others.
    -   **High Customizability:** Allows for tenant-specific customizations and integrations in the future.
    -   **Pragmatic Rollout:** The single-tenant MVP approach allows us to develop and validate the core application quickly and cheaply before investing in the more complex DevOps automation required for the commercial product.

-   **Negative:**
    -   **Higher Upfront Cost for SaaS:** The commercial product will have a higher baseline infrastructure cost per tenant.
    -   **Significant DevOps Investment Required:** A Hard Multi-Tenancy model is not viable without a significant upfront investment in building an automated provisioning and deployment pipeline. This is a prerequisite for launching the commercial product.
    -   **Complex Code Maintenance for SaaS:** Updating the commercial product will require deploying the new code to every single tenant instance, which demands a robust, automated deployment system.
