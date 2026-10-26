#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "ERROR: .env file not found. Copy .env.example to .env before running setup."
  exit 1
fi

if grep -q '^LAVALINK_SERVER_PASSWORD=ChangeMeWithAStrongSecretPassword2026' .env; then
  echo "WARNING: Default LAVALINK_SERVER_PASSWORD detected in .env. Update it before public exposure."
fi

mkdir -p plugins logs

if command -v docker >/dev/null; then
  # Lavalink official container executes under UID/GID 322
  sudo chown -R 322:322 plugins logs 2>/dev/null || true
  chmod 600 .env 2>/dev/null || true

  docker compose config -q
  docker compose pull
  docker compose up -d
  docker compose ps
else
  echo "Initialized plugins and logs directories."
  echo "Native execution command: java -Xmx4G -Xms2G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -jar Lavalink.jar"
fi