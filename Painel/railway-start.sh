#!/bin/bash

echo "============================================"
echo "RAILWAY STARTUP SCRIPT RUNNING"
echo "PWD: $(pwd)"
echo "============================================"

# FIRST: Delete cache files BEFORE any artisan command (NO PHP YET)
echo "=== STEP 1: DELETING CACHE FILES (raw rm -rf) ==="
rm -rfv storage/framework/views/* 2>&1 | head -n 10
rm -rfv storage/framework/cache/* 2>&1 | head -n 10
rm -rfv bootstrap/cache/*.php 2>&1 | head -n 10
ls -la storage/framework/views/ || echo "Views directory empty or missing"
echo "=== CACHE FILES DELETED ==="

# THEN: Clear Laravel caches
echo "=== CLEARING LARAVEL CACHES ==="
php artisan cache:clear || true
php artisan view:clear || true
php artisan config:clear || true
php artisan route:clear || true
php artisan optimize:clear || true
echo "=== LARAVEL CACHES CLEARED ==="

# Force recompile all views from source
echo "=== FORCING VIEW RECOMPILATION ==="
php force-recompile-views.php || true
echo "=== VIEW RECOMPILATION COMPLETE ==="

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
