#!/usr/bin/env bash
set -euo pipefail

BACKEND_URL_WEB="/api"
BACKEND_URL_APK="https://sorgvry.phygital-tech.ai/api"

build_web() {
  echo "==> Building web app..."
  cd app
  flutter build web --dart-define="BACKEND_URL=$BACKEND_URL_WEB"
  cd ..
  echo "==> Web build complete: app/build/web/"
}

build_apk() {
  echo "==> Building APK (arm64 only)..."
  export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"
  export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
  cd app
  flutter build apk \
    --target-platform android-arm64 \
    --dart-define="BACKEND_URL=$BACKEND_URL_APK"
  cd ..
  echo "==> APK build complete: app/build/app/outputs/flutter-apk/app-release.apk"
}

# Parse arguments
TARGETS=("$@")
if [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS=("all")
fi

for target in "${TARGETS[@]}"; do
  case "$target" in
    web)     build_web ;;
    apk)     build_apk ;;
    all)     build_web; build_apk ;;
    *)       echo "Unknown target: $target (use: web, apk, all)"; exit 1 ;;
  esac
done
