# PurePulse Sites on R510 Server

Deployment configuration and management scripts for all PurePulse sites running on the R510 server.

## 🌐 Sites

| Site | URL | Port | Status |
|------|-----|------|--------|
| Rooted Daily | https://rootedapp.space/ | 3002 | 🔄 |
| P3 Lending Protocol | https://p3lending.space/ | 5173 | 🔄 |
| Morrow | velour.live | 3009 | 🔄 |
| FuelShield | GitHub Pages | 3005 | 🔄 |
| Relay | http://relayapp.pro/ | 3006 | 🔄 |
| Matty's SDR Blog | https://mattjhagen.xyz | 3012 | ❌ |
| PacMac ACP | https://pacmacmobile.com/ | 3007 | 🔄 |
| FlowOS Project Aquarius | http://projectaquarius.space/ | 3011 | 🔄 |
| NorthStar Recovery | https://cmameet.site/ | 3010 | 🔄 |
| Event Transport Protocol | https://eventtransport.space/ | 3008 | 🔄 |
| PurePulse Marketing | https://purepulse.one | 3000 | 🔄 |

## 📁 Repository Structure

```
sites-on-r510/
├── agents.md                 # Detailed deployment work log
├── README.md                 # This file
├── systemd/                  # Systemd service files
│   ├── rootedapp.service
│   ├── fuelshield.service
│   ├── relay.service
│   ├── purepulse.service
│   ├── pacmac.service
│   ├── p3lending.service
│   └── eventtransport.service
├── cloudflare/              # Cloudflare tunnel configuration
│   └── config.yml
├── scripts/                 # Deployment and management scripts
│   ├── install-services.sh
│   ├── start-all-sites.sh
│   └── setup-cloudflare-tunnel.sh
└── nginx/                   # Nginx configs (future use)
```

## 🚀 Quick Start

### 1. Install Dependencies

First, ensure all site dependencies are installed:

```bash
# Rooted Daily
cd /home/matt/PurePulse/Rooted-Daily-static-site && npm install

# FuelShield
cd /home/matt/PurePulse/FuelShield && npm install

# PurePulse Marketing
cd /home/matt/PurePulse/PurePulse-Marketing && npm install --legacy-peer-deps

# PacMac ACP
cd /home/matt/PurePulse/PacMac-ACP && npm install

# P3 Lending Protocol
cd /home/matt/PurePulse/P3-Lending-Protocol && npm install

# Event Transport Protocol
cd /home/matt/PurePulse/Event-Transport-Protocol && npm install
```

### 2. Install Systemd Services

```bash
cd /home/matt/sites-on-r510/scripts
chmod +x *.sh
./install-services.sh
```

### 3. Start All Sites

```bash
./start-all-sites.sh
```

### 4. Setup Cloudflare Tunnel

```bash
./setup-cloudflare-tunnel.sh
```

## 🔧 Manual Service Management

### Start/Stop Individual Services

```bash
# Start a service
sudo systemctl start <service-name>

# Stop a service
sudo systemctl stop <service-name>

# Restart a service
sudo systemctl restart <service-name>

# Enable service to start on boot
sudo systemctl enable <service-name>

# Check service status
sudo systemctl status <service-name>
```

### View Logs

```bash
# Follow logs for a specific service
sudo journalctl -u <service-name> -f

# View last 100 lines of logs
sudo journalctl -u <service-name> -n 100

# View logs for all sites
sudo journalctl -u rootedapp -u fuelshield -u relay -u purepulse -u pacmac -u p3lending -u eventtransport -f
```

## 🌐 Cloudflare Tunnel

### Configuration

The tunnel configuration is in `cloudflare/config.yml` and maps each domain to its local port.

### DNS Setup

For each domain, add a CNAME record in Cloudflare pointing to your tunnel:

```bash
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

### Running the Tunnel

#### Manual Mode
```bash
cloudflared tunnel --config ~/.cloudflared/config.yml run purepulse-r510
```

#### As a Service
```bash
sudo cloudflared service install
sudo systemctl start cloudflared
sudo systemctl enable cloudflared
```

## 📊 Monitoring

### Check All Services Status

```bash
sudo systemctl status rootedapp fuelshield relay purepulse pacmac p3lending eventtransport --no-pager
```

### Check Cloudflare Tunnel Status

```bash
sudo systemctl status cloudflared
```

### View All Logs in Real-time

```bash
# All site logs
sudo journalctl -u rootedapp -u fuelshield -u relay -u purepulse -u pacmac -u p3lending -u eventtransport -f

# Cloudflare tunnel logs
sudo journalctl -u cloudflared -f
```

## 🛠️ Tech Stack

### Static Sites (http-server)
- **Rooted Daily**: Port 3002
- **FuelShield**: Port 3005
- **Relay**: Port 3006

### React/Vite Applications
- **PurePulse Marketing**: Port 3000 (Vite)
- **PacMac ACP**: Port 3007 (Vite)
- **P3 Lending Protocol**: Port 5173 (Vite + Express backend on 5001)
- **Event Transport Protocol**: Port 3008 (Vite + Express backend)

### Complex Applications
- **Morrow**: Port 3009 (Vinext/Next.js-like framework, uses pnpm)
- **NorthStar Recovery**: Port 3010 (React Native + Website)
- **FlowOS Project Aquarius**: Port 3011 (Python-based)

## 📝 Port Allocation

| Port | Service |
|------|---------|
| 3000 | PurePulse Marketing |
| 3002 | Rooted Daily |
| 3005 | FuelShield |
| 3006 | Relay |
| 3007 | PacMac ACP |
| 3008 | Event Transport Protocol |
| 3009 | Morrow |
| 3010 | NorthStar Recovery |
| 3011 | FlowOS Project Aquarius |
| 3012 | Matty's SDR Blog (TBD) |
| 5001 | P3 Lending Backend API |
| 5173 | P3 Lending Frontend |

## 🔐 Security Notes

- All services run as user `matt`
- Services automatically restart on failure
- Cloudflare tunnel provides SSL/TLS termination
- No direct port exposure to the internet

## 🐛 Troubleshooting

### Service won't start

```bash
# Check logs for errors
sudo journalctl -u <service-name> -n 50

# Check if port is already in use
sudo lsof -i :<port-number>

# Verify service file is correct
sudo systemctl cat <service-name>
```

### Cloudflare tunnel issues

```bash
# Check tunnel status
cloudflared tunnel list

# Test tunnel connection
cloudflared tunnel run purepulse-r510

# View tunnel logs
sudo journalctl -u cloudflared -f
```

### Site not loading

1. Check if service is running: `sudo systemctl status <service-name>`
2. Check if tunnel is running: `sudo systemctl status cloudflared`
3. Verify DNS records in Cloudflare dashboard
4. Check service logs: `sudo journalctl -u <service-name> -f`

## 📚 Additional Resources

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Systemd Service Documentation](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [agents.md](./agents.md) - Detailed deployment work log

## 🤝 Contributing

To add a new site:

1. Create a new systemd service file in `systemd/`
2. Add the domain mapping to `cloudflare/config.yml`
3. Update this README with the new site information
4. Update `agents.md` with deployment notes
5. Run `./install-services.sh` to install the new service

---

**Last Updated**: 2026-10-21  
**Maintained by**: Matt Hagen  
**Server**: R510 (Ubuntu Server)
