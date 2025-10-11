# This is the official Story Specification Template for the AOS Project.
# It is a hybrid of the BMAD-METHOD™ template and our own specific architectural requirements.
# All new features must be defined using this structure.

id: [MODULE-###]                       # Unique story ID (e.g., COMP-101)
title: ""                               # Short, action-oriented title
summary: ""                             # One-line goal of the feature

# --- User Story (for human context) ---
user_story: "As a [ROLE], I want [FEATURE] so that [BENEFIT]."

# --- Strategic & Compliance Constraints ---
component_type: [Core | Expansion Pack]     # As per ADR-007
scope: [MVP | Post-MVP]                 # Business priority for rollout
stakeholders: []                        # List of roles from the Role Matrix who will use/be affected by this
compliance:
  hipaa_implicated: false             # true if this feature is in the EVV or touches PHI
  phi_fields: []                      # If true, list the exact model fields containing PHI.
  access_control:                     # Define the specific RBAC requirements for this feature
    - role: ""
      permissions: []                 # e.g., ["read_own", "write_own", "delete_own"]
  immutable_core_impact: false        # true if this feature requires a change to our core governance

# --- Technical Specification ---
module: ""                              # The target Odoo addon for the code (e.g., "hub_compliance")
depends_on: []                          # List of other addon module dependencies
out_of_scope: []                        # Explicitly excluded areas to prevent scope creep

models:
  - name: ""                            # Odoo model name (e.g., "hub.compliance.document")
    fields:
      - { name: "", type: "", relation: "", required: false }
    methods:
      - name: ""
        signature: "def method_name(self, arg: str) -> bool:"
        intent: "Briefly describe the business logic this method will contain."

# --- User Experience ---
ui_mockup: |
  # (Optional: Low-token ASCII mockup of the UI)
  ┌────────────────────────────────────────────┐
  │ Example UI Component                       │
  ├────────────────────────────────────────────┤
  │ [Label]: [Data Field]                      │
  └────────────────────────────────────────────┘

# --- Business Logic & Validation ---
rules:
  - q: ""                               # A question about a business rule (e.g., "What is the max length of a name?")
    a: ""                               # The definitive answer.

# --- Testing & Verification ---
acceptance_criteria:
  - ""                                   # GIVEN-WHEN-THEN format (e.g., "GIVEN a user with 'read_own' permission, WHEN they access a record they don't own, THEN the system must raise an AccessError.")

# --- Implementation Plan ---
artifacts:
  code:
    - ""                                 # List of Python and XML files to be created/modified.
  tests:
    - ""                                 # List of test files to be created.
  docs:
    - ""                                 # List of any documentation files to be created/updated.

# --- Agent Guidance ---
agent_hints:
  builder_output: "Unified diff only. Stay in the specified module path. Adhere strictly to all ADRs."
  qa_output: "Generate tests that explicitly cover every acceptance criterion. Include tests for permissions and error conditions."
  security_focus: "Pay close attention to the `compliance` section. All `access_control` rules must be enforced."
