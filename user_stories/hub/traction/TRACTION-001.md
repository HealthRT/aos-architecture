# Story ID: `TRACTION-001`
- **Scope:** MVP
- **Avatar:** Manager
- **User Story:** As a Manager, I want to see a larger notes area with a clear meeting context, so that I can capture detailed notes more efficiently during our L10 meetings.

### Workflow
While participating in an L10 Meeting, the user clicks the "Notes" button to open the meeting notes editor. A modal window appears. This modal is significantly taller than the standard Odoo modal, providing a much larger text area that reduces the need for scrolling.

The title of the modal window dynamically includes the name of the current meeting, for example, "Meeting Notes: Leadership Team Weekly L10 - 2025-10-09". This provides immediate context to the user, confirming they are editing notes for the correct session. The user then proceeds to add or edit notes and saves their changes.

### Automations & Triggers
- **Dynamic Title Population:** When the notes modal is invoked, the system fetches the `display_name` of the parent L10 meeting record and passes it to the modal's view context to render the dynamic title.

### Acceptance Criteria

#### Backend Acceptance Criteria
1. The Python method that launches the notes modal view must be modified to read the `display_name` of the current `traction.l10.meeting` record.
2. The meeting's `display_name` must be added to the action's `context` so it is available to the client-side view for rendering the title.

#### UI Acceptance Criteria
1. The modal window containing the notes field must have its height increased to be approximately three times taller than the default Odoo modal height. This should be achieved by adding a custom CSS class to the modal.
2. The title of the notes modal must display in the format: "Meeting Notes: [Meeting Display Name]", where "[Meeting Display Name]" is the dynamic name of the L10 meeting record.
3. The increased height must not be a fixed pixel value but should use responsive units (like `vh`) or properties (`min-height`) to ensure it adapts gracefully to different screen sizes.
4. The UI must adhere to all principles in `02-ui-ux-and-security-principles.md`.

#### UAT Acceptance Criteria
1. I can open an L10 meeting record named "Q4 Leadership Sync".
2. I can click the "Notes" button.
3. I can confirm the modal that appears is significantly taller than a standard notes modal.
4. I can confirm the title of the modal reads exactly "Meeting Notes: Q4 Leadership Sync".
