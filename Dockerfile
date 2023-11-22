# Use PHP 8.2 with Apache on Debian Bookworm as the base image
FROM php:8.2-apache-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    nano \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    libicu-dev

# Clear out the local repository of retrieved package files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions including intl
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to the Apache document root
WORKDIR /var/www/html

# Install CodeIgniter using Composer
RUN composer create-project codeigniter4/appstarter codeigniter

# Move CodeIgniter files to the working directory, excluding special directories
RUN find codeigniter -mindepth 1 -maxdepth 1 -exec mv {} . \; && rm -rf codeigniter

# Create a backup of the application
RUN mkdir -p /var/www/html_backup && cp -a . /var/www/html_backup

# Copy Apache configuration file
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy .htaccess file
COPY .htaccess /var/www/html/.htaccess

# Set permissions for the Apache document root
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Create a directory for the entrypoint script
RUN mkdir -p /opt/ci

# Copy the entrypoint script
COPY docker-entrypoint.sh /opt/ci/docker-entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /opt/ci/docker-entrypoint.sh

# Set the ServerName directive
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf



# Start Apache server in the foreground
ENTRYPOINT ["/opt/ci/docker-entrypoint.sh"]
