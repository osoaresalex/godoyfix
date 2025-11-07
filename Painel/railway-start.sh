#!/bin/bash

echo "============================================"
echo "RAILWAY STARTUP SCRIPT RUNNING"
echo "PWD: $(pwd)"
echo "============================================"

# CRITICAL: Install Composer dependencies FIRST
echo "=== INSTALLING COMPOSER DEPENDENCIES ==="
if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
    echo "vendor/ not found or incomplete, running composer install..."
    composer install --no-dev --optimize-autoloader --no-interaction
else
    echo "vendor/ exists, skipping composer install"
fi
echo "=== COMPOSER DEPENDENCIES INSTALLED ==="

# Create required Laravel directories with absolute paths
echo "=== CREATING REQUIRED DIRECTORIES ==="
mkdir -p ./storage/framework/sessions
mkdir -p ./storage/framework/views
mkdir -p ./storage/framework/cache/data
mkdir -p ./storage/logs
mkdir -p ./bootstrap/cache
chmod -R 775 ./storage ./bootstrap/cache
ls -la storage/framework/ || echo "Failed to create storage/framework"
echo "=== DIRECTORIES CREATED ==="

# Delete cache files
echo "=== DELETING CACHE FILES ==="
rm -rf storage/framework/views/* || true
rm -rf storage/framework/cache/* || true
rm -rf bootstrap/cache/*.php || true
echo "=== CACHE FILES DELETED ==="

# Clear Laravel caches
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
