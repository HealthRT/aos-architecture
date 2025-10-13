---
title: "TRACTION-004B-ATOMIC-07: Update manifest for new views"
epic: "TRACTION-004B"
operation: "MODIFY FILE"
sequence: 7
repository: "hub"
assignee: "aos-coder-agent"
phase: "B - KPI Views & Integration"
---

# Atomic Work Order: TRACTION-004B-ATOMIC-07

**Operation:** MODIFY FILE

**Target File Path:** `hub/addons/traction/__manifest__.py`

**Original Content:**
```python
{
    "name": "Traction",
    "version": "18.0.1.0.0",
    "category": "Productivity",
    "summary": "EOS Traction Tools for L10 Meetings",
    "description": """
        Traction EOS (Entrepreneurial Operating System) tools for running effective L10 meetings.
        Manage Issues, Rocks, Groups, and track accountability across leadership teams.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "base",
        "mail",
    ],
    "data": [
        "security/groups.xml",
        "security/ir.model.access.csv",
        "data/ir_model.xml",
        "views/traction_group_views.xml",
        "views/traction_issue_views.xml",
        "views/traction_rock_views.xml",
        "views/menus.xml",
    ],
    "installable": True,
    "application": True,
    "auto_install": False,
}
```

**Instructions:**
Add the two new view files (`traction_todo_views.xml` and `traction_scorecard_kpi_views.xml`) to the `data` list, placed after the existing views and before `menus.xml`.

**Required Final Content:**
```python
{
    "name": "Traction",
    "version": "18.0.1.0.0",
    "category": "Productivity",
    "summary": "EOS Traction Tools for L10 Meetings",
    "description": """
        Traction EOS (Entrepreneurial Operating System) tools for running effective L10 meetings.
        Manage Issues, Rocks, Groups, and track accountability across leadership teams.
    """,
    "author": "HealthRT",
    "website": "https://healthracetech.com",
    "license": "LGPL-3",
    "depends": [
        "base",
        "mail",
    ],
    "data": [
        "security/groups.xml",
        "security/ir.model.access.csv",
        "data/ir_model.xml",
        "views/traction_group_views.xml",
        "views/traction_issue_views.xml",
        "views/traction_rock_views.xml",
        "views/traction_todo_views.xml",
        "views/traction_scorecard_kpi_views.xml",
        "views/menus.xml",
    ],
    "installable": True,
    "application": True,
    "auto_install": False,
}
```

---

## Submission Format

Use the new streamlined format:

```
TASKS COMPLETE:
✅ TRACTION-004B-ATOMIC-06 - Created KPI views XML
✅ TRACTION-004B-ATOMIC-07 - Updated manifest with new view files

VERIFICATION: Both files match specs exactly
Branch: feature/TRACTION-004-todos-kpis-atomic
```

---

**Parent Epic:** TRACTION-004B - KPI Views & Integration (Phase B)  
**Authority:** Executive Architect Directive EA-046 (Phased Atomic Decomposition)  
**Created:** 2025-10-14 04:06:00 UTC

