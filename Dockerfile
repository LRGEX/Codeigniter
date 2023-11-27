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
    jq \
    unzip \
    libzip-dev \
    libicu-dev \
    ca-certificates \
    gnupg && \
    a2enmod rewrite && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl && \
    # Install Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
    
# Set the working directory to the Apache document root
WORKDIR /var/www/html

# Install Main CodeIgniter 4 with dependencies

#   Create a new project
RUN composer create-project codeigniter4/appstarter codeigniter && \
    # Move all files from the project root to the current directory
    find codeigniter -mindepth 1 -maxdepth 1 -exec mv {} . \; && rm -rf codeigniter && \
    # Create a directory for the project to store some files 
    mkdir -p /opt/ci && \
    # Create a flag file to indicate that the container has been initialized
    touch /opt/ci/flags && \
    # Create a flag file to indicate that the container has been initialized
    echo 'ServerName localhost' >> /etc/apache2/apache2.conf && \
    # copy env to .env
    cp env .env && \
    # # sed lines in .env and uncomment
    sed -i 's/# CI_ENVIRONMENT = production/CI_ENVIRONMENT = development/g' .env



    # setting up permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html && \
    # Create a backup of the original files to be copied over to the project when the container is started for the first time
    mkdir -p /var/www/html_backup && cp -a . /var/www/html_backup && \
    # Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy Apache custome configuration files to default location
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
# Copy .htaccess file for apache
COPY .htaccess /var/www/html/.htaccess
# Copy the entrypoint script
COPY docker-entrypoint.sh /opt/ci/docker-entrypoint.sh

# Expose port 80
EXPOSE 80

# Ensure the entrypoint script is executable
RUN chmod +x /opt/ci/docker-entrypoint.sh

# Start Apache server in the foreground
ENTRYPOINT ["/opt/ci/docker-entrypoint.sh"]