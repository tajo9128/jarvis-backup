# Docker-MailServer Quick Reference

## 🚀 Start Mail Server

```bash
cd ~/mailserver
./setup.sh
```

## 🔧 Manual Setup

```bash
cd ~/mailserver
mkdir -p config/postfix/accounts
echo "user@biodockify.com:password" > config/postfix/accounts
docker compose up -d
```

## 📊 Check Status

```bash
docker ps | grep mailserver
docker stats mailserver
docker logs -f mailserver
```

## 📧 Email Client Settings

**IMAP (Receive):**
- Server: mail.biodockify.com
- Port: 993
- SSL: Yes

**SMTP (Send):**
- Server: mail.biodockify.com
- Port: 587 (STARTTLS) or 465 (SSL)
- SSL: Yes

## 🆘 Common Commands

**Add user:**
```bash
echo "new@biodockify.com:pass" >> config/postfix/accounts
docker exec mailserver setup email add new@biodockify.com pass
docker exec mailserver postfix reload
```

**List users:**
```bash
docker exec mailserver setup email list
```

**Remove user:**
```bash
docker exec mailserver setup email del user@biodockify.com
```

**Check Fail2Ban:**
```bash
docker exec mailserver fail2ban-client status
```

**Unban IP:**
```bash
docker exec mailserver fail2ban-client set postfix unbanip 1.2.3.4
```

**Restart:**
```bash
cd ~/mailserver
docker compose restart
```

## 📝 DNS Records

**Required:**
```
A: mail → 217.76.55.124
MX: @ → mail.biodockify.com (10)
```

**Recommended:**
```
TXT (SPF): @ → v=spf1 ip4:217.76.55.124 -all
TXT (DMARC): _dmarc → v=DMARC1; p=none; rua=mailto:dmarc@biodockify.com
```

## 🔌 Firewall

```bash
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 465/tcp
sudo ufw allow 993/tcp
sudo ufw reload
```

## 📖 Full Guide

`~/.openclaw/workspace/memory/2026-02-25-mailserver-guide.md`

## 💾 Backup

```bash
tar -czf ~/mail-backup-$(date +%Y%m%d).tar.gz ~/mailserver/maildata
```

## 🧪 Test Email

```bash
# Test MX record
dig MX biodockify.com

# Test port 25
nc -zv mail.biodockify.com 25

# Test deliverability
# Visit: https://www.mail-tester.com/
```

## 📦 Resources

- RAM: ~400-800MB
- CPU: ~0.5-1%
- Disk: ~500MB base + email storage

## 🔐 Security Features

✅ SpamAssassin
✅ Fail2Ban
✅ Let's Encrypt SSL
✅ Docker isolation

---

**Quick Start:**
```bash
cd ~/mailserver && ./setup.sh
```
