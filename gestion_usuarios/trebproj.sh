#! /bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
#Date: 6 mar 2020
#Version 0.1
#Pone al usuario debajo del directorio del proyecto

if [ $# -lt 1 ]; then
  echo "ERROR: Hay que pasar el nombre del proyecto por parámetro" >&2
  exit 1
fi

if [ $1 = "-h" ]; then
  echo "Uso: ./altaproj.sh [id_proyecto]"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  exit 0
fi


if [ "$(id -Gn | grep $1)" != "" ];then
  actualGrupo=$(id -gn)
  if [ "$actualGrupo" != "$1" ]; then
    newgrp $1
    echo "Se ha modificado al grupo $1"
  fi
fi

realpath=$(find /home/projectes -iname $1)
cd $realpath

exec bash
exit 0
