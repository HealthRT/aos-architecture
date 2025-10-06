# Hub / Compliance Module User Stories

This document contains the detailed user stories for the `hub_compliance` module.

---

## Story ID: `ADMIN-001`
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

---

## Story ID: `ADMIN-002`
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

---

## Story ID: `TRAINING-COORDINATOR-001`
- **Avatar:** Training Coordinator
- **User Story:** As the Training Coordinator, I want a central dashboard to monitor the real-time progress of all new hires, so that I can quickly identify bottlenecks and see who is falling behind.

### Workflow
The coordinator clicks on the 'Onboarding Dashboard' menu item. They see a Kanban board with columns like 'Not Started', 'In Progress', 'Awaiting Review', and 'Completed'. Each new hire is a card on the board. The coordinator can filter the view by manager or template, and click a card to see the detailed checklist for that person.

### Automations & Triggers
1. **Automation:** The dashboard updates in real-time as employees complete tasks. 
2. **Alert:** Cards for employees whose tasks are overdue are automatically flagged (e.g., turned red).

### Acceptance Criteria

#### Backend Acceptance Criteria
1. The `compliance.onboarding.process` model has a `kanban_state` computed field based on the status of its tasks. 
2. The model has fields for `total_task_count` and `completed_task_count` for progress calculation. 
3. Record rules are in place, but a Coordinator can see all records. 
4. Overdue tasks are identified by a daily scheduled action that compares `task.deadline_date` with the current date.

#### UI Acceptance Criteria
1. A Kanban view is the default for the `compliance.onboarding.process` model. 
2. Each Kanban card clearly displays the employee's name, avatar, progress (e.g., '5/12 Tasks Complete'), and manager. 
3. Cards have a visual indicator (e.g., red border) if the process contains overdue tasks. 
4. Quick filters are available for 'My Team' (for managers), 'Overdue', and by 'Onboarding Template'.

#### UAT Acceptance Criteria
1. I can open the dashboard and see all current new hires organised by their overall status. 
2. I can filter the dashboard to see only the employees managed by 'John Doe'. 
3. I can see that 'Jane Smith's card is red because she has not completed a task by its deadline. 
4. I can click on Jane's card and be taken directly to her detailed onboarding checklist.

---
... and so on for all user stories.
