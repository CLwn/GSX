#!/bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
#	Date: 05 mar 2020
#	Version 0.1
# 	Limita el numero maximo de procesos de un usuario

#### 		CODE		####
if [ "$EUID" -ne 0 ] 2> /dev/null; then #Si no se esta ejecutando como root
  echo "ERROR: Permisos de root son necesarios para ejecutar el script" >&2
  exit 2
fi


if [ $# -lt 1 ]; then
  echo "ERROR: Hay que pasar un valor por parámetro " >&2
  exit 1
fi

if [ $1 = "-h" ]; then
  echo "Uso: ./altaproj.sh [Value_proc]"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  echo "Necesitamos permisos de root para dar de alta al usuario"
  exit 0
fi

if [ $? -eq 0 ]; then
  echo -e "*\thard\tnproc\t$1" > /etc/security/limits.conf
  conf="session required\tpam_limits.so"
  file=/etc/pam.d/common-session
  text=$(cat $file | grep -P "$conf")
  if [ "$text" = "" ]; then #lo metemos si no se ha introducido anteriormente
    echo -e "$conf" >> $file
  fi
  pam-auth-update --force
  echo "Se ha limitado el número de procesos de los usuarios a $1"
fi

exit 0
