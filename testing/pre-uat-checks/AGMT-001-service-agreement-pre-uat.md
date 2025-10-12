# Pre-UAT Check: Service Agreement (AGMT-001)

**Date:** 2025-10-12  
**Tester:** James  
**Environment:** EVV (http://localhost:8091)  
**Module:** `evv_agreements`  
**Status:** Ready for Testing

---

## 📋 **Pre-Test Setup**

### **1. Access Odoo**

- **URL:** http://localhost:8091
- **Username:** admin
- **Password:** admin

### **2. Install Module (If Not Already Installed)**

```bash
# In EVV container
docker exec odoo_evv odoo -c /etc/odoo/odoo.conf -d postgres -i evv_agreements --stop-after-init
```

OR via UI:
1. Go to Apps
2. Remove "Apps" filter
3. Search "Service Agreement"
4. Click "Install"

---

## ✅ **Smoke Test Checklist**

### **Test 1: Module Installation**

- [ ] Module appears in Apps list
- [ ] Module installs without errors
- [ ] No errors in Odoo logs
- [ ] Database upgrades successfully

**Expected:** Clean installation, no Python errors, no XML parsing errors

---

### **Test 2: Navigation & Menu**

- [ ] "Service Agreements" menu item visible
- [ ] Menu item is in correct location (EVV section)
- [ ] Clicking menu opens list view
- [ ] List view loads without errors

**Expected:** Menu accessible, list view renders

---

### **Test 3: Create Service Agreement (Basic)**

1. Click "Create" button
2. Fill in required fields:
   - Partner (select a contact/client)
   - Service (if field exists)
   - Start Date
   - Any other required fields
3. Click "Save"

**Checklist:**
- [ ] Create button visible and clickable
- [ ] Form view loads
- [ ] All fields render correctly
- [ ] Required fields marked with *
- [ ] Save button works
- [ ] Record saves successfully
- [ ] No errors on save

**Expected:** Can create and save a basic service agreement

---

### **Test 4: View Service Agreement**

1. Open the service agreement you just created
2. Check all fields display correctly
3. Check related information (if any)

**Checklist:**
- [ ] Form view displays saved data
- [ ] All fields populated correctly
- [ ] No UI rendering issues
- [ ] No JavaScript errors in browser console

**Expected:** Service agreement displays correctly

---

### **Test 5: Edit Service Agreement**

1. Click "Edit" button
2. Modify a field (e.g., change date)
3. Click "Save"

**Checklist:**
- [ ] Edit button works
- [ ] Fields are editable
- [ ] Changes save successfully
- [ ] Updated data persists after save

**Expected:** Can edit and save changes

---

### **Test 6: Partner Extension (If Implemented)**

1. Go to Contacts
2. Open a contact
3. Check for Service Agreement tab/section

**Checklist:**
- [ ] Service Agreement tab/section exists
- [ ] Shows related service agreements
- [ ] Can view linked agreements
- [ ] "Create Agreement" button works (if exists)

**Expected:** Partner form shows related agreements

---

### **Test 7: List View Features**

1. Go back to Service Agreements list
2. Test list view features:

**Checklist:**
- [ ] All columns display correctly
- [ ] Can sort by columns (click headers)
- [ ] Search works
- [ ] Filters work (if any exist)
- [ ] Pagination works (if multiple records)

**Expected:** List view fully functional

---

### **Test 8: Security & Access**

1. Check current user can access module
2. Verify no unauthorized access errors

**Checklist:**
- [ ] Can view service agreements
- [ ] Can create service agreements
- [ ] Can edit service agreements
- [ ] No "Access Denied" errors

**Expected:** Appropriate access granted

---

### **Test 9: Data Validation**

Try to create invalid records:

**Test Cases:**
- [ ] Create agreement without required partner → Error message
- [ ] Create agreement with invalid date → Error or correction
- [ ] Save with missing required fields → Error message

**Expected:** Validation rules work, clear error messages

---

### **Test 10: Workflow (If Implemented)**

If service agreement has workflow states:

**Checklist:**
- [ ] State field visible
- [ ] Action buttons visible (Activate, Cancel, etc.)
- [ ] Can transition between states
- [ ] State-based access rules work

**Expected:** Workflow functions correctly

---

## 🐛 **Issues Found**

### **Critical (Blocking):**

| Issue # | Description | Steps to Reproduce | Severity |
|---------|-------------|-------------------|----------|
| BUG-001 | XML Syntax Error - Module installation fails | 1. Go to Apps<br>2. Search "evv_agreements"<br>3. Click Install | 🔴 CRITICAL |

**BUG-001 Details:**
```
File: evv_agreements/views/service_agreement_views.xml
Line: 16, column 45
Error: lxml.etree.XMLSyntaxError: xmlParseEntityRef: no name
Impact: Module cannot be installed - blocks all testing
```

### **Major (Should Fix):**

| Issue # | Description | Steps to Reproduce | Severity |
|---------|-------------|-------------------|----------|
|         |             |                   |          |

### **Minor (Nice to Fix):**

| Issue # | Description | Steps to Reproduce | Severity |
|---------|-------------|-------------------|----------|
|         |             |                   |          |

---

## 📝 **Test Results Summary**

**Total Tests:** 10  
**Passed:** 0  
**Failed:** 0  
**Blocked:** 10 (Cannot install module)  

**Overall Status:** ❌ **FAIL - Critical Bug Found**

**Blocker:** BUG-001 (XML Syntax Error) prevents module installation

---

## 🎯 **Recommendation**

- [ ] **Ready for UAT** - All critical tests pass, minor issues acceptable
- [x] **Not Ready** - Critical issues found, needs rework
- [ ] **Conditional** - Ready with known limitations documented

**Notes:**
- XML syntax error in views/service_agreement_views.xml line 16
- Module cannot be installed
- All testing blocked until bug fixed
- Bug ticket BUG-001 created
- Assigned to coder agent for immediate fix

---

## 📸 **Screenshots (Optional)**

Add screenshots of:
- Module in Apps list
- Service Agreement form view
- Service Agreement list view
- Partner with agreements (if applicable)

---

## 🔄 **Next Steps**

### **If Tests Pass:**
1. Document any minor issues found
2. Schedule SME UAT session
3. Prepare UAT checklist based on open items in `AGMT-001-open-items.md`

### **If Tests Fail:**
1. Document critical issues
2. Create bug tickets (GitHub Issues)
3. Assign to coder agent for fixes
4. Retest after fixes

---

## 📚 **Reference Documents**

- **Feature Spec:** `aos-architecture/specs/evv/AGMT-001.yaml`
- **Work Orders:** WO-AGMT-001-01 through WO-AGMT-001-05
- **Open Items:** `aos-architecture/working_docs/evv/AGMT-001-open-items.md`
- **Process Improvement:** Entries #007 (test discovery issue)

---

**Tester Signature:** ________________  
**Date Completed:** ________________


