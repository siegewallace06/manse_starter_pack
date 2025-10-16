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

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install basic tools
install_basic_tools() {
    print_status "Installing basic development tools..."
    
    # Docker
    if ! command_exists docker; then
        print_status "Installing Docker..."
        bash "$SCRIPT_DIR/scripts/install-docker.sh"
        print_success "Docker installation completed"
    else
        print_warning "Docker is already installed"
    fi
    
    # Node.js via NVM
    if [ ! -s "$HOME/.nvm/nvm.sh" ] && ! command_exists node; then
        print_status "Installing Node.js with NVM..."
        bash "$SCRIPT_DIR/scripts/install-nodejs.sh"
        print_success "Node.js installation completed"
    else
        print_warning "Node.js/NVM is already installed"
    fi
    
    # PM2
    if ! command_exists pm2; then
        print_status "Installing PM2..."
        bash "$SCRIPT_DIR/scripts/install-pm2.sh"
        print_success "PM2 installation completed"
    else
        print_warning "PM2 is already installed"
    fi
    
    # Tailscale
    if ! command_exists tailscale; then
        print_status "Installing Tailscale..."
        bash "$SCRIPT_DIR/scripts/install-tailscale.sh"
        print_success "Tailscale installation completed"
    else
        print_warning "Tailscale is already installed"
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
    echo "  help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install         # Install all tools"
    echo "  $0 start           # Start Docker services"
    echo "  $0 full            # Install everything and start services"
}

# Main execution
main() {
    print_banner
    
    case "${1:-}" in
        "install")
            install_basic_tools
            print_success "All installations completed!"
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
        "full")
            install_basic_tools
            print_status "Installation completed. Starting Docker services..."
            start_docker_services
            show_service_urls
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