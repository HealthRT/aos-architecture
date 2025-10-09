# 5. Automation and Labeling Standards

**Status:** Accepted
**Author:** Executive Architect
**Date:** 2025-10-08

## 1. Purpose

This document is the single source of truth for the operational tags and identities used in our automated development workflow. Its purpose is to ensure that all team members (human and AI) use a consistent, predictable, and organized system for routing tasks and managing status in GitHub.

## 2. Agent Roster

This section defines the official GitHub user handles and roles for all AI agents participating in the AOS project. Background agents will be configured to "listen" for issues assigned to their specific handle.

| Agent GitHub Handle | Role                | Responsibilities                                                                        | Primary Repository |
| :------------------ | :------------------ | :-------------------------------------------------------------------------------------- | :----------------- |
| `aos-ba-agent`      | Business Analyst    | Writing and refining user stories in the `aos-architecture` repository.                   | `aos-architecture` |
| `aos-coder-agent`   | Coder / Developer   | Writing and refactoring Odoo modules based on work orders.                              | `hub`, `evv`       |
| `aos-tester-agent`  | Tester / QA         | Writing and running unit/integration tests to validate the Coder Agent's work.          | `hub`, `evv`       |
| `aos-devops-agent`  | DevOps Specialist   | Managing CI/CD pipelines, Docker environments, and GitHub Actions automation.           | `all`              |
| `aos-architect`     | Executive Architect | (The AI in this chat) Reviewing code, making architectural decisions, creating work orders. | `all`              |

## 3. GitHub Label Glossary

This section defines the official set of GitHub labels used to manage issues and pull requests. All automation and filtering will be based on these labels.

### 3.1. Agent Labels

*   **Prefix:** `agent:`
*   **Purpose:** To signal which type of specialized agent is required for a task.

| Label           | Color   | Description                                                           |
| :-------------- | :------ | :-------------------------------------------------------------------- |
| `agent:coder`   | `#0075ca` | This issue is a work order for the **Coder Agent**.                   |
| `agent:tester`  | `#c5def5` | This issue is ready for the **Tester Agent** to begin its work.       |
| `agent:devops`  | `#fef2c0` | This issue requires action from the **DevOps Specialist**.              |
| `agent:ba`      | `#5319e7` | This issue requires work from the **Business Analyst Agent**.         |

### 3.2. Status Labels

*   **Prefix:** `status:`
*   **Purpose:** To provide a clear, at-a-glance indication of an issue's current state in the workflow.

| Label                  | Color   | Description                                                                 |
| :--------------------- | :------ | :-------------------------------------------------------------------------- |
| `status:needs-review`  | `#fbca04` | This Pull Request is complete and ready for **architectural review**.       |
| `status:blocked`       | `#d93f0b` | This issue cannot proceed; it is waiting on another task or a decision.   |
| `status:awaiting-sme`  | `#bfd4f2` | This issue is waiting for feedback from a **Subject Matter Expert**.        |

### 3.3. Work Type Labels

*   **Prefix:** `type:`
*   **Purpose:** To categorize the nature of the work being done.

| Label            | Color   | Description                                                               |
| :--------------- | :------ | :------------------------------------------------------------------------ |
| `type:feature`   | `#a2eeef` | A new, user-facing feature.                                               |
| `type:bug`       | `#d73a4a` | A bug in existing functionality that needs to be fixed.                     |
| `type:refactor`  | `#7057ff` | Improving the internal structure of the code without changing its behavior. |
| `type:docs`      | `#0052cc` | Writing or updating documentation.                                        |
| `type:epic`      | `#0e8a16` | A high-level tracker for a full user story (parent to other issues).      |

### 3.4. Priority Labels

*   **Prefix:** `priority:`
*   **Purpose:** To indicate the urgency of a task.

| Label             | Color   | Description                                                          |
| :---------------- | :------ | :------------------------------------------------------------------- |
| `priority:high`   | `#b60205` | This issue is a blocker or is on the critical path for a release.    |
| `priority:medium` | `#fbca04` | This issue is part of normal, planned development. (Default)         |
| `priority:low`    | `#0e8a16` | This is a "nice-to-have" or an opportunistic improvement.           |

### 3.5. Module Labels

*   **Prefix:** `module:`
*   **Purpose:** To categorize work by the specific Odoo module or feature suite it pertains to.

| Label                        | Color   | Description                                                           |
| :--------------------------- | :------ | :-------------------------------------------------------------------- |
| `module:hub-compliance`      | `#1d76db` | Related to the Compliance and Onboarding module in the Hub.           |
| `module:hub-traction`        | `#b662d0` | Related to the Traction/EOS module in the Hub.                        |
| `module:hub-payroll`         | `#f9d0c4` | Related to the Payroll and Blended Overtime module in the Hub.        |
| `module:evv-scheduling`      | `#008672` | Related to the Scheduling and Matching Engine in the EVV.             |
| `module:ask-if`              | `#f9d0c4` | Related to the "Ask IF" AI Assistant.                                 |
| `module:employee-experience` | `#f9d0c4` | Related to the `if_*` suite of retention and engagement modules.      |
