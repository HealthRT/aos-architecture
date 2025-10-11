# 6. GitHub Projects Structure

**Status:** Accepted  
**Author:** Executive Architect  
**Date:** 2025-10-11  
**Project URL:** https://github.com/users/HealthRT/projects/2

---

## 1. Purpose

This document defines the structure and usage of GitHub Projects for managing AOS development work. The project is designed as a unified board that can be easily split into separate projects if complexity grows.

---

## 2. Project: "AOS Development Workflow"

**Type:** Board view with custom fields  
**Scope:** All repositories (aos-architecture, hub, evv)  
**URL:** https://github.com/users/HealthRT/projects/2

### 2.1. Philosophy

- **Start Simple:** Single board for all work, use metadata to organize
- **Easy Filtering:** Rich custom fields enable views by repo, module, agent, priority
- **Future-Proof:** Metadata structure allows splitting into separate projects later
- **Agent-Ready:** Fields align with agent labels and workflow automation

---

## 3. Custom Fields

### 3.1. Built-In Fields

| Field | Type | Purpose |
|:------|:-----|:--------|
| **Title** | Text | Issue/PR title (auto-populated) |
| **Assignees** | People | Who is working on this |
| **Status** | Single Select | Current workflow stage |
| **Labels** | Tags | GitHub labels (agent:, type:, priority:, module:, status:) |
| **Repository** | Text | Source repository (auto-populated) |
| **Linked PRs** | Reference | Associated pull requests |
| **Milestone** | Reference | Release milestone (if applicable) |
| **Parent Issue** | Reference | For sub-tasks/epics |
| **Sub-issues Progress** | Progress | Tracks completion of child issues |

### 3.2. Custom Fields (Added)

| Field | Type | Options | Purpose |
|:------|:-----|:--------|:--------|
| **Agent Type** | Single Select | Coder, Tester, DevOps, BA, Architect, None | Quick identification of required agent |
| **Module** | Single Select | hub-compliance, hub-traction, hub-payroll, evv-scheduling, ask-if, employee-experience, infrastructure, architecture, cross-cutting | Module-level organization |
| **Priority** | Single Select | High, Medium, Low | Urgency indicator (mirrors priority: labels) |

---

## 4. Workflow Stages (Status Field)

### 4.1. Current Status Options

The project is created with these default stages:

| Status | Description | Next Action |
|:-------|:------------|:------------|
| **Todo** | Backlog item, not yet ready | Refine requirements, assign agent |
| **In Progress** | Actively being worked on | Complete implementation |
| **Done** | Completed and merged | Archive/close |

### 4.2. Recommended Additional Stages

**To add these stages, visit the project settings:**

1. **Backlog** - Ideas and future work (not yet refined)
2. **Ready for Agent** - Fully specified work order, ready to assign
3. **Blocked** - Waiting on external dependency or decision
4. **Needs Review** - PR submitted, awaiting architect review

**How to add:**
1. Open the project: https://github.com/users/HealthRT/projects/2
2. Click ⚙️ Settings (top right)
3. Click on "Status" field
4. Click "+ Add option" for each new stage
5. Drag to reorder: Backlog → Ready for Agent → In Progress → Needs Review → Blocked → Done

---

## 5. Filtering and Views

The custom fields enable powerful filtering without splitting the project:

### 5.1. Suggested Saved Views

**View 1: Hub Work Only**
- Filter: Repository = "HealthRT/hub"
- Group by: Module
- Sort by: Priority

**View 2: EVV Work Only**
- Filter: Repository = "HealthRT/evv"
- Group by: Status
- Sort by: Priority

**View 3: Architecture & Infrastructure**
- Filter: Repository = "HealthRT/aos-architecture"
- Group by: Agent Type
- Sort by: Status

**View 4: Current Sprint**
- Filter: Status = "In Progress" OR Status = "Ready for Agent"
- Group by: Agent Type
- Sort by: Priority

**View 5: Blocked Items**
- Filter: Status = "Blocked"
- Group by: Repository
- Sort by: Priority

**View 6: DevOps Agent Queue**
- Filter: Agent Type = "DevOps" AND Status != "Done"
- Sort by: Priority

---

## 6. Automation Rules (Recommended)

GitHub Projects supports workflow automation. To configure:

### 6.1. Auto-Status Updates

1. **When issue assigned** → Set Status to "In Progress"
2. **When PR opened** → Set Status to "Needs Review"
3. **When PR merged** → Set Status to "Done"
4. **When issue closed without PR** → Set Status to "Done"
5. **When label "status:blocked" added** → Set Status to "Blocked"

### 6.2. Auto-Field Updates

1. **When label "agent:coder" added** → Set Agent Type to "Coder"
2. **When label "agent:devops" added** → Set Agent Type to "DevOps"
3. **When label "agent:tester" added** → Set Agent Type to "Tester"
4. **When label "agent:ba" added** → Set Agent Type to "BA"
5. **When label "priority:high" added** → Set Priority to "High"
6. **When label "priority:medium" added** → Set Priority to "Medium"
7. **When label "priority:low" added** → Set Priority to "Low"

**To configure automation:**
1. Open project: https://github.com/users/HealthRT/projects/2
2. Click ⋯ menu (top right) → Workflows
3. Enable built-in workflows
4. Create custom workflows for label-to-field mappings

---

## 7. Using the Project

### 7.1. Adding Issues to the Project

**Manual:**
```bash
gh project item-add 2 --owner HealthRT --url <issue-url>
```

**Automatic:**
Configure automation to auto-add issues with specific labels (e.g., `agent:*` labels).

### 7.2. Setting Custom Fields via CLI

```bash
# Get project item ID for an issue
gh project item-list 2 --owner HealthRT --format json | jq '.items[] | select(.content.title == "Your Issue Title") | .id'

# Note: Setting custom field values via CLI requires GraphQL API
# See: https://docs.github.com/en/graphql/reference/mutations#updateprojectv2itemfieldvalue
```

### 7.3. Recommended Workflow

1. **Create Issue** → Add `agent:*` and `type:*` labels → Auto-adds to project
2. **Set Custom Fields** → Agent Type, Module, Priority (via web UI or automation)
3. **Status: Ready for Agent** → Assign to agent (human or AI)
4. **Status: In Progress** → Agent implements solution
5. **Status: Needs Review** → PR created, architect reviews
6. **Status: Done** → PR merged, issue closed

---

## 8. Future: Splitting the Project

If the unified project becomes too complex, here's how to split:

### 8.1. Export by Repository

1. Filter project to single repository (e.g., Repository = "HealthRT/hub")
2. Export issues to CSV
3. Create new project "Hub Development"
4. Import issues from CSV
5. Update automation rules

### 8.2. Export by Module

1. Filter project to module (e.g., Module = "hub-traction")
2. Follow same export/import process
3. Create project per major module

### 8.3. Maintain Metadata

The custom fields you've set up (Repository, Module, Agent Type, Priority) will be preserved and can be migrated to new projects. This makes splitting painless.

---

## 9. Integration with Standards

### 9.1. Alignment with Labeling Standards

This project structure directly integrates with:
- **05-automation-and-labeling-standards.md** - Uses same agent/type/priority/module taxonomy
- **Work Order Templates** - Custom fields match work order metadata
- **Agent Roster** - Agent Type field maps to agent GitHub handles

### 9.2. Agent Workflows

AI agents can query the project to:
- Find work assigned to them: `Agent Type = "Coder"` AND `Status = "Ready for Agent"`
- Report status updates: Update Status field via GraphQL API
- Track dependencies: Use Parent Issue and Sub-issues Progress fields

---

## 10. Maintenance

### 10.1. Adding New Modules

When creating new Odoo modules:
1. Add module label to all repos (per 05-automation-and-labeling-standards.md)
2. Add option to "Module" field in project settings
3. Update this document

### 10.2. Adding New Status Stages

If workflow needs change:
1. Add new status option in project settings
2. Update automation rules
3. Document in this file

### 10.3. Regular Reviews

**Monthly:**
- Review "Blocked" items
- Archive completed work (Status = Done, closed > 30 days)
- Assess if project split is needed

**Quarterly:**
- Review automation effectiveness
- Refine custom fields based on usage
- Update views and filters

---

## 11. Quick Links

- **Project Board:** https://github.com/users/HealthRT/projects/2
- **Project Settings:** https://github.com/users/HealthRT/projects/2/settings
- **Automation Workflows:** https://github.com/users/HealthRT/projects/2/workflows
- **GitHub Projects Docs:** https://docs.github.com/en/issues/planning-and-tracking-with-projects

---

## 12. Summary

✅ **Single unified project** for all AOS development  
✅ **Rich metadata** (Repository, Module, Agent Type, Priority)  
✅ **Future-proof** structure allows easy splitting  
✅ **Agent-ready** with automation hooks  
✅ **Aligned** with labeling standards and workflows  
✅ **Flexible** filtering and views for any perspective  

**Status:** Production ready, Issue #1 added as first item

