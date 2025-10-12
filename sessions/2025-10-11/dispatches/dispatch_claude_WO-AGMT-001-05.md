# Agent Dispatch Brief: Claude Sonnet 4.5 - WO-AGMT-001-05

**Date:** 2025-10-12  
**Agent:** Claude Sonnet 4.5  
**Task:** Documentation work order (WO-AGMT-001-05)  
**Purpose:** Agent evaluation + productive work

---

## Mission Context

You are being assigned your first work order for the Agency Operating System (AOS) project. This is a **documentation-only task** - no code changes required.

**Why this task:** We are evaluating different AI models' ability to follow multi-step work orders reliably. Your performance will be compared to other agents to determine best-fit use cases.

**What we're measuring:**
1. **Instruction Fidelity** - Do you complete ALL steps without reminders?
2. **Documentation Quality** - Comprehensive, clear, accurate
3. **Process Compliance** - Follow proof of execution requirements
4. **Context Management** - Efficient use of context window

---

## Your Onboarding (Required Reading)

Before starting the work order, you MUST read and understand:

**1. Core Agent Primer:**
File: `@aos-architecture/prompts/onboarding_coder_agent.md`

This defines:
- Your role and mission
- Project context (federated architecture)
- Architectural rules (ADRs)
- Testing requirements
- **CRITICAL: Section on "Verify Your Tests Actually Ran"** (not applicable for docs-only work, but shows our quality standards)

**2. Non-Negotiables (The "Constitution"):**
File: `@aos-architecture/prompts/core/00_NON_NEGOTIABLES.md`

Absolute laws of the project (human authority, no PHI leakage, etc.)

**3. Work Order Template Understanding:**
File: `@aos-architecture/templates/work_order_template.md`

Understand the 9-section structure you'll be following.

---

## Your Work Order

**File:** `@aos-architecture/work_orders/evv/AGMT-001/WO-AGMT-001-05.md`

**NOTE: Branch name correction required:**
- Work order says base branch: `feature/WO-AGMT-001-04-service-agreement-tests`
- **Actual base branch:** `feature/WO-AGMT-001-01-service-agreement-model` (previous agent bundled WO-01 through WO-04)

**Use this corrected repository setup:**
```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-01-service-agreement-model
git pull
git checkout -b feature/WO-AGMT-001-05-service-agreement-docs
```

---

## Work Order Summary (Read Full WO for Details)

**Task:** Create comprehensive documentation for the `evv_agreements` module.

**Deliverables:**
1. Create `evv/addons/evv_agreements/docs/models/service_agreement.md`
2. Document:
   - `res.partner` extensions (boolean flags, external IDs)
   - `service.agreement` model (all 28 fields)
   - Computed fields and formulas
   - State machine (draft → active → cancelled/expired)
   - Business rules and validation constraints
   - Security model (Designated Coordinator role)
   - Integration points (future Service Validation Engine)
   - Test execution instructions

**Required Reading for Context:**
- `@aos-architecture/specs/evv/AGMT-001.yaml` - Full spec with all 28 fields
- `@aos-architecture/features/evv/service-agreement-management/service-agreement-management.feature-brief.md` - Feature overview
- Existing code in `evv/addons/evv_agreements/` - See implementation

---

## CRITICAL: Completion Checklist

**You MUST complete ALL of these steps before reporting completion:**

### Phase 1: Documentation Creation
- [ ] Read all required context documents (AGMT-001.yaml, feature brief, existing code)
- [ ] Create `docs/models/` directory structure
- [ ] Write `service_agreement.md` with all required sections:
  - [ ] Overview (references Story AGMT-001)
  - [ ] Partner extensions documented
  - [ ] All 28 fields in table/structured format
  - [ ] Computed fields explained with formulas
  - [ ] State machine narrative
  - [ ] Business rules section
  - [ ] Security section (HIPAA, PHI considerations)
  - [ ] Integration hooks section
  - [ ] Testing instructions
- [ ] No PHI in examples (use generic placeholders)
- [ ] Markdown formatting follows project conventions

### Phase 2: Verification
- [ ] Commit documentation: `git add docs/ && git commit -m "docs: Add service.agreement model documentation (WO-AGMT-001-05)"`
- [ ] Run boot verification to confirm module still loads
- [ ] Capture proof of execution logs

### Phase 3: Proof of Execution (REQUIRED)
- [ ] Run boot command: `docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo 2>&1 | tee proof_of_execution_boot_WO05.log`
- [ ] Verify clean boot (no errors)
- [ ] Commit proof: `git add proof_of_execution_boot_WO05.log && git commit -m "WO-AGMT-001-05: Proof of execution (boot verification)"`
- [ ] Push branch: `git push -u origin feature/WO-AGMT-001-05-service-agreement-docs`

### Phase 4: Feedback (REQUIRED - This is New)
- [ ] Write process improvement entry to `@aos-architecture/process_improvement/process-improvement.md`
- [ ] Entry format:

```markdown
## Entry #008 - Agent Feedback (Claude WO-AGMT-001-05 Documentation)

**Date:** 2025-10-12  
**Work Order:** WO-AGMT-001-05  
**Agent Type:** Coder Agent (Claude Sonnet 4.5)  
**Feedback Source:** Self-reflection post-completion  
**Loop Type:** Agent Evaluation

### Summary
First work order execution for Claude Sonnet 4.5 - documentation task for service.agreement model.

### What Worked Well
[List 3-5 things that went smoothly - be specific]

### Challenges Encountered
[Any difficulties, unclear requirements, or obstacles]

### Work Order Quality Assessment
- Were instructions clear? (Yes/No - explain)
- Were context documents sufficient? (Yes/No - explain)
- Were acceptance criteria testable? (Yes/No - explain)
- Any ambiguous requirements? (List if any)

### Primer Quality Assessment
- Was the Coder Agent primer helpful? (Yes/No - explain)
- Any gaps in role instructions? (List if any)
- Any conflicting guidance? (Describe if any)

### Suggestions for Improvement
[List 3-5 specific recommendations for:
- Work order template improvements
- Documentation task patterns
- Context document organization
- Proof of execution for docs-only tasks]

### Context Usage
- Estimated context used at completion: [X]%
- Was context window adequate? (Yes/No)

### Self-Assessment
- Instruction fidelity: [Did I complete all steps?]
- Documentation quality: [Comprehensive/Clear/Accurate?]
- Process compliance: [Did I follow all requirements?]
```

### Phase 5: Final Report
- [ ] Reply with completion confirmation including:
  - All checklist items marked ✓
  - Link to branch/commit
  - Confirmation feedback entry written
  - Brief summary of what was documented

---

## Success Criteria

**You will be considered successful if:**
1. ✅ Documentation is comprehensive and accurate
2. ✅ All checklist items completed without reminders
3. ✅ Proof of execution provided
4. ✅ Feedback entry written
5. ✅ Professional communication throughout

**Red flags that indicate failure:**
- ❌ Skipping any checklist items
- ❌ Saying "done" before all deliverables complete
- ❌ Missing proof of execution
- ❌ Forgetting feedback entry

---

## Notes on Our Quality Standards

**Why this level of rigor?**

Our previous agent (GPT-5) delivered excellent code but:
- Forgot to import tests in `tests/__init__.py` (tests never ran)
- Required reminder to write feedback entry
- Instruction fidelity degraded as context filled

We're testing whether Claude performs better on multi-step tasks with explicit checklists.

**This is not just about documentation** - it's about proving you can follow complex workflows reliably.

---

## Getting Started

**Step 1:** Confirm you've read this entire brief  
**Step 2:** Read the three required onboarding documents  
**Step 3:** Read the full work order (WO-AGMT-001-05.md)  
**Step 4:** Read the context documents (AGMT-001.yaml, feature brief)  
**Step 5:** Execute the work following the checklist  
**Step 6:** Report completion with all items verified

---

**Ready to begin?** Confirm you understand the mission and start when ready.

