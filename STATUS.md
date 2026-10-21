# PurePulse Sites Status

**Last Updated**: 2026-10-21 15:45 UTC

## 🟢 Running Sites (7/11)

| Site | URL | Port | Status |
|------|-----|------|--------|
| PurePulse Marketing | https://purepulse.one | 3000 | ✅ Running |
| Rooted Daily | https://rootedapp.space/ | 3002 | ✅ Running |
| FuelShield | https://mattjhagen.github.io/FuelShield/ | 3005 | ✅ Running |
| Relay | http://relayapp.pro/ | 3006 | ✅ Running |
| PacMac ACP | https://pacmacmobile.com/ | 3007 | ✅ Running |
| P3 Lending Frontend | https://p3lending.space/ | 5173 | ✅ Running |
| P3 Lending Backend | API | 5001 | ✅ Running |

## 🟡 In Progress (3/11)

| Site | URL | Port | Status | Notes |
|------|-----|------|--------|-------|
| Event Transport Protocol | https://eventtransport.space/ | 3008 (Web), 8081 (API) | 🔧 Port conflict | Needs reconfiguration |
| Morrow | velour.live | 3009 | 🔄 Ready to start | Dependencies installed |
| NorthStar Recovery | https://cmameet.site/ | 3010 | 🔄 Pending | Needs configuration |

## 🔴 Not Started (1/11)

| Site | URL | Port | Status | Notes |
|------|-----|------|--------|-------|
| FlowOS Aquarius | http://projectaquarius.space/ | 3011 | ⏸️ Not started | Python-based app |
| Matty's SDR Blog | https://mattjhagen.xyz | 3012 | ❌ Not found | Repository not available locally |

## Infrastructure Status

### Services
- **Systemd services**: Created for 7 sites
- **Running processes**: 45 active
- **Node.js version**: v22.23.4
- **npm version**: 10.9.9

### Cloudflare Tunnel
- **Status**: ⏸️ Not configured yet
- **Tunnel name**: purepulse-r510
- **Config file**: `/home/matt/sites-on-r510/cloudflare/config.yml`
- **DNS records**: Pending setup

## Next Steps

1. ✅ ~~Install dependencies for all sites~~
2. ✅ ~~Start and test basic sites~~
3. 🔄 Fix Event Transport Protocol port conflict
4. 🔄 Start remaining sites (Morrow, NorthStar, FlowOS)
5. ⏸️ Configure Cloudflare tunnel
6. ⏸️ Add DNS records for all domains
7. ⏸️ Install systemd services (requires sudo)
8. ⏸️ Enable services to start on boot

## Quick Commands

### Check Status
```bash
/home/matt/sites-on-r510/scripts/check-status.sh
```

### View Logs
```bash
# View all site processes
ps aux | grep -E "(http-server|vite|npm)" | grep -v grep

# Check specific port
lsof -i :3000
```

### Cloudflare Tunnel Setup
```bash
cd /home/matt/sites-on-r510/scripts
./setup-cloudflare-tunnel.sh
```

## Notes

- All sites are currently running in development mode via npm/vite
- Production builds will be needed for better performance
- Event Transport Protocol has a port conflict (both it and P3 Lending want port 5173)
- NorthStarRecovery has a website component that needs to be identified
- FlowOS is Python-based and will need different setup
- Matty's SDR Blog repository not found locally

## Repository

GitHub: [Mattjhagen/sites-on-r510](https://github.com/Mattjhagen/sites-on-r510)
