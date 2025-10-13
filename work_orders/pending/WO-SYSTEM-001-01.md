---
title: "[FEATURE] WO-SYSTEM-001-01: Create Reliable Test Runner for evv"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:high"
---
# Work Order: WO-SYSTEM-001-01 – Create Reliable Test Runner for evv

## 1. Context & Objective

Create a robust, agent-friendly test execution system for the `evv` repository consisting of two scripts: `start-agent-env.sh` for dynamic port management and environment startup, and `run-tests.sh` for automated test execution with comprehensive logging, per `SYSTEM-001` requirements.

---

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** evv  
**GitHub URL:** github.com/HealthRT/evv  
**Target Module:** N/A (Repository-level infrastructure)  
**Module Prefix:** evv_*

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /home/james/development/aos-development/evv

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/evv.git

# Step 3: Verify Docker environment exists
ls docker-compose.agent.yml
# Must exist in repository root

# Step 4: Create scripts directory if needed
mkdir -p scripts
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/evv)
- [ ] Confirmed `docker-compose.agent.yml` exists in repository root
- [ ] Read repository's `README.md` file

### Docker Environment

**Start Command:**
```bash
cd /home/james/development/aos-development/evv
docker compose -f docker-compose.agent.yml up -d
```

**Access URL:** Dynamic (assigned by `start-agent-env.sh` in range 8090-8100)

**Database:** postgres

### Git Workflow

**Base Branch:** main  
**New Branch:** feature/WO-SYSTEM-001-01-evv-test-runner

**Setup Commands:**
```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/WO-SYSTEM-001-01-evv-test-runner
```

---

## 3. Problem Statement & Technical Details

### Current State
Agents currently lack a reliable, single-command method to execute module tests in isolated environments. Port conflicts between concurrent agent sessions prevent parallel work. Test execution requires manual Docker orchestration, and inconsistent cleanup leads to resource leaks.

### Required Artifacts

#### 1. `scripts/start-agent-env.sh`
**Purpose:** Start an isolated Docker environment with dynamic port allocation.

**Requirements:**
- Accept one argument: unique environment name (e.g., `WO-SYSTEM-001-01`).
- Scan ports 8090-8100 to find first available port.
- If all ports occupied, exit with non-zero code and clear error message.
- Start Docker environment using `docker-compose.agent.yml` with unique project name (derived from env name) and allocated port.
- Export environment variables for subsequent commands (e.g., `ODOO_PORT`, `PROJECT_NAME`).
- Print clear startup message: `"Environment [name] started at http://localhost:[port]"`.
- Validate Odoo container is responsive before returning (poll healthcheck or wait for boot log).

**Technical Details:**
```bash
# Port scanning logic
for port in {8090..8100}; do
  if ! lsof -i:$port >/dev/null 2>&1; then
    AVAILABLE_PORT=$port
    break
  fi
done

# Project naming to avoid collisions
PROJECT_NAME="evv-agent-${ENV_NAME}"

# Start with dynamic port
docker compose -f docker-compose.agent.yml -p "${PROJECT_NAME}" up -d
```

#### 2. `scripts/run-tests.sh`
**Purpose:** Execute tests for a specified module in a clean, isolated environment.

**Requirements:**
- Accept one argument: module name (e.g., `evv_core`).
- Validate argument; print usage and exit non-zero if missing.
- Generate unique environment name (e.g., `test-evv-core-$(date +%s)`).
- Call `start-agent-env.sh` to provision environment; capture allocated port/project name.
- Wait for Odoo to be fully ready (poll until responsive).
- Execute Odoo test suite targeting specified module: `odoo-bin --test-enable --stop-after-init -i <module>`.
- Stream output to console AND capture to `proof_of_execution_tests.log` in repo root (overwrite per run).
- On completion (success or failure), tear down Docker environment using captured project name.
- Use `trap` to ensure cleanup occurs even if script interrupted.
- Exit with code 0 on test success; propagate non-zero code on test failure or script error.

**Cleanup Logic:**
```bash
cleanup() {
  echo "Cleaning up Docker environment: ${PROJECT_NAME}"
  docker compose -p "${PROJECT_NAME}" down -v --remove-orphans
}
trap cleanup EXIT
```

#### 3. Documentation Updates

**`README.md`:**
- Add section "Running Tests (Agent Workflow)" documenting usage of `run-tests.sh`.
- Include examples for successful and failing test runs.
- Document `start-agent-env.sh` for manual environment provisioning use cases.
- Replace any outdated Docker commands with new script invocations.

**`aos-architecture/prompts/onboarding_coder_agent.md`:**
- Update Section 9 (Proof of Execution) to reference new `scripts/run-tests.sh` command.
- Replace hardcoded Docker commands with: `bash scripts/run-tests.sh [module_name]`.

**`aos-architecture/templates/work_order_template.md`:**
- Update Section 9.1 (Test Execution) with new command pattern.
- Remove outdated `docker compose exec` test invocations.

#### 4. `docker-compose.agent.yml` (if modifications needed)
- Ensure compose file supports dynamic project naming via `-p` flag.
- Verify service names, volumes, networks are compose-project-scoped (not hardcoded).
- Add healthcheck to Odoo service if missing, enabling startup validation.
- Keep changes minimal and backward-compatible.

---

## 4. Required Implementation

### Script Design Requirements
- Use POSIX-compatible bash (`#!/bin/bash`).
- Enable strict error handling: `set -euo pipefail`.
- No `sudo` required; scripts must work with Docker user permissions.
- Both scripts must be executable: `chmod +x scripts/*.sh`.
- Include comprehensive inline comments referencing SYSTEM-001.

### Port Allocation Strategy
- Range: 8090-8100 (11 ports for concurrent agent sessions).
- Detection: Use `lsof -i:[port]` or equivalent to test availability.
- Fallback: Exit gracefully with actionable error if all ports occupied.

### Logging Requirements
- `run-tests.sh` must create `proof_of_execution_tests.log` in repo root.
- Log must include:
  - Timestamp
  - Module name
  - Full test output (stdout + stderr)
  - Exit code
  - Environment details (port, project name)

### Error Handling
- Validate all required commands available (`docker`, `lsof`, `grep`, etc.).
- Provide actionable error messages (e.g., "Docker not running" not "command failed").
- Ensure cleanup runs even on failures (use `trap`).

---

## 5. Acceptance Criteria

### Functional Requirements

**`start-agent-env.sh`:**
- [ ] Script accepts one argument (environment name).
- [ ] Script scans ports 8090-8100 and selects first available.
- [ ] Script starts Docker environment with unique project name.
- [ ] Script prints startup URL clearly.
- [ ] If all ports occupied, script exits non-zero with clear error.
- [ ] Environment is accessible at printed URL within 60 seconds.

**`run-tests.sh`:**
- [ ] Script accepts one argument (module name).
- [ ] Running `bash scripts/run-tests.sh evv_core` completes with exit code 0.
- [ ] Log file `proof_of_execution_tests.log` created with test output.
- [ ] Modifying a test to fail results in non-zero exit code and failure logged.
- [ ] Script cleans up Docker resources (containers, volumes, networks) on success and failure.
- [ ] Re-running script immediately after previous run succeeds without manual cleanup.

**Documentation:**
- [ ] `README.md` updated with clear usage instructions.
- [ ] `onboarding_coder_agent.md` updated to reference new script.
- [ ] `work_order_template.md` updated with new test command pattern.

**Integration:**
- [ ] Both scripts reference Story `SYSTEM-001` in comments.
- [ ] Scripts are executable (`chmod +x`).
- [ ] Changes to `docker-compose.agent.yml` (if any) maintain backward compatibility.

### Testing Requirements (MANDATORY)

**Note:** This work order creates test *infrastructure*, not application code. Testing requirements focus on validation via demonstration rather than unit tests.

**Validation Demonstrations:**
- [ ] **Successful Run:** Demonstrate `run-tests.sh evv_core` with passing tests (exit code 0, log showing success).
- [ ] **Failed Run:** Introduce failing assertion, run script, demonstrate non-zero exit code and failure in log.
- [ ] **Port Conflict Handling:** Start environments on all ports 8090-8100, attempt `start-agent-env.sh`, verify graceful failure.
- [ ] **Cleanup Verification:** Run script, verify no orphaned containers/volumes remain: `docker ps -a | grep evv-agent` returns empty.
- [ ] **Parallel Execution:** Start two environments concurrently with different names, verify each gets unique port and both function.

**Coverage:**
- [ ] All acceptance criteria demonstrated with command output.
- [ ] Edge cases tested (no available ports, missing module name, interrupted execution).

**Proof of Execution:**
- [ ] Test output committed showing successful and failed runs
- [ ] Code committed with descriptive message
- [ ] Proof of execution provided (see Section 9)

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Write `start-agent-env.sh` and commit.
- Write `run-tests.sh` and commit.
- Update documentation files and commit.
- **Checkpoint:** `git commit -m "feat(infra): add reliable test runner scripts for evv (SYSTEM-001)"`

**Phase 2: Validation**
- Run validation demonstrations per acceptance criteria.
- Capture all outputs for proof of execution.
- **Checkpoint:** Commit proof logs: `git commit -m "docs: add proof of execution for test runner"`

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- Analyze validation failures, implement fixes, re-validate.
- If validation passes, proceed to Proof of Execution.
- If still failing, commit attempt and proceed to Iteration 2.

**Iteration 2:**
- Try **different approach** to fix issue. Re-validate.
- If validation passes, proceed to Proof of Execution.
- If still failing, **STOP and ESCALATE.**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document your attempts on the GitHub Issue using the standard escalation template, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

- `@aos-architecture/specs/SYSTEM-001.yaml`
- `@aos-architecture/prompts/onboarding_coder_agent.md`
- `@aos-architecture/templates/work_order_template.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`

---

## 8. Technical Constraints

- **Odoo Version:** Scripts must work with **Odoo 18.0 Community Edition**.
- **Portability:** Scripts must run on Linux environments with bash, Docker, and standard POSIX utilities.
- **No Additional Dependencies:** Do not require installation of additional tools beyond Docker and bash.
- **Backward Compatibility:** Changes to `docker-compose.agent.yml` must not break existing workflows.
- **Change Size:** Keep total diff <500 LOC.

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Successful Test Run
```bash
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_core
echo "Exit code: $?"
cat proof_of_execution_tests.log | tail -n 100
```

**Provide:**
- Full command output
- Exit code (must be 0)
- Last 100 lines of log showing tests passed

### 9.2 Intentional Failure Demonstration
```bash
# Modify a test to fail (e.g., in evv_core/tests/test_core.py add: self.assertEqual(True, False))
bash scripts/run-tests.sh evv_core || echo "Expected failure"
echo "Exit code: $?"
cat proof_of_execution_tests.log | tail -n 100
```

**Provide:**
- Full command output
- Exit code (must be non-zero)
- Last 100 lines of log showing test failure details

### 9.3 Port Allocation Test
```bash
# Start environment manually
bash scripts/start-agent-env.sh test-env-1
# Verify URL printed and environment accessible
curl -I http://localhost:[printed-port] || echo "Checking accessibility..."
# Cleanup
docker compose -p evv-agent-test-env-1 down -v
```

**Provide:**
- Command output showing port allocation
- URL accessibility verification

### 9.4 Cleanup Verification
```bash
# Run test
bash scripts/run-tests.sh evv_core

# Verify no orphaned resources
docker ps -a | grep evv-agent
docker volume ls | grep evv-agent
docker network ls | grep evv-agent

# All should return empty or only unrelated resources
```

**Provide:**
- Output showing no orphaned Docker resources after script execution

### 9.5 Documentation Review
```bash
# Show updated sections
grep -A 10 "Running Tests" /home/james/development/aos-development/evv/README.md
grep -A 5 "scripts/run-tests.sh" /home/james/development/aos-development/aos-architecture/prompts/onboarding_coder_agent.md
```

**Provide:**
- Relevant excerpts from updated documentation files
