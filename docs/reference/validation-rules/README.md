# Business Validation Rules & Reference Data

This directory contains business logic, calculation rules, and reference data from external authoritative sources.

---

## 📁 Subdirectories

### `service-authorization/` - Service Authorization Rules
Validation rules, rate tables, and authorization logic for waiver service agreements.

**Source:** Minnesota DHS, county case management systems

**Key Documents:**
- Unit validation matrix (which services can have which unit types) - *Pending*
- 2025 rate tables (authorized reimbursement rates) - *Pending*
- Authorization approval logic - *Pending*

**Used by:**
- AGMT-001 (Service Agreement model - stores authorized rates/units)
- Future Service Validation Engine
- Future claims/billing features

**Format:** Excel/CSV for rate tables, Markdown for logic descriptions

---

### `overtime-calculations/` - Overtime Rules
FLSA and state-level overtime calculation rules, blended overtime formulas.

**Source:** U.S. Department of Labor (FLSA), Minnesota Department of Labor

**Key Documents:**
- FLSA overtime rules - *Pending*
- Minnesota state overtime rules - *Pending*
- Blended overtime calculation examples - *Pending*

**Used by:**
- Hub Payroll module
- Hub blended overtime calculator

**Format:** Markdown with worked examples, potentially Python reference implementation

---

## 📋 Document Types

### Rate Tables
**Format:** CSV or Excel  
**Example:** `rate-tables-2025.csv`

Columns might include:
- Service code
- Modifier
- Rate per unit
- Effective date
- County/region

**Purpose:** Validate service agreement rates, calculate expected reimbursement

---

### Validation Matrices
**Format:** Excel or Markdown tables  
**Example:** `unit-validation-matrix.xlsx`

Defines:
- Which service codes require which modifiers
- Valid unit types for each service (hours, visits, miles)
- Min/max authorized quantities
- Conflicting service combinations

**Purpose:** Validate service agreements before activation

---

### Calculation Formulas
**Format:** Markdown with examples  
**Example:** `blended-overtime-calculation.md`

Includes:
- Formula definition
- Worked examples
- Edge cases
- Rounding rules
- Regulatory citation

**Purpose:** Implement business logic in code, create test cases

---

## 📋 Adding Validation Rules

### Before Adding
1. **Verify authoritative source**
   - Government agency?
   - Vendor-provided?
   - Industry standard?
2. **Document source and date**
   - Rules change; need audit trail
3. **Identify effective date**
   - May need multiple versions

### After Adding
1. Create/update subdirectory README with:
   - Source of rules
   - Date obtained/effective
   - Which features implement these rules
   - Known exceptions or edge cases
2. Update this README
3. Update parent INDEX.md
4. Reference in:
   - Relevant specs (validation section)
   - Test cases (acceptance criteria)
   - ADRs (if rules influenced architectural decision)

---

## 🔗 Cross-References

### Specs Implementing Validation Rules
- **AGMT-001:** Service agreement validation (date ranges, positive units)
- **Future:** Service Validation Engine (comprehensive authorization validation)
- **Future:** Payroll module (overtime calculations)

### ADRs Citing Business Rules
- May create ADRs when business rules require specific architectural approaches
- Example: "ADR-XXX: Service Validation Engine Architecture" might cite `unit-validation-matrix.xlsx`

---

## ⚠️ Important Notes

### Version Control
Business rules change (new rates, updated policies):
1. Keep historical versions with date suffix: `rate-tables-2024.csv`, `rate-tables-2025.csv`
2. Note effective date in filename
3. Document in subdirectory README which version applies when
4. System may need to use different rules based on date of service

### Testing
Validation rules are CRITICAL for test case development:
- Use examples from these docs to create unit tests
- Test edge cases documented in rules
- Verify system matches authoritative source

### Regulatory Alignment
Validation rules often come from regulatory requirements:
- Cross-reference to `regulatory/` documents
- Note regulatory citation in README
- Keep rules in sync with regulation updates

---

## 📊 Status Tracking

Check each subdirectory README for status of specific rules/tables:
- **Available** - Uploaded and implemented in system
- **Pending** - Identified but not uploaded
- **Requested** - Awaiting from external party
- **In Development** - Rules partially implemented

---

**Last updated:** 2025-10-11

