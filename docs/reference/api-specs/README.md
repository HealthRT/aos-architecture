# External API Specifications

This directory contains technical documentation for third-party APIs that AOS integrates with.

---

## 📁 Subdirectories

### `gusto/` - Gusto Payroll & HR API
Gusto API documentation for payroll, employee management, and time tracking integration.

**Relevance:** Per ADR-004, Gusto is the source of truth for employee data. Hub syncs employee records from Gusto.

**Key Documents:**
- Gusto API v1 Specification - *Pending*
- Authentication & OAuth flow - *Pending*
- Webhook documentation - *Pending*

**Referenced by:**
- ADR-004 (Gusto as Employee Source of Truth)
- Future Hub employee sync features

**Integration Points:**
- Hub employee onboarding
- Hub payroll processing
- Hub blended overtime calculations

---

### `county-systems/` - County Integration Specifications
APIs and data exchange formats for county case management systems.

**Relevance:** Service authorizations come from county systems; results/claims may be submitted back.

**Key Documents:**
- Hennepin County API - *Pending*
- Ramsey County SFTP Specification - *Pending*
- Generic county data exchange format - *Pending*

**Referenced by:**
- Future EVV service authorization import features
- Future EVV claims submission features

**Integration Points:**
- Service agreement import (automated vs. manual entry)
- Claims/billing submission
- Authorization status updates

---

## 📋 Adding API Documentation

### Preferred Format
**OpenAPI/Swagger YAML** when available:
- Structured, machine-readable
- Can generate client code
- Clear schema definitions

**Markdown** for non-OpenAPI docs:
- Convert vendor docs to clean markdown
- Include examples and use cases
- Note authentication requirements

### What to Include
For each API:
1. **Authentication:** How to authenticate (OAuth, API keys, etc.)
2. **Base URLs:** Production, staging, sandbox environments
3. **Endpoints:** Document all endpoints AOS uses
4. **Rate Limits:** Request throttling, quotas
5. **Webhooks:** If API pushes data to us
6. **Error Codes:** How to handle failures
7. **Versioning:** API version strategy
8. **Support:** Where to get help

### After Upload
1. Create `[vendor]/README.md` with:
   - API version
   - Date obtained
   - Which AOS features use it
   - Authentication setup notes
   - Known limitations
2. Update this README
3. Update parent INDEX.md
4. Reference in relevant ADRs

---

## 🔗 Cross-References

### ADRs Defining Integration Strategy
- **ADR-003:** API-First Design (how we build internal APIs)
- **ADR-004:** Gusto as Employee Source of Truth
- Future ADRs for county system integrations

### Features Using External APIs
- **Hub Employee Sync** → Gusto API
- **Hub Payroll Processing** → Gusto API
- **EVV Service Authorization Import** → County APIs (future)
- **EVV Claims Submission** → County APIs (future)

---

## ⚠️ Important Notes

### API Keys & Credentials
**DO NOT store API keys, tokens, or credentials in this directory.**

- Document HOW to authenticate (process)
- Do NOT document WHAT the actual keys are
- Actual credentials belong in environment variables (per ADR-002)

### API Versioning
APIs change over time:
1. Keep multiple versions if we support multiple API versions
2. Name files with version: `gusto-api-v1.yaml`, `gusto-api-v2.yaml`
3. Document breaking changes in vendor README
4. Plan migration strategy before upgrading

### Vendor Terms of Service
Some API docs may be proprietary:
- Check vendor TOS before uploading
- May need to reference external URL instead
- Note license restrictions in vendor README

---

**Last updated:** 2025-10-11

