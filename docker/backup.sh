#!/bin/sh
# ─────────────────────────────────────────────────────────────────────────────
# backup.sh — MySQL auto-backup script for Tomodachi Pet Shop
#
# Dijalankan oleh container mysql_backup (mcuadros/ofelia atau cron Alpine).
# Backup disimpan di /backups (di-mount ke volume mysql_backups di host).
# File backup lebih dari BACKUP_RETAIN_DAYS hari akan otomatis dihapus.
# ─────────────────────────────────────────────────────────────────────────────

set -e

# ── Konfigurasi (diambil dari env container) ─────────────────────────────────
DB_HOST="${DB_HOST:-mysql}"
DB_PORT="${DB_PORT:-3306}"
DB_DATABASE="${DB_DATABASE:-tomodachi_petshop}"
DB_USERNAME="${DB_USERNAME:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
BACKUP_DIR="${BACKUP_DIR:-/backups}"
BACKUP_RETAIN_DAYS="${BACKUP_RETAIN_DAYS:-7}"

# ── Pastikan folder backup ada ───────────────────────────────────────────────
mkdir -p "$BACKUP_DIR"

# ── Nama file dengan timestamp ───────────────────────────────────────────────
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="${DB_DATABASE}_${TIMESTAMP}.sql.gz"
FILEPATH="${BACKUP_DIR}/${FILENAME}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Memulai backup database '${DB_DATABASE}'..."

# ── Jalankan mysqldump dan compress langsung ─────────────────────────────────
mysqldump \
  --host="${DB_HOST}" \
  --port="${DB_PORT}" \
  --user="${DB_USERNAME}" \
  --password="${DB_PASSWORD}" \
  --single-transaction \
  --routines \
  --triggers \
  --add-drop-table \
  "${DB_DATABASE}" | gzip > "${FILEPATH}"

# ── Verifikasi hasil backup ──────────────────────────────────────────────────
if [ -f "${FILEPATH}" ] && [ -s "${FILEPATH}" ]; then
  FILE_SIZE=$(du -sh "${FILEPATH}" | cut -f1)
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Backup berhasil: ${FILENAME} (${FILE_SIZE})"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ Backup GAGAL: file tidak terbuat atau kosong"
  exit 1
fi

# ── Hapus backup lama (lebih dari BACKUP_RETAIN_DAYS hari) ───────────────────
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Membersihkan backup lebih dari ${BACKUP_RETAIN_DAYS} hari..."
find "${BACKUP_DIR}" -name "${DB_DATABASE}_*.sql.gz" -mtime "+${BACKUP_RETAIN_DAYS}" -delete
REMAINING=$(find "${BACKUP_DIR}" -name "${DB_DATABASE}_*.sql.gz" | wc -l)
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Total backup tersimpan: ${REMAINING} file"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup selesai."
