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

WORKDIR /output
COPY --from=builder /app/build/web .

# Perintah ini akan copy file ke volume saat container jalan
CMD ["cp", "-r", "/output/.", "/output-vol/"]
# Catatan: volume di docker-compose di-mount ke /output-vol
# Tapi karena CMD langsung copy, kita override di compose:
# command: sh -c "cp -r /output/. /output-vol/ && echo Done"
