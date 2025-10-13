---
title: "[WORK ORDER] WO-SYSTEM-001-01 – Create Reliable Test Runner for evv"
labels: ["agent:coder", "module:evv-compliance", "priority:high"]
assignee: "aos-coder-agent"
---

# Work Order: WO-SYSTEM-001-01 – Create Reliable Test Runner for evv

## 📋 Context & Objective

Create a robust, agent-friendly test execution system for the `evv` repository consisting of two scripts: `start-agent-env.sh` for dynamic port management and environment startup, and `run-tests.sh` for automated test execution with comprehensive logging, per `SYSTEM-001` requirements.

**Story:** `SYSTEM-001` - Stabilize and Harden the Agent Test Environment

---

## 🎯 Deliverables

### 1. `scripts/start-agent-env.sh`
- Dynamic port allocation (8090-8100 range)
- Unique Docker project naming
- Environment validation before returning
- Clear startup messaging

### 2. `scripts/run-tests.sh`
- Single-command test execution
- Module-specific test targeting
- Comprehensive logging to `proof_of_execution_tests.log`
- Automatic cleanup on success/failure
- Proper exit codes

### 3. Documentation Updates
- `README.md` - Usage instructions
- `aos-architecture/prompts/onboarding_coder_agent.md` - Updated test commands
- `aos-architecture/templates/work_order_template.md` - Updated proof of execution

### 4. `docker-compose.agent.yml` (if needed)
- Dynamic project naming support
- Health checks for validation

---

## ✅ Acceptance Criteria

**`start-agent-env.sh`:**
- [ ] Accepts environment name argument
- [ ] Finds available port in 8090-8100 range
- [ ] Starts Docker with unique project name
- [ ] Prints clear startup URL
- [ ] Fails gracefully when no ports available
- [ ] Environment accessible within 60 seconds

**`run-tests.sh`:**
- [ ] Accepts module name argument
- [ ] `bash scripts/run-tests.sh evv_core` exits with code 0
- [ ] Creates `proof_of_execution_tests.log` with full output
- [ ] Failed tests result in non-zero exit code
- [ ] Cleans up all Docker resources automatically
- [ ] Can run repeatedly without manual cleanup

**Documentation:**
- [ ] README updated with usage examples
- [ ] Onboarding doc references new script
- [ ] Work order template uses new commands

**Integration:**
- [ ] Scripts reference SYSTEM-001
- [ ] Scripts executable (`chmod +x`)
- [ ] Backward compatible with existing workflows

---

## 🧪 Validation Demonstrations Required

1. **Successful Run:** `evv_core` tests pass, exit code 0, log captured
2. **Failed Run:** Intentional test failure, non-zero exit, failure logged
3. **Port Conflict:** All ports occupied, graceful failure with clear error
4. **Cleanup:** No orphaned containers/volumes after run
5. **Parallel Execution:** Two environments running simultaneously

---

## 📚 Required Context

- `@aos-architecture/specs/SYSTEM-001.yaml`
- `@aos-architecture/prompts/onboarding_coder_agent.md`
- `@aos-architecture/templates/work_order_template.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

---

## 🔧 Technical Constraints

- **Repository:** HealthRT/evv
- **Base Branch:** main
- **New Branch:** `feature/WO-SYSTEM-001-01-evv-test-runner`
- **Odoo Version:** 18.0 Community Edition
- **No sudo required:** Scripts must work with standard Docker permissions
- **Change Size:** <500 LOC
- **Backward Compatible:** Existing workflows unaffected

---

## 📝 Proof of Execution Checklist

When complete, post to this issue:

- [ ] Successful test run output (exit code 0)
- [ ] Intentional failure run output (non-zero exit)
- [ ] Port allocation test output
- [ ] Cleanup verification (no orphaned resources)
- [ ] Documentation excerpts showing updates
- [ ] Link to Pull Request

---

**Full Work Order:** `@aos-architecture/work_orders/pending/WO-SYSTEM-001-01.md`
