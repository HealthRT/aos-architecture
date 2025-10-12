# 13. Repository Boundaries & Module Placement

**Date:** 2025-10-12  
**Status:** Accepted  
**Supersedes:** None  
**Related:** ADR-001 (Hub-EVV Authentication), ADR-009 (Immutable Core Framework)

## Context

During Pre-UAT setup for AGMT-001 (2025-10-12), we discovered a critical architectural divergence: the EVV module `evv_agreements` had been contaminated into the Hub repository. Root cause analysis (Process Improvement Entry #009) revealed that while our federated architecture (Hub and EVV as separate instances) was documented in ADR-001, we had **no formal standard defining which modules belong in which repository**.

This gap allowed an agent to make a logical but architecturally incorrect decision when attempting to provide proof of execution. The agent found no `docker-compose.yml` in the `evv/` repository and used the workspace-level Docker environment (which mounted `hub/addons`), leading to module misplacement.

**The Missing Constraint:**
- ADR-001 defines Hub and EVV as separate Odoo instances ✅
- ADR-001 requires API-only communication between them ✅
- **No ADR defined which modules belong in which repository** ❌
- **No ADR defined how agents verify correct repository** ❌
- **No automated enforcement** ❌

This ADR formally establishes repository boundaries, module placement rules, and enforcement mechanisms to prevent recurrence.

## Decision

We will establish **strict repository boundaries** with the following rules:

### 1. Repository-Module Mapping (Immutable)

**Hub Repository** (`github.com/HealthRT/hub`)
- **Purpose:** Administrative, HR, and compliance management
- **Allowed Module Prefixes:**
  - `hub_*` (e.g., `hub_compliance`)
  - `traction*` (e.g., `traction_eos_odoo`)
- **Prohibited:** Any `evv_*` prefixed modules
- **Examples:**
  - ✅ `hub/addons/traction/`
  - ✅ `hub/addons/hub_compliance/`
  - ❌ `hub/addons/evv_agreements/` (VIOLATION)

**EVV Repository** (`github.com/HealthRT/evv`)
- **Purpose:** HIPAA-compliant care delivery, visit verification, billing
- **Allowed Module Prefixes:**
  - `evv_*` (e.g., `evv_agreements`, `evv_visits`)
- **Prohibited:** Any `hub_*` or `traction*` prefixed modules
- **Examples:**
  - ✅ `evv/addons/evv_agreements/`
  - ✅ `evv/addons/evv_visits/`
  - ❌ `evv/addons/hub_compliance/` (VIOLATION)

**AOS Architecture Repository** (`github.com/HealthRT/aos-architecture`)
- **Purpose:** Specs, ADRs, templates, work orders, process improvement
- **Contains:** No Odoo modules
- **Prohibited:** Any executable Odoo code

### 2. Agent Verification Requirements

Before starting any work, agents MUST:

1. **Verify Repository Identity:**
   ```bash
   git remote -v
   # Output must show correct repo: HealthRT/hub OR HealthRT/evv
   ```

2. **Verify Docker Environment:**
   ```bash
   pwd  # Must be in target repository root
   ls docker-compose.yml  # Must exist in target repo
   ```

3. **Document Verification in Proof of Execution:**
   ```markdown
   ## Repository Verification
   - Repository: [hub | evv]
   - Git Remote: [output of git remote -v]
   - Docker Config: [path to docker-compose.yml]
   ```

### 3. Automated Enforcement

**Pre-commit Hook** (applies to `hub/` and `evv/` repositories):
- **Script:** `scripts/validate-module-placement.sh`
- **Trigger:** Before every commit
- **Action:** Fails commit if:
  - EVV module (`evv_*`) detected in Hub repository
  - Hub module (`hub_*` or `traction*`) detected in EVV repository
  - Module in `addons/` directory doesn't follow naming convention

**Implementation Status:** Created as part of this ADR (see Consequences section).

### 4. Module Naming Convention

All custom Odoo modules MUST follow this naming pattern:

```
{system}_{domain}[_{component}]

Where:
- {system} = "hub" | "evv"
- {domain} = functional area (e.g., "agreements", "compliance", "visits")
- {component} = optional sub-component (e.g., "portal", "api")

Examples:
- evv_agreements (✅ EVV, Agreements domain)
- evv_visits_mobile (✅ EVV, Visits domain, Mobile component)
- hub_compliance_training (✅ Hub, Compliance domain, Training component)
- traction_eos_odoo (✅ Hub, Traction/EOS suite - grandfathered)
```

**Exceptions:**
- `traction*` modules are grandfathered (pre-date this ADR)
- Standard Odoo modules (no prefix) are allowed if they're from Odoo Community

### 5. Cross-Repository Collaboration

When a feature requires changes in both Hub and EVV:

**Pattern: API-First Design**
1. Define API contract in `aos-architecture/api/`
2. Implement API endpoints in one repository (typically Hub)
3. Implement API client in the other repository (typically EVV)
4. **Never share code** between repositories (no symlinks, no submodules)
5. **Never share databases** between instances (ADR-001)

**Example: Compliance Data Flow**
```
Hub (Source of Truth)
└── hub_compliance module
    └── /api/v1/staff/{id}/capabilities endpoint
        ↓ HTTP + OAuth 2.0
EVV (Consumer)
└── evv_scheduling module
    └── Calls Hub API to verify caregiver qualifications
```

### 6. Work Order Requirements

Every work order MUST include a **"Development Environment"** section:

```markdown
## Development Environment

**Target Repository:** [hub | evv]
**Target Module:** [module_name]
**Module Prefix:** [hub_* | evv_* | traction*]
**Docker Setup:**
- Navigate: `cd [repository_path]/`
- Verify: `git remote -v` (must show HealthRT/[repo])
- Start: `docker compose up -d`
- Access: `http://localhost:[8090 for hub | 8091 for evv]`

**Pre-Work Checklist:**
- [ ] Read `[repo]/README.md`
- [ ] Verified git remote shows correct repository
- [ ] Confirmed `docker-compose.yml` exists in repo root
- [ ] Confirmed module prefix matches repository
```

## Consequences

### Positive

1. **Prevents Architectural Violations:**
   - Automated enforcement catches module misplacement before commit
   - Impossible to accidentally contaminate repositories
   - Clear, unambiguous rules for agents and humans

2. **Improves Agent Clarity:**
   - Explicit verification steps in every work order
   - No guesswork about which repo to use
   - Documentation includes exact commands

3. **Maintains HIPAA Boundaries:**
   - EVV data (PHI) never crosses into Hub repository
   - Clear separation of concerns
   - Audit trail of what code exists where

4. **Enables Parallel Development:**
   - Module prefixes make ownership obvious at a glance
   - No collision risk when working on different systems
   - Enables concurrent Hub and EVV work streams

5. **Facilitates Onboarding:**
   - New developers/agents immediately understand boundaries
   - README files in each repo provide quick start
   - Naming convention is self-documenting

### Negative

1. **Adds Verification Overhead:**
   - Agents must run verification commands before starting
   - Work orders are longer (Development Environment section)
   - *Mitigation:* Templates automate most of this

2. **Requires Git Hook Setup:**
   - Each developer must have pre-commit hooks installed
   - Requires coordination during onboarding
   - *Mitigation:* Document in each repo's README

3. **Module Renaming May Be Needed:**
   - Existing modules that don't follow convention need renaming
   - Requires database migration
   - *Mitigation:* Grandfather existing modules, enforce for new ones

4. **Stricter Process:**
   - Less flexibility for "quick fixes"
   - Must follow formal process even for small changes
   - *Mitigation:* Prevents technical debt and violations

## Implementation

### Phase 1: Immediate (Completed with this ADR)

1. ✅ **ADR-013 Created** (this document)
2. ✅ **Pre-commit Hook Script:** `aos-architecture/scripts/validate-module-placement.sh`
3. ✅ **Installation Instructions:** Added to Hub and EVV README files
4. ✅ **Coder Agent Primer Updated:** Section 2.1 added (completed in Entry #009)

### Phase 2: Integration (To be completed)

5. ⏳ **Work Order Template Updated:** Add Development Environment section
6. ⏳ **Scrum Master Primer Updated:** Require Development Environment in all WOs
7. ⏳ **Install hooks in Hub repo:** Run hook setup script
8. ⏳ **Install hooks in EVV repo:** Run hook setup script

### Phase 3: Monitoring (Ongoing)

9. ⏳ **Track violations:** Log any hook failures to process improvement
10. ⏳ **Refine rules:** Adjust based on real-world usage
11. ⏳ **Audit existing modules:** Verify compliance, rename if needed

## Validation Script

The validation script (`scripts/validate-module-placement.sh`) will be installed in each repository's Git hooks and will run automatically before every commit.

**See:** `aos-architecture/scripts/validate-module-placement.sh` (created with this ADR)

## Related Documentation

- **ADR-001:** Hub-EVV Authentication (defines separate instances)
- **ADR-009:** Immutable Core Framework (governance structure)
- **ADR-014:** Parallel Agent Coordination (work assignment patterns)
- **Process Improvement Entry #009:** Multi-repo Docker confusion incident
- **Hub README:** `hub/README.md`
- **EVV README:** `evv/README.md`
- **Workspace README:** `/README.md`

## Revision History

- **2025-10-12:** Initial version (v1.0) - Established after Entry #009 incident

---

**This ADR is part of Ring 1 (Protected Layer) per ADR-009 Immutable Core Framework.**

