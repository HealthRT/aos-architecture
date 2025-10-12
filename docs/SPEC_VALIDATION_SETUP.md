# Spec Validation Setup Guide

**Status:** Ready to Deploy (Pending Field Name Confirmation)  
**Date:** 2025-10-12

---

## 🎯 **Purpose**

Automate validation that code implementations match their spec definitions.

**Problem We're Solving:**
- Agents can write code without reading spec
- Field name mismatches caught late (runtime, not build time)
- Manual validation is error-prone and forgettable

**Solution:**
- Automated validation in CI/CD pipeline
- Optional pre-commit hook for local validation
- Clear pass/fail criteria

---

## 📦 **What's Been Created**

### **1. Validation Script**
**File:** `scripts/compare-spec-to-implementation.py`  
**Status:** ✅ Created and tested

**Features:**
- Parses YAML spec for model/field definitions
- Parses Python model files for actual fields
- Compares and reports matches/mismatches
- Exit code 0 = pass, 1 = fail

**Usage:**
```bash
python scripts/compare-spec-to-implementation.py \
  specs/evv/AGMT-001.yaml \
  ../evv/addons/evv_agreements/models/
```

**Test Result:** ✅ AGMT-001 validates perfectly (27/27 fields match)

---

### **2. GitHub Actions CI/CD Workflow**
**File:** `.github/workflows/validate-spec-compliance.yml`  
**Status:** ✅ Created, not yet committed (pending field name confirmation)

**Triggers:**
- Pull requests that modify:
  - `evv/addons/**/*.py`
  - `hub/addons/**/*.py`
  - `aos-architecture/specs/**/*.yaml`
- Pushes to main branch (same paths)

**What It Does:**
1. Checks out code
2. Sets up Python 3.11
3. Installs dependencies (pyyaml)
4. Runs validation for each spec
5. **Fails PR if mismatches found**

**Benefits:**
- Automated (no human memory required)
- Blocks bad code from merging
- Fast (< 30 seconds per validation)
- Clear error messages

---

### **3. Pre-Commit Hook (Optional)**
**File:** `scripts/pre-commit-spec-validation.sh`  
**Status:** ✅ Created, not yet installed (optional)

**Installation:**
```bash
# In aos-architecture, evv, or hub repository:
cp scripts/pre-commit-spec-validation.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**What It Does:**
1. Runs before every commit
2. Validates changed modules
3. **Warns if mismatches found (does not block)**
4. Can be skipped with `--no-verify`

**Benefits:**
- Catches mismatches immediately (before push)
- Developer gets instant feedback
- Optional (doesn't break existing workflows)

**Note:** Currently set to WARNING mode. Change to blocking mode by:
```bash
# Line 97 in pre-commit-spec-validation.sh
# Change:  exit 0
# To:      exit 1
```

---

## 🚦 **Deployment Options**

### **Option A: CI/CD Only (Recommended)**
**What:** GitHub Actions validates on every PR  
**Impact:** All PRs must pass validation before merge  
**Effort:** Just commit the workflow file

**Pros:**
- ✅ Centralized enforcement
- ✅ No local setup required
- ✅ Clear gate before merge

**Cons:**
- ❌ Developers find out late (after push)

---

### **Option B: Pre-Commit + CI/CD (Strictest)**
**What:** Local hook warns, CI/CD enforces  
**Impact:** Developers get immediate feedback, CI/CD is final gate  
**Effort:** Commit workflow + document hook installation

**Pros:**
- ✅ Immediate feedback (before push)
- ✅ CI/CD still enforces (can't bypass)
- ✅ Reduces failed PRs

**Cons:**
- ❌ Requires developer setup (one-time)

---

### **Option C: Manual Only (Not Recommended)**
**What:** Developers run validation manually  
**Impact:** Easy to forget, no enforcement  
**Effort:** Just commit the script

**Pros:**
- ✅ Flexible (no forced validation)

**Cons:**
- ❌ Easy to forget
- ❌ No enforcement
- ❌ Same problem we're trying to solve

---

## 📋 **Pending: Field Name Confirmation**

**Before deploying CI/CD, please confirm these field names are correct:**

### **1. Patient/Recipient Terminology**
```yaml
Current in spec:
  - recipient_id_external      (External system ID)
  - patient_id                 (Internal Odoo link)
  - is_patient                 (Boolean flag)
```

**Question:** Is "recipient" correct (county terminology) or change to "patient" everywhere?

**Options:**
- ✅ Keep as-is: Matches county systems
- 🔄 Change to: `patient_id_external` (more intuitive for staff)

---

### **2. Case Manager vs. Caregiver**
```yaml
Current in spec:
  - is_case_manager            (Boolean flag)
  - case_manager_id            (Link to case manager)
  - case_manager_external_id   (External system ID)
```

**Question:** Are these county staff (case managers) or agency staff (caregivers)?

**Options:**
- ✅ Keep as-is: County staff who authorize services
- 🔄 Change to: `is_caregiver` (agency staff who provide care)
- 🔄 Add both: Separate roles (case_manager AND caregiver)

---

### **3. Rate Field Naming**
```yaml
Current in spec:
  - rate_per_unit              (Monetary)
```

**Question:** Is this clear or prefer shorter name?

**Options:**
- ✅ Keep as-is: `rate_per_unit` (explicit, reads well)
- 🔄 Change to: `unit_rate` (shorter, common in billing)

---

## 🎯 **Decision Tree**

```
Are field names correct for your business?
│
├─ YES → Deploy CI/CD immediately
│         └─ Option A (CI/CD only) or Option B (Pre-commit + CI/CD)
│
└─ NO → Update spec first, then code, then deploy CI/CD
         └─ Follow process: Spec → Code → Validation
```

---

## 🚀 **Deployment Steps (Once Field Names Confirmed)**

### **If Field Names Are Correct:**

```bash
# 1. Commit CI/CD workflow
cd aos-development
git add .github/workflows/validate-spec-compliance.yml
git add aos-architecture/scripts/pre-commit-spec-validation.sh
git add aos-architecture/docs/SPEC_VALIDATION_SETUP.md
git commit -m "feat: Add automated spec compliance validation (CI/CD + pre-commit)"
git push

# 2. Update documentation
# Add to coder agent primer: "Spec validation runs automatically on PRs"
# Add to work order template: "CI/CD will validate spec compliance"

# 3. (Optional) Install pre-commit hook locally
cd evv
cp ../aos-architecture/scripts/pre-commit-spec-validation.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

cd ../hub
cp ../aos-architecture/scripts/pre-commit-spec-validation.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

### **If Field Names Need Updating:**

```bash
# 1. Update spec FIRST
# Edit: aos-architecture/specs/evv/AGMT-001.yaml
# Change field names to match business terminology

# 2. Update code to match new spec
# Edit: evv/addons/evv_agreements/models/*.py
# Update field names

# 3. Update tests to match new spec
# Edit: evv/addons/evv_agreements/tests/*.py
# Update field names

# 4. Run validation to confirm
cd aos-architecture
python scripts/compare-spec-to-implementation.py \
  specs/evv/AGMT-001.yaml \
  ../evv/addons/evv_agreements/models/

# 5. If validation passes, deploy CI/CD
git add .github/workflows/validate-spec-compliance.yml
git commit -m "feat: Add automated spec compliance validation"
git push
```

---

## 📊 **Success Metrics**

**How we'll know this is working:**

1. **Zero spec mismatches** in merged PRs (CI/CD catches them)
2. **Faster feedback** for developers (pre-commit warns immediately)
3. **Reduced runtime errors** (field name issues caught at build time)
4. **User confidence restored** (no more "fundamental issues" concerns)

**Tracking:**
- GitHub Actions: Pass/fail rate on PRs
- Process Improvement Log: Spec compliance violations (target: 0)

---

## 🔗 **Related Documents**

- **Standard:** `standards/SPEC_COMPLIANCE.md`
- **Process Entry:** `process_improvement/entry_011_spec_compliance_field_names.md`
- **Validation Script:** `scripts/compare-spec-to-implementation.py`
- **CI/CD Workflow:** `.github/workflows/validate-spec-compliance.yml`
- **Pre-commit Hook:** `scripts/pre-commit-spec-validation.sh`

---

**Status:** Ready to Deploy (Pending Field Name Confirmation)  
**Next Step:** User confirms field names → Deploy CI/CD

