#!/bin/bash

set -x

source variables.sh

# CLonamos repositorio
wget https://wordpress.org/latest.zip -O /tmp/latest.zip

apt update
apt install unzip -y

unzip /tmp/latest.zip -d /var/www/html

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$DB_HOST_PRIVATE_IP/" /var/www/html/wordpress/wp-config.php


sed -i "/DB_COLLATE/a define('WP_HOME', '$WP_HOME');" /var/www/html/wordpress/wp-config.php
sed -i "/DB_COLLATE/a define('WP_SITEURL', '$WP_SITEURL');" /var/www/html/wordpress/wp-config.php
# Eliminamos el index default
rm -f /var/www/html/index.html

# Copiamos el index del directorio Wordpress
cp /var/www/html/wordpress/index.php /var/www/html/index.php

# Modificamos el propietario y grupo
chown www-data:www-data /var/www/html -R


mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'" 

