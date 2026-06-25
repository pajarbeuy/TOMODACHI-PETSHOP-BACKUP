# ─── Stage 1: Composer dependencies ─────────────────────
FROM composer:2.7 AS composer_stage

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --ignore-platform-reqs \
    --no-scripts

# ─── Stage 2: Final image ────────────────────────────────
FROM php:8.4-fpm-alpine

# Install PHP extensions yang dibutuhkan Laravel
RUN apk add --no-cache \
    libpng-dev jpeg-dev libwebp-dev \
    libzip-dev oniguruma-dev \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
    && docker-php-ext-enable opcache

# Konfigurasi OPcache untuk production
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini \
 && echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/conf.d/opcache.ini

WORKDIR /var/www/laravel

# Salin kode aplikasi
COPY . .
RUN cp -a public /var/www/laravel_public_seed

# Salin vendor dari stage composer
COPY --from=composer_stage /app/vendor ./vendor

# Hapus stale bootstrap cache (dibuild lokal dengan dev deps, tidak valid di production)
RUN rm -f bootstrap/cache/packages.php bootstrap/cache/services.php \
        bootstrap/cache/config.php bootstrap/cache/routes-v7.php bootstrap/cache/events.php

# Set permission untuk storage dan cache
RUN mkdir -p storage/logs storage/framework/{cache,sessions,views} bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Entrypoint: jalankan migrasi dan optimasi, lalu PHP-FPM
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
