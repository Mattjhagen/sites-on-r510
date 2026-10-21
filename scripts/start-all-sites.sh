#!/bin/bash
# Start all PurePulse sites

echo "Starting all PurePulse sites..."

# Array of service names
services=(
    "rootedapp"
    "fuelshield"
    "relay"
    "purepulse"
    "pacmac"
    "p3lending"
    "eventtransport"
)

# Start each service
for service in "${services[@]}"; do
    echo "Starting $service..."
    sudo systemctl start "$service.service"
    sudo systemctl enable "$service.service"

    # Check status
    if systemctl is-active --quiet "$service.service"; then
        echo "✓ $service is running"
    else
        echo "✗ $service failed to start"
    fi
done

echo ""
echo "Checking all services status:"
sudo systemctl status rootedapp fuelshield relay purepulse pacmac p3lending eventtransport --no-pager

echo ""
echo "All sites started! To view logs:"
echo "sudo journalctl -u <service-name> -f"
