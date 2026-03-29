---
name: deploy
description: Build and deploy the app (web, APK, backend) to the Pi server.
user-invocable: true
argument-hint: [all | web | apk | backend]
allowed-tools: Bash, Read, Grep, Glob
model: sonnet
---

# Deploy Skill

**PURPOSE**: Build Flutter artifacts and deploy to `raspi-webserver`.

## Usage

- `/deploy` or `/deploy all` — build everything, deploy everything
- `/deploy web` — build and deploy web app only
- `/deploy apk` — build and deploy APK only
- `/deploy backend` — deploy backend only (builds on Pi via Docker)

## Steps

### 1. Parse target

Default to `all` if no argument given. Valid targets: `all`, `web`, `apk`, `backend`.

### 2. Build (if target includes web or apk)

Run `./build.sh <targets>` from the project root. This builds:
- **web**: `flutter build web --dart-define=BACKEND_URL=/api`
- **apk**: `flutter build apk --dart-define=BACKEND_URL=https://sorgvry.phygital-tech.ai/api` (requires JAVA_HOME and ANDROID_HOME)

Wait for builds to complete. Report any build errors to the user and stop.

### 3. Deploy

Run `./deploy.sh <targets>` from the project root. This:
- **backend**: rsyncs source to Pi, runs `docker compose up -d --build`
- **web**: rsyncs `app/build/web/` to Pi
- **apk**: rsyncs APK to Pi as `sorgvry.apk`

### 4. Verify

After deploy, run these checks and report results:

```bash
curl -s https://sorgvry.phygital-tech.ai/api/health
```

If web was deployed:
```bash
curl -sI https://sorgvry.phygital-tech.ai/ | head -1
```

If APK was deployed:
```bash
curl -sI https://sorgvry.phygital-tech.ai/download/sorgvry.apk | head -1
```

Report success/failure for each target.
