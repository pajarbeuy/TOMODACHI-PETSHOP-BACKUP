#!/bin/sh
set -e

echo "Waiting for MySQL to be ready..."
until php -r "new PDO('mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}');" 2>/dev/null; do
  sleep 2
done
echo "MySQL is ready."

echo "Syncing Laravel public assets..."
cp -a /var/www/laravel_public_seed/. public/

echo "Clearing stale Laravel bootstrap cache..."
rm -f bootstrap/cache/packages.php \
      bootstrap/cache/services.php \
      bootstrap/cache/config.php \
      bootstrap/cache/routes-v7.php \
      bootstrap/cache/events.php

echo "Discovering production packages..."
php artisan package:discover --ansi

echo "Running migrations..."
php artisan migrate --force

echo "Creating storage symlink..."
php artisan storage:link || true

echo "Optimizing..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"
