# Pre-Commit Hooks - Hub Repository

**Status:** ✅ ACTIVE as of 2025-10-09  
**Tool Version:** pre-commit 4.3.0

---

## 📋 What Are Pre-Commit Hooks?

Automated code quality checks that run **before each commit**, catching issues early in the development cycle.

**Benefits:**
- Instant feedback on code quality
- Catches common mistakes before review
- Enforces consistent style
- Prevents architectural violations

---

## 🔧 What Gets Checked?

### Basic Checks
- **YAML syntax** - Validates YAML files
- **JSON syntax** - Validates JSON files
- **End of file** - Ensures files end with newline
- **Trailing whitespace** - Removes extra whitespace
- **Large files** - Prevents commits > 500KB
- **Merge conflicts** - Detects unresolved conflicts

### Python Quality
- **Black** - Auto-formats Python code (PEP 8)
- **Flake8** - Lints Python code (style, complexity)
- **Pylint** - Comprehensive linting (includes Odoo plugin)
- **Mypy** - Static type checking

### Custom Odoo Checks
- **sudo() usage** - Warns about dangerous sudo() calls
- **Hardcoded company IDs** - Prevents multi-tenancy violations

---

## 🚀 For Developers

### Installation (One-Time Setup)

```bash
cd /home/james/development/aos-development/hub
pip install pre-commit  # or: pipx install pre-commit
pre-commit install
```

### Normal Usage

**Hooks run automatically on commit:**
```bash
git commit -m "your message"
# Hooks run automatically
# If hooks fail, commit is blocked
# Fix issues and try again
```

**Run hooks manually (before commit):**
```bash
pre-commit run --all-files  # Check all files
pre-commit run --files file1.py file2.py  # Check specific files
```

**Skip hooks (EMERGENCY ONLY):**
```bash
git commit --no-verify -m "emergency fix"
```

⚠️ **Only use `--no-verify` for true emergencies**

---

## 🤖 For AI Agents

Pre-commit hooks will:
- ✅ Give you instant feedback on code quality
- ✅ Auto-fix formatting issues (Black, whitespace)
- ✅ Catch common mistakes before review
- ✅ Enforce Odoo best practices
- ✅ Prevent architectural violations

**If hooks fail:**
1. Read the error message carefully
2. Fix the issue in your code
3. Stage the changes: `git add .`
4. Commit again

**Common Failures:**
- **Unused imports** → Remove them
- **Line too long** → Break into multiple lines (max 120 chars)
- **Unused variables** → Remove or prefix with `_` if intentional
- **Translation formatting** → Use named placeholders in `_()`

**DON'T skip hooks** unless absolutely necessary and document why.

---

## 📊 Current Status

### ✅ Activated
- Pre-commit hooks installed: `.git/hooks/pre-commit`
- Configuration: `.pre-commit-config.yaml`
- All hooks initialized and cached

### ⚠️ Existing Code Issues

**Note:** Pre-commit hooks found **150+ existing issues** in the codebase:

- **Flake8:** 45+ issues (unused imports, line length, unused variables)
- **Pylint:** 100+ issues (manifest format, translations, Odoo patterns)
- **Mypy:** 1 issue (missing type stubs for requests)

**These are pre-existing issues, NOT introduced by pre-commit.**

### 🎯 Strategy

**For New Code (Going Forward):**
- ✅ All new code MUST pass pre-commit hooks
- ✅ No commits allowed with hook failures
- ✅ Agents must fix issues before commit

**For Existing Code:**
- ⏳ Will be cleaned up gradually
- ⏳ Separate cleanup task (not blocking current work)
- ⏳ Priority: Fix as you touch files

---

## 🛠️ Configuration

### Location
`.pre-commit-config.yaml`

### Customization

**To adjust max line length:**
```yaml
- id: flake8
  args: ['--max-line-length=120']  # Change 120 to desired length
```

**To exclude files:**
```yaml
- id: pylint
  exclude: 'tests/|migrations/|legacy/'
```

**To disable a specific check:**
```yaml
- id: flake8
  args: ['--extend-ignore=E501']  # Ignore line-length
```

---

## 🐛 Troubleshooting

### Hooks not running?
```bash
pre-commit install  # Reinstall
```

### Hooks too slow?
```bash
pre-commit run --files specific_file.py  # Run on specific files only
```

### Need to update hooks?
```bash
pre-commit autoupdate  # Update to latest versions
```

### False positives?
Update `.pre-commit-config.yaml` to adjust rules or add exclusions.

---

## 📈 Impact & Benefits

**Since Activation (2025-10-09):**

**Auto-Fixes Applied:**
- 22 files: End-of-file issues fixed
- 35 files: Trailing whitespace removed
- 1 file: Black formatting applied

**Issues Detected:**
- 150+ existing code quality issues identified
- 6 Odoo-specific anti-patterns found
- Prevents new issues from being committed

**Time Savings:**
- Instant feedback (vs waiting for PR review)
- Auto-fixes save manual editing
- Catches bugs before they reach production

---

## 🎓 Learning Resources

- **Pre-commit docs:** https://pre-commit.com/
- **Black:** https://black.readthedocs.io/
- **Flake8:** https://flake8.pycqa.org/
- **Pylint:** https://pylint.pycqa.org/
- **Pylint-Odoo:** https://github.com/OCA/pylint-odoo

---

## 🔄 Maintenance

**Regular Tasks:**
- **Monthly:** Run `pre-commit autoupdate` to get latest hook versions
- **As needed:** Adjust configuration based on team feedback
- **Quarterly:** Review and update custom hooks

**Owner:** Development Team  
**Last Updated:** 2025-10-09  
**Version:** 1.0

---

**Questions?** See `.pre-commit-config.yaml` for configuration details or ask the team.

✨ **Happy coding with pre-commit!** ✨

