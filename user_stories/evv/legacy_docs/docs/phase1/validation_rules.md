# EVV MVP Timecard Validation Rules

This document specifies the authoritative, server-side validation logic applied when a timecard (visit) is submitted for approval or processed for billing.

---

## 1. Service Agreement Validation

These rules ensure the visit is authorized by a valid service agreement.

| Rule                      | Error Code                 | Logic                                                                                                                              |
| :------------------------ | :------------------------- | :--------------------------------------------------------------------------------------------------------------------------------- |
| **Agreement Existence**   | `SA_NOT_FOUND`             | Every visit must be linked to a `service_agreement` record.                                                                        |
| **Agreement Status**      | `SA_NOT_ACTIVE`            | The linked `service_agreement.status` must be "Approved". Visits against "Draft" or "Cancelled" agreements are rejected.           |
| **Date Range**            | `VISIT_OUTSIDE_PLAN_DATES` | The visit's `start_time` must be **>=** `service_agreement.plan_start` and the visit's `end_time` must be **<** `service_agreement.plan_end`. |
| **Approved Service**      | `SERVICE_NOT_IN_AGREEMENT` | The `visit.service_code` must exist within the list of `service_agreement.approved_services`.                                      |
| **Provider Match**        | `PROVIDER_NOT_IN_AGREEMENT`| The `visit.dsp_id` must match the `provider_id` specified on the `service_agreement`.                                              |
| **Agreement Signed**      | `SA_NOT_SIGNED`            | The `service_agreement.signed_date` must not be null.                                                                              |

## 2. Unit & Cap Validation

These rules ensure the visit does not exceed the authorized units.

| Rule                      | Error Code                 | Logic                                                                                                                              |
| :------------------------ | :------------------------- | :--------------------------------------------------------------------------------------------------------------------------------- |
| **Unit Limit Enforcement**| `EXCEEDS_UNIT_LIMIT`       | On create or update, the system calculates the cumulative units consumed for the period (e.g., month). If the new visit's units would cause the total to exceed the `service_agreement.unit_limit`, the operation is blocked. |

## 3. Visit Integrity Validation

These rules ensure the visit data itself is logical and complete.

| Rule                      | Error Code                 | Logic                                                                                                                              |
| :------------------------ | :------------------------- | :--------------------------------------------------------------------------------------------------------------------------------- |
| **No Overlapping Segments**| `VISIT_CONFLICT_OVERLAP`   | The `start_time` and `end_time` for a visit segment cannot overlap with any other existing segments for that same DSP.               |
| **Valid Duration**        | `VISIT_INVALID_DURATION`   | The `end_time` of a visit must be after its `start_time`.                                                                          |
| **Geo-Fence**             | `VISIT_OUTSIDE_GEOFENCE`   | If `service_agreement.geo_fence` is defined, the `visit.location` must be within the approved geographical area.                   |
| **Active Patient**        | `PATIENT_NOT_ACTIVE`       | The `patient.status` must be "Active" at the time of the visit.                                                                    |
| **Valid DSP Credentials** | `DSP_CREDENTIALS_EXPIRED`  | The `dsp.background_check_date` must be within the last 2 years.                                                                   |
| **Late Entry Lockout**    | `VISIT_ENTRY_TOO_LATE`     | A visit cannot be created if its `date_of_service` is more than 7 days in the past (configurable).                                 |

---

For a detailed list of all error codes and their meanings, see `contracts/errors.md`.
