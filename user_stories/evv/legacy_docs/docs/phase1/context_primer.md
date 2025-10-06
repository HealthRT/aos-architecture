# EVV System Context Primer (Phase 1)

_Last updated: 2025-10-04_

This document summarizes the **core context, rules, and decisions** for the EVV MVP and future roadmap.  
It is the primary input for AI-assisted architecture and development.  
All downstream specs (architecture, guardrails, contracts, validation rules) must stay aligned with this document.

---

## 1. Purpose & MVP Scope
- Build an EVV system that:
  - Records **visits** and **service usage** by DSPs.
  - Validates against **service agreements** (units, caps, dates).
  - Exports **timecard data as CSV** for manual upload to Pavillio (our current EVV/billing system).
- MVP does **not** integrate directly with clearinghouses (837/835, JSON APIs).
- Long-term features (placeholders):
  - Rate Waiver Tracker
  - Interest Tracker
  - AI-driven Policy Watcher
  - Admin/HR/training Odoo install (linked but separate from HIPAA EVV instance)

---

## 2. Visit & Segment Model
- A **Visit** is composed of one or more sequential **Segments**.
- Each **Segment**:
  - Has a **service code/type** (e.g., in-home care with/without training).
  - Has a **start and stop time**.
  - Derives **minutes** and **units** at approval/export.
- **Rules**:
  - Only one segment active at a time (**no concurrency**).
  - DSP must explicitly stop → start to switch service codes.
  - Segments may be chained (A → B → C).
  - No overlapping segments allowed.

---

## 3. Units & Rounding
- **Unit = 15 minutes** (consistent with Minnesota 245D HCBS service codes).
- **Minutes are tracked raw** during capture.
- **Rounding occurs only at approval/export**:
  - Default: round to nearest 15 min.
  - Thresholds TBD (likely 8–22 min = 1 unit).
- Export/approval recomputes minutes → units and updates the ledger.

---

## 4. Service Agreements & Ledger
- Each Individual has a **Service Agreement**:
  - `{ service_code, cap_window, units_authorized, units_used, start_date, end_date, carryover_flag }`
- Ledger tracks unit consumption per service code.
- **Cap windows** may be daily, weekly, monthly, or authorization-span based (needs SME confirmation).
- At capture/switch:
  - Perform **provisional check** against remaining units.
  - **HARD BLOCK**: If projected unit balance is insufficient, the segment **cannot be started**. The controller must return `EVV_NO_UNITS_AVAILABLE`.
- At export/approval:
  - Recompute units and enforce caps.
  - Mark row as `ineligible` if over cap (error code logged).
- **Override workflow** (supervisor/manager) planned post-MVP.

---

## 5. CSV Export (to Pavillio)
- **Output = CSV** (manual upload by user from secure workstation).
- One **row per segment**.
- Two **profiles**:
  - **basic** (default, no PHI).
  - **phi** (includes PHI fields, gated by role + MFA + purpose-of-use, local download only).
- **Strict mode**: invalid rows dropped to `*_errors.csv`.
- **Lenient mode**: invalid rows included with `eligibility_status=ineligible`.
- Idempotent: each row has a stable `external_timecard_id`.
- **PHI Export Policy**:
  - Only certain roles (Supervisor, Manager).
  - MFA re-auth + purpose-of-use logged.
  - Download delivered with **no-store headers**.
  - CSV must be uploaded immediately to Pavillio and deleted from local machine.
  - Audit logs contain **batch metadata only** (no PHI).

---

## 6. Compliance & Security
- **HIPAA**:
  - No PHI in logs or telemetry.
  - Role-based access controls.
  - Correlation IDs for all actions.
  - PHI export subject to special controls (see above).
- **ADA**:
  - Accessible UI (contrast, ARIA roles, keyboard navigation, large touch targets).
- **Performance & CSP**:
  - Mobile-first, offline-first (DSPs ~90% mobile).
  - Spotty connections handled via async sync.
  - No external fonts/scripts unless justified with risk review.
  - Payloads and UI kept lightweight for mobile.

---

## 7. Data Models (MVP)
- **Visit** `{ visit_id, individual_id, dsp_id, started_at, stopped_at }`
- **VisitSegment** `{ segment_id, visit_id, service_code, started_at, stopped_at, minutes_raw, units_final (computed), eligibility_status, eligibility_reason }`
- **ServiceAgreement** `{ agreement_id, individual_id, service_code, units_authorized, cap_window, units_used, start_date, end_date, carryover_flag }`
- **UnitLedgerEntry** `{ ledger_id, service_code, visit_segment_id, units_consumed, period_start, period_end, timestamp }`

---

## 8. Validations
- Visit/segment dates must fall within agreement span.
- Service code must be approved for Individual.
- Units must be available in current cap window.
- No overlapping segments.
- Provisional checks at capture/switch; final checks at export/approval.
- **Unit availability is a HARD BLOCK** at capture. See `validation_rules.md` for details.
- Errors marked with **error codes** (not free text).

---

## 9. Testing Strategy
- Contract tests for CSV headers, column types, rounding.
- Unit tests for validation rules.
- Export tests: strict vs lenient mode behavior.
- ADA & performance smoke tests (axe-core, Lighthouse).
- Synthetic data used for PHI export tests.

---

## 10. Unknowns (TBD via SME/State)
- Exact cap window semantics (calendar vs rolling, daily vs monthly).
- Carryover rules.
- Minimum billable minutes (<8 min segments).
- Combining adjacent short segments.
- Override workflow details (bucket or adjustment).

---

## 11. Long-Term Roadmap Placeholders
- **Claims engine** (837/835 EDI, Claim.MD, HHAeXchange).
- **Rate Waiver Tracker** module.
- **Interest Tracker** (matching DSP and individual interests).
- **Policy Watcher** for DHS updates.
- **Admin Odoo instance** (HR, training, payroll, linked but separate).

---

## 12. Self-Check
Before generating architecture/code:
- Respect **multi-segment model**.
- Apply **15-min units** at export only.
- Provide **provisional checks** during capture, with a **hard block** for unit availability.
- Maintain **no overlap** rule.
- Default to **basic (no PHI) export**; enable PHI only via secure gated flow.
- Do not log PHI; logs must use **error codes + correlation IDs**.

