# 2. Environment Variable Configuration

**Date:** 2025-10-06

**Status:** Accepted

## Context

To align with our "Code for Production, Configure for the Environment" principle, we need a standardized method for managing application settings that vary between environments (e.g., local Docker, UAT, Production). This includes sensitive data like API secrets, external service URLs, and feature flags. Hardcoding these values into the codebase would create significant technical debt and security vulnerabilities, making future deployments complex and risky.

## Decision

We will use **environment variables** as the exclusive method for providing all environment-specific configuration to both the Hub and EVV Odoo applications.

- All configuration that changes between deployments—such as database connections, API endpoints, credentials, and security feature flags—must be injectable via the environment.
- Odoo's native `odoo.conf` file will be configured to read these values from the environment.
- Hardcoding environment-specific values in the Python code is strictly prohibited. For local development, a template `.env.template` file should be provided in each repository to guide developers on the required variables.

## Consequences

- **Positive:**
    - **Enhanced Security:** Secrets and credentials are never stored in the Git repository, mitigating the risk of accidental exposure.
    - **Improved Portability:** The application is decoupled from its configuration, making it easy to deploy in new environments without code changes. This aligns with Twelve-Factor App principles.
    - **Simplified CI/CD:** Deployment pipelines can easily inject the appropriate variables for staging, UAT, and production environments.
    - **Clarity for AI Agents:** Provides a clear and unambiguous rule for AI coders on how to handle configuration, reducing the chance of them hardcoding values.

- **Negative:**
    - **Management Overhead:** Each environment (local, UAT, production) will require its own mechanism for managing and injecting these variables. For local development, this will be handled via `.env` files.
    - **Discovery:** Developers and AI agents must be able to discover which environment variables are required for the application to run correctly. The `.env.template` file will serve as the primary documentation for this.
