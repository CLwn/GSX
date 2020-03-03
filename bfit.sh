#!/bin/bash
# Marc Garcia
# Vacia un fichero pasado por parametro

if [ $# -lt 1 ]; then
	echo "ERROR: Hay que pasar el fichero por parametro." >&2
	exit 1
fi

if [ $1 = "-h" ]; then
	echo "Usage: ./bfit.sh [FILE]"
	echo "Remove the content from a given file."
	echo -e "Optional parameters:\n\t -h\tShow help."
	echo "This requires the permission to modify a given file."
  exit 0
fi

if [ -f $1 ]; then
	truncate -s 0 $1 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "ERROR: No tenemos permisos para vaciar el fichero." >&2
		exit 4
	fi
elif [ -d $1 ]; then
	echo "ERROR: No podemos vaciar un directorio." >&2
	exit 2
else
	echo "ERROR: El fichero no existe." >&2
	exit 3
fi

exit 0
