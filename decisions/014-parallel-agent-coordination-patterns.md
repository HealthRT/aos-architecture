# 14. Parallel Agent Coordination Patterns

**Date:** 2025-10-12  
**Status:** Accepted  
**Supersedes:** None  
**Related:** ADR-013 (Repository Boundaries), Standard 03 (AI Agent Workflow)

## Context

As AOS development scales, we increasingly need multiple AI agents working simultaneously to maintain velocity. However, without formal coordination patterns, parallel agent work creates risks:

1. **File Collision:** Two agents modifying the same file simultaneously
2. **Dependency Conflicts:** Agent B starts work that depends on Agent A's unmerged changes
3. **Test Interference:** Parallel test runs affecting each other
4. **Merge Conflicts:** Complex git conflicts requiring human intervention
5. **Context Duplication:** Agents duplicating work they're unaware of

**Historical Context:**

On 2025-10-09, comprehensive parallel agent strategies were discussed and documented in `sessions/2025-10-09/PARALLEL_AGENT_STRATEGY.md`. This 370-line document identified 5 safe parallelization patterns, traffic rules, and coordination tools. However, it remained a session document and was never formally adopted as an official standard (Ring 1).

This ADR formally adopts those strategies as official AOS development standards and adds enforcement mechanisms.

## Decision

We will adopt **5 Parallel Agent Coordination Patterns** as official standards, ranked from safest to most complex:

### Pattern 1: Module Isolation (SAFEST - Primary Pattern)

**Rule:** Each agent works on a **different Odoo module** in separate directories.

**When to Use:**
- Default pattern for all parallel work
- Available whenever work spans multiple modules
- Especially effective in federated architecture (Hub vs EVV)

**Example:**
```
Agent A: hub/addons/traction/          (Hub repo)
Agent B: evv/addons/evv_agreements/    (EVV repo)
Agent C: hub/addons/hub_compliance/    (Hub repo)
```

**Why It's Safe:**
- ✅ Zero file overlap = impossible to have git conflicts
- ✅ Independent testing (separate test suites)
- ✅ Can merge PRs in any order
- ✅ Clear ownership boundaries

**Requirements:**
- Work orders must specify target module
- Each agent gets one module
- Module must follow ADR-013 naming convention

**Enforcement:** 
- Checked via File Lock System (see Pattern 5)
- Module prefix validated by pre-commit hook (ADR-013)

---

### Pattern 2: Layer Separation (SAFE)

**Rule:** Each agent works on a **different architectural layer** within the same module.

**Layers:**
```
Backend:     models/*.py
Frontend:    views/*.xml, static/src/js/*
API:         controllers/api.py
Security:    security/*.xml, security/*.csv
Tests:       tests/*.py
Documentation: docs/*.md
```

**Example:**
```
Agent A: evv_agreements/models/service_agreement.py
Agent B: evv_agreements/views/service_agreement_views.xml
Agent C: evv_agreements/docs/models/service_agreement.md
```

**Why It's Safe:**
- ✅ Different file types/directories
- ✅ Clear architectural boundaries
- ⚠️ May have logical dependencies (frontend needs backend first)

**Requirements:**
- Work order specifies target layer
- Declare dependencies if any (e.g., "Depends on WO-XXX")
- Test layer typically goes last

**Coordination:**
- Backend agent finishes implementation
- Frontend agent can start once backend is testable
- Documentation agent can work in parallel

---

### Pattern 3: Sequential Stages (SAFEST FOR DEPENDENCIES)

**Rule:** Agent B explicitly waits for Agent A to complete and merge first.

**When to Use:**
- Work has clear dependencies (B needs A's code)
- Same file must be modified by multiple agents
- Refactoring work that affects multiple areas

**Example:**
```
Stage 1: Agent A implements feature → PR merged
         ↓
Stage 2: Agent B writes tests for feature → PR merged
         ↓
Stage 3: Agent C documents feature → PR merged
```

**Why It's Safe:**
- ✅ Zero conflicts - each works on completed code
- ✅ Clear dependencies
- ✅ Each stage builds on previous
- ❌ Not truly parallel (but safest for dependent work)

**Requirements:**
- Work orders include "Depends On: #XXX" field
- Dependent work orders marked as "Blocked" until dependency merges
- GitHub Issue tracks dependency chain

**Workflow:**
```markdown
## Dependencies
- **Depends On:** #42 must be merged before starting
- **Blocks:** #45, #46 cannot start until this is done
- **Safe Parallel With:** #50, #51 (different modules)
```

---

### Pattern 4: Feature vs. Testing Split (COMMON)

**Rule:** Coder works on implementation, Tester works on tests (different files within same module).

**Example:**
```
Coder Agent:  models/service_agreement.py (implements feature)
Tester Agent: tests/test_service_agreement.py (writes tests)
```

**Why It Works:**
- ✅ Feature code and test code in different files
- ✅ Tester can write test structure while coder implements
- ⚠️ Tester must sync before running tests
- ⚠️ Requires good communication

**Workflow:**
1. Coder creates feature branch: `feature/WO-042-service-agreement`
2. Coder pushes initial implementation
3. Tester creates branch FROM coder's branch: `feature/WO-042-tests`
4. Tester writes tests while coder refines implementation
5. Both agents coordinate via PR comments
6. Merge tester's branch into coder's branch
7. Submit single PR with both implementation and tests

**Requirements:**
- Coder pushes working stub/interface first
- Tester syncs frequently with coder's branch
- Single PR contains both (tests + implementation)

---

### Pattern 5: File Manifest Pre-Assignment (ADVANCED)

**Rule:** Declare which specific files each agent will touch BEFORE starting work.

**When to Use:**
- Advanced coordination for complex refactoring
- Same module, but different files can be split
- Need maximum parallelism with careful planning

**Example Work Order:**
```markdown
## WO-042: Service Agreement Model
**Agent:** Coder Agent A
**Assigned Files:**
- models/service_agreement.py (lines 1-150 only)
- models/partner.py (add service_agreement_ids field)
**Do NOT Modify:**
- views/* (Agent B owns)
- tests/* (Agent C owns)

## WO-043: Service Agreement Views  
**Agent:** Coder Agent B
**Assigned Files:**
- views/service_agreement_views.xml
**Do NOT Modify:**
- models/* (Agent A owns)
```

**File Lock System:**

Create `WORK_IN_PROGRESS.md` in each repository root:

```markdown
# Active Work - DO NOT MODIFY THESE FILES

| Agent | Issue | Module | Files Locked | Branch | Started |
|-------|-------|--------|--------------|--------|---------|
| Claude | #42 | evv_agreements | models/service_agreement.py | feature/WO-042 | 2025-10-12 10:00 |
| GPT-5 | #43 | evv_agreements | views/service_agreement_views.xml | feature/WO-043 | 2025-10-12 10:15 |
```

**Workflow:**
1. Before starting, agent checks `WORK_IN_PROGRESS.md`
2. If files conflict, agent WAITS or escalates
3. If clear, agent adds their entry
4. Agent modifies ONLY listed files
5. When PR merged, agent removes entry

**Why It Works:**
- ✅ Explicit file ownership prevents conflicts
- ✅ Can work in parallel if no file overlap
- ⚠️ Requires careful planning
- ⚠️ Manual discipline (agents must update the file)

---

## Traffic Rules

### Rule 1: Branch Isolation

Each agent works on their own feature branch from `main`:

```
main
├── feature/WO-042-service-agreement (Agent A)
├── feature/WO-043-agreement-views (Agent B)  
└── feature/WO-044-compliance-audit (Agent C)
```

**Never** work directly on `main` or shared branches.

### Rule 2: Module Prefix Ownership

Per ADR-013:
- `evv_*` modules → EVV repository only
- `hub_*` or `traction*` modules → Hub repository only

This creates natural boundaries for parallel work.

### Rule 3: Dependency Declaration

Every work order must declare:

```markdown
## Dependencies

- **Depends On:** #41, #42 (must be merged first)
- **Blocks:** #45, #46 (wait for this)
- **Safe Parallel With:** #50-60 (different modules)
- **File Conflicts With:** #43 (same files, coordinate!)
```

### Rule 4: Merge Order Protocol

When multiple PRs are ready:

**Priority:**
1. PRs with no dependencies (independent work)
2. PRs that other work depends on (blocking work)
3. Test PRs (after implementation PRs)
4. Documentation PRs (after everything else)

**Example:**
```
PR #42 (Service Agreement Model) → Merge first (others depend on it)
PR #50 (Compliance Module) → Can merge anytime (different module)
PR #43 (Agreement Views) → Merge after #42 (depends on model)
PR #44 (Documentation) → Merge last (documents all above)
```

### Rule 5: Draft PR Visibility

Agents should open **Draft PRs** immediately when starting work:
- Others can see what files are being modified
- Prevents duplicate work
- Enables early feedback
- Shows work-in-progress status

---

## Parallelization Decision Tree

```
START: Can this work be split?
   │
   ├─ YES: Different MODULES?
   │   └─ ✅ Use Pattern 1: Module Isolation (SAFEST)
   │
   ├─ YES: Different LAYERS (models vs views vs docs)?
   │   └─ ✅ Use Pattern 2: Layer Separation
   │
   ├─ YES: Feature vs Tests (different files)?
   │   └─ ✅ Use Pattern 4: Feature/Testing Split
   │
   ├─ YES: Can pre-assign specific files?
   │   └─ ✅ Use Pattern 5: File Manifest (ADVANCED)
   │
   ├─ NO: Work has dependencies (B needs A's code)?
   │   └─ ✅ Use Pattern 3: Sequential Stages
   │
   └─ NO: Same file, complex changes, no clear split?
       └─ ❌ SEQUENTIAL ONLY (one agent, one at a time)
```

---

## Work Assignment Process

### For Scrum Master / Architect

When decomposing a story into work orders:

1. **Identify Parallelization Opportunity:**
   - Can work be split across modules? → Use Pattern 1
   - Can work be split across layers? → Use Pattern 2
   - Are there dependencies? → Use Pattern 3

2. **Create Work Orders with Coordination Info:**
   ```markdown
   ## WO-042: Service Agreement Model
   **Parallelization Pattern:** Module Isolation
   **Safe Parallel With:** WO-050 to WO-060 (all different modules)
   **Blocks:** WO-043 (views need this model)
   ```

3. **Update File Lock System:**
   - Add entries to `WORK_IN_PROGRESS.md` when dispatching
   - Or instruct agents to do so

4. **Monitor for Conflicts:**
   - Check Draft PRs regularly
   - Identify potential collisions early
   - Coordinate resolution before PR submission

---

## Implementation Tools

### Tool 1: File Lock System

**Location:** `hub/WORK_IN_PROGRESS.md` and `evv/WORK_IN_PROGRESS.md`

**Template:** (Created with this ADR)

### Tool 2: GitHub Project Board

**Columns:**
```
📋 Backlog
🎯 Ready for Assignment
👤 Agent A: In Progress
👤 Agent B: In Progress
👤 Agent C: In Progress
🔍 Code Review
✅ Merged
```

Shows at-a-glance who's working on what.

### Tool 3: Work Order Template Enhancement

Add to work order template:

```markdown
## Parallelization Metadata

**Pattern:** [Module Isolation | Layer Separation | Sequential | Feature/Testing Split | File Manifest]
**Safe Parallel With:** [List of WO IDs]
**Depends On:** [List of WO IDs that must merge first]
**Blocks:** [List of WO IDs waiting on this]
**File Manifest:** [List specific files this WO will modify]
```

### Tool 4: Branch Naming Convention

```
feature/WO-{ID}-{short-description}
bugfix/ISSUE-{NUM}-{short-description}
docs/WO-{ID}-{short-description}

Examples:
feature/WO-042-service-agreement-model
feature/WO-043-agreement-views
docs/WO-044-agreement-documentation
```

Pattern reveals the work order and purpose at a glance.

---

## Safety Checklist

Before dispatching parallel work, verify:

- [ ] **Module Isolation?** Each agent has different module (Pattern 1)
- [ ] **Layer Separation?** Each agent has different file types (Pattern 2)
- [ ] **Dependencies Clear?** "Depends On" and "Blocks" documented
- [ ] **File Manifest?** If same module, specific files declared (Pattern 5)
- [ ] **Branch Names?** Follow convention `feature/WO-{ID}-{desc}`
- [ ] **File Lock Updated?** Entries added to `WORK_IN_PROGRESS.md`
- [ ] **Draft PRs?** Agents instructed to open Draft PR on start
- [ ] **Merge Order?** Priority sequence planned

---

## Consequences

### Positive

1. **Increases Development Velocity:**
   - Multiple agents can work simultaneously
   - Hub and EVV can progress in parallel
   - Independent modules never block each other

2. **Reduces Human Coordination Overhead:**
   - Formal patterns eliminate guesswork
   - File Lock System makes conflicts visible
   - Draft PRs show active work automatically

3. **Prevents Conflicts:**
   - Module Isolation (Pattern 1) eliminates 90% of collision risk
   - File Manifest (Pattern 5) handles the remaining 10%
   - Sequential Stages (Pattern 3) used only when necessary

4. **Improves Predictability:**
   - Clear rules for when parallel work is safe
   - Decision tree provides systematic approach
   - Reduces risk of failed merges

5. **Scales Effectively:**
   - Patterns work for 2 agents or 10 agents
   - Federated architecture (Hub/EVV) is naturally parallel
   - Module-per-agent pattern scales indefinitely

### Negative

1. **Requires Upfront Planning:**
   - Scrum Master must analyze parallelization opportunities
   - Work orders must include coordination metadata
   - File manifests require careful thought

2. **Manual File Lock System:**
   - Agents must remember to update `WORK_IN_PROGRESS.md`
   - Human oversight needed to catch violations
   - Future: Automate with GitHub Actions

3. **More Complex Work Orders:**
   - Work orders longer (parallelization metadata)
   - Agents must read and follow coordination rules
   - Templates help, but adds cognitive load

4. **Limited Parallelism in Some Cases:**
   - Complex refactoring still requires sequential work
   - Same-file modifications can't be parallelized
   - Some work inherently sequential

---

## Validation

**Success Metrics:**

| Metric | Before ADR-014 | Target After ADR-014 |
|--------|----------------|----------------------|
| Parallel work incidents (conflicts/collisions) | Unknown (no tracking) | < 5% of parallel work |
| Work orders with parallelization metadata | 0% | 100% |
| File Lock System usage | N/A (didn't exist) | Updated for all parallel work |
| Average time to merge (days) | Unknown | Reduced by 30% (parallel work) |

**Monitoring:**
- Track all parallelization attempts
- Log conflicts that occur despite patterns
- Analyze which patterns are most/least effective
- Refine patterns based on real-world usage

---

## Related Documentation

- **ADR-013:** Repository Boundaries (defines Module Isolation pattern)
- **ADR-009:** Immutable Core Framework (governance for this ADR)
- **Standard 03:** AI Agent Workflow (single-agent workflow)
- **Session 2025-10-09:** `PARALLEL_AGENT_STRATEGY.md` (original research)
- **Work Order Template:** `templates/work_order_template.md` (to be updated)
- **File Lock System:** `hub/WORK_IN_PROGRESS.md`, `evv/WORK_IN_PROGRESS.md`

---

## Revision History

- **2025-10-12:** Initial version (v1.0) - Formal adoption of parallel patterns

---

**This ADR is part of Ring 1 (Protected Layer) per ADR-009 Immutable Core Framework.**

