# Agency Operating System (AOS) - Architecture Repository

**Welcome to the AOS Architecture Repository** - the single source of truth for the architecture, standards, and strategic direction of the Agency Operating System.

---

## 🚀 Quick Start

### **New to AOS?**
→ Read the **[User Guide](USER_GUIDE.md)** for a comprehensive orientation

### **Core Principles**
→ Read **[Non-Negotiables](prompts/core/00_NON_NEGOTIABLES.md)** (Ring 0 - Immutable)

### **Onboarding an AI Agent?**
→ See **[Agent Onboarding Quick Reference](QUICK_REFERENCE_AGENT_ONBOARDING.md)**

---

## 📂 Directory Structure

| Directory | Purpose | Start Here |
|-----------|---------|------------|
| **[/decisions](decisions/)** | Architecture Decision Records (ADRs) | The "why" behind our design |
| **[/standards](standards/)** | Operational standards & guidelines | How we build consistently |
| **[/specs](specs/)** | Feature specifications (YAML) | Detailed technical blueprints |
| **[/features](features/)** | High-level feature briefs | Business requirements |
| **[/work_orders](work_orders/)** | Executable tasks for agents | Hyper-detailed work items |
| **[/prompts](prompts/)** | Agent onboarding primers | Role-specific instructions |
| **[/templates](templates/)** | Document templates | Reusable formats |
| **[/docs/reference](docs/reference/)** | External reference materials | Regulations, APIs, validation rules |
| **[/process_improvement](process_improvement/)** | Feedback & lessons learned | Our learning log |
| **[/bugs](bugs/)** | Active bug tracking | Issues in progress |
| **[/testing](testing/)** | Pre-UAT test plans | Manual test checklists |
| **[/sessions](sessions/)** | Historical session archives | Development history |

---

## 🎯 What Is AOS?

The **Agency Operating System** is a federated platform for home healthcare agencies, consisting of:

- **The Hub:** Administrative core (HR, compliance, Traction EOS)
- **The EVV:** HIPAA-compliant care delivery system (scheduling, visits, billing)

These systems communicate through version-controlled APIs, maintaining strict separation for security and compliance.

---

## 📚 Key Documents

### **Governance**
- [Repository Structure Governance](standards/00-repository-structure-governance.md) - Where files go & naming conventions
- [Immutable Core Framework (ADR-009)](decisions/009-immutable-core-framework.md) - 3-ring governance model

### **Architecture**
- [Hub-EVV Authentication (ADR-001)](decisions/001-hub-evv-authentication.md)
- [Repository Boundaries (ADR-013)](decisions/013-repository-boundaries-and-module-placement.md)
- [Test Environment Isolation (ADR-015)](decisions/015-test-environment-isolation-for-parallel-agents.md)

### **Process**
- [AI Agent Workflow (Standard 03)](standards/03-ai-agent-workflow.md)
- [Spec Compliance (Standard)](standards/SPEC_COMPLIANCE.md)
- [Testing Strategy](standards/TESTING_STRATEGY.md)

### **Development**
- [Odoo Coding Standards (Standard 01)](standards/01-odoo-coding-standards.md)
- [Local Development Guide (Standard 06)](standards/06-local-development-guide.md)
- [Pre-Commit Hooks](standards/PRE_COMMIT_HOOKS.md)

---

## 🤖 AI Agent Workflow

AOS uses specialized AI agents for development:

```
Feature Brief → Spec (YAML) → Work Orders → Code → Tests → UAT
     ↓              ↓              ↓           ↓        ↓       ↓
    BA          BA/Arch      Scrum Master   Coder   Tester   Human
```

**Read:** [Complete Workflow End-to-End](COMPLETE_WORKFLOW_END_TO_END.md)

---

## 🔍 Finding What You Need

### **I need to understand an architectural decision**
→ Browse `/decisions/` (ADRs are numbered and titled)

### **I need to know the coding standards**
→ See `/standards/01-odoo-coding-standards.md`

### **I need to implement a new feature**
→ Start with `/features/[domain]/[feature-name]/01-feature-brief.md`  
→ Then check `/specs/[domain]/XXXX-NNN.yaml`

### **I need to onboard an AI agent**
→ See `/prompts/README.md` for the master list of primers

### **I need to understand a government regulation**
→ Check `/docs/reference/INDEX.md`

### **I need to track down a bug**
→ See `/bugs/` for active tickets

---

## 📖 Documentation Philosophy

This repository follows a **"one place, one purpose"** principle:

- **Decisions are permanent** (ADRs never deleted, only deprecated)
- **Standards are living** (updated as we learn)
- **Specs are contracts** (versioned for historical reference)
- **Feedback is sacred** (process improvement log is append-only)

**Read more:** [Repository Structure Governance](standards/00-repository-structure-governance.md)

---

## 🚦 Status & Health

- **Active Features:** See `/operations/implementation-status.md`
- **Agent Performance:** See `/operations/agent-evaluation-matrix.md`
- **Recent Issues:** See `/process_improvement/process-improvement.md`

---

## 🤝 Contributing

### **For AI Agents**
1. Read your role-specific primer: `/prompts/onboarding_[role].md`
2. Read Ring 0 principles: `/prompts/core/00_NON_NEGOTIABLES.md`
3. Follow your work order
4. Log feedback in `/process_improvement/`

### **For Humans**
1. Read the [User Guide](USER_GUIDE.md)
2. Follow the [Contributor Guide](standards/00-contributor-guide.md)
3. Review [GitHub Projects Structure](standards/06-github-projects-structure.md)

---

## ⚠️ Important Notes

- **No PHI in this repository** - Ever. This is not a HIPAA-compliant system.
- **Ring 0 is immutable** - Changes to `/prompts/core/00_NON_NEGOTIABLES.md` require unanimous approval
- **Repository boundaries are enforced** - Pre-commit hooks prevent cross-contamination

---

## 🆘 Getting Help

**"Where does this file go?"**  
→ [Repository Structure Governance](standards/00-repository-structure-governance.md)

**"Which agent primer do I use?"**  
→ [Agent Onboarding Quick Reference](QUICK_REFERENCE_AGENT_ONBOARDING.md)

**"How do I set up my local environment?"**  
→ [Local Development Guide](standards/06-local-development-guide.md)

**"Something broke, what now?"**  
→ Create a ticket in `/bugs/BUG-NNN-description.md`

---

**Maintained By:** Executive Architect  
**Last Updated:** 2025-10-12  
**Version:** 2.0 (Post-Cleanup)

---

## 📜 Recent Changes

**2025-10-12:** Major repository reorganization
- Deleted duplicate `aos-architecture/` nested structure
- Consolidated onboarding primers (removed version suffixes)
- Created comprehensive governance documentation
- Added missing index files for all major directories

**See:** [Cleanup Status](CLEANUP_STATUS.md) for full details

