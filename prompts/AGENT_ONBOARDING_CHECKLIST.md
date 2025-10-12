# Agent Onboarding Checklist - Hardened Architecture

**Version:** 2.0 (Post-ADR-013/014/015)  
**Last Updated:** 2025-10-12  
**Purpose:** Ensure all agents (current and future) understand the hardened architectural decisions

---

## 🎯 **Mandatory Reading for All Agents**

Every agent MUST read these documents before receiving work orders:

### **Ring 0: The Immutable Core (Non-Negotiable)**

**File:** `prompts/core/00_NON_NEGOTIABLES.md`

**Key Principles:**
- [ ] **Human Final Authority:** Only humans merge PRs, only humans modify Ring 0
- [ ] **No PHI Leakage:** Protected Health Information never in logs, commits, issues
- [ ] **Federated Architecture:** Hub and EVV are separate instances, API-only communication
- [ ] **Repository Boundaries:** Hub modules in Hub repo, EVV modules in EVV repo (ADR-013)
- [ ] **Hard Multi-Tenancy:** No hardcoded company values (ADR-006)

**Test Your Understanding:**
- Q: Can I commit an `evv_*` module to the Hub repository?
- A: NO - Pre-commit hook will reject it (ADR-013)

---

### **Ring 1: Protected Layer (Standards & ADRs)**

#### **Critical ADRs (Must Read)**

1. **ADR-001: Hub-EVV Authentication**
   - File: `decisions/001-hub-evv-authentication.md`
   - Key: Two separate Odoo instances, OAuth 2.0 for communication
   - Test: Where does employee compliance data live? (Answer: Hub)

2. **ADR-002: Environment Variables**
   - File: `decisions/002-environment-configuration.md`
   - Key: No hardcoded secrets, use env vars exclusively
   - Test: Can I hardcode an API key? (Answer: NO)

3. **ADR-003: API-First Design**
   - File: `decisions/003-internal-api-first-design.md`
   - Key: Business logic in reusable Python functions, thin UI layer
   - Test: Where does business logic belong? (Answer: Python functions, not views)

4. **ADR-009: Immutable Core Framework**
   - File: `decisions/009-immutable-core-framework.md`
   - Key: Ring 0 (Immutable), Ring 1 (Protected), Ring 2 (Adaptive)
   - Test: Can I propose changes to standards? (Answer: Yes, via Ring 2 feedback)

5. **⭐ ADR-013: Repository Boundaries (NEW - CRITICAL)**
   - File: `decisions/013-repository-boundaries-and-module-placement.md`
   - Key: Module placement rules, pre-commit enforcement, naming conventions
   - **Must Read Sections:**
     - Section 1: Repository-Module Mapping
     - Section 2: Agent Verification Requirements
     - Section 4: Module Naming Convention
   - Test Questions:
     - Q: Where does `evv_visits` module belong? (Answer: EVV repo)
     - Q: What command verifies correct repository? (Answer: `git remote -v`)
     - Q: What happens if I commit Hub module to EVV? (Answer: Pre-commit hook rejects)

6. **⭐ ADR-014: Parallel Agent Coordination (NEW - CRITICAL)**
   - File: `decisions/014-parallel-agent-coordination-patterns.md`
   - Key: 5 coordination patterns, file lock system, traffic rules
   - **Must Read Sections:**
     - Pattern 1: Module Isolation (primary pattern)
     - Pattern 5: File Manifest Pre-Assignment (file lock system)
     - Traffic Rules (all 5 rules)
   - Test Questions:
     - Q: Can I work on the same module as another agent? (Answer: Check `WORK_IN_PROGRESS.md` first)
     - Q: Safest parallel pattern? (Answer: Pattern 1 - Module Isolation)
     - Q: What file tracks active work? (Answer: `WORK_IN_PROGRESS.md` in each repo)

7. **ADR-015: Test Environment Isolation (NEW - PROPOSED)**
   - File: `decisions/015-test-environment-isolation-for-parallel-agents.md`
   - Key: Deferred - use Pattern 1 (Module Isolation) for now
   - Test: Do I have my own Odoo instance? (Answer: Not yet - share with repo)

#### **Critical Standards (Must Read)**

1. **Standard 01: Odoo Coding Standards**
   - File: `standards/01-odoo-coding-standards.md`
   - Key: Module structure, Python conventions, versioning
   - Test: What framework for tests? (Answer: Odoo's built-in unittest)

2. **Standard 03: AI Agent Workflow**
   - File: `standards/03-ai-agent-workflow.md`
   - Key: GitHub Issues as handoff, smoke test mandatory, Definition of Done
   - Test: When do I submit PR? (Answer: After Test-Approved status)

3. **Standard 08: Testing Requirements**
   - File: `standards/08-testing-requirements.md`
   - Key: Tests MANDATORY, no "tests optional", 0 failures required
   - Test: Are tests optional for bootstrap work? (Answer: NO - never optional)

#### **Critical Templates (Must Use)**

1. **Work Order Template**
   - File: `templates/work_order_template.md`
   - **New Section 2:** Development Environment (CRITICAL)
   - Must complete Pre-Work Verification Checklist:
     - [ ] `git remote -v` shows correct repository
     - [ ] `docker-compose.yml` exists in repo root
     - [ ] Module prefix matches repository
     - [ ] Read repository's `README.md`

---

### **Ring 2: Adaptive Layer (Feedback & Improvement)**

1. **Process Improvement Log**
   - File: `process_improvement/process-improvement.md`
   - Your feedback goes here after completing work
   - Recent: Entry #009 (Multi-repo confusion) → led to ADR-013/014/015

2. **Agent Evaluation Matrix**
   - File: `operations/agent-evaluation-matrix.md`
   - Performance tracking, comparison between AI models
   - Recent: Claude 95/100, GPT-5 68/100

---

## 🔍 **Repository-Specific Onboarding**

### **Before Working in Hub Repository**

**Read:** `/path/to/hub/README.md`

- [ ] Understand Hub's purpose (Admin, HR, compliance, Traction)
- [ ] Know allowed module prefixes: `hub_*`, `traction*`
- [ ] Understand Docker setup: `cd hub/ && docker-compose up -d`
- [ ] Know access URL: `http://localhost:8090`
- [ ] Locate `WORK_IN_PROGRESS.md` for file lock coordination

### **Before Working in EVV Repository**

**Read:** `/path/to/evv/README.md`

- [ ] Understand EVV's purpose (HIPAA care delivery, visits, billing)
- [ ] Know allowed module prefix: `evv_*`
- [ ] Understand HIPAA compliance requirements
- [ ] Understand Docker setup: `cd evv/ && docker-compose up -d`
- [ ] Know access URL: `http://localhost:8091`
- [ ] Locate `WORK_IN_PROGRESS.md` for file lock coordination

---

## ✅ **Pre-Work Verification (Every Work Order)**

**Before starting ANY work order, you MUST:**

### Step 1: Repository Verification
```bash
cd /path/to/[target-repo]/
git remote -v
# Output MUST show: HealthRT/[hub|evv].git
```

### Step 2: Docker Environment Check
```bash
ls docker-compose.yml
# Must exist in repository root
```

### Step 3: Module Prefix Validation
- Hub work → Module must be `hub_*` or `traction*`
- EVV work → Module must be `evv_*`

### Step 4: File Lock Check
```bash
cat WORK_IN_PROGRESS.md
# Check if any files you plan to modify are locked by another agent
```

### Step 5: README Review
```bash
cat README.md | less
# Understand repo-specific guidelines
```

---

## 🎓 **Knowledge Checks**

**Every agent must be able to answer these correctly:**

### Architecture Questions

1. **Q:** Are Hub and EVV in the same database?  
   **A:** NO - Separate Odoo instances, API-only communication (ADR-001)

2. **Q:** Can I access Hub database from EVV code?  
   **A:** NO - API-only, no direct DB access (Ring 0)

3. **Q:** Where do I put a module for visit tracking?  
   **A:** EVV repository, name it `evv_visits` (ADR-013)

4. **Q:** I'm working on `hub_compliance`. Which Docker environment?  
   **A:** Hub: `cd hub/ && docker-compose up -d`, access on port 8090

### Process Questions

5. **Q:** Can I skip writing tests for my module?  
   **A:** NO - Tests MANDATORY for all code changes (Standard 08, Ring 0)

6. **Q:** Another agent is modifying `models/service_agreement.py`. Can I work on it too?  
   **A:** NO - Check `WORK_IN_PROGRESS.md`, coordinate or wait (ADR-014)

7. **Q:** My PR is approved. Can I merge it?  
   **A:** NO - Only humans merge PRs (Ring 0)

8. **Q:** I found a gap in the Coder Agent primer. What do I do?  
   **A:** Write feedback to Ring 2 (`process_improvement/process-improvement.md`)

### Safety Questions

9. **Q:** I need to commit an `evv_agreements` module to Hub repo for testing. Is that okay?  
   **A:** NO - Pre-commit hook will reject it. Test in EVV repo. (ADR-013)

10. **Q:** Can I hardcode `company_id = 1` in my code?  
   **A:** NO - Hard multi-tenancy violation (ADR-006, Ring 0)

### Emergency Questions

11. **Q:** I've tried fixing a bug twice and it still fails. What now?  
   **A:** STOP. Escalate with `status:needs-help` label. (2-iteration limit)

12. **Q:** The work order is unclear about which repository to use. What do I do?  
   **A:** STOP. Ask for clarification. Don't guess. (ADR-013)

---

## 📚 **Agent-Specific Primers**

### For Coder Agents
**Primary Primer:** `prompts/onboarding_coder_agent.md`  
**Key Updates:** Section 2.1 (Repository & Docker), Section 5 (Proof of Execution)

### For Scrum Master Agents
**Primary Primer:** `prompts/onboarding_scrum_master.md`  
**Critical:** Work orders MUST include Development Environment section (Section 2)

### For Architect Agents
**Primary Primer:** `prompts/onboarding_architect_hub.md`  
**Focus:** Ring 1 changes require human approval (ADR-009)

---

## 🚀 **First Work Order Workflow**

**For an agent's FIRST work order:**

1. **Complete this checklist** ✅ (You are here)
2. **Read Ring 0:** `prompts/core/00_NON_NEGOTIABLES.md`
3. **Read ADR-013, ADR-014:** Repository boundaries and coordination
4. **Read target repo README:** Hub or EVV specific
5. **Read your role primer:** Coder, Scrum Master, etc.
6. **Run Pre-Work Verification** (see above)
7. **Only then:** Start work on the work order

**Estimated Time:** 45-60 minutes for first-time onboarding

**Subsequent Work Orders:** ~5 minutes (just Pre-Work Verification)

---

## 🔄 **Keeping Knowledge Current**

### When ADRs Are Updated

**You will be notified when:**
- New ADRs are added (they'll be in `decisions/` folder)
- Existing ADRs are modified (check git history)
- Ring 0 is updated (rare - human-only changes)

**Action Required:**
- Read the new/updated ADR
- Update your mental model
- Apply to future work

### Quarterly Architecture Reviews

**Every quarter:**
- Review all ADRs for changes
- Re-read Ring 0 for any updates
- Check process improvement log for new patterns

---

## ✅ **Onboarding Complete Checklist**

**I certify that I have:**

- [ ] Read `prompts/core/00_NON_NEGOTIABLES.md` (Ring 0)
- [ ] Read ADR-001 (Hub-EVV Authentication)
- [ ] Read ADR-009 (Immutable Core Framework)
- [ ] Read ADR-013 (Repository Boundaries) - **CRITICAL**
- [ ] Read ADR-014 (Parallel Agent Coordination) - **CRITICAL**
- [ ] Read Standard 03 (AI Agent Workflow)
- [ ] Read Standard 08 (Testing Requirements)
- [ ] Read my role-specific primer
- [ ] Read the README for my target repository (Hub or EVV)
- [ ] Understand Pre-Work Verification steps
- [ ] Can answer all 12 Knowledge Check questions correctly
- [ ] Know where to find `WORK_IN_PROGRESS.md`
- [ ] Understand pre-commit hooks will enforce repository boundaries

**Signed:** [Agent Model/Name]  
**Date:** [YYYY-MM-DD]  
**First Work Order:** [WO-XXX]

---

## 📞 **Getting Help**

**If you're unsure about:**
- **Repository placement:** Re-read ADR-013, check module prefix
- **Parallel work collision:** Check `WORK_IN_PROGRESS.md`, coordinate in Issue comments
- **Architecture decision:** Search ADRs in `decisions/` folder
- **Process question:** Check `COMPLETE_WORKFLOW_END_TO_END.md`
- **Emergency/stuck:** Add `status:needs-help` label, escalate to human

**Remember:** Better to ask than to violate architecture. We prefer clarification questions over corrections.

---

**Last Updated:** 2025-10-12 (Post-Entry #009 remediation)  
**Next Review:** 2026-01-12 (Quarterly)  
**Related:** ADR-009 (Immutable Core), Process Improvement Entry #009

