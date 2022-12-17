#!/bin/bash

clear
set -x
source variables.sh


#----------------------Instalar funciones backend----------------------#
apt-get update -y

apt-get install mysql-server -y

systemctl start mysqld

systemctl enable mysqld

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

#----------------------------------------------------------------------#

#--------------------------------Instalar DB---------------------------#

# Creación de la DB y su usuario
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4"
mysql -u root <<< "DROP USER IF EXISTS $DB_USER@'%'"
mysql -u root <<< "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%'" 

#----------------------------------------------------------------------#
