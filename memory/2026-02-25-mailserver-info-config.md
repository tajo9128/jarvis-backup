# Docker-MailServer Configuration - info@biodockify.com

## Configuration Verified ✅

### Mail Server Details

| Setting | Value |
|----------|--------|
| **Hostname** | mail.biodockify.com |
| **Domain** | biodockify.com |
| **Email Account** | info@biodockify.com |

### Current Settings

**File:** `/home/biodockify/mailserver/mailserver.env`
```env
ENABLE_SPAMASSASSIN=1
ENABLE_CLAMAV=0
ENABLE_FAIL2BAN=1
ENABLE_POSTGREY=0
ONE_DIR=1
PERMIT_DOCKER=network
SSL_TYPE=letsencrypt
HOSTNAME=mail.biodockify.com
```

**File:** `/home/biodockify/mailserver/docker-compose.yml`
```yaml
hostname: mail
domainname: biodockify.com
```

**Result:** Full hostname = `mail.biodockify.com` ✅

## Create Email Account

### Option 1: Use Setup Script (Recommended)

```bash
cd ~/mailserver
./setup.sh
```

The script now defaults to **info@biodockify.com**.

### Option 2: Create info@biodockify.com Account Only

```bash
cd ~/mailserver
./create-info-user.sh
```

This script will:
1. Prompt for password
2. Create the account
3. Show configuration details

### Option 3: Manual Creation

```bash
cd ~/mailserver
mkdir -p config/postfix/accounts

# Create account (format: username@domain:password)
echo "info@biodockify.com:yourpassword" > config/postfix/accounts

# Start mail server
docker compose up -d

# Check status
docker logs -f mailserver
```

## DNS Records Required

### Required Records

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

### Recommended Records

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

## Email Client Configuration

Configure your email client with these settings:

### IMAP (Receiving Email)

| Setting | Value |
|---------|-------|
| Server | mail.biodockify.com |
| Port | 993 |
| SSL/TLS | Yes (required) |
| Username | info@biodockify.com |
| Password | (as set) |

### SMTP (Sending Email)

| Setting | Value |
|---------|-------|
| Server | mail.biodockify.com |
| Port | 587 (STARTTLS) or 465 (SSL) |
| SSL/TLS | Yes (required) |
| Username | info@biodockify.com |
| Password | (as set) |

## Quick Start

### Step 1: Configure DNS

Add the DNS records listed above to your domain registrar.

### Step 2: Create Email Account

```bash
cd ~/mailserver
./create-info-user.sh
```

Or use the setup script:
```bash
cd ~/mailserver
./setup.sh
# It will default to info@biodockify.com
```

### Step 3: Start Mail Server

```bash
cd ~/mailserver
docker compose up -d
```

### Step 4: Check Status

```bash
docker ps | grep mailserver
docker logs -f mailserver
```

### Step 5: Test Email

1. Send test email from info@biodockify.com to external address
2. Check if received
3. Reply to the test email
4. Verify both directions work

## Testing Your Email

### Test MX Record

```bash
dig MX biodockify.com
```

### Test Port 25 (SMTP)

```bash
nc -zv mail.biodockify.com 25
```

### Test Email Deliverability

Visit these services to test:

- https://www.mail-tester.com/
- https://mxtoolbox.com/
- https://www.appmaildev.com/en/dkim

## Security Features

- ✅ **SpamAssassin** - Filters spam emails
- ✅ **Fail2Ban** - Blocks brute force attacks
- ✅ **Let's Encrypt** - Automatic SSL certificates
- ❌ **ClamAV** - Disabled (saves resources)

## Common Commands

### View Logs

```bash
# Real-time logs
docker logs -f mailserver

# Last 100 lines
docker logs --tail 100 mailserver

# Mail-specific logs
tail -f ~/mailserver/maillogs/mail.log
```

### Restart Mail Server

```bash
cd ~/mailserver
docker compose restart
```

### Stop Mail Server

```bash
cd ~/mailserver
docker compose down
```

### Start Mail Server

```bash
cd ~/mailserver
docker compose up -d
```

### Check Fail2Ban Status

```bash
docker exec mailserver fail2ban-client status
docker exec mailserver fail2ban-client status postfix
```

### Unban an IP (if blocked)

```bash
docker exec mailserver fail2ban-client set postfix unbanip 1.2.3.4
```

## Firewall Rules

Ensure these ports are open (run as root):

```bash
sudo ufw allow 25/tcp   # SMTP incoming
sudo ufw allow 587/tcp  # SMTP submission
sudo ufw allow 465/tcp  # SMTPS
sudo ufw allow 993/tcp  # IMAPS
sudo ufw reload
```

## DKIM Setup (Important for Deliverability)

After the mail server is running and DNS is configured:

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

Copy the output and add as a TXT record:
- Name: `default._domainkey`
- Value: (the entire DKIM record)

### Verify After DNS Propagation

```bash
dig TXT default._domainkey.biodockify.com
```

## Troubleshooting

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

If Let's Encrypt fails, you can generate self-signed certificates:

```bash
openssl req -new -x509 -days 365 -nodes \
  -out ~/mailserver/config/ssl/cert.pem \
  -keyout ~/mailserver/config/ssl/key.pem
```

Then update `mailserver.env`:
```env
SSL_TYPE=manual
SSL_CERT_PATH=/etc/ssl/mail/cert.pem
SSL_KEY_PATH=/etc/ssl/mail/key.pem
```

## Resource Usage

**Expected:**
- RAM: ~400-800MB
- CPU: ~0.5-1% (idle)
- Disk: ~500MB base + email storage

**Current VPS Usage After Mail Server:**
- Total RAM: ~2.3GB (30% of 7.8GB)
- Available RAM: 5.5GB (70%)

## File Structure

```
/home/biodockify/mailserver/
├── docker-compose.yml       # Container configuration
├── mailserver.env         # Environment variables
├── setup.sh              # Automated setup script
├── create-info-user.sh   # Create info@biodockify.com account
├── maildata/             # Email storage
├── maillogs/             # Log files
├── mailstate/            # Application state
└── config/
    └── postfix/
        └── accounts      # Email accounts file
```

## Summary

- ✅ Hostname: mail.biodockify.com
- ✅ Domain: biodockify.com
- ✅ Default email: info@biodockify.com
- ✅ Setup script updated (defaults to info user)
- ✅ Quick user creation script ready
- ✅ Documentation complete

## Ready to Start!

1. **Configure DNS records** (see above)
2. **Create email account**:
   ```bash
   cd ~/mailserver && ./create-info-user.sh
   ```
3. **Start mail server**:
   ```bash
   cd ~/mailserver && docker compose up -d
   ```
4. **Test email sending/receiving**

Your mail server will be live! 📧
