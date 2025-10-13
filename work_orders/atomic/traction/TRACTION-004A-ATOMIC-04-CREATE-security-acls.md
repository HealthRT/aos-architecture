---
title: "TRACTION-004A-ATOMIC-04: Create security ACLs for todo and kpi"
epic: "TRACTION-004A"
operation: "MODIFY FILE"
sequence: 4
repository: "hub"
assignee: "aos-coder-agent"
phase: "A - To-Do Model & Views"
---

# Atomic Work Order: TRACTION-004A-ATOMIC-04

**Operation:** MODIFY FILE

**Target File Path:** `hub/addons/traction/security/ir.model.access.csv`

**Original Content:**
```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_traction_group_facilitator,traction.group.facilitator,model_traction_group,group_facilitator,1,1,1,1
access_traction_group_leadership,traction.group.leadership,model_traction_group,group_leadership,1,1,1,1
access_traction_group_user,traction.group.user,model_traction_group,base.group_user,1,0,0,0
access_traction_issue_facilitator,traction.issue.facilitator,model_traction_issue,group_facilitator,1,1,1,1
access_traction_issue_leadership,traction.issue.leadership,model_traction_issue,group_leadership,1,1,1,1
access_traction_rock_facilitator,traction.rock.facilitator,model_traction_rock,group_facilitator,1,1,1,1
access_traction_rock_leadership,traction.rock.leadership,model_traction_rock,group_leadership,1,1,1,1
access_mail_message_subtype_user,mail.message.subtype.user,mail.model_mail_message_subtype,base.group_user,1,0,0,0
access_mail_message_subtype_facilitator,mail.message.subtype.facilitator,mail.model_mail_message_subtype,group_facilitator,1,0,0,0
access_mail_message_subtype_leadership,mail.message.subtype.leadership,mail.model_mail_message_subtype,group_leadership,1,0,0,0
access_res_company_facilitator,res.company.facilitator,base.model_res_company,group_facilitator,1,0,0,0
access_res_company_leadership,res.company.leadership,base.model_res_company,group_leadership,1,0,0,0
```

**Instructions:**
Add ACL entries for the new traction.todo and traction.scorecard.kpi models. Facilitators and leadership get full access.

**Required Final Content:**
```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_traction_group_facilitator,traction.group.facilitator,model_traction_group,group_facilitator,1,1,1,1
access_traction_group_leadership,traction.group.leadership,model_traction_group,group_leadership,1,1,1,1
access_traction_group_user,traction.group.user,model_traction_group,base.group_user,1,0,0,0
access_traction_issue_facilitator,traction.issue.facilitator,model_traction_issue,group_facilitator,1,1,1,1
access_traction_issue_leadership,traction.issue.leadership,model_traction_issue,group_leadership,1,1,1,1
access_traction_rock_facilitator,traction.rock.facilitator,model_traction_rock,group_facilitator,1,1,1,1
access_traction_rock_leadership,traction.rock.leadership,model_traction_rock,group_leadership,1,1,1,1
access_traction_todo_facilitator,traction.todo.facilitator,model_traction_todo,group_facilitator,1,1,1,1
access_traction_todo_leadership,traction.todo.leadership,model_traction_todo,group_leadership,1,1,1,1
access_traction_scorecard_kpi_facilitator,traction.scorecard.kpi.facilitator,model_traction_scorecard_kpi,group_facilitator,1,1,1,1
access_traction_scorecard_kpi_leadership,traction.scorecard.kpi.leadership,model_traction_scorecard_kpi,group_leadership,1,1,1,1
access_mail_message_subtype_user,mail.message.subtype.user,mail.model_mail_message_subtype,base.group_user,1,0,0,0
access_mail_message_subtype_facilitator,mail.message.subtype.facilitator,mail.model_mail_message_subtype,group_facilitator,1,0,0,0
access_mail_message_subtype_leadership,mail.message.subtype.leadership,mail.model_mail_message_subtype,group_leadership,1,0,0,0
access_res_company_facilitator,res.company.facilitator,base.model_res_company,group_facilitator,1,0,0,0
access_res_company_leadership,res.company.leadership,base.model_res_company,group_leadership,1,0,0,0
```

---

## Submission Format

Reply with:
```
ATOMIC TASK COMPLETE - TRACTION-004A-ATOMIC-04

File: hub/addons/traction/security/ir.model.access.csv

Content:
[paste complete file content here]
```

---

**Parent Epic:** TRACTION-004A - To-Do Model & Views (Phase A)  
**Authority:** Executive Architect Directive EA-046 (Phased Atomic Decomposition)  
**Created:** 2025-10-14 03:40:00 UTC

