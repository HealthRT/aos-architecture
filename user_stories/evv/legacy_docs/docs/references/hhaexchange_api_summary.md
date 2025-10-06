# HHAeXchange EVV API Specification Summary

_This document summarizes the key technical details from the HHAeXchange EVV API PDF specification (Version X.X, dated YYYY-MM-DD)._

## 1. High-Level Workflow

-   **Objective**: Facilitate the integration of third-party Electronic Visit Verification (EVV) systems with HHAeXchange to ensure compliance with the 21st Century Cures Act.
-   **Sequence**: 
    1.  Authenticate to obtain an access token.
    2.  Submit visit data using the appropriate API endpoint.
    3.  Monitor the processing status of submitted visits.

## 2. Authentication

-   **Method**: OAuth 2.0
-   **Credentials Required**: `client_id` and `client_secret`
-   **Token Endpoint**: `POST /oauth/token`
-   **Token Lifetime**: Tokens are valid for a specified duration; refer to the API documentation for exact timeframes.

## 3. Key Endpoints

List the primary API endpoints relevant to sending EVV data.

-   **Endpoint**: `POST /visits`
    -   **Description**: Submits a new visit record.
-   **Endpoint**: `PUT /visits/{visitId}`
    -   **Description**: Updates an existing visit record.
-   **Endpoint**: `GET /visits/{visitId}/status`
    -   **Description**: Checks the processing status of a submitted visit.

## 4. Data Payload: Visit Submission

This is the most critical section. Please detail the JSON/XML structure required to submit a visit.

```json
{
  "providerId": "string",
  "patientId": "string",
  "employeeId": "string",
  "visitStartTime": "ISO 8601 datetime",
  "visitEndTime": "ISO 8601 datetime",
  "timezone": "string (e.g., America/New_York)",
  "serviceLines": [
    {
      "serviceCode": "string",
      "startTime": "ISO 8601 datetime",
      "endTime": "ISO 8601 datetime",
      "units": "decimal"
    }
  ],
  "notes": "string"
}
```

## 5. Key Field Mapping Analysis

Provide an initial analysis of how our Odoo models map to their payload.

| Our Odoo Model (`Field`)          | HHAeXchange Field  | Data Type / Format Note                     |
| :-------------------------------- | :----------------- | :------------------------------------------ |
| `evv.visit` (`dsp_external_id`)   | `employeeId`       | `string`                                    |
| `evv.visit` (`client_external_id`)| `patientId`        | `string`                                    |
| `evv.visit.segment` (`start_time`)| `serviceLines.startTime` | ISO 8601 UTC Datetime                     |
| `evv.visit.segment` (`end_time`)  | `serviceLines.endTime`   | ISO 8601 UTC Datetime                     |
| `evv.visit.segment` (`service_code`)| `serviceLines.serviceCode`| `string`                                    |
| `evv.visit.segment` (`units_billed`)|`serviceLines.units`| `decimal`                                   |

## 6. Error Handling

-   **Success Codes**: 
    - `200 OK`: Request was successful.
    - `202 Accepted`: Request has been accepted for processing.
-   **Error Codes**: 
    - `400 Bad Request`: The server could not understand the request due to invalid syntax.
    - `401 Unauthorized`: Authentication is required and has failed or has not been provided.
    - `422 Unprocessable Entity`: The request was well-formed but was unable to be followed due to semantic errors.
-   **Error Response Body**: Show an example of what an error response looks like.

```json
{
  "errorCode": "INVALID_PATIENT_ID",
  "message": "The provided Patient ID does not exist.",
  "correlationId": "abc-123-xyz-456"
}
```
