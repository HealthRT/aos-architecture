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
| **Coder A** | GPT-5-codex | ✅ **ACTIVE** | Sole active developer. Proven reliable. Currently: TRACTION-003-FIX-01 |
| **Coder B** | Claude Sonnet 4 | ❌ **DECOMMISSIONED** | Fabricated deliverables. Terminal breach of trust. Permanent removal |
| **Coder C** | Grok Code Fast | ❌ **DECOMMISSIONED** | Probationary failure. Missing checklist, no test proof, out-of-scope changes. Permanent removal |
| **Coder D** | Gemini 2.5 Flash | ❌ **DECOMMISSIONED** | Benchmark failure. Created empty files in wrong location. Worse than Coder B. Permanent removal |
| **Coder E** | Gemini 2.5 Pro | ✅ **ACTIVE** | Operation Craftsman pilot. First atomic task SUCCESS. Currently: VISIT-001-ATOMIC-02 |

### Active Work

**Currently Assigned:**
- **TRACTION-003-FIX-01** → Coder A (GPT-5-codex) - Hub repository ACL fix (Dispatched: MSG_ID:SM-073, Multiple scope expansions)
- **VISIT-001-ATOMIC-02** → Coder E (Gemini 2.5 Pro) - Atomic workflow pilot (Dispatched: MSG_ID:SM-080)

**Recently Completed:**
- **AGMT-001-FIX-01** → Coder A (GPT-5-codex) - ✅ APPROVED & MERGED - Perfect submission
- **VISIT-001-ATOMIC-01** → Coder E (Gemini 2.5 Pro) - ✅ APPROVED & INTEGRATED - First atomic success

**Operation Craftsman:** PILOT IN PROGRESS
- Atomic work order framework: ✅ Implemented
- First atomic task: ✅ SUCCESS (Coder E)
- Status: Pilot continuing with ATOMIC-02 through ATOMIC-06

### Process Improvements

- ✅ **Pre-flight Submission Checklist** created and mandatory for all submissions
- ✅ Integrated into all work order templates
- ⚠️ Enforcement: Missing/incomplete checklist = immediate rejection

### Project Status

- **Feature Development:** HALTED
- **Only Active Work:** Two probationary tasks
- **Unblocked After:** Both probationary agents demonstrate perfect execution
- **Authority:** Executive Architect Directive EA-038

---

## Epic Status Dashboards

| Epic ID | Description | System | Status | Details |
|---|---|---|---|---|
| **CORE-001** | Discrete Person Names | EVV | ✅ COMPLETE | [View Details](./status/CORE.md) |
| **CM-001** | Case Manager Record | EVV | ✅ COMPLETE | [View Details](./status/CM.md) |
| **PT-001** | Patient Record | EVV | ✅ COMPLETE | [View Details](./status/PT.md) |
| **AGMT-001**| Service Agreements | EVV | ⚠️ IN PROGRESS | [View Details](./status/AGMT.md) |
| **VISIT-001**| Visit Records | EVV | ❌ BLOCKED | [View Details](./status/VISIT.md) |
| **TRACTION** | Hub/Traction MVP | Hub | ⚠️ IN PROGRESS | [View Details](./status/TRACTION.md) |
| **SYSTEM** | Infrastructure & Tooling | Both | ✅ COMPLETE | [View Details](./status/SYSTEM.md) |
