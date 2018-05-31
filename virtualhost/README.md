# VIRTUALHOST

### Para que sirve este script
Ejecutándolo mediante el comando:

    $ sudo bash virtualhost.sh [opciones]

Este script sirve para crear y eliminar vhost de una máquina con Apache. Para visualizar la ayuda y ver que comandos hay disponible, sólo hay que hacer:

    $ sudo bash virtualbox.sh -h

y nos mostrará lo siguiente

    All the available virtualhost options are:
      -h, --help        Show this help message and exit
      -v, --version     Show the script version and exit
      -a, --action      Required. The possibilities are: create or delete
      -d, --domain      Required. The domain for the vhost
      -D, --directory   Optional. The name of the folder inside /var/www

Ejemplo
---
    sudo bash virtualhost.sh -a create -d mywebpage.localhost

Esto nos creará un directorio `/var/www/mywebpage.localhost` con un archivo `index.html` y nos habilitará un virtualhost llamado `mywebpage.localhost`.