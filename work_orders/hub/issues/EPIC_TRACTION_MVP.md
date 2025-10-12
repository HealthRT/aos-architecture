# Issue Draft: EPIC – Traction/EOS MVP (Greenfield)

**Title:** EPIC: Traction/EOS MVP (Greenfield)  
**Labels:** type:epic, module:hub-traction, priority:high  
**Assignee:** aos-scrum-master

---

## Summary

Deliver the Traction/EOS MVP inside Hub as a greenfield implementation centered on Level 10 meetings, canonical items (issues, rocks, to-dos, scorecard KPIs), and the meeting-item junction that preserves per-meeting context—aligned with ADR-003/006/007 and testing standards.

---

## Scope & Notes

- EOS Level 10 meetings for two weekly groups: Executive Leadership & Management (Designated Coordinators).  
- No timers in MVP; facilitator-only control of agenda progression.  
- Canonical items share a single ownership model (`owner_group_id`, `visible_group_ids`) with escalation/cascade semantics.  
- Junction model `traction.meeting_item_link` captures per-meeting context and supports escalations/cascades between groups.

---

## Key Artifacts

- Feature Brief: `aos-architecture/features/hub/traction/01-feature-suite-brief.md`  
- Story: `aos-architecture/specs/hub/traction/MEETINGS_MVP_STORY.yaml`  
- Story: `aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`

---

## Decomposition Overview

1. Implement canonical item foundations (ITEMS_CORE) before meeting workflows.  
2. Deliver meeting model, agenda flow, and linking after core items exist.  
3. Each work order stays under ≈500 LOC, includes comprehensive testing per `standards/08-testing-requirements.md`, and carries labels `agent:coder`, `module:hub-traction`, `priority:high`.

---

## Initial Work Orders

1. **TRACTION-001:** Establish Traction groups, security, and seed data.  
2. **TRACTION-002:** Canonical issues model with escalation/cascade behaviors.  
3. **TRACTION-003:** Rocks model plus leadership-only guardrails.  
4. **TRACTION-004:** To-Dos and Scorecard KPI models.  
5. **TRACTION-005:** Meeting model, agenda progression, section notes.  
6. **TRACTION-006:** Meeting item linking junction and snapshot context.  
7. **TRACTION-007:** Escalation/cascade automation from meetings.  
8. **TRACTION-008:** Integration tests & documentation for MVP proof.

---

## Definition of Done

- All stories implemented and tested with zero failures.  
- Security rules enforce ownership/visibility correctly.  
- Meeting completion logs provide stubs for downstream events.  
- Documentation updated for canonical items, meetings, and operations.


