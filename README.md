# BioDockify VPS Backup

Backup of Jarvis (OpenClaw) and BioDockify websites.

## Contents

- `openclaw.json` - OpenClaw main config
- `.claw.json` - OpenClaw identity
- `skills/` - All Jarvis skills
- `memory/` - Jarvis memory files
- `cloudvina/` - BioDockify website code
- `Caddyfile` - Web server config
- `.env.production` - Environment variables (remove secrets before pushing!)

## To Restore on New VPS

```bash
git clone https://github.com/tajo9128/biodockify-vps-backup.git
cd biodockify-vps-backup
chmod +x migrate.sh
sudo ./migrate.sh
```

## Note

- Remove sensitive data from `.env.production` before committing
- This backup was created on: 2026-02-20
