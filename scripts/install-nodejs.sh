#!/bin/bash

# Node.js Installation Script using NVM
# Installs NVM and the latest LTS version of Node.js

set -e

echo "📦 Starting Node.js installation with NVM..."

# Check if NVM is already installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "⚠️  NVM is already installed. Updating..."
    source "$HOME/.nvm/nvm.sh"
else
    echo "🔄 Installing NVM..."
    
    # Download and install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Reload shell configuration
echo "🔄 Reloading shell configuration..."
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# Source NVM again to ensure it's available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS Node.js
echo "🔄 Installing latest LTS Node.js..."
nvm install --lts
nvm use --lts
nvm alias default lts/*

# Verify installation
echo "🧪 Verifying installation..."
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

# Update npm to latest
echo "🔄 Updating npm to latest version..."
npm install -g npm@latest

echo "✅ Node.js installation completed successfully!"
echo "📝 Note: You may need to restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc'"
echo "🔍 Available commands:"
echo "  - node --version"
echo "  - npm --version"
echo "  - nvm list (to see installed versions)"
echo "  - nvm install <version> (to install specific version)"
echo "  - nvm use <version> (to switch versions)"