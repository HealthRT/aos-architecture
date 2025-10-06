# Minnesota 245D HCBS Program Summary

_This document summarizes key requirements from the Minnesota 245D Home and Community-Based Services (HCBS) standards, relevant to the implementation of our EVV system._

## 1. Core Principles & Definitions

-   **Key Terms**:
    -   **Coordinated Service and Support Plan (CSSP)**: This is the primary plan developed by the case manager that identifies the person's support needs and the services to meet them. Our system must align with the services authorized in this plan.
    -   **Direct Support Professional (DSP)**: An employee of the license holder who provides direct services to a person. The system must track service delivery at the individual DSP level.
    -   **Unit of Service**: The statute does not provide a universal, minute-based definition (e.g., "15 minutes"). Instead, it states that the unit of service for billing must be based on the service authorization from the lead agency (county). This means our system's rounding and unit calculation logic must be configurable based on specific payer rules.
    -   **Service Termination**: The statute outlines a formal process for terminating services. While not directly an EVV function, our system should be able to flag or deactivate services for clients whose services have been formally terminated.

-   **Provider Qualifications**:
    -   **Training**: DSPs must complete orientation and annual training on topics including the service recipient's rights, the CSSP, and data privacy. The system should ideally have a way to track DSP training compliance.
    -   **Background Checks**: All staff with direct contact must pass a background study. This is a critical flag to have at the DSP record level.

## 2. Service-Specific Requirements

-   **Service Codes**: Chapter 245D applies broadly to all HCBS waiver services. It does not list specific billing codes but rather the standards that apply to services like **Intensive Support Services**, **Basic Support Services**, and **In-Home Support Services**. The specific service codes are determined by the lead agency and authorized in the CSSP.
-   **Unit of Service Definition**: As noted above, there is no single definition. It is determined by the lead agency's service authorization. This is a critical business rule: **our system cannot hard-code a 15-minute unit rule** and must be flexible.
-   **Documentation Requirements**: This is a critical section. For each service delivered, the record must include:
    -   The **name of the person served**.
    -   The **date of service**.
    -   The **start and end time of the service**.
    -   The **location where the service was provided**.
    -   The **name of the staff member** who provided the service.
    -   A **description of the service provided**, including activities performed and the person's response.
    -   Information about **progress towards the goals** outlined in the Coordinated Service and Support Plan (CSSP).
    -   Any **incidents or emergencies** that occurred.

## 3. Billing & Claims Requirements

-   **Billing Limitations**: The statute does not detail specific billing limitations (like travel time), as these are typically defined by the lead agency (county) and the specific waiver program. However, it requires that billing must be for services that are **authorized in the CSSP** and **actually provided**. Our system must have strong validation to prevent billing for services that don't have a corresponding documented visit.
-   **Required Modifiers**: The 245D statute itself does not list specific billing code modifiers. These are determined by the Minnesota Department of Human Services (DHS) billing guidelines for specific services and waiver programs.

## 4. Record-Keeping & Auditing

-   **Record Retention Policy**: All records related to service delivery, including those captured by the EVV system, must be retained for a minimum of **five years** from the date of service.
-   **Audit Requirements**: To prove compliance, auditors will primarily look for:
    -   **Service Authorization**: Proof that a valid Coordinated Service and Support Plan (CSSP) was in place authorizing the service at the time it was delivered.
    -   **Service Delivery Documentation**: The service record must contain all the elements listed in the "Documentation Requirements" section above (date, time, location, staff, description, etc.).
    -   **Staff Qualifications**: Evidence that the DSP who delivered the service met all training and background check requirements.
    -   **Data Privacy**: Proof that service recipient records are kept confidential and secure.

---
