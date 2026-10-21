#!/bin/bash
# Setup Cloudflare Tunnel for all PurePulse sites

echo "Setting up Cloudflare Tunnel..."

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo "Error: cloudflared is not installed"
    echo "Install from: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/"
    exit 1
fi

# Create tunnel (if it doesn't exist)
echo "Creating tunnel 'purepulse-r510'..."
cloudflared tunnel create purepulse-r510

# Copy config file
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$SCRIPT_DIR/../cloudflare/config.yml"

mkdir -p ~/.cloudflared
cp "$CONFIG_FILE" ~/.cloudflared/config.yml

echo ""
echo "Tunnel created! Now you need to:"
echo ""
echo "1. Add DNS records for each domain in Cloudflare Dashboard:"
echo "   - rootedapp.space → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - p3lending.space → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - velour.live → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - relayapp.pro → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - pacmacmobile.com → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - projectaquarius.space → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - cmameet.site → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - eventtransport.space → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - purepulse.one → CNAME to <tunnel-id>.cfargotunnel.com"
echo "   - mattjhagen.xyz → CNAME to <tunnel-id>.cfargotunnel.com"
echo ""
echo "Or use the cloudflared command to add DNS records:"
echo "  cloudflared tunnel route dns purepulse-r510 rootedapp.space"
echo ""
echo "2. Start the tunnel:"
echo "   cloudflared tunnel run purepulse-r510"
echo ""
echo "3. Or install as a service:"
echo "   sudo cloudflared service install"
echo "   sudo systemctl start cloudflared"
echo "   sudo systemctl enable cloudflared"
