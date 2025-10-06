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

1.  **Assignment:** The GitHub Issue is assigned to an AI Coder.
2.  **Implementation:** The AI Coder reads the issue and implements the required code changes, adhering to all documented standards.
3.  **Local Validation (Self-Test):** Before handing off to the Tester, the AI Coder **must** validate its changes in an isolated, local Odoo container.
4.  **Handoff to Tester:** The Coder requests a test from its paired AI Tester by commenting in the GitHub Issue. This request must include a link to a private commit/branch.
5.  **Test Implementation:** The AI Tester reads the original Work Order Issue and the Coder's implementation. It then writes the necessary unit/integration tests to validate the code against the acceptance criteria.
6.  **Test Execution & Feedback Loop:**
    -   **If tests fail:** The AI Tester commits the failing tests and assigns the issue back to the AI Coder with the test logs. The Coder must fix the code to make the new tests pass. This loop continues until all tests pass.
    -   **If tests pass:** The AI Tester provides a "Test-Approved" comment.
7.  **Pull Request Submission:** Only after receiving "Test-Approved" status can the AI Coder submit the final Pull Request. The PR must include both the feature code and the accompanying tests.
8.  **Final Architect Review:** The Architect performs the final review of the PR, which now contains both the implementation and the proof of its correctness.

### Definition of Done Checklist

This checklist must be included in every work order issue and completed by the AI Coder before handoff to the AI Tester.

```markdown
- [ ] 1. Code is written and adheres to `01-odoo-coding-standards.md`.
- [ ] 2. All UI elements adhere to `02-ui-ux-and-security-principles.md`.
- [ ] 3. **Local Odoo instance boots successfully with the new code.**
- [ ] 4. Code is self-documented with appropriate comments and docstrings.
```

## Phase 3: User Story Lifecycle & Status Tracking

To track the progress of a user story from concept to completion, we use a system of "Epic" issues in the `aos-architecture` repository.

1.  **Epic Creation:** For each user story file (e.g., `ADMIN-001.md`), the Architect creates a corresponding **"Epic" Issue**. This Epic serves as the single source of truth for the *status* of that user story.
2.  **Task Association:** All "work order" issues created during decomposition are linked as tasks to the parent Epic issue.
3.  **Automated Status:** The status of the Epic is derived automatically from the state of its child tasks.
    -   **Pending:** The Epic is open, but no work order issues are in progress.
    -   **In Progress:** The first work order issue is moved to "In Progress".
    -   **Completed:** All child work order issues are complete and merged to production.

## Phase 4: SME Review Workflow

This process is used to gather feedback from non-technical Subject Matter Experts (SMEs) on user stories and architectural decisions.

1.  **Trigger:** The workflow is initiated when the human overseer gives a natural language command to the Architect (e.g., *"Architect, send user story `ADMIN-001` for SME review."*).
2.  **Automated Issue Creation:** The Architect triggers a GitHub Action that reads the specified Markdown file and creates a new **"SME Review" Issue** in the `aos-architecture` repository.
3.  **Structured Issue Content:** The issue is pre-populated with the full text of the document and a standardized checklist to guide the SME's feedback.
4.  **Feedback Loop:** The SME is provided a direct link to the issue, where they can provide feedback by checking boxes and leaving comments. This creates a centralized, traceable record of the review.
