#!/bin/bash

# Docker Installation Script
# Supports Ubuntu/Debian and CentOS/RHEL/Fedora

set -e

echo "🐳 Starting Docker installation..."

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VERSION=$VERSION_ID
else
    echo "❌ Cannot detect OS. Exiting."
    exit 1
fi

echo "📋 Detected OS: $OS"

# Function to install Docker on Ubuntu/Debian
install_docker_ubuntu() {
    echo "🔄 Installing Docker on Ubuntu/Debian..."
    
    # Update package index
    sudo apt-get update
    
    # Install required packages
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt-get update
    
    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Function to install Docker on CentOS/RHEL/Fedora
install_docker_rhel() {
    echo "🔄 Installing Docker on CentOS/RHEL/Fedora..."
    
    # Remove old versions
    sudo yum remove -y docker \
                      docker-client \
                      docker-client-latest \
                      docker-common \
                      docker-latest \
                      docker-latest-logrotate \
                      docker-logrotate \
                      docker-engine
    
    # Install required packages
    sudo yum install -y yum-utils
    
    # Set up repository
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    
    # Install Docker Engine
    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Install Docker based on OS
case "$OS" in
    "Ubuntu"*|"Debian"*)
        install_docker_ubuntu
        ;;
    "CentOS"*|"Red Hat"*|"Fedora"*)
        install_docker_rhel
        ;;
    *)
        echo "❌ Unsupported OS: $OS"
        exit 1
        ;;
esac

# Start and enable Docker service
echo "🚀 Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group
echo "👤 Adding current user to docker group..."
sudo usermod -aG docker $USER

# Test Docker installation
echo "🧪 Testing Docker installation..."
sudo docker run hello-world

echo "✅ Docker installation completed successfully!"
echo "📝 Note: You may need to log out and back in for group changes to take effect."
echo "🔍 Run 'docker --version' and 'docker compose version' to verify installation."