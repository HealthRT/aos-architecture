# Odoo EVV Coding Standards

This document defines the canonical coding standards for the Odoo EVV project. It is based on the official [Odoo 18.0 Coding Guidelines](https://www.odoo.com/documentation/18.0/contributing/development/coding_guidelines.html) and includes project-specific conventions. All contributions must adhere to these standards.

## 1. General Principles

-   **Spec-Driven Development**: All code must implement a documented specification (`/docs`) or user story (`/docs/requirements`). Code without a corresponding requirement will be rejected.
-   **Clarity and Extensibility**: Write code that is easy to understand and extend. Odoo is a highly modular framework; your code should be designed to be inherited and modified by other modules.
-   **No Raw SQL**: Never use raw SQL queries. Use the Odoo ORM for all database operations to ensure security, maintainability, and respect for Odoo's multi-tenancy and access control mechanisms.
-   **Never Commit Transactions**: Do not call `self.env.cr.commit()` within model methods. The framework is responsible for transaction management. Committing transactions prematurely can lead to severe data integrity issues.
-   **No External Frameworks**: Do not introduce external Python libraries (from PyPI) or JavaScript libraries (from NPM, etc.) without a formal architectural review and approval. All development should leverage Odoo's built-in APIs and the Odoo Web Library (OWL) as the default.

## 2. Odoo Module Structure

All custom modules must follow the standard Odoo directory structure.

-   `controllers/`: For HTTP route handlers.
-   `models/`: For Python model definitions (`.py` files).
-   `views/`: For XML view definitions (`.xml` files).
-   `data/`: For non-view data files (`.xml`).
-   `security/`: For `ir.model.access.csv` and security rule definitions.
-   `static/`: For all web assets (JS, CSS, XML templates for JS).
    -   `static/src/js/`: JavaScript files.
    -   `static/src/xml/`: QWeb/OWL templates.
    -   `static/src/scss/`: SCSS files.
-   `tests/`: For Python and contract tests.

## 3. Python Standards

-   **Linter**: Code must be formatted with `Black` and pass `Flake8` (or `Ruff`) linting.
-   **Model Attributes**:
    -   `_name = 'evv.visit'`: Always use a clear, prefixed name.
    -   `_description = 'EVV Visit'`: Provide a human-readable description.
    -   `_inherit = 'res.partner'`: Use for inheriting from existing models.
-   **Method Conventions**:
    -   **`self.ensure_one()`**: Use at the start of any method that should only operate on a single record.
    -   **Standard Prefixes**: Use `_compute_...`, `_onchange_...`, `_inverse_...`, `_cron_...` for their respective method types.
    -   **API Decorators**: Use `@api.model`, `@api.model_create_multi`, `@api.returns` where appropriate.
-   **Docstrings**: All public methods must have a docstring explaining their purpose. For business logic, link to the relevant user story ID.
    ```python
    def _recompute_and_round_units(self):
        """
        Recomputes raw minutes and rounds to billable units.
        Implements: TIMEcards_REVIEW_001 (A2)
        """
        self.ensure_one()
        # ... logic ...
    ```
-   **Context Propagation**: When calling methods that may be extended, always pass the context: `record.with_context(context).do_something()`.

## 4. Module Versioning

All custom Odoo modules must specify a version in their `__manifest__.py` file. The versioning scheme must follow the format: `[Odoo Version].[Major].[Minor].[Patch]`.

-   **Odoo Version:** The major version of Odoo the module is built for (e.g., `18.0`).
-   **Major:** The major version of our custom module (e.g., `1`). This is incremented for breaking changes.
-   **Minor:** Incremented when new, backward-compatible features are added.
-   **Patch:** Incremented for backward-compatible bug fixes.

**Example:** The initial version for a new module for Odoo 18 would be `18.0.1.0.0`.

## 5. XML (Views & Data) Standards

-   **File Organization**: Separate views (`views/`), data (`data/`), and security (`security/`).
-   **XML IDs**: Use a consistent, readable pattern:
    -   **Views**: `view_<model_name_with_underscores>_<view_type>` (e.g., `view_evv_visit_form`, `view_evv_visit_segment_tree`).
    -   **Actions**: `action_<model_name_with_underscores>_<action_type>` (e.g., `action_evv_visit_window`).
    -   **Menus**: `menu_<location>_<name>` (e.g., `menu_evv_root`, `menu_evv_visits_all`).
-   **View Inheritance**:
    -   Use `xpath` expressions to modify existing views.
    -   Make selectors specific enough to be stable but not so specific they break easily.
    -   Add a comment to explain the purpose of the `xpath` expression.

## 6. JavaScript (OWL Framework) Standards

-   **`'use strict;'`**: Use at the beginning of all JS files.
-   **Linter**: Use a standard JS linter (e.g., JSHint, ESLint).
-   **Component Structure**: One component per file. Component names in `PascalCase`.
-   **Testability**: Add `data-testid` attributes to all key interactive elements to facilitate stable E2E tests.
-   **Static File Organization**: Place JS files in `static/src/js/`, OWL templates in `static/src/xml/`, and tour tests in `static/tests/tours/`.

## 7. CSS / SCSS Standards

-   **Class Naming**: Prefix all custom classes with `o_evv_`. For example, `.o_evv_visit_container`.
-   **Structure**: Follow the "Grandchild" approach for naming nested elements to avoid overly long and brittle selectors.
    ```css
    /* Good */
    .o_evv_visit { ... }
    .o_evv_segment { ... }
    .o_evv_segment_time { ... }

    /* Bad */
    .o_evv_visit_segments_list_item_time { ... }
    ```
-   **Variables**: Use SCSS variables for defining the design system and CSS variables for contextual adaptations.

## 8. Testing Standards

-   **Requirement**: All new features or bug fixes that alter business logic must be accompanied by corresponding tests.
-   **Framework**: Use Odoo's built-in testing framework, which is based on Python's `unittest`.
-   **Contract Tests**: For any changes impacting the CSV export, the contract tests in `tests/contracts/` must be updated and must pass.
-   **No PHI in Tests**: Test data must be synthetic and must never contain real Protected Health Information.
-   **Test Naming**: Test files should be prefixed with `test_` (e.g., `tests/test_visit_rounding.py`). Test methods within those files should also be prefixed with `test_`.
