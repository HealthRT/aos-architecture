---
title: "[DEVOPS] DEVOPS-004: Create `dispatch.sh` Script for Work Orders"
repo: "HealthRT/aos-architecture"
assignee: "aos-devops-agent"
labels: "agent:devops,type:refactor,priority:high"
---
# Work Order: DEVOPS-004 - Create `dispatch.sh` Script for Work Orders

## 1. Context & Objective

To improve our workflow and eliminate copy-paste errors, we are moving from a manual issue creation process to a script-driven one. This task is to create the `dispatch.sh` script that will read a Work Order from a markdown file and create the corresponding GitHub issue automatically.

---

## 2. Repository Setup

**Repository:** `aos-architecture` (The script will live at the project root)
**Base Branch:** `main`
**New Branch:** `feature/DEVOPS-004-dispatch-script`

---

## 3. Required Implementation

Create a new, executable shell script named `dispatch.sh` in the root of the `aos-architecture` repository.

**Script Logic:**

1.  **Input:** The script must accept one argument: the file path to a Work Order markdown file (e.g., `bash dispatch.sh work_orders/pending/DEVOPS-004.md`).
2.  **Parsing:** The script needs to parse the YAML frontmatter at the top of the input markdown file to extract the `title`, `repo`, `assignee`, and `labels`.
3.  **Execution:** The script will use the extracted variables to construct and execute a `gh issue create` command. The body of the issue will be the entire content of the markdown file *after* the frontmatter block.
4.  **File Management:** Upon successful creation of the GitHub issue, the script must move the processed markdown file from the `/work_orders/pending/` directory to a new `/work_orders/dispatched/` directory.
5.  **Error Handling:** If the `gh` command fails, the script should exit with an error and should **not** move the file.

---

## 4. Acceptance Criteria

- [ ] A new, executable `dispatch.sh` file exists at the project root of `aos-architecture`.
- [ ] Running the script with a valid Work Order file path successfully creates a new GitHub issue with the correct title, body, labels, and assignee.
- [ ] After successful creation, the source markdown file is moved to the `dispatched` directory.
- [ ] If the script is run with an invalid path or if the `gh` command fails, the file is **not** moved.
- [ ] The script is submitted via a Pull Request for review.

---

## 5. Required Context Documents

- `@aos-architecture/standards/03-ai-agent-workflow.md` (for understanding the dispatch step)
- `gh` CLI documentation for `issue create`.

---

## 6. MANDATORY: Proof of Execution

Provide command-line output demonstrating:
1.  A successful run of the script, including the URL of the newly created GitHub issue.
2.  An `ls` command showing the work order file has been moved from `pending` to `dispatched`.
3.  A failed run of the script showing the correct error handling.
