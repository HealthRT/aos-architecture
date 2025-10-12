# AOS Architecture Scripts

This directory contains automation scripts for maintaining quality and consistency in the AOS development process.

---

## `validate-work-order.sh`

### Purpose
Validates that work orders meet quality standards before dispatch to Coder Agents.

### Usage
```bash
chmod +x scripts/validate-work-order.sh
./scripts/validate-work-order.sh path/to/WO-XXX-YY.md
```

### What It Checks
1. **Prohibited Phrases:** Detects "tests optional" and similar phrases
2. **Testing Requirements Section:** Ensures mandatory testing section exists
3. **Testing Standards Reference:** Verifies `08-testing-requirements.md` is referenced
4. **Proof of Execution Section:** Confirms section exists
5. **Test Execution Command:** Looks for test command (with flexibility for docs-only WOs)
6. **Required Sections:** Validates standard work order structure

### Exit Codes
- `0` - Validation passed, work order is ready
- `1` - Validation failed, work order must be corrected

### Example Output
```
🔍 Validating work order: work_orders/evv/AGMT-001/WO-AGMT-001-01.md

Check 1: Prohibited phrases...
✅ PASS: No prohibited phrases

Check 2: Testing Requirements section...
✅ PASS: Testing Requirements section found

Check 3: Testing standards reference...
✅ PASS: Testing standards document referenced

Check 4: Proof of Execution section...
✅ PASS: Proof of Execution section found

Check 5: Test execution command...
✅ PASS: Test execution command found

Check 6: Required sections...
✅ PASS: All required sections found

═══════════════════════════════════════════
✅ VALIDATION PASSED: Work order meets quality standards
═══════════════════════════════════════════
```

### Integration Points

**Scrum Master Workflow:**
- Scrum Master primer instructs agents to run this script before submitting work orders
- Manual self-check checklist aligns with script validation

**Human Review:**
- Architect can quickly validate work orders before dispatch
- Reduces manual review time

**Future Automation:**
- Can be integrated into pre-commit hooks
- Can be used in GitHub Actions CI pipeline

---

## Adding New Scripts

When adding scripts to this directory:
1. Make them executable: `chmod +x scripts/your-script.sh`
2. Add usage documentation to this README
3. Reference script in relevant primer/workflow documents
4. Test on sample work orders before committing

---

## Maintenance

**Owner:** Executive Architect  
**Review Frequency:** When process improvements are identified  
**Related Documents:**
- `prompts/onboarding_scrum_master.md` - References validation script
- `templates/work_order_template.md` - Defines structure being validated
- `standards/08-testing-requirements.md` - Testing standards enforced by script

