#!/bin/bash

# Railway start script
# Clear all caches first
php artisan cache:clear
php artisan view:clear
php artisan config:clear
php artisan route:clear

# Rebuild caches
php artisan config:cache
php artisan route:cache
php artisan migrate --force
php artisan serve --host=0.0.0.0 --port=$PORT
