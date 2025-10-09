# 5. Odoo Development Best Practices

**Status:** Accepted
**Author:** Executive Architect (Synthesized from AI Coder Agent Findings)
**Date:** 2025-10-07

## 1. Purpose

This document captures a set of practical, "in the trenches" best practices for Odoo development, specifically related to debugging and validating module changes. These rules were synthesized from the learnings of an AI Coder Agent during a complex refactoring task.

All Coder Agents are required to consult and apply these techniques to improve the quality of their work and the efficiency of their debugging process.

## 2. Core Principles & Techniques

### 2.1. Treat Declarative Data as Code

Odoo's XML and CSV files (for views, data, and security) are a form of declarative programming and must be treated with the same rigor as Python code. The order of records is critical.

-   **Rule:** Before referencing a resource (e.g., a `security.group` in an `ir.model.access.csv` file, or a `record` in a view), you must ensure it has been defined earlier in the same file or in a file that is loaded *before* the current one in the `__manifest__.py`.
-   **Debugging:** If you encounter an "External ID not found" error during module installation, the **first thing you should check** is the order of the XML and CSV files in the `__manifest__.py`.

### 2.2. Respect Manifest Ordering

The order of files listed in the `__manifest__.py`'s `data` key is the exact order in which Odoo will load them.

-   **Rule:** Always list files in dependency order. For example, security group definitions must come before the `ir.model.access.csv` that uses them. Model definitions are handled by Python, but all XML/CSV data files must be manually ordered.

### 2.3. Automate Installation Validation

Do not rely solely on the Odoo server booting up. A running server does not mean a module is installable.

-   **Mandatory Check:** Before handing off any work, you must validate that your module can be successfully installed or upgraded from the command line. Use the following command:
    ```bash
    odoo -c /etc/odoo/odoo.conf -d <database_name> -u <your_module_name> --stop-after-init
    ```
-   **Verification:** A successful run of this command will exit with a `code 0`. A non-zero exit code indicates an error during installation that must be fixed. For tricky data loading issues, use `-i <your_module_name>` to perform a full re-installation.

### 2.4. Practice Good Log Hygiene

Odoo logs can be noisy. It is critical to work with clean logs to avoid confusing old errors with new ones.

-   **Rule:** Before running a validation command (like the one above), clear or tail the Odoo log file.
-   **Debugging:** When an error occurs, focus on the first traceback you see after the point where your module starts loading. Ignore harmless warnings (like deprecation notices) and focus on fatal errors (e.g., `ParseError`, `IntegrityError`, `KeyError`).
