# Traction/EOS — Feature Suite Brief (Greenfield)

## Overview
Traction/EOS in Hub is being rebuilt from scratch. This brief defines the high‑level scope, outcomes, and architectural principles to guide specs and work orders.

## Goals
- Deliver an employee‑centric Traction/EOS experience: Level 10 meetings, scorecards, rocks, issues, and to‑dos.
- Architect for modular independence: the suite can be enabled/disabled without breaking other Hub modules.
- Design API‑first contracts for integrations; no direct coupling to EVV or external systems.

## Non‑Goals
- Clinical/patient workflows (EVV domain)
- PHI storage or processing in Hub

## Users and Use Cases
- DSPs and staff: simple, mobile‑first participation in meetings and to‑dos
- Managers: scorecards, rocks, issue tracking, and reporting
- Administrators: configuration, permissions, dashboards

## Architecture Principles
- API‑First (ADR‑003): Public service layer with stable, versioned endpoints
- Modular Independence (ADR‑007): Each sub‑feature is loosely coupled
- Multi‑Tenancy Ready (ADR‑006): No hardcoded company data; tenant‑aware design
- Security: No PHI in Hub; standard Odoo ACLs and record rules

## Feature Scope (Initial)
1. Meetings (Level 10)
   - Schedule, agenda, notes, action items
   - Completion workflow and event broadcasting
2. Scorecards
   - KPIs, weekly updates, thresholds
3. Rocks
   - Quarterly goals, ownership, progress, company vs team scope
4. Issues
   - Capture, triage, resolve, link to meetings and to‑dos
5. To‑Dos
   - Assignment, due dates, status, reminders

## Integration Boundaries
- Internal: Hub services (e.g., notifications, dashboards)
- External: EVV only via formal APIs; no direct DB access

## Deliverables
- This brief (living document)
- Epics and `STORY.yaml` specs in `aos-architecture/specs/hub/traction/`
- Work orders created under `aos-architecture/work_orders/pending/`

## Milestones (Proposed)
1. Architecture and domain model outline
2. Meetings service MVP (create, run, complete)
3. To‑Dos service MVP
4. Rocks service MVP
5. Scorecards service MVP
6. Issues service MVP

## Acceptance Criteria (for MVP readiness)
- Service layer endpoints defined and documented
- Mandatory tests per standards; zero failures
- Role‑based access and record rules in place
- No PHI; tenant‑aware behaviors verified


