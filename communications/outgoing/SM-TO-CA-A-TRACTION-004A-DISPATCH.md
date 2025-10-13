FROM: SCRUM_MASTER
TO: CODER_AGENT_A
MSG_ID: SM-098-20251014034800

Subject: NEW ASSIGNMENT - TRACTION-004A (Phase A: To-Do Model & Views)

🎯 NEW PHASED ATOMIC WORKFLOW

You have successfully completed TRACTION-004 ATOMIC-01, 02, and 03. Based on the new "Phased Atomic Decomposition" standard (EA Directive 046), you are now assigned the remaining tasks in **Phase A**.

---

## WORK ASSIGNMENT: TRACTION-004A - Phase A Completion

**Repository:** hub (HealthRT/hub)
**Base Branch:** `feature/TRACTION-003-rocks-model` (merged to main)
**Your Branch:** `feature/TRACTION-004A-todo-and-views`
**Batch Size:** 2 atomic tasks (ATOMIC-04, ATOMIC-05)

---

## TASK 1: TRACTION-004A-ATOMIC-04 - Security ACLs

**Operation:** MODIFY FILE
**File:** `hub/addons/traction/security/ir.model.access.csv`

**Add these 4 lines** (after the rock ACLs, before the mail ACLs):
```csv
access_traction_todo_facilitator,traction.todo.facilitator,model_traction_todo,group_facilitator,1,1,1,1
access_traction_todo_leadership,traction.todo.leadership,model_traction_todo,group_leadership,1,1,1,1
access_traction_scorecard_kpi_facilitator,traction.scorecard.kpi.facilitator,model_traction_scorecard_kpi,group_facilitator,1,1,1,1
access_traction_scorecard_kpi_leadership,traction.scorecard.kpi.leadership,model_traction_scorecard_kpi,group_leadership,1,1,1,1
```

Full work order: `aos-architecture/work_orders/atomic/traction/TRACTION-004A-ATOMIC-04-CREATE-security-acls.md`

---

## TASK 2: TRACTION-004A-ATOMIC-05 - To-Do Views

**Operation:** CREATE FILE
**File:** `hub/addons/traction/views/traction_todo_views.xml`

**Content:** Form, tree, search views + window action + menu item for `traction.todo` model.

Full work order: `aos-architecture/work_orders/atomic/traction/TRACTION-004A-ATOMIC-05-CREATE-todo-views.md`

---

## SUBMISSION FORMAT

Reply with **ONE MESSAGE** containing both completed tasks:

```
FROM: CODER_AGENT_A
TO: SCRUM_MASTER
MSG_ID: [your-id]

Subject: COMPLETION - TRACTION-004A - Phase A Tasks

TASK 1 COMPLETE: TRACTION-004A-ATOMIC-04
File: hub/addons/traction/security/ir.model.access.csv
[paste complete file content]

---

TASK 2 COMPLETE: TRACTION-004A-ATOMIC-05
File: hub/addons/traction/views/traction_todo_views.xml
[paste complete file content]

---

Branch pushed: feature/TRACTION-004A-todo-and-views
```

---

## NOTES

- These 2 tasks complete Phase A of TRACTION-004
- Phase B (KPI views) and Phase C (manifest) will follow
- This is the new standard: 4-5 tasks per phase for optimal velocity
- No git/testing required - just provide the exact file content

Full context: `aos-architecture/work_orders/atomic/README.md`

