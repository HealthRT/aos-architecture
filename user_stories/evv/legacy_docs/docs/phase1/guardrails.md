# EVV MVP Guardrails

This document defines the key technical and compliance guardrails for the EVV MVP project. All development, including AI-assisted coding, must adhere to these standards.

## 1. Accessibility (ADA)

The application must be accessible to users with disabilities. We will target WCAG 2.1 Level AA compliance.

-   **Focus Order**: Logical and intuitive focus order for all interactive elements is mandatory. Test with keyboard navigation only.
-   **ARIA Roles**: Use appropriate ARIA (Accessible Rich Internet Applications) roles and attributes to describe custom components (e.g., `role="button"`, `aria-label`).
-   **Color Contrast**: All text must have a minimum contrast ratio of 4.5:1 against its background.
-   **Large Hit Targets**: All buttons, links, and other interactive controls must have a minimum target size of 44x44 CSS pixels.

## 2. Security (HIPAA & CSP)

### HIPAA (Health Insurance Portability and Accountability Act)

Protecting Patient Health Information (PHI) is a critical requirement. The following technical safeguards, aligned with HIPAA standards, must be implemented.

**1. Access Control**
-   **Role-Based Access Control (RBAC)**: Odoo's built-in Access Control Lists (`ir.model.access.csv`) and Record Rules must be the sole mechanism for enforcing the principle of least privilege.
-   **No Superuser Checks**: As defined in `CODING_STANDARDS.md`, code must never contain special logic for the admin user. Permissions must be managed exclusively through security groups.

**2. Audit Controls**
-   **No PHI in Standard Logs**: Application and server logs must never contain PHI.
-   **Correlation IDs**: All log entries for a single request/transaction must be tagged with a unique `correlation_id`.
-   **PHI Access Logging**: Key models containing PHI (e.g., `evv.visit`) must be extended to create an immutable audit trail. This can be achieved using Odoo's `mail.message` (chatter) functionality to automatically log creations and modifications.
-   **Billing Audit Trail**: All billing-related actions must generate a detailed, immutable log. This includes visit approvals, corrections, export events, and any changes to a claim's status. The log must record the user who performed the action, the timestamp, and what data was changed.
-   **Suspicious Activity Alerts**: A scheduled action must be configured to monitor for and report on suspicious access patterns (e.g., a single user accessing an unusually high number of distinct client records in a short period).

**3. Data Security**
-   **Encryption at Rest (File Storage)**: Any PHI-containing documents or attachments (`ir.attachment`) must not be stored directly in the database. They must be stored in an encrypted external file store, such as AWS S3 with Server-Side Encryption enabled.
-   **Encrypted Backups**: Daily database and filestore backups must be encrypted using a tool like Duplicity or Restic and stored securely in a separate geographical location from the Odoo host.

**4. Authentication & Session Management**
-   **Strong Passwords & 2FA**: All user accounts must enforce strong password policies. Two-Factor Authentication (2FA) is mandatory.
-   **Session Timeout**: The system must enforce an automatic session timeout after a short period of inactivity (e.g., 15 minutes) to prevent unauthorized access from unattended workstations.

**5. System & Infrastructure Hardening**
-   **Patch Management**: The underlying server operating system must be configured for automatic security updates.
-   **Firewall**: A host-based firewall (e.g., UFW) must be enabled and configured to only allow traffic on necessary ports (e.g., 80, 443).
-   **Intrusion Prevention**: A tool such as `fail2ban` must be configured to monitor logs and automatically block IPs that exhibit malicious behavior (e.g., repeated failed login attempts).

### PHI Export Policy

The `phi` CSV export profile contains highly sensitive data and must be handled with extreme care. This feature is intended only for manual, internal use cases like auditing and reconciliation.

-   **Manual Process**: Exporting PHI is a manual action gated by specific user roles and MFA. It is not an automated process.
-   **Workstation Security**: The user downloading the file is responsible for ensuring the security of the workstation (e.g., disk encryption, up-to-date antivirus, locked screen).
-   **No-Store Headers**: The server response for the file download will include `Cache-Control: no-store` and `Pragma: no-cache` headers to prevent intermediate caching.
-   **Immediate Deletion**: The downloaded file must be deleted from the workstation immediately after its intended use is complete.

### CSP (Content Security Policy)

To mitigate the risk of cross-site scripting (XSS) and other injection attacks, a strict Content Security Policy will be enforced.

-   **No External Scripts/Fonts**: The policy will disallow loading scripts, styles, or fonts from any external domains. All assets must be hosted within the Odoo instance.
-   **Policy Definition**: The `Content-Security-Policy` HTTP header should be configured to `self`. Example: `script-src 'self'; style-src 'self'; font-src 'self';`.

## 3. User Experience (UX)

-   **Role-Based UI**: The User Interface (UI) must be designed contextually for the user's role. A Direct Support Professional (DSP) using the mobile app has different needs and priorities than a Supervisor or Billing Manager using the back-office interface. Layouts, data density, and available actions should be tailored to the specific "avatar" or role.

## 4. Performance

The application must be performant, especially on mobile devices with potentially slow network connections.

-   **Mobile-First Design**: The user interface must be designed for small screens first and then scaled up for larger devices. This ensures the core experience is optimized for the primary user (DSP).
-   **Offline-First Capability**: The mobile app must remain functional when network connectivity is lost. Odoo's PWA capabilities, combined with service workers and local storage (e.g., IndexedDB), will be used to cache application data and sync it back to the server when the connection is restored.
-   **Performance Budgets**:
    -   **Time to Interactive (TTI)**: < 5 seconds on a simulated 3G network.
    -   **Asset Sizes**: Total JavaScript bundle size < 250KB gzipped.

## 5. AI Development Self-Check

Any AI-generated code or documentation must be reviewed against the following checklist by the developer before committing.

> ```
> [ ] **Compliance**: Does this output adhere to all ADA, HIPAA, and CSP guardrails?
> [ ] **No PHI**: Have I verified that no PHI is present in logs, comments, or user-facing error messages?
> [ ] **Performance**: Does this code respect the mobile-first and offline-first performance budgets?
> [ ] **Idiomatic Code**: Is the code consistent with Odoo development best practices?
> [ ] **Clarity**: Is the code easy to understand and maintain?
> ```
