# Cloudflare Tunnel Setup Guide

Complete guide for setting up Cloudflare Tunnel to expose all PurePulse sites to the internet.

## Prerequisites

- ✅ Cloudflared installed (version 2026.10.1 confirmed)
- ✅ All sites running locally on their respective ports
- ✅ Cloudflare account with access to manage DNS for all domains
- ✅ Domains registered or transferred to Cloudflare

## Step 1: Authenticate with Cloudflare

```bash
cloudflared tunnel login
```

This will open a browser where you'll select which Cloudflare account/zone to associate with the tunnel.

## Step 2: Create the Tunnel

```bash
cloudflared tunnel create purepulse-r510
```

This creates:
- A tunnel with ID (you'll see this in the output)
- A credentials file at `~/.cloudflared/<tunnel-id>.json`

**Save the tunnel ID** - you'll need it for DNS records.

## Step 3: Configure the Tunnel

The configuration file is already created at `/home/matt/sites-on-r510/cloudflare/config.yml`.

Copy it to the cloudflared directory:

```bash
mkdir -p ~/.cloudflared
cp /home/matt/sites-on-r510/cloudflare/config.yml ~/.cloudflared/config.yml
```

**Update the credentials file path** in config.yml if needed:
```bash
# Edit the config.yml to point to your actual credentials file
sed -i "s|/home/matt/.cloudflared/tunnel-credentials.json|$HOME/.cloudflared/<YOUR-TUNNEL-ID>.json|" ~/.cloudflared/config.yml
```

## Step 4: Add DNS Records

You need to add a CNAME record for each domain pointing to your tunnel.

### Option A: Using Cloudflared CLI (Recommended)

```bash
# Get your tunnel ID first
cloudflared tunnel list

# Add DNS records for each domain
cloudflared tunnel route dns purepulse-r510 rootedapp.space
cloudflared tunnel route dns purepulse-r510 p3lending.space
cloudflared tunnel route dns purepulse-r510 velour.live
cloudflared tunnel route dns purepulse-r510 relayapp.pro
cloudflared tunnel route dns purepulse-r510 pacmacmobile.com
cloudflared tunnel route dns purepulse-r510 projectaquarius.space
cloudflared tunnel route dns purepulse-r510 cmameet.site
cloudflared tunnel route dns purepulse-r510 eventtransport.space
cloudflared tunnel route dns purepulse-r510 purepulse.one
cloudflared tunnel route dns purepulse-r510 mattjhagen.xyz
```

### Option B: Manual DNS in Cloudflare Dashboard

For each domain, add a CNAME record:
- **Type**: CNAME
- **Name**: @ (for root domain) or subdomain
- **Target**: `<TUNNEL-ID>.cfargotunnel.com`
- **Proxy status**: Proxied (orange cloud)

Example:
```
Type: CNAME
Name: @
Target: a1b2c3d4-e5f6-7890-abcd-ef1234567890.cfargotunnel.com
Proxy: On
```

## Step 5: Test the Tunnel

Run the tunnel manually first to test:

```bash
cloudflared tunnel run purepulse-r510
```

You should see output like:
```
INF Connection registered connIndex=0
INF Each HA connection's tunnel IDs: map[0:<tunnel-id>]
```

Test each domain in a browser or with curl:
```bash
curl -I https://purepulse.one
curl -I https://rootedapp.space
curl -I https://p3lending.space
# etc.
```

## Step 6: Install as a Service

Once confirmed working, install cloudflared as a system service:

```bash
sudo cloudflared service install
```

Start the service:
```bash
sudo systemctl start cloudflared
sudo systemctl enable cloudflared
```

Check status:
```bash
sudo systemctl status cloudflared
```

View logs:
```bash
sudo journalctl -u cloudflared -f
```

## Domain Configuration

| Domain | Port | Service | Notes |
|--------|------|---------|-------|
| purepulse.one | 3000 | PurePulse Marketing | Main site |
| rootedapp.space | 3002 | Rooted Daily | Static site |
| p3lending.space | 5173 | P3 Lending Frontend | Also has backend on 5001 |
| velour.live | 3009 | Morrow | Vinext app |
| relayapp.pro | 3006 | Relay | Static site |
| pacmacmobile.com | 3007 | PacMac ACP | Vite app |
| projectaquarius.space | 3011 | FlowOS Aquarius | Python app |
| cmameet.site | 3010 | NorthStar Recovery | React Native |
| eventtransport.space | 3008 | Event Transport | Vite + API (8081) |
| mattjhagen.xyz | 3012 | SDR Blog | Not found yet |

## Troubleshooting

### Tunnel won't start
```bash
# Check tunnel list
cloudflared tunnel list

# Check credentials file exists
ls -la ~/.cloudflared/*.json

# Validate config
cloudflared tunnel --config ~/.cloudflared/config.yml run purepulse-r510
```

### DNS not resolving
```bash
# Check DNS records
nslookup purepulse.one
dig purepulse.one

# Check Cloudflare dashboard for DNS records
# Make sure CNAME records are proxied (orange cloud)
```

### 502 Bad Gateway
This usually means:
1. The tunnel is running but the local service isn't
2. Wrong port in config.yml
3. Service not listening on 0.0.0.0 (only listening on 127.0.0.1)

Check:
```bash
# Verify local service is running
curl http://localhost:3000

# Check what's listening on the port
sudo lsof -i :3000

# View tunnel logs
sudo journalctl -u cloudflared -f
```

### 403 Forbidden
Check Cloudflare firewall rules and security settings for the domain.

### SSL/TLS Issues
Cloudflare automatically provides SSL. Make sure:
- SSL/TLS mode in Cloudflare is set to "Flexible" or "Full"
- Don't force HTTPS redirect in your local app (Cloudflare handles this)

## Security Best Practices

1. **Keep credentials secure**: Never commit `~/.cloudflared/*.json` to git
2. **Use Flexible SSL**: Your tunnel to Cloudflare is encrypted, even if local traffic isn't
3. **Enable WAF**: Use Cloudflare's Web Application Firewall
4. **Rate Limiting**: Configure rate limiting in Cloudflare dashboard
5. **Access Policies**: Consider using Cloudflare Access for admin panels

## Monitoring

### Check tunnel status
```bash
sudo systemctl status cloudflared
```

### View active connections
```bash
cloudflared tunnel info purepulse-r510
```

### Restart tunnel
```bash
sudo systemctl restart cloudflared
```

### Update tunnel config
```bash
# Edit config
nano ~/.cloudflared/config.yml

# Restart tunnel
sudo systemctl restart cloudflared
```

## Cloudflare Dashboard Settings

### Recommended Settings per Domain

1. **SSL/TLS**
   - Mode: Flexible or Full
   - Enable: Always Use HTTPS
   - Enable: Automatic HTTPS Rewrites

2. **Speed**
   - Enable: Auto Minify (JS, CSS, HTML)
   - Enable: Brotli compression
   - Enable: Rocket Loader (test first)

3. **Caching**
   - Browser Cache TTL: 4 hours
   - Enable: Cache Everything page rule for static assets

4. **Security**
   - Enable: Bot Fight Mode
   - Security Level: Medium
   - Challenge Passage: 30 minutes

## Adding a New Site

1. Add entry to `config.yml` under `ingress`:
```yaml
  - hostname: newsite.com
    service: http://localhost:3013
```

2. Add DNS record:
```bash
cloudflared tunnel route dns purepulse-r510 newsite.com
```

3. Restart tunnel:
```bash
sudo systemctl restart cloudflared
```

## Removing the Tunnel

If you need to start over:

```bash
# Stop and disable service
sudo systemctl stop cloudflared
sudo systemctl disable cloudflared
sudo cloudflared service uninstall

# Delete DNS routes
cloudflared tunnel route dns delete purepulse-r510 <domain>

# Delete tunnel
cloudflared tunnel delete purepulse-r510

# Clean up files
rm -rf ~/.cloudflared/
```

## Resources

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Cloudflared GitHub](https://github.com/cloudflare/cloudflared)
- [Cloudflare Community](https://community.cloudflare.com/)

## Support

For tunnel issues:
1. Check Cloudflare dashboard for tunnel status
2. View logs: `sudo journalctl -u cloudflared -f`
3. Test local services: `curl http://localhost:<port>`
4. Verify DNS: `nslookup <domain>`

---

**Config File**: `/home/matt/sites-on-r510/cloudflare/config.yml`  
**Tunnel Name**: purepulse-r510  
**Setup Script**: `/home/matt/sites-on-r510/scripts/setup-cloudflare-tunnel.sh`
