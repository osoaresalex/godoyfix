#!/bin/bash

echo "============================================"
echo "RAILWAY STARTUP SCRIPT RUNNING"
echo "PWD: $(pwd)"
echo "============================================"

# CRITICAL: Create cache directories BEFORE Composer (Laravel needs them during package:discover)
echo "=== CREATING REQUIRED DIRECTORIES (PRE-COMPOSER) ==="
echo "Current directory: $(pwd)"

# Create all required Laravel cache directories with proper structure
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/framework/cache/data
mkdir -p storage/framework/testing
mkdir -p storage/logs
mkdir -p bootstrap/cache

# Set permissions
chmod -R 775 storage bootstrap/cache 2>/dev/null || true

# Verify directories were created with subdirectories
echo "Verifying directory structure:"
echo "storage/framework:"
ls -la storage/framework/ 2>/dev/null || echo "ERROR: storage/framework/ not found"
echo "storage/framework/cache:"
ls -la storage/framework/cache/ 2>/dev/null || echo "ERROR: storage/framework/cache/ not found"
echo "bootstrap/cache:"
ls -la bootstrap/cache/ 2>/dev/null || echo "ERROR: bootstrap/cache/ not found"
test -w storage/framework/views && echo "✓ storage/framework/views is writable" || echo "✗ storage/framework/views NOT writable"
test -w storage/framework/cache/data && echo "✓ storage/framework/cache/data is writable" || echo "✗ storage/framework/cache/data NOT writable"
echo "=== DIRECTORIES CREATED ==="

# Install Composer dependencies WITHOUT running scripts (to avoid cache path error)
echo "=== INSTALLING COMPOSER DEPENDENCIES ==="
if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
    echo "vendor/ not found or incomplete, running composer install WITHOUT post-install scripts..."
    composer install --no-dev --optimize-autoloader --no-interaction --no-scripts
    echo "Composer packages installed, now running package discovery manually..."
    php artisan package:discover --ansi || echo "Warning: package:discover failed, continuing..."
else
    echo "vendor/ exists, skipping composer install"
fi
echo "=== COMPOSER DEPENDENCIES INSTALLED ==="

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
