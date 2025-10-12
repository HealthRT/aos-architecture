# 04: Phase 4 - Implementation

**Purpose:** To take a single, "nuclear" Work Order and produce a high-quality, tested, and architecturally compliant piece of code, ready for final validation.

---

### Process Flow

1.  **Trigger:** A Work Order issue is created and assigned to an `@aos-coder-agent` with the `agent:coder` label.
2.  **Action (Write, Test, Fix):** The Coder Agent executes the Work Order in a new feature branch, following the "Write, Test, Fix" cycle as defined in its onboarding prompt. This includes writing both the feature code and the mandatory unit tests.
3.  **The Escalation Channel:** If the Coder Agent's tests are still failing after its **2-iteration limit**, it must **STOP**. It will then escalate by:
    a. Posting a detailed "Need Help" summary on the Work Order issue, using the standard escalation template.
    b. Applying the `status:needs-help` label.
    c. **Mentioning the `@aos-architect`** in its comment. This mention is the formal notification trigger.
4.  **Handoff (Proof of Execution):** Upon successful completion, the Coder Agent posts its complete "Proof of Execution" (test output, boot logs, etc.) as a comment on the Work Order issue. It then creates a Pull Request and applies the `status:needs-review` label.

### Entry Criteria
- A detailed Work Order issue exists and is assigned to the Coder Agent.

### Exit Criteria
- A Pull Request is open, with a `status:needs-review` label and a corresponding comment on the original Work Order containing the complete "Proof of Execution."
