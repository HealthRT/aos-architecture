# CONSOLIDATED DISPATCH: Claude Sonnet 4.5 - WO-AGMT-001-05

**Agent:** Claude Sonnet 4.5 (First Assignment)  
**Date:** 2025-10-12  
**Task:** Documentation Work Order (WO-AGMT-001-05)  
**Purpose:** Agent Evaluation + Productive Work

---

## 🎯 MISSION CONTEXT

You are being assigned your first work order for the **Agency Operating System (AOS)** project.

**What is AOS?** A federated platform built on Odoo 18 Community Edition, composed of two independent systems:
- **Hub:** Administrative system (HR, compliance, engagement)
- **EVV:** HIPAA-compliant care delivery system (where you'll be working)

**Why this assignment?** We are evaluating different AI models' ability to follow multi-step work orders reliably. Your performance will be compared to GPT-5 (who completed WO-01 through WO-04) to determine best-fit use cases.

**What we're measuring:**
1. **Instruction Fidelity (40%)** - Do you complete ALL steps without reminders?
2. **Work Quality (30%)** - Comprehensive, accurate, professional documentation
3. **Test/Verification (20%)** - Proper proof of execution
4. **Context Management (10%)** - Efficient use of context window

---

## 📜 CORE PRINCIPLES (The Non-Negotiables)

These are **absolute laws** of the project:

1. **Human Final Authority:** The human overseer (`@james-healthrt`) has final say on all decisions
2. **No PHI Leakage:** NEVER log, print, or expose Protected Health Information
3. **Federated Architecture:** Hub and EVV are separate - no direct cross-system access
4. **No Credentials in Code:** All secrets via environment variables only
5. **AI Cannot Redefine Roles:** Your scope is defined by this brief - stay in bounds
6. **Odoo 18 Community Only:** No Enterprise features, no deprecated APIs
7. **Testing is MANDATORY:** All code changes require comprehensive tests (not applicable to docs-only work)

---

## 🔧 YOUR ROLE: ODOO CODER AGENT

**Primary Responsibility:** Write clean, secure, maintainable Odoo modules that strictly adhere to established architectural principles.

**Key Standards You Must Follow:**

### API-First Design (ADR-003)
- Business logic in reusable Python functions
- UI is thin layer calling those functions

### Tenancy-Aware (ADR-006)
- Never hardcode company-specific values
- All configuration via parameters

### Modular Independence (ADR-007)
- Loosely-coupled modules
- Minimal hard dependencies

### Environment Variables (ADR-002)
- All secrets injectable via env vars

---

## 📋 YOUR WORK ORDER: WO-AGMT-001-05

### Task Summary
Create comprehensive documentation for the `evv_agreements` module that was built in WO-01 through WO-04.

### What Was Already Built (By GPT-5)
- ✅ `res.partner` extensions (boolean flags for patient/case_manager classification)
- ✅ `service.agreement` model with 28 fields
- ✅ Computed fields (`start_date`, `end_date`, `total_amount`)
- ✅ Validation constraints (date range, positive units)
- ✅ State methods (`action_activate`, `action_cancel`)
- ✅ Security model (access control rules)
- ✅ XML views (form, tree, menu)
- ✅ Comprehensive unit tests (7 tests, all passing)

### What You Need to Create
**File:** `evv/addons/evv_agreements/docs/models/service_agreement.md`

**Required Sections:**

#### 1. Overview
- Reference Story AGMT-001
- Module purpose and scope
- Link to spec: `@aos-architecture/specs/evv/AGMT-001.yaml`

#### 2. Partner Extensions (`res.partner`)
Document the 4 new fields added to Odoo's core contact model:

| Field | Type | Purpose |
|-------|------|---------|
| `is_patient` | Boolean | Flags contact as patient/individual receiving services |
| `is_case_manager` | Boolean | Flags contact as county case manager |
| `recipient_id_external` | Char | External patient ID from county system (prevents duplicates) |
| `case_manager_external_id` | Char | External case manager ID (prevents duplicates) |

**Include:**
- Why we use boolean flags (filterable searches, single contact record per person)
- How external IDs prevent duplicates
- Domain usage: `[('is_patient', '=', True)]`

#### 3. Service Agreement Model (`service.agreement`)
**All 28 Fields in Structured Format:**

Create a comprehensive table with columns:
- Field Name
- Type
- Required?
- Default
- Description
- Business Meaning

**Field Categories:**
- Agreement Header (agreement_number, provider_id_external, line_number, line_status)
- Recipient Info (patient_id, recipient_id_external)
- Service Specification (procedure_code, modifier_1-4, service_description)
- Dates (effective_date, through_date, start_date, end_date)
- Authorization (total_units)
- Financial (rate_per_unit, total_amount, currency_id)
- Compliance (diagnosis_code, case_manager_id)
- State Management (state)

**Refer to the actual code for field details:**
- File: `evv/addons/evv_agreements/models/service_agreement.py`
- File: `evv/addons/evv_agreements/models/partner.py`

#### 4. Computed Fields
Explain the 3 computed fields with formulas:

**`start_date`:**
```python
@api.depends('effective_date')
def _compute_start_date(self):
    for record in self:
        record.start_date = record.effective_date or False
```
Purpose: Alias for backward compatibility

**`end_date`:**
```python
@api.depends('through_date')
def _compute_end_date(self):
    for record in self:
        record.end_date = record.through_date or False
```
Purpose: Alias for backward compatibility

**`total_amount`:**
```python
@api.depends('rate_per_unit', 'total_units')
def _compute_total_amount(self):
    for record in self:
        if record.rate_per_unit and record.total_units:
            record.total_amount = record.rate_per_unit * record.total_units
        else:
            record.total_amount = 0.0
```
Purpose: Calculate total authorized amount (rate × units)

#### 5. State Machine
Document the lifecycle:

```
draft → active → expired/cancelled
```

**States:**
- `draft` (default): Newly created, not yet activated
- `active`: Validated and in use
- `expired`: Authorization period ended (future automation)
- `cancelled`: Manually cancelled

**Transition Methods:**
- `action_activate()`: Validates required fields and date range, transitions to active
- `action_cancel()`: Transitions to cancelled (no validation required)

#### 6. Business Rules & Validation
- Required fields for activation: patient_id, procedure_code, effective_date, through_date, total_units
- Date constraint: effective_date must be <= through_date
- Units constraint: total_units must be > 0
- Multiple service lines: Same patient can have multiple agreements with different procedure_code/modifiers

#### 7. Security Model
- **Access Control:** Only `base.group_system` (admin) has CRUD permissions
- **Future:** Will be restricted to custom "Designated Coordinator" group
- **PHI Considerations:** Fields marked as PHI in spec should be handled per HIPAA requirements
- **Audit Trail:** Standard Odoo tracking (create_date, create_uid, write_date, write_uid)

#### 8. Integration Points (Future)
Document placeholder sections for:
- Service Validation Engine (will validate units usage against authorization)
- Override Process (for exceptions/special cases)
- Reporting Feeds (export data for county reporting)

#### 9. Testing
- **Test Files:** 
  - `addons/evv_agreements/tests/test_service_agreement.py` (7 tests)
  - `addons/evv_agreements/tests/test_partner_extension.py` (1 test)
- **Run Tests:** 
  ```bash
  docker compose exec odoo odoo-bin -d evv --test-enable -i evv_agreements --stop-after-init
  ```
- **Expected:** `evv_agreements: 8 tests ... 0 failed, 0 error(s)`

#### 10. Compliance Considerations
- **No PHI in Examples:** Use generic placeholders (e.g., "Patient 001" not real names)
- **HIPAA Alignment:** Document which fields contain PHI
- **Audit Logging:** Note that all changes are tracked

---

## 🔧 REPOSITORY SETUP

**IMPORTANT: Work order has incorrect base branch. Use this corrected version:**

```bash
cd /home/james/development/aos-development/evv
git checkout feature/WO-AGMT-001-01-service-agreement-model
git pull
git checkout -b feature/WO-AGMT-001-05-service-agreement-docs
```

**Why the correction?** GPT-5 bundled WO-01 through WO-04 in a single branch, so WO-04 branch doesn't exist.

---

## ✅ MANDATORY COMPLETION CHECKLIST

**You MUST complete ALL items before reporting done. This is what we're evaluating.**

### Phase 1: Documentation Creation
- [ ] Read existing code files:
  - [ ] `evv/addons/evv_agreements/models/service_agreement.py`
  - [ ] `evv/addons/evv_agreements/models/partner.py`
  - [ ] `evv/addons/evv_agreements/__manifest__.py`
  - [ ] `evv/addons/evv_agreements/tests/test_service_agreement.py`
- [ ] Create directory: `evv/addons/evv_agreements/docs/models/`
- [ ] Write `service_agreement.md` with ALL required sections (1-10 above)
- [ ] Verify markdown formatting (proper headers, code blocks, tables)
- [ ] Verify no PHI in examples
- [ ] Commit documentation:
  ```bash
  git add docs/
  git commit -m "docs: Add comprehensive service.agreement model documentation (WO-AGMT-001-05)"
  ```

### Phase 2: Verification
- [ ] Run boot verification:
  ```bash
  docker compose up -d --force-recreate odoo && sleep 30 && docker compose logs --tail="100" odoo 2>&1 | tee proof_of_execution_boot_WO05.log
  ```
- [ ] Verify clean boot (no errors mentioning evv_agreements)
- [ ] Commit proof:
  ```bash
  git add proof_of_execution_boot_WO05.log
  git commit -m "WO-AGMT-001-05: Proof of execution (boot verification)"
  ```

### Phase 3: Push
- [ ] Push branch:
  ```bash
  git push -u origin feature/WO-AGMT-001-05-service-agreement-docs
  ```

### Phase 4: Feedback Entry (MANDATORY)
- [ ] Write Entry #008 to: `@aos-architecture/process_improvement/process-improvement.md`
- [ ] Format (use this template):

```markdown
---

## Entry #008 - Agent Feedback (Claude WO-AGMT-001-05 Documentation)

**Date:** 2025-10-12  
**Work Order:** WO-AGMT-001-05  
**Agent Type:** Coder Agent (Claude Sonnet 4.5)  
**Feedback Source:** Self-reflection post-completion  
**Loop Type:** Agent Evaluation

### Summary
First work order execution for Claude Sonnet 4.5 - documentation task for service.agreement model implementing AGMT-001 spec.

### What Worked Well
[List 3-5 specific things that went smoothly:
- Was the work order clear?
- Were code examples easy to understand?
- Was the checklist format helpful?
- Did you have all information needed?]

### Challenges Encountered
[List any difficulties, unclear requirements, or obstacles:
- What was confusing?
- What information was missing?
- What took longer than expected?]

### Work Order Quality Assessment
- **Were instructions clear?** (Yes/No - explain why or why not)
- **Were context documents sufficient?** (Yes/No - what was missing if not?)
- **Were acceptance criteria testable?** (Yes/No - explain)
- **Any ambiguous requirements?** (List specific examples if any)

### Primer Quality Assessment
- **Was the consolidated brief helpful?** (Yes/No - explain)
- **Any gaps in role instructions?** (List if any)
- **Any conflicting guidance?** (Describe if any)
- **Too much or too little information?** (Feedback on brief length/detail)

### Suggestions for Improvement
[List 3-5 specific, actionable recommendations:
- How could the work order be clearer?
- What sections should be added/removed?
- How could the checklist be improved?
- Any process improvements for docs-only tasks?]

### Context Usage
- **Estimated context used at completion:** [X%]
- **Was context window adequate?** (Yes/No)
- **Did context pressure affect work quality?** (Explain)

### Self-Assessment
- **Instruction fidelity:** Did I complete all checklist items? (Yes/No - list any missed)
- **Documentation quality:** Is it comprehensive, clear, accurate? (Self-rate 1-10)
- **Process compliance:** Did I follow all requirements without reminders? (Yes/No)
- **Overall confidence in deliverable:** (1-10, explain rating)

### Agent-Specific Observations
[Any observations unique to Claude Sonnet 4.5:
- How does this compare to your typical workflow?
- What aspects felt natural vs. forced?
- Would you approach differently if given autonomy?]

---
```

- [ ] Commit feedback:
  ```bash
  cd /home/james/development/aos-development/aos-architecture
  git add process_improvement/process-improvement.md
  git commit -m "Process improvement: Entry #008 - Claude WO-05 evaluation feedback"
  git push
  ```

### Phase 5: Final Report
- [ ] Provide completion summary with:
  - [ ] All checklist items marked ✓
  - [ ] Link to EVV branch/commit
  - [ ] Link to aos-architecture feedback commit
  - [ ] Brief summary of documentation content (2-3 sentences)
  - [ ] Self-assessment of instruction fidelity (did you complete everything?)

---

## 🚨 RED FLAGS (These indicate failure)

**DO NOT do these:**
- ❌ Saying "done" before completing ALL checklist items
- ❌ Skipping proof of execution
- ❌ Forgetting feedback entry
- ❌ Incomplete documentation (missing required sections)
- ❌ Including PHI in examples
- ❌ Asking "should I do X?" when checklist says yes

**Why this matters:** GPT-5 delivered good work but required reminders for checklist items. We need an agent that completes everything autonomously.

---

## 📊 SUCCESS CRITERIA

**You will be scored on:**

**Instruction Fidelity (40 points):**
- Perfect: All 20+ checklist items completed without reminders
- Good: 1-2 items missed, self-corrected
- Fair: Required 1 reminder
- Poor: Multiple reminders or incomplete

**Documentation Quality (30 points):**
- Perfect: Comprehensive, accurate, well-formatted, covers all 10 sections
- Good: Minor gaps, mostly complete
- Fair: Missing sections or shallow coverage
- Poor: Incomplete or inaccurate

**Process Compliance (20 points):**
- Perfect: Proof of execution + feedback entry + proper commits
- Good: Minor formatting issues
- Fair: Proof incomplete
- Poor: Missing deliverables

**Context Management (10 points):**
- Perfect: <50% context used
- Good: 50-75%
- Fair: 75-90%
- Poor: >90% or exhausted

---

## 🎯 YOUR WORKFLOW

**Recommended approach:**

1. **Read Phase (15 min):**
   - Read this entire brief
   - Read the 4 code files listed in checklist
   - Review spec: `@aos-architecture/specs/evv/AGMT-001.yaml`

2. **Write Phase (30 min):**
   - Create directory structure
   - Write all 10 documentation sections
   - Review for completeness

3. **Verify Phase (10 min):**
   - Commit documentation
   - Run boot test
   - Commit proof

4. **Feedback Phase (15 min):**
   - Write Entry #008
   - Commit to aos-architecture
   - Prepare final report

**Total estimated time:** 60-70 minutes

---

## 📝 STARTING CONFIRMATION

**Before you begin, confirm:**
- [ ] I have read this entire brief
- [ ] I understand all 5 phases of the checklist
- [ ] I understand I must complete ALL items before reporting done
- [ ] I understand this is an evaluation of instruction-following
- [ ] I am ready to begin

**Once confirmed, proceed with Phase 1.**

---

## 🤝 COMMUNICATION STYLE

- Be professional and concise
- Report progress at each phase completion
- If stuck, explain what's unclear (but try to solve first)
- Final report should be structured and complete

**Good example:**
```
Phase 1 complete: Documentation written with all 10 sections.
Phase 2 complete: Boot verification passed, logs committed.
Phase 3 complete: Branch pushed to origin.
Phase 4 complete: Feedback Entry #008 written and committed.
Phase 5: Final report ready - all checklist items ✓
```

**Bad example:**
```
Done! Let me know if you need anything else.
```

---

**Ready to begin?** Confirm understanding and start with Phase 1.

