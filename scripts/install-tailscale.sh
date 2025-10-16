#!/bin/bash

# Tailscale Installation Script
# Installs and configures Tailscale VPN

set -e

echo "🔗 Starting Tailscale installation..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
else
    echo "❌ Cannot detect OS. Exiting."
    exit 1
fi

echo "📋 Detected OS: $OS"

# Function to install Tailscale on Ubuntu/Debian
install_tailscale_ubuntu() {
    echo "🔄 Installing Tailscale on Ubuntu/Debian..."
    
    # Add Tailscale's GPG key and repository
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    
    # Update package list and install
    sudo apt-get update
    sudo apt-get install -y tailscale
}

# Function to install Tailscale on CentOS/RHEL/Fedora
install_tailscale_rhel() {
    echo "🔄 Installing Tailscale on CentOS/RHEL/Fedora..."
    
    # Add Tailscale repository
    sudo yum-config-manager --add-repo https://pkgs.tailscale.com/stable/rhel/8/tailscale.repo
    
    # Install Tailscale
    sudo yum install -y tailscale
}

# Install Tailscale based on OS
case "$OS" in
    "Ubuntu"*|"Debian"*)
        install_tailscale_ubuntu
        ;;
    "CentOS"*|"Red Hat"*|"Fedora"*)
        install_tailscale_rhel
        ;;
    *)
        echo "❌ Unsupported OS: $OS"
        echo "📋 For other systems, please visit: https://tailscale.com/download"
        exit 1
        ;;
esac

# Enable and start Tailscale service
echo "🚀 Starting Tailscale service..."
sudo systemctl enable --now tailscaled

# Check service status
echo "🧪 Checking Tailscale service status..."
sudo systemctl status tailscaled --no-pager

echo "✅ Tailscale installation completed successfully!"
echo ""
echo "🔧 Next steps:"
echo "1. Run 'sudo tailscale up' to connect this device to your Tailscale network"
echo "2. Follow the authentication URL that appears"
echo "3. Use 'tailscale status' to check connection status"
echo "4. Use 'tailscale ip' to see your Tailscale IP address"
echo ""
echo "🔍 Useful Tailscale commands:"
echo "  - sudo tailscale up          # Connect to Tailscale"
echo "  - sudo tailscale down        # Disconnect from Tailscale"
echo "  - tailscale status           # Show connection status"
echo "  - tailscale ip               # Show Tailscale IP addresses"
echo "  - tailscale ping <device>    # Ping another device"
echo "  - sudo tailscale logout      # Logout from Tailscale"