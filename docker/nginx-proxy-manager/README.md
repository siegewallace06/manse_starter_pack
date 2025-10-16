# Nginx Proxy Manager

This setup provides the popular jc21/nginx-proxy-manager with a MySQL database backend.

## Features
- Web-based GUI for managing reverse proxy configurations
- Automatic SSL certificate generation with Let's Encrypt
- Built-in access lists and security features
- MySQL database for configuration storage

## Access
- **Admin Interface**: http://your-server-ip:81
- **HTTP Traffic**: Port 80
- **HTTPS Traffic**: Port 443

## Default Credentials
- **Email**: admin@example.com
- **Password**: changeme

**⚠️ Important**: Change these credentials immediately after first login!

## Quick Start
```bash
cd docker/nginx-proxy-manager
cp .env.example .env
# Edit .env file with your desired settings
docker compose up -d
```

## Configuration
Before starting, copy `.env.example` to `.env` and modify the values:

```bash
cp .env.example .env
```

Key settings to modify in `.env`:
- **Database passwords**: Change `MYSQL_ROOT_PASSWORD`, `MYSQL_PASSWORD`, etc.
- **Database settings**: Modify database name, user if needed
- **IPv6**: Uncomment `DISABLE_IPV6=true` if IPv6 is not enabled

## Configuration
- Data and configurations are stored in `./data`
- SSL certificates are stored in `./letsencrypt`
- MySQL data is stored in `./mysql`

## Backup
To backup your configuration:
```bash
tar -czf npm-backup-$(date +%Y%m%d).tar.gz data letsencrypt mysql
```