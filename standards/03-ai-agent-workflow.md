# 3. AI Agent Collaboration Workflow

**Status:** Accepted

## Guiding Principle

Every piece of work must be atomic, verifiable, and clearly communicated. We use GitHub Issues as the primary communication and handoff mechanism between agents.

## Phase 1: Architect-Led Decomposition (Human-in-the-Loop)

1.  **Story Review:** The Architect analyzes an approved User Story from the `/user_stories` directory.
2.  **Decomposition:** The Architect breaks the story down into a sequence of "nuclear" tasks, each representing a single, logical unit of work (e.g., "Create the `compliance.onboarding.template` model," "Add the form view for the template").
3.  **Issue Creation:** For each nuclear task, the Architect creates a detailed GitHub Issue in the appropriate repository (`hub` or `evv`). This issue is the **"work order"** for the AI Coder.

### The "Work Order" Issue Structure

-   **Title:** Clear and concise (e.g., `[MODEL] Create compliance.onboarding.template`).
-   **User Story Link:** A link back to the parent user story file.
-   **Clear Instructions:** Explicit instructions on what to build.
-   **Acceptance Criteria:** The specific criteria from the user story that apply to this task.
-   **File Manifest:** A list of files expected to be created or modified.
-   **Definition of Done:** A mandatory checklist for the AI Coder.

## Phase 2: AI Coder & AI Tester Pair

For every "work order" issue, we deploy a pair of specialized agents: an **AI Coder** and an **AI Tester**.

1.  **Assignment:** The GitHub Issue is assigned to an AI Coder, who creates a feature branch.
2.  **Implementation:** The AI Coder implements the required code changes, adhering to all standards. Upon completion, it commits the code to the feature branch.
3.  **Handoff to Tester:** The Coder re-assigns the GitHub issue to its paired AI Tester.
4.  **Mandatory Smoke Test (Tester's First Action):** The AI Tester checks out the Coder's branch and runs an automated "smoke test" script. This script's only job is to build the Docker container and confirm that the Odoo server boots successfully. **If the smoke test fails, the work is immediately rejected** and sent back to the Coder.
5.  **Test Implementation:** If the smoke test passes, the AI Tester proceeds to write and run the necessary unit/integration tests to validate the code against the acceptance criteria.
6.  **Test Execution & Feedback Loop:**
    -   If functional tests fail, the AI Tester re-assigns the issue back to the AI Coder with the test logs.
    -   If all tests pass, the AI Tester provides a "Test-Approved" comment and a link to the passing test run.
7.  **Pull Request Submission:** Only after receiving "Test-Approved" status can the AI Coder submit the final Pull Request.
8.  **Final Architect Review:** The Architect performs the final review of the PR.

### Definition of Done Checklist

This checklist must be included in every work order issue and completed by the AI Coder before handoff to the AI Tester.

```markdown
- [ ] 1. Code is written and adheres to `01-odoo-coding-standards.md`.
- [ ] 2. All UI elements adhere to `02-ui-ux-and-security-principles.md`.
- [ ] 3. The code is "tenancy-aware" as per ADR-006 (e.g., does not hardcode company-specific values).
- [ ] 4. **Proof of Execution:** I have successfully restarted my local Odoo instance, upgraded the modified module, and have attached the server log showing a clean boot to this issue.
- [ ] 5. Code is self-documented with appropriate comments and docstrings.
```

## Phase 3: User Story Lifecycle & Status Tracking
