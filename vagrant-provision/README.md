Vagrant provision
=================

Esta estructura de directorios ha sido creada para facilitar la creación de entornos Vagrant basados en la box `ubuntu/xenial64`.

Requisitos
----------

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) >= 5.2.12
- [Vagrant](https://www.vagrantup.com/downloads.html) >= 2.1.1

Si el host es un SO Windows , para poder ejecutar bash habrá que instalar:
- [Git Bash](https://git-scm.com/downloads) >= 2.13.1

Instalación
-----------

Para la correcta instalación, hay que seguir los siguientes pasos:

    $ cd ~
    $ git clone https://github.com/xvrmallafre/bashutils
    $ cd bashutils
    $ cp vagrant-provision /carpeta/donde/se/vagrant
    $ cd ~
    $ rm -rf bashutils

Uso
---

Una vez ha sido completado el proceso de instalación, procedemos a cambiar algunos valores en el fichero situado en `config/config.yaml` (en caso que fuese necesario) para posteriormente inicializar el proceso. 

Para ello, hay que acceder al directorio donde se han dejado los ficheros y ejecutar el archivo `init_project.sh` de la siguiente manera:

    $ bash init_project.sh

