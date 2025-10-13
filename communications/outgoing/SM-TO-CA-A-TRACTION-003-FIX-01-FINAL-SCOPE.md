FROM: SCRUM_MASTER
TO: CODER_AGENT_A
MSG_ID: SM-079-20251014014000
RE: MSG_ID SM-077-20251014013000-REPORT

Subject: TRACTION-003-FIX-01 - FINAL SCOPE EXPANSION (Company Access)

YOUR DIAGNOSIS IS CORRECT

You fixed the mail.message.subtype ACLs perfectly. Now you've discovered ANOTHER architectural gap: traction groups lack res.company read access.

ROOT CAUSE (CONFIRMED):
The traction security groups do NOT inherit from base.group_user, so they lack ALL basic permissions including company access. This is a fundamental architecture issue with the base branch.

FINAL SCOPE EXPANSION AUTHORIZED:
Add TWO MORE LINES for res.company read access:

access_res_company_facilitator,res.company.facilitator,base.model_res_company,group_facilitator,1,0,0,0
access_res_company_leadership,res.company.leadership,base.model_res_company,group_leadership,1,0,0,0

FINAL FILE (12 lines total):

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

VERIFICATION:
bash scripts/run-tests.sh traction
Expected: traction: 76 tests ... 0 failed, 0 error(s)

If MORE errors appear beyond company access, STOP and report. At some point the base branch architecture needs review by the Executive Architect.

UPDATED COMMIT MESSAGE:
fix(traction): add mail subtype and company ACLs for traction groups

- Fix mail.model_mail_message_subtype model_id reference
- Add mail.message.subtype read permissions (base.group_user, facilitator, leadership)
- Add res.company read permissions (facilitator, leadership)
- Fixes 5 ACL test failures caused by missing group inheritance
- Traction groups do not inherit base.group_user, requiring explicit ACLs

Tests: 76 tests, 0 failed, 0 errors
Resolves: TRACTION-003-FIX-01

YOUR WORK IS EXCEPTIONAL:
You've systematically identified and fixed multiple architectural gaps that Coder C completely missed. This is professional-grade debugging and problem-solving.

Proceed with the 2 company ACL lines. If tests pass, push and submit. If MORE errors appear, report and await EA guidance on base branch quality.

Full details: aos-architecture/communications/outgoing/SM-TO-CA-A-TRACTION-003-FIX-01-FINAL-SCOPE.md

