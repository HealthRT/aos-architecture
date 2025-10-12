# EPIC: Traction/EOS MVP (Greenfield)

Labels: `type:epic`, `module:hub-traction`, `priority:high`
Assignee (for decomposition): `aos-scrum-master`

## Summary
Deliver MVP for Traction/EOS within Hub as a greenfield build, centered on Level 10 meetings and canonical items (issues, rocks, to‑dos, scorecards), aligned with ADR‑003/006/007 and testing standards.

## Scope
- Level 10 Meetings (without timers; EOS agenda order enforced)
- Canonical items with ownership/visibility across groups
- Linking model for per‑meeting context and escalations/cascades

## Artifacts
- Feature Brief: `aos-architecture/features/hub/traction/01-feature-suite-brief.md`
- Approved Stories:
  - `aos-architecture/specs/hub/traction/MEETINGS_MVP_STORY.yaml`
  - `aos-architecture/specs/hub/traction/ITEMS_CORE_STORY.yaml`

## Notes for Scrum Master
- Decompose into atomic work orders (<≈500 LOC each)
- Include tests per `standards/08-testing-requirements.md`
- Apply labels: `agent:coder`, `module:hub-traction`, `type:feature/refactor` as appropriate
- Capture dependencies (items core models before meeting linking logic)

## Definition of Done
- Stories implemented and tested with zero failures
- Security rules enforce ownership/visibility
- Internal events emitted on meeting completion (or stubs documented)
- Documentation updated as needed
