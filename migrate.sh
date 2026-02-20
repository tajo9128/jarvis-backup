#!/bin/bash
# BioDockify Jarvis Migration Script
# Run this on the NEW VPS to restore everything

set -e

echo "=== BioDockify Jarvis Migration ==="
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo"
    exit 1
fi

echo "Step 1: Installing prerequisites..."
apt-get update -qq
apt-get install -y -qq git curl docker.io docker-compose caddy

echo ""
echo "Step 2: Cloning backup from GitHub..."
cd /root
git clone https://github.com/tajo9128/biodockify-vps-backup.git backup || cd backup && git pull

echo ""
echo "Step 3: Restoring OpenClaw..."
cp backup/openclaw.json /root/.openclaw/openclaw.json
cp backup/.claw.json /root/.openclaw/.claw.json
cp -r backup/skills /root/.openclaw/skills
cp -r backup/memory /root/.openclaw/memory

echo ""
echo "Step 4: Restoring BioDockify website..."
mkdir -p /var/www/html
mkdir -p /var/www/pharma-ai
cp -r backup/cloudvina/web/dist/* /var/www/html/
cp -r backup/pharma-ai-landing/* /var/www/pharma-ai/

echo ""
echo "Step 5: Restoring Caddy config..."
cp backup/Caddyfile /etc/caddy/Caddyfile

echo ""
echo "Step 6: Starting services..."
systemctl restart caddy
cd /root/cloudvina
docker-compose up -d

echo ""
echo "=== Migration Complete! ==="
echo ""
echo "Your new BioDockify is ready at:"
echo "  - https://www.biodockify.com"
echo "  - https://ai.biodockify.com"
echo "  - https://api.biodockify.com"
