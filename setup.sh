#!/bin/bash

# VM Setup Master Script
# Installs all required tools and optionally starts Docker services

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$SCRIPT_DIR/docker"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Print banner
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    VM Setup Master Script                    ║"
    echo "║                                                              ║"
    echo "║  This script will install and configure essential tools     ║"
    echo "║  for your VM development environment.                       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to reload shell environment
reload_shell_env() {
    # Source common shell configuration files
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.profile" ]; then
        source "$HOME/.profile"
    fi
    
    # Explicitly load NVM if it exists
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install basic tools
install_basic_tools() {
    print_status "Installing basic development tools..."
    
    local install_failed=false
    
    # Docker
    if ! command_exists docker; then
        print_status "Installing Docker..."
        if bash "$SCRIPT_DIR/scripts/install-docker.sh"; then
            print_success "Docker installation completed"
        else
            print_error "Docker installation failed"
            install_failed=true
        fi
    else
        print_warning "Docker is already installed"
    fi
    
    # Node.js via NVM
    if [ ! -s "$HOME/.nvm/nvm.sh" ] && ! command_exists node; then
        print_status "Installing Node.js with NVM..."
        if bash "$SCRIPT_DIR/scripts/install-nodejs.sh"; then
            print_success "Node.js installation completed"
            
            # Reload shell environment after NVM installation
            print_status "Reloading shell environment..."
            reload_shell_env
            
            # Verify Node.js is now available
            if command_exists node; then
                print_success "Node.js is now available in PATH"
            else
                print_warning "Node.js installation completed but may require manual shell reload"
                print_warning "You may need to run: source ~/.bashrc && ./setup.sh install"
            fi
        else
            print_error "Node.js installation failed"
            install_failed=true
        fi
    else
        print_warning "Node.js/NVM is already installed"
        # Ensure environment is loaded even if already installed
        reload_shell_env
    fi
    
    # PM2
    if ! command_exists pm2; then
        print_status "Installing PM2..."
        
        # Ensure Node.js/npm is available before installing PM2
        reload_shell_env
        
        if ! command_exists node; then
            print_error "Node.js is not available. Cannot install PM2."
            print_warning "Please run the script again or manually source your shell configuration."
            install_failed=true
        else
            # PM2 installation script may exit with non-zero due to startup command
            # but PM2 itself might be installed successfully, so let's check
            set +e  # Temporarily disable exit on error
            bash "$SCRIPT_DIR/scripts/install-pm2.sh"
            set -e  # Re-enable exit on error
            
            # Check if PM2 installation was successful regardless of script exit code
            reload_shell_env
            if command_exists pm2; then
                print_success "PM2 installation completed"
            else
                print_warning "PM2 installation may require manual shell reload"
                print_warning "You may need to run: source ~/.bashrc && ./setup.sh install"
            fi
        fi
    else
        print_warning "PM2 is already installed"
    fi
    
    # Tailscale
    if ! command_exists tailscale; then
        print_status "Installing Tailscale..."
        if bash "$SCRIPT_DIR/scripts/install-tailscale.sh"; then
            print_success "Tailscale installation completed"
        else
            print_error "Tailscale installation failed"
            install_failed=true
        fi
    else
        print_warning "Tailscale is already installed"
    fi
    
    if [ "$install_failed" = true ]; then
        print_error "Some installations failed. Please check the errors above and try again."
        return 1
    fi
}

# Function to start Docker services
start_docker_services() {
    if ! command_exists docker; then
        print_error "Docker is not installed. Please run installation first."
        return 1
    fi
    
    print_status "Starting Docker services..."
    
    services=("nginx-proxy-manager" "gowa" "n8n")
    
    for service in "${services[@]}"; do
        if [ -d "$DOCKER_DIR/$service" ]; then
            read -p "Start $service? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Starting $service..."
                cd "$DOCKER_DIR/$service"
                
                # Check if .env file exists, if not copy from .env.example
                if [ ! -f ".env" ] && [ -f ".env.example" ]; then
                    print_warning ".env file not found for $service, copying from .env.example"
                    cp .env.example .env
                    print_warning "Please edit .env file and restart the service with your custom settings"
                fi
                
                docker compose up -d
                print_success "$service started successfully"
            fi
        else
            print_warning "Service directory $service not found"
        fi
    done
}

# Function to stop Docker services
stop_docker_services() {
    print_status "Stopping Docker services..."
    
    services=("nginx-proxy-manager" "gowa" "n8n")
    
    for service in "${services[@]}"; do
        if [ -d "$DOCKER_DIR/$service" ]; then
            print_status "Stopping $service..."
            cd "$DOCKER_DIR/$service"
            docker compose down
            print_success "$service stopped"
        fi
    done
}

# Function to show service status
show_service_status() {
    print_status "Docker service status:"
    
    services=("nginx-proxy-manager" "gowa" "n8n")
    
    for service in "${services[@]}"; do
        if [ -d "$DOCKER_DIR/$service" ]; then
            echo -e "\n${BLUE}=== $service ===${NC}"
            cd "$DOCKER_DIR/$service"
            docker compose ps
        fi
    done
}

# Function to reload environment and check status
reload_and_check() {
    print_status "Reloading shell environment..."
    reload_shell_env
    
    echo -e "\n${BLUE}Installation Status Check:${NC}"
    echo "┌─────────────────────────────────────────────────────────────┐"
    
    # Check Docker
    if command_exists docker; then
        echo -e "│ ✅ Docker:     $(docker --version | cut -d' ' -f3)                    │"
    else
        echo -e "│ ❌ Docker:     Not installed                               │"
    fi
    
    # Check Node.js
    if command_exists node; then
        echo -e "│ ✅ Node.js:    $(node --version)                              │"
    else
        echo -e "│ ❌ Node.js:    Not installed                               │"
    fi
    
    # Check PM2
    if command_exists pm2; then
        echo -e "│ ✅ PM2:       $(pm2 --version)                                  │"
    else
        echo -e "│ ❌ PM2:       Not installed                                │"
    fi
    
    # Check Tailscale
    if command_exists tailscale; then
        echo -e "│ ✅ Tailscale: Installed                                    │"
    else
        echo -e "│ ❌ Tailscale: Not installed                               │"
    fi
    
    echo "└─────────────────────────────────────────────────────────────┘"
    
    # Count missing tools
    missing_count=0
    ! command_exists docker && ((missing_count++))
    ! command_exists node && ((missing_count++))
    ! command_exists pm2 && ((missing_count++))
    ! command_exists tailscale && ((missing_count++))
    
    if [ $missing_count -eq 0 ]; then
        print_success "All tools are installed and available!"
    else
        print_warning "$missing_count tool(s) missing or not in PATH"
        echo "💡 To install missing tools, run: ./setup.sh install"
        if ! command_exists node || ! command_exists pm2; then
            echo "💡 If Node.js/PM2 issues persist, try: source ~/.bashrc && ./setup.sh reload"
        fi
    fi
}

# Function to show service URLs
show_service_urls() {
    echo -e "\n${GREEN}Service Access URLs:${NC}"
    echo "┌─────────────────────────────────────────────────────────────┐"
    echo "│ Nginx Proxy Manager: http://your-server-ip:81              │"
    echo "│ Go WhatsApp Web:    http://your-server-ip:3000             │"
    echo "│ n8n:                http://your-server-ip:5678             │"
    echo "└─────────────────────────────────────────────────────────────┘"
    echo -e "\n${YELLOW}Remember to change default passwords!${NC}"
}

# Function to display help
show_help() {
    echo "VM Setup Master Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  install           Install all basic tools (Docker, Node.js, PM2, Tailscale)"
    echo "  start             Start all Docker services"
    echo "  stop              Stop all Docker services"
    echo "  status            Show status of Docker services"
    echo "  urls              Show service access URLs"
    echo "  full              Install tools and start services"
    echo "  reload            Reload shell environment and check installations"
    echo "  help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install         # Install all tools"
    echo "  $0 start           # Start Docker services"
    echo "  $0 full            # Install everything and start services"
    echo "  $0 reload          # Reload environment and check status"
}

# Main execution
main() {
    print_banner
    
    case "${1:-}" in
        "install")
            if install_basic_tools; then
                print_success "All installations completed!"
                echo ""
                print_status "Running final status check..."
                reload_and_check
            else
                print_error "Installation completed with errors. Run './setup.sh reload' to check status."
                exit 1
            fi
            ;;
        "start")
            start_docker_services
            show_service_urls
            ;;
        "stop")
            stop_docker_services
            ;;
        "status")
            show_service_status
            ;;
        "urls")
            show_service_urls
            ;;
        "reload")
            reload_and_check
            ;;
        "full")
            if install_basic_tools; then
                print_success "All installations completed!"
                print_status "Starting Docker services..."
                start_docker_services
                show_service_urls
            else
                print_error "Installation failed. Please check errors and try again."
                exit 1
            fi
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            print_warning "No option specified. Use 'help' to see available options."
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Execute main function with all arguments
main "$@"