# Data Integrity & Business Logic Rules

_This document specifies key business logic and data integrity rules that apply across different data models in the system._

## 1. Service Agreement (`service.agreement`)

| Rule                               | Error Code                     | Trigger                      | Logic                                                                                                  |
| :--------------------------------- | :----------------------------- | :--------------------------- | :----------------------------------------------------------------------------------------------------- |
| **Must have a Patient**            | `SA_MISSING_PATIENT`           | On Create / On Update        | The `patient_id` field cannot be null or empty.                                                        |
| **Patient Demographics Complete**  | `PATIENT_DEMOGRAPHICS_INCOMPLETE`| On Status Change to "Approved" | Before an agreement can be approved, the linked `patient` record must have a valid `date_of_birth` and `mrn` (Medical Record Number). |
| **No Overlapping Agreements**      | `SA_OVERLAPPING_AGREEMENT`     | On Create / On Update        | An active agreement's date range for a specific `service_code` cannot overlap with another active agreement for the same `patient`. |

## 2. Visit (`evv.visit`)

| Rule                            | Error Code                   | Trigger               | Logic                                                                                             |
| :------------------------------ | :--------------------------- | :-------------------- | :------------------------------------------------------------------------------------------------ |
| **Must have a Patient**         | `VISIT_MISSING_PATIENT`      | On Create             | The `patient_id` field cannot be null or empty.                                                   |
| **Patient Matches Agreement**   | `VISIT_PATIENT_MISMATCH`     | On Create / On Update | The `visit.patient_id` must be the same as the `service_agreement.patient_id` it is linked to. |
| **Site Matches Agreement**      | `VISIT_SITE_MISMATCH`        | On Create / On Update | The `visit.site_id` must match the `service_agreement.site_id`.                                                |

## 3. DSP Assignment (`dsp.assignment`)

| Rule                                    | Error Code                   | Trigger               | Logic                                                                                             |
| :-------------------------------------- | :--------------------------- | :-------------------- | :------------------------------------------------------------------------------------------------ |
| **No Overlapping Assignments**          | `ASSIGNMENT_OVERLAP`         | On Create / On Update | An assignment's time window cannot overlap with another assignment for the same DSP and `service_agreement`. |
| **Visit within Assignment Window**      | `VISIT_OUTSIDE_ASSIGNMENT`   | On Visit Create       | The visit's timestamps must fall within the start and end of a valid `dsp.assignment` record.      |
