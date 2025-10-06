# Story ID: `ADMIN-001`
- **Avatar:** Administrator
- **User Story:** As an Administrator, I want to create and manage onboarding templates, so that I can define different, repeatable onboarding checklists for different job roles.

### Workflow
The admin navigates to the Compliance section, opens 'Onboarding Templates', and creates a new template. They give it a name (e.g., 'DSP Onboarding') and add/remove required compliance items (like 'CPR Certification') from a master list of all possible 'Document Types'.

### Automations & Triggers
This is a configuration task, so no major automation. However, changes to a template should not affect employees whose onboarding is already in progress.

### Acceptance Criteria

#### Backend Acceptance Criteria
1. A `compliance.onboarding.template` model exists with a `name` field and a many-to-many relationship to the `compliance.document.type` model. 
2. Standard Odoo CRUD (Create, Read, Update, Delete) functionality is enabled. 
3. The system ensures that editing a template does not alter existing `compliance.onboarding.process` records that were created from that template.

#### UI Acceptance Criteria
1. A menu item 'Onboarding Templates' is available within the main 'Compliance' app. 
2. The form view for a template has a text field for the name and a list-based or tag-based widget for adding/removing `document.type` records. 
3. The view is protected by appropriate access rights, accessible only to the compliance admin/manager group.

#### UAT Acceptance Criteria
1. I can successfully create a new template named 'DSP Onboarding'. 
2. I can add the 'CPR Certification' and 'Driver's License' requirements to this template and save it. 
3. I can later edit the template to remove 'Driver's License' without affecting any employee who has already started the 'DSP Onboarding' process.
