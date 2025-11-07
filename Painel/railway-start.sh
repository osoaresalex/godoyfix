#!/bin/bash

# Railway start script
# AGGRESSIVE cache clearing
php artisan cache:clear || true
php artisan view:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan optimize:clear || true

# Force delete ALL compiled views (ignore errors)
rm -rf storage/framework/views/* || true
rm -rf storage/framework/cache/* || true
rm -rf bootstrap/cache/*.php || true

# Rebuild caches
php artisan config:cache
php artisan route:cache

php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=$PORT
php artisan serve --host=0.0.0.0 --port=$PORT
