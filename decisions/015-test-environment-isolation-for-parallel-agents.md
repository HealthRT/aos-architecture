# 15. Test Environment Isolation for Parallel Agents

**Date:** 2025-10-12  
**Status:** Approved for Implementation  
**Implementation Target:** Phase 1 complete by end of sprint  
**Related:** ADR-014 (Parallel Agent Coordination), Standard 03 (AI Agent Workflow)

## Context

Per ADR-014, we support multiple agents working in parallel on different modules. Each agent's workflow includes "smoke testing" (boot verification) as part of their Proof of Execution requirements. Currently, all agents share the same Docker environment:

**Current Setup:**
```
Hub: docker-compose up -d  → Single container (odoo_hub on port 8090)
EVV: docker-compose up -d  → Single container (odoo_evv on port 8091)
```

**The Problem:**
When multiple agents work in parallel on the same repository (e.g., Agent A on `traction`, Agent B on `hub_compliance`), they would:
1. Both attempt to install their modules in the same Odoo instance
2. Both restart the same Docker container
3. Potentially interfere with each other's smoke tests
4. Create race conditions during database initialization

**Example Collision Scenario:**
```
Agent A (WO-042): Modifying traction module
  └─ Runs: docker-compose restart odoo

Agent B (WO-043): Modifying hub_compliance module  
  └─ Runs: docker-compose restart odoo (at same time)

Result: Unpredictable state, one agent's test may fail incorrectly
```

## Decision (Proposed)

**We DEFER implementation of isolated test environments until we have active parallel work that requires it.**

**Rationale:**
1. **Current State:** Pattern 1 (Module Isolation - different repos) is our primary parallelization strategy
   - Hub work and EVV work naturally use different Docker environments
   - This handles 90% of parallel work scenarios
2. **Module Isolation within same repo** (Pattern 5) is rare and can be sequential for now
3. **Implementation complexity:** Per-agent containers require significant infrastructure
4. **Cost/benefit:** Low current need vs. high implementation cost

**Future Implementation Path (When Needed):**

### Option A: Dynamic Container Names (Lightweight)

Each agent gets a uniquely named container:

```yaml
# Agent A's docker-compose override
services:
  odoo:
    container_name: odoo_hub_agent_a
    ports:
      - "8090:8069"

# Agent B's docker-compose override  
services:
  odoo:
    container_name: odoo_hub_agent_b
    ports:
      - "8092:8069"
```

**Work Order Instructions:**
```bash
# Agent identifier passed as environment variable
export AGENT_ID="agent-a"
docker-compose -f docker-compose.yml -f docker-compose.agent.yml up -d
```

**Pros:**
- Simple to implement
- Minimal resource overhead
- Agents can't interfere

**Cons:**
- Each agent needs unique port
- Port management complexity
- Database still shared (need DB per agent)

### Option B: Docker Compose Profiles (Moderate)

Use Docker Compose profiles for agent-specific environments:

```yaml
# docker-compose.yml
services:
  odoo-agent-a:
    image: odoo:18.0
    profiles: ["agent-a"]
    ports:
      - "8090:8069"
    volumes:
      - ./addons:/mnt/extra-addons
    depends_on:
      - db-agent-a
      
  db-agent-a:
    image: postgres:15
    profiles: ["agent-a"]
    volumes:
      - db-agent-a-data:/var/lib/postgresql/data

  odoo-agent-b:
    image: odoo:18.0
    profiles: ["agent-b"]
    ports:
      - "8092:8069"
    # ...similar config
```

**Work Order Instructions:**
```bash
# Agent A
COMPOSE_PROFILES=agent-a docker-compose up -d

# Agent B  
COMPOSE_PROFILES=agent-b docker-compose up -d
```

**Pros:**
- Full isolation (separate DB per agent)
- Clean configuration in single file
- No port conflicts

**Cons:**
- More complex docker-compose file
- Higher resource usage (multiple DBs)
- Requires careful profile management

### Option C: GitHub Actions CI (Future)

Move smoke tests to GitHub Actions:

```yaml
# .github/workflows/smoke-test.yml
name: Smoke Test
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
      odoo:
        image: odoo:18.0
    steps:
      - uses: actions/checkout@v3
      - name: Install Module
        run: odoo -i $MODULE_NAME --stop-after-init
      - name: Boot Test
        run: odoo --stop-after-init
```

**Pros:**
- Completely isolated (GitHub provides fresh environment)
- No local resource impact
- Automatic on every push
- Scales infinitely

**Cons:**
- Requires GitHub Actions setup
- Slower feedback (network latency)
- Cost for private repos (Actions minutes)
- Still need local testing during development

## Consequences

### Positive (When Implemented)

1. **True Parallel Work:**
   - Multiple agents can work on same repository simultaneously
   - No interference during smoke tests
   - Predictable, reproducible results

2. **Improved Reliability:**
   - Each agent gets clean environment
   - No "works on my machine" issues
   - Consistent test results

3. **Better Resource Utilization:**
   - Option C moves compute to GitHub infrastructure
   - Local machine not burdened by multiple containers

### Negative

1. **Resource Overhead:**
   - Options A & B: Multiple containers/DBs running locally
   - Higher memory and CPU usage
   - More complex cleanup

2. **Complexity:**
   - Configuration management more involved
   - Port allocation coordination needed
   - More failure modes to debug

3. **Cost:**
   - Option C: GitHub Actions minutes (for private repos)
   - Options A & B: Local compute resources

## Current Workaround

**Until isolated environments are implemented:**

### Pattern 1: Module Isolation (Primary - No Collision)
Different repositories = different Docker environments:
```
Agent A: Works on Hub (port 8090)
Agent B: Works on EVV (port 8091)
→ No collision, fully parallel
```

### Pattern 3: Sequential Stages (Fallback - No Collision)
Same repository, sequential work:
```
Agent A: Completes WO-042 → Merges → Done
Agent B: Starts WO-043 (after A's merge)
→ No collision, but not parallel
```

### File Lock Coordination (Manual)
If parallel work in same repo is critical:
1. Check `WORK_IN_PROGRESS.md`
2. Coordinate smoke test timing in Issue comments
3. Agent A: "Running smoke test 14:30-14:35"
4. Agent B: Waits, then runs test 14:36-14:40

## Implementation Trigger

**We will implement isolated test environments when:**
1. We have 3+ active parallel work orders in the same repository, OR
2. We experience a smoke test collision in production, OR  
3. Pattern 1 (Module Isolation) is insufficient for current workload

**Current Assessment:** Trigger conditions not met. Defer.

## Validation

**Success Metrics (When Implemented):**
- Zero smoke test collisions between agents
- Agents can run smoke tests simultaneously without coordination
- 100% reproducible test results regardless of parallel work

**Monitoring:**
- Track "smoke test collision" incidents in process improvement log
- If >2 incidents in a sprint, triggers implementation
- Review quarterly: Is Pattern 1 still sufficient?

## Related Documentation

- **ADR-014:** Parallel Agent Coordination Patterns (defines Pattern 1: Module Isolation)
- **Standard 03:** AI Agent Workflow (defines smoke test requirement)
- **Process Improvement Entry #009:** Multi-repo confusion (led to ADR-013, ADR-014, this ADR)

## Revision History

- **2025-10-12:** Initial version (v1.0) - Proposed, deferred pending need

---

**Status:** Proposed for future implementation  
**Trigger:** 3+ parallel WOs in same repo, or collision incident  
**Current Workaround:** Pattern 1 (Module Isolation) sufficient for 90% of cases

---

**This ADR is part of Ring 1 (Protected Layer) per ADR-009 Immutable Core Framework.**

