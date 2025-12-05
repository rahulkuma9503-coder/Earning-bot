# Use the official PHP image with Apache
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies and Composer
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer files and install dependencies
COPY composer.json ./
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Copy all application files
COPY . .

# Create data files if they don't exist and set correct permissions
RUN touch users.json error.log && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Make our custom start script executable
RUN chmod +x start.sh

# Enable Apache rewrite module
RUN a2enmod rewrite

# Use our custom script to start the services
CMD ["./start.sh"]
