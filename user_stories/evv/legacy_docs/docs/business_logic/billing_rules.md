# MHCP Billing & Business Rules

_This document summarizes the key billing and business logic derived from the Minnesota Health Care Programs (MHCP) Provider Manual, specifically for 245D Home and Community-Based Services (HCBS). This is the source of truth for our system's billing engine._

## 1. Unit of Service & Rounding

-   **Standard Unit**: For most HCBS waiver services, the standard unit of service is **15 minutes**.
-   **Rounding Rule**: MHCP uses the **"8-Minute Rule"** for rounding. To bill one 15-minute unit, the provider must deliver at least **8 minutes** of service.
    -   1 Unit: 8 to 22 minutes
    -   2 Units: 23 to 37 minutes
    -   3 Units: 38 to 52 minutes
    -   4 Units (1 hour): 53 to 67 minutes
    -   *Our system's billing engine must precisely follow this rounding logic.*
    -   *Visits resulting in zero billable units should not be included on a claim.*

## 2. Billing Limitations & Non-Billable Time

-   **Provider Travel**: Travel time is **not billable**. The clock for a billable segment starts when the DSP arrives at the service location and begins providing service.
-   **Documentation Time**: Time spent on documentation is **not separately billable**. It is considered part of the overall service delivery and is included in the rate for the primary service.
-   **Sleep Time**: For overnight shifts, up to **8 hours** of sleep time can be billed, but it must be explicitly authorized in the client's Coordinated Service and Support Plan (CSSP).

## 3. Required Billing Modifiers

| Service Category      | Modifier | Description                                                              |
| :-------------------- | :------- | :----------------------------------------------------------------------- |
| Shared Staffing       | `U1`     | Used when a single DSP serves more than one client in the same setting.  |
| Group Services        | `HQ`     | Used for services provided in a group setting.                           |
| Remote Services       | `GT`     | Used when services are delivered via telehealth/remote communication.    |
| Night Supervision     | `U2`     | Used for overnight shifts that include sleep time.                       |

## 4. EVV-Specific Billing Requirements

-   **Visit Verification**: Claims for services that require EVV must be supported by a verified visit record. Claims submitted without a matching, compliant EVV record will be denied.
-   **Missing Data**: A claim will be denied if the EVV record is missing any of the six federally required data points (Service, Client, DSP, Date, Time In/Out, Location).

## 5. Claim Data Requirements

_Based on the MN DHS 837P Companion Guide, the following data points must be present and valid on any electronic claim submission._

-   **Place of Service (POS) Code**: All claims for services delivered in the home must use POS Code **`12`**.
-   **Rendering Provider NPI**: The claim must include the valid National Provider Identifier (NPI) of the DSP who delivered the service.
-   **Billing Provider Info**: The claim must include the complete information for the agency, including NPI, Tax ID, and address.
-   **Client & Payer IDs**: The claim must include the client's Medicaid ID and the correct MHCP Payer ID.

---
_This document is a summary and should be used in conjunction with the official, most current MHCP Provider Manual._
