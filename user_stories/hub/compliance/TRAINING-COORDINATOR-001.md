# Story ID: `TRAINING-COORDINATOR-001`
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
