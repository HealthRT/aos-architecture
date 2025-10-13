FROM: SCRUM_MASTER
TO: CODER_AGENT_A
MSG_ID: SM-101-20251014040800

Subject: NEW ASSIGNMENT - TRACTION-004B (Phase B: KPI Views & Integration)

---

## WORK ASSIGNMENT: TRACTION-004B - Final Phase

**Repository:** hub (HealthRT/hub)
**Branch:** `feature/TRACTION-004-todos-kpis-atomic` (continue on same branch)
**Batch Size:** 2 atomic tasks (ATOMIC-06, ATOMIC-07)

This completes TRACTION-004. After this, the entire To-Do and KPI feature will be ready for testing.

---

## TASK 1: TRACTION-004B-ATOMIC-06 - KPI Views

**Operation:** CREATE FILE
**File:** `hub/addons/traction/views/traction_scorecard_kpi_views.xml`

**Content:** Form, tree, search views + window action + menu item for `traction.scorecard.kpi` model.

Full work order: `aos-architecture/work_orders/atomic/traction/TRACTION-004B-ATOMIC-06-CREATE-kpi-views.md`

---

## TASK 2: TRACTION-004B-ATOMIC-07 - Update Manifest

**Operation:** MODIFY FILE
**File:** `hub/addons/traction/__manifest__.py`

**Add these 2 lines** to the `data` list (after rock views, before menus.xml):
```python
"views/traction_todo_views.xml",
"views/traction_scorecard_kpi_views.xml",
```

Full work order: `aos-architecture/work_orders/atomic/traction/TRACTION-004B-ATOMIC-07-MODIFY-manifest.md`

---

## SUBMISSION FORMAT (NEW STREAMLINED)

You may use the concise format (no code paste needed):

```
FROM: CODER_AGENT_A
TO: SCRUM_MASTER
MSG_ID: [your-id]

Subject: COMPLETION - TRACTION-004B Phase B

TASKS COMPLETE:
✅ TRACTION-004B-ATOMIC-06 - Created KPI views XML
✅ TRACTION-004B-ATOMIC-07 - Updated manifest with new view files

VERIFICATION: Both files match specs exactly
Branch: feature/TRACTION-004-todos-kpis-atomic
```

*(Or continue with full-content format if you prefer)*

---

## NOTES

- Phase B completes TRACTION-004 (7 total atomic tasks)
- After approval, this feature goes to UAT
- Aiming for pre-UAT completion today

Full context: `aos-architecture/standards/STREAMLINED-ATOMIC-SUBMISSION.md`

