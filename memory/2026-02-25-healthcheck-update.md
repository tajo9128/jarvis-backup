# VPS Health Check Update - 2026-02-25

## Changes Made

### 1. New Health Check Script ✓
**File:** `/home/biodockify/scripts/healthcheck-all.sh`

**Features:**
- Auto-discovers ALL running Docker containers dynamically
- No hardcoded service names - works with any container
- Smart health checks:
  - HTTP health endpoints for web services
  - Docker health status for non-HTTP containers
  - Status check for worker/background processes
- Skips database containers (postgres, redis) - they use Docker health checks
- Logs detailed status with port and endpoint info

**Health Check Priority Order:**
1. `/health`
2. `/healthz`
3. `/api/health`
4. `/api/status`
5. `/api/system/status`
6. `/`

### 2. Crontab Updated ✓

**Before:**
```bash
*/5 * * * * /home/biodockify/scripts/healthcheck.sh >> /home/biodockify/logs/healthcheck.log 2>&1
```

**After:**
```bash
*/30 * * * * /home/biodockify/scripts/healthcheck-all.sh >> /home/biodockify/logs/healthcheck.log 2>&1
```

**Changes:**
- Interval: 5 minutes → **30 minutes**
- Script: `healthcheck.sh` → `healthcheck-all.sh`

## Benefits

1. **Automatic Monitoring:** Any new container is auto-monitored without code changes
2. **Less Frequent Checks:** 30-minute intervals reduce load while still catching issues
3. **Better Coverage:** Monitors ALL containers, not just a fixed list
4. **Smarter Checks:** Multiple health endpoint fallbacks
5. **Database Safe:** Won't restart databases due to failed HTTP checks

## Root Crontab (Pending)

The root crontab also has the old healthcheck script. Update it as root:

```bash
# View current root crontab
sudo crontab -l

# Update to use new script and 30-minute interval
echo "*/30 * * * * /home/biodockify/scripts/healthcheck-all.sh >> /home/biodockify/logs/healthcheck.log 2>&1" | sudo crontab -
```

## Test Results

Last test output (all containers passing):
```
[2026-02-25 10:06:20] === Starting health check for all containers ===
[2026-02-25 10:06:20] ✓ biodockify-postgres is running
[2026-02-25 10:06:20] ✓ biodockify-ai-web is healthy (8082/health)
[2026-02-25 10:06:20] ✓ portainer is healthy (9000/api/status)
[2026-02-25 10:06:20] ✓ uptime-kuma is healthy (3002/health)
[2026-02-25 10:06:20] ✓ biodockify-worker is running
[2026-02-25 10:06:20] ✓ biodockify-learn-backend is healthy (8001/health)
[2026-02-25 10:06:20] ✓ biodockify-web is healthy (8080/health)
[2026-02-25 10:06:20] ✓ biodockify-api is healthy (8000/health)
[2026-02-25 10:06:20] === Health check completed ===
```

## How It Works

1. **Discovery:** Lists all running Docker containers
2. **Classification:** Identifies container type (web, worker, database)
3. **Health Check:**
   - Web services: HTTP request to common health endpoints
   - Workers/Databases: Docker health status or running state
4. **Action:** Restarts unhealthy containers
5. **Logging:** Writes detailed status to log file

## Logs

**Location:** `/home/biodockify/logs/healthcheck.log`

**Example output:**
```
[2026-02-25 10:06:20] === Starting health check for all containers ===
[2026-02-25 10:06:20] ✓ biodockify-api is healthy (8000/health)
[2026-02-25 10:06:20] ✓ biodockify-worker is running
[2026-02-25 10:06:20] === Health check completed ===
```

## Maintenance

### Adding New Container
No changes needed! The script auto-discovers new containers.

### Adding New Health Endpoint
Edit `/home/biodockify/scripts/healthcheck-all.sh` and add to `HEALTH_ENDPOINTS` array.

### Changing Interval
Update crontab:
```bash
# Example: change to 15 minutes
echo "*/15 * * * * /home/biodockify/scripts/healthcheck-all.sh >> /home/biodockify/logs/healthcheck.log 2>&1" | crontab -
```

## Old Script

**File:** `/home/biodockify/scripts/healthcheck.sh`

Status: Still present but no longer used by crontab. Can be deleted after confirming new script works well.

## Next Steps

1. Run as root to update root's crontab (see above)
2. Monitor logs over 24 hours to confirm stability
3. Delete old `healthcheck.sh` after 1-2 days of stable operation
4. Optional: Add alerting (email/Telegram) for failed containers

## File Summary

| File | Status | Purpose |
|------|--------|---------|
| `healthcheck-all.sh` | ✓ Active | New auto-discovery health check |
| `healthcheck.sh` | ○ Deprecated | Old hardcoded health check |
| `healthcheck.log` | ✓ Active | Health check logs |
| `crontab` (biodockify) | ✓ Updated | 30-minute interval |
| `crontab` (root) | ⚠️ Pending | Needs update |
