# Atomic Work Orders

## Operation Craftsman - Simplified Agent Workflow

**Philosophy:** Agents are single-file code generators, not full-stack developers.

---

## Atomic Work Order Format

Every atomic work order follows this structure:

### Required Fields

1. **Operation:** `CREATE FILE` or `MODIFY FILE`
2. **Target File Path:** Full path to the single file
3. **[If Modifying] Original Content:** Complete verbatim content of existing file
4. **Instructions:** Plain English description of changes
5. **Required Final Content:** Complete final file content (agent's deliverable)

---

## Agent Responsibilities (Simplified)

✅ **Agent DOES:**
- Read the work order
- Produce the complete final file content
- Submit the content in their completion report

❌ **Agent DOES NOT:**
- Manage git (no branching, committing, pushing)
- Run tests (SM verifies)
- Coordinate multi-file changes (each task is one file)
- Verify on GitHub (SM handles)

---

## Scrum Master Responsibilities (Expanded)

✅ **SM DOES:**
- Create git branches
- Apply agent's file content to the branch
- Run tests and verify
- Commit and push changes
- Merge to main when complete
- Manage work order sequencing

---

## Benefits

1. **Radical Simplification:** 90% reduction in cognitive load
2. **Clear Deliverable:** One file content, nothing else
3. **Easy Verification:** Diff the file, test the module
4. **Eliminates Failure Modes:**
   - No git confusion
   - No test execution errors
   - No branch verification issues
   - No multi-file scope creep

---

## Directory Structure

```
atomic/
├── visit/          # VISIT epic atomic work orders
├── agmt/           # AGMT epic atomic work orders
├── traction/       # TRACTION epic atomic work orders
└── README.md       # This file
```

---

## Work Order Naming Convention

Format: `{EPIC}-{SEQUENCE}-{OPERATION}-{FILE}.md`

Examples:
- `VISIT-001-CREATE-manifest.md`
- `VISIT-002-CREATE-model.md`
- `VISIT-003-MODIFY-manifest.md`
- `AGMT-001-CREATE-views.md`

---

## Example Atomic Work Order

```markdown
---
title: "TRACTION-004-CREATE-manifest"
epic: "TRACTION-004"
operation: "MODIFY FILE"
sequence: 1
assignee: "aos-coder-agent"
---

# Atomic Work Order: TRACTION-004-001-MODIFY-manifest

**Operation:** MODIFY FILE

**Target File Path:** `hub/addons/traction/__manifest__.py`

**Original Content:**
```python
{
    "name": "Traction EOS",
    "version": "18.0.1.0.0",
    "depends": ["base", "mail"],
    "data": [
        "security/traction_security.xml",
    ],
}
```

**Instructions:**
Add the new security ACL file to the manifest's 'data' list. Place it after `traction_security.xml`.

**Required Final Content:**
```python
{
    "name": "Traction EOS",
    "version": "18.0.1.0.0",
    "depends": ["base", "mail"],
    "data": [
        "security/traction_security.xml",
        "security/ir.model.access.csv",
    ],
}
```

**Submission Format:**
Reply with: "ATOMIC TASK COMPLETE" followed by the complete final file content in a code block.
```

---

**Authority:** Executive Architect Directive EA-042 (Operation Craftsman)  
**Effective:** 2025-10-14 01:15:00 UTC

