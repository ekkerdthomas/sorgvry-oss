# Build stage
FROM dart:stable AS build
WORKDIR /app

# Workspace pubspec (keep sdk constraint in sync with root pubspec.yaml)
RUN printf 'name: sorgvry_workspace\npublish_to: none\n\nenvironment:\n  sdk: ^3.10.0\n\nworkspace:\n  - packages/sorgvry_shared\n  - backend\n' > pubspec.yaml

COPY packages/sorgvry_shared/ packages/sorgvry_shared/
COPY backend/ backend/
WORKDIR /app/backend
RUN dart pub get
RUN dart pub global activate dart_frog_cli 1.2.14
ENV PATH="$PATH:/root/.pub-cache/bin"
RUN dart_frog build
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Run stage
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libsqlite3-0 && rm -rf /var/lib/apt/lists/*
COPY --from=build /app/backend/build/bin/server /app/server
EXPOSE 8080
ENV PORT=8080
CMD ["/app/server"]
