<h1 align="center">Local Native Setup</h1>

<p align="center">Procedure for executing Lavalink directly on the host machine using bare metal Java without container runtimes.</p>

## Overview

This setup executes Lavalink as a native Java 21 process on your operating system. Network traffic and WebSocket streaming communicate directly through local loopback on port 2333.

## System Prerequisites

<table width="100%" style="width: 100%; border-collapse: collapse; margin-top: 14px; margin-bottom: 24px; font-size: 13.5px; border: 1px solid #d0d7de; border-radius: 6px; overflow: hidden;">
  <thead>
    <tr style="background-color: #f6f8fa; border-bottom: 2px solid #d0d7de;">
      <th style="padding: 10px 14px; text-align: left; width: 30%; font-weight: 600; color: #1f2328;">Component</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Requirement</th>
      <th style="padding: 10px 14px; text-align: left; width: 35%; font-weight: 600; color: #1f2328;">Installation Command</th>
    </tr>
  </thead>
  <tbody>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Java Runtime</td>
      <td style="padding: 10px 14px; color: #1f2328;">Java 21 LTS or higher</td>
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">sudo apt install -y openjdk-21-jre-headless</code></td>
    </tr>
    <tr style="background-color: #f8f9fa;">
      <td style="padding: 10px 14px; color: #1f2328; font-weight: 600;">Download Utility</td>
      <td style="padding: 10px 14px; color: #1f2328;">curl binary</td>
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">sudo apt install -y curl</code></td>
    </tr>
  </tbody>
</table>

## Environment Configuration

Generate the environment configuration file from the template:

```bash
cp .env.example .env
```

Apply the following values inside .env for native execution:

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
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Network port for REST and WebSocket calls.</td>
    </tr>
    <tr style="background-color: #f8f9fa; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">SERVER_ADDRESS</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">localhost</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Restricts listening strictly to local loopback interface.</td>
    </tr>
    <tr style="background-color: #ffffff; border-bottom: 1px solid #d0d7de;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">LAVALINK_SERVER_PASSWORD</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">LocalSecretAuthPass2026</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Password for client bot authentication.</td>
    </tr>
    <tr style="background-color: #f8f9fa;">
      <td style="padding: 10px 14px;"><code style="font-size: 12.5px; font-weight: 600; color: #0969da; background-color: #f0f6fc; border: 1px solid #d0d7de; padding: 2px 7px; border-radius: 5px;">PLUGINS_YOUTUBE_REMOTE_CIPHER_URL</code></td>
      <td style="padding: 10px 14px; color: #1f2328;">http://localhost:8001</td>
      <td style="padding: 10px 14px; color: #1f2328; line-height: 1.5;">Points to local cipher resolver if running natively.</td>
    </tr>
  </tbody>
</table>

## Installation and Execution

Download the Lavalink 4.2.2 binary:

```bash
curl -L -o Lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/4.2.2/Lavalink.jar
mkdir -p plugins logs
```

Start the node with studio audio memory arguments:

```bash
set -a
source .env
set +a
java -Xmx4G -Xms2G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -jar Lavalink.jar
```

On Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force -Path plugins, logs | Out-Null
Get-Content .env | Where-Object { $_ -notmatch '^#' -and $_ -match '=' } | ForEach-Object {
    $parts = $_ -split '=', 2
    [System.Environment]::SetEnvironmentVariable($parts[0].Trim(), $parts[1].Trim(), "Process")
}
java -Xmx4G -Xms2G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -jar Lavalink.jar
```

## Client Node Connection Settings

Configure your Discord bot to communicate directly over loopback:

```json
{
  "name": "lavalink-native-local",
  "host": "localhost",
  "port": 2333,
  "password": "LocalSecretAuthPass2026",
  "secure": false
}
```
