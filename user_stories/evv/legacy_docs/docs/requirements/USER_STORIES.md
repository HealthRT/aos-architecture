# User Stories (MVP)

_Last updated: 2025-10-04_

This file defines MVP user stories with acceptance criteria and test IDs.
All changes to behavior should check a box here in PRs and update specs/tests accordingly.

---

## VISIT_START_STOP_001 — DSP starts/stops a visit (single service)
**As a** DSP  
**I want** to start and stop a visit for a service code  
**So that** my time is recorded accurately

### Acceptance
- [ ] A1: Start requires a valid service code approved for the Individual
- [ ] A2: Stop cannot occur before Start; duration >= 1 minute
- [ ] A3: Provisional unit balance is shown after Start and at Stop (no PHI in UI beyond what’s needed)
- [ ] A4: Controller returns `correlation_id`; logs contain `event=start/stop`, `error.code` if any
- [ ] A5: No PHI in logs

**Test IDs**
- API: `VISIT_START_STOP_API_001`
- E2E: `VISIT_START_STOP_E2E_001`

---

## VISIT_SWITCH_001 — DSP switches service mid-visit (multi-segment)
**As a** DSP  
**I want** to switch service types mid-visit (sequential segments)  
**So that** each service’s time is tracked and validated

### Acceptance
- [ ] A1: Must explicitly **stop** current segment before starting next (no overlap)
- [ ] A2: UI shows provisional remaining units for the next service before confirming
- [ ] A3: If projected balance < 0, block with `EVV_NO_UNITS_AVAILABLE` (post-MVP override noted)
- [ ] A4: Data model stores multiple segments under one visit with ordered `segment_index`
- [ ] A5: Logs include `correlation_id` and segment lifecycle events; no PHI

**Test IDs**
- API: `SEGMENTS_NO_OVERLAP_001`
- E2E: `SEGMENT_SWITCH_E2E_001`
- Contract: `CSV_SEGMENT_ROW_001`

---

## TIMEcards_REVIEW_001 — Supervisor reviews & approves
**As a** Supervisor (DC)  
**I want** to review and approve segments  
**So that** only compliant timecards are exported

### Acceptance
- [ ] A1: Supervisor can see segments, statuses, and validation results (codes, not PHI)
- [ ] A2: Approval recomputes minutes and units with 15-min rounding
- [ ] A3: Non-compliant segments show `eligibility_status=ineligible` with `error.code`
- [ ] A4: Approved segments are idempotently exportable (stable external IDs)

**Test IDs**
- API: `APPROVAL_RECALC_001`
- Unit: `ROUNDING_AT_EXPORT_001`

---

## EXPORT_CSV_BASIC_001 — Export basic CSV (no PHI)
**As a** Billing user  
**I want** to export a CSV without PHI  
**So that** Pavillio can ingest it and we minimize data risk

### Acceptance
- [ ] A1: One row per **approved segment**
- [ ] A2: Headers and types match `contracts/csv/timecard_export_v1.csvspec.md`
- [ ] A3: Strict vs lenient modes behave as specified (errors CSV vs ineligible rows)
- [ ] A4: Export logs contain `export_batch_id`, row count, checksum; no PHI

**Test IDs**
- Contract: `CSV_CONTRACT_BASIC_001`
- Unit: `CSV_STRICT_LENIENT_001`

---

## EXPORT_CSV_PHI_001 — Export CSV with PHI (gated)
**As a** Supervisor/Manager  
**I want** to export a PHI-enriched CSV for manual upload  
**So that** Pavillio receives required identifiers

### Acceptance
- [ ] A1: Export profile `phi` requires role + MFA re-auth + purpose-of-use
- [ ] A2: Download served with **no-store** headers (local download only)
- [ ] A3: Columns match `timecard_export_v1.phi.csvspec.md`
- [ ] A4: Audit logs capture metadata only (no PHI), including checksum

**Test IDs**
- Contract: `CSV_CONTRACT_PHI_001`
- Security: `NO_PHI_IN_LOGS_001`

---

## UNITS_CAP_ENFORCEMENT_001 — Cap windows and balances
**As a** System  
**I want** to enforce service agreement caps by service code  
**So that** overuse is prevented or flagged

### Acceptance
- [ ] A1: Capture-time provisional check considers cap window (daily/weekly/monthly/auth-span; configurable)
- [ ] A2: Approval/export recomputes units and enforces cap; on breach mark `ineligible` and include `error.code`
- [ ] A3: Unit consumption recorded in an append-only ledger (idempotent on re-export)
- [ ] A4: Config matrix drives service-specific policies (combine-adjacent, min billable, rounding mode)

**Test IDs**
- Unit: `CAP_WINDOW_ENFORCEMENT_001`
- Unit: `LEDGER_IDEMPOTENCY_001`

---

## Offline & Performance (cross-cutting)
### Acceptance
- [ ] OP1: UI continues to function with spotty network; queues writes for sync
- [ ] OP2: Payloads are small; no external fonts/scripts; CSP enforced
- [ ] OP3: Basic Lighthouse/axe-core thresholds pass on mobile

**Test IDs**
- Perf: `LIGHTHOUSE_BUDGET_001`
- ADA: `AXE_SMOKE_001`
