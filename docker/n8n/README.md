# n8n Workflow Automation

n8n is a powerful workflow automation tool that lets you connect different services and automate tasks.

## Features
- Visual workflow builder
- 200+ integrations with popular services
- Custom code execution (JavaScript/Python)
- Webhook support
- Scheduled executions
- Error handling and retry logic

## Access
- **Web Interface**: http://your-server-ip:5678

## Default Credentials
- **Username**: admin
- **Password**: admin123

**⚠️ Important**: Change these credentials immediately after first login!

## Quick Start
```bash
cd docker/n8n
docker compose up -d
```

## Configuration
Before starting, you should modify the environment variables in `docker-compose.yml`:

### Essential Changes
1. Change `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`
2. Update `WEBHOOK_URL` to your actual domain/IP
3. Set `GENERIC_TIMEZONE` to your timezone

### Optional Enhancements
- Enable PostgreSQL for better performance (uncomment postgres service)
- Enable Redis for queue management (uncomment redis service)
- Configure SMTP for email notifications
- Set up SSL/TLS (change N8N_PROTOCOL to https and N8N_SECURE_COOKIE to true)

## Data Persistence
- Workflow data and configurations: `./data`
- File storage for workflows: `./files`

## Database Options
- **SQLite** (default): Simple setup, good for single-user
- **PostgreSQL**: Better performance for multiple users and complex workflows

## Security Recommendations
1. Use strong authentication credentials
2. Place behind a reverse proxy with SSL
3. Restrict network access if possible
4. Regularly backup your workflow data

## Backup
To backup your n8n workflows and data:
```bash
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz data files
```

## Useful Environment Variables
- `N8N_HOST`: Host to bind to (default: 0.0.0.0)
- `N8N_PORT`: Port to run on (default: 5678)
- `N8N_PROTOCOL`: http or https
- `WEBHOOK_URL`: Base URL for webhooks
- `EXECUTIONS_DATA_MAX_AGE`: How long to keep execution data (hours)

## Integrations
n8n supports hundreds of integrations including:
- Google Services (Sheets, Drive, Gmail, etc.)
- Slack, Discord, Teams
- GitHub, GitLab
- AWS, Azure, GCP
- Databases (MySQL, PostgreSQL, MongoDB)
- And many more!