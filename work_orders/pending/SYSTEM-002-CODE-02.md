---
title: "[INFRASTRUCTURE] SYSTEM-002-CODE-02: Resilient Test Runner for hub"
repo: "HealthRT/hub"
assignee: "aos-coder-agent"
labels: "agent:coder,module:hub-traction,priority:high"
---
# Work Order: SYSTEM-002-CODE-02 – Resilient Test Runner for hub

## 1. Context & Objective

**REPLACES SYSTEM-001-CODE-02.** Create a hardened, single-command `run-tests.sh` script for the `hub` repository that guarantees Docker resource cleanup even on failure or crash. This mirrors the EVV implementation and resolves the critical port-conflict blocker documented in Process Improvement Entry #012 and Entry #014.

**Critical Success Factor:** The `trap` command for guaranteed cleanup is non-negotiable. This is the primary deliverable.

**Parity Requirement:** Core logic must match SYSTEM-002-CODE-01 implementation for consistency.

---

## 2. Development Environment (CRITICAL - Read First)

**Per ADR-013 (Repository Boundaries) - MUST VERIFY BEFORE STARTING**

### Target Repository
**Repository:** hub  
**GitHub URL:** github.com/HealthRT/hub  
**Target Module:** N/A (Repository-level infrastructure)  
**Module Prefix:** hub_*, traction*

### Pre-Work Verification Checklist

**BEFORE starting any work, you MUST complete these steps:**

```bash
# Step 1: Navigate to target repository
cd /home/james/development/aos-development/hub

# Step 2: Verify correct repository (MANDATORY)
git remote -v
# Expected output: origin  https://github.com/HealthRT/hub.git

# Step 3: Verify Docker environment exists
ls docker-compose.agent.yml
# Must exist in repository root

# Step 4: Create scripts directory if needed
mkdir -p scripts
```

- [ ] Confirmed `git remote -v` shows correct repository (HealthRT/hub)
- [ ] Confirmed `docker-compose.agent.yml` exists in repository root
- [ ] Read repository's `README.md` file

### Git Workflow

**Base Branch:** main  
**New Branch:** feature/SYSTEM-002-CODE-02-hub-resilient-test-runner

**Setup Commands:**
```bash
cd /home/james/development/aos-development/hub
git checkout main
git pull origin main
git checkout -b feature/SYSTEM-002-CODE-02-hub-resilient-test-runner
```

---

## 3. Problem Statement & Technical Details

### Current State (Why This Replaces SYSTEM-001)

**Process Improvement Log Entries #012 and #014 documented critical failures:**
- Agents unable to reliably run tests due to port conflicts
- Docker environments not cleaning up after test runs
- `start-agent-env.sh` + `run-tests.sh` two-script approach proved fragile
- Port allocation failures even when ports appeared available

**Root Cause:** Insufficient cleanup guarantees led to orphaned containers blocking ports.

### Required Solution: Single Resilient Script

Create `scripts/run-tests.sh` that is a **self-contained, bulletproof test runner**.

**NO separate `start-agent-env.sh`** - all functionality in one script.

---

## 4. Required Implementation

### `scripts/run-tests.sh` - Complete Specification

**CRITICAL:** This script must maintain parity with SYSTEM-002-CODE-01 (EVV) implementation. Only repository-specific details should differ (project name prefix: `hub-agent-test-` instead of `evv-agent-test-`).

#### A. Script Header & Error Handling
```bash
#!/bin/bash
set -euo pipefail

# Strict error handling:
# -e: Exit on any command failure
# -u: Exit on undefined variable
# -o pipefail: Pipe failures propagate
```

#### B. Unique Project Naming (CRITICAL)
```bash
# Generate unique project name using module + timestamp
MODULE_NAME="$1"
TIMESTAMP=$(date +%s)
PROJECT_NAME="hub-agent-test-${MODULE_NAME}-${TIMESTAMP}"

# Example result: hub-agent-test-traction-1697234567
```

**Why:** Prevents any possibility of collision between concurrent test runs.

#### C. Guaranteed Cleanup Trap (MOST CRITICAL)
```bash
cleanup() {
    echo "=== CLEANUP: Tearing down ${PROJECT_NAME} ==="
    docker compose -p "${PROJECT_NAME}" -f docker-compose.agent.yml down -v --remove-orphans || true
    echo "=== CLEANUP COMPLETE ==="
}

# CRITICAL: This trap ensures cleanup runs on:
# - Normal exit (success)
# - Error exit (test failure)
# - SIGINT (Ctrl+C)
# - SIGTERM (kill signal)
trap cleanup EXIT
```

**Why:** This is the primary fix. No matter what happens, cleanup runs.

#### D. Port Allocation
```bash
# Find available port in range 8090-8100
find_available_port() {
    for port in {8090..8100}; do
        if ! lsof -iTCP:${port} -sTCP:LISTEN >/dev/null 2>&1; then
            echo ${port}
            return 0
        fi
    done
    echo "ERROR: No available ports in range 8090-8100" >&2
    return 1
}

ODOO_PORT=$(find_available_port)
if [ $? -ne 0 ]; then
    echo "FATAL: Cannot allocate port. Exiting."
    exit 1
fi

export ODOO_PORT
echo "=== Using port: ${ODOO_PORT} ==="
```

#### E. Environment Startup
```bash
echo "=== Starting isolated environment: ${PROJECT_NAME} ==="
docker compose -p "${PROJECT_NAME}" -f docker-compose.agent.yml up -d

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to start Docker environment"
    exit 1
fi
```

#### F. Healthcheck Wait (NEW REQUIREMENT)
```bash
echo "=== Waiting for Odoo healthcheck to pass ==="

MAX_WAIT=300  # 5 minutes
ELAPSED=0
INTERVAL=5

while [ $ELAPSED -lt $MAX_WAIT ]; do
    # Check if container is healthy
    HEALTH=$(docker inspect --format='{{.State.Health.Status}}' $(docker compose -p "${PROJECT_NAME}" ps -q odoo) 2>/dev/null || echo "unknown")
    
    if [ "$HEALTH" = "healthy" ]; then
        echo "=== Odoo is healthy and ready ==="
        break
    fi
    
    echo "Waiting for healthcheck... (${ELAPSED}s/${MAX_WAIT}s, status: ${HEALTH})"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

if [ $ELAPSED -ge $MAX_WAIT ]; then
    echo "ERROR: Healthcheck timeout after ${MAX_WAIT} seconds"
    exit 1
fi
```

**Why:** Prevents race conditions where tests run before Odoo is ready.

#### G. Test Execution
```bash
echo "=== Running tests for module: ${MODULE_NAME} ==="

# Run tests and capture output
docker compose -p "${PROJECT_NAME}" exec -T odoo \
    odoo-bin -c /etc/odoo/odoo.conf -d odoo \
    --test-enable --stop-after-init -i "${MODULE_NAME}" \
    --log-level=test 2>&1 | tee proof_of_execution_tests.log

# Capture exit code
TEST_EXIT_CODE=${PIPESTATUS[0]}

echo "=== Test execution complete with exit code: ${TEST_EXIT_CODE} ==="
exit ${TEST_EXIT_CODE}
```

**Why:** 
- `tee` streams to console AND file
- `${PIPESTATUS[0]}` captures the actual `odoo-bin` exit code (not `tee`'s)
- Script exits with test result code

#### H. Argument Validation
```bash
# At top of script after shebang:
if [ $# -ne 1 ]; then
    echo "Usage: $0 <module_name>"
    echo "Example: $0 traction"
    exit 1
fi
```

---

### `docker-compose.agent.yml` - Healthcheck Addition

Add to the `odoo` service:

```yaml
services:
  odoo:
    # ... existing config ...
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8069/web/health || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 30
      start_period: 60s
```

**Why:** Provides Docker-native way to detect when Odoo is ready.

---

### Documentation Updates

#### `README.md`
Update "Running Tests" section:
```markdown
## Running Tests

Use the resilient test runner:

```bash
bash scripts/run-tests.sh <module_name>
```

**Example:**
```bash
bash scripts/run-tests.sh traction
```

**Features:**
- ✅ Automatic port allocation
- ✅ Isolated Docker environment
- ✅ Guaranteed cleanup (even on failure)
- ✅ Healthcheck waiting
- ✅ Logs to `proof_of_execution_tests.log`

**Verify cleanup:**
```bash
docker ps -a | grep hub-agent-test
# Should return nothing after script completes
```
```

#### `aos-architecture/prompts/onboarding_coder_agent.md`
Update Section 9.1 (Test Execution) to be repository-agnostic:
```markdown
### 9.1 Test Execution (REQUIRED for code changes)
```bash
# Run all tests for your module using the resilient test runner
cd /home/james/development/aos-development/[evv|hub]
bash scripts/run-tests.sh <module_name>
```

**Examples:**
```bash
# For EVV modules:
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_core

# For Hub modules:
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
```

The script handles:
- Port allocation
- Environment startup
- Healthcheck waiting
- Test execution
- Automatic cleanup

**CRITICAL VERIFICATION:**
After test run completes, verify cleanup:
```bash
# For EVV:
docker ps -a | grep evv-agent-test

# For Hub:
docker ps -a | grep hub-agent-test

# Must be empty - no leftover containers
```
```

#### `aos-architecture/templates/work_order_template.md`
Update Section 9.1 to be repository-agnostic:
```markdown
### 9.1 Test Execution (REQUIRED for code changes)
```bash
# Run all tests for your module
bash scripts/run-tests.sh [module_name]
```

**CRITICAL VERIFICATION CHECKLIST:**
- [ ] Tests executed successfully OR
- [ ] Tests failed (expected for validation)
- [ ] Verify `proof_of_execution_tests.log` created
- [ ] **VERIFY CLEANUP:** Run `docker ps -a | grep [repo]-agent-test` → Must be empty
```

---

## 5. Acceptance Criteria

### Functional Requirements

**Script Functionality:**
- [ ] Script accepts one argument (module name)
- [ ] Script validates argument and prints usage if missing
- [ ] Script generates unique project name with timestamp
- [ ] Script finds available port in 8090-8100 range
- [ ] Script starts Docker environment with unique project name
- [ ] Script waits for healthcheck to pass before running tests
- [ ] Script executes tests for specified module
- [ ] Script captures output to `proof_of_execution_tests.log`
- [ ] Script exits with code 0 on test success
- [ ] Script exits with non-zero code on test failure

**Guaranteed Cleanup (MOST CRITICAL):**
- [ ] Script uses `trap cleanup EXIT`
- [ ] Cleanup function calls `docker compose ... down -v --remove-orphans`
- [ ] After successful run: `docker ps -a | grep hub-agent-test` returns empty
- [ ] After failed run: `docker ps -a | grep hub-agent-test` returns empty
- [ ] After interrupted run (Ctrl+C): `docker ps -a | grep hub-agent-test` returns empty

**Docker Configuration:**
- [ ] `docker-compose.agent.yml` has healthcheck for odoo service
- [ ] Healthcheck uses appropriate test command
- [ ] Healthcheck has reasonable interval/timeout/retries

**Documentation:**
- [ ] `README.md` updated with script usage
- [ ] `onboarding_coder_agent.md` updated with repository-agnostic commands
- [ ] `work_order_template.md` updated with repository-agnostic commands
- [ ] All docs emphasize cleanup verification

**Parity with EVV:**
- [ ] Core script logic matches SYSTEM-002-CODE-01 implementation
- [ ] Only repository-specific details differ (project name prefix)

### Testing Requirements (MANDATORY)

**Note:** This work order creates test *infrastructure*, not application code. Testing requirements focus on validation via demonstration.

**Validation Demonstrations:**
- [ ] **Successful Run:** `bash scripts/run-tests.sh traction` exits 0, log shows passing tests, cleanup verified
- [ ] **Failed Run:** Introduce failing test, run script, exits non-zero, log shows failure, cleanup verified
- [ ] **Interrupted Run:** Start script, interrupt with Ctrl+C mid-execution, cleanup verified
- [ ] **Port Exhaustion:** Occupy ports 8090-8100, run script, graceful error message
- [ ] **Healthcheck Timeout:** (Optional) Simulate unhealthy container, verify timeout and cleanup

**Cleanup Verification (MANDATORY for ALL demonstrations):**
```bash
docker ps -a | grep hub-agent-test
# Output MUST be empty
```

**Proof of Execution:**
- [ ] All validation demonstrations captured with command output
- [ ] Cleanup verification shown for each demonstration
- [ ] Code committed with descriptive message
- [ ] Proof logs provided (see Section 9)

---

## 6. Context Management & Iteration Limits

**IMPORTANT:** AI agents have finite context windows. This section prevents context exhaustion.

### Workflow Phases & Checkpoints

**Phase 1: Implementation**
- Write `run-tests.sh` (single comprehensive script)
- Update `docker-compose.agent.yml` (add healthcheck)
- Update documentation files
- **Checkpoint:** `git commit -m "feat(infra): add resilient test runner for hub (SYSTEM-002)"`

**Phase 2: Validation**
- Run all validation demonstrations per acceptance criteria
- Capture all outputs for proof of execution
- Verify cleanup after EVERY run
- **Checkpoint:** Commit proof logs: `git commit -m "docs: add proof of execution for resilient test runner"`

**Phase 3: Bug Fixing - MAXIMUM 2 ITERATIONS**

**Iteration 1:**
- Analyze validation failures, implement fixes, re-validate
- If validation passes, proceed to Proof of Execution
- If still failing, commit attempt and proceed to Iteration 2

**Iteration 2:**
- Try **different approach** to fix issue, re-validate
- If validation passes, proceed to Proof of Execution
- If still failing, **STOP and ESCALATE**

### Escalation Process (After 2 Failed Iterations)

**DO NOT** continue debugging. Instead, document your attempts on the GitHub Issue using the standard escalation template, apply the `status:needs-help` label, and tag `@james-healthrt`.

---

## 7. Required Context Documents

- `@aos-architecture/specs/SYSTEM-002.yaml`
- `@aos-architecture/process_improvement/process-improvement.md` (Entry #012, #014)
- `@aos-architecture/prompts/onboarding_coder_agent.md`
- `@aos-architecture/templates/work_order_template.md`
- `@aos-architecture/standards/01-odoo-coding-standards.md`
- `@SYSTEM-002-CODE-01.md` (for parity reference)

---

## 8. Technical Constraints

- **Odoo Version:** Scripts must work with **Odoo 18.0 Community Edition**
- **Portability:** Scripts must run on Linux environments with bash, Docker, and standard POSIX utilities
- **No Additional Dependencies:** Do not require installation of additional tools beyond Docker and bash
- **Backward Compatibility:** Changes to `docker-compose.agent.yml` must not break existing workflows
- **No sudo:** Scripts must work with Docker user permissions
- **Parity Required:** Core logic must match SYSTEM-002-CODE-01 implementation
- **Change Size:** Keep total diff <500 LOC

**CRITICAL:** The `trap` for cleanup is non-negotiable. This is the primary deliverable.

---

## 9. MANDATORY: Proof of Execution

**YOU MUST COMPLETE THIS AND POST IT TO THE GITHUB ISSUE BEFORE CREATING A PULL REQUEST.**

### 9.1 Successful Test Run
```bash
cd /home/james/development/aos-development/hub
bash scripts/run-tests.sh traction
echo "Exit code: $?"
cat proof_of_execution_tests.log | tail -n 100

# CRITICAL: Verify cleanup
docker ps -a | grep hub-agent-test
echo "Cleanup verified: No orphaned containers"
```

**Provide:**
- Full command output
- Exit code (must be 0)
- Last 100 lines of log showing tests passed
- Cleanup verification (empty output)

### 9.2 Intentional Failure Demonstration
```bash
# Modify a test to fail (e.g., in traction/tests/test_models.py add: self.assertEqual(True, False))
bash scripts/run-tests.sh traction || echo "Expected failure"
echo "Exit code: $?"
cat proof_of_execution_tests.log | tail -n 100

# CRITICAL: Verify cleanup
docker ps -a | grep hub-agent-test
echo "Cleanup verified: No orphaned containers"
```

**Provide:**
- Full command output
- Exit code (must be non-zero)
- Last 100 lines of log showing test failure details
- Cleanup verification (empty output)

### 9.3 Interrupted Execution Test
```bash
# Start script and interrupt with Ctrl+C after ~10 seconds
bash scripts/run-tests.sh traction &
PID=$!
sleep 10
kill -INT $PID
wait $PID

# CRITICAL: Verify cleanup
docker ps -a | grep hub-agent-test
echo "Cleanup verified: No orphaned containers after interrupt"
```

**Provide:**
- Command output showing interruption
- Cleanup verification (empty output)

### 9.4 Port Allocation Test
```bash
# Occupy all ports 8090-8100 (simulate busy system)
# Then run script and show graceful failure
bash scripts/run-tests.sh traction || echo "Expected: No available ports"
```

**Provide:**
- Command output showing port allocation error message

### 9.5 Documentation Review
```bash
# Show updated sections
grep -A 15 "Running Tests" /home/james/development/aos-development/hub/README.md
grep -A 20 "scripts/run-tests.sh" /home/james/development/aos-development/aos-architecture/prompts/onboarding_coder_agent.md
```

**Provide:**
- Relevant excerpts from updated documentation files

