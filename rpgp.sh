#!/bin/bash
# Marc Garcia
# Restaura el propietario, grupo y permisos de los ficheros indicados dentro de otro fichero

if [ "$EUID" -ne 0 ]; then # Si no se esta ejecutando con permisos de root.
	echo "ERROR: Permisos de root son necesarios para ejecutar el script." >&2
	exit 2
fi

if [ $# -lt 1 ]; then
	echo "ERROR: Hay que pasar un fichero por parámetro" >&2
	exit 1
fi

if [ $1 = "-h" ]; then
	echo "Uso: ./rpgp.sh FICHERO"
	echo "Muestra por pantalla el propietario, grupo y permisos actuales y anteriores de todos los ficheros o directorios indicados dentro del fichero que pasamos por parametro y restaura su valor antiguo si el usuario da su permiso."
	echo -e "Opciones:\n\t -h\tAyuda para utilizar el script."
	echo "Necesitaremos los permisos necesarios para poder leer el fichero pasado por parámetro. Si queremos utilizar la función de restaurar el estado anterior, también necesitaremos permisos de root."
	exit 0
fi

IFS=$'\n' # Separar fichero por saltos de línea

for line in $(cat $1); do
	file=$(cut -f 1 -d $'\t' <<< "$line")
	ls "$file" > /dev/null 2> /dev/null
	if [ $? == 0 ]; then # Si el fichero existe
		before=$(echo -e $(stat --format="%U\t%G\t%a" $file))
		after=$(cut -f 2-4 -d "	" <<< "$line")
		echo $(realpath $file)
		if [ $before != $after ]; then
      echo -e "Estado actual  : $before"
  		echo -e "Estado anterior: $after"
			echo "¿Quieres restaurar las propiedades anteriores? y/n"
			read -r conf
			if [ $conf = "y" ]; then
				chown $(cut -f 2 -d $'\t' <<< "$line") $file
				chgrp $(cut -f 3 -d $'\t' <<< "$line") $file
				chmod $(cut -f 4 -d $'\t' <<< "$line") $file
				echo "Se han restablecido las propiedades."
			fi
		else
      echo -e "los permisos de $file no se han visto modificados"
	else
		echo "ERROR: $file no existe." >&2
		exit 3
	fi
	echo ""
done
exit 0
