#!/bin/bash

set -x

source variables.sh

# CLonamos repositorio
wget https://wordpress.org/latest.zip -O /tmp/latest.zip

apt-get install unzip -y

rm -rf /var/www/html/wordpress
rm -rf /var/www/html/index.html

unzip /tmp/latest.zip -d /var/www/html

# Copiar archivo de config de ejemplo
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Establecemos variables de configuración 

sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$DB_HOST_PRIVATE_IP/" /var/www/html/wordpress/wp-config.php

# Añadimos las varibles WP_HOME y WP_SITEURL

sed -i "s/DB_COLLATE/a define('WP_HOME', '$WP_HOME');" /var/www/html/wordpress/wp-config.php
sed -i "s/WP_HOME/a define('WP_SITEURL', '$WP_SITEURL');" /var/www/html/wordpress/wp-config.php

# Copiamos el index del directorio Wordpress
cp /var/www/html/wordpress/index.php /var/www/html/index.php

sed -i "s|wp-blog-header.php|wordpress/wp-blog-header.php|" /var/www/html/index.php

# Modificamos el propietario y grupo
chown www-data:www-data /var/www/html -R

# Creación de la DB y su usuario
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'" 

# Reinicio servicio apache2
systemctl restart apache2
