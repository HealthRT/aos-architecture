# Implementation Plan: Agent Test Isolation

**Date:** 2025-10-12  
**Status:** Approved - Ready to Implement  
**Target:** Complete Phase 1 this session  
**Related:** ADR-015 (Test Environment Isolation)

---

## 🎯 **Objective**

Provide each agent with an isolated Odoo test environment to prevent collisions, enable fearless parallel development, and future-proof for increased parallelization.

---

## 📐 **Architecture Design**

### **Chosen Approach: Work Order Scoped Containers**

Each work order gets its own isolated environment:

```
Work Order WO-042 (Hub, traction module)
├── Container: odoo_hub_wo042
├── Database: db_hub_wo042
├── Port: 8090
└── Volume: odoo-hub-wo042-data

Work Order WO-043 (Hub, hub_compliance module)
├── Container: odoo_hub_wo043
├── Database: db_hub_wo043
├── Port: 8092
└── Volume: odoo-hub-wo043-data

Work Order WO-050 (EVV, evv_visits module)
├── Container: odoo_evv_wo050
├── Database: db_evv_wo050
├── Port: 8091
└── Volume: odoo-evv-wo050-data
```

**Key Features:**
- ✅ Completely isolated (separate DB, separate container, separate volumes)
- ✅ No port conflicts (auto-assigned from range)
- ✅ Parallel-safe (agents can't interfere with each other)
- ✅ Clean teardown (remove container when work order complete)
- ✅ Simple agent workflow (one command to start)

---

## 🏗️ **Implementation Phases**

### **Phase 1: Docker Compose Infrastructure (This Session)**

**Goal:** Create reusable Docker Compose setup with work order scoping

**Deliverables:**
1. `docker-compose.agent.yml` template (for both Hub and EVV)
2. `scripts/start-agent-env.sh` - Start isolated environment
3. `scripts/stop-agent-env.sh` - Stop and cleanup environment
4. `scripts/list-agent-envs.sh` - Show all running agent environments
5. Updated Work Order Template (Section 2: Agent Environment Setup)

**Files to Create:**

#### Hub Repository
- `hub/docker-compose.agent.yml`
- `hub/scripts/start-agent-env.sh`
- `hub/scripts/stop-agent-env.sh`
- `hub/scripts/list-agent-envs.sh`

#### EVV Repository
- `evv/docker-compose.agent.yml`
- `evv/scripts/start-agent-env.sh`
- `evv/scripts/stop-agent-env.sh`
- `evv/scripts/list-agent-envs.sh`

---

### **Phase 2: Agent Training & Documentation (Next)**

**Goal:** Update all agent documentation and work order templates

**Deliverables:**
1. Updated Coder Agent Primer (Section 5: Proof of Execution)
2. Updated Work Order Template (Section 2: Development Environment)
3. Updated AGENT_ONBOARDING_CHECKLIST.md
4. Quick reference card (commands cheat sheet)

---

### **Phase 3: Port Management System (Future)**

**Goal:** Automated port allocation to prevent conflicts

**Deliverables:**
1. Port registry file (tracks assigned ports)
2. Auto-assign next available port
3. Port cleanup on environment teardown

---

## 💻 **Detailed Implementation: Phase 1**

### **1. Docker Compose Agent Template (Hub)**

**File:** `hub/docker-compose.agent.yml`

```yaml
# Docker Compose Agent Template for Hub
# Usage: WORK_ORDER=WO-042 PORT=8090 docker-compose -f docker-compose.agent.yml up -d

services:
  odoo:
    image: odoo:18.0
    container_name: odoo_hub_${WORK_ORDER:-default}
    depends_on:
      - db
    ports:
      - "${PORT:-8090}:8069"
    volumes:
      - ./etc:/etc/odoo
      - ./addons:/mnt/extra-addons
      - odoo-hub-${WORK_ORDER:-default}-data:/var/lib/odoo
    environment:
      - PASSWORD=odoo
      - USER=odoo
      - DBNAME=postgres_${WORK_ORDER:-default}
      - HOST=db
    networks:
      - agent_net_${WORK_ORDER:-default}
    
  db:
    image: postgres:15
    container_name: db_hub_${WORK_ORDER:-default}
    environment:
      - POSTGRES_DB=postgres_${WORK_ORDER:-default}
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo
    volumes:
      - db-hub-${WORK_ORDER:-default}-data:/var/lib/postgresql/data
    networks:
      - agent_net_${WORK_ORDER:-default}

networks:
  agent_net_${WORK_ORDER:-default}:
    driver: bridge

volumes:
  odoo-hub-${WORK_ORDER:-default}-data:
  db-hub-${WORK_ORDER:-default}-data:
```

### **2. Start Agent Environment Script (Hub)**

**File:** `hub/scripts/start-agent-env.sh`

```bash
#!/usr/bin/env bash
#
# start-agent-env.sh - Start isolated Odoo environment for a work order
#
# Usage: ./scripts/start-agent-env.sh WO-042 [port]
#
# Arguments:
#   $1: Work Order ID (e.g., WO-042)
#   $2: Port (optional, defaults to auto-assign)
#
# Example:
#   ./scripts/start-agent-env.sh WO-042 8090

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Work Order ID required${NC}"
    echo "Usage: $0 <WORK_ORDER_ID> [PORT]"
    echo "Example: $0 WO-042 8090"
    exit 1
fi

WORK_ORDER=$1
PORT=${2:-""}

# Auto-assign port if not provided
if [ -z "$PORT" ]; then
    echo -e "${BLUE}🔍 Auto-assigning port...${NC}"
    
    # Start from 8090, check if in use, increment if needed
    PORT=8090
    while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
        echo "   Port $PORT in use, trying next..."
        PORT=$((PORT + 1))
    done
    
    echo -e "${GREEN}   Assigned port: $PORT${NC}"
fi

# Check if environment already exists
if docker ps -a --format '{{.Names}}' | grep -q "odoo_hub_${WORK_ORDER}"; then
    echo -e "${YELLOW}⚠️  Environment for $WORK_ORDER already exists${NC}"
    echo "   To restart: docker-compose -f docker-compose.agent.yml restart"
    echo "   To stop: ./scripts/stop-agent-env.sh $WORK_ORDER"
    exit 1
fi

echo -e "${BLUE}🚀 Starting agent environment for $WORK_ORDER...${NC}"
echo "   Container: odoo_hub_${WORK_ORDER}"
echo "   Port: $PORT"
echo "   Database: postgres_${WORK_ORDER}"

# Export environment variables
export WORK_ORDER
export PORT

# Start services
docker-compose -f docker-compose.agent.yml up -d

# Wait for Odoo to be ready
echo -e "${BLUE}⏳ Waiting for Odoo to start...${NC}"
sleep 10

# Check if Odoo is running
if docker ps --format '{{.Names}}' | grep -q "odoo_hub_${WORK_ORDER}"; then
    echo -e "${GREEN}✅ Agent environment ready!${NC}"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}   Work Order: $WORK_ORDER${NC}"
    echo -e "${GREEN}   Access URL: http://localhost:$PORT${NC}"
    echo "   Database: postgres_${WORK_ORDER}"
    echo "   Username: admin"
    echo "   Password: admin"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Commands:"
    echo "  View logs:  docker logs -f odoo_hub_${WORK_ORDER}"
    echo "  Stop:       ./scripts/stop-agent-env.sh $WORK_ORDER"
    echo "  List all:   ./scripts/list-agent-envs.sh"
    echo ""
else
    echo -e "${RED}❌ Failed to start environment${NC}"
    echo "Check logs: docker-compose -f docker-compose.agent.yml logs"
    exit 1
fi
```

### **3. Stop Agent Environment Script (Hub)**

**File:** `hub/scripts/stop-agent-env.sh`

```bash
#!/usr/bin/env bash
#
# stop-agent-env.sh - Stop and cleanup isolated Odoo environment
#
# Usage: ./scripts/stop-agent-env.sh WO-042 [--cleanup]
#
# Arguments:
#   $1: Work Order ID (e.g., WO-042)
#   --cleanup: Remove volumes and networks (full cleanup)

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo -e "${RED}Error: Work Order ID required${NC}"
    echo "Usage: $0 <WORK_ORDER_ID> [--cleanup]"
    exit 1
fi

WORK_ORDER=$1
CLEANUP=false

if [ "$2" == "--cleanup" ]; then
    CLEANUP=true
fi

echo -e "${YELLOW}🛑 Stopping agent environment for $WORK_ORDER...${NC}"

# Export for docker-compose
export WORK_ORDER

# Stop containers
docker-compose -f docker-compose.agent.yml down

if [ "$CLEANUP" = true ]; then
    echo -e "${YELLOW}🗑️  Performing full cleanup (removing volumes)...${NC}"
    
    # Remove volumes
    docker volume rm "hub_odoo-hub-${WORK_ORDER}-data" 2>/dev/null || true
    docker volume rm "hub_db-hub-${WORK_ORDER}-data" 2>/dev/null || true
    
    # Remove network
    docker network rm "hub_agent_net_${WORK_ORDER}" 2>/dev/null || true
    
    echo -e "${GREEN}✅ Full cleanup complete${NC}"
else
    echo -e "${GREEN}✅ Environment stopped (volumes preserved)${NC}"
    echo "   To fully cleanup: $0 $WORK_ORDER --cleanup"
fi
```

### **4. List Agent Environments Script (Hub)**

**File:** `hub/scripts/list-agent-envs.sh`

```bash
#!/usr/bin/env bash
#
# list-agent-envs.sh - List all running agent environments

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Active Agent Environments (Hub)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Find all Hub agent containers
CONTAINERS=$(docker ps --filter "name=odoo_hub_WO-" --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}")

if [ -z "$CONTAINERS" ]; then
    echo "No active agent environments found."
    echo ""
    echo "Start one with: ./scripts/start-agent-env.sh WO-XXX"
else
    echo "$CONTAINERS"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
```

---

## 🔄 **Agent Workflow Updates**

### **Before (Shared Environment):**

```bash
cd hub/
docker-compose up -d  # All agents share this
# Risk: Agent A and Agent B interfere
```

### **After (Isolated Environment):**

```bash
cd hub/
./scripts/start-agent-env.sh WO-042
# Agent gets: http://localhost:8090 (auto-assigned)
# Work → Test → Commit
./scripts/stop-agent-env.sh WO-042
```

### **Work Order Template Update:**

**Section 2 becomes:**

```markdown
## 2. Development Environment

### Agent Environment Setup

**BEFORE starting work, create your isolated test environment:**

```bash
cd [target-repo]/
./scripts/start-agent-env.sh [WORK_ORDER_ID]

# Example:
cd hub/
./scripts/start-agent-env.sh WO-042
```

**Your environment:**
- Container: `odoo_[repo]_[work_order]`
- Access URL: Shown in script output (e.g., http://localhost:8090)
- Database: `postgres_[work_order]`
- Credentials: admin / admin

**When finished:**
```bash
./scripts/stop-agent-env.sh [WORK_ORDER_ID]

# Full cleanup (remove data):
./scripts/stop-agent-env.sh [WORK_ORDER_ID] --cleanup
```
```

---

## 📊 **Implementation Timeline**

### **Phase 1: Core Infrastructure (This Session - ~2 hours)**

| Task | Time | Owner |
|------|------|-------|
| Create docker-compose.agent.yml (Hub) | 15 min | Claude |
| Create start-agent-env.sh (Hub) | 20 min | Claude |
| Create stop-agent-env.sh (Hub) | 15 min | Claude |
| Create list-agent-envs.sh (Hub) | 10 min | Claude |
| Test Hub scripts | 15 min | James |
| Replicate for EVV | 20 min | Claude |
| Test EVV scripts | 15 min | James |
| Update ADR-015 status | 5 min | Claude |
| Commit and document | 10 min | Claude |

**Total: ~2 hours**

### **Phase 2: Documentation (Next Session - ~1 hour)**

- Update Coder Agent Primer
- Update Work Order Template
- Update AGENT_ONBOARDING_CHECKLIST.md
- Create quick reference card

### **Phase 3: Port Management (Future - ~3 hours)**

- Port registry system
- Auto-allocation improvements
- Conflict detection

---

## ✅ **Success Criteria**

**Phase 1 Complete When:**
- [ ] Two agents can run isolated environments simultaneously (same repo)
- [ ] Scripts work in both Hub and EVV repositories
- [ ] No port conflicts when running multiple environments
- [ ] Clean startup (<30 seconds)
- [ ] Clean teardown (containers removed)
- [ ] Volumes preserved between stops (unless --cleanup)
- [ ] Documentation updated

**Validation Test:**
```bash
# Terminal 1
cd hub/
./scripts/start-agent-env.sh WO-042 8090

# Terminal 2  
cd hub/
./scripts/start-agent-env.sh WO-043 8092

# Both should work, no interference
# Access http://localhost:8090 and http://localhost:8092
```

---

## 🚀 **Ready to Implement?**

**I can start creating these files RIGHT NOW if you approve.**

**Decision Points:**
1. ✅ Proceed with Phase 1 implementation? (Recommended: YES)
2. Port range: Start at 8090 for Hub, 8091 for EVV, increment as needed? (Recommended: YES)
3. Auto-cleanup on stop, or preserve volumes by default? (Recommended: Preserve, cleanup optional)

**Your call - should I proceed with implementation?**

