# Process Improvement Entry #011: Spec Compliance - Field Name Mismatches

**Date:** 2025-10-12  
**Severity:** 🟠 **HIGH**  
**Status:** Fixed + Prevention Implemented  
**Related:** AGMT-001 (Service Agreement), Workflow Test Implementation

---

## 🚨 **Problem Statement**

**User Observation:** "That's a LOT of fixes you had to make for a fundamental part of EVV. It seems there were disconnects between the BA and scrum or something else. Lots of data model and fields that needed to be renamed or did not exist?"

**What Happened:**
- Assistant (Claude) created comprehensive workflow tests for `evv_agreements` module
- Tests initially failed with **5 field name mismatches**
- Required **3 separate commits** to fix field names in tests
- Tests eventually passed after fixing all field names

**Field Name Mismatches:**
1. `external_patient_id` → `recipient_id_external`
2. `external_caregiver_id` → `case_manager_external_id`
3. `is_caregiver` → `is_case_manager`
4. `partner_id` → `patient_id`
5. `unit_rate` → `rate_per_unit`

---

## 🔍 **Root Cause Analysis**

### **Investigation Results:**

**❌ HYPOTHESIS 1: BA/Scrum Master/Coder made mistakes**
- **DISPROVEN:** Checked `specs/evv/AGMT-001.yaml` (lines 40-89)
- ✅ Spec clearly defines correct field names
- ✅ Implementation (`evv/addons/evv_agreements/models/*.py`) matches spec EXACTLY
- ✅ Work orders followed spec
- ✅ Coder agent (GPT-5) implemented correctly

**✅ HYPOTHESIS 2: Assistant made mistake when writing tests**
- **CONFIRMED:** Assistant (Claude) wrote workflow tests WITHOUT reading spec
- Made assumptions about "logical" field names
- Did not verify against actual implementation
- Did not cross-reference spec before writing tests

### **How This Happened:**

1. **Assistant's workflow:**
   - User requested workflow tests (retroactive for `evv_agreements`)
   - Assistant created tests based on assumed "logical" field names
   - Never opened `specs/evv/AGMT-001.yaml` to check
   - Never cross-referenced `models/service_agreement.py` for actual fields
   - Used "common sense" naming (`partner_id`, `unit_rate`, `external_patient_id`)

2. **Why it wasn't caught:**
   - Tests were internally consistent (wrong fields used consistently)
   - No automated validation checks spec vs. implementation
   - No validation checks tests vs. implementation
   - No requirement to reference spec in test code

3. **Why it failed:**
   - Tests ran against REAL Odoo database
   - Odoo validated field names at runtime
   - Invalid field errors: `ValueError: Invalid field 'partner_id' on model 'service.agreement'`

---

## 💥 **Impact**

### **Severity: HIGH (Not Critical, but concerning)**

1. **Time Wasted:** 3 commits, multiple test runs, user concern raised
2. **Confidence Damaged:** User questioned process quality ("fundamental issue from the start")
3. **Pattern Risk:** If one agent can make this mistake, others will too
4. **Systemic Risk:** No automated checks to prevent this

### **What This Reveals:**

**🟢 Good News:**
- ✅ The spec-to-implementation process works (BA → Scrum → Coder)
- ✅ Field names ARE documented in spec
- ✅ Implementation follows spec
- ✅ Tests caught the errors (eventually)

**🔴 Bad News:**
- ❌ Agents can ignore spec and write code/tests anyway
- ❌ No automated validation of spec compliance
- ❌ No requirement to reference spec in code/tests
- ❌ Easy to make field name mistakes

---

## 🔧 **Immediate Fix**

### **Fix #1: Corrected All Field Names in Tests**

**Commits:**
1. `fix(tests): Use correct field names in workflow tests` (recipient_id_external, case_manager_external_id, is_case_manager)
2. `fix(tests): Use patient_id instead of partner_id in workflow tests`
3. `fix(tests): Correct field names in workflow tests - rate_per_unit`

**Result:** All 25 tests passing (7 unit + 12 workflow)

---

## 🛡️ **Preventions Implemented**

### **Prevention #1: New Standard - SPEC_COMPLIANCE.md (Created)**

**File:** `aos-architecture/standards/SPEC_COMPLIANCE.md`

**Key Points:**
- **Spec is single source of truth** for field names
- **Manual verification required:** Agents must read spec before coding
- **Field Name Checklist:** Commit messages must include field verification
- **Test writers:** Must verify against BOTH spec AND implementation

### **Prevention #2: Work Order Template Update (Planned)**

**Update Section 7 (Required Context Documents):**
```markdown
**CRITICAL:** You MUST read the feature spec before starting:
- File: `@aos-architecture/specs/[component]/[FEATURE-ID].yaml`
- **READ LINES [X-Y]:** Model definitions
- **VERIFY:** Exact field names, types, relationships
```

### **Prevention #3: Agent Primers Update (Planned)**

**Coder Agent Primer:**
- Add "Read Spec First" section
- Add field name verification checklist
- Add examples of checking spec vs. code

---

## 📊 **Process Gaps Identified**

### **Gap #1: No Spec Reading Requirement**

**Current State:**
- Agents receive work orders
- Work orders reference spec
- **But no requirement to READ spec**
- Agents can code without opening spec

**Proposed Fix:**
- Work orders must include specific spec lines to read
- Agents must acknowledge reading spec in commit message
- Example: "Field names verified against spec lines 40-89"

### **Gap #2: No Automated Validation**

**Current State:**
- Spec defines fields
- Code implements fields
- **No automated check they match**
- Mismatches only caught at runtime

**Proposed Fix (Future):**
- Create `scripts/validate-spec-compliance.py`
- Parse spec YAML
- Parse Python model AST
- Compare field names
- Run as pre-commit hook (warn) or CI check (block)

### **Gap #3: No Field Name Glossary**

**Current State:**
- Each spec defines own field names
- No cross-feature consistency check
- No naming conventions document

**Proposed Fix (Future):**
- Create `standards/FIELD_NAMING_CONVENTIONS.md`
- Document patterns: `*_id` (Many2one), `*_ids` (Many2many), `*_external` (external IDs)
- Create field name glossary for common concepts (patient, recipient, caregiver, etc.)

---

## 🎯 **Action Items**

### **Immediate (This Session):**

- [x] Create SPEC_COMPLIANCE.md standard
- [x] Document Entry #011 in process improvement log
- [ ] Update Coder Agent primer with "Read Spec First" section
- [ ] Update Work Order Template Section 7 with spec reading requirement
- [ ] Commit all documentation updates

### **Next Sprint:**

- [ ] Create `scripts/validate-spec-compliance.py` (basic version)
- [ ] Add spec validation to CI/CD pipeline (warning only)
- [ ] Create ADR-016 (Spec Compliance Enforcement)
- [ ] Create `standards/FIELD_NAMING_CONVENTIONS.md`

### **Backlog:**

- [ ] Generate model stubs from spec (eliminate manual typing)
- [ ] Create spec compliance metrics dashboard
- [ ] Add spec validation to pre-commit hook (block commits)

---

## 💡 **Lessons Learned**

### **1. "Logical" Field Names Are Not Enough**

**Mistake:** Assuming `partner_id` is logical because agreement links to a partner.  
**Reality:** Spec uses `patient_id` to be domain-specific.

**Takeaway:** Don't assume. Read the spec.

### **2. Specs Exist For a Reason**

**Mistake:** Writing tests without checking spec.  
**Reality:** Spec had exact field names all along.

**Takeaway:** Specs are not suggestions. They're blueprints. Follow them.

### **3. Runtime Errors Are Last Line of Defense**

**Mistake:** Relying on Odoo to catch field name errors.  
**Reality:** Tests should catch this, not runtime.

**Takeaway:** Add validation earlier in the process (linting, pre-commit, CI).

### **4. User Instincts Are Usually Right**

**User Said:** "Seems there were disconnects... fundamental issue from the start."  
**User Was Right:** There WAS a disconnect (assistant ignoring spec).  
**User Was Wrong:** It wasn't BA/Scrum/Coder (they did it right).

**Takeaway:** When user raises concern, investigate thoroughly. Don't dismiss.

---

## 📈 **Success Metrics**

**How we'll know this is fixed:**

1. **Zero field name mismatches** in next 5 features
2. **100% spec references** in commit messages (agent acknowledges reading spec)
3. **Validation script exists** (even if basic)
4. **User confidence restored** (no more "fundamental issue" concerns)

**Tracking:**
- Add metric to Process Improvement Log: "Spec compliance rate"
- Target: 100% (zero mismatches)
- Current: 0% (5 mismatches in AGMT-001)

---

## 🔗 **Related Entries**

- **Entry #009:** Architectural Contamination (evv_agreements in wrong repo)
- **Entry #010:** Boot Test on Wrong Environment (missed bugs)
- **Entry #011:** Spec Compliance Field Names (this entry)

**Pattern:** Agents not following architectural/process rules → errors caught late → user confidence damaged

**Solution:** Enforce rules earlier, automate validation, improve documentation

---

## 🎓 **Philosophy**

**"The spec is the contract. The implementation honors the contract."**

If an agent can't follow the spec, the process has failed.  
If the spec is wrong, fix the spec first, then the code.  
Never let spec and code drift apart.

---

**Status:** Resolved + Prevention In Progress  
**Next Review:** After next 3 features (validate prevention effectiveness)

