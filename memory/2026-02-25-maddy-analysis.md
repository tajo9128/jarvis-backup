# Maddy Mail Server - Resource Analysis

## Current VPS Resources

| Resource | Available | Used | Available for Growth |
|----------|-----------|------|---------------------|
| RAM | 7.8GB | 2.8GB | **4.9GB** |
| Disk | 145GB | 80GB | **65GB** |
| CPU | Low load | 0.38 avg | Plenty headroom |

## Current Docker Memory Usage

| Container | RAM | CPU |
|-----------|-----|-----|
| biodockify-api | 822MB | 0.86% |
| biodockify-learn-backend | 413MB | 0.37% |
| uptime-kuma | 136MB | ~1% |
| biodockify-worker | 52MB | 0.01% |
| portainer | 21MB | 0.09% |
| biodockify-postgres | 24MB | 0.65% |
| biodockify-ai-web | 5MB | 0% |
| biodockify-web | 6MB | 0% |
| **Total** | **~1.48GB** | **~2.9%** |

## Maddy Mail Server - Estimated Resources

**Maddy** (foxcpp/maddy) is a lightweight, all-in-one mail server written in Go:

| Metric | Estimate |
|--------|----------|
| RAM (idle) | 50-100MB |
| RAM (under load) | 200-300MB |
| CPU (idle) | <0.1% |
| CPU (under load) | 1-5% |
| Disk | ~50-100MB (binary + config) |

## Docker-MailServer - For Comparison

**Found existing setup:** `/home/biodockify/mailserver/`

| Metric | Estimate |
|--------|----------|
| RAM (with SpamAssassin) | 500-800MB |
| RAM (without ClamAV) | 400-600MB |
| CPU (idle) | 0.5-1% |
| Disk | ~500MB |

**Your current docker-mailserver config:**
- SpamAssassin: **enabled**
- ClamAV: **disabled** (saves resources)
- Fail2Ban: **enabled**
- Postgrey: **disabled**

## Comparison

| Feature | Maddy | Docker-MailServer |
|---------|-------|-----------------|
| RAM usage | **~100-300MB** | ~400-800MB |
| Architecture | Single Go binary | Postfix + Dovecot + SpamAssassin + tools |
| Config complexity | Simple | Moderate |
| Maintenance | Low | Medium |
| SMTP | ✅ | ✅ |
| IMAP | ✅ (beta) | ✅ (stable) |
| DKIM/SPF/DMARC | ✅ Built-in | ✅ Via SpamAssassin/Rspamd |
| Anti-spam | Basic | Advanced (Rspamd/SpamAssassin) |
| Anti-virus | ❌ None | ✅ ClamAV (optional) |

## Resource Impact Analysis

### With Maddy:

**After adding Maddy:**
- Total RAM: ~1.48GB + 300MB = **1.78GB** (23% of 7.8GB)
- Available: **6GB** (77% free)
- **Verdict:** ✅ **Easily fits**

### With Docker-MailServer:

**After adding docker-mailserver:**
- Total RAM: ~1.48GB + 600MB = **2.08GB** (27% of 7.8GB)
- Available: **5.7GB** (73% free)
- **Verdict:** ✅ **Fits well**

## Recommendation

### Maddy - Good Choice For:

- ✅ **Personal/small business use**
- ✅ **Lightweight requirements**
- ✅ **Simple setup & maintenance**
- ✅ **Modern, composable architecture**
- ✅ **Built-in DKIM/SPF/DMARC**

### Maddy - Considerations:

- ⚠️ IMAP storage is **beta** (may have issues with large mailboxes)
- ⚠️ Basic spam filtering (not as advanced as Rspamd)
- ⚠️ No virus scanning (ClamAV)

### Docker-MailServer - Good Choice For:

- ✅ **Production/stable IMAP**
- ✅ **Advanced spam filtering** (Rspamd/SpamAssassin)
- ✅ **Virus scanning** (ClamAV)
- ✅ **Battle-tested** (Postfix + Dovecot)

## Final Verdict

**YES** - Your VPS can easily run Maddy mail server.

**Resource impact:** Minimal
- RAM: +100-300MB (12-23% of current usage)
- CPU: +0.1-2%
- Disk: +50-100MB

**Total after Maddy:** ~1.6-1.8GB RAM (still 77% free)

## Next Steps

### Option 1: Maddy (Recommended for simplicity)

```bash
# Pull Maddy image
docker pull foxcpp/maddy:0.6

# Create directory structure
mkdir -p ~/maddy/{config,data}
```

Would you like me to set up Maddy docker-compose configuration?

### Option 2: Use existing docker-mailserver

Your existing setup in `/home/biodockify/mailserver/` is ready to start:

```bash
cd ~/mailserver
docker compose up -d
```

This would use more RAM (~600MB) but offers more features.

## DNS Requirements

Before running any mail server, ensure you have:

1. **A record:** `mail.biodockify.com` → 217.76.55.124
2. **MX record:** `@` → `mail.biodockify.com` (priority 10)
3. **SPF record:** `@` → `v=spf1 ip4:217.76.55.124 -all`
4. **DKIM key:** Generate after mail server setup
5. **DMARC record:** `_dmarc` → `v=DMARC1; p=none; rua=mailto:dmarc@biodockify.com`

## Ports Required

Both Maddy and docker-mailserver need these ports:
- **25** (SMTP) - Essential for receiving mail
- **587** (SMTP submission) - For sending mail
- **465** (SMTPS) - Optional, SMTP over SSL
- **993** (IMAPS) - For reading mail

**Note:** Port 25 may be blocked by Contabo. Verify before setup.
