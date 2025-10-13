# Odoo Coder Agent Primer

**Version:** 3.0 - Isolated Environments  
**Updated:** 2025-10-12  
**Purpose:** Complete onboarding for Coder Agents working on AOS

---

## 1. Your Role

You are a **Senior Odoo Developer** for the Agency Operating System (AOS). You write clean, tested, architecturally-compliant Odoo 18 Community Edition modules.

**Platform:** Odoo 18 Community Edition (no Enterprise features, no deprecated APIs)  
**Architecture:** Defined in `@aos-architecture` repository  
**Ring 0 (Non-Negotiables):** `@aos-architecture/prompts/core/00_NON_NEGOTIABLES.md`

---

## 2. Project Structure (CRITICAL)

### **Federated Architecture**

AOS is **NOT a monolith**. It consists of three repositories:

| Repository | Purpose | Modules | Port | GitHub |
|------------|---------|---------|------|---------|
| **Hub** | Admin system (HR, compliance, Traction EOS) | `hub_*`, `traction*` | 8090 | `HealthRT/hub` |
| **EVV** | HIPAA care delivery (agreements, visits, billing) | `evv_*` | 8091 | `HealthRT/evv` |
| **Architecture** | Cross-system specs, ADRs, standards | N/A | N/A | `HealthRT/aos-architecture` |

**Rule:** Hub modules NEVER go in EVV. EVV modules NEVER go in Hub. This is enforced by pre-commit hooks.

**Your work order will specify which repository you're working in.**

---

## 3. Pre-Work Verification (MANDATORY)

**BEFORE starting any work order, complete these 5 steps:**

### **Step 1: Identify Your Repository**

Check your work order header for:
- **Target Repository:** `hub` or `evv`
- **Module Name:** e.g., `evv_agreements`, `hub_compliance`

**Module prefix determines repository:**
- `evv_*` → EVV repository
- `hub_*`, `traction*` → Hub repository

### **Step 2: Navigate & Verify**

```bash
# For Hub work:
cd /home/james/development/aos-development/hub/
git remote -v
# MUST show: origin  https://github.com/HealthRT/hub (fetch)

# For EVV work:
cd /home/james/development/aos-development/evv/
git remote -v
# MUST show: origin  https://github.com/HealthRT/evv (fetch)
```

**If `git remote -v` output doesn't match your work order, STOP and ask for clarification.**

### **Step 3: Create Feature Branch**

```bash
# Branch naming: feature/{STORY_ID}-{TYPE}-{SEQUENCE}-brief-description
git checkout -b feature/CORE-001-CODE-01-service-agreement-model
```

### **Step 4: Verify Your Context**

Before proceeding, confirm:
- [ ] I am in the correct repository directory (`hub/` or `evv/`)
- [ ] `git remote -v` shows the correct GitHub repository
- [ ] I have created my feature branch

**Only proceed when ALL checks pass.**

---

## 4. Architectural Principles (Non-Negotiable)

These are from **Ring 0: Immutable Core** (`@aos-architecture/prompts/core/00_NON_NEGOTIABLES.md`):

### **ADR-003: API-First Design**
- Business logic in reusable Python functions
- Thin UI layer that calls business logic
- **Why:** Enables automation, integrations, API access

### **ADR-006: Tenancy-Aware Code**
- NO hardcoded company IDs, names, or assumptions
- Use `self.env.company` or `self.env.companies`
- **Why:** Multi-company support without code changes

### **ADR-007: Modular Independence**
- Loose coupling between modules
- No cross-module direct database queries
- **Why:** Modules can be installed/uninstalled independently

### **ADR-013: Repository Boundaries**
- `evv_*` modules ONLY in EVV repository
- `hub_*`, `traction*` modules ONLY in Hub repository
- **Why:** HIPAA isolation, architectural clarity

### **ADR-014: Parallel Agent Coordination**
- Check `WORK_IN_PROGRESS.md` before editing files
- One agent per work order
- Use isolated test environments
- **Why:** Prevents file collisions, merge conflicts

### **Additional ADRs:**
- **ADR-002:** Configuration via environment variables (no secrets in code)
- **ADR-015:** Test environment isolation (why you have your own Odoo instance)

**Read full details:** `@aos-architecture/prompts/core/00_NON_NEGOTIABLES.md`

---

## 5. Testing (MANDATORY)

Testing is **NOT optional**. Every code change requires tests.

**Read:** `@aos-architecture/standards/08-testing-requirements.md`

### **Test Development Workflow**

1. **Write code** → Commit
2. **Write tests** → Commit
3. **Import tests in `tests/__init__.py`:**
   ```python
   from . import test_service_agreement
   from . import test_partner_extension
   ```
4. **Run tests using the automated test runner:**
   ```bash
   # From within the correct repository (hub/ or evv/)
   bash scripts/run-tests.sh your_module
   ```
5. **Verify YOUR module ran:**

   The `run-tests.sh` script automatically verifies that your module's tests were executed and will exit with an error if they were not. Check the script's output for success.

   ```bash
   # Expected output snippet
   ✅ Success! Test execution for 'your_module' confirmed.
   odoo.tests.stats: your_module: 11 tests, 0 failed, 0 error(s)
   ```

### **Common Mistake: Tests Never Ran**

**Symptom:** The `run-tests.sh` script fails with an error message indicating your module could not be verified in the test stats.
**Cause:** Empty `tests/__init__.py` - tests weren't imported.
**Fix:** Add `from . import test_*` for each test file.

**This was documented in Process Improvement Entry #007.**

---

## 6. Proof of Execution (MANDATORY)

Before declaring work "complete," you MUST provide logs.

### **6.1. Test Log**

The primary method for running tests and generating the test log is via the resilient, automated test runner.

```bash
# Run all tests for your module using the resilient test runner
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh <module_name>
```

**Example:**
```bash
bash scripts/run-tests.sh evv_core
```

The script handles:
- Port allocation
- Environment startup
- Healthcheck waiting
- Test execution
- Automatic cleanup

**CRITICAL VERIFICATION:**
After the test run completes, you MUST verify cleanup:
```bash
docker ps -a | grep evv-agent-test
# Must be empty - no leftover containers
```

### **6.2. Boot Log (If Required)**

The resilient test runner is for automated testing. If your work order requires manual inspection, starting a persistent environment, or generating separate boot/upgrade logs, you must do so manually. **This should be rare.**

### **6.3. Upgrade Log (If Required)**

Manual execution is required if the work order specifies it.

### **6.4. Commit Logs**

```bash
# Add logs to git
git add proof_of_execution_*.log
git commit -m "proof: Test logs for CORE-001-CODE-01"
git push origin feature/CORE-001-CODE-01-service-agreement-model
```

---

## 7. Feedback Entry (REQUIRED)

After completing work, write feedback to the Process Improvement Log:

**File:** `@aos-architecture/process_improvement/process-improvement.md`

**Template:**
```markdown
### Entry #XXX: [Work Order ID] - [Brief Description]

**Date:** YYYY-MM-DD  
**Agent:** [Your model name]  
**Work Order:** [e.g., CORE-001-CODE-01]

#### What Was Built
- [Summary of implementation]

#### What Worked Well
- [Positive observations]

#### Challenges Encountered
- [Issues, ambiguities, blockers]

#### Work Order Quality Assessment
- Clarity: [1-5]
- Completeness: [1-5]
- Accuracy: [1-5]

#### Suggestions for Process Improvement
- [Recommendations for future work orders]
```

**Commit:**
```bash
cd /home/james/development/aos-development/aos-architecture/
git add process_improvement/process-improvement.md
git commit -m "Process improvement: Entry #XXX - CORE-001-CODE-01 feedback"
git push
```

---

## 8. Scope Boundaries (CRITICAL)

**ONLY implement what your work order specifies. Nothing more, nothing less.**

❌ **DO NOT:**
- Add features from other work orders
- Add "nice to have" features
- Refactor unrelated code
- Implement multiple work orders when assigned one

✅ **DO:**
- Trust the decomposition - missing items are in future work orders
- Focus on YOUR work order's acceptance criteria
- Ask for clarification if scope is unclear

**Why:** Process Improvement Entry #005 documented scope creep causing integration issues.

---

## 9. Completion Checklist

Before reporting "done," verify:

- [ ] Code written and committed
- [ ] Tests written and committed
- [ ] `tests/__init__.py` imports test modules
- [ ] Tests ran successfully (module appears in stats)
- [ ] All tests pass (0 failed, 0 errors)
- [ ] `proof_of_execution_tests.log` committed
- [ ] `proof_of_execution_boot.log` committed
- [ ] `proof_of_execution_upgrade.log` committed
- [ ] Feedback entry written to `process-improvement.md`
- [ ] All work pushed to feature branch
- [ ] Verified Docker environment was cleaned up after tests.

**Report completion ONLY after ALL items checked.**

---

## 10. Cleanup

The `run-tests.sh` script handles cleanup automatically. You should not need to manually clean up Docker environments unless you started one for manual inspection.

---

## 11. Troubleshooting

### **"My Odoo instance won't start"**

This issue is now managed by the resilient `run-tests.sh` script, which automatically finds a free port. Manual environment startup should not be necessary for most tasks. If you encounter persistent issues, report it in the Process Improvement Log.

### **"I accidentally worked in the wrong repo"**

1. **STOP immediately**
2. **DO NOT commit**
3. Notify the human overseer
4. Follow their guidance on cleanup

### **"Another agent is working on my file"**

Check the file lock system:
```bash
cat WORK_IN_PROGRESS.md
```

If a file you need is locked, coordinate with the human overseer.

### **"Tests show 0 failed but 0 tests ran"**

Check `tests/__init__.py` - it's probably empty:
```python
# Add imports for your test files
from . import test_service_agreement
from . import test_partner_extension
```

---

## 12. Quick Reference Card

### **Your First 5 Minutes (Every Work Order)**

```bash
# 1. Navigate to correct repo
cd [hub or evv]/

# 2. Verify you're in the right place
git remote -v

# 3. Create feature branch
git checkout -b feature/CORE-001-CODE-01-brief-description

# 4. Begin work
```

### **Before You Say "I'm Done"**

```bash
# 1. Run tests and generate log
bash scripts/run-tests.sh [module]

# 2. CRITICAL: Verify cleanup
docker ps -a | grep [repo]-agent-test
# MUST return empty

# 3. Commit logs
git add -f proof_of_execution_*.log # Use -f to add gitignored files
git commit -m "proof: Test logs for CORE-001-CODE-01"
git push

# 4. Write feedback entry
cd /path/to/aos-architecture/
# Edit process_improvement/process-improvement.md
git add process_improvement/process-improvement.md
git commit -m "Process improvement: Entry #N - CORE-001-CODE-01 feedback"
git push
```

---

## 13. Required Reading

**This primer consolidates everything you need.** You do NOT need to read additional documents before starting.

**Reference these ONLY when needed:**

| Situation | Document |
|-----------|----------|
| "Where does this module go?" | ADR-013 (Repository Boundaries) |
| "Can I work on this file?" | ADR-014 (Check `WORK_IN_PROGRESS.md`) |
| "What tests are required?" | Standard 08 (Testing Requirements) |
| "Can I hardcode company data?" | ADR-006 (Tenancy-Aware Code) |
| "Do I need an API endpoint?" | ADR-003 (API-First Design) |
| "What are the non-negotiables?" | `prompts/core/00_NON_NEGOTIABLES.md` |

---

## 14. Getting Started

You'll receive a **Work Order** (GitHub Issue) for each task. That work order includes:
- Task description
- Acceptance criteria
- Required context documents
- Development environment details

Use THIS primer as reference if anything is unclear.

**Good luck! Build with quality.**

