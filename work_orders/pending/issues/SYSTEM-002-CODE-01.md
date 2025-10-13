---
title: "[INFRASTRUCTURE] SYSTEM-002-CODE-01: Resilient Test Runner for evv"
labels: agent:coder,module:evv-compliance,priority:high
assignee: aos-coder-agent
---

## Work Order: SYSTEM-002-CODE-01

**Repository:** HealthRT/evv  
**Story:** SYSTEM-002 - Resilient Test Environment  
**REPLACES:** SYSTEM-001-CODE-01

### Objective
Create a hardened, single-command `run-tests.sh` script for the `evv` repository that guarantees Docker resource cleanup even on failure or crash. This resolves the critical port-conflict blocker documented in Process Improvement Entry #012 and Entry #014.

**CRITICAL:** The `trap` command for guaranteed cleanup is non-negotiable. This is the primary deliverable.

### Branch
`feature/SYSTEM-002-CODE-01-evv-resilient-test-runner`

### Key Deliverables
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
- [ ] Script uses `trap cleanup EXIT`
- [ ] Cleanup function calls `docker compose ... down -v --remove-orphans`
- [ ] After successful run: `docker ps -a | grep evv-agent-test` returns empty
- [ ] After failed run: `docker ps -a | grep evv-agent-test` returns empty
- [ ] After interrupted run (Ctrl+C): `docker ps -a | grep evv-agent-test` returns empty
- [ ] `docker-compose.agent.yml` has healthcheck for odoo service
- [ ] Healthcheck uses appropriate test command
- [ ] Healthcheck has reasonable interval/timeout/retries
- [ ] `README.md` updated with script usage
- [ ] `onboarding_coder_agent.md` updated with new command
- [ ] `work_order_template.md` updated with new command
- [ ] All docs emphasize cleanup verification

### Reference
Full work order: `aos-architecture/work_orders/pending/SYSTEM-002-CODE-01.md`

### Acceptance Criteria
All items in work order Section 5 must be satisfied with proof of execution documented in GitHub issue comments, with mandatory cleanup verification for ALL test runs.

