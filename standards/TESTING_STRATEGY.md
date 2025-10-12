# Testing Strategy: Comprehensive Backend Workflow Testing

**Status:** DRAFT - For Discussion  
**Date:** 2025-10-12  
**Author:** AOS Architecture Team

---

## 🎯 **Purpose**

Define a comprehensive testing strategy that catches issues **BEFORE** human/UI testing, saving time and ensuring quality.

---

## 📊 **Testing Pyramid**

```
           Manual UAT
          (SMEs, Real Data)
         ──────────────────
        /                  \
       /  Pre-UAT (Human)   \
      /  (Quick UI Check)    \
     ────────────────────────
    /                        \
   /  E2E Workflow Tests       \  ← NEW: FOCUS AREA
  /   (Backend, User Scenarios) \
 ──────────────────────────────
/                              \
    Unit Tests (Models/Logic)
────────────────────────────────
```

**Goal:** Maximize automated backend tests, minimize manual testing.

---

## 🧪 **Test Levels**

### **Level 1: Unit Tests (REQUIRED)**

**Purpose:** Test individual methods and business logic in isolation.

**What to Test:**
- ✅ Model field defaults and computes
- ✅ Constraints and validations
- ✅ Individual button/action methods
- ✅ Data transformations

**Example:**
```python
def test_create_defaults(self):
    """Test default values are set correctly"""
    agreement = self.Agreement.create({
        'patient_id': self.patient.id,
        'procedure_code': 'H2014',
        'effective_date': date(2025, 1, 1),
        'through_date': date(2025, 1, 31),
        'total_units': 10.0,
    })
    self.assertEqual(agreement.state, 'draft')  # Default state
```

**Coverage Target:** Every model, every public method.

---

### **Level 2: Workflow Tests (REQUIRED - NEW)**

**Purpose:** Test complete user workflows without UI, simulating button clicks and navigation in code.

**What to Test:**
- ✅ Multi-step workflows (Create → Activate → Cancel)
- ✅ State transitions
- ✅ User journey scenarios
- ✅ Integration between related models
- ✅ Access rights (can user X do action Y?)

**Example:**
```python
def test_workflow_complete_agreement_lifecycle(self):
    """Test: Create patient → Create agreement → Activate → Cancel
    
    This replicates the user journey:
    1. User goes to Contacts > Create > Patient
    2. User goes to Service Agreements > Create
    3. User clicks "Activate" button
    4. User clicks "Cancel" button
    """
    # Step 1: Create patient (EVV > Contacts > Create)
    patient = self.env['res.partner'].create({
        'name': 'Jane Smith',
        'is_patient': True,
        'external_patient_id': 'PAT-12345',
    })
    
    # Step 2: Create agreement (EVV > Service Agreements > Create)
    agreement = self.env['service.agreement'].create({
        'partner_id': patient.id,
        'procedure_code': 'H2014',
        'effective_date': date(2025, 1, 1),
        'through_date': date(2025, 12, 31),
        'total_units': 100.0,
    })
    
    # Verify: Agreement is in draft state
    self.assertEqual(agreement.state, 'draft')
    
    # Step 3: User clicks "Activate" button
    agreement.action_activate()
    
    # Verify: Agreement is now active
    self.assertEqual(agreement.state, 'active')
    
    # Step 4: User clicks "Cancel" button
    agreement.action_cancel()
    
    # Verify: Agreement is cancelled
    self.assertEqual(agreement.state, 'cancelled')
    
    # ✅ Complete workflow tested in < 1 second
    # ✅ No UI needed
    # ✅ Catches workflow issues early
```

**Coverage Target:** Every major user workflow (happy path + error paths).

---

### **Level 3: Integration Tests (OPTIONAL)**

**Purpose:** Test integration between modules and external systems.

**What to Test:**
- ✅ Cross-module workflows (EVV → Hub)
- ✅ API endpoints (if we have REST API)
- ✅ External service integrations (when we add them)

**Example:**
```python
def test_integration_agreement_with_billing(self):
    """Test: Agreement creation triggers billing setup"""
    # Future: When we have billing module
    pass
```

**Coverage Target:** All integration points between modules.

---

### **Level 4: Pre-UAT (Smoke Test) (REQUIRED)**

**Purpose:** Human quickly verifies basic functionality in UI before formal UAT.

**What to Test:**
- ✅ Module installs without errors
- ✅ Menus appear in correct places
- ✅ Forms load without errors
- ✅ Basic workflow (Create → Activate) works in UI
- ✅ No obvious visual issues

**Duration:** 10-15 minutes per feature.

**Documented In:** `aos-architecture/testing/pre-uat-checks/`

---

### **Level 5: User Acceptance Testing (REQUIRED)**

**Purpose:** SMEs validate business requirements with real-world scenarios.

**What to Test:**
- ✅ Business rules are correct
- ✅ Workflows match real-world processes
- ✅ Data validation makes sense for users
- ✅ UI is usable and intuitive

**Duration:** 1-2 hours per feature.

**Participants:** Domain experts (SMEs), not just developers.

---

## 🚀 **Workflow Test Examples**

### **Example 1: Happy Path Workflow**

```python
@tagged("post_install", "-at_install", "evv_agreements", "workflow")
class TestServiceAgreementWorkflows(TransactionCase):
    """End-to-end workflow tests that replicate user activities"""
    
    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.env = cls.env(context=dict(cls.env.context, tracking_disable=True))
        cls.Partner = cls.env['res.partner']
        cls.Agreement = cls.env['service.agreement']
        
        # Create test patient
        cls.patient = cls.Partner.create({
            'name': 'Test Patient',
            'is_patient': True,
            'external_patient_id': 'PAT-001',
        })
    
    def test_workflow_create_and_activate_agreement(self):
        """Workflow: Create agreement → Activate → Verify searchable"""
        
        # User creates agreement via UI form
        agreement = self.Agreement.create({
            'partner_id': self.patient.id,
            'procedure_code': 'H2014',
            'effective_date': date(2025, 1, 1),
            'through_date': date(2025, 12, 31),
            'total_units': 100.0,
        })
        
        # Verify it's in draft
        self.assertEqual(agreement.state, 'draft')
        
        # User clicks "Activate" button
        agreement.action_activate()
        
        # Verify state changed
        self.assertEqual(agreement.state, 'active')
        
        # Verify it appears in "Active Agreements" search
        active_agreements = self.Agreement.search([
            ('state', '=', 'active'),
            ('partner_id', '=', self.patient.id)
        ])
        self.assertIn(agreement, active_agreements)
```

### **Example 2: Error Path Workflow**

```python
    def test_workflow_cannot_activate_without_required_fields(self):
        """Workflow: Try to activate incomplete agreement → Should fail"""
        
        # User creates agreement with missing fields
        agreement = self.Agreement.create({
            'partner_id': self.patient.id,
            'procedure_code': 'H2014',
            'effective_date': date(2025, 1, 1),
            # Missing: through_date, total_units
        })
        
        # User tries to click "Activate" button
        with self.assertRaises(ValidationError) as cm:
            agreement.action_activate()
        
        # Verify error message is helpful
        self.assertIn('required', str(cm.exception).lower())
```

### **Example 3: Multi-Actor Workflow**

```python
    def test_workflow_manager_can_cancel_active_agreement(self):
        """Workflow: User creates → Manager cancels"""
        
        # Create two users: regular user and manager
        user = self.env.ref('base.user_demo')  # Regular user
        manager = self.env.ref('base.user_admin')  # Manager
        
        # Regular user creates and activates agreement
        agreement = self.Agreement.with_user(user).create({
            'partner_id': self.patient.id,
            'procedure_code': 'H2014',
            'effective_date': date(2025, 1, 1),
            'through_date': date(2025, 12, 31),
            'total_units': 100.0,
        })
        agreement.action_activate()
        
        # Manager cancels it
        agreement.with_user(manager).action_cancel()
        
        # Verify cancelled
        self.assertEqual(agreement.state, 'cancelled')
```

---

## 📋 **Workflow Test Checklist (For Every Feature)**

When implementing a new feature, ensure you have:

- [ ] **Unit Tests:** All models, all public methods
- [ ] **Happy Path Workflow:** Main user journey works end-to-end
- [ ] **Error Path Workflow:** Invalid inputs rejected gracefully
- [ ] **State Transition Tests:** All state changes work correctly
- [ ] **Search/Filter Tests:** Records are findable after creation
- [ ] **Access Rights Tests:** Only authorized users can perform actions
- [ ] **Edge Cases:** Boundary conditions tested (empty, null, max values)

---

## 🎯 **Benefits of Backend Workflow Tests**

### **Speed:**
- ✅ Unit test: ~0.01 seconds
- ✅ Workflow test: ~0.1 seconds
- ❌ Pre-UAT (human): ~15 minutes
- ❌ UAT (SME): ~60 minutes

**10x-1000x faster than manual testing.**

### **Reliability:**
- ✅ Automated: Run on every commit
- ✅ Repeatable: Same test, same result
- ✅ No human error: Tests don't forget steps

### **Coverage:**
- ✅ Tests EVERY workflow, not just "happy path"
- ✅ Tests error cases humans might skip
- ✅ Tests edge cases humans might not think of

### **Cost:**
- ✅ Catches issues BEFORE Pre-UAT (saves human time)
- ✅ Catches issues BEFORE UAT (saves SME time)
- ✅ Prevents broken code from reaching users

---

## 🚨 **What Backend Tests DON'T Catch**

Backend workflow tests will NOT catch:

❌ **XML view errors** (unless you test view rendering)  
❌ **CSS/styling issues**  
❌ **JavaScript errors**  
❌ **Browser compatibility**  
❌ **UI/UX usability problems**

**For these, you still need:**
- Pre-UAT (human smoke test)
- UAT (SME validation)

---

## 📝 **Implementation Guide**

### **For Scrum Master: Work Order Decomposition**

When creating work orders, ensure acceptance criteria includes:

```markdown
### Testing Requirements (MANDATORY)

**Unit Tests:**
- [ ] Test all model methods
- [ ] Test all constraints
- [ ] Test all computed fields

**Workflow Tests (NEW):**
- [ ] Test complete user workflow (Create → Action → Verify)
- [ ] Test error cases (invalid inputs rejected)
- [ ] Test state transitions

**Code Coverage:** Minimum 80%
```

### **For Coder Agent: Test File Structure**

```
tests/
├── __init__.py
├── test_model_name.py              # Unit tests (existing)
└── test_model_name_workflows.py    # Workflow tests (NEW)
```

### **For Coder Agent: Running Tests**

```bash
# Run all tests
docker exec odoo_evv odoo -c /etc/odoo/odoo.conf -d postgres \
  --test-tags=evv_agreements --stop-after-init

# Run only workflow tests
docker exec odoo_evv odoo -c /etc/odoo/odoo.conf -d postgres \
  --test-tags=evv_agreements,workflow --stop-after-init

# Run only unit tests (exclude workflows)
docker exec odoo_evv odoo -c /etc/odoo/odoo.conf -d postgres \
  --test-tags=evv_agreements,-workflow --stop-after-init
```

---

## 🔗 **Related Documents**

- **Testing Standards:** `aos-architecture/standards/TESTING.md`
- **Coder Agent Primer:** `aos-architecture/prompts/onboarding_coder_agent.md`
- **Work Order Template:** `aos-architecture/templates/work_order_template.md`

---

## 🎓 **Philosophy**

**"Test workflows like a user acts, not like a developer thinks."**

Every button a user clicks should have a test.  
Every error they might hit should be tested.  
Every happy path should be verified.

**Before a human touches the UI, the code should already know it works.**

---

**Status:** DRAFT - Needs team review and approval before implementation.

