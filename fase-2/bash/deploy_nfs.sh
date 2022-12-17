#!/bin/bash

clear
set -x
source variables.sh

#----------------------Instalar funciones NFS--------------------------#
# Actualizamos los repositorios
apt-get update

# Instalamos el servidor NFS
apt-get install nfs-kernel-server -y

# Crear el directorio a compartir
mkdir -p /var/www/html

# Cambiamos los permiosos al directorio a compartir
chown nobody:nogroup /var/www/html

# Editamos /etc/exports
cp conf/exports /etc/exports

sed -i "s#IP_HTTP_SERVER_1#$IP_HTTP_SERVER_1#" /etc/exports
sed -i "s#IP_HTTP_SERVER_2#$IP_HTTP_SERVER_2#" /etc/exports

#----------------------------------------------------------------------#

systemctl restart nfs-kernel-server