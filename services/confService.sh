#!/bin/sh													
# Marc García, Miguel Martínez, Nohemí Tomàs
# Date: 25 feb 2020	
# Version 0.1
# Configuracion para los scripts de backup y restore 	

####	VARIABLES		####
ret=0

#### 		CODE		####
user=$(whoami)
if [ $user != "root" ]
then
	echo "This script must be executed with root permisses.">&2
	ret=1
else
	chmod 644 backup.service
	cp -p *.service /etc/systemd/system/
	chown root /etc/systemd/system/backup.service
	chgrp root /etc/systemd/system/backup.service
	cp -p backup.sh /usr/bin/
	cp -p restore.sh /usr/bin/
	cp -p restore.sh /etc/init.d/
	chmod 755 /etc/init.d/restore.sh
	chown root:root /etc/init.d/restore.sh
	mkdir -p /usr/bin/utils/
	cp -p ../utils/* /usr/bin/utils/
	cd /etc/init.d
	/usr/lib/insserv/insserv restore.sh
fi
exit $ret
