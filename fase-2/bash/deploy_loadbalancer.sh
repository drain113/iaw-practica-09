#!/bin/bash

clear
set -x
source variables.sh

#----------------------Instalar funciones Loadbalancer----------------------#
# Actualizamos los repositorios
apt update

# Instalamos el servidor web Apache
apt install apache2 -y

# Activamos los módulos para configurar Apache como proxy inverso
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_ajp
a2enmod rewrite 
a2enmod deflate
a2enmod headers
a2enmod proxy_balancer
a2enmod proxy_connect
a2enmod proxy_html
a2enmod lbmethod_byrequests
#----------------------------------------------------------------------#

# Copiamos el archivo de config en Apache
cp -f conf/000-default-bal.conf /etc/apache2/sites-available/000-default.conf

# Reemplazamos las variables del archivo de config
sed -i "s/IP_HTTP_SERVER_1/$IP_HTTP_SERVER_1/" /etc/apache2/sites-available/000-default.conf
sed -i "s/IP_HTTP_SERVER_2/$IP_HTTP_SERVER_2/" /etc/apache2/sites-available/000-default.conf
#sed -i "s/IP_HTTP_SERVER_3/$IP_HTTP_SERVER_3/" /etc/apache2/sites-available/000-default.conf


#----------------------------------------------------------------------#

# Realizamos la instalación y actualización de snapd.
snap install core; snap refresh core 

#Eliminamos si existiese alguna instalación previa de certbot con apt.
apt-get remove certbot -y

#Instalamos el cliente de Certbot con snapd.
snap install --classic certbot 

#Creamos una alias para el comando certbot.
ln -s /snap/bin/certbot /usr/bin/certbot

#Obtenemos el certificado y configuramos el servidor web Apache.
certbot --apache -m $EMAIL --agree-tos --no-eff-email  -d $DOMAIN 

# Reiniciamos servicio Apache2
systemctl restart apache2