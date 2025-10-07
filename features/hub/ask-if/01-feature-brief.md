# Feature Brief: Ask IF Module

**Status:** Proposed
**Author:** Executive Architect
**Date:** 2025-10-07

## 1. Vision & Strategy

This document outlines the architectural foundation for the **`Ask IF`** module. The vision is to create a true **AI Assistant** for all staff. This assistant will serve as a **Natural Language Interface** for the entire Agency Operating System, allowing users to ask questions, retrieve information from application modules (e.g., their schedule), and eventually trigger actions using natural language.

The development strategy is a phased rollout:
1.  **MVP (Knowledge Base Q&A):** The initial focus is to build the core RAG pipeline for answering questions from our verified knowledge base (policies, procedures).
2.  **Post-MVP (Application Integration):** Once the core is proven, we will iteratively add new "tools" to the assistant, allowing it to interact with other modules like Scheduling and Time Off.

## 2. Architectural Pillars ("Agentic" Architecture)

The system will be built using an "Agentic" architecture, which is composed of a router and a "tool chest."

### 2.1. The "Router" (Intent Recognition)

This is the entry point for all user queries. When a user interacts with "Ask IF", this layer's sole responsibility is to classify the user's **intent**. For example:
-   `query_knowledge_base`: The user is asking a general policy question.
-   `query_open_shifts`: The user is asking to see available work shifts.
-   `request_time_off`: The user wants to submit a PTO request.

### 2.2. The "Tool Chest"

Based on the recognized intent, the Router will pass the query to the appropriate "tool." Each tool is a specialized function designed to handle one type of task.

-   **Tool: `query_knowledge_base` (MVP):** This is the Retrieval-Augmented Generation (RAG) pipeline we've designed. It will find and synthesize answers from the Odoo Knowledge Base.
-   **Tool: `query_open_shifts` (Post-MVP):** This tool will query the `evv_scheduling` module, run the results through the Matching Engine, and return a list of shifts the user is qualified for.
-   **Tool: `request_time_off` (Post-MVP):** This tool will interact with the `hub_time_off` module's internal API to submit a new PTO request on the user's behalf.

### 2.3. The Knowledge Base & Ingestion Pipeline

The foundation for the `query_knowledge_base` tool remains the same:
-   **Location:** The Odoo Knowledge App in the Hub.
-   **Ingestion:** A two-part system for automatically indexing internal documents and providing a human-in-the-loop workflow for monitoring external compliance sites.

## 3. Workflow & API

The cross-repository API remains critical. The EVV mobile app will make a request to a single, intelligent endpoint (`POST /api/v1/ask-if`). The Hub will be responsible for routing the request to the correct internal tool and returning a structured response.

## 4. Key Architectural Decisions & Dependencies

-   **API-First Design:** The success of this module is critically dependent on all other modules (like Scheduling, Time Off) being built with a clean, internal API that this assistant can call. This is formalized in ADR-003.
-   **Strictly Grounded Answers:** The `query_knowledge_base` tool is architecturally constrained to only provide answers based on verified documents.
-   **External Dependencies:** LLM API, Embedding Model API, Vector Database.
