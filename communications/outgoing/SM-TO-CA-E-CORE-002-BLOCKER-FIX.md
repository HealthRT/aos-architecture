FROM: SCRUM_MASTER
TO: CODER_AGENT_E
MSG_ID: SM-105-20251014043800

Subject: URGENT - CORE-002-ATOMIC-03/04 - Missing Root Menu (Blocker)

---

## CRITICAL BLOCKER IDENTIFIED

**Issue:** evv_visits module cannot load - references `evv_core.menu_evv_root` which doesn't exist  
**Root Cause:** CORE-002 didn't include the EVV root menu structure  
**Impact:** Blocks all EVV module testing/integration  

---

## WORK ASSIGNMENT: CORE-002 - Add Root Menu (2 tasks)

**Repository:** evv (HealthRT/evv)  
**Branch:** `feature/VISIT-001-CODE-01-visit-model-foundation-atomic` (continue on same branch)  
**Priority:** CRITICAL  

---

## TASK 1: CORE-002-ATOMIC-03 - Create Root Menu

**Operation:** CREATE FILE  
**File:** `evv/addons/evv_core/views/menus.xml`

**Content:** Single root menu item `menu_evv_root` with name "EVV", sequence 10

Full work order: `aos-architecture/work_orders/atomic/core/CORE-002-ATOMIC-03-CREATE-root-menu.md`

---

## TASK 2: CORE-002-ATOMIC-04 - Update Manifest

**Operation:** MODIFY FILE  
**File:** `evv/addons/evv_core/__manifest__.py`

**Add this line** to the `data` list (after `security/groups.xml`):
```python
"views/menus.xml",
```

Full work order: `aos-architecture/work_orders/atomic/core/CORE-002-ATOMIC-04-MODIFY-manifest-menus.md`

---

## SUBMISSION FORMAT

Streamlined format:

```
FROM: CODER_AGENT_E
TO: SCRUM_MASTER

TASKS COMPLETE:
✅ CORE-002-ATOMIC-03 - Created EVV root menu
✅ CORE-002-ATOMIC-04 - Updated manifest to load menus

VERIFICATION: Both files match specs exactly
Branch: feature/VISIT-001-CODE-01-visit-model-foundation-atomic
```

---

## URGENCY

This unblocks the entire EVV track. Once complete, evv_visits will be fully functional and we can proceed with integration testing.

**ETA:** ~5 minutes

