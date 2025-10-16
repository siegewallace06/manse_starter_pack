#!/bin/bash

# PM2 Installation Script
# Installs PM2 process manager globally

set -e

echo "⚡ Starting PM2 installation..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first using the install-nodejs.sh script."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install Node.js first using the install-nodejs.sh script."
    exit 1
fi

echo "📋 Node.js version: $(node --version)"
echo "📋 npm version: $(npm --version)"

# Install PM2 globally
echo "🔄 Installing PM2 globally..."
npm install -g pm2

# Verify installation
echo "🧪 Verifying PM2 installation..."
pm2 --version

# Set up PM2 startup script
echo "🔄 Setting up PM2 startup script..."
pm2 startup

echo "✅ PM2 installation completed successfully!"
echo "📝 Important: To enable PM2 to start on boot, run the command that was displayed above."
echo "🔍 Useful PM2 commands:"
echo "  - pm2 start <app.js>     # Start an application"
echo "  - pm2 list               # List all processes"
echo "  - pm2 stop <id|name>     # Stop a process"
echo "  - pm2 restart <id|name>  # Restart a process"
echo "  - pm2 delete <id|name>   # Delete a process"
echo "  - pm2 logs               # Show logs"
echo "  - pm2 monit              # Monitor processes"
echo "  - pm2 save               # Save current process list"
echo "  - pm2 resurrect          # Restore saved processes"