# Next Steps - PurePulse Sites Deployment

## ✅ Completed

1. **Repository Setup**
   - Created and pushed sites-on-r510 GitHub repository
   - Organized configuration files and documentation
   - Created comprehensive README and tracking documents

2. **Site Preparation**
   - Installed dependencies for all npm-based sites
   - Created systemd service files for 7 sites
   - Created deployment and management scripts

3. **Sites Running** (7/11)
   - ✅ PurePulse Marketing (3000)
   - ✅ Rooted Daily (3002)
   - ✅ FuelShield (3005)
   - ✅ Relay (3006)
   - ✅ PacMac ACP (3007)
   - ✅ P3 Lending Frontend (5173)
   - ✅ P3 Lending Backend API (5001)

## 🔄 Immediate Next Steps

### 1. Fix Event Transport Protocol Port Conflict

The Event Transport Protocol is currently using port 5173 (conflicting with P3 Lending). We need to reconfigure it to use port 3008.

**Option A: Update the package.json script**
```bash
cd /home/matt/PurePulse/Event-Transport-Protocol
# Edit package.json and update the "dev" script to specify port 3008
```

**Option B: Create a vite.config.ts with custom port**
```bash
cd /home/matt/PurePulse/Event-Transport-Protocol
# Add server.port configuration to vite.config.ts
```

### 2. Set Up Cloudflare Tunnel

This is the critical step to make all sites accessible via their domain names.

```bash
cd /home/matt/sites-on-r510/scripts
./setup-cloudflare-tunnel.sh
```

**Then add DNS records for each domain:**
```bash
# You can either use the Cloudflare dashboard or run these commands:

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

**Start the tunnel:**
```bash
# Test it first
cloudflared tunnel run purepulse-r510

# If it works, install as a service
sudo cloudflared service install
sudo systemctl start cloudflared
sudo systemctl enable cloudflared
```

### 3. Install Systemd Services (Requires sudo)

Once you have sudo access:

```bash
cd /home/matt/sites-on-r510/scripts
./install-services.sh
./start-all-sites.sh
```

### 4. Start Remaining Sites

**Morrow (Vinext):**
```bash
cd /home/matt/PurePulse/Morrow
npm run dev -- --port 3009 &
```

**NorthStar Recovery:**
First, locate the website component:
```bash
cd /home/matt/PurePulse/NorthStarRecovery
ls -la website/
# Check for index.html or package.json in website folder
```

**FlowOS Project Aquarius (Python):**
```bash
cd /home/matt/PurePulse/FlowOS-Project-Aquarius
# Install Python dependencies
pip install -r requirements.txt
# Start the Flask/GUI server on port 3011
```

## 📋 Pre-Flight Checklist

Before going live with Cloudflare tunnel:

- [ ] All sites tested locally and responding
- [ ] Cloudflare tunnel created
- [ ] DNS records added for all domains
- [ ] Tunnel tested and running
- [ ] Systemd services installed (optional, for auto-start)
- [ ] SSL/TLS certificates verified in Cloudflare
- [ ] All domains pointed to tunnel

## 🔐 Security Considerations

1. **Environment Variables**: Ensure all sites have proper `.env` files with production values
2. **API Keys**: Keep sensitive API keys secure and not in git repos
3. **HTTPS**: Cloudflare provides automatic HTTPS
4. **Rate Limiting**: Consider adding rate limiting to prevent abuse
5. **Monitoring**: Set up monitoring for site uptime

## 📊 Monitoring

**Check all sites status:**
```bash
/home/matt/sites-on-r510/scripts/check-status.sh
```

**View site logs:**
```bash
# When running as systemd services:
sudo journalctl -u rootedapp -f
sudo journalctl -u p3lending -f
# etc.

# Current background processes:
ps aux | grep -E "(http-server|vite|npm)" | grep -v grep
```

**Check tunnel status:**
```bash
sudo systemctl status cloudflared
cloudflared tunnel list
```

## 🚨 Troubleshooting

### Site not accessible
1. Check if site is running: `curl http://localhost:<port>`
2. Check tunnel status: `sudo systemctl status cloudflared`
3. Verify DNS record: `nslookup <domain>`
4. Check Cloudflare dashboard for tunnel status

### Port conflicts
Run: `sudo lsof -i :<port>` to see what's using the port

### Service won't start
Check logs: `sudo journalctl -u <service-name> -n 50`

## 📚 Documentation

- Main README: `/home/matt/sites-on-r510/README.md`
- Agents work log: `/home/matt/sites-on-r510/agents.md`
- Current status: `/home/matt/sites-on-r510/STATUS.md`
- GitHub: https://github.com/Mattjhagen/sites-on-r510

## 🎯 Success Criteria

The deployment is complete when:
- ✅ All 11 sites are running
- ✅ Cloudflare tunnel is active
- ✅ All domains resolve and are accessible via HTTPS
- ✅ Sites auto-restart on failure (systemd services)
- ✅ Sites auto-start on server reboot (systemd enabled)

---

**Current Status**: 7/11 sites running, ready for Cloudflare tunnel setup
**GitHub Repo**: https://github.com/Mattjhagen/sites-on-r510
