#!/bin/bash
# Marc Garcia, Nohemí Tomàs, Miguel Martínez
# Date: 5 mar 2020
# Version 0.1
# Lista todos los procesos que se han ejecutado entre las 13 y 15 horas

#### 		CODE		####
if [ "$EUID" -ne 0 ]; then # Si no se esta ejecutando con permisos de root.
	echo "ERROR: Permisos de root son necesarios para ejecutar el script." >&2
	exit 2
fi

if [[ $# -gt 0  &&  $1 = "-h" ]]; then
	echo "Uso: ./comandes.sh"
	echo "Lista todas las comandas y de quien las ha ejecutado entre las 13:00 y las 14:59 horas."
	echo -e "Opciones:\n\t -h\tAyuda para utilizar el script."
	echo "Necesitamos permisos de root para poder acceder al fichero /var/log/account/pacct."
	exit 0
fi


IFS=$'\n'
comandas=$(lastcomm)
for line in $comandas; do
	hour=$(cut -c65-66 <<<"$line")	#Nos quedamos con los 2 carácteres que simbolizan la hora
  if [ $hour -eq 13 -o $hour -eq 14 ]; then
		echo $(cut -f1 -d ' ' <<<"$line") $(cut -c24- <<<"$line" | cut -f1 -d ' ')
	fi
done
