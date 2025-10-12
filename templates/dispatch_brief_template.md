# Dispatch Brief: [Role] Agent - [Task ID]

**Date:** [YYYY-MM-DD]  
**Agent Role:** [Coder / Scrum Master / Architect / etc.]  
**Task ID:** [WO-XXX or TASK-XXX]  
**Estimated Duration:** [Hours/Days]

---

## 📋 Your Assignment

You have been assigned: **[Brief task description]**

**This brief contains everything you need to complete this task. Read it carefully before starting.**

---

## 1. Role Context (Your Primer)

You are a **[Role Title]** for the Agency Operating System (AOS).

**Read your full primer:** `@aos-architecture/prompts/onboarding_[role]_agent.md`

**Key points from your primer:**
- [Principle 1]
- [Principle 2]
- [Principle 3]

**Non-Negotiables (Ring 0):** `@aos-architecture/prompts/core/00_NON_NEGOTIABLES.md`

---

## 2. Task Details

### **Objective:**
[Clear statement of what needs to be accomplished]

### **Context:**
[Background information, dependencies, related work]

### **Scope:**
**IN SCOPE:**
- [Specific item 1]
- [Specific item 2]
- [Specific item 3]

**OUT OF SCOPE:**
- [Explicitly excluded item 1]
- [Explicitly excluded item 2]

---

## 3. Development Environment (Coder Only)

**Target Repository:** [hub / evv]  
**Module Name:** `[module_name]`  
**GitHub URL:** [https://github.com/HealthRT/...]

### **Pre-Work Verification:**

```bash
# 1. Navigate to repository
cd /home/james/development/aos-development/[hub or evv]/

# 2. Verify correct repository
git remote -v
# Expected: [GitHub URL]

# 3. Start YOUR isolated environment
./scripts/start-agent-env.sh [WORK_ORDER_ID]
# Save the Access URL and container name

# 4. Create feature branch
git checkout -b feature/[WORK_ORDER_ID]-[brief-description]

# 5. Confirm all checks pass before proceeding
```

**Your Isolated Environment:**
- Container: `odoo_[repo]_[WORK_ORDER_ID]`
- Access URL: Will be provided by script
- Database: `postgres_[WORK_ORDER_ID]`

---

## 4. Acceptance Criteria

**Your work is complete when:**

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] [etc.]

### **Testing Requirements (MANDATORY for Coder):**
- [ ] Unit tests written for all new/modified methods
- [ ] Edge cases tested (empty recordsets, null values, validation failures)
- [ ] All tests pass (0 failed, 0 errors)
- [ ] Module name appears in test stats output

### **Proof of Execution (MANDATORY for Coder):**
- [ ] `proof_of_execution_tests.log` committed
- [ ] `proof_of_execution_boot.log` committed
- [ ] `proof_of_execution_upgrade.log` committed

### **Feedback Entry (MANDATORY for Coder):**
- [ ] Entry written to `@aos-architecture/process_improvement/process-improvement.md`

---

## 5. Required Context Documents

**Read these before starting:**

1. [Document 1 with path]
2. [Document 2 with path]
3. [Document 3 with path]

**Reference as needed:**

4. [Reference doc 1]
5. [Reference doc 2]

---

## 6. Technical Specifications (If Applicable)

### **Models:**
```python
# [Model definition or reference]
```

### **Fields:**
| Field Name | Type | Required | Description |
|------------|------|----------|-------------|
| [field1] | [type] | [Y/N] | [description] |
| [field2] | [type] | [Y/N] | [description] |

### **Business Rules:**
- [Rule 1]
- [Rule 2]

### **Security:**
- [Security requirement 1]
- [Security requirement 2]

---

## 7. Completion Workflow

### **Step 1: Implementation**
- Follow your primer's guidelines
- Stay within scope (Section 2)
- Write tests alongside code

### **Step 2: Testing**
- Run tests in YOUR isolated environment
- Verify YOUR module appears in stats
- Fix any failures (max 2 attempts, then escalate)

### **Step 3: Proof of Execution**
- Generate all 3 logs (test, boot, upgrade)
- Commit logs to your feature branch
- Push to GitHub

### **Step 4: Feedback**
- Write entry to process improvement log
- Include work order quality assessment
- Commit and push

### **Step 5: Cleanup**
- Stop your isolated environment with `--cleanup`
- Notify human overseer of completion

---

## 8. Common Pitfalls for This Task

**Watch out for:**
- [Specific pitfall 1]
- [Specific pitfall 2]
- [Specific pitfall 3]

**If you encounter:**
- [Problem X] → [Solution/Escalation path]
- [Problem Y] → [Solution/Escalation path]

---

## 9. Questions & Clarifications

**Before starting, ensure you understand:**
- [ ] What repository am I working in?
- [ ] What is my isolated environment name?
- [ ] What is explicitly IN scope?
- [ ] What is explicitly OUT of scope?
- [ ] What are my acceptance criteria?
- [ ] Where do I find the required context documents?

**If ANY of these are unclear, ask for clarification before proceeding.**

---

## 10. Success Criteria

**Your work is successful when:**

1. All acceptance criteria met
2. All tests pass
3. Proof of execution provided
4. Feedback entry written
5. Code merged to target repository
6. No architectural violations
7. Human overseer approves

---

## 11. Timeline & Milestones

**Estimated Timeline:** [X hours/days]

**Checkpoints:**
- [ ] Day/Hour X: [Milestone 1]
- [ ] Day/Hour Y: [Milestone 2]
- [ ] Day/Hour Z: Final review and completion

---

## 12. Need Help?

**If you encounter blockers:**

1. Review your primer (`onboarding_[role]_agent.md`)
2. Review Ring 0 (`prompts/core/00_NON_NEGOTIABLES.md`)
3. Check related ADRs and standards (listed in Section 5)
4. Escalate to human overseer with specific question

**DO NOT:**
- Guess at unclear requirements
- Implement features not in scope
- Skip testing or proof of execution
- Proceed when uncertain about architecture

---

**Good luck! Build with quality.**

---

## Dispatch Checklist (Human Overseer Use Only)

Before dispatching this brief:

- [ ] Role-specific primer exists and is current
- [ ] All placeholders replaced with actual values
- [ ] Required context documents exist and are accessible
- [ ] Acceptance criteria are specific and measurable
- [ ] Scope (IN/OUT) is explicitly defined
- [ ] Environment details are correct (repo, module, GitHub URL)
- [ ] Timeline is realistic
- [ ] Common pitfalls section is filled in (if known)


