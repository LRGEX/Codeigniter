#!/bin/bash
cat << "EOF"
██╗     ██████╗  ██████╗ ███████╗██╗  ██╗
██║     ██╔══██╗██╔════╝ ██╔════╝╚██╗██╔╝
██║     ██████╔╝██║  ███╗█████╗   ╚███╔╝ 
██║     ██╔══██╗██║   ██║██╔══╝   ██╔██╗ 
███████╗██║  ██║╚██████╔╝███████╗██╔╝ ██╗
╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ 
┌─┐┌─┐┌┬┐┌─┐╦╔═╗╔╗╔╦╔╦╗╔═╗╦═╗
│  │ │ ││├┤ ║║ ╦║║║║ ║ ║╣ ╠╦╝
└─┘└─┘─┴┘└─┘╩╚═╝╝╚╝╩ ╩ ╚═╝╩╚═  v4.3.3-2                                
EOF


# Path to the backup directory
BACKUP_DIR="/var/www/html_backup"

# Path to the mounted directory
MOUNTED_DIR="/var/www/html"

# Check if the mounted directory is empty
if [ -z "$(ls -A $MOUNTED_DIR)" ]; then
    echo ""
    echo "Mounted directory is empty. Restoring content from backup..."
    echo ""
    cp -a $BACKUP_DIR/. $MOUNTED_DIR/
    echo ""
    echo "Done!"
    echo ""
    sleep 2
fi

if ! grep -q "started" /opt/ci/flags; then
    echo ""
    echo "Configuring Permissions..."
    echo ""
    # Change ownership to www-data and set appropriate permissions on the mounted directory
    chown -R www-data:www-data $MOUNTED_DIR
    chmod -R 755 $MOUNTED_DIR
    touch /opt/ci/flags
    echo "started" >> /opt/ci/flags
    echo ""
    echo "Done!"
    echo ""
    sleep 2
fi

if ! grep -q "defined('BASE')" /var/www/html/app/Config/Constants.php; then
    echo ""
    echo "Configuring CodeIgniter Base url..."
    echo ""
    # Set the base URL in the CodeIgniter configuration file and the Constants file
    sed -i 's/public string $baseURL = .*/public $baseURL = BASE;/' /var/www/html/app/Config/App.php
    echo "\$protocol = isset(\$_SERVER['HTTPS']) && \$_SERVER['HTTPS'] != 'off' ? 'https://' . \$_SERVER['HTTP_HOST'] : 'http://' . \$_SERVER['HTTP_HOST'];" >> /var/www/html/app/Config/Constants.php
    echo " defined('BASE') || define('BASE', \$protocol);" >> /var/www/html/app/Config/Constants.php
    echo ""
    echo "Done!"
    sleep 2
fi

echo ""
echo "Starting Apache..."
echo ""
echo "if you want to use bootstrap, please do the following:"
echo ""
echo "go to localhost:80/webcontrol in your browser"
echo ""
echo "Press Start Sass to start the sass compiler"
echo ""
echo "your synced css file with bootstrap will be located in /var/www/html/public/assets/css/style.css"
echo ""
echo "if you want change the css file name, please edit the package.json file accordingly"

# Start Apache in the foreground
exec apache2-foreground

