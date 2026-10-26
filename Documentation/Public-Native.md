<h1 align="center">Public Native Setup</h1>

<p align="center">Procedure for running Lavalink natively on a Linux host with public internet access, managed by systemd and secured by Nginx or Caddy.</p>

## Overview

In this deployment model, Lavalink runs directly on the bare metal host managed as an operating system service through systemd. A lightweight web server such as Nginx or standalone Caddy terminates TLS on port 443 and proxies WebSocket traffic to local port 2333.

## Infrastructure Prerequisites

<table width="100%" style="width: 100%; border-collapse: collapse; margin-top: 14px; margin-bottom: 24px; font-size: 13.5px; border: 1px solid #d0d7de; border-radius: 6px; overflow: hidden;">
  <thead>
    <tr style="background-color: #f6f8fa; border-bottom: 2px solid #d0d7de;">
      <th style="padding: 10px 14px; text-align: left; width: 30%; font-weight: 600; color: #1f2328;">Component</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Requirement</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Command</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Java Runtime</td>
      <td style="padding: 10px 14px; color: #1f2328;">Java 21 LTS runtime</td>
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">sudo apt install -y openjdk-21-jre-headless</code></td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Reverse Proxy</td>
      <td style="padding: 10px 14px; color: #1f2328;">Nginx with Certbot</td>
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">sudo apt install -y nginx certbot python3-certbot-nginx</code></td>
    </tr>
    <tr style="background-color: #ffffff;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Firewall Ports</td>
      <td style="padding: 10px 14px; color: #1f2328;">Open 80 TCP and 443 TCP</td>
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">sudo ufw allow 80,443/tcp</code></td>
    </tr>
  </tbody>
</table>

## Environment Configuration

Generate the environment configuration file from the template:

```bash
cp .env.example .env
```

Apply the following production parameters inside .env:

<table width="100%" style="width: 100%; border-collapse: collapse; margin-top: 14px; margin-bottom: 24px; font-size: 13.5px; border: 1px solid #d0d7de; border-radius: 6px; overflow: hidden;">
  <thead>
    <tr style="background-color: #f6f8fa; border-bottom: 2px solid #d0d7de;">
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Variable</th>
      <th style="padding: 10px 14px; text-align: left; width: 30%; font-weight: 600; color: #1f2328;">Production Value</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_PORT</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">2333</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Internal loopback listening port.</td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_ADDRESS</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">127.0.0.1</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Locks Lavalink to local interface so outside traffic must pass through the reverse proxy.</td>
    </tr>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">LAVALINK_SERVER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">YourStrongPublicPasswordHere</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Public bot authentication secret.</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">PLUGINS_YOUTUBE_REMOTE_CIPHER_URL</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">http://127.0.0.1:8001</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Address of the local yt-cipher background worker.</td>
    </tr>
  </tbody>
</table>

## Systemd Service Installation

Download the binary:

```bash
curl -L -o Lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/4.2.2/Lavalink.jar
mkdir -p plugins logs
```

Create the systemd service file at `/etc/systemd/system/lavalink.service`:

```ini
[Unit]
Description=Lavalink Audio Streaming Server
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/Lavalink
EnvironmentFile=/opt/Lavalink/.env
ExecStart=/usr/bin/java -Xmx4G -Xms2G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -jar /opt/Lavalink/Lavalink.jar
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now lavalink
sudo systemctl status lavalink
```

## Nginx Reverse Proxy Configuration

Create `/etc/nginx/sites-available/lavalink`:

```nginx
server {
    server_name lavalink.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:2333;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable configuration and generate SSL certificates:

```bash
sudo ln -s /etc/nginx/sites-available/lavalink /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d lavalink.yourdomain.com
```

## Client Node Connection Settings

Configure external Discord bots to connect over the secure HTTPS endpoint:

```json
{
  "name": "lavalink-native-public",
  "host": "lavalink.yourdomain.com",
  "port": 443,
  "password": "YourStrongPublicPasswordHere",
  "secure": true
}
```
