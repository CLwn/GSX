#!/bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
# Date: 18 feb 2020						
# Version 0.3		
# Copia de seguridad de los archivos modificados desde la ultima
# vez que se encendio el sistema 

####	VARIABLES		####
ret=0

#### 		CODE		####

/usr/bin/utils/bfit.sh /tmp/bkpPaths.txt
IFS=$'\n'
for line in $(find /usr -type f ! -path '*/\.*' -newer /proc/stat); do
	echo $line >> /tmp/bkpPaths.txt
done

for line in $(find /home -type f ! -path '*/\.*' -newer /proc/stat); do
	echo $line >> /tmp/bkpPaths.txt
done

fileName="$(date +%Y%m%d%H%M)"
mkdir -p /back/
for line in $(cat /tmp/bkpPaths.txt); do
	/usr/bin/utils/gpgp.sh $line >> "/back/$fileName.pth"
done

tar -Ppzcf /back/$fileName.tgz -T "/tmp/bkpPaths.txt" >&2					# -p is used to preserve permisses
																			# -z is used to compress files
																			# -c is used to create new file
																			# -f is used to use our file ($fileName) and not to create a different one
																			# -P is used to preserve full absolute path
rm /tmp/bkpPaths.txt


exit $ret
