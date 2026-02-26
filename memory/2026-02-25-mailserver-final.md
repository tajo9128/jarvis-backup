# Docker-MailServer - Ready for info@biodockify.com

## ✅ Configuration Verified

| Setting | Value |
|----------|--------|
| Hostname | mail.biodockify.com |
| Domain | biodockify.com |
| Email Account | info@biodockify.com |
| Location | /home/biodockify/mailserver |

## 📋 Pre-Flight Checklist

Before starting, complete these steps:

### 1. DNS Records (Required)

Add these to your DNS provider:

```
A Record:
  Name: mail
  Value: 217.76.55.124
  TTL: 3600

MX Record:
  Name: @
  Value: mail.biodockify.com
  Priority: 10
```

### 2. Recommended DNS Records (For Email Deliverability)

```
SPF TXT:
  Name: @
  Value: v=spf1 ip4:217.76.55.124 -all

DMARC TXT:
  Name: _dmarc
  Value: v=DMARC1; p=none; rua=mailto:dmarc@biodockify.com
```

### 3. Firewall (Run as Root)

```bash
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 465/tcp
sudo ufw allow 993/tcp
sudo ufw reload
```

## 🚀 Quick Start

### Option 1: Full Setup with Account Creation

```bash
cd ~/mailserver
./setup.sh
```

This will:
- Check DNS configuration
- Prompt for info@biodockify.com password
- Create the account
- Start the mail server

### Option 2: Create Account Then Start

```bash
# Step 1: Create email account
cd ~/mailserver
./create-info-user.sh

# Step 2: Start mail server
docker compose up -d

# Step 3: Check status
docker logs -f mailserver
```

### Option 3: Manual Setup

```bash
cd ~/mailserver

# Create directory and account
mkdir -p config/postfix/accounts
echo "info@biodockify.com:yourpassword" > config/postfix/accounts

# Start mail server
docker compose up -d

# Monitor logs
docker logs -f mailserver
```

## 📧 Email Client Settings

Configure your email client with:

### IMAP (Receiving)

| Setting | Value |
|---------|-------|
| Server | mail.biodockify.com |
| Port | 993 |
| SSL/TLS | Yes (required) |
| Username | info@biodockify.com |
| Password | (as set) |

### SMTP (Sending)

| Setting | Value |
|---------|-------|
| Server | mail.biodockify.com |
| Port | 587 (STARTTLS) or 465 (SSL) |
| SSL/TLS | Yes (required) |
| Username | info@biodockify.com |
| Password | (as set) |

## 🧪 Testing

After the mail server is running:

### 1. Check Container Status

```bash
docker ps | grep mailserver
```

### 2. View Logs

```bash
docker logs -f mailserver
```

### 3. Test DNS MX

```bash
dig MX biodockify.com
```

### 4. Test Port 25

```bash
nc -zv mail.biodockify.com 25
```

### 5. Test Email Sending

Send an email from info@biodockify.com to an external address (like Gmail) and check if it arrives.

### 6. Test Email Deliverability

Visit https://www.mail-tester.com/ and send an email from info@biodockify.com to get a deliverability score.

## 🔐 Security Features

- ✅ SpamAssassin (anti-spam filtering)
- ✅ Fail2Ban (brute force protection)
- ❌ ClamAV (disabled - saves resources)
- ✅ Let's Encrypt (automatic SSL)

## 📊 Resource Impact

| Resource | Current | With Mail Server | Total |
|----------|----------|-------------------|--------|
| RAM | 1.48GB | +400-800MB | ~2.3GB (30%) |
| CPU | 2.9% | +0.5-1% | ~3.5% |
| Disk | 80GB | +~500MB | ~80.5GB |

**✅ Fits easily within available resources!**

## 🔧 Common Commands

### View Logs
```bash
docker logs -f mailserver
tail -f ~/mailserver/maillogs/mail.log
```

### Restart
```bash
cd ~/mailserver && docker compose restart
```

### Stop
```bash
cd ~/mailserver && docker compose down
```

### Start
```bash
cd ~/mailserver && docker compose up -d
```

### Check Fail2Ban
```bash
docker exec mailserver fail2ban-client status
docker exec mailserver fail2ban-client status postfix
```

### Unban IP
```bash
docker exec mailserver fail2ban-client set postfix unbanip 1.2.3.4
```

### List Users
```bash
docker exec mailserver setup email list
```

## 📝 DKIM Setup (After Mail Server is Running)

For better email deliverability, set up DKIM:

### Generate DKIM Key

```bash
cd ~/mailserver
docker exec mailserver setup config dkim keysize 2048 selector default
```

### Get DKIM Record

```bash
cat config/opendkim/keys/biodockify.com/default.txt
```

### Add to DNS

Add as TXT record:
- Name: `default._domainkey`
- Value: (the entire DKIM record output)

### Verify

After DNS propagation (wait 24-48 hours):

```bash
dig TXT default._domainkey.biodockify.com
```

## 🆘 Troubleshooting

### Container Won't Start

```bash
docker logs mailserver
cd ~/mailserver
docker compose down
docker compose up -d --force-recreate
```

### Can't Send Email

1. Check port 25:
   ```bash
   nc -zv mail.biodockify.com 25
   ```

2. Check DNS MX record:
   ```bash
   dig MX biodockify.com
   ```

3. Check logs:
   ```bash
   docker logs mailserver | grep -i error
   ```

4. If port 25 is blocked, contact Contabo support.

### Emails Going to Spam

1. Verify SPF record is correct
2. Set up DKIM (see above)
3. Set up DMARC
4. Wait 24-48 hours for DNS propagation
5. Test with mail-tester.com

### Certificate Errors

Generate self-signed certificates:

```bash
openssl req -new -x509 -days 365 -nodes \
  -out ~/mailserver/config/ssl/cert.pem \
  -keyout ~/mailserver/config/ssl/key.pem
```

Update `mailserver.env`:
```env
SSL_TYPE=manual
SSL_CERT_PATH=/etc/ssl/mail/cert.pem
SSL_KEY_PATH=/etc/ssl/mail/key.pem
```

## 📚 Documentation

| File | Purpose |
|------|---------|
| `mailserver-info-quick.md` | Quick reference card |
| `mailserver-info-config.md` | Complete configuration guide |
| `mailserver-guide.md` | Full documentation |
| `mailserver-summary.md` | Setup summary |

All in: `~/.openclaw/workspace/memory/`

## 🎯 Summary

| Item | Status |
|------|--------|
| Hostname configured | ✅ mail.biodockify.com |
| Domain configured | ✅ biodockify.com |
| Setup script ready | ✅ (defaults to info user) |
| Account creation script | ✅ create-info-user.sh |
| Documentation | ✅ Complete |
| DNS records | ⏳ Pending |
| Mail server started | ⏳ Pending |

## Ready to Launch!

1. ✅ Configure DNS records
2. ⏳ Run `cd ~/mailserver && ./create-info-user.sh`
3. ⏳ Run `docker compose up -d`
4. ⏳ Test email sending/receiving
5. ⏳ Set up DKIM for better deliverability

**Your mail server will be live!** 📧

---

**Quick command to get started:**
```bash
cd ~/mailserver && ./create-info-user.sh && docker compose up -d
```
