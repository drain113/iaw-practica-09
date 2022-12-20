# Balanceador de carga con Apache
<p align="center">
<img src="https://raw.githubusercontent.com/drain113/pictures/main/Fotos/3.png" width="250" height="320" />  
</p>
<br>   <br/>  


# Índice

### [1. Introducción](#introducción)

### [2. Estructura](#estructura)

### [3. Creación y configuración de la instancia](#creación-y-configuración-de-la-instancia)
  
### [4. Funcionamiento del repositorio](#funcionamiento-del-repositorio)

### [5. Conclusión](#conclusión)

<br>   <br/>   

# Introducción
Esta práctica consiste en una arquitectura web para desplegar Wordpress en 5 niveles.
Para realizarla, he dividido la práctica general en 3 fases:
- Fase 0.
  - Instalación de Wordpress en un nivel (Un único servidor con todo lo         necesario).
- Fase 1. 
  - Instalación de Wordpress en dos niveles (Un servidor web y un servidor MySQL).
- Fase 2. 
  - Instalación de Wordpress en tres niveles (Balanceador, 2 Servidores webs, Servidor NFS y Servidor MySQL).

Se ha utilizado un servidor NFS para que los servidores de la capa de front-end compartan el directorio /var/www/html donde los sevidores web serán los clientes que utilizarán el directorio compartido.

Los dos equipos de frontend actuarán como cliente (Ya añadido en su script)
<br>   <br/>   

# Estructura
La estructura de esta práctica se divide en cinco máquinas (EC2).  
- Una máquina que hará de **Balanceador**.  
- Una máquina que hará de **Backend**.
- Dos máquinas que harán de **Frontend**.
- Una máquina que, formando parte del frontend, actuará como servidor **NFS**.  

Por otro lado, necesitamos un equipo , ya sea local o máquina EC2 que será el Launcher desde el que instalaremos ansible para ejecutar los playbooks en las máquinas

Como realizaremos la instalación en Ansible, solo tendremos que tener en cuenta el archivo inventario del repositorio en el que declararemos las IP de las máquinas que actuarán como Frontend y backend.
También debemos de editar las variables para seleccionar las IP del backend y otras variables de configuración de la base de datos.  
# Creación y configuración de la instancia

Crearemos **cinco** instancias, todas con **Ubuntu 22.04 y 4 GB de RAM.**

### **Tendremos que fijarnos en que la máquina de Backend tenga el puerto MySQL (3306 TCP) abierto y que el servidor NFS tenga el puerto NFS abierto (2049 TCP)**

**IMPORTANTE**  
 
- Es importante que cambiemos las variables del script (archivo variables.yml) para determinar el dominio e Ips del backend entre otras funciones.
- Por último, se debe cambiar las Ip del inventario.

Descargaremos la vockey de nuestras máquinas (vockey.pem) en nuestro Launcher o equipo local para declararla en nuestro inventario de conexiones de Ansible.

En caso de usar máquina como Launcher de ansible, podremos pasar la vockey con la siguiente sintáxis:
``` shell
scp username@b:/path/to/file /path/to/destination
```


# Funcionamiento del repositorio

* Como he comentado anteriormente,la primera fase (**fase 0**) es totalmente en local por lo que existen los siguientes playbooks:  
  1. install_lamp.yml
  2. deploy_wordpress.yml
  3. install_certbot.yml
  <br>   <br/> 

* En la **fase 1** , de una manera más recogida, nos encontraremos los siguientes repositorios:  
  1.  deploy_backend.yml
  2.  deploy_frontend.yml  

Esta fase recoge en solo dos playbooks una manera de hacer deploy de wordpress en un frontend y un backend como la práctica 7.
<br>   <br/> 
* Por último, la **fase 2** hará el deploy completo de la estructura en 3 niveles y de 5 máquinas con los siguientes scripts:

  1. deploy_backend.yml
  2. deploy_loadbalancer.yml
  3. deploy_nfs.yml
  4. deploy_frontend.yml
  5. deploy_wordpress

Con este mismo orden se ejecutará desde el main.

Cada playbook tiene comentarios explicativos de las acciones realizdas pero, en resumen, la fase 2 comenzará instalando las herramientas básicas de MySQL y creando un usuario con una base de datos a la que se conectará el Frontend de Wordpress para guardar la información.  

El Loadbalancer configurará correctamente el flujo entre el frontend 1 y 2 gracias al módulo de Apache instalado y a las respectiva configuración mediante IP privadas de los Frontend.
También instalará Certbot para poder conectarnos mediante HTTPS gracias al dominio especificado.  

El servidor NFS creará el directorio a compartir y cambiaremos el archivo /etc/exports para que el bloque de direcciones privadas de EC2 puedan usarlo.  (/16)  

El playbook de deploy del frontend instalará Apache, php y los requisitos para funcionar, aparte de instalar también el cliente NFS creando la partición del mount. 

Por último, deploy_wordpress hará una instalación limpia cada vez que sea ejecutado de Wordpress corrigiendo todos los posibles errores que puedan existir como en las variables WP_HOME, WP_SITEURL o $_SERVER ['HTTPS'] = 'on' .


# Conclusión

Ansible es realmente útil para manejar múltiples máquinas y configurar e instalar herramientas conjuntas.
Esta práctica es una manera de acercarnos a la arquitectura en partes de las páginas webs más avanzadas para  asegurarnos de no tener fallos de rendimiento o posibles caídas en frontends. 
<break>   </break>  
-Guille  
<break>   </break>  
 [![](https://preview.redd.it/enr7hhg3zku81.png?auto=webp&s=fc017e6a82f91cc81ab3dd7d0388ef57bfd72c30)](https://github.com/drain113)
