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

# Copia del archivo 000-default.conf
cp /conf/000-default.conf /etc/apache2/sites-available

# Copia del archivo dir.conf
cp /conf/dir.conf /etc/apache2/mods-available

# Copiamos el archivo de config php
cp -f conf/config.php /var/www/html/config.php

# Reemplazamos variables del archivo conf
sed -i "s/MYSQL_IP_PUB_SERVER/$DB_HOST/" /var/www/html/config.php
sed -i "s/lamp_db/$DB_NAME/" /var/www/html/config.php
sed -i "s/lamp_user/$DB_USER/" /var/www/html/config.php
sed -i "s/lamp_pass/$DB_PASSWORD/" /var/www/html/config.php

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

# Cambiamos header.php del index
sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php
sed -i "/WP_HOME/a $_SERVER['HTTPS'] = 'on';" /var/www/html/wordpress/wp-config.php
chown www-data:www-data /var/www/html -R
#----------------------------------------------------------------------#

#------------------------Instalar Cliente NFS--------------------------#
sudo apt-get install nfs-common -y

# Montamos NFS SERVER en la máquina cliente
mount $IP_SERV_NFS:/var/www/html /var/www/html

# Editamos /etc/fstab
echo "$IP_SERV_NFS:/var/www/html /var/www/html nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab

#----------------------------------------------------------------------#
# Reinicio servicio apache2
systemctl restart apache2