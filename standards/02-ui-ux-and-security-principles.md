# 2. UI/UX and Security Principles

**Status:** Accepted

## 1. Guiding Principles

- **Simplicity and Clarity:** The UI must be intuitive and easy to use. We prioritize clarity over feature density.
- **Role-Based Design:** The interface must be tailored to the user's specific role. A mobile care worker has different needs than a back-office administrator. Layouts, data, and actions should be contextual.
- **Mobile-First:** All interfaces must be designed for small screens first and then scaled up. This ensures the core experience is optimized for the most common use cases.

## 2. Accessibility (WCAG 2.1 AA)

All applications must be accessible to users with disabilities. We will target WCAG 2.1 Level AA compliance as a mandatory requirement.

-   **Focus Order**: All interactive elements must have a logical and intuitive focus order that is testable with keyboard-only navigation.
-   **ARIA Roles**: Use appropriate ARIA (Accessible Rich Internet Applications) roles and attributes to describe the function of custom components (e.g., `role="button"`, `aria-label`).
-   **Color Contrast**: All text must have a minimum contrast ratio of 4.5:1 against its background to be readable.
-   **Large Hit Targets**: All buttons, links, and other interactive controls must have a minimum target size of 44x44 CSS pixels to be easily usable on touch devices.

## 3. Security & Data Handling (HIPAA)

Protecting user and patient data is a critical requirement. The following technical safeguards must be implemented in all applications.

-   **Access Control (RBAC)**: Odoo's built-in Access Control Lists (`ir.model.access.csv`) and Record Rules are the **sole** mechanisms for enforcing the principle of least privilege.
-   **No Superuser Logic**: Code must never contain special logic for the admin user (`uid == SUPERUSER_ID`). All functionality must be accessible to non-admin users who have the correct permissions.
-   **Audit Trails**: All significant actions, especially those related to billing or data changes, must generate a clear and detailed audit trail.
-   **No PHI in Logs**: Application and server logs must **never** contain Protected Health Information (PHI) or any other sensitive user data.
-   **Content Security Policy (CSP)**: To mitigate XSS risks, a strict CSP must be enforced. The default policy should be `script-src 'self'`, disallowing all external scripts.

## 4. Performance

The application must be performant, especially on mobile devices with potentially slow network connections.

-   **Time to Interactive (TTI)**: Target < 5 seconds on a simulated 3G network.
-   **Asset Sizes**: Total JavaScript bundle size should be < 250KB gzipped.
-   **Batching for Large Datasets**: Any process that handles a large number of records (e.g., data exports) must use batching and pagination to ensure reliability and prevent timeouts.
