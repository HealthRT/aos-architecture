# Odoo-Aware Decomposition: Validation Strategy

**Date:** 2025-10-12  
**Status:** Validation Framework  
**Related:** Scrum Master Primer Section 3.1, Process Improvement

---

## 🎯 **The Critical Question**

**User:** "How successful is the Odoo-aware decomposition going to actually be? What data drives those decisions? And how do we test that they are in fact accurate?"

**Short Answer:** **We don't know yet. We have hypotheses based on limited data. We need empirical validation.**

---

## 📊 **Current State: Data Sources**

### **What Data We HAVE:**

1. **One Real Incident (Entry #009):**
   - GPT-5 created `evv_agreements` module without visible problems initially
   - Module eventually worked when security CSV was added
   - **However:** We don't know if it would have failed bootability test because the test wasn't run correctly

2. **General Odoo Knowledge:**
   - Odoo requires `__manifest__.py`, `__init__.py` for all modules (documented in Odoo)
   - Models without security CSV cause installation failures (documented behavior)
   - Views referencing non-existent models cause errors (standard MVC principle)

3. **One Scrum Master Run (AGMT-001):**
   - Created 5 work orders for Service Agreement feature
   - WO-01 included: Model + Security + Tests
   - **However:** This was before Odoo-aware guidance existed

### **What Data We DON'T HAVE:**

1. **No validation that the decomposition patterns prevent actual problems**
2. **No data on whether agents can successfully implement vertical slices**
3. **No comparison: vertical slice vs. layer-by-layer success rates**
4. **No evidence on optimal work order sizing (< 100, 100-300, 300-500 LOC)**
5. **No data on whether Scrum Master follows the patterns consistently**

---

## ⚠️ **Honesty Check: Level of Confidence**

| Recommendation | Confidence Level | Evidence Type | Validation Status |
|----------------|------------------|---------------|-------------------|
| **Models need security CSV** | ✅ **HIGH (95%)** | Odoo docs + incident | ✅ Validated by Entry #009 |
| **Vertical slice > Layer-by-layer** | ⚠️ **MEDIUM (70%)** | General best practice | ❌ Not validated in THIS project |
| **300-500 LOC is "large"** | ⚠️ **LOW (50%)** | Gut instinct | ❌ No data |
| **Every WO must boot Odoo** | ✅ **HIGH (90%)** | Logical requirement | ⚠️ Partially validated (we need boots for testing) |
| **Pattern A preferred over Pattern B** | ⚠️ **MEDIUM (60%)** | Agile literature | ❌ Not validated in THIS project |

**Bottom Line:** We have **one strong rule** (models need security), and several **educated guesses** that need validation.

---

## 🔬 **Validation Strategy: How to Test Decomposition Patterns**

### **Phase 1: Immediate Validation (Next 2-3 Work Orders)**

**Goal:** Test if the patterns are even being followed

**Metrics to Track:**

1. **Adherence Rate:**
   - Does Scrum Master create vertical slices or layer-by-layer?
   - Are work orders within sizing guidelines?
   - Pattern used (A or B), LOC count, components included

2. **Bootability Pass Rate:**
   - Did every work order produce bootable code?
   - How many required rework for bootability issues?

3. **Agent Feedback:**
   - Did agent have everything needed to implement?
   - Were dependencies clear?
   - Were acceptance criteria achievable?

**Data Collection Tool:**

Create `process_improvement/decomposition_log.md`:

```markdown
| WO ID | Pattern | LOC | Components | Bootable? | Agent Rework Cycles | Notes |
|-------|---------|-----|------------|-----------|-------------------|-------|
| WO-01 | Vertical | 250 | Model+Sec+Views+Tests | Yes | 0 | Clean implementation |
| WO-02 | Layer | 100 | Model only | **No** | 2 | Missing security CSV |
```

**Success Criteria for Phase 1:**
- ✅ 100% of work orders are bootable (with ≤1 rework cycle)
- ✅ Scrum Master follows patterns in > 80% of cases
- ✅ Agents report work orders as "clear and complete"

**Failure Criteria:**
- ❌ > 20% of work orders require rework for bootability
- ❌ Scrum Master ignores patterns consistently
- ❌ Agents report missing dependencies or unclear scope

---

### **Phase 2: Comparative Validation (After 5-10 Work Orders)**

**Goal:** Test if Pattern A (Vertical Slice) is actually better than Pattern B (Layer-by-Layer)

**A/B Test Design:**

1. **Next Scrum Master Task:** Decompose a feature using BOTH patterns
2. **Parallel Implementation:** Assign Pattern A WOs to Agent 1, Pattern B to Agent 2
3. **Measure:**
   - Time to complete
   - Number of rework cycles
   - Agent-reported clarity
   - Integration issues

**Metrics to Compare:**

| Metric | Pattern A (Vertical) | Pattern B (Layer) | Winner |
|--------|----------------------|-------------------|--------|
| Avg. time per WO | X hours | Y hours | ? |
| Rework cycles | N | M | ? |
| Bootability failures | 0% | Z% | ? |
| Integration issues | Low | High | ? |
| Agent satisfaction | High | Medium | ? |

**Hypothesis:**
- **H1:** Pattern A (Vertical Slice) has fewer integration issues
- **H2:** Pattern A has higher first-pass success rate
- **H3:** Pattern B is faster per WO but slower overall (due to rework)

**How to Falsify:**
- If Pattern B has equal/better metrics, revise guidance to make Pattern B acceptable
- If no significant difference, simplify guidance (don't prescribe patterns)

---

### **Phase 3: Sizing Validation (After 10-15 Work Orders)**

**Goal:** Test if LOC sizing guidelines are accurate

**Data to Collect:**

| WO Size | LOC Range | Avg. Completion Time | Success Rate | Agent Feedback |
|---------|-----------|---------------------|--------------|----------------|
| Small | < 100 | X hours | Y% | "Too trivial" / "Just right" |
| Medium | 100-300 | X hours | Y% | "Good size" |
| Large | 300-500 | X hours | Y% | "Too big" / "Manageable" |
| Too Large | > 500 | X hours | Y% | "Should be split" |

**Adjustments Based on Data:**
- If "Small" consistently takes 6+ hours → Raise threshold to < 150 LOC
- If "Large" has < 70% success rate → Lower threshold to 400 LOC
- If "Medium" is sweet spot → Use 150-350 LOC range

---

## 📝 **Process Improvement Integration**

### **How This Informs Process Improvement**

**1. Regular Retrospectives (Every 5 Work Orders):**

Add to `process_improvement/process-improvement.md`:

```markdown
### Entry #XXX: Decomposition Pattern Retrospective (WO-001 to WO-005)

**Scrum Master Performance:**
- Pattern adherence: 4/5 work orders followed Pattern A
- Sizing accuracy: 3/5 within guidelines, 2/5 too large
- Bootability rate: 5/5 bootable on first try

**Agent Performance:**
- Avg. completion time: 6 hours per WO
- Rework cycles: 0.2 per WO (1 WO required rework)
- Feedback: "Work orders clear and complete"

**Issues Identified:**
- WO-003 was 650 LOC (should have been split)
- WO-004 had ambiguous acceptance criteria

**Actions:**
1. Remind Scrum Master of 500 LOC limit
2. Add examples of good acceptance criteria to primer
```

**2. Quarterly Pattern Review:**

Every 3 months:
- Analyze decomposition log
- Calculate success rates by pattern
- Update Scrum Master primer based on evidence
- Archive outdated guidance

**3. Feedback Loop to Primers:**

If we discover:
- ❌ **Vertical slices cause more rework** → Update primer to allow layer-by-layer
- ✅ **300 LOC is actually the sweet spot** → Update sizing guidelines
- ❌ **Security CSV rule has exceptions** → Document exceptions

---

## 🚦 **Decision Framework: When to Revise Guidance**

### **Green Light (Keep Current Guidance):**
- ✅ Bootability rate > 90%
- ✅ Agent satisfaction > 80%
- ✅ Rework cycles < 0.5 per WO

### **Yellow Light (Monitor Closely):**
- ⚠️ Bootability rate 75-90%
- ⚠️ Agent satisfaction 60-80%
- ⚠️ Rework cycles 0.5-1.0 per WO

### **Red Light (Revise Immediately):**
- ❌ Bootability rate < 75%
- ❌ Agent satisfaction < 60%
- ❌ Rework cycles > 1.0 per WO
- ❌ Scrum Master ignores guidance consistently

---

## 🎯 **Immediate Next Steps**

### **1. Create Decomposition Log (Now):**

```bash
touch process_improvement/decomposition_log.md
```

**Template:**

```markdown
# Decomposition Pattern Validation Log

## Purpose
Track work order decomposition patterns to validate Scrum Master guidance.

## Metrics Tracked
- Pattern used (A: Vertical Slice, B: Layer-by-Layer, C: Other)
- Lines of code (LOC)
- Components included
- Bootability (Yes/No/Rework)
- Agent rework cycles
- Agent feedback

## Log

| WO ID | Date | Pattern | LOC | Components | Bootable? | Rework | Agent Feedback | Notes |
|-------|------|---------|-----|------------|-----------|--------|----------------|-------|
|       |      |         |     |            |           |        |                |       |
```

### **2. Update Scrum Master Primer with Logging Requirement:**

Add to Scrum Master primer:

```markdown
## 6. Decomposition Feedback Loop

After creating work orders, log your decomposition decisions to:
`@aos-architecture/process_improvement/decomposition_log.md`

**Why:** We are validating decomposition patterns empirically. Your data helps us refine guidance.

**What to log:**
- Work Order ID
- Pattern used (A: Vertical Slice, B: Layer-by-Layer)
- Estimated LOC
- Components included
- Reasoning for pattern choice
```

### **3. First Retrospective After WO-005:**

Schedule review of:
- Decomposition log entries (WO-001 to WO-005)
- Agent feedback from process improvement log
- Bootability test results from proof of execution

**Decision:** Keep guidance, revise, or run Phase 2 A/B test?

---

## 💡 **Key Insights**

### **What We Know:**
1. **Models need security CSV** (high confidence, validated)
2. **Bootability is testable** (we can empirically check)
3. **We have a framework to validate everything else** (decomposition log, retrospectives)

### **What We Don't Know (Yet):**
1. **Is vertical slice actually better than layer-by-layer for THIS project?**
2. **Are our LOC sizing guidelines accurate?**
3. **Will Scrum Master follow the patterns?**
4. **Will the patterns reduce rework?**

### **The Plan:**
1. ✅ **Ship the guidance** (based on best available knowledge)
2. 📊 **Collect data** (decomposition log, agent feedback)
3. 🔬 **Validate empirically** (Phase 1, 2, 3)
4. 🔄 **Iterate** (update primers based on evidence)

---

## 🎓 **Philosophy: Lean Startup for Process**

We're applying **Build-Measure-Learn** to our development process:

1. **Build:** Created Odoo-aware decomposition patterns (Section 3.1)
2. **Measure:** Decomposition log, agent feedback, bootability tests
3. **Learn:** Retrospectives, pattern validation, sizing adjustments

**This is better than:**
- ❌ **No guidance at all** (agents flounder)
- ❌ **Waiting for perfect data before shipping** (analysis paralysis)

**We're saying:**
- ✅ "Here's our best hypothesis, let's test it"
- ✅ "We'll revise based on evidence"
- ✅ "One strong rule (security CSV), several testable guesses"

---

## ✅ **Answer to Your Questions**

### **Q1: How successful will Odoo-aware decomposition be?**

**A:** **Unknown. We have one strong rule (models need security) and several educated guesses. Success depends on:**
- Scrum Master adherence
- Agent implementation quality
- Accuracy of our LOC sizing estimates
- Validity of "vertical slice > layer-by-layer" hypothesis

**We'll know after 5-10 work orders** (Phase 1 validation).

---

### **Q2: What data drives those decisions?**

**A:** **Limited data:**
- ✅ **One incident** (Entry #009 - security CSV required)
- ✅ **Odoo documentation** (manifest, init files required)
- ⚠️ **General Agile literature** (vertical slices preferred - not project-specific)
- ❌ **No project-specific data on LOC sizing or pattern success rates**

**We're making informed guesses, not evidence-based decisions (yet).**

---

### **Q3: How do we test that they are accurate?**

**A:** **Three-phase validation:**

1. **Phase 1 (WO-001 to WO-005):** Track adherence and bootability
2. **Phase 2 (WO-006 to WO-010):** A/B test Pattern A vs. Pattern B
3. **Phase 3 (WO-011 to WO-015):** Validate LOC sizing guidelines

**Tools:**
- `decomposition_log.md` (quantitative data)
- Agent feedback in process improvement log (qualitative data)
- Retrospectives every 5 work orders

**Red line:** If bootability < 75% or rework > 1.0 cycles per WO, revise immediately.

---

### **Q4: How does this inform process improvement?**

**A:** **It IS process improvement:**

1. **Decomposition log** → Process improvement data
2. **Every 5 WOs** → Retrospective entry in process improvement log
3. **Quarterly** → Review all decomposition data, update primers
4. **Red flags** → Immediate revision of guidance

**This closes the loop:**
- Scrum Master creates WOs using patterns
- Agents execute and give feedback
- We measure bootability, rework, satisfaction
- We revise patterns based on evidence
- Updated patterns fed back to Scrum Master

**This is the scientific method applied to software process.**

---

## 🚀 **Recommendation**

**SHIP the guidance now** with:
1. ✅ High confidence in security CSV rule
2. ⚠️ Medium confidence in other patterns (labeled as hypotheses)
3. 📊 Validation framework in place (decomposition log)
4. 🔄 Commitment to revise based on data (process improvement)

**Then VALIDATE over next 10-15 work orders.**

**Don't wait for perfect data. Build, measure, learn.**


