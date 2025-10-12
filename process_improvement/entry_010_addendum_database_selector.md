# Entry #010 Addendum: Odoo 18 Database Selector Issue

**Date:** 2025-10-12  
**Related:** Entry #010 (Boot Test Wrong Environment + Uninitialized Database)  
**Status:** Workaround Implemented, Investigating Permanent Fix  
**Severity:** 🟡 **MEDIUM** (Has workaround, blocks convenience not functionality)

---

## 🔄 **Follow-Up Issue Discovered**

After fixing the manifest syntax and initializing the database (Entry #010), user attempted Pre-UAT testing and encountered:

**Symptom:** Odoo shows database selector/creation wizard instead of login page  
**Tested:** Incognito windows (not a caching issue)  
**Environment:** EVV Odoo on http://localhost:8091

---

## 🔍 **Investigation**

### **Configuration Applied (Correct):**

```ini
# evv/etc/odoo.conf
[options]
db_name = postgres
dbfilter = ^postgres$
list_db = False
```

```yaml
# evv/docker-compose.yml
command: ["odoo", "-c", "/etc/odoo/odoo.conf", "--db-filter=^postgres$$"]
```

### **Verification:**

✅ **Config file is being loaded:**
```bash
$ docker exec odoo_evv ps aux | grep odoo
/usr/bin/python3 /usr/bin/odoo -c /etc/odoo/odoo.conf --db-filter=^postgres$ ...
```

✅ **Database exists and is initialized:**
```bash
$ docker exec db_evv psql -U odoo -l
postgres  | odoo  | UTF8  # ← EXISTS

$ docker exec db_evv psql -U odoo -d postgres -c "SELECT COUNT(*) FROM ir_module_module;"
 count 
-------
   128   # ← INITIALIZED
```

✅ **Admin user exists:**
```bash
$ docker exec db_evv psql -U odoo -d postgres -c "SELECT login FROM res_users WHERE id=2;"
 login 
-------
 admin  # ← ADMIN USER EXISTS
```

✅ **Only 3 databases exist** (postgres + 2 templates):
```bash
$ docker exec db_evv psql -U odoo -l | grep -E "(postgres|template)" | wc -l
3  # ← Should trigger dbfilter
```

### **Unexpected Behavior:**

❌ **Despite correct configuration, Odoo redirects to database selector:**
```bash
$ curl -I http://localhost:8091/web/login
Location: /web/database/selector  # ← SHOULD GO TO LOGIN
```

❌ **Even with explicit database parameter:**
```bash
$ curl -s "http://localhost:8091/web?db=postgres"
<title>Redirecting...</title>  # ← STILL REDIRECTING
```

---

## 🤔 **Root Cause Hypothesis**

### **Possible Causes:**

1. **Odoo 18 Behavior Change:**
   - Odoo 18 (20250918 build) may have changed database selector logic
   - `dbfilter` may require different regex syntax in Odoo 18
   - `list_db = False` may not be sufficient alone

2. **Multi-Database Detection:**
   - Odoo might be detecting multiple databases across Docker network
   - Hub (odoo_hub) and EVV (odoo_evv) share Docker networks potentially
   - Database filter might not be applied to connection initialization

3. **Configuration Precedence:**
   - Command-line args (`--db-filter`) might not override config file
   - Or vice versa - conflict between the two settings
   - Environment variables from Docker image might take precedence

4. **Session/Cookie Issue:**
   - Previous sessions without database parameter cached
   - Cookie domain/path settings interfering
   - (BUT: User tested in incognito, so less likely)

---

## ✅ **Workaround Implemented**

### **Solution: Access with Database Name in URL**

**Working URL:**
```
http://localhost:8091/web/login?db=postgres
```

**Documented in:**
- `evv/QUICK_START.md` - Instructions for Pre-UAT testing
- Pre-UAT checklist updated to use direct URL

### **Impact:**

✅ **Functional:** User can access Odoo and perform Pre-UAT testing  
⚠️ **Inconvenient:** Must remember to add `?db=postgres` to URL  
⚠️ **Training:** All agents and users need to know about this workaround

---

## 🛠️ **Configuration Improvements Implemented**

### **All Repositories and Environments Updated:**

| Repository/Environment | Config File | Docker Compose | Init Script | Status |
|------------------------|-------------|----------------|-------------|--------|
| **Hub (main)** | ✅ dbfilter + list_db=False | ✅ Uses config file | ✅ Auto-init | ✅ Complete |
| **EVV (main)** | ✅ dbfilter + list_db=False | ✅ Uses config file | ✅ Auto-init | ✅ Complete |
| **Hub (agent isolated)** | ✅ Uses shared config | ✅ Uses config file | ✅ Auto-detect + init | ✅ Complete |
| **EVV (agent isolated)** | ✅ Uses shared config | ✅ Uses config file | ✅ Auto-detect + init | ✅ Complete |

### **Files Updated:**

**Hub:**
- `hub/etc/odoo.conf` - Added dbfilter and list_db=False
- `hub/docker-compose.yml` - Explicit config file loading
- `hub/docker-compose.agent.yml` - Config file, no env vars
- `hub/scripts/start-agent-env.sh` - Auto-initialize database
- `hub/scripts/init-database.sh` - Manual init script

**EVV:**
- `evv/etc/odoo.conf` - Added dbfilter and list_db=False
- `evv/docker-compose.yml` - Explicit config file loading
- `evv/docker-compose.agent.yml` - Config file, no env vars
- `evv/scripts/start-agent-env.sh` - Auto-initialize database
- `evv/scripts/init-database.sh` - Manual init script
- `evv/QUICK_START.md` - Workaround documentation

---

## 🎯 **Next Steps for Permanent Fix**

### **Option A: Investigate Odoo 18 Specific Settings**

Research if Odoo 18 requires different dbfilter configuration:
- Check Odoo 18 release notes for database selector changes
- Test different dbfilter regex patterns
- Test `db_filter` vs `dbfilter` parameter names

### **Option B: Custom Entrypoint Script**

Create custom Docker entrypoint that:
- Forces database selection before Odoo starts
- Disables database manager module
- Patches Odoo code to skip selector check

### **Option C: Nginx Reverse Proxy**

Add Nginx layer that:
- Automatically appends `?db=postgres` to URLs
- Redirects `/web` to `/web?db=postgres`
- Transparent to users

### **Option D: Accept Workaround**

Document `?db=postgres` requirement as standard procedure:
- Update all documentation with direct URLs
- Train agents to use direct URLs
- Accept this as Odoo 18 behavior

---

## 📊 **Impact Assessment**

### **Current State:**

| Aspect | Status | Impact |
|--------|--------|--------|
| **Pre-UAT Testing** | ✅ Unblocked | Can proceed with workaround |
| **Agent Development** | ✅ Unblocked | start-agent-env.sh auto-inits |
| **User Experience** | ⚠️ Degraded | Must remember URL parameter |
| **Documentation** | ✅ Updated | Quick start guide created |
| **Configuration** | ✅ Hardened | All envs use config files |

### **Priority:**

🟡 **MEDIUM** - Has functional workaround, investigate permanent fix during next architecture session

---

## 💡 **Lessons Learned**

### **1. Odoo Version Behavior Changes**

New Odoo versions may change behavior of existing configurations.

**Takeaway:** Test configuration changes against actual Odoo version, not just documentation.

### **2. Environment Parity Important**

Hub and EVV should have identical configuration patterns.

**Takeaway:** Applied same config approach to both environments proactively.

### **3. Auto-Initialization Prevents Issues**

Database initialization was manual, caused user to see database wizard.

**Takeaway:** All environment startup scripts now auto-detect and initialize if needed.

### **4. Workarounds Need Documentation**

Even temporary workarounds need clear, accessible documentation.

**Takeaway:** Created `QUICK_START.md` for immediate user reference.

---

## 🔗 **Related**

- **Entry #010:** Boot Test Wrong Environment + Uninitialized Database
- **ADR-015:** Test Environment Isolation (why isolated envs need auto-init)
- **AGMT-001:** Service Agreement Pre-UAT (blocked by this issue)

---

## 📝 **Status Tracking**

- [x] Database selector issue identified
- [x] Configuration verified correct
- [x] Workaround implemented and documented
- [x] All environments updated with consistent config
- [x] Auto-initialization added to isolated environment scripts
- [ ] Permanent fix investigation (scheduled for next architecture session)
- [ ] Test permanent fix (when implemented)
- [ ] Remove workaround documentation (when permanent fix deployed)

---

**Recommendation:** Proceed with Pre-UAT testing using workaround URL. Schedule investigation of permanent fix for next architecture session (not blocking current work).


