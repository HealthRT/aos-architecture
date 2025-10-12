# BUG-001: XML Syntax Error - Repair Instructions

**Agent:** Coder Agent (GPT-5 or Claude Sonnet 4.5)  
**Priority:** 🔴 URGENT (Blocks Pre-UAT)  
**Estimated Time:** 15 minutes

---

## 🎯 **Your Mission**

Fix XML syntax error that prevents `evv_agreements` module installation.

---

## 📍 **Environment Setup (CRITICAL)**

```bash
# 1. Navigate to EVV repository
cd /home/james/development/aos-development/evv

# 2. Verify you're in correct repository
pwd
git remote -v  # Should show evv repository

# 3. Start EVV Odoo (if not running)
docker-compose up -d

# 4. Wait for startup
sleep 10

# 5. Verify EVV Odoo is accessible
curl -s http://localhost:8091/web/database/selector | head -5
```

**Expected Port:** `8091` (EVV), NOT `8090` (Hub)

---

## 🐛 **The Bug**

**File:** `evv/addons/evv_agreements/views/service_agreement_views.xml`  
**Line:** 16  
**Column:** 45

**Current (BROKEN):**
```xml
<group string="Patient & Service" colspan="2">
```

**Error Message:**
```
lxml.etree.XMLSyntaxError: xmlParseEntityRef: no name, line 16, column 45
```

**Root Cause:** Unescaped ampersand (`&`) in XML attribute.

---

## 🔧 **The Fix**

### **Step 1: Create Feature Branch**

```bash
cd /home/james/development/aos-development/evv
git checkout main
git pull
git checkout -b bugfix/BUG-001-xml-escaping
```

### **Step 2: Fix Line 16**

Change:
```xml
<group string="Patient & Service" colspan="2">
```

To:
```xml
<group string="Patient &amp; Service" colspan="2">
```

### **Step 3: Search for Other Instances**

```bash
# Check ALL XML files for unescaped ampersands
cd addons/evv_agreements/
grep -rn 'string="[^"]*&[^a]' views/
```

If you find others, fix them too. Use `&amp;` for ampersand in XML.

---

## ✅ **Testing (MANDATORY)**

### **Test 1: Module Installation**

```bash
# CRITICAL: Use odoo_evv container, NOT odoo_hub
docker exec odoo_evv odoo \
  -c /etc/odoo/odoo.conf \
  -d postgres \
  -i evv_agreements \
  --stop-after-init \
  --log-level=info 2>&1 | tee proof_of_execution_install.log
```

**Expected:** No errors, module installs successfully.

**Look for:**
- ✅ "Modules loaded."
- ✅ "evv_agreements" in loaded modules
- ❌ NO "XMLSyntaxError"
- ❌ NO "xmlParseEntityRef"

### **Test 2: Verify in UI**

1. Access: http://localhost:8091/web/login?db=postgres
2. Login: `admin` / `odoo`
3. Navigate to: **Apps**
4. Search: `Service Agreement`
5. Verify: Module shows as "Installed"
6. Navigate to: **EVV > Service Agreements**
7. Click: **Create**
8. Verify: Form loads without errors
9. **Critical:** Check that "Patient & Service" section displays correctly

### **Test 3: Run Unit Tests**

```bash
docker exec odoo_evv odoo \
  -c /etc/odoo/odoo.conf \
  -d postgres \
  --test-tags=evv_agreements \
  --stop-after-init \
  --log-level=test 2>&1 | tee proof_of_execution_tests.log
```

**Expected:** All 7 tests pass.

---

## 📝 **Proof of Execution (MANDATORY)**

### **Commit Your Work**

```bash
cd /home/james/development/aos-development/evv

# Add all changes
git add addons/evv_agreements/views/

# Add proof logs
git add proof_of_execution_install.log
git add proof_of_execution_tests.log

# Commit
git commit -m "fix(evv_agreements): Escape ampersand in XML view (BUG-001)

- Fixed line 16 in service_agreement_views.xml
- Changed 'Patient & Service' to 'Patient &amp; Service'
- Verified module installs without XML errors
- All unit tests pass (7/7)
- Tested in EVV environment (odoo_evv, port 8091)

Closes: BUG-001"

# Push
git push -u origin bugfix/BUG-001-xml-escaping
```

### **Report Back**

Paste the last 30 lines of your install log showing:
```bash
tail -30 proof_of_execution_install.log
```

---

## ⚠️ **Common Mistakes to AVOID**

❌ **DO NOT** use `odoo_hub` container  
❌ **DO NOT** test on port 8090  
❌ **DO NOT** work in `hub/` directory  
✅ **DO** verify `git remote -v` shows EVV repo  
✅ **DO** use `docker exec odoo_evv`  
✅ **DO** test on http://localhost:8091  

---

## 🔗 **Related Documents**

- Bug Ticket: `aos-architecture/bugs/BUG-001-xml-syntax-error-service-agreement-views.md`
- Pre-UAT Checklist: `aos-architecture/testing/pre-uat-checks/AGMT-001-service-agreement-pre-uat.md`
- Process Entry: `aos-architecture/process_improvement/entry_010_boot_test_wrong_environment.md`

---

## ❓ **Questions or Blockers?**

Report immediately with:
1. Exact error message
2. Container name used (`docker ps`)
3. Port tested
4. Repository path (`pwd`)

