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
    # remove this v
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
    # curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    # Install Node.js
    # mkdir -p /etc/apt/keyrings && \
    # curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    # NODE_MAJOR=21 && \
    # echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    # apt-get update && \
    # apt-get install nodejs -y
    
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
    # # Install NPM
    # curl -qL https://www.npmjs.com/install.sh | sh && \
    # npm init -y && \
    # Install Bootstrap
    # npm install bootstrap@5.3.2 --save && \
    # create directory structure for application
    # mkdir ./public/css && \
    # mkdir ./public/js && \
    # mkdir ./public/assets && \
    # mkdir ./public/scss && \
    # touch ./public/scss/main.scss && \
    # echo "@import '../../node_modules/bootstrap/scss/bootstrap';" >> ./public/scss/main.scss && \
    # touch ./public/js/main.js && \
    # # instal sass
    # npm install sass && \
    # # sed lines in package.json
    # jq '.scripts += {"scss": "npx sass --watch public/scss/main.scss public/css/styles.css"} | del(.scripts.test)' package.json > temp.json && mv temp.json package.json && \
    # copy env to .env
    cp env .env && \
    # # sed lines in .env and uncomment
    sed -i 's/# CI_ENVIRONMENT = production/CI_ENVIRONMENT = development/g' .env

# COPY dep/ /temp/dep/


# RUN cp -a /temp/dep/assets/. ./public/assets && \
#     cp -a /temp/dep/css/. ./public/css && \
#     cp -a /temp/dep/js/. ./public/js && \
#     cp -a /temp/dep/scss/. ./public/scss && \
#     cp -a /temp/dep/Views/. ./app/Views && \
#     cp -a /temp/dep/Controllers/. ./app/Controllers && \
#     cp -a /temp/dep/Config/. ./app/Config && \
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