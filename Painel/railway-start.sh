#!/bin/bash

# Enable verbose logging for debugging
set -x

# Create debug log file
DEBUG_LOG="storage/logs/railway-startup-debug.log"
mkdir -p storage/logs
exec 2>&1 | tee -a "$DEBUG_LOG"

echo "============================================"
echo "RAILWAY STARTUP SCRIPT RUNNING"
echo "PWD: $(pwd)"
echo "Date: $(date)"
echo "PHP Version: $(php -v | head -n 1)"
echo "Composer Version: $(composer --version 2>/dev/null || echo 'not found')"
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

# CRITICAL: Write env vars to .env file BEFORE any Laravel command runs
# This ensures Laravel always reads these values during config load
echo "Setting up .env with view cache configuration..."
if [ -f ".env" ]; then
    # Remove old VIEW_COMPILED_PATH and VIEW_CACHE_DISABLED if they exist
    sed -i '/^VIEW_COMPILED_PATH=/d' .env
    sed -i '/^VIEW_CACHE_DISABLED=/d' .env
    
    echo "Current .env contents (first 20 lines):"
    head -n 20 .env
fi

# Append critical config to .env
echo "VIEW_COMPILED_PATH=/app/Painel/storage/framework/views" >> .env
echo "VIEW_CACHE_DISABLED=false" >> .env
sed -i '/^LOG_CHANNEL=/d' .env
echo "LOG_CHANNEL=stderr" >> .env

echo ".env file updated with view cache configuration"
echo "Verify .env has VIEW_ vars:"
cat .env | grep VIEW_ || echo "ERROR: VIEW_ vars NOT in .env!"

# Also export as env vars for current shell session
export VIEW_COMPILED_PATH="/app/Painel/storage/framework/views"
export VIEW_CACHE_DISABLED=false
export APP_DEBUG=true
export LOG_LEVEL=debug
export LOG_CHANNEL=stderr

echo "Environment variables set in shell:"
echo "  VIEW_COMPILED_PATH=$VIEW_COMPILED_PATH"
echo "  VIEW_CACHE_DISABLED=$VIEW_CACHE_DISABLED"

# Test reading .env with PHP
echo "Test reading VIEW_COMPILED_PATH from .env using PHP:"
php -r "require 'vendor/autoload.php'; \$dotenv = Dotenv\Dotenv::createImmutable(__DIR__); \$dotenv->load(); echo 'VIEW_COMPILED_PATH from env(): ' . ($_ENV['VIEW_COMPILED_PATH'] ?? 'NOT SET') . PHP_EOL;"

# Remove any cached bootstrap files that could store an invalid compiled path
if [ -d "bootstrap/cache" ]; then
    echo "Cleaning bootstrap/cache files before package discovery..."
    rm -f bootstrap/cache/config.php || true
    rm -f bootstrap/cache/services.php || true
    rm -f bootstrap/cache/packages.php || true
    rm -f bootstrap/cache/routes.php || true
    rm -f bootstrap/cache/modules.php || true
fi

# Install Composer dependencies WITHOUT running scripts (to avoid cache path error)
echo "=== INSTALLING COMPOSER DEPENDENCIES ==="
if [ ! -d "vendor" ] || [ ! -f "vendor/autoload.php" ]; then
    echo "vendor/ not found or incomplete, running composer install WITHOUT post-install scripts..."
    composer install --no-dev --optimize-autoloader --no-interaction --no-scripts 2>&1 | tee -a storage/logs/composer-install.log
    echo "Composer install exit code: $?"
    
    echo "Composer packages installed, now running package discovery manually..."
    php artisan package:discover --ansi 2>&1 | tee -a storage/logs/package-discover.log || {
        echo "ERROR: package:discover failed with exit code $?"
        echo "Last 50 lines of package discover output:"
        tail -n 50 storage/logs/package-discover.log
    }
else
    echo "vendor/ exists, skipping composer install"
fi
echo "=== COMPOSER DEPENDENCIES INSTALLED ==="

# Delete cache files
echo "=== DELETING CACHE FILES ==="
rm -rf storage/framework/views/* || true
rm -rf storage/framework/cache/data || true
# Recreate data directory after deletion
mkdir -p storage/framework/cache/data
rm -rf bootstrap/cache/*.php || true
echo "=== CACHE FILES DELETED ==="

# CRITICAL: Clear bootstrap cache again before running artisan commands
echo "Removing bootstrap cache files before artisan commands..."
rm -f bootstrap/cache/config.php bootstrap/cache/services.php bootstrap/cache/packages.php bootstrap/cache/routes.php bootstrap/cache/modules.php || true

# Clear Laravel caches with detailed logging
echo "=== CLEARING LARAVEL CACHES ==="
echo "Running cache:clear..."
php artisan cache:clear 2>&1 | tee -a storage/logs/cache-clear.log || echo "cache:clear failed with exit code $?"
echo "Running view:clear..."
php artisan view:clear 2>&1 | tee -a storage/logs/view-clear.log || echo "view:clear failed with exit code $?"
echo "Running config:clear..."
php artisan config:clear 2>&1 | tee -a storage/logs/config-clear.log || echo "config:clear failed with exit code $?"
echo "Running route:clear..."
php artisan route:clear 2>&1 | tee -a storage/logs/route-clear.log || echo "route:clear failed with exit code $?"
echo "Running optimize:clear..."
php artisan optimize:clear 2>&1 | tee -a storage/logs/optimize-clear.log || echo "optimize:clear failed with exit code $?"
echo "=== LARAVEL CACHES CLEARED ==="

# Rebuild caches with detailed logging
echo "=== REBUILDING CACHES ==="
echo "Running config:cache..."
php artisan config:cache 2>&1 | tee -a storage/logs/config-cache.log || {
    echo "ERROR: config:cache failed with exit code $?"
    echo "Contents of config-cache.log:"
    cat storage/logs/config-cache.log
}
# SKIP route:cache - the app has duplicate route names that prevent caching
echo "SKIPPING route:cache (duplicate route names in AdminModule)"
echo "=== CACHES REBUILT ==="

echo "=== RUNNING MIGRATIONS ==="
php artisan migrate --force 2>&1 | tee -a storage/logs/migrate.log || {
    echo "ERROR: migrate failed with exit code $?"
    echo "Contents of migrate.log:"
    cat storage/logs/migrate.log
}
echo "=== MIGRATIONS COMPLETE ==="

echo "=== FINAL ENVIRONMENT CHECK ==="
echo "Storage directories status:"
ls -laR storage/framework/ | head -n 50
echo "Bootstrap cache status:"
ls -la bootstrap/cache/
echo "Checking compiled view directory with shell checks:"
echo "path: storage/framework/views"
echo "realpath: $(realpath storage/framework/views || echo 'FALSE')"
test -d storage/framework/views && echo "is_dir: true" || echo "is_dir: false"
test -w storage/framework/views && echo "is_writable: true" || echo "is_writable: false"

echo "=== DEBUG LOGS SAVED TO storage/logs/ ==="
echo "Available log files:"
ls -lh storage/logs/*.log 2>/dev/null || echo "No log files found"

echo "=== STARTING SERVER ON PORT ${PORT:-8080} ==="
touch storage/logs/laravel.log
tail -n 0 -F storage/logs/laravel.log &
php artisan serve --host=0.0.0.0 --port=${PORT:-8080} 2>&1 | tee -a storage/logs/server.log
