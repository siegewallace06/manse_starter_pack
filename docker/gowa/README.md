# Go WhatsApp Web Multi-Device

A Go-based WhatsApp Web Multi-Device API that allows you to send and receive WhatsApp messages programmatically. This service provides a REST API interface to interact with WhatsApp Web.

## Features
- Send text messages, images, documents, videos, audio
- Receive webhooks for incoming messages
- Multi-device support (same as WhatsApp Web)
- Auto-reply functionality
- Group message support
- Contact management
- QR code authentication via web interface
- REST API with comprehensive endpoints

## Access
- **Web Interface**: http://your-server-ip:3000
- **API Documentation**: http://your-server-ip:3000/docs

## Default Credentials
- **Username**: admin
- **Password**: admin123

**⚠️ Important**: Change these credentials immediately after first login!

## Quick Start
```bash
cd docker/gowa
docker compose up -d
```

## Initial Setup
1. Start the service with `docker compose up -d`
2. Open http://your-server-ip:3000 in your browser
3. Login with the default credentials
4. Scan the QR code with your WhatsApp mobile app
5. Your WhatsApp will be connected and ready to use

## Configuration
Before starting, you should modify the environment variables in `docker-compose.yml`:

### Essential Changes
1. Change `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD`
2. Set your timezone in `APP_TIMEZONE`
3. Configure webhook URL if you want to receive message notifications
4. Set up auto-reply messages if needed

### Webhook Configuration
If you want to receive real-time notifications for incoming messages:
```yaml
environment:
  - WEBHOOK=https://your-webhook-url.com/webhook
  - WEBHOOK_HEADER=Authorization: Bearer your-token
  - WEBHOOK_SECRET=your-secret-key
```

## API Endpoints
The service provides various REST API endpoints:

### Authentication
- `GET /app/login` - Login page
- `GET /app/logout` - Logout

### Device Management
- `GET /app/devices` - List connected devices
- `DELETE /app/devices/{device_id}` - Disconnect device

### Messaging
- `POST /send/message` - Send text message
- `POST /send/image` - Send image
- `POST /send/file` - Send document
- `POST /send/video` - Send video
- `POST /send/audio` - Send audio

### Contacts & Groups
- `GET /app/contacts` - Get contacts
- `GET /app/groups` - Get groups
- `POST /app/groups` - Create group

Full API documentation is available at `/docs` endpoint.

## Data Persistence
- WhatsApp session data: `./storages`
- Application logs: `./logs`

## Security Recommendations
1. Change default username and password
2. Use strong webhook secrets
3. Place behind a reverse proxy with SSL (like nginx-proxy-manager)
4. Restrict API access with proper authentication
5. Monitor logs for suspicious activity

## Auto-Reply Setup
Configure automatic replies to incoming messages:
```yaml
environment:
  - AUTO_REPLY_MESSAGE="Thank you for your message. We will get back to you soon!"
  - AUTO_REPLY_WEBHOOK=https://your-webhook-for-auto-reply.com
```

## Backup
To backup your WhatsApp session and data:
```bash
tar -czf whatsapp-backup-$(date +%Y%m%d).tar.gz storages logs
```

## Troubleshooting
- **QR Code not appearing**: Check if the service is running and accessible
- **Connection lost**: Re-scan the QR code to reconnect
- **API not responding**: Check logs with `docker compose logs -f`
- **Webhook not working**: Verify webhook URL is accessible and credentials are correct

## Important Notes
- This service connects to WhatsApp Web, not the official WhatsApp Business API
- Keep your session active by regular use
- WhatsApp may disconnect inactive sessions
- Always backup your session data before updates

## Example Usage
Send a message via API:
```bash
curl -X POST http://your-server:3000/send/message \
  -H "Content-Type: application/json" \
  -u admin:admin123 \
  -d '{
    "phone": "1234567890",
    "message": "Hello from Go WhatsApp Web!"
  }'
```