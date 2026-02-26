# VPS Analysis - 2026-02-25

## System Overview

**Host:** vmi3097749 (Contabo VPS)
**IP:** 217.76.55.124
**OS:** Ubuntu 24.04 (Linux 6.8.0-100-generic)
**Uptime:** 4 days, 6 hours
**Users:** 2 (root + biodockify)

### Hardware
- **CPU:** Load: 0.38, 0.19, 0.12 (light)
- **RAM:** 7.8GB total, 3.1GB used, 4.6GB available (39% usage)
- **Disk:** 145GB total, 80GB used, 65GB free (56% usage)
- **Swap:** None configured

### Network
- **SSH:** Port 22, running (password auth enabled)
- **HTTP:** Port 80 (Caddy)
- **HTTPS:** Port 443 (Caddy)
- **Firewall:** ufw active, allows 22, 80, 443

## Services Running

### System Services
- **caddy.service** - Reverse proxy & SSL (3 days uptime)
- **docker.service** - Container orchestration
- **ssh.service** - SSH server

### Docker Containers (8 running)

| Container | Status | Ports | Image | Purpose |
|-----------|--------|-------|-------|---------|
| biodockify-postgres | Up 47h | 5432 | postgres:16-alpine | PostgreSQL database |
| biodockify-ai-web | Up 2d | 8082 | nginx:alpine | AI web interface |
| portainer | Up 3d | 9000, 9443 | portainer-ce | Docker management UI |
| netdata | Up 3d (healthy) | 19999 | netdata | System monitoring |
| uptime-kuma | Up 3d (healthy) | 3002 | uptime-kuma | Uptime monitoring |
| biodockify-worker | Up 43m | - | biodockify-worker | Queue processor |
| biodockify-learn-backend | Up 3d | 8001 | biodockify-learn | Learn platform backend |
| biodockify-web | Up 3d | 8080 | biodockify-web | Main web frontend |
| biodockify-api | Up 47h (healthy) | 8000 | biodockify-api | Main API backend |

### Docker Images
- **netdata:** 1.61GB
- **biodockify-*/worker:** 2.37GB each
- **postgres:** 395MB
- **portainer:** 242MB
- **uptime-kuma:** 724MB

## Caddy Configuration

Domains routed:
- `biodockify.com, www.biodockify.com, ai.biodockify.com` → `localhost:8080` (Main web)
- `learn.biodockify.com` → `localhost:8001` (Learn backend)
- `api.biodockify.com` → `localhost:8000` (API)
- `uptime.biodockify.com` → `localhost:3002` (Uptime Kuma)
- `monitor.biodockify.com` → `localhost:19999` (NetData)
- `portainer.biodockify.com` → `localhost:9000` (Portainer)
- `mission.biodockify.com` → `localhost:3001` (Mission Control - NOT RUNNING)

SSL Email: cloudvina2025@gmail.com

## Project Structure

**Main Project:** `/home/biodockify/`
- **docker-compose.yml** - Main orchestration
- **api/** - Backend (FastAPI)
- **web/** - Frontend (React)
- **jobs/** - Job storage (empty)
- **logs/** - Application logs
- **scripts/** - Maintenance scripts
- **old_backup/** - Backup directory
- **mailserver/** - Mail server config
- **cloudvina/** - Cloud Vina project
- **openclaw-mission-control/** - Mission control (not active)

### Storage
- `/mnt/md-active/` - Active MD jobs (empty, not mounted)
- `/mnt/md-archive/` - Archived MD jobs (empty, not mounted)
- Both are directories on main disk, NOT separate mounts

## Automation

### Cron Jobs
```bash
*/5 * * * * /home/biodockify/scripts/healthcheck.sh >> /home/biodockify/logs/healthcheck.log 2>&1
0 2 * * * /home/biodockify/.openclaw/workspace/jarvis-backup/backup.sh >> /home/biodockify/.openclaw/workspace/jarvis-backup/cron.log 2>&1
```

### Health Check Script
- Runs every 5 minutes
- Monitors all containers
- Checks for failed containers
- **Issue:** `openclaw-mission-control-frontend-1` is failing (container doesn't exist)

## OpenClaw
- **Gateway running:** Yes (PID 1450966)
- **User:** biodockify
- **Workspace:** `/home/biodockify/.openclaw/workspace`
- **Uptime:** Since Feb 24

## Issues & Observations

1. **Mission Control Frontend Missing:** Health check tries to restart `openclaw-mission-control-frontend-1` which doesn't exist
2. **No Swap:** 0B swap configured - could be an issue under heavy load
3. **Storage:** `/mnt/md-*` directories are not mounted - MD jobs would use main disk
4. **Database:** External PostgreSQL on 149.102.141.216:25432 (BillionMail shared container)
5. **NetData High CPU:** 8.27% - might need optimization

## Security

- SSH password auth enabled (user: biodockify, pass: tajudinshaik)
- Root SSH login disabled (`PermitRootLogin no`)
- Firewall active with minimal ports open
- No obvious security issues

## Recommendations

1. Fix health check script to ignore non-existent mission-control container
2. Add swap file (2-4GB) for better memory management
3. Configure proper storage for `/mnt/md-active` and `/mnt/md-archive` if needed
4. Optimize NetData configuration or resource usage
5. Set up proper SSH key-based auth instead of passwords
6. Consider automated backups for critical data (API database, jobs, logs)

## Access URLs

- **Main site:** https://biodockify.com
- **API:** https://api.biodockify.com
- **Learn:** https://learn.biodockify.com
- **Monitor:** https://monitor.biodockify.com (NetData)
- **Uptime:** https://uptime.biodockify.com (Uptime Kuma)
- **Portainer:** https://portainer.biodockify.com
- **Mission Control:** https://mission.biodockify.com (NOT RUNNING)

## User Info

- **User:** biodockify (uid 1000)
- **Can sudo:** Yes (sudo su - to root)
- **Home:** /home/biodockify
- **Shell:** bash
- **Tools:** git, docker, node, python3, bun, npm
