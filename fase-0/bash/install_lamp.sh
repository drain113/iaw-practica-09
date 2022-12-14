 #!/bin/bash

#Depuramos comandos que el script realiza para poder verlos
 set -x

#Actualizamos repositorios
 apt-get update

#Actualizamos repositorios nuevos
apt-get upgrade -y

#Instalamos servidor web Apache
apt-get install apache2 -y

#Instalamos el sistema gestor de base de datos, MySQL
apt-get install mysql-server -y

#Instalamos los módulos de PHP
apt-get install php libapache2-mod-php php-mysql -y

# Activamos módulo de Apache
a2enmod rewrite

# Copiamos los archivos de configuración preestablecidos y los reemplazamos por los que ya existen
cp -f ../conf/000-default.conf /etc/apache2/sites-available
cp -f ../conf/dir.conf /etc/apache2/mods-available

# Reiniciamos servicio Apache
systemctl restart apache2