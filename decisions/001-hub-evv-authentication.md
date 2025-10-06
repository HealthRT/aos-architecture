2# 1. Hub-to-EVV Server Authentication

**Date:** 2025-10-06

**Status:** Accepted

## Context

We require a highly secure method for our two separate Odoo instances, the Hub (HR/Admin) and the EVV (HIPAA/Care), to communicate server-to-server. The EVV system needs to consume compliance data from the Hub, which is the source of truth. A simple static API key is not sufficient for an architecture that touches a HIPAA-regulated environment due to the risks of key leakage and the lack of a clear revocation process.

## Decision

We will use the **OAuth 2.0 Client Credentials flow** for all server-to-server authentication between the Hub and EVV instances.

- The **Hub** will act as the OAuth 2.0 Authorization Server. It will be responsible for issuing short-lived access tokens.
- The **EVV** system will act as the client. It will be responsible for securely storing a Client ID and Client Secret and using them to request access tokens from the Hub before making API calls.
- Communication will be restricted by scopes, starting with a `read:compliance` scope.

## Consequences

- **Positive:**
    - This is a modern, industry-standard, and highly secure protocol.
    - Access tokens are short-lived, drastically minimizing the risk of a compromised credential.
    - Access can be easily revoked at the server level (the Hub).
    - Scopes provide a granular level of access control.
- **Negative:**
    - This approach is more complex to implement initially compared to a static API key.
    - Development in both the `hub` and `evv` projects must now account for including OAuth 2.0 libraries and handling the token exchange flow.
    - A "development mode" bypass will be necessary for local and smoke testing environments to maintain development velocity.
