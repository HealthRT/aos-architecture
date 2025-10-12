# Agency Operating System (AOS) - User Guide

**Last Updated:** 2025-10-12  
**Version:** 2.0 (Post-Reorganization)

---

## 1. Project Vision

Welcome to the **Agency Operating System (AOS)** project. This repository is the **single source of truth** for the architecture, standards, and strategic direction of the entire AOS platform.

The AOS is a federated system composed of two primary applications:
-   **The Hub:** The administrative core for HR, compliance, and operations.
-   **The EVV:** A HIPAA-compliant system for patient care and scheduling.

---

## 2. The AOS-BMAD Hybrid Framework

The AOS project follows a custom workflow that is philosophically aligned with the **BMAD-METHOD™**, an open-source methodology for agentic software development. We have formally adopted key concepts from BMAD to structure our process.

Our workflow is divided into two main phases:

1.  **Agentic Planning:** The strategic phase where humans and specialist AI agents (Architect, Business Analyst) collaborate to define the *what* and the *why* of the features we build. The output of this phase is a set of architecturally-vetted user stories.
2.  **Context-Engineered Development:** The tactical phase where a **Scrum Master Agent** decomposes the approved user stories into "hyper-detailed" Work Orders. Specialist Coder, Tester, and DevOps agents then execute these work orders to build, validate, and deploy the software.

This guide serves as the master reference for this entire end-to-end process.

---

## 3. Repository Purpose & Structure

This repository is the "external brain" and the "constitution" for the project. It is the central hub for our **Agentic Planning** phase. It does not contain application code, but rather the blueprints and rulebooks that govern that code.

**For detailed governance:** See `/standards/00-repository-structure-governance.md`

The repository is organized into the following key directories:

### `/decisions` - Architecture Decision Records (ADRs)
Contains our formal **Architecture Decision Records (ADRs)**. These are the immutable laws of our project, documenting the *why* behind our most critical technical choices (e.g., authentication, multi-tenancy). 

**Start here to understand the foundational rules.**

**Examples:**
- ADR-001: Hub-EVV Authentication
- ADR-009: Immutable Core Framework
- ADR-013: Repository Boundaries and Module Placement
- ADR-015: Test Environment Isolation

---

### `/standards` - Operational Standards & Guidelines
Contains our operational **rulebooks and guides**. These documents define *how* we build things consistently. This includes our Odoo coding standards, UI/UX principles, AI agent workflows, and labeling conventions.

**Key Standards:**
- Standard 00: Repository Structure Governance
- Standard 01: Odoo Coding Standards
- Standard 03: AI Agent Workflow
- SPEC_COMPLIANCE.md
- TESTING_STRATEGY.md
- PRE_COMMIT_HOOKS.md

---

### `/specs` - Feature Specifications (YAML)
Contains our **Story Specifications** in a structured `YAML` format. These are the definitive, machine-readable "contracts" for all new features, derived from the `STORY.yaml.tpl` template. This is the new primary artifact for feature definition.

**Structure:**
```
/specs/
├── evv/           ← EVV system specs
│   └── AGMT-001.yaml
└── hub/           ← Hub system specs
    └── traction/
```

**See:** `/specs/README.md` for full details on spec format and lifecycle.

---

### `/features` - Feature Briefs
Contains our high-level, strategic **Feature Briefs**. These documents describe the *what* and are the primary input for the Business Analyst to create the detailed `YAML` specs.

**Structure:**
```
/features/
├── evv/
│   └── service-agreement-management/
│       ├── 01-feature-brief.md
│       └── reference/ (samples, examples)
└── hub/
    └── traction/
```

---

### `/work_orders` - Executable Work Orders
Contains hyper-detailed, executable tasks for Coder Agents. Each work order is bootable, testable, and independent.

**Structure:**
```
/work_orders/
├── evv/
│   └── AGMT-001/
│       ├── WO-AGMT-001-01.md
│       └── TRACKING.md
├── hub/
├── dispatched/    ← Active work sent to agents
└── pending/       ← Decomposed but not yet assigned
```

**See:** `/work_orders/README.md` for work order lifecycle and quality standards.

---

### `/prompts` - Agent Onboarding Primers
Contains the official, version-controlled **onboarding prompts** for our specialized AI agents (e.g., Coder, Scrum Master, Business Analyst). These are the master instructions that define each agent's role and responsibilities.

**Rule:** ONE file per role, NO version numbers in filenames. Version numbers are in the file headers.

**Current Primers:**
- `onboarding_coder_agent.md` (v3.0)
- `onboarding_scrum_master.md`
- `onboarding_business_analyst.md`
- `onboarding_ui_ux_agent.md`
- `onboarding_architect_hub.md`
- `onboarding_github_coach.md`
- `onboarding_document_retrieval_agent.md`

**Core Principles:** `prompts/core/00_NON_NEGOTIABLES.md` (Ring 0 - Immutable)

**See:** `/prompts/README.md` for complete list and onboarding guide.

---

### `/templates` - Document Templates
Contains our standardized templates for creating artifacts, such as the `work_order_template.md` that is used to dispatch tasks to Coder Agents.

**Current Templates:**
- `work_order_template.md`
- `dispatch_brief_template.md`
- `pre-uat-check-template.md`

---

### `/docs/reference` - External Reference Materials
Contains our structured reference documentation library for external materials (government regulations, API specs, validation rules) that inform AOS development.

**Categories:**
- `regulatory/` - Government regulations (HIPAA, Minnesota DHS)
- `api-specs/` - Third-party API documentation (Gusto, county systems)
- `validation-rules/` - Business logic from external authorities

**See:** `docs/reference/INDEX.md` and `docs/REFERENCE_LIBRARY_GUIDE.md` for complete usage guide.

---

### `/process_improvement` - Feedback & Lessons Learned
Contains the `process-improvement.md` log file, which is our official, append-only record of feedback from our AI agents on how to improve our workflow.

**Also contains:**
- Detailed analysis entries (e.g., `entry_010_boot_test_wrong_environment.md`)
- Bug analysis documents
- Decomposition logs

**This is the learning loop** that drives continuous improvement.

---

### `/bugs` - Active Bug Tracking
Contains active bug tickets and repair instructions for agents.

**Naming Convention:** `BUG-NNN-brief-description.md`

**Example:**
- `BUG-001-xml-syntax-error-service-agreement-views.md`
- `BUG-001-REPAIR-INSTRUCTIONS.md`

**Lifecycle:** Bugs remain here even after resolution, with status updated.

---

### `/testing` - Pre-UAT Test Plans
Contains Pre-UAT test plans and manual test checklists used before formal User Acceptance Testing.

**Structure:**
```
/testing/
└── pre-uat-checks/
    └── AGMT-001-service-agreement-pre-uat.md
```

**Created By:** Tester Agent (from spec acceptance criteria)

---

### `/sessions` - Historical Archives
Contains historical archive of development session summaries, decisions, and ephemeral documents.

**Structure:**
```
/sessions/
├── 2025-10-11/
│   ├── evv-agmt-001-session-summary.md
│   └── dispatches/
└── 2025-10-12/
    └── strategy-docs/
```

**Purpose:** Historical reference for process improvement and "what did we do when?"

**See:** `/sessions/README.md` for archiving guidelines.

---

### `/user_stories` (DEPRECATED)
This directory contains our legacy, prose-based user stories. All new work is defined in the `/specs` directory (YAML format). This directory will be archived in the future.

