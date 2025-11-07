#!/usr/bin/env sh
set -e

cd /var/www/Painel

# Ensure storage and cache directories exist
mkdir -p storage/framework/{cache,data,sessions,views} storage/logs bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Ensure APP_KEY exists (don't fail if env var not provided)
if [ ! -f ".env" ]; then
  cp .env.example .env || true
fi

if ! grep -q "^APP_KEY=" .env || [ -z "$(grep '^APP_KEY=' .env | cut -d= -f2)" ]; then
  php artisan key:generate --force || true
fi

# Cache config and routes (ignore route cache if it fails due to dup names)
php artisan config:clear || true
php artisan config:cache || true
php artisan route:clear || true
php artisan view:clear || true
php artisan optimize:clear || true

# Run migrations (don't fail startup if migrations hit a non-critical warning)
php artisan migrate --force || true

# Warm up caches
php artisan view:cache || true

# Start via CMD (php-fpm or supervisord)
exec "$@"
