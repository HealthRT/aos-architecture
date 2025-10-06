# EVV Service Configuration Matrix

This document defines the template for service-specific billing rules. The values in this table will be configurable within Odoo and are critical for accurate unit calculation and validation.

**Note**: The initial values below are placeholders. Most require input from Subject Matter Experts (SMEs).

| Service Code | Description               | Cap Window  | Carryover Allowed? | Rounding Mode      | Min Billable Minutes | Combine Adjacent? |
| :----------- | :------------------------ | :---------- | :----------------- | :----------------- | :------------------- | :---------------- |
| `S5125`      | Personal Care             | `daily`     | `false`            | `nearest_15_min`   | `8`                  | `true`            |
| `S5130`      | Homemaker Services        | `weekly`    | `false`            | `nearest_15_min`   | `8`                  | `false`           |
| `T1019`      | Respite Care              | `auth_span` | `true`             | `nearest_15_min`   | `15`                 | `false`           |
| `H0004`      | Behavioral Health         | `daily`     | `false`            | `exact_minutes`    | `1`                  | `false`           |
| `G0156`      | Skilled Nursing           | `monthly`   | **TODO: SME Input** | **TODO: SME Input** | **TODO: SME Input**  | **TODO: SME Input** |
| `T2025`      | Community Integration     | `weekly`    | **TODO: SME Input** | `nearest_15_min`   | `8`                  | `true`            |

### Column Definitions

-   **Service Code**: The official billing code for the service (e.g., from `product.product` in Odoo).
-   **Description**: A human-readable name for the service.
-   **Cap Window**: The time period over which unit caps are enforced.
    -   `daily`: Midnight to midnight. (**TODO**: Confirm this definition).
    -   `weekly`: Sunday to Saturday. (**TODO**: Confirm this definition).
    -   `monthly`: First to last day of the calendar month.
    -   `auth_span`: The entire duration of the `service.agreement`.
-   **Carryover Allowed?**: If `true`, unused units from one period can be used in the next (e.g., unused units from this week can be used next week). Typically `false`.
-   **Rounding Mode**: The rule for converting raw minutes to billable units.
    -   `nearest_15_min`: Standard rounding. 1-7 mins = 0 units, 8-22 mins = 1 unit, 23-37 mins = 2 units, etc.
    -   `exact_minutes`: Units are calculated based on the exact minute count (less common for EVV).
-   **Min Billable Minutes**: The minimum number of minutes a segment must have to be considered for billing. Segments below this are flagged or ignored.
-   **Combine Adjacent?**: If `true`, adjacent segments with the same service code within the same visit are combined *before* rounding is applied. This is a critical policy decision. See `risks.md` for more detail.

### System-Wide Configuration Flags

These settings apply globally and are not service-specific.

-   `ALLOW_NONBILLABLE_CAPTURE`
    -   **MVP Value**: `false`
    -   **Description**: If set to `true`, this flag would allow the UI to offer a "Record as non-billable" option when a DSP is blocked due to `EVV_NO_UNITS_AVAILABLE`. This would create a segment that is excluded from exports and does not consume units. This feature is a safety valve for future use and is **not** enabled for the MVP.

### Agency-Wide Validation Thresholds

To prevent false positives and provide flexibility, certain validation rules should have configurable thresholds. These are not service-specific but apply to the entire agency.

| Setting                        | Description                                                                                             | MVP Default Value |
| :----------------------------- | :------------------------------------------------------------------------------------------------------ | :---------------- |
| `validation.threshold.minutes` | The number of minutes a visit can go over a cap before being flagged as ineligible (e.g., a "grace period"). | `0`               |

### Payer-Specific Configuration

These settings will be configurable on a per-payer or trading partner basis to handle different billing rules.

| Setting                        | Description                                                                                             | MVP Default Value |
| :----------------------------- | :------------------------------------------------------------------------------------------------------ | :---------------- |
| `payer.timely_filing_days`     | The maximum number of days after the date of service that a claim can be submitted.                     | `180`             |
| `payer.eligibility_window_days`| The number of days a client's eligibility is considered valid before requiring a re-check.              | `120`             |
