#!/bin/bash
VERSION="0.2.0"

function printUsage() {
	echo "Usage: sudo virtualhost [options]"
	echo ""
	echo "All the available virtualhost options are:"
	echo "  -h, --help        Show this help message and exit"
	echo "  -v, --version     Show the script version and exit"
	echo "  -a, --action      Required. The possibilities are: create or delete"
	echo "  -d, --domain      Required. The domain for the vhost"
	echo "  -D, --directory   Optional. The name of the folder inside /var/www"
	echo ""
	exit 0
}

function printVersion() {
	echo "virtualhost v${VERSION}"
	exit 0
}

while true; do
    case "$1" in
		-h|--help )
		printUsage;
		shift ;;

		-v|--version )
		printVersion;
		shift ;;

		-a|--action )
		ACTION="$2";
		shift ;
		shift ;;

		-d|--domain )
		DOMAIN="$2"
		shift ;
		shift ;;

		-D|--directory )
		ROOTDIR="$2"
		shift ;
		shift ;;

		* )
		break ;;
	esac
done

OWNER=$(who am i | awk '{print $1}')
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'
sitesAvailabledomain=${sitesAvailable}${DOMAIN}.conf

if [ "$(whoami)" != 'root' ]; then
	echo $"You have no permission to run $0 as non-root user. Use sudo"
	exit 1;
fi

if [ "${ACTION}" != 'create' ] && [ "${ACTION}" != 'delete' ]; then
	printUsage
fi

if [ "${DOMAIN}" == "" ];then
	echo -e $"Please provide domain. e.g: example.test"
	exit 0
fi

if [ "${ROOTDIR}" == "" ]; then
	ROOTDIR=${userDir}${DOMAIN}
else
	ROOTDIR=${userDir}${ROOTDIR}
fi

if [ "${ACTION}" == 'create' ]
	then
		if [ -e ${sitesAvailabledomain} ]; then
			echo -e $"This domain already exists.\nPlease Try Another one"
			exit;
		fi
		if ! [ -d ${ROOTDIR} ]; then
			mkdir ${ROOTDIR}
			chmod 755 ${ROOTDIR}
			if ! echo "<?php echo phpinfo(); ?>" > ${ROOTDIR}/phpinfo.php
			then
				echo $"ERROR: Not able to write in file ${ROOTDIR}/phpinfo.php. Please check permissions"
				exit;
			else
				echo $"Added content to ${ROOTDIR}/phpinfo.php"
			fi
		fi
		if ! echo "<VirtualHost *:80>
	ServerName ${DOMAIN}
	ServerAlias ${DOMAIN}
	DocumentRoot ${ROOTDIR}
	<Directory ${ROOTDIR}>
		Options Indexes FollowSymLinks
		AllowOverride all
	</Directory>
	ErrorLog /var/log/apache2/${DOMAIN}-error.log
	LogLevel warn
	CustomLog /var/log/apache2/${DOMAIN}-access.log combined
</VirtualHost>" > ${sitesAvailabledomain}
		then
			echo -e $"There is an ERROR creating ${DOMAIN} file"
			exit;
		else
			echo -e $"\nNew Virtual Host Created\n"
		fi
		chown -R ${OWNER}:${OWNER} ${ROOTDIR}
		a2ensite ${DOMAIN}
		service apache2 reload
		echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://${DOMAIN} \nAnd its located at ${ROOTDIR}"
		exit;
	else
		if ! [ -e ${sitesAvailabledomain} ]; then
			echo -e $"This domain does not exist.\nPlease try another one"
			exit;
		else
			a2dissite ${DOMAIN}
			service apache2 reload
			rm ${sitesAvailabledomain}
		fi
		if [ -d ${ROOTDIR} ]; then
			echo -e $"Delete host root directory ? (y/n)"
			read deldir

			if [ "${deldir}" == 'y' -o "${deldir}" == 'Y' ]; then
				rm -rf ${ROOTDIR}
				echo -e $"Directory deleted"
			else
				echo -e $"Host directory conserved"
			fi
		else
			echo -e $"Host directory not found. Ignored"
		fi
		echo -e $"Complete!\nYou just removed Virtual Host ${DOMAIN}"
		exit 0
fi
