---
title: "[WORK ORDER] WO-SYSTEM-002-02 – Resilient Test Runner for hub"
labels: ["agent:coder", "module:hub-traction", "priority:high"]
assignee: "aos-coder-agent"
---

# Work Order: WO-SYSTEM-002-02 – Resilient Test Runner for hub

## 📋 Context & Objective

**REPLACES WO-SYSTEM-001-02.** Create a hardened, single-command `run-tests.sh` script that guarantees Docker resource cleanup even on failure or crash. This mirrors the EVV implementation and resolves the critical port-conflict blocker documented in Process Improvement Entry #012 and Entry #014.

**Story:** `SYSTEM-002` - Resilient Agent Test Environment with Guaranteed Cleanup

**Critical Success Factor:** The `trap` command for guaranteed cleanup is non-negotiable.

**Parity Requirement:** Core logic must match WO-SYSTEM-002-01 implementation.

---

## 🎯 Deliverables

### 1. `scripts/run-tests.sh` (Single Comprehensive Script)
- ✅ Unique Docker project naming (module + timestamp)
- ✅ **`trap cleanup EXIT`** for guaranteed cleanup
- ✅ Dynamic port allocation (8090-8100)
- ✅ Healthcheck waiting before test execution
- ✅ Test execution with logging
- ✅ Proper exit codes

### 2. `docker-compose.agent.yml` Enhancement
- ✅ Healthcheck added to odoo service

### 3. Documentation Updates
- `README.md` - Usage instructions
- `aos-architecture/prompts/onboarding_coder_agent.md` - Updated to be repository-agnostic
- `aos-architecture/templates/work_order_template.md` - Updated to be repository-agnostic

---

## ✅ Acceptance Criteria

**Script Functionality:**
- [ ] Accepts module name argument
- [ ] Generates unique project name (hub-agent-test-MODULE-TIMESTAMP)
- [ ] Finds available port in 8090-8100
- [ ] Starts isolated Docker environment
- [ ] Waits for healthcheck to pass
- [ ] Executes tests and logs to `proof_of_execution_tests.log`
- [ ] Returns exit code 0 on success, non-zero on failure

**Guaranteed Cleanup (MOST CRITICAL):**
- [ ] Uses `trap cleanup EXIT`
- [ ] After successful run: `docker ps -a | grep hub-agent-test` → empty
- [ ] After failed run: `docker ps -a | grep hub-agent-test` → empty
- [ ] After Ctrl+C interrupt: `docker ps -a | grep hub-agent-test` → empty

**Documentation:**
- [ ] README updated with usage
- [ ] Onboarding doc updated (repository-agnostic)
- [ ] Work order template updated (repository-agnostic)
- [ ] All docs emphasize cleanup verification

**Parity:**
- [ ] Core logic matches WO-SYSTEM-002-01
- [ ] Only repository-specific details differ

---

## 🧪 Validation Demonstrations Required

**MANDATORY: Must verify cleanup after EVERY demonstration**

1. **Successful Run:** `traction` tests pass, exit 0, cleanup verified
2. **Failed Run:** Intentional test failure, non-zero exit, cleanup verified
3. **Interrupted Run:** Ctrl+C during execution, cleanup verified
4. **Port Exhaustion:** All ports busy, graceful error message
5. **Documentation Review:** Show updated sections

**Cleanup Verification Command:**
```bash
docker ps -a | grep hub-agent-test
# Must return empty
```

---

## 📚 Required Context

- `@aos-architecture/specs/SYSTEM-002.yaml`
- `@aos-architecture/process_improvement/process-improvement.md` (Entry #012, #014)
- `@aos-architecture/prompts/onboarding_coder_agent.md`
- `@aos-architecture/templates/work_order_template.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@WO-SYSTEM-002-01.md` (for parity reference)

---

## 🔧 Technical Constraints

- **Repository:** HealthRT/hub
- **Base Branch:** main
- **New Branch:** `feature/WO-SYSTEM-002-02-hub-resilient-test-runner`
- **Odoo Version:** 18.0 Community Edition
- **No sudo required**
- **Change Size:** <500 LOC
- **Parity Required:** Core logic must match EVV implementation
- **CRITICAL:** `trap` for cleanup is non-negotiable

---

## 📝 Proof of Execution Checklist

When complete, post to this issue:

- [ ] Successful test run output (exit code 0) + cleanup verification
- [ ] Intentional failure run output (non-zero exit) + cleanup verification
- [ ] Interrupted run output + cleanup verification
- [ ] Port allocation test output
- [ ] Documentation excerpts showing updates
- [ ] Link to Pull Request

**Remember:** Every proof must include `docker ps -a | grep hub-agent-test` showing empty output.

---

**Full Work Order:** `@aos-architecture/work_orders/pending/WO-SYSTEM-002-02.md`

