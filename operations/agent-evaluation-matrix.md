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

#### WO-AGMT-001-05 (Author Documentation for Service Agreements)
**Date:** 2025-10-12  
**Task:** Create comprehensive documentation for evv_agreements module (docs-only, no code changes)

**Results:**
- **Instruction Fidelity:** 🟢 Perfect (100%)
  - ✅ Completed all 20+ checklist items without reminders
  - ✅ Proper git commits with exact specified messages
  - ✅ Proof of execution provided autonomously
  - ✅ Feedback entry written without prompting
  - Context at completion: ~6%
- **Documentation Quality:** 🟢 Excellent
  - 1,070 lines of comprehensive documentation
  - All 10 required sections present and detailed
  - Proper markdown formatting (tables, code blocks, headers)
  - No PHI in examples (generic placeholders used)
  - Accurate technical content verified against code
- **Test Quality:** N/A (documentation task)
  - Boot verification executed properly (clean logs)
- **Context Management:** 🟢 Efficient (~6% context used, 54K tokens)
- **Speed:** 🟡 Moderate (~60 minutes total)

**Overall Score:** 95/100  
**Recommendation:** Highly reliable for complex multi-step tasks. Excellent autonomous execution.

**Specific Achievements:**
1. ✅ Zero reminders needed - completed all phases independently
2. ✅ Comprehensive feedback entry with actionable suggestions
3. ✅ Self-assessed accurately (gave 9/10, matches architectural review)
4. ✅ Provided context for evaluation (acknowledged being tested)

**Strengths:**
- Perfect instruction following (100% checklist completion)
- Exceptional documentation quality (comprehensive, well-organized)
- Strong autonomous execution (no hand-holding required)
- Thoughtful feedback (4 concrete suggestions for improvement)
- Excellent context efficiency (6% vs GPT-5's 70%)

**Weaknesses:**
- Slightly slower than GPT-5 (60 min vs 45 min for comparable work)
- Minor: Needed brief investigation of docker architecture (resolved independently)

**Comparison to GPT-5:**
- **Instruction Fidelity:** Claude 100% vs GPT-5 50% (⭐ Claude wins decisively)
- **Context Efficiency:** Claude 6% vs GPT-5 70% (⭐ Claude wins)
- **Speed:** GPT-5 faster (45 min vs 60 min)
- **Quality:** Both excellent (tie)
- **Autonomy:** Claude completed all steps, GPT-5 required 2 reminders (⭐ Claude wins)

---

### GPT-4 Codex (OpenAI)

#### [Future Evaluation]
**Date:** [Pending]  
**Task:** [To be assigned]

**Results:** [TBD]

---

## Findings & Recommendations

### Current Status (Updated 2025-10-12)
- **2 agents evaluated:** GPT-5, Claude Sonnet 4.5
- **Clear Winner Emerging:** Claude Sonnet 4.5 significantly outperforms on instruction fidelity
- **Key Finding:** Context management highly correlated with instruction following

### Initial Conclusions

#### 1. Instruction Fidelity & Context Management
**Finding:** Claude's superior context efficiency (6% vs 70%) directly correlates with perfect instruction following.

**Hypothesis Confirmed:** Instruction fidelity DOES degrade with context pressure
- GPT-5 at 40% context: Missed test imports
- GPT-5 at 70% context: Forgot feedback entry
- Claude at 6% context: Perfect execution (100%)

**Implication:** For multi-step work orders, Claude's larger effective context window (200K vs GPT-5's ~128K) provides significant reliability advantage.

#### 2. Documentation vs. Code Quality
**Status:** Need more data
- Both agents produced excellent output quality
- GPT-5 tested on code + tests (complex)
- Claude tested on documentation (different skill set)
- **Next:** Need to test Claude on coding work order for fair comparison

#### 3. Speed vs. Reliability Trade-off
**Finding:** GPT-5 is 25% faster but requires supervision
- GPT-5: 45 min + 2 reminders + architect review time
- Claude: 60 min + zero supervision = faster end-to-end
- **Winner:** Claude (true speed includes supervision overhead)

### Proposed Actions (Updated)
1. ✅ Evaluate Claude Sonnet 4.5 on WO-05 (COMPLETE)
2. ✅ Update agent evaluation matrix (COMPLETE)
3. 🎯 **RECOMMENDED:** Assign Claude next coding work order (WO-06 or next feature)
4. ⏳ Evaluate GPT-4 Codex only if Claude fails coding test
5. ⏳ Finalize "Agent Selection Guide"

### Questions Answered
- ✅ **Does instruction fidelity correlate with context size?** YES - Strong correlation
- ✅ **Which agent is most reliable for multi-step tasks?** Claude (100% vs 50%)
- ⏳ **Which agent produces best code quality?** Need coding comparison
- ⏳ **Which agent has best test coverage?** Need coding comparison
- ⏳ **Cost/performance trade-offs?** Need to compare pricing

---

## Agent Selection Guide (Preliminary)

**Status:** Preliminary recommendations based on 2 agents evaluated. Will be finalized after Claude completes coding work order.

### Recommended Agent by Task Type:

| Task Type | Recommended Agent | Confidence | Rationale |
|-----------|------------------|------------|-----------|
| **Documentation** | ⭐ **Claude Sonnet 4.5** | High | Proven: 1,070-line comprehensive doc, perfect execution |
| **Multi-Step Workflows** | ⭐ **Claude Sonnet 4.5** | High | 100% checklist completion vs GPT-5's 50% |
| **Bootstrap/Scaffolding** | 🤔 TBD | Low | Need Claude coding test |
| **Complex Business Logic** | 🤔 TBD | Low | Need Claude coding test |
| **Testing Work Orders** | 🤔 TBD | Low | Need Claude coding test |
| **Refactoring** | 🤔 TBD | Low | Need Claude coding test |
| **Speed-Critical Tasks** | GPT-5 (with supervision) | Medium | 25% faster but needs reminders |

### Preliminary Default Agent:
**⭐ Claude Sonnet 4.5**

**Reasoning:**
1. **Reliability:** 100% instruction fidelity vs 50% for GPT-5
2. **Autonomy:** Zero reminders vs 2 reminders for GPT-5
3. **Context:** 6% usage vs 70% (more headroom for complex tasks)
4. **Quality:** Excellent output (matches GPT-5)
5. **True Speed:** No supervision overhead

**Caveat:** This recommendation is based on one documentation task. Must be validated with coding work order before finalizing.

---

## Notes

**Entry Log:**
- 2025-10-12: Created evaluation framework
- 2025-10-12: Completed GPT-5 evaluation (WO-AGMT-001-01)

**Next Steps:**
- Assign WO-02 to Claude Sonnet 4.5
- Track all metrics
- Update guide after 3 agents evaluated

