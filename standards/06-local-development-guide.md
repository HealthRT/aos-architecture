# 6. Local Development & Testing Guide

**Status:** Accepted
**Author:** Executive Architect
**Date:** 2025-10-07

## 1. Purpose

This document provides a "Quick Start" guide for setting up and validating changes in the local development environment for the Agency Operating System (AOS) project. All developers, including AI Coder Agents, must use this guide to test their work.

This guide is the official implementation reference for the validation checks required in the "Definition of Done" (as defined in `03-ai-agent-workflow.md`).

## 2. Environment Setup

### Prerequisites
-   You must have `docker` and `docker-compose` installed and running in your environment.

### Starting the Local Environment
The project root contains a `docker-compose.yml` file that defines the complete Odoo environment for the Hub.

To start the services (Odoo and PostgreSQL database) in the background, run the following command from the project root (`/home/james/development/aos-development`):
```bash
docker-compose up -d
```
After the first run, the Odoo instance will be available in your browser at `http://localhost:8090`.

## 3. Mandatory Validation Workflow

Before handing off any work or submitting a Pull Request, you **must** validate that your module changes have not broken the installation process.

### Step 1: Find the Database Name
The default database name is `postgres`. You can confirm this by checking the running containers:
```bash
docker-compose ps
```
Look for the name of the database container (e.g., `db_hub`). The database name is usually specified in the `docker-compose.yml` environment variables.

### Step 2: Run the Validation Command
Execute the following command from the project root. This command attempts to update your module within the running Odoo instance and will exit with an error if the installation fails.

Replace `<your_module_name>` with the name of the Odoo module you have been working on (e.g., `traction_eos_odoo`).

```bash
docker-compose exec odoo odoo -c /etc/odoo/odoo.conf -d postgres -u <your_module_name> --stop-after-init
```

### Step 3: Verify the Result
-   A **successful** validation will complete and your terminal will show a `0` exit code.
-   A **failed** validation will print a Python traceback/error and exit with a non-zero code. You must debug and fix this error before proceeding.

## 4. Debugging

To view the real-time logs from the Odoo container to debug an installation failure or other runtime error, use the following command:
```bash
docker-compose logs -f odoo
```
This will "follow" the log, showing you new output as it's generated. Use `Ctrl+C` to stop following the log. It is best practice to review clean logs for each run to avoid confusion.
