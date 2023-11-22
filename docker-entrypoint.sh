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

# Check if the mounted directory is empty
if [ -z "$(ls -A $MOUNTED_DIR)" ]; then
    echo "Mounted directory is empty. Restoring content from backup..."
    cp -a $BACKUP_DIR/. $MOUNTED_DIR/
    
    # Change ownership to www-data and set appropriate permissions
    chown -R www-data:www-data $MOUNTED_DIR
    chmod -R 777 $MOUNTED_DIR
fi

# Start Apache in the foreground
exec apache2-foreground

