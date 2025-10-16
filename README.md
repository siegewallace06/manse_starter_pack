# VM Starter Pack 🚀

A comprehensive collection of installation scripts and Docker Compose configurations to quickly set up a development VM with essential tools and services.

## 📋 What's Included

### Installation Scripts
- **Docker** - Container runtime and Docker Compose
- **Node.js** - JavaScript runtime via NVM (Node Version Manager)
- **PM2** - Process manager for Node.js applications
- **Tailscale** - Secure VPN mesh networking

### Docker Services
- **Nginx Proxy Manager** - Web-based reverse proxy management
- **Go WhatsApp Web Multi-Device** - WhatsApp Web API for sending/receiving messages
- **n8n** - Workflow automation platform

## 🚀 Quick Start

### Option 1: Install Everything at Once
```bash
# Clone or download this repository
git clone <repository-url>
cd manse_starter_pack

# Install all tools and start all services
./setup.sh full
```

### Option 2: Step by Step
```bash
# Install basic tools only
./setup.sh install

# Start Docker services later
./setup.sh start
```

## 📂 Repository Structure

```
manse_starter_pack/
├── setup.sh                     # Master setup script
├── scripts/                     # Installation scripts
│   ├── install-docker.sh        # Docker installation
│   ├── install-nodejs.sh        # Node.js + NVM installation
│   ├── install-pm2.sh          # PM2 installation
│   └── install-tailscale.sh    # Tailscale installation
├── docker/                     # Docker Compose configurations
│   ├── nginx-proxy-manager/    # Reverse proxy manager
│   ├── gowa/                   # Go development environment
│   └── n8n/                    # Workflow automation
└── README.md                   # This file
```

## 🛠 Individual Scripts

### Installation Scripts

All scripts are located in the `scripts/` directory and can be run individually:

```bash
# Install Docker
./scripts/install-docker.sh

# Install Node.js with NVM
./scripts/install-nodejs.sh

# Install PM2
./scripts/install-pm2.sh

# Install Tailscale
./scripts/install-tailscale.sh
```

### Docker Services

Each service has its own directory with `docker-compose.yml` and `README.md`:

```bash
# Start individual services
cd docker/nginx-proxy-manager && docker compose up -d
cd docker/gowa && docker compose up -d
cd docker/n8n && docker compose up -d
```

## 🌐 Service Access URLs

After starting the services, they will be available at:

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| **Nginx Proxy Manager** | http://your-server:81 | admin@example.com / changeme |
| **Go WhatsApp Web** | http://your-server:3000 | admin / admin123 |
| **n8n** | http://your-server:5678 | admin / admin123 |

> ⚠️ **Security Warning**: Change all default passwords immediately after first login!

## 📖 Master Script Usage

The `setup.sh` script provides several commands:

```bash
./setup.sh install    # Install all basic tools
./setup.sh start      # Start all Docker services
./setup.sh stop       # Stop all Docker services
./setup.sh status     # Show service status
./setup.sh urls       # Show service access URLs
./setup.sh full       # Install everything and start services
./setup.sh help       # Show help message
```

## 🔧 Customization

### Environment Variables

Each Docker service can be customized by modifying environment variables in their respective `docker-compose.yml` files:

- **Security**: Change default passwords and secret keys
- **Ports**: Modify exposed ports if needed
- **Database**: Switch from SQLite to PostgreSQL for better performance
- **Domain**: Update webhook URLs and hostnames

### Adding New Services

To add a new Docker service:

1. Create a new directory in `docker/`
2. Add `docker-compose.yml` and `README.md`
3. Update the `setup.sh` script to include the new service

## 🔒 Security Recommendations

1. **Change Default Credentials**: Update all default usernames and passwords
2. **Use Strong Secrets**: Generate random secret keys and tokens
3. **Enable SSL/TLS**: Configure HTTPS for production environments
4. **Firewall Configuration**: Restrict access to necessary ports only
5. **Regular Updates**: Keep Docker images and system packages updated
6. **Backup Strategy**: Implement regular backups of service data

## 🗂 Data Persistence

All services store their data in local directories:

- **Nginx Proxy Manager**: `docker/nginx-proxy-manager/data/`
- **Gowa**: `docker/gowa/data/`
- **n8n**: `docker/n8n/data/`

## 💾 Backup Strategy

Each service directory contains backup instructions. General backup command:

```bash
# Backup all service data
tar -czf vm-backup-$(date +%Y%m%d).tar.gz docker/*/data docker/*/config
```

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure scripts are executable (`chmod +x script.sh`)
2. **Port Conflicts**: Check if ports are already in use (`netstat -tlnp`)
3. **Docker Not Running**: Start Docker service (`sudo systemctl start docker`)
4. **Service Won't Start**: Check logs (`docker compose logs service-name`)

### Checking Service Status

```bash
# Check all services
./setup.sh status

# Check specific service
cd docker/service-name && docker compose ps

# View service logs
cd docker/service-name && docker compose logs -f
```

## 📋 System Requirements

- **OS**: Ubuntu 20.04+, Debian 10+, CentOS 8+, or RHEL 8+
- **RAM**: Minimum 2GB (4GB+ recommended)
- **Storage**: At least 10GB free space
- **Network**: Internet connection for downloads and updates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source. Feel free to use, modify, and distribute as needed.

## 🆘 Support

For issues and questions:

1. Check the individual service README files
2. Review the troubleshooting section
3. Check Docker logs for specific services
4. Consult the official documentation for each tool

---

**Happy coding!** 🎉