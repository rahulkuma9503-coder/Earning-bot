#!/bin/bash

# Start the PHP bot in the background
# The output is redirected to prevent it from interfering with the main log
php index.php > /dev/null 2>&1 &

# Start Apache in the foreground
# This keeps the container running and satisfies Render's health checks
exec apache2-foreground
