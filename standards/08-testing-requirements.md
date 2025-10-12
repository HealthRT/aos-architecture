# 8. Testing Requirements and Standards

**Status:** Accepted  
**Date:** 2025-10-09

---

## Overview

This document defines testing requirements for the AOS project. Following these standards ensures code quality, catches bugs early, and enables confident refactoring.

**Key Principle:** Testing is not optional. It is as essential as the code itself.

---

## When to Write Tests

### ✅ Always Required

**You MUST write tests when:**
- Creating new methods or functions
- Modifying existing business logic
- Adding new models or fields with logic
- Implementing validation or constraints
- Handling external data (URLs, APIs, user input)
- Creating service layer methods

**Exception:** Pure documentation changes (no code modified)

### 🎯 Test Types by Scenario

| Scenario | Unit Tests | Integration Tests | Security Tests |
|----------|------------|-------------------|----------------|
| New service method | ✅ Required | ⚠️ If cross-module | ❌ No |
| Form validation | ✅ Required | ❌ No | ❌ No |
| External API call | ✅ Required | ✅ Required | ✅ Required |
| Event broadcasting | ✅ Required | ✅ Required | ❌ No |
| UI view changes | ❌ No | ⚠️ Recommended | ❌ No |
| Model constraints | ✅ Required | ❌ No | ❌ No |

---

## Testing Agent Workflow

### Who Writes Tests?

**Answer: The SAME agent that writes the code.**

**Workflow:**
```
Agent writes code
  ↓
Agent writes tests
  ↓
Agent runs tests
  ↓
Tests fail? → Agent fixes code AND tests
  ↓
Tests pass? → Provide proof of execution
  ↓
Ready for review
```

### Why Same Agent?

**Pros:**
- ✅ **Immediate feedback loop** - Faster iteration
- ✅ **Code context fresh** - Agent understands what was built
- ✅ **Ownership** - Agent responsible for complete, working solution
- ✅ **Efficiency** - No handoff overhead
- ✅ **Learning** - Agent improves through test-driven development

**Cons:**
- ⚠️ **Blind spots** - Agent may not think of edge cases they didn't consider
- ⚠️ **Bias** - Agent tests what they built, not what they should have built

**Solution to Cons:**
- Require specific edge case tests (documented below)
- Code review catches missing test scenarios
- Escalation path for persistent failures

### Escalation Path

**If agent can't fix failing tests after 2 iterations:**

1. Agent documents:
   - What tests are failing
   - What fixes were attempted
   - Why they think it's failing
   
2. Request review/assistance:
   - Post to GitHub issue with `status:needs-help` label
   - Tag reviewer with specific questions
   - Provide full error logs

3. Reviewer decides:
   - Guide agent to solution
   - Take over if architectural issue
   - Assign to specialist agent if needed

---

## Test Structure

### File Organization

```
addons/my_module/
├── models/
│   └── my_model.py
├── services/
│   └── my_service.py
└── tests/
    ├── __init__.py
    ├── test_my_model.py      ← Test models
    ├── test_my_service.py    ← Test services
    └── test_integration.py   ← Integration tests
```

### Test Class Template

```python
"""Unit tests for MyService."""

from datetime import date
from odoo.tests.common import TransactionCase
from odoo.exceptions import UserError, ValidationError


class TestMyService(TransactionCase):
    """Test suite for MyService domain logic."""
    
    @classmethod
    def setUpClass(cls):
        """Set up test fixtures that are reused across tests.
        
        Use setUpClass for:
        - Creating test data used by multiple tests
        - Setting up complex object graphs
        - Expensive operations that don't need to repeat
        
        Note: Changes here persist across tests in this class!
        """
        super().setUpClass()
        
        # Set up service
        cls.service = cls.env['my_module.my.service']
        
        # Create test company (avoid hardcoding company_id=1)
        cls.company = cls.env['res.company'].create({
            'name': 'Test Company',
        })
        
        # Create test users
        cls.user1 = cls.env['res.users'].create({
            'name': 'Test User 1',
            'login': 'testuser1@test.com',
            'company_id': cls.company.id,
            'company_ids': [(6, 0, [cls.company.id])],
        })
        
    def test_method_name_happy_path(self):
        """Test the expected behavior with valid input.
        
        Test naming convention:
        - test_<method_name>_<scenario>
        - Use descriptive scenarios: happy_path, edge_case, error_condition
        """
        # Arrange
        test_record = self._create_test_record()
        
        # Act
        result = self.service.my_method(test_record)
        
        # Assert
        self.assertTrue(result)
        self.assertEqual(test_record.status, 'completed')
        
    def test_method_name_with_empty_input(self):
        """Test behavior when required fields are empty/None."""
        # Edge case: What happens with empty input?
        with self.assertRaises(ValidationError):
            self.service.my_method(None)
            
    def test_method_name_without_company_context(self):
        """Test behavior when company context is missing."""
        # Edge case: No company set in environment
        # This catches bugs like the ones we found in Entry #002!
        self.env.company = False
        
        record = self.service.my_method(self.user1)
        
        # Should fall back to user's company
        self.assertEqual(record.company_id, self.user1.company_id)
    
    def _create_test_record(self):
        """Helper method to create test data.
        
        Use private helper methods (with underscore) for:
        - Creating test data
        - Complex setup
        - Reusable assertions
        """
        return self.env['my.model'].create({
            'name': 'Test Record',
            'company_id': self.company.id,
        })
```

---

## What to Test

### Happy Path Tests

**Definition:** Normal expected usage with valid inputs

**Example:**
```python
def test_create_meeting_with_valid_team_and_date(self):
    """Test meeting creation with all required valid inputs."""
    team = self.env['eos.team'].browse(1)
    meeting = self.service.create_meeting(team, date.today())
    
    self.assertTrue(meeting.exists())
    self.assertEqual(meeting.state, 'scheduled')
```

**Coverage:** Every public method needs at least one happy path test.

---

### Edge Case Tests

**Definition:** Boundary conditions, empty values, missing context

**Required Edge Cases:**

1. **Empty/None Values**
   ```python
   def test_method_with_none_parameter(self):
       with self.assertRaises(ValidationError):
           self.service.my_method(None)
   ```

2. **Empty Recordsets**
   ```python
   def test_method_with_empty_recordset(self):
       empty = self.env['my.model'].browse([])
       result = self.service.my_method(empty)
       self.assertFalse(result)
   ```

3. **Missing Company Context**
   ```python
   def test_method_without_company_context(self):
       self.env.company = False
       # Should not raise AttributeError!
       record = self.service.my_method()
       self.assertTrue(record.company_id)
   ```

4. **Missing Related Records**
   ```python
   def test_task_without_assignee(self):
       task = self.Task.create({
           'name': 'Test',
           'assignee_id': False,  # No assignee
       })
       self.assertFalse(task.assignee_id)
   ```

---

### Error Condition Tests

**Definition:** Invalid input that should raise exceptions

**Pattern:**
```python
def test_method_raises_user_error_on_invalid_date(self):
    """Test that method raises UserError for dates in the past."""
    team = self.env['eos.team'].browse(1)
    past_date = date(2020, 1, 1)
    
    with self.assertRaises(UserError) as cm:
        self.service.create_meeting(team, past_date)
    
    # Optionally verify error message
    self.assertIn('past', str(cm.exception).lower())
```

**Test ALL UserError and ValidationError conditions!**

---

### Side Effect Tests

**Definition:** Verify events, logging, notifications

**Example:**
```python
def test_complete_meeting_broadcasts_event(self):
    """Test that completing a meeting broadcasts bus event."""
    meeting = self._create_test_meeting()
    
    # Mock the bus to capture events
    with patch.object(self.env['bus.bus'], '_sendmany') as mock_bus:
        self.service.complete_meeting(meeting)
        
        # Verify event was broadcast
        mock_bus.assert_called_once()
        args = mock_bus.call_args[0][0]
        self.assertEqual(args[0][0], 'eos.meeting.completed')
```

---

### Constraint Tests

**Definition:** Test Odoo model constraints

**Example:**
```python
def test_leader_must_be_team_member(self):
    """Test that leader validation constraint works."""
    user_not_member = self.env['res.users'].create({
        'name': 'Outsider',
        'login': 'outsider@test.com',
    })
    
    with self.assertRaises(ValidationError) as cm:
        self.env['eos.team'].create({
            'name': 'Test Team',
            'leader_id': user_not_member.id,
            'member_ids': [(6, 0, [])],  # Empty members
        })
    
    self.assertIn('team member', str(cm.exception).lower())
```

---

## Security Testing

### When Required

**Test security when your code:**
- Accepts URLs from users
- Makes external HTTP requests
- Processes file uploads
- Executes dynamic code
- Accesses filesystem

### URL Validation Tests

**Required for any method accepting URLs:**

```python
def test_url_validation_blocks_private_ips(self):
    """Test that private IP addresses are blocked."""
    meeting = self.Meeting.create({
        'name': 'Test',
        'scorecard_url': 'http://192.168.1.1/admin',
    })
    
    with self.assertRaises(UserError) as cm:
        meeting.action_fetch_url()
    
    self.assertIn('private', str(cm.exception).lower())

def test_url_validation_blocks_localhost(self):
    """Test that localhost is blocked."""
    meeting = self.Meeting.create({
        'name': 'Test',
        'scorecard_url': 'http://localhost:8000/secrets',
    })
    
    with self.assertRaises(UserError):
        meeting.action_fetch_url()

def test_url_validation_allows_whitelisted_domains(self):
    """Test that whitelisted domains are allowed."""
    meeting = self.Meeting.create({
        'name': 'Test',
        'scorecard_url': 'https://docs.google.com/spreadsheets/123',
    })
    
    # Should not raise
    result = meeting.action_fetch_url()
    self.assertTrue(result)
```

---

## Odoo-Specific Patterns

### Using TransactionCase

**Most common test base class:**

```python
from odoo.tests.common import TransactionCase

class TestMyFeature(TransactionCase):
    """Each test runs in a transaction that's rolled back."""
```

**Benefits:**
- ✅ Tests are isolated (changes don't persist)
- ✅ Fast (no database commits)
- ✅ Can test database operations

**When to use:** 99% of tests

---

### Creating Test Data

**NEVER hardcode IDs!**

```python
# ❌ BAD
user = self.env['res.users'].browse(1)  # What if ID 1 doesn't exist?

# ✅ GOOD
user = self.env['res.users'].create({
    'name': 'Test User',
    'login': 'test@test.com',
})

# ✅ ALSO GOOD (if record must exist)
user = self.env.ref('base.user_admin')
```

---

### Testing with Context

**Simulating different contexts:**

```python
def test_method_in_different_company(self):
    """Test behavior when run in different company context."""
    company2 = self.env['res.company'].create({'name': 'Company 2'})
    
    # Run in company2 context
    record = self.service.with_context(
        allowed_company_ids=[company2.id]
    ).my_method()
    
    self.assertEqual(record.company_id, company2)
```

---

### Mocking External Calls

**For methods that make HTTP requests:**

```python
from unittest.mock import patch

def test_api_call_success(self):
    """Test successful external API call."""
    with patch('requests.get') as mock_get:
        # Setup mock response
        mock_get.return_value.status_code = 200
        mock_get.return_value.json.return_value = {'status': 'ok'}
        
        # Call method that uses requests.get
        result = self.service.fetch_external_data()
        
        # Verify
        self.assertTrue(result)
        mock_get.assert_called_once()
```

---

## Test Coverage Requirements

### Minimum Coverage

**For each Pull Request:**
- ✅ All new methods must have tests
- ✅ All modified methods must have tests
- ✅ At least one edge case test per method
- ✅ All error conditions tested

**Not Required:**
- ❌ 100% line coverage (nice to have, not required)
- ❌ Tests for unmodified code

---

### Coverage by Code Type

| Code Type | Required Coverage |
|-----------|------------------|
| Service methods | 100% (all methods) |
| Model `create()` override | 100% |
| Model `write()` override | 100% |
| `@api.constrains` | 100% |
| Computed fields | 80% (major scenarios) |
| Button actions | 80% (happy path + 1 error) |
| Wizards | 80% |
| Reports | 50% (spot checks) |

---

## Running Tests

### Command Line

```bash
# Run all tests for a module
odoo-bin -c /etc/odoo/odoo.conf \
  --test-enable \
  --stop-after-init \
  -i my_module \
  --log-level=test:INFO

# Run specific test class
odoo-bin -c /etc/odoo/odoo.conf \
  --test-enable \
  --stop-after-init \
  -i my_module \
  --test-tags /TestMyService \
  --log-level=test:INFO

# Run with more verbose output
odoo-bin -c /etc/odoo/odoo.conf \
  --test-enable \
  --stop-after-init \
  -i my_module \
  --log-level=test:DEBUG
```

---

### In Docker

```bash
# From host machine
docker compose exec odoo odoo-bin \
  -c /etc/odoo/odoo.conf \
  -d odoo \
  --test-enable \
  --stop-after-init \
  -i my_module \
  --log-level=test:INFO
```

---

## Proof of Execution Format

**When submitting work, provide:**

```markdown
## Proof of Execution - Tests

### Test Execution
```bash
$ odoo-bin --test-enable -i my_module --log-level=test:INFO
...
my_module: 7 tests 0.34s 156 queries
0 failed, 0 error(s)
```

### Coverage
- Methods tested: 5/5 (100%)
- Edge cases: 8 scenarios covered
- Error conditions: 3 scenarios covered

### Test Files
- `tests/test_my_service.py` (127 lines, 7 tests)
- `tests/test_my_model.py` (89 lines, 4 tests)
```

---

## Common Pitfalls

### ❌ Don't: Test Internal Implementation

```python
# BAD: Testing private method directly
def test_internal_helper_method(self):
    result = self.service._internal_helper()
```

**Why bad:** Private methods are implementation details. Test public API instead.

---

### ❌ Don't: Hardcode Test Data

```python
# BAD: Hardcoded IDs
user = self.env['res.users'].browse(2)
company = self.env['res.company'].browse(1)
```

**Why bad:** Breaks in different environments. Create test data instead.

---

### ❌ Don't: Test Without Assertions

```python
# BAD: No assertions
def test_create_meeting(self):
    meeting = self.service.create_meeting(team, date.today())
    # Test passes even if method returns None!
```

**Why bad:** Test always passes. Add assertions to verify behavior.

---

### ❌ Don't: Have Interdependent Tests

```python
# BAD: Test depends on order
def test_step_1(self):
    self.record = self.service.create()
    
def test_step_2(self):
    self.service.update(self.record)  # Fails if step_1 didn't run first!
```

**Why bad:** Tests should be independent. Create needed data in each test.

---

### ✅ Do: Use Descriptive Test Names

```python
# GOOD: Clear what's being tested
def test_complete_task_sets_status_to_done(self):
def test_complete_task_broadcasts_event(self):
def test_complete_task_raises_error_if_task_is_none(self):
```

**Why good:** Name tells you what broke when test fails.

---

## Examples from Our Codebase

### Example 1: Service Method Test

See: `tests/test_my_service.py` (in your module)

**Highlights:**
- ✅ Complete setup with fixtures
- ✅ Tests for create, start, complete methods
- ✅ Tests for "copy previous" or equivalent logic
- ✅ Edge cases covered

**Use this as a template for service layer tests!**

---

### Example 2: Constraint Test (From Bugfix)

**Bug we found:** Leader validation skipped when members empty

**Test that would have caught it:**

```python
def test_leader_validation_with_empty_members(self):
    """Test that leader cannot be assigned without members."""
    user = self.env['res.users'].create({
        'name': 'Test Leader',
        'login': 'leader@test.com',
    })
    
    with self.assertRaises(ValidationError) as cm:
        self.env['eos.team'].create({
            'name': 'Test Team',
            'leader_id': user.id,
            'member_ids': [(6, 0, [])],  # Empty!
        })
    
    self.assertIn('without team members', str(cm.exception))
```

---

## Testing Checklist

Before submitting code, verify:

### Code Coverage
- [ ] All new public methods have tests
- [ ] All modified methods have updated tests
- [ ] At least one happy path test per method
- [ ] At least one edge case test per method
- [ ] All error conditions tested

### Edge Cases
- [ ] Tested with None/empty values
- [ ] Tested without company context
- [ ] Tested with empty recordsets
- [ ] Tested with missing related records

### Security (if applicable)
- [ ] URL validation tested (private IPs, localhost)
- [ ] Input sanitization tested
- [ ] File upload restrictions tested

### Proof of Execution
- [ ] All tests pass (0 failures, 0 errors)
- [ ] Test output captured and provided
- [ ] Test file locations documented

---

## Questions?

**Where to get help:**
1. Review existing tests in `tests/test_meeting_service.py`
2. Check Odoo testing documentation: https://www.odoo.com/documentation/17.0/developer/reference/backend/testing.html
3. Post questions to GitHub issue with `status:needs-help` label
4. Tag `@james-healthrt` for testing-related questions

---

## Related Documents

- **Entry #002** - Process Improvement Log (testing gaps identified)
- **ADR-003** - API-First Design (why service tests matter)
- **01-odoo-coding-standards.md** - General coding standards
- **03-ai-agent-workflow.md** - How testing fits in agent workflow

---

**Remember:** Good tests are as valuable as good code. They catch bugs, enable refactoring, and serve as living documentation. Take pride in your tests! 🎯

