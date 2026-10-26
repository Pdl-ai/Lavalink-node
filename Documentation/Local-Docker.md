<h1 align="center">Local Docker Setup</h1>

<p align="center">Procedure for running Lavalink and the YouTube cipher service locally on the host machine using Docker Compose.</p>

## Overview

This setup executes both Lavalink and yt-cipher within a private Docker bridge network while exposing port 2333 directly to the local host machine. The Caddy reverse proxy is not needed for strictly local deployments.

## Environment Configuration

Generate the local configuration file from the template:

```bash
cp .env.example .env
```

Apply the following values inside .env for a local container deployment:

<table width="100%" style="width: 100%; border-collapse: collapse; margin-top: 14px; margin-bottom: 24px; font-size: 13.5px; border: 1px solid #d0d7de; border-radius: 6px; overflow: hidden;">
  <thead>
    <tr style="background-color: #f6f8fa; border-bottom: 2px solid #d0d7de;">
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Variable</th>
      <th style="padding: 10px 14px; text-align: left; width: 30%; font-weight: 600; color: #1f2328;">Recommended Value</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_PORT</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">2333</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Port bound to the host network interface.</td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_ADDRESS</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">0.0.0.0</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Internal container binding address.</td>
    </tr>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">LAVALINK_SERVER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">LocalSecretAuthPass2026</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Authentication secret required by Discord bot clients.</td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">PLUGINS_YOUTUBE_REMOTE_CIPHER_URL</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">http://youtube-cipher:8001</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Internal Docker network address of the cipher engine.</td>
    </tr>
    <tr style="background-color: #ffffff;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">PLUGINS_YOUTUBE_REMOTE_CIPHER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">LocalSecretAuthPass2026</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Must match the primary server password.</td>
    </tr>
  </tbody>
</table>

## Deployment Commands

Start only the Lavalink node and the cipher container, bypassing the public Caddy service:

```bash
mkdir -p plugins logs
sudo chown -R 322:322 plugins logs 2>/dev/null || true
docker compose up -d youtube-cipher lavalink
```

Monitor service health and logs:

```bash
docker compose logs -f lavalink
```

Stop the services:

```bash
docker compose down
```

## Client Node Connection Settings

Configure your Discord bot running on the host machine to target the local container:

```json
{
  "name": "lavalink-docker-local",
  "host": "localhost",
  "port": 2333,
  "password": "LocalSecretAuthPass2026",
  "secure": false
}
```
