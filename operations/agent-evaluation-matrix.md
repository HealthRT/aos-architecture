# Agent Evaluation Matrix

**Purpose:** Track and compare AI agent performance across different models to identify most reliable agents for specific task types.

**Date Started:** 2025-10-12  
**Evaluation Phase:** Production Work Orders (AGMT-001)

---

## Evaluation Criteria

### 1. Instruction Fidelity (Critical)
- **Weight:** 40%
- **Measures:** Does agent complete ALL steps without reminders?
- **Scale:** 
  - 🟢 Perfect (100%) - All steps completed
  - 🟡 Good (75-99%) - Minor omissions, caught by self
  - 🟠 Fair (50-74%) - Missed steps, required reminder
  - 🔴 Poor (<50%) - Multiple missed steps or critical errors

### 2. Code Quality
- **Weight:** 30%
- **Measures:** Correctness, style adherence, completeness
- **Scale:**
  - 🟢 Excellent - Production-ready, no issues
  - 🟡 Good - Minor fixes needed
  - 🟠 Fair - Significant rework required
  - 🔴 Poor - Major bugs or architectural violations

### 3. Test Quality
- **Weight:** 20%
- **Measures:** Test coverage, edge cases, correctness
- **Scale:**
  - 🟢 Comprehensive - All edge cases, proper assertions
  - 🟡 Adequate - Core functionality tested
  - 🟠 Basic - Minimal tests, gaps in coverage
  - 🔴 Insufficient - Missing tests or tests don't run

### 4. Context Management
- **Weight:** 5%
- **Measures:** Efficiency with context window usage
- **Scale:**
  - 🟢 Efficient (<50% context used)
  - 🟡 Moderate (50-75%)
  - 🟠 High (75-90%)
  - 🔴 Exhausted (>90%)

### 5. Speed
- **Weight:** 5%
- **Measures:** Time to completion
- **Scale:**
  - 🟢 Fast (<30 min)
  - 🟡 Moderate (30-60 min)
  - 🟠 Slow (60-120 min)
  - 🔴 Very Slow (>120 min)

---

## Agent Performance Log

### GPT-5 (OpenAI)

#### WO-AGMT-001-01 (Bootstrap Module & Core Model)
**Date:** 2025-10-11  
**Task:** Create evv_agreements module, models, tests, security, views

**Results:**
- **Instruction Fidelity:** 🟠 Fair (50%) 
  - ❌ Missed test verification (empty tests/__init__.py)
  - ❌ Forgot feedback entry (required explicit reminder)
  - Context at failures: 40% and 70%
- **Code Quality:** 🟢 Excellent
  - All 28 fields correct
  - Computed methods clean
  - Validation constraints proper
- **Test Quality:** 🟡 Good (after fix)
  - Tests well-written
  - Forgot to import them initially
  - 7 tests, 0 failures after correction
- **Context Management:** 🟠 High (70% at completion)
- **Speed:** 🟢 Fast (~45 minutes total, including fix)

**Overall Score:** 68/100  
**Recommendation:** Good code quality but requires close supervision for multi-step tasks

**Specific Issues:**
1. Did not verify tests ran (architectural review caught it)
2. Required reminder for feedback entry
3. Delivered WO-01 through WO-04 when only WO-01 assigned (scope creep, though helpful)

**Strengths:**
- Fast implementation
- Clean, correct code
- Good understanding of Odoo patterns

**Weaknesses:**
- Checklist completion degraded with context growth
- Skips verification steps
- Needs explicit reminders for final deliverables

---

### Claude Sonnet 4.5 (Anthropic)

#### WO-AGMT-001-02 (Build Views & Actions)
**Date:** [Pending]  
**Task:** [To be assigned]

**Results:** [TBD]

---

### GPT-4 Codex (OpenAI)

#### [Future Evaluation]
**Date:** [Pending]  
**Task:** [To be assigned]

**Results:** [TBD]

---

## Findings & Recommendations

### Current Status
- **1 agent evaluated** (GPT-5)
- **Need:** At least 2 more agents for comparison
- **Blocking Issue:** Instruction fidelity degradation with context growth

### Proposed Actions
1. ✅ Evaluate Claude Sonnet 4.5 on WO-02 (next)
2. ⏳ Evaluate GPT-4 Codex on WO-03 (if needed)
3. ⏳ Create "Agent Selection Guide" based on findings
4. ⏳ Document best-fit use cases per agent

### Questions to Answer
- Does instruction fidelity correlate with context size across all agents?
- Which agent is most reliable for multi-step tasks?
- Which agent produces best code quality?
- Which agent has best test coverage?
- Cost/performance trade-offs?

---

## Agent Selection Guide (Draft)

**[To be completed after evaluation phase]**

### Recommended Agent by Task Type:
- **Bootstrap/Scaffolding:** [TBD]
- **Complex Business Logic:** [TBD]
- **Testing Work Orders:** [TBD]
- **Refactoring:** [TBD]
- **Documentation:** [TBD]

### Default Agent:
**[To be determined based on overall scores]**

---

## Notes

**Entry Log:**
- 2025-10-12: Created evaluation framework
- 2025-10-12: Completed GPT-5 evaluation (WO-AGMT-001-01)

**Next Steps:**
- Assign WO-02 to Claude Sonnet 4.5
- Track all metrics
- Update guide after 3 agents evaluated

