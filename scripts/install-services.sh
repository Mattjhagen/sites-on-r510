#!/bin/bash
# Install systemd service files for all PurePulse sites

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SYSTEMD_DIR="$SCRIPT_DIR/../systemd"

echo "Installing systemd service files..."

# Copy all service files to systemd directory
for service_file in "$SYSTEMD_DIR"/*.service; do
    service_name=$(basename "$service_file")
    echo "Installing $service_name..."
    sudo cp "$service_file" /etc/systemd/system/
done

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo ""
echo "✓ Service files installed!"
echo ""
echo "To start all services, run:"
echo "  ./start-all-sites.sh"
echo ""
echo "To start individual services:"
echo "  sudo systemctl start <service-name>"
echo "  sudo systemctl enable <service-name>"
