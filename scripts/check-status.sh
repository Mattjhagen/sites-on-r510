#!/bin/bash
# Check status of all PurePulse sites

echo "==================================="
echo "  PurePulse Sites Status Check"
echo "==================================="
echo ""

# Define sites and their ports
declare -A sites=(
    ["3000"]="PurePulse Marketing (purepulse.one)"
    ["3002"]="Rooted Daily (rootedapp.space)"
    ["3005"]="FuelShield (mattjhagen.github.io/FuelShield)"
    ["3006"]="Relay (relayapp.pro)"
    ["3007"]="PacMac ACP (pacmacmobile.com)"
    ["3008"]="Event Transport Protocol Web (eventtransport.space)"
    ["3009"]="Morrow (velour.live)"
    ["3010"]="NorthStar Recovery (cmameet.site)"
    ["3011"]="FlowOS Aquarius (projectaquarius.space)"
    ["5001"]="P3 Lending Backend API"
    ["5173"]="P3 Lending Frontend (p3lending.space)"
    ["8081"]="Event Transport Protocol API"
)

# Check each port
for port in $(echo "${!sites[@]}" | tr ' ' '\n' | sort -n); do
    site_name="${sites[$port]}"

    # Try to connect to the port
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$port 2>/dev/null)

    if [ "$response" = "200" ] || [ "$response" = "301" ] || [ "$response" = "302" ]; then
        echo "✓ Port $port: $site_name - Running (HTTP $response)"
    elif [ "$response" = "000" ]; then
        echo "✗ Port $port: $site_name - Not responding"
    else
        echo "⚠ Port $port: $site_name - HTTP $response"
    fi
done

echo ""
echo "==================================="
echo "Process count: $(ps aux | grep -E '(http-server|vite|npm|node)' | grep -v grep | wc -l) running"
echo "==================================="
