# Story ID: `ADMIN-003`
- **Scope:** MVP
- **Avatar:** Administrator
- **User Story:** As an Administrator, I want to define which user roles have permission to create "Company-Level" Rocks, so that I can ensure our highest-level priorities are set and managed only by the leadership team.

### Workflow
The Administrator navigates to the main Odoo `Settings` application to manage access rights. They create or modify a user group, granting it a new, specific permission called "Traction Leadership."

When a user who belongs to the "Traction Leadership" group creates or edits a Rock, they will see a checkbox or toggle labeled "Company Rock." They can set this flag to elevate the Rock's visibility.

A regular user, who is not in the "Traction Leadership" group, will not see the "Company Rock" checkbox in the UI. Any attempt to bypass the UI and set the flag via the API will be blocked by the system's security rules, resulting in an access error.

### Automations & Triggers
- **Security Rule Enforcement:** The system will automatically enforce a record rule upon any `create` or `write` operation on a Rock record. If the "Company Rock" flag is set to `True`, the rule will check if the current user is in the "Traction Leadership" group. If the check fails, the transaction is blocked.

### Acceptance Criteria

#### Backend Acceptance Criteria
1. A new boolean field (e.g., `is_company_rock`) is added to the `traction.rock` model.
2. A new security group, `traction.group_leadership`, is defined within the Traction module's security files.
3. An `ir.rule` (Record Rule) is created that restricts `create` and `write` permissions for any `traction.rock` record where `is_company_rock` is `True` to members of the `traction.group_leadership` group.
4. The rule must successfully prevent a non-leadership user from creating or editing a Rock to be a "Company Rock."

#### UI Acceptance Criteria
1. In the form view for a `traction.rock` record, the "Company Rock" field is only visible if the current user is a member of the `traction.group_leadership` group. This must be implemented using the `groups` attribute in the XML view definition.
2. A menu item to manage Traction-specific settings (if any) is available in the main `Settings` application and is only visible to users with administrative privileges.
3. The UI respects all principles in `02-ui-ux-and-security-principles.md`.

#### UAT Acceptance Criteria
1. I can, as an Administrator, assign a user to the "Traction Leadership" group.
2. I can, as the newly assigned user, create a new Rock, see the "Company Rock" checkbox, check it, and save the record successfully.
3. I can, as a standard user *not* in the leadership group, create or edit a Rock and confirm that I cannot see the "Company Rock" option.
