# Scripts de Administración de Servicios y Configuración de PHP

Este repositorio contiene varios scripts útiles para la administración de servicios y la configuración de PHP en un entorno Linux. A continuación se describen las funcionalidades de cada script.

## Scripts

### `nginx_modsite`

Este script permite habilitar y deshabilitar sitios web en Nginx de manera sencilla. Los sitios deben estar ubicados en los directorios de configuración predeterminados `/etc/nginx/sites-available` y `/etc/nginx/sites-enabled`.

#### Uso
```bash
nginx_modsite [opciones]

#### Opciones
- `-e, --enable <site>`: Habilita un sitio.
- `-d, --disable <site>`: Deshabilita un sitio.
- `-l, --list`: Lista los sitios disponibles y habilitados.
- `-h, --help`: Muestra la ayuda.
```

### `php_xdebug`

Este script permite habilitar y deshabilitar Xdebug en la versión actual de PHP instalada en el sistema.

#### Uso
```bash	
sudo php_xdebug [opciones]

#### Opciones
- `-h, --help`: Muestra la ayuda.
- `-e, --enable`: Habilita Xdebug.
- `-d, --disable`: Deshabilita Xdebug.
```

### `startup_services`

Este script configura y arranca varios servicios necesarios para el entorno de desarrollo, incluyendo PHP-FPM, Nginx, MySQL, Elasticsearch, Redis y Mailhog.

#### Uso
```bash	
sudo ./startup_services
```

### `stop_services`

Este script detiene varios servicios que pueden estar en ejecución, incluyendo PHP-FPM, Nginx, MySQL, Elasticsearch, Redis y Mailhog.

#### Uso
```bash
sudo ./stop_services
```

### `switchphp`

Este script permite cambiar entre diferentes versiones de PHP instaladas en el sistema.

#### Uso
```bash
sudo ./switchphp <php-version>
```

#### Ejemplo
```bash	
sudo ./switchphp 7.4
```

# Requisitos

- Permisos de superusuario (sudo) para ejecutar los scripts.
- PHP, Nginx, MySQL, Elasticsearch, Redis y Mailhog instalados en el sistema según sea necesario.

# Notas

- Asegúrese de que los scripts tengan permisos de ejecución. Puede otorgar permisos con el siguiente comando:
  `chmod +x script_name`
- Algunos scripts requieren archivos de configuración adicionales, como `xdebug.ini.template` para `php_xdebug`.