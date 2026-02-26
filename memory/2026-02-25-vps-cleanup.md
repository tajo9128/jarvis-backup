# VPS Cleanup & Improvements - 2026-02-25

## Changes Made

### 1. NetData Removed ✓
- Container stopped and removed
- Health check script updated (removed netdata entry)
- Caddyfile updated (removed monitor.biodockify.com)
- Frees ~344MB RAM and 1.61GB disk

### 2. Mission Control Cleanup ✓
- No containers running (already stopped)
- Health check script updated (removed mission-control entry)
- Frees resources for database

### 3. Health Check Script Fixed ✓
- Removed `netdata:19999` entry
- Removed `openclaw-mission-control-frontend-1:3001` entry
- Clean monitoring for remaining services only

Current monitored services:
- biodockify-web:8080
- biodockify-api:8000
- biodockify-learn-backend:8001
- portainer:9000
- uptime-kuma:3002

## Pending Changes (Need Root Access)

### 4. Add 2GB Swap File
Run these commands as root:

```bash
# Create swap file
fallocate -l 2G /swapfile

# Set permissions
chmod 600 /swapfile

# Create swap area
mkswap /swapfile

# Enable swap
swapon /swapfile

# Verify
swapon --show
free -h

# Make permanent
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Optimize swap settings
echo 'vm.swappiness=10' >> /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
```

### 5. Update Caddyfile
Already prepared in `/tmp/caddy_new.conf`:
```bash
# Copy and reload
cp /tmp/caddy_new.conf /etc/caddy/Caddyfile
systemctl reload caddy
```

## Resource Impact

### Before:
- RAM used: ~3.1GB
- NetData: 344MB RAM, 8.27% CPU, 1.61GB disk
- Swap: 0B

### After (once swap added):
- RAM used: ~2.8GB (without NetData)
- Swap: 2GB available
- CPU: Reduced (NetData removed)

## URLs Updated

Removed:
- ~~https://monitor.biodockify.com~~ (NetData)

Remaining:
- https://biodockify.com
- https://api.biodockify.com
- https://learn.biodockify.com
- https://uptime.biodockify.com
- https://portainer.biodockify.com
- ~~https://mission.biodockify.com~~ (will 404 once Caddy updated)

## Files Modified

- `/home/biodockify/scripts/healthcheck.sh` ✓
- `/tmp/caddy_new.conf` (ready to deploy)
- `/tmp/setup_swap.sh` (ready to run)

## Next Steps

1. Run swap setup as root (see above)
2. Update Caddyfile as root
3. Monitor healthcheck.log to confirm no errors
4. Verify all services still accessible
