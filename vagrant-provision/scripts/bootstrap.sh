#!/usr/bin/env bash

# Configurable Variables
GITNAME=$1
GITEMAIL=$2
GITTEXTEDITOR=$3
MYSQLROOTPASSWORD=$4

# Script Variables
VMHOSTSDIR='/etc/apache2/sites-available'
PHPMODSDIR='/etc/php/7.1/mods-available'
HOMEROOT='/root'
HOMEVAGRANT='/home/vagrant'
HOSTSDIR='/vagrant/vhosts'
SCRIPTSDIR='/usr/local/bin'

# Update
sudo apt-get update

# Installing VIM
sudo apt-get install -y vim

# Installing GIT
sudo apt-get install -y git

# Set up .gitconfig
git config --global user.name ${GITNAME}
git config --global user.email ${GITEMAIL}
git config --global core.editor ${GITTEXTEDITOR}
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.last "log -1"
sudo cp /root/.gitconfig ${HOMEVAGRANT} && sudo chown vagrant.vagrant ${HOMEVAGRANT}/.gitconfig

# Installing Curl
sudo apt-get install -y curl

# Installing Apache
sudo apt-get install -y apache2
sudo a2enmod rewrite
APACHEUSR=`grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars`
APACHEGRP=`grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars`
if [ APACHEUSR ]; then
    sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars
fi
if [ APACHEGRP ]; then
    sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars
fi
sudo chown -R vagrant:www-data /var/lock/apache2
sudo a2dissite 000-default.conf
sudo a2dissite default-ssl.conf
sudo service apache2 reload

# Installing OpenSSL
sudo apt-get install -y openssl

# Installing Redis
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo apt-get update -y
sudo apt-get install -y redis-server

# Installing PHP 7.1
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install -y php7.1 libapache2-mod-php7.1 php7.1-cli php7.1-common php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-mysql php7.1-mcrypt php7.1-zip php7.1-soap php7.1-curl php-redis php7.1-xsl php7.1-readline php7.1-json php7.1-bz2 php7.1-pgsql php7.1-snmp php-xdebug

# Set up Xdebug
XDEBUGFILE="${PHPMODSDIR}/xdebug.ini"
sudo rm ${XDEBUGFILE}
if [ ! -f ${XDEBUGFILE} ];
then
    sudo touch ${XDEBUGFILE}
    sudo echo "zend_extension=xdebug.so" >> ${XDEBUGFILE}
    sudo echo "xdebug.remote_enable = 1" >> ${XDEBUGFILE}
    sudo echo "xdebug.remote_port = 9000" >> ${XDEBUGFILE}
    sudo echo "xdebug.idekey = PHPSTORM" >> ${XDEBUGFILE}
    sudo echo "xdebug.show_error_trace = 1" >> ${XDEBUGFILE}
    sudo echo "xdebug.remote_autostart = 0" >> ${XDEBUGFILE}
    sudo echo "xdebug.var_display_max_depth = -1" >> ${XDEBUGFILE}
    sudo echo "xdebug.var_display_max_children = -1" >> ${XDEBUGFILE}
    sudo echo "xdebug.var_display_max_data = -1" >> ${XDEBUGFILE}
fi
sudo phpenmod xdebug

# Restart Apache
sudo service apache2 reload

# Installing MySQL
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQLROOTPASSWORD}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQLROOTPASSWORD}"
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-client
MYCNFFILE="${HOMEROOT}/.my.cnf"
sudo echo "[client]" >> ${MYCNFFILE}
sudo echo "user=root" >> ${MYCNFFILE}
sudo echo "password=${MYSQLROOTPASSWORD}" >> ${MYCNFFILE}
cp ${MYCNFFILE} ${HOMEVAGRANT}
sudo chown vagrant.vagrant ${HOMEVAGRANT}/.my.cnf

# Installing Nodejs
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y build-essential nodejs

# Installing Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=${SCRIPTSDIR} --filename=composer
php -r "unlink('composer-setup.php');"
sudo chown vagrant.vagrant ${SCRIPTSDIR}/composer
sudo composer self-update -q

# Set up VHOSTS
if [ -d ${HOSTSDIR} ];
then
    for fn in `cd ${HOSTSDIR} && ls *.conf`; do
        if [ -f ${VMHOSTSDIR}/${fn} ]; then
            sudo a2dissite ${fn}
        fi
        sudo cp ${HOSTSDIR}/${fn} ${VMHOSTSDIR}
        sudo a2ensite ${fn}
        sudo service apache2 restart
    done
fi

# Installing Ruby
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.5 ruby2.5-dev

# Installing Pip
sudo apt-get install -y python-pip
sudo pip install --upgrade pip

# Installing awscli
sudo pip install awscli --upgrade --user

# Update & Upgrade
sudo apt-get update && sudo apt-get -y upgrade
