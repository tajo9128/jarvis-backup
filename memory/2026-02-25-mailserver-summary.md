# Docker-MailServer - Setup Summary

## ✅ Prepared

### Files Created/Updated:

1. **Docker Compose** - `/home/biodockify/mailserver/docker-compose.yml`
   - Configured with DNS resolvers (Cloudflare)
   - Network isolation (mail-network)
   - All required ports exposed

2. **Setup Script** - `/home/biodockify/mailserver/setup.sh`
   - Interactive setup wizard
   - Creates first email account automatically
   - Checks for DNS records
   - Starts mail server

3. **Configuration** - `/home/biodockify/mailserver/mailserver.env`
   - SpamAssassin: ✅ enabled
   - ClamAV: ❌ disabled (saves resources)
   - Fail2Ban: ✅ enabled
   - Let's Encrypt: ✅ enabled

4. **Documentation** - `/home/biodockify/.openclaw/workspace/memory/2026-02-25-mailserver-guide.md`
   - Complete setup guide
   - Troubleshooting section
   - DKIM setup instructions
   - Email client configuration

## 🔧 Before Starting: DNS Records

You **MUST** configure these DNS records first:

### Required:

1. **A Record**
   ```
   Type: A
   Name: mail
   Value: 217.76.55.124
   TTL: 3600
   ```

2. **MX Record**
   ```
   Type: MX
   Name: @
   Value: mail.biodockify.com
   Priority: 10
   ```

### Recommended (for deliverability):

3. **SPF Record**
   ```
   Type: TXT
   Name: @
   Value: v=spf1 ip4:217.76.55.124 -all
   ```

4. **DMARC Record**
   ```
   Type: TXT
   Name: _dmarc
   Value: v=DMARC1; p=none; rua=mailto:dmarc@biodockify.com
   ```

## 🚀 Quick Start

### Option 1: Automated (Recommended)

```bash
cd ~/mailserver
./setup.sh
```

The script will:
- ✅ Check if DNS is configured
- ✅ Prompt for email account details
- ✅ Create first user automatically
- ✅ Start mail server
- ✅ Display connection details

### Option 2: Manual

```bash
cd ~/mailserver

# Create email user
mkdir -p config/postfix/accounts
echo "admin@biodockify.com:yourpassword" > config/postfix/accounts

# Start mail server
docker compose up -d

# Check status
docker ps
docker logs -f mailserver
```

## 📊 Resource Impact

| Metric | Current | After Mail Server | Total |
|--------|----------|-------------------|--------|
| RAM | 1.48GB | +400-800MB | ~2.3GB (30%) |
| CPU | 2.9% | +0.5-1% | ~3.5% |
| Disk | 80GB | +~500MB | ~80.5GB |

**Verdict:** ✅ **Easily within resources**

## 🔌 Ports Required

Ensure firewall allows these:

```bash
sudo ufw allow 25/tcp   # SMTP (incoming)
sudo ufw allow 587/tcp  # SMTP submission
sudo ufw allow 465/tcp  # SMTPS
sudo ufw allow 993/tcp  # IMAPS
sudo ufw reload
```

**Note:** Port 25 may be blocked by Contabo. Verify after setup.

## 📧 Email Client Setup

Once running, configure your email client:

### IMAP (Receiving)
- **Server:** mail.biodockify.com
- **Port:** 993
- **Security:** SSL/TLS
- **Username:** your-email@biodockify.com
- **Password:** (as set)

### SMTP (Sending)
- **Server:** mail.biodockify.com
- **Port:** 587 (STARTTLS) or 465 (SSL)
- **Security:** SSL/TLS
- **Username:** your-email@biodockify.com
- **Password:** (as set)

## 🧪 Testing

After starting, test:

1. **Check container:**
   ```bash
   docker ps | grep mailserver
   ```

2. **View logs:**
   ```bash
   docker logs -f mailserver
   ```

3. **Test port 25:**
   ```bash
   nc -zv mail.biodockify.com 25
   ```

4. **Test deliverability:**
   - Send email to external address
   - Check spam folder
   - Use https://www.mail-tester.com/

## 🔐 Security Features

- ✅ SpamAssassin (anti-spam)
- ✅ Fail2Ban (brute force protection)
- ✅ Let's Encrypt (automatic SSL)
- ✅ Docker isolation
- ✅ Network separation

## 📋 Next Steps

1. ⏳ **Configure DNS records** (MUST DO FIRST)
2. ⏳ **Run setup script** (`./setup.sh`)
3. ⏳ **Create email accounts**
4. ⏳ **Test sending/receiving**
5. ⏳ **Set up DKIM** (improves deliverability)
6. ⏳ **Configure email clients**
7. ⏳ **Test with mail-tester.com**
8. ⏳ **Add backup cron job**

## 📁 File Locations

| Item | Location |
|------|----------|
| Mail server setup | `/home/biodockify/mailserver/` |
| Email data | `~/mailserver/maildata/` |
| Logs | `~/mailserver/maillogs/` |
| Config | `~/mailserver/config/` |
| Setup script | `~/mailserver/setup.sh` |
| Documentation | `~/.openclaw/workspace/memory/2026-02-25-mailserver-guide.md` |

## 🆘 Troubleshooting

### Container won't start
```bash
docker logs mailserver
docker compose down
docker compose up -d
```

### Can't send email
1. Check port 25: `nc -zv mail.biodockify.com 25`
2. Check DNS MX: `dig MX biodockify.com`
3. Check logs: `docker logs mailserver`

### Email goes to spam
1. Verify SPF record
2. Set up DKIM (see guide)
3. Wait 24-48h for DNS propagation

### Port 25 blocked
Contact Contabo support or use SMTP relay service.

## 📞 Support

- **Documentation:** `~/.openclaw/workspace/memory/2026-02-25-mailserver-guide.md`
- **Official docs:** https://docker-mailserver.github.io/docker-mailserver/
- **GitHub:** https://github.com/docker-mailserver/docker-mailserver

## 🎯 Summary

- ✅ Docker compose configured
- ✅ Setup script ready
- ✅ Documentation complete
- ⏳ **Waiting for DNS configuration**
- ⏳ **Ready to start mail server**

Once DNS is configured, run:
```bash
cd ~/mailserver
./setup.sh
```

And your mail server will be live! 📧
