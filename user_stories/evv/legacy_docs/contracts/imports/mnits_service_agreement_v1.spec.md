# MN-ITS Service Agreement Import File Specification v1

_This document outlines the structure and requirements for the MN-ITS Service Agreement Import File._

## 1. File Format

-   **Format**: Comma-Separated Values (CSV)
-   **Encoding**: UTF-8
-   **Delimiter**: Comma (`,`)
-   **Text Qualifier**: Double quotes (`"`)
-   **Header Row**: The first row must contain the exact column headers specified in the section below.

## 2. Guiding Principles

-   **One Row Per Agreement**: Each row represents a complete service agreement or a significant amendment.
-   **Data Integrity**: All required fields must be populated. The `End Date` must not be earlier than the `Start Date`.

## 3. Field Specifications

| Column Name             | Type      | Required | Description                                                    | Example                 |
| :---------------------- | :-------- | :------- | :------------------------------------------------------------- | :---------------------- |
| `ServiceAgreementID`    | `string`  | Yes      | Unique identifier for the service agreement.                   | `SA12345`               |
| `ClientID`              | `string`  | Yes      | Unique identifier for the client.                              | `CL67890`               |
| `ServiceCode`           | `string`  | Yes      | Code representing the type of service provided.                | `SC001`                 |
| `StartDate`             | `date`    | Yes      | The date the service agreement begins, in `YYYY-MM-DD` format. | `2025-01-01`            |
| `EndDate`               | `date`    | Yes      | The date the service agreement ends, in `YYYY-MM-DD` format.   | `2025-12-31`            |
| `AuthorizedUnits`       | `integer` | Yes      | Total number of service units authorized.                      | `100`                   |
| `UnitType`              | `string`  | Yes      | The unit of measure (e.g., `hours`, `days`, `visits`).         | `hours`                 |
| `RatePerUnit`           | `decimal` | Yes      | The monetary rate per service unit.                            | `50.00`                 |
| `TotalAuthorizedAmount` | `decimal` | Yes      | Total monetary amount authorized for the agreement.            | `5000.00`               |
| `ServiceProviderID`     | `string`  | Yes      | Unique identifier for the service provider agency.             | `SP45678`               |
| `ServiceLocation`       | `string`  | No       | Location or address where the service is provided.             | `Main Facility`         |
| `FundingSource`         | `string`  | Yes      | The source of funding for the agreement.                       | `State Funding`         |
| `Comments`              | `string`  | No       | Additional notes or comments.                                  | `Initial authorization` |

## 4. Business Rules & Assumptions

-   **Date Formatting**: All date fields must strictly adhere to the `YYYY-MM-DD` format.
-   **Numeric Fields**: `AuthorizedUnits` must be a positive integer. `RatePerUnit` and `TotalAuthorizedAmount` must be valid decimals with up to two decimal places.
-   **Validation**: Records with missing required fields will be rejected during import.
-   **Idempotency**: Importing a file with the same `ServiceAgreementID` as an existing record should be treated as an update.

## 5. Sample Record

Here is an example of a single, correctly formatted CSV record.

```csv
ServiceAgreementID,ClientID,ServiceCode,StartDate,EndDate,AuthorizedUnits,UnitType,RatePerUnit,TotalAuthorizedAmount,ServiceProviderID,ServiceLocation,FundingSource,Comments
"SA12345","CL67890","SC001","2025-01-01","2025-12-31",100,"hours",50.00,5000.00,"SP45678","Main Facility","State Funding","Initial agreement for 2025 services."
```
