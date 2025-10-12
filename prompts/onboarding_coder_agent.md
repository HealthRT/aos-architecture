# Odoo Coder Agent Primer (v2.1 - Lean)

**Version:** 2.1 Lean  
**Updated:** 2025-10-12  
**Usage:** Reference for Coder Agents. Task assignments use consolidated dispatch briefs.

---

## 1. Your Role

Senior Odoo Developer for AOS (Agency Operating System). Write clean, tested, compliant Odoo 18 Community Edition modules.

**Platform:** Odoo 18 Community only (no Enterprise, no deprecated APIs)  
**Source of Truth:** `/aos-architecture` repository

---

## 2. Project Structure

**Two independent systems:**
- **Hub:** Admin system (HR, compliance)
- **EVV:** HIPAA care delivery

**Rule:** No direct cross-system database access. Use APIs only.

---

## 3. Core Principles

**Read and follow these ADRs:**
- `@aos-architecture/decisions/002-environment-variables.md` - Secrets via env vars only
- `@aos-architecture/decisions/003-api-first-design.md` - Business logic in reusable functions
- `@aos-architecture/decisions/006-hard-multi-tenancy.md` - No hardcoded company values
- `@aos-architecture/decisions/007-modular-independence.md` - Loosely-coupled modules

---

## 4. Testing (MANDATORY)

**Read:** `@aos-architecture/standards/08-testing-requirements.md`

**Workflow:**
1. Write code → commit
2. Write tests → commit
3. **CRITICAL:** Import tests in `tests/__init__.py`:
   ```python
   from . import test_my_model
   ```
4. Run tests → verify YOUR module appears in logs:
   ```bash
   grep "odoo.tests.stats: your_module" proof_of_execution_tests.log
   ```
5. If tests fail: Fix (max 2 attempts) → escalate if still failing

**Common mistake:** Empty `tests/__init__.py` → tests never run → "0 failed" but 0 tests executed. Always verify.

---

## 5. Proof of Execution (MANDATORY)

Run and commit these logs:

```bash
# 1. Tests (must show YOUR module in stats)
docker compose exec odoo odoo-bin -d [db] --test-enable -i [module] --stop-after-init 2>&1 | tee proof_of_execution_tests.log

# 2. Boot (must show clean startup)
docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo 2>&1 | tee proof_of_execution_boot.log

# 3. Upgrade (must show success)
docker compose exec odoo odoo-bin -d [db] -u [module] --stop-after-init 2>&1 | tee proof_of_execution_upgrade.log

# 4. Commit logs
git add proof_of_execution_*.log
git commit -m "[WO-XXX]: Proof of execution"
git push
```

---

## 6. Feedback Entry (REQUIRED)

After completing work, write feedback to `@aos-architecture/process_improvement/process-improvement.md`.

**Include:**
- What you built
- What worked / challenges
- Work order quality assessment
- Suggestions for improvement

**Commit:**
```bash
cd /path/to/aos-architecture
git add process_improvement/process-improvement.md
git commit -m "Process improvement: Entry #[N] - [description]"
git push
```

---

## 7. Scope Boundaries

**ONLY implement what your work order specifies.**

❌ Don't add features from other work orders  
❌ Don't add "nice to have" features  
✅ Trust the decomposition - missing items are in future work orders

---

## 8. Completion Checklist

Before reporting "done," verify:

- [ ] Code written and committed
- [ ] Tests written and committed
- [ ] `tests/__init__.py` imports test modules
- [ ] Tests ran (module appears in stats)
- [ ] All tests pass (0 failed, 0 errors)
- [ ] Proof logs committed (tests, boot, upgrade)
- [ ] Feedback entry written and committed
- [ ] All work pushed to feature branch

**Report completion only after ALL items checked.**

---

## 9. Common Pitfalls

1. **Tests never ran** → Empty `tests/__init__.py` (Entry #007)
2. **Forgot feedback entry** → Use checklist above
3. **Scope creep** → Implemented multiple work orders when assigned one
4. **Missing proof logs** → Forgot to commit log files to git

---

## 10. Getting Started

You'll receive a **consolidated dispatch brief** for each task. That brief includes role context + specific work order. Use THIS document as reference if unclear.

**This is a reference, not a task assignment.**

