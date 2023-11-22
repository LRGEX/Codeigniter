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
└─┘└─┘─┴┘└─┘╩╚═╝╝╚╝╩ ╩ ╚═╝╩╚═  v4.3.3                                
EOF


# Path to the backup directory
BACKUP_DIR="/var/www/html_backup"

# Path to the mounted directory
MOUNTED_DIR="/var/www/html"
lrgex_flag=$(grep -c "started" /opt/ci/flags)



# Check if the mounted directory is empty
if [ -z "$(ls -A $MOUNTED_DIR)" ]; then
    echo "Mounted directory is empty. Restoring content from backup..."
    cp -a $BACKUP_DIR/. $MOUNTED_DIR/
    
  
    
fi
if [$lrgex_flag == false ];then
  # Change ownership to www-data and set appropriate permissions
    chown -R www-data:www-data $MOUNTED_DIR
    chmod -R 777 $MOUNTED_DIR
    # Set the base URL in the CodeIgniter configuration file and the Constants file
    sed -i 's/public string $baseURL = .*/public $baseURL = BASE;/' /var/www/html/app/Config/App.php && \
    echo "\$protocol = isset(\$_SERVER['HTTPS']) && \$_SERVER['HTTPS'] != 'off' ? 'https://' . \$_SERVER['HTTP_HOST'] : 'http://' . \$_SERVER['HTTP_HOST'];" >> /var/www/html/app/Config/Constants.php && \
    echo " defined('BASE') || define('BASE', \$protocol);" >> /var/www/html/app/Config/Constants.php 
    touch /opt/ci/flags
    echo "started" >> /opt/ci/flags
fi



# Start Apache in the foreground
exec apache2-foreground

