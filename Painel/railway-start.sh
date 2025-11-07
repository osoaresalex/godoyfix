#!/bin/bash

# Railway start script
# FIRST: Delete cache files BEFORE any artisan command
echo "=== DELETING CACHE FILES BEFORE ARTISAN ==="
rm -rf storage/framework/views/* || true
rm -rf storage/framework/cache/* || true
rm -rf bootstrap/cache/*.php || true
echo "=== CACHE FILES DELETED ==="

# THEN: Clear Laravel caches
echo "=== CLEARING LARAVEL CACHES ==="
php artisan cache:clear || true
php artisan view:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan optimize:clear || true
echo "=== LARAVEL CACHES CLEARED ==="

# Rebuild caches
echo "=== REBUILDING CACHES ==="
php artisan config:cache
php artisan route:cache
echo "=== CACHES REBUILT ==="

echo "=== RUNNING MIGRATIONS ==="
php artisan migrate --force
echo "=== MIGRATIONS COMPLETE ==="

echo "=== STARTING SERVER ON PORT $PORT ==="
php artisan serve --host=0.0.0.0 --port=$PORT
