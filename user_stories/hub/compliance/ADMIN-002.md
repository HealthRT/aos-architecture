# Story ID: `ADMIN-002`
- **Avatar:** Administrator
- **User Story:** As an Administrator, I want the system to automatically start the correct onboarding process when a new employee is added to Gusto, so that no new hire is missed and the process starts immediately without manual data entry.

### Workflow
When an employee accepts their offer in Gusto, a webhook is sent to Odoo. The system listens for this, creates the new employee record, and uses the employee's job title to find the matching Onboarding Template. It then automatically creates and starts the full onboarding process, including all individual tasks.

### Automations & Triggers
1. **Trigger:** Gusto 'employee.created' webhook. 
2. **Automation:** The system creates the `hr.employee` and `compliance.staff` records. A mapping system (e.g., a simple model mapping job titles to templates) is used to assign the correct `compliance.onboarding.template`. An `onboarding.process` with all its `onboarding.task` records is created. 
3. **Alert:** If no template is found for the given job title, a notification and an activity are created and assigned to the admin.

### Acceptance Criteria

#### Backend Acceptance Criteria
1. A controller endpoint `/api/gusto/webhook` exists, is secured, and can receive and parse the JSON payload from Gusto. 
2. Business logic correctly creates the `hr.employee` and `compliance.staff` records from the payload. 
3. A data model `compliance.job.title.mapping` exists to link `job_title` strings to `compliance.onboarding.template` records. 
4. If a mapping is found, a `compliance.onboarding.process` is created. If not, an `mail.activity` is created for the 'Compliance Admin' user group.

#### UI Acceptance Criteria
This is a backend process, so there is no direct UI. The results are visible in the system. The Job Title-to-Template mapping must have a simple UI for the admin to manage.

#### UAT Acceptance Criteria
1. When I create an employee in Gusto with job title 'Direct Support Professional', an onboarding process using the 'DSP Onboarding' template is automatically created for them in Odoo. 
2. I can immediately find this new employee in the Onboarding Dashboard. 
3. If I create an employee with job title 'Unknown Role', I receive a 'To-Do' notification in Odoo prompting me to manually assign an onboarding template.
