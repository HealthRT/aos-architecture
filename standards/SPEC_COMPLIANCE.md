# Spec Compliance & Validation Standard

**Status:** DRAFT - For Discussion  
**Date:** 2025-10-12  
**Priority:** 🔴 CRITICAL  
**Reason:** Prevents field name mismatches and spec drift

---

## 🎯 **Purpose**

Ensure all implementations (code, tests, documentation) match the authoritative spec.

**Problem We're Solving:**
- Agents writing code without reading spec
- Field names mismatching between spec and implementation
- Tests using wrong field names (passing but testing wrong things)
- No automated validation of spec compliance

---

## 📋 **The Rule**

**Every feature spec (`specs/*/FEATURE-ID.yaml`) is the SINGLE SOURCE OF TRUTH for:**
- Model names
- Field names (exact spelling, case-sensitive)
- Field types
- Required/optional status
- Relationships (Many2one, Many2many)
- Methods and their signatures

**Implementation MUST match spec EXACTLY.**

---

## 🔧 **Enforcement Mechanisms**

### **Level 1: Manual Verification (Immediate - Day 1)**

**For Coder Agents:**

#### **Before Writing Code:**
1. ✅ Read the feature spec (`@aos-architecture/specs/*/FEATURE-ID.yaml`)
2. ✅ Note exact field names and types
3. ✅ Reference spec while coding (keep it open)

#### **Before Committing Code:**
1. ✅ Create a "Field Name Checklist" in commit message:
   ```
   Field Name Verification:
   - patient_id (Many2one to res.partner) ✅ Matches spec line 59
   - recipient_id_external (Char) ✅ Matches spec line 46
   - rate_per_unit (Monetary) ✅ Matches spec line 80
   ```

**For Test Writers:**
1. ✅ Read the **actual implementation** (`models/*.py`)
2. ✅ Read the **spec** to verify implementation matches
3. ✅ Use **exact field names from implementation**
4. ✅ Add comment in test file:
   ```python
   # Field names verified against:
   # - Spec: aos-architecture/specs/evv/AGMT-001.yaml (lines 40-89)
   # - Implementation: evv/addons/evv_agreements/models/service_agreement.py
   ```

---

### **Level 2: Automated Validation (Future - Next Sprint)**

**Create validation script: `scripts/validate-spec-compliance.py`**

```python
#!/usr/bin/env python3
"""
Validates that model implementations match their spec definitions.

Usage:
  python scripts/validate-spec-compliance.py SPEC_FILE.yaml MODEL_FILE.py
  
Example:
  python scripts/validate-spec-compliance.py \
    specs/evv/AGMT-001.yaml \
    evv/addons/evv_agreements/models/service_agreement.py
"""

import yaml
import ast
import sys

def parse_spec(spec_file):
    """Extract model definitions from spec"""
    with open(spec_file) as f:
        spec = yaml.safe_load(f)
    return spec['models']

def parse_model(model_file):
    """Extract field definitions from Python model"""
    with open(model_file) as f:
        tree = ast.parse(f.read())
    # Extract fields.* assignments
    # Return dict of field_name: field_type
    pass

def validate_fields(spec_model, python_model):
    """Compare spec fields vs Python fields"""
    errors = []
    for field in spec_model['fields']:
        field_name = field['name']
        if field_name not in python_model:
            errors.append(f"Missing field: {field_name} (defined in spec)")
    
    for field_name in python_model:
        if field_name not in [f['name'] for f in spec_model['fields']]:
            errors.append(f"Extra field: {field_name} (not in spec)")
    
    return errors

def main():
    spec_file, model_file = sys.argv[1:3]
    spec_models = parse_spec(spec_file)
    python_model = parse_model(model_file)
    
    errors = validate_fields(spec_models[0], python_model)
    
    if errors:
        print("❌ Spec compliance validation FAILED:")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)
    else:
        print("✅ Spec compliance validation PASSED")
        sys.exit(0)

if __name__ == '__main__':
    main()
```

**Run as:**
- Pre-commit hook (warns but doesn't block)
- CI/CD check (blocks merge if fails)
- Manual validation: `make validate-spec`

---

### **Level 3: Schema Validation (Future - Month 2)**

**Generate Python model stubs from spec:**

```bash
# Generate model template from spec
python scripts/generate-model-from-spec.py \
  specs/evv/AGMT-001.yaml \
  --output evv/addons/evv_agreements/models/service_agreement.py.template

# Agent fills in business logic, but field names are pre-generated
```

**Benefits:**
- Eliminates field name mismatches
- Ensures type consistency
- Auto-generates docstrings from spec `help` text

---

## 📝 **Updated Work Order Template**

### **Section 7: Required Context Documents**

```markdown
## 7. Required Context Documents

**CRITICAL:** You MUST read these documents before starting:

1. **Feature Spec (MANDATORY):**
   - File: `@aos-architecture/specs/[component]/[FEATURE-ID].yaml`
   - **READ LINES [X-Y]:** Model definitions (lines 36-90 for AGMT-001)
   - **VERIFY:** Exact field names, types, relationships
   
2. **Standards:**
   - `@aos-architecture/standards/08-testing-requirements.md`
   - `@aos-architecture/standards/SPEC_COMPLIANCE.md` (NEW)
   - `@aos-architecture/standards/TESTING_STRATEGY.md`
   
3. **ADRs:**
   - [List relevant ADRs]
```

---

## 🚨 **Common Pitfalls (Learn from Entry #011)**

### **Mistake: Assuming Field Names**

❌ **WRONG:**
```python
# Test writer assumes logical field name
agreement = self.Agreement.create({
    'partner_id': self.patient.id,  # Assumed "partner" is logical
    'unit_rate': 25.0,              # Assumed "unit_rate" makes sense
})
```

✅ **CORRECT:**
```python
# Test writer checks spec AND implementation
# Spec (AGMT-001.yaml line 59): "patient_id" (Many2one to res.partner)
# Spec (AGMT-001.yaml line 80): "rate_per_unit" (Monetary)
agreement = self.Agreement.create({
    'patient_id': self.patient.id,  # Spec field name
    'rate_per_unit': 25.0,          # Spec field name
})
```

### **Mistake: Not Reading Spec**

❌ **WRONG:** "I'll just look at the existing model and guess field names."

✅ **CORRECT:** "I'll open the spec, find the model definition (lines X-Y), and use exact field names."

---

## ✅ **Acceptance Criteria for This Standard**

This standard is considered "implemented" when:

- [ ] **All Coder Agent primers** reference this document
- [ ] **All Work Order templates** include spec reading requirement
- [ ] **Process Improvement Log** tracks spec compliance issues (if any)
- [ ] **Validation script** exists (even if basic)
- [ ] **Zero spec mismatches** in next 5 features

---

## 📊 **Metrics to Track**

| Metric | Target | Current |
|--------|--------|---------|
| Field name mismatches per feature | 0 | 5 (AGMT-001, Entry #011) |
| Spec references in commit messages | 100% | 0% |
| Validation script coverage | 80% | 0% |

---

## 🎓 **Philosophy**

**"The spec is law. The implementation serves the spec."**

If the spec is wrong, change the spec first, then update code.  
If the code is wrong, change the code to match the spec.  
Never let them drift apart.

---

**Related:**
- Process Improvement Entry #011 (Field Name Mismatches - AGMT-001)
- ADR-016 (Spec Compliance Enforcement) - TO BE CREATED

