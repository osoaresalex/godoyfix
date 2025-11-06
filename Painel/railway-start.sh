#!/bin/bash

# Railway start script
# Clear ALL caches and delete compiled views
php artisan cache:clear
php artisan view:clear
php artisan config:clear
php artisan route:clear
php artisan optimize:clear

# Delete compiled views to force recompilation
rm -rf storage/framework/views/*

# Rebuild caches
php artisan config:cache
php artisan route:cache
php artisan optimize

php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=$PORT
