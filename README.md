<div align="center">

```
 _                       _ _       _    
| |                     | (_)     | |   
| |     __ ___   ____ _ | |_ _ __ | | __
| |    / _` \ \ / / _` || | | '_ \| |/ /
| |___| (_| |\ V / (_| || | | | | |   < 
\_____/\__,_| \_/ \__,_||_|_|_| |_|_|\_\
```

Lavalink v4 audio streaming node engineered for studio-grade fidelity, native Discord DAVE voice encryption, and resilient YouTube playback.

</div>

## Architecture

```
[ Discord Bot Client ]
        │
        ├── Direct Local or LAN ──> Port 2333 ──┐
        │                                       ▼
        └── Public HTTPS or WSS ──> Port 443 ───┼─> [ Lavalink 4.2.2 ]
                                                │            │
                                                │            ▼ Port 8001
                                                └─> [ yt-cipher Engine ]
```

## Core Highlights

* Studio Grade Audio Pipeline
Opus encoding quality set to level 10, high-precision resampling interpolation, non-allocating frame buffers disabled for immediate filter feedback, and a 5000ms frame buffer.

* Resilient YouTube Streaming
Integrates youtube-plugin 1.18.2 backed by remote yt-cipher signature deciphering, multi-tier client fallback across Music, Android, iOS, TV, and Web, with optional OAuth2 authentication.

* Discord DAVE Protocol
Full native support for Discord end-to-end voice encryption on Lavalink 4.2.2.

## Deployment Guides

Detailed configuration and execution procedures:

* [Local Docker Setup](Documentation/Local-Docker.md)
Containerized deployment on the local host via Docker Compose.

* [Local Native Setup](Documentation/Local-Native.md)
Bare metal execution on the local host with Java 21 LTS.

* [Public Docker Setup](Documentation/Public-Docker.md)
Internet-facing deployment with Docker Compose and automatic TLS via Caddy.

* [Public Native Setup](Documentation/Public-Native.md)
Internet-facing systemd service secured by an Nginx reverse proxy.

## Quick Start

```bash
cp .env.example .env
chmod +x scripts/setup.sh
./scripts/setup.sh
```

Inspect streaming operations:

```bash
docker compose logs -f lavalink
```

## Client Node Configuration

```json
{
  "name": "lavalink-node",
  "host": "localhost",
  "port": 2333,
  "password": "your_password",
  "secure": false
}
```

For public production instances using a domain, set host to your domain, port to 443, and secure to true.

## YouTube Anti-Bot Authentication

If hosting on datacenter IP addresses that encounter verification challenges:

1. Enable OAuth2 inside .env:
   PLUGINS_YOUTUBE_OAUTH_ENABLED=true

2. Start the Lavalink node and check terminal output.

3. Navigate to https://www.google.com/device and enter the user code.

4. Authenticate using a secondary Google account.

5. Save the generated refresh token into .env:
   PLUGINS_YOUTUBE_OAUTH_REFRESH_TOKEN=your_token_value
