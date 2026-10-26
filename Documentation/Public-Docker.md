<h1 align="center">Public Docker Setup</h1>

<p align="center">Procedure for deploying a publicly accessible Lavalink node using Docker Compose and automatic HTTPS through Caddy.</p>

## Overview

This architecture deploys Lavalink alongside the YouTube cipher resolver behind a Caddy reverse proxy. Port 80 and 443 are exposed to handle automatic Let's Encrypt SSL certificates and WebSocket termination. Port 2333 remains internal to the Docker network for enhanced security.

## Infrastructure Prerequisites

<table width="100%" style="width: 100%; border-collapse: collapse; margin-top: 14px; margin-bottom: 24px; font-size: 13.5px; border: 1px solid #d0d7de; border-radius: 6px; overflow: hidden;">
  <thead>
    <tr style="background-color: #f6f8fa; border-bottom: 2px solid #d0d7de;">
      <th style="padding: 10px 14px; text-align: left; width: 30%; font-weight: 600; color: #1f2328;">Prerequisite</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Specification</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Action Required</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">DNS Record</td>
      <td style="padding: 10px 14px; color: #1f2328;">A or AAAA Record</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Point your domain (for example lavalink.domain.com) to your server public IP address.</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Firewall Ports</td>
      <td style="padding: 10px 14px; color: #1f2328;">80 TCP and 443 TCP</td>
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
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">DOMAIN</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">lavalink.yourdomain.com</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Public domain used by Caddy for TLS generation.</td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">LAVALINK_SERVER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">YourStrongPublicPasswordHere</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Robust authorization password for public bot access.</td>
    </tr>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">PLUGINS_YOUTUBE_REMOTE_CIPHER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">YourStrongPublicPasswordHere</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Internal cipher authentication secret.</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_HTTP2_ENABLED</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">true</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Enables HTTP2 performance over TLS.</td>
    </tr>
  </tbody>
</table>

## Deployment Commands

Execute the automated setup script to deploy the full container stack:

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

Verify Caddy TLS certificate issuance:

```bash
docker compose logs -f caddy
```

Verify Lavalink node connectivity:

```bash
docker compose logs -f lavalink
```

## Client Node Connection Settings

Configure external Discord bots to connect through the secure HTTPS reverse proxy:

```json
{
  "name": "lavalink-public-node",
  "host": "lavalink.yourdomain.com",
  "port": 443,
  "password": "YourStrongPublicPasswordHere",
  "secure": true
}
```
