#!/bin/sh -x														
# Marc García, Miguel Martínez, Nohemí Tomàs
# Date: 25 feb 2020	
# Version 0.1	
# Restaura los archivos que se habian guardado en el backup	

### BEGIN INIT INFO
# Provides:          restore.sh
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     1 2 3 4 5
# Default-Stop:      
# Short-Description: Restore backup files
### END INIT INFO

####	VARIABLES		####
ret=0
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DESC="restore the backup"
NAME=restore.sh
SCRIPTNAME=/etc/init.d/"$NAME"
DAEMON=/usr/sbin/restore.sh

#### 		CODE		####
IFS=$'\n'
user=$(whoami)

if [ $1 = "-h" ] 2> /dev/null; then
	echo "Script para que automaticamente cuando se encienda el sistema
		se haga la restauración de la ultima carpeta de /back"
	exit 0
fi

case "$1" in
	start) 
		cd /back/ 
		# ls -1 lista los directorios de 1 en 1
		backupTGZ=$(ls -1 | tail -1)
		# descomprime el tgz directamente en la raiz y se sustituyen 
		# los archivos correspondientes
		tar -xvf $backupTGZ -C /
		;;
	esac
exit $ret
