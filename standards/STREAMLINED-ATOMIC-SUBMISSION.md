# Streamlined Atomic Submission Protocol

**Status:** ACTIVE  
**Effective:** 2025-10-14  
**Authority:** Scrum Master Process Improvement  

---

## Problem Statement

Current atomic workflow requires agents to paste full file contents (sometimes 100+ lines) in their completion messages. This creates:
- Large message payloads
- Copy-paste friction for the Product Owner
- Redundant content (spec already has "Required Final Content")

---

## Streamlined Workflow

### For Agents: Simplified Submission Format

**Instead of pasting full code, use this concise format:**

```
FROM: CODER_AGENT_[X]
TO: SCRUM_MASTER
MSG_ID: [your-id]

Subject: COMPLETION - [WORK-ORDER-ID]

TASKS COMPLETE:
✅ [WORK-ORDER-ID]-ATOMIC-[XX] - [brief description]
✅ [WORK-ORDER-ID]-ATOMIC-[YY] - [brief description]

VERIFICATION:
- Content matches "Required Final Content" in work order specifications exactly
- Files created/modified as specified
- [Optional: Any clarifications or notes]

Branch: [branch-name]
```

**Example:**
```
FROM: CODER_AGENT_A
TO: SCRUM_MASTER
MSG_ID: CA-A-123

Subject: COMPLETION - TRACTION-004A Phase A

TASKS COMPLETE:
✅ TRACTION-004A-ATOMIC-04 - Added 4 ACL lines for todo/kpi models
✅ TRACTION-004A-ATOMIC-05 - Created todo views XML (form/tree/search/action/menu)

VERIFICATION:
- Both files match "Required Final Content" exactly
- ACL lines placed after rock entries, before mail entries

Branch: feature/TRACTION-004A-todo-and-views
```

---

## For Scrum Master: Integration Process

1. **Receive** agent's concise completion message
2. **Read** the atomic work order files (which contain "Required Final Content")
3. **Write** files directly using the specification content
4. **Commit** and push with descriptive message
5. **Notify** agent of approval/integration

This approach:
- ✅ Eliminates copy-paste friction
- ✅ Uses single source of truth (work order spec)
- ✅ Reduces message size by ~90%
- ✅ Maintains verification and audit trail

---

## Fallback: Detailed Submission

If content deviates from spec or requires clarification, agents may still provide full code in their submission. Use judgment.

---

## Rollout

- **Immediate:** Optional for all agents
- **Encouraged:** Especially for batches of 2+ tasks or large files (50+ lines)
- **Agent Choice:** Agents may continue using full-content format if preferred

The goal is efficiency, not rigidity.

