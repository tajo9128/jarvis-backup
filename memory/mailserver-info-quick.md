# Docker-MailServer - info@biodockify.com Quick Start

## Configuration ✅

- **Hostname:** mail.biodockify.com
- **Domain:** biodockify.com
- **Email:** info@biodockify.com

## Quick Start

### 1. Configure DNS (Required)

```
A: mail → 217.76.55.124
MX: @ → mail.biodockify.com (10)
```

### 2. Create Email Account

```bash
cd ~/mailserver
./create-info-user.sh
```

### 3. Start Mail Server

```bash
cd ~/mailserver
docker compose up -d
```

### 4. Check Status

```bash
docker ps | grep mailserver
docker logs -f mailserver
```

## Email Client Settings

### IMAP (Receive)
- Server: mail.biodockify.com
- Port: 993
- SSL: Yes
- Username: info@biodockify.com

### SMTP (Send)
- Server: mail.biodockify.com
- Port: 587 (STARTTLS) or 465 (SSL)
- SSL: Yes
- Username: info@biodockify.com

## Commands

**Check status:**
```bash
docker ps | grep mailserver
docker logs mailserver
```

**Restart:**
```bash
cd ~/mailserver && docker compose restart
```

**Stop:**
```bash
cd ~/mailserver && docker compose down
```

**Start:**
```bash
cd ~/mailserver && docker compose up -d
```

**Check Fail2Ban:**
```bash
docker exec mailserver fail2ban-client status
```

**Unban IP:**
```bash
docker exec mailserver fail2ban-client set postfix unbanip 1.2.3.4
```

## Testing

**Check MX:**
```bash
dig MX biodockify.com
```

**Test port 25:**
```bash
nc -zv mail.biodockify.com 25
```

**Test deliverability:**
- https://www.mail-tester.com/
- https://mxtoolbox.com/

## Recommended DNS Records

**SPF:**
```
@ → v=spf1 ip4:217.76.55.124 -all
```

**DMARC:**
```
_dmarc → v=DMARC1; p=none; rua=mailto:dmarc@biodockify.com
```

## DKIM Setup (After Mail Server Running)

```bash
cd ~/mailserver
docker exec mailserver setup config dkim keysize 2048 selector default
cat config/opendkim/keys/biodockify.com/default.txt
```

Add as TXT record:
- Name: `default._domainkey`
- Value: (the DKIM record)

## Firewall

```bash
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 465/tcp
sudo ufw allow 993/tcp
sudo ufw reload
```

## Resources

- RAM: ~400-800MB
- CPU: ~0.5-1%
- Disk: ~500MB base

## Files

| File | Location |
|------|----------|
| Setup | `~/mailserver/setup.sh` |
| Create info user | `~/mailserver/create-info-user.sh` |
| Config | `~/mailserver/mailserver.env` |
| Compose | `~/mailserver/docker-compose.yml` |
| Full guide | `~/.openclaw/workspace/memory/2026-02-25-mailserver-info-config.md` |

## Summary

✅ Hostname: mail.biodockify.com
✅ Email: info@biodockify.com
✅ Ready to start

**Start:**
```bash
cd ~/mailserver && ./create-info-user.sh && docker compose up -d
```
