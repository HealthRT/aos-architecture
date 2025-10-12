# BUG-001: XML Syntax Error in Service Agreement Views

**Date Reported:** 2025-10-12  
**Reported By:** James (Pre-UAT Testing)  
**Severity:** 🔴 **CRITICAL** (Blocks all functionality)  
**Status:** 🟡 **Open - Needs Fix**  
**Feature:** AGMT-001 (Service Agreement)  
**Work Order:** WO-AGMT-001-04 (Form Views)

---

## 🐛 **Bug Description**

Module `evv_agreements` fails to install with XML syntax error.

**Error Message:**
```
lxml.etree.XMLSyntaxError: xmlParseEntityRef: no name, line 16, column 45
File: /mnt/extra-addons/evv_agreements/views/service_agreement_views.xml
```

---

## 📍 **Location**

**File:** `evv/addons/evv_agreements/views/service_agreement_views.xml`  
**Line:** 16  
**Column:** 45

---

## 🔍 **Root Cause**

Unescaped ampersand (`&`) in XML attribute.

**Current (WRONG):**
```xml
<group string="Patient & Service" colspan="2">
```

**Should Be:**
```xml
<group string="Patient &amp; Service" colspan="2">
```

**Rule:** In XML, the `&` character must be escaped as `&amp;` in attributes and text content.

---

## 💥 **Impact**

**Severity: CRITICAL**

- ❌ Module cannot be installed
- ❌ All Pre-UAT testing blocked
- ❌ All functionality inaccessible
- ❌ Cannot proceed to UAT with SMEs

**Testing Stage:** Pre-UAT (discovered during initial smoke test)

---

## 📝 **Steps to Reproduce**

1. Access EVV Odoo: http://localhost:8091/web/login?db=postgres
2. Login as admin/admin
3. Go to **Apps**
4. Remove "Apps" filter
5. Search "evv" or "Service Agreement"
6. Click **Install**
7. **Result:** Error message, module not installed

---

## 🔬 **Why This Wasn't Caught Earlier**

### **Root Cause: Wrong Environment Boot Test (Entry #010)**

**Agent Proof of Execution shows:**
```
odoo_hub  | 2025-10-11 23:48:58,179 1 INFO postgres odoo.modules.loading: loading 1 modules... 
```

**Analysis:**
- Boot test log says `odoo_hub` (Hub environment)
- Agent was working on `evv_agreements` (EVV module)
- Agent ran boot test on **WRONG ENVIRONMENT**
- Hub doesn't have `evv_agreements`, so XML was never parsed
- Error went undetected, code merged

**This is the SAME issue as Entry #010:**
- Agent working in one environment
- Testing in another environment
- Errors slip through

**Prevention Status:**
- ✅ Environment verification added to Coder primer (Section 3)
- ✅ Isolated test environments implemented (Phase 1)
- ✅ Pre-commit hooks for repository boundaries
- ⏳ **BUT:** This work order completed BEFORE these fixes

---

## ✅ **Fix Required**

### **Task: Fix XML Escaping**

**Search for all unescaped ampersands in XML files:**

```bash
cd evv/addons/evv_agreements/
grep -n 'string="[^"]*&[^a]' views/*.xml
```

**Expected Fixes:**
1. Line 16: `Patient & Service` → `Patient &amp; Service`
2. Any other unescaped `&` in XML attributes

### **Verification:**

After fix, agent must:

1. **Install module in EVV environment** (not Hub!):
   ```bash
   cd evv/
   docker exec odoo_evv odoo -c /etc/odoo/odoo.conf -d postgres -i evv_agreements --stop-after-init
   ```

2. **Verify no XML errors:**
   ```bash
   docker logs odoo_evv 2>&1 | grep -i "xml\|error"
   ```

3. **Boot test in correct environment:**
   ```bash
   docker logs odoo_evv --tail 100 > proof_of_execution_boot_BUGFIX.log
   # Log must say "odoo_evv" not "odoo_hub"
   ```

4. **Access module in UI:**
   - Login to EVV: http://localhost:8091/web/login?db=postgres
   - Go to Apps → evv_agreements should show "Installed"
   - Navigate to Service Agreements menu

---

## 📊 **Assignment**

**Assign To:** Coder Agent (preferably same agent who created WO-AGMT-001-04)  
**Priority:** 🔴 **URGENT** (Blocks Pre-UAT)  
**Estimated Fix Time:** 15 minutes  

**Work Order:** Create WO-AGMT-001-BUGFIX-001

---

## 🔄 **Retest After Fix**

**Who:** James (Pre-UAT)  
**Checklist:** `aos-architecture/testing/pre-uat-checks/AGMT-001-service-agreement-pre-uat.md`

**Acceptance Criteria:**
- ✅ Module installs without errors
- ✅ Service Agreements menu visible
- ✅ Can create/view/edit service agreements
- ✅ All 10 Pre-UAT tests pass

---

## 📚 **Related**

- **Feature:** AGMT-001 (Service Agreement)
- **Pre-UAT Checklist:** `testing/pre-uat-checks/AGMT-001-service-agreement-pre-uat.md`
- **Process Improvement:** Entry #010 (Boot Test Wrong Environment)
- **Work Orders:** WO-AGMT-001-01 through WO-AGMT-001-05

---

## 💡 **Lessons Learned**

### **1. Pre-UAT Caught Critical Bug**

Pre-UAT testing is working as designed - found showstopper before formal UAT with SMEs.

### **2. Wrong Environment Testing is a Pattern**

This is the SECOND time (Entry #010 original + this) that wrong environment testing slipped through.

**Prevention:** 
- Isolated test environments now implemented
- Agent primers updated with verification steps
- **Need:** Stricter review of proof of execution logs

### **3. XML Validation Missing**

No automated XML validation in CI/CD pipeline.

**Future Enhancement:** Add XML linting to pre-commit hooks or CI/CD.

---

**Next Step:** Create work order for coder agent to fix XML escaping issue.


