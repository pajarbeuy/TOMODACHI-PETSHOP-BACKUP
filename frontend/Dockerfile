# ─── Build Flutter Web ───────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# Build Flutter Web dengan target release
RUN flutter build web --release --base-href "/"

# ─── Copy ke volume output ───────────────────────────────
# Stage ini hanya untuk copy hasil build ke named volume
FROM alpine:3.19

WORKDIR /app_build
COPY --from=builder /app/build/web .

# Copy hasil build ke named volume yang di-mount docker-compose di /output.
CMD ["sh", "-c", "cp -r /app_build/. /output/ && echo 'Flutter web build copied to volume.'"]
