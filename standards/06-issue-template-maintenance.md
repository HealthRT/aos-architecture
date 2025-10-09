# 6. Issue Template Maintenance

**Status:** Accepted  
**Date:** 2025-10-09

## Purpose

This document defines how to maintain GitHub Issue Templates across our three repositories (aos-architecture, hub, evv) to ensure consistency and prevent drift.

---

## The Challenge

**Problem:** GitHub Issue Templates must be stored in each repository's `.github/ISSUE_TEMPLATE/` directory. This means we have duplicate templates that must be kept synchronized.

**Repositories with Templates:**
- `hub/.github/ISSUE_TEMPLATE/work-order-coder.yml`
- `evv/.github/ISSUE_TEMPLATE/work-order-coder.yml`
- `aos-architecture/.github/ISSUE_TEMPLATE/` (ADR, User Story templates)

**Risk:** Templates can diverge over time if updates are made to one repository but not others.

---

## Template Inventory

### Work Order: Coder Agent
**Locations:**
- `hub/.github/ISSUE_TEMPLATE/work-order-coder.yml`
- `evv/.github/ISSUE_TEMPLATE/work-order-coder.yml`

**Differences (Intentional):**
- Repository name (hub vs evv)
- Docker compose commands (odoo vs evv container)
- Module dropdown options (hub-* vs evv-* modules)
- EVV includes HIPAA compliance checkbox

**Core Structure (Must Match):**
- All 7 sections from work_order_template.md
- Validation requirements
- Proof of execution format

---

### Architecture Decision Record
**Location:** `aos-architecture/.github/ISSUE_TEMPLATE/architecture-decision.yml`  
**Scope:** Architecture repo only (not duplicated)

---

### User Story
**Location:** `aos-architecture/.github/ISSUE_TEMPLATE/user-story.yml`  
**Scope:** Architecture repo only (not duplicated)

---

## Maintenance Process

### When Template Updates Are Needed

**Trigger Events:**
1. Process improvement identified
2. New required section added
3. Validation requirements change
4. Workflow standards updated

### Update Procedure

**Step 1: Propose Change**
Create ADR or issue in `aos-architecture` describing:
- What needs to change
- Why it's needed
- Which templates are affected

**Step 2: Update Source Template**
Update `aos-architecture/templates/work_order_template.md` first (this is the source of truth)

**Step 3: Update All Issue Templates**
For each affected repository, update the corresponding `.github/ISSUE_TEMPLATE/*.yml` file.

**Required Updates:**
- [ ] `hub/.github/ISSUE_TEMPLATE/work-order-coder.yml`
- [ ] `evv/.github/ISSUE_TEMPLATE/work-order-coder.yml`
- [ ] Any new templates added

**Step 4: Verify Consistency**
Run the validation script (see below) to ensure templates are in sync.

**Step 5: Document in Changelog**
Update this document's changelog with what changed and when.

---

## Validation Script

Use this command to check if Work Order templates are in sync:

```bash
# Compare hub and evv work order templates (ignoring repo-specific differences)
cd /home/james/development/aos-development

# Extract core structure (sections 1-7) from both
diff -u \
  <(grep -A 999 "body:" hub/.github/ISSUE_TEMPLATE/work-order-coder.yml | sed 's/hub/REPO/g' | sed 's/odoo/CONTAINER/g' | sed 's/module:hub-/module:REPO-/g') \
  <(grep -A 999 "body:" evv/.github/ISSUE_TEMPLATE/work-order-coder.yml | sed 's/evv/REPO/g' | sed 's/module:evv-/module:REPO-/g')
```

**Expected:** Minimal differences (only repo-specific values)  
**If differences found:** Templates have diverged, synchronize them

---

## Alternative Solutions (Future)

### Option A: Template Generation Script

Create a script that generates repo-specific templates from a single source:

```bash
# Generate templates from master
./scripts/generate-issue-templates.sh

# This would:
# 1. Read master template
# 2. Apply repo-specific variables
# 3. Write to each repo's .github/ISSUE_TEMPLATE/
```

**Pros:** Single source of truth, automated consistency  
**Cons:** Requires maintenance of generation script

---

### Option B: Git Submodules

Store templates in `aos-architecture` and use git submodules to link them into other repos.

**Pros:** True single source  
**Cons:** Submodules are complex, GitHub may not support this for issue templates

---

### Option C: GitHub Template Repository

Create a separate `aos-templates` repository that all others reference.

**Pros:** Centralized management  
**Cons:** Extra repository overhead, GitHub limitations

---

## Decision: Manual Synchronization (Current Approach)

**For Now:** We will maintain templates manually with disciplined process.

**Why:**
- Simple and works today
- Low template change frequency expected
- Only 2 repos need work-order-coder.yml sync
- Can automate later if it becomes a burden

**Commitment:**
- ✅ Update all repos when templates change
- ✅ Document changes in this file
- ✅ Validate consistency regularly
- ✅ Revisit automation if templates change frequently

---

## Changelog

### 2025-10-09: Initial Template Deployment
**Changes:**
- Created work-order-coder.yml for hub repository
- Created work-order-coder.yml for evv repository  
- Created architecture-decision.yml for aos-architecture
- Created user-story.yml for aos-architecture

**Modified Sections:** N/A (initial creation)

**Updated By:** Workflow Coach AI  
**Reviewed By:** Architect (approved)

---

### Future Updates

Document all template changes here with:
- Date
- What changed
- Which templates affected
- Who made the change

---

## Quick Reference

**Template Locations:**
```
aos-architecture/
├── templates/work_order_template.md (SOURCE OF TRUTH)
└── .github/ISSUE_TEMPLATE/
    ├── architecture-decision.yml
    └── user-story.yml

hub/
└── .github/ISSUE_TEMPLATE/
    └── work-order-coder.yml (KEEP IN SYNC WITH EVV)

evv/
└── .github/ISSUE_TEMPLATE/
    └── work-order-coder.yml (KEEP IN SYNC WITH HUB)
```

**Update Checklist:**
- [ ] Update source: `aos-architecture/templates/work_order_template.md`
- [ ] Update hub template
- [ ] Update evv template
- [ ] Run validation script
- [ ] Document in changelog above
- [ ] Commit all changes together

---

**Responsibility:** Workflow Coach AI (with Architect approval for changes)

