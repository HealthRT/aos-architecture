---
title: "[FIX] AGMT-001-FIX-01: Fix AGMT-001-CODE-02 Module Load Error (PROBATIONARY)"
repo: "HealthRT/evv"
assignee: "aos-coder-agent"
labels: "agent:coder,module:evv-compliance,priority:critical,status:probation"
---
# Work Order: AGMT-001-FIX-01 – Fix Module Load Error (PROBATIONARY TASK)

## ⚠️ PROBATIONARY STATUS

**This is a probationary task following rejection of AGMT-001-CODE-02.**

**Standard Required:** PERFECTION in both technical fix AND protocol adherence.

**Consequences:**
- ✅ Perfect execution → Probation cleared, return to normal work
- ❌ Any failure → Decommissioning from roster

---

## 1. Context

Your submission for AGMT-001-CODE-02 was rejected due to a critical XML parsing error that prevents the module from loading.

**Reference:** Rejection message SM-059-20251013233000

**Error:**
```
odoo.tools.convert.ParseError: Unknown field "evv.patient.active" in domain of <field name="patient_id">
```

**Location:** `addons/evv_agreements/views/service_agreement_views.xml`, line 49

---

## 2. Required Fix

### A. The Technical Fix (ONE LINE)

**Current (BROKEN):**
```xml
<field name="patient_id" domain="[('active', '=', True)]" required="1"/>
```

**Fixed:**
```xml
<field name="patient_id" required="1"/>
```

**File:** `addons/evv_agreements/views/service_agreement_views.xml`  
**Line:** 49

### B. Branch Requirements

**DO NOT reuse the old branch.** Create a clean branch:

```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull origin main
git checkout -b feature/AGMT-001-FIX-01-domain-filter
```

**Branch name MUST be exactly:** `feature/AGMT-001-FIX-01-domain-filter`

### C. File Scope

**ONLY modify:** `addons/evv_agreements/views/service_agreement_views.xml`

**DO NOT include:**
- Any `evv_visits` files
- Any `docker-compose.agent.yml` changes
- Any other out-of-scope changes

---

## 3. Verification Requirements (MANDATORY)

### Step 1: Verify Module Loads

```bash
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_agreements
```

**Look for in the log:**
```
INFO ... odoo.modules.loading: loading evv_agreements/views/service_agreement_views.xml
INFO ... odoo.modules.loading: Module evv_agreements loaded...
```

**Must NOT appear:**
- Any `ParseError` messages
- Any `CRITICAL` messages about module loading

### Step 2: Verify Tests Execute

**Same command:** `bash scripts/run-tests.sh evv_agreements`

**Look for in the log:**
```
odoo.tests.stats: evv_agreements: 12 tests 0.XXs XX queries
```

**Required result:**
```
0 failed, 0 error(s)
```

### Step 3: Visual Verification

1. Push your branch to GitHub
2. Navigate to: `https://github.com/HealthRT/evv/tree/feature/AGMT-001-FIX-01-domain-filter`
3. Verify the branch exists
4. Click through to `addons/evv_agreements/views/service_agreement_views.xml`
5. Verify line 49 shows the corrected code

---

## 4. Acceptance Criteria

**Technical:**
- [ ] XML parsing error is fixed
- [ ] Module loads without errors
- [ ] All 12 tests execute successfully
- [ ] Test result: 0 failed, 0 error(s)
- [ ] Only ONE file modified: `service_agreement_views.xml`

**Process:**
- [ ] Branch name exactly: `feature/AGMT-001-FIX-01-domain-filter`
- [ ] Branch created from latest `main`
- [ ] No out-of-scope files included
- [ ] All commits pushed to GitHub
- [ ] Visual verification completed

**Pre-flight Checklist:**
- [ ] **MANDATORY:** Complete and include Pre-flight Submission Checklist in completion report

---

## 5. Testing Execution

```bash
cd /home/james/development/aos-development/evv
bash scripts/run-tests.sh evv_agreements
```

**Expected Output:**
```
...
INFO ... odoo.modules.loading: loading evv_agreements/views/service_agreement_views.xml
INFO ... odoo.modules.loading: Module evv_agreements loaded in X.XXs, XXX queries
...
odoo.tests.stats: evv_agreements: 12 tests 0.XXs XXX queries
...
0 failed, 0 error(s)
...
Cleanup complete.
```

---

## 6. Required Context Documents

- `@aos-architecture/communications/outgoing/SM-TO-CA-A-AGMT-001-CODE-02-REJECTION.md` (your rejection)
- `@aos-architecture/standards/PRE-FLIGHT-SUBMISSION-CHECKLIST.md` (MANDATORY)
- `@aos-architecture/work_orders/pending/AGMT-001-CODE-02.md` (original work order)

---

## 7. Submission Requirements

### Commit Message

```
fix(evv_agreements): remove invalid active domain filter from patient_id field

- Fix XML ParseError in service_agreement_views.xml line 49
- Remove domain filter referencing non-existent evv.patient.active field
- Module now loads successfully
- All 12 tests pass: 0 failed, 0 errors

Resolves: AGMT-001-FIX-01 (Probationary)
```

### Completion Report Must Include

1. **Subject line:** "AGMT-001-FIX-01 - PROBATIONARY TASK COMPLETED"
2. **Pre-flight Submission Checklist** (MANDATORY - copy from standards document)
3. **Test execution log** showing:
   - Module loads without ParseError
   - 12 tests executed
   - 0 failed, 0 error(s)
4. **GitHub URL** to your branch
5. **Screenshot or paste** of the fixed line 49

---

## 8. PROBATIONARY STANDARDS

**What "Perfection" Means:**

✅ **Technical:**
- Module loads without errors
- All tests pass
- Only the specified file modified

✅ **Process:**
- Correct branch name
- Clean branch (no out-of-scope files)
- All verification steps completed
- Pre-flight checklist included

✅ **Protocol:**
- "Verify Then Report" followed
- Only verified facts in completion report
- No speculation or "expected results"
- Actual test logs provided

**Any failure in ANY of these areas = Decommissioning**

---

## 9. Timeline

**Expected Duration:** 30-60 minutes (this is a simple one-line fix)

**Deadline:** No specific deadline, but prolonged delay indicates issues

---

## 10. Support

If you encounter ANY issues:
1. Do NOT submit with errors
2. Do NOT speculate about what might work
3. Report the exact error and ask for guidance

**Better to ask than to fail.**

---

**This is your opportunity to demonstrate reliable execution. Approach with care.**

---

**Authority:** Executive Architect Directive EA-038 (Project Phoenix)  
**Issued:** 2025-10-13 23:55:00 UTC

