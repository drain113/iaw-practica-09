#!/bin/bash

clear
set -x
source variables.sh

#----------------------Instalar funciones Frontend----------------------#
apt-get update -y

# Instalamos apache2
apt-get install apache2 -y

# Instalamos los módulos de PHP
apt-get install php libapache2-mod-php php-mysql -y

# Instalamos unzip
apt-get install unzip -y

#----------------------------------------------------------------------#


#-------------------------Instalar Wordpress--------------------------#
wget https://wordpress.org/latest.zip -O /tmp/latest.zip

# Eliminar instalaciones previas en html y wordpress
rm -rf /var/www/html/wordpress
rm -rf /var/www/html/index.html

unzip /tmp/latest.zip -d /var/www/html

# Copiar archivo de config de ejemplo
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Establecemos variables de configuración 

sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$DB_HOST/" /var/www/html/wordpress/wp-config.php

# Añadimos las varibles WP_HOME y WP_SITEURL

sed -i "/DB_COLLATE/a define('WP_HOME', '$WP_HOME');" /var/www/html/wordpress/wp-config.php
sed -i "/WP_HOME/a define('WP_SITEURL', '$WP_SITEURL');" /var/www/html/wordpress/wp-config.php

# Copiamos el index del directorio Wordpress
cp /var/www/html/wordpress/index.php /var/www/html/index.php

# Copiamos el archivo de config php
cp -f conf/config.php /var/www/html/config.php
#----------------------------------------------------------------------#

# Reinicio servicio apache2
systemctl restart apache2