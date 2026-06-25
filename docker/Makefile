.PHONY: help build-backend push-backend up down logs shell-laravel db migrate fresh

COMPOSE_PROD=docker compose -f docker-compose.prod.yml

help:
	@echo ""
	@echo "  ── Development ──────────────────────────────────────"
	@echo "  make up          — Jalankan semua container (dev)"
	@echo "  make down        — Matikan semua container"
	@echo "  make logs        — Lihat logs semua service"
	@echo "  make shell       — Masuk ke shell Laravel container"
	@echo "  make db          — Masuk ke MySQL CLI"
	@echo "  make migrate     — Jalankan php artisan migrate"
	@echo "  make fresh       — migrate:fresh --seed (HAPUS data!)"
	@echo ""
	@echo "  ── Backup & Restore ──────────────────────────────────"
	@echo "  make backup      — Jalankan backup MySQL sekarang (manual)"
	@echo "  make backup-logs — Lihat log backup container"
	@echo "  make backup-list — Tampilkan daftar file backup"
	@echo ""
	@echo "  ── Production ───────────────────────────────────────"
	@echo "  make build-backend  — Build & push image backend ke Docker Hub"
	@echo "  make prod-up        — Jalankan stack production"
	@echo "  make prod-down      — Matikan stack production"
	@echo "  make prod-logs      — Lihat logs production"
	@echo "  make prod-backup    — Backup manual di production"
	@echo ""

# ─── Development ──────────────────────────────────────────────
up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

shell:
	docker exec -it tomodachi_laravel sh

db:
	docker exec -it tomodachi_mysql mysql -u $${DB_USERNAME} -p$${DB_PASSWORD} $${DB_DATABASE}

migrate:
	docker exec tomodachi_laravel php artisan migrate

fresh:
	@echo "⚠️  Ini akan menghapus semua data!"
	docker exec tomodachi_laravel php artisan migrate:fresh --seed

# ─── Backup & Restore ─────────────────────────────────────────────
# Trigger backup manual tanpa menunggu jadwal 24 jam
backup:
	docker exec tomodachi_mysql_backup sh /backup.sh

# Lihat log dari container backup
backup-logs:
	docker logs tomodachi_mysql_backup --tail=50 -f

# List semua file backup yang tersimpan
backup-list:
	docker exec tomodachi_mysql_backup ls -lh /backups/

# ─── Production ───────────────────────────────────────────────
build-backend:
	docker build -f backend.Dockerfile ../backend -t $${BACKEND_IMAGE}
	docker push $${BACKEND_IMAGE}

build-backend-no-cache:
	docker build --no-cache -f backend.Dockerfile ../backend -t $${BACKEND_IMAGE}
	docker push $${BACKEND_IMAGE}

prod-up:
	$(COMPOSE_PROD) up -d

prod-down:
	$(COMPOSE_PROD) down

prod-logs:
	$(COMPOSE_PROD) logs -f

# Backup manual di environment production
prod-backup:
	docker exec tomodachi_mysql_backup sh /backup.sh

prod-backup-list:
	docker exec tomodachi_mysql_backup ls -lh /backups/
