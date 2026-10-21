# DNS Fix Required for purepulse.one

## Current Issue

**purepulse.one is pointing to GitHub Pages instead of the Cloudflare tunnel!**

```bash
$ nslookup purepulse.one
Address: 185.199.108.153  # This is GitHub Pages!
```

Response headers confirm it:
```
server: GitHub.com
x-github-request-id: ...
```

## What Needs to be Done

You need to log into the Cloudflare dashboard and update the DNS record for `purepulse.one`:

### Option 1: Update via Cloudflare Dashboard (Recommended)

1. Go to https://dash.cloudflare.com/
2. Select the domain where purepulse.one is registered
3. Go to DNS → Records
4. Find the record for `purepulse.one` (either A, AAAA, or CNAME)
5. **Delete or update** the existing record
6. Make sure there's a CNAME record:
   - **Type**: CNAME
   - **Name**: @ (or purepulse.one)
   - **Target**: `2c92961b-db35-4513-985c-6c91b5778e8c.cfargotunnel.com`
   - **Proxy status**: Proxied (orange cloud ON)

### Option 2: Use Cloudflare API

If you can't access the dashboard, you'll need to use the Cloudflare API to update the DNS record.

## Tunnel Information

- **Tunnel Name**: purepulse-r510
- **Tunnel ID**: 2c92961b-db35-4513-985c-6c91b5778e8c
- **Target**: `2c92961b-db35-4513-985c-6c91b5778e8c.cfargotunnel.com`

## What's Working vs Not Working

### ✅ Working DNS Records (pointing to tunnel)
- rootedapp.space → 200 OK
- relayapp.pro → 200 OK
- pacmacmobile.com → 200 OK
- eventtransport.space → configured (site needs to start)
- mattjhagen.xyz → 200 OK

### ❌ Not Working (wrong DNS)
- **purepulse.one** → Points to GitHub Pages instead of tunnel

### ⚠️ Need Investigation
- p3lending.space → 530 error (running on wrong port 5173 instead of 5174)
- velour.live → timeout/no response (site running on 3009)
- cmameet.site → no response (site running on 3010)

## Verification

After updating DNS, test with:

```bash
# Check DNS resolution
nslookup purepulse.one

# Should show Cloudflare IPs, not GitHub Pages IP

# Test the site
curl -I https://purepulse.one

# Should show "Elite Web Design & Digital Roster" title
curl -s https://purepulse.one | grep "<title>"
```

## Why This Happened

When we ran `cloudflared tunnel route dns purepulse-r510 purepulse.one`, it tried to create a CNAME record, but there was likely an existing A record for purepulse.one pointing to GitHub Pages that took precedence.

The tunnel infrastructure is working perfectly - we just need to update this one DNS record!
