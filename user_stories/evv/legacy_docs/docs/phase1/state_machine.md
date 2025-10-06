# Timecard State Machine

_This document defines the lifecycle of a `visit` record and the rules governing its state transitions._

## 1. States

A visit can exist in one of the following states:

| State              | Description                                                                 |
| :----------------- | :-------------------------------------------------------------------------- |
| `draft`            | The visit has been created but not yet submitted for approval.              |
| `pending_approval` | The visit has been submitted by a DSP and is awaiting supervisor review.    |
| `approved`         | The visit has been approved by a supervisor and is ready for billing.       |
| `rejected`         | The visit was rejected by a supervisor and sent back for correction.        |
| `submitted`        | The visit has been included in a claim batch and submitted to a payer.      |
| `paid`             | The payer has confirmed payment for the visit.                              |
| `denied`           | The payer has denied the claim for the visit.                               |

## 2. State Transitions & Rules

The following table defines the only valid transitions between states. Any attempt to move a record between states in a way not defined here must be blocked by the system.

| From State         | To State           | Triggering Action            | User Role Required     | Rules & Conditions                                                                    |
| :----------------- | :----------------- | :--------------------------- | :--------------------- | :------------------------------------------------------------------------------------ |
| `(new)`            | `draft`            | DSP starts a visit           | `DSP`                  | -                                                                                     |
| `draft`            | `pending_approval` | DSP submits their timecard   | `DSP` or `Delegate`    | -                                                                                     |
| `pending_approval` | `approved`         | Supervisor approves visit    | `Designated Coordinator` | - All validations must pass.                                                          |
| `pending_approval` | `rejected`         | Supervisor rejects visit     | `Designated Coordinator` | - A `rejection_reason` must be provided.                                              |
| `rejected`         | `draft`            | Supervisor corrects the data | `Designated Coordinator` | - After correction, the record returns to `draft` before re-submission.             |
| `approved`         | `submitted`        | Included in a billing batch  | `Billing Manager`      | -                                                                                     |
| `submitted`        | `paid`             | Payer confirms payment (835) | `System` / `Billing`   | -                                                                                     |
| `submitted`        | `denied`           | Payer denies claim (835)     | `System` / `Billing`   | -                                                                                     |

## 3. Immutability

-   **Once a visit is in the `approved` state, it becomes immutable.** No further edits to its core data (times, services, client, DSP) are allowed. If a correction is needed after approval, a formal reversal or adjustment process must be followed (post-MVP feature).
-   **Edits are only permitted on records in the `draft` or `rejected` state** by users with the appropriate permissions.
