#!/usr/bin/env bash
set -euo pipefail

PI_HOST="ekkerdthomas@raspi-webserver"
REMOTE_DIR="/opt/sorgvry"

deploy_backend() {
  echo "==> Checking .env on Pi..."
  ssh "$PI_HOST" "test -f $REMOTE_DIR/.env" || { echo "ERROR: $REMOTE_DIR/.env not found on Pi"; exit 1; }

  echo "==> Syncing backend source to Pi..."
  rsync -az --delete \
    --exclude='.dart_tool' \
    --exclude='.packages' \
    --exclude='build/' \
    --exclude='.git' \
    --exclude='app/' \
    packages backend docker-compose.yml \
    "$PI_HOST:$REMOTE_DIR/src/"

  echo "==> Building and restarting backend on Pi..."
  ssh "$PI_HOST" "cd $REMOTE_DIR/src && docker compose up -d --build sorgvry-backend"
}

deploy_web() {
  echo "==> Syncing web app to Pi..."
  rsync -az --delete \
    app/build/web/ \
    "$PI_HOST:$REMOTE_DIR/web/"
}

deploy_apk() {
  echo "==> Syncing APK to Pi..."
  rsync -az \
    app/build/app/outputs/flutter-apk/app-release.apk \
    "$PI_HOST:$REMOTE_DIR/download/sorgvry.apk"
}

# Parse arguments
TARGETS=("$@")
if [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS=("all")
fi

for target in "${TARGETS[@]}"; do
  case "$target" in
    backend) deploy_backend ;;
    web)     deploy_web ;;
    apk)     deploy_apk ;;
    all)     deploy_backend; deploy_web; deploy_apk ;;
    *)       echo "Unknown target: $target (use: backend, web, apk, all)"; exit 1 ;;
  esac
done

echo "==> Done."
echo "    Web:      https://sorgvry.phygital-tech.ai/"
echo "    API:      https://sorgvry.phygital-tech.ai/api/health"
echo "    Download: https://sorgvry.phygital-tech.ai/download/sorgvry.apk"
