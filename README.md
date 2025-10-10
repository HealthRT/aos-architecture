# Agency Operating System (AOS) - Architecture Repository

## 1. Project Vision

Welcome to the **Agency Operating System (AOS)** project. This repository is the **single source of truth** for the architecture, standards, and strategic direction of the entire AOS platform.

The AOS is a federated system composed of two primary applications:
-   **The Hub:** The administrative core for HR, compliance, and operations.
-   **The EVV:** A HIPAA-compliant system for patient care and scheduling.

## 2. Repository Purpose & Structure

This repository is the "external brain" and the "constitution" for the project. It does not contain application code, but rather the blueprints and rulebooks that govern that code.

The repository is organized into the following key directories:

### `/decisions`
Contains our formal **Architecture Decision Records (ADRs)**. These are the immutable laws of our project, documenting the *why* behind our most critical technical choices (e.g., authentication, multi-tenancy). **Start here to understand the foundational rules.**

### `/standards`
Contains our operational **rulebooks and guides**. These documents define *how* we build things consistently. This includes our Odoo coding standards, UI/UX principles, AI agent workflows, and labeling conventions.

### `/features`
Contains our high-level, strategic **Feature Briefs**. These documents describe the *what* and the architectural vision for new, large-scale modules or feature suites (e.g., EVV Scheduling, Ask IF).

### `/user_stories`
Contains the detailed, granular **user stories** that are derived from the Feature Briefs. These are the specific, actionable requirements that will be turned into work orders for our AI agents. The structure is `/[hub|evv]/[module]/[STORY_ID].md`.

### `/prompts`
Contains the official, version-controlled **onboarding prompts** for our specialized AI agents (e.g., Coder, UI/UX). These are the master instructions that define each agent's role and responsibilities.

### `/templates`
Contains our standardized templates for creating artifacts, such as the `work_order_template.md` that is used to dispatch tasks to Coder Agents.

### `/process_improvement`
Contains the `process-improvement.md` log file, which is our official, append-only record of feedback from our AI agents on how to improve our workflow.

