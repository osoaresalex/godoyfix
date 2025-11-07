# Multi-stage Dockerfile for Laravel app located in Painel/
# Stage 1: Builder (install PHP extensions + composer dependencies)
FROM php:8.2-fpm-alpine AS builder

# Install system dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    icu-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libzip-dev \
    oniguruma-dev \
    openssl \
    zip \
    unzip \
    shadow \
    supervisor

# Configure and install PHP extensions
RUN docker-php-ext-configure intl \
 && docker-php-ext-install \
    pdo_mysql \
    intl \
    bcmath \
    pcntl \
    zip

# GD (with JPEG, WebP)
RUN docker-php-ext-configure gd --with-jpeg --with-webp \
 && docker-php-ext-install gd

# Opcache recommended settings
RUN docker-php-ext-install opcache

# Enable commonly needed extensions
RUN docker-php-ext-install exif

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy only composer files first for better layer caching
COPY Painel/composer.json Painel/composer.lock ./Painel/

WORKDIR /var/www/Painel
RUN composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction --no-scripts || true \
 && composer dump-autoload --optimize

# Stage 2: Runtime
FROM php:8.2-fpm-alpine AS runtime

# System dependencies
RUN apk add --no-cache bash icu libpng libjpeg-turbo libwebp libzip oniguruma openssl shadow supervisor

# Copy PHP extensions from builder (already compiled)
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Copy composer vendor directory and application source
WORKDIR /var/www/Painel
COPY --from=builder /var/www/Painel/vendor ./vendor
COPY Painel .

# Create necessary directories and set permissions
RUN mkdir -p storage/framework/{cache,data,sessions,views} storage/logs bootstrap/cache \
 && chown -R www-data:www-data /var/www/Painel \
 && chmod -R 775 storage bootstrap/cache

# Copy supervisor configuration
COPY tools/docker/supervisor.conf /etc/supervisord.conf

# Expose port for php-fpm
EXPOSE 9000

# Healthcheck: simple PHP -v invocation
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD php -v || exit 1

ENV APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr

# Entrypoint script sets up environment, caches and starts supervisord
COPY tools/docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]

# Notes:
# - Queue worker and scheduler will reuse this image in docker-compose.
# - websockets or horizon can be added later if needed.
