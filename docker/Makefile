.PHONY: help build up down logs shell-laravel shell-mysql migrate fresh

help:
	@echo ""
	@echo "  make build       — Build ulang semua image"
	@echo "  make up          — Jalankan semua container"
	@echo "  make down        — Matikan semua container"
	@echo "  make logs        — Lihat logs semua service"
	@echo "  make shell       — Masuk ke shell Laravel"
	@echo "  make db          — Masuk ke MySQL CLI"
	@echo "  make migrate     — Jalankan php artisan migrate"
	@echo "  make fresh       — migrate:fresh --seed (HAPUS data!)"
	@echo ""

build:
	docker compose --profile build up flutter_builder --build
	docker compose build laravel nginx

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
