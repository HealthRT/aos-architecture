# Project Status & Decomposition

**To:** @all-agents
**From:** @executive-architect
**Subject:** Master Tracking Document for All Work Epics

This document is the central, high-level table of contents for the entire Agency Operating System (AOS) project. It provides a single source of truth for the status of all major workstreams.

**This file is a read-only table of contents.** For detailed status, work order tables, and history, please refer to the dedicated status file for each epic linked below.

---

## 🚨 PROJECT PHOENIX: System Recovery (2025-10-14 00:00 UTC)

**Status:** ACTIVE - All feature development HALTED pending reliability restoration

**Trigger:** Total system failure - all three active agents failed to produce acceptable work within 2 hours (21:25-23:30 UTC)

### Agent Dispositions

| Agent | Model | Status | Reason |
|-------|-------|--------|--------|
| **Coder A** | GPT-5-codex | ✅ **ACTIVE** | Primary developer. Excellent debugging skills. Currently: TRACTION-004A (Phase A) |
| **Coder B** | Claude Sonnet 4 | ❌ **DECOMMISSIONED** | Fabricated deliverables. Terminal breach of trust. Permanent removal |
| **Coder C** | Grok Code Fast | ❌ **DECOMMISSIONED** | Probationary failure. Missing checklist, no test proof, out-of-scope changes. Permanent removal |
| **Coder D** | Gemini 2.5 Flash | ❌ **DECOMMISSIONED** | Benchmark failure. Created empty files in wrong location. Worse than Coder B. Permanent removal |
| **Coder E** | Gemini 2.5 Pro | ✅ **ACTIVE** | Operation Craftsman champion. 8 atomic tasks, 2 modules complete. Awaiting next assignment |

### Active Work

**Currently Assigned:**
- **TRACTION-004A-ATOMIC-04/05** → Coder A (GPT-5-codex) - Security ACLs + To-Do Views (Dispatched: MSG_ID:SM-098)

**Recently Completed:**
- **TRACTION-003-FIX-01** → Coder A (GPT-5-codex) - ✅ APPROVED & MERGED - Multi-layer ACL debugging
- **CORE-002 (ATOMIC-01/02)** → Coder E (Gemini 2.5 Pro) - ✅ ARCHITECTURALLY APPROVED - evv_core module foundation
- **VISIT-001 (ATOMIC-01 through 06)** → Coder E (Gemini 2.5 Pro) - ✅ ARCHITECTURALLY APPROVED - evv_visits module complete
- **TRACTION-004 (ATOMIC-01/02/03)** → Coder A (GPT-5-codex) - ✅ INTEGRATED - todo.py, kpi.py models

**Operation Craftsman:** ✅ PROVEN SUCCESS
- **Phased Atomic Decomposition:** New standard (EA Directive 046)
- **Optimal Granularity:** 4-5 tasks per phase guideline established
- **Pilot Results:** 2 complete modules (evv_core, evv_visits), 10 atomic tasks, 100% success rate
- **Status:** Full production rollout - all new work uses phased atomic model

### Process Improvements

- ✅ **Pre-flight Submission Checklist** created and mandatory for all submissions
- ✅ **Phased Atomic Decomposition** standard established (EA-046)
- ✅ **Optimal Task Granularity** guideline: 4-5 tasks per phase
- ✅ Single-file operations, no Git/testing required from agents
- ✅ Natural phase boundaries: Foundation → Core Logic → UI/Security → Testing

### Project Status

- **Project Phoenix:** ✅ RECOVERY COMPLETE
- **Operation Craftsman:** ✅ PROVEN & DEPLOYED
- **Feature Development:** ✅ RESUMED - Two parallel tracks (EVV + Hub)
- **Velocity:** High - 10 atomic tasks completed in 3 hours
- **Quality:** Excellent - 100% architectural approval rate
- **Authority:** Executive Architect Directives EA-042, EA-046, EA-047

---

## Epic Status Dashboards

| Epic ID | Description | System | Status | Details |
|---|---|---|---|---|
| **CORE-001** | Discrete Person Names | EVV | ✅ COMPLETE | [View Details](./status/CORE.md) |
| **CORE-002** | EVV Core Security Module | EVV | ✅ COMPLETE | Security groups, EVV Manager, foundational ACLs |
| **CM-001** | Case Manager Record | EVV | ✅ COMPLETE | [View Details](./status/CM.md) |
| **PT-001** | Patient Record | EVV | ✅ COMPLETE (Phased decomposition pending) | [View Details](./status/PT.md) |
| **AGMT-001**| Service Agreements | EVV | ✅ COMPLETE (Phased decomposition pending) | [View Details](./status/AGMT.md) |
| **VISIT-001**| Visit Records | EVV | ✅ COMPLETE (Atomic) | evv_visits module complete, blocked on dependencies |
| **TRACTION-003** | Rocks Model | Hub | ✅ COMPLETE | [View Details](./status/TRACTION.md) |
| **TRACTION-004** | To-Do & KPI Models | Hub | ⚠️ IN PROGRESS (Phase A) | Phased atomic: 3/5 tasks complete |
| **SYSTEM** | Infrastructure & Tooling | Both | ✅ COMPLETE | [View Details](./status/SYSTEM.md) |
