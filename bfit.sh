#!/bin/bash
# Marc Garcia
# Vacia un fichero pasado por parametro

if [$ # -lt 1 ]; then
  echo "ERROR: Hay que pasar el fichero por parametro." >&2
  exit 1
fi
if [$1 = "-h" ]; then
    echo "Uso: ./bfit.sh FICHERO"
    echo "Vacia un fichero pasado por parametro"
    echo - e "Opciones:\n\t -h\tAyuda para utilizar el script."
    echo "Solo necesitamos los permisos necesarios para poder modificar el fichero."
    exit 0
fi

if [ - f $1 ]; then
  truncate - s 0$1 2 > /dev/ null

  if [$ ? - ne 0 ]; then
    echo "ERROR: No tenemos permisos para vaciar el fichero." >&2
    exit 4
  fi
elif [ - d $1 ]; then
  echo "ERROR: No podemos vaciar un directorio." >&2
  exit 2
else
  echo "ERROR: El fichero no existe." >&2
  exit 3
fi
exit 0