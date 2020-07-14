#!/bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
#	Date: 05 mar 2020
#	Version 0.1
#	Para todos los procesos que hayan consumido 3 min de CPU en
#	una hora. comando crontab 0 10-20 * * * ./stopProc.sh

#### 		CODE		####
if [ "$EUID" -ne 0 ] 2> /dev/null; then #Si no se esta ejecutando como root
  echo "ERROR: Permisos de root son necesarios para ejecutar el script" >&2
  exit 2
fi


if [ $1 = "-h" ] 2> /dev/null; then
  echo "Uso: ./stopProc.sh"
  echo "Para todos los procesos en ejecución que hayan consumido más de 3 min de la CPU"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  echo "Necesitamos permisos de root para dar de alta al usuario"
  exit 0
fi

IFS=$'\n'

if [ ! -f /home/milax/GSX/gestion_procesos/stoppedProc.txt ]; then
  touch /home/milax/GSX/gestion_procesos/stoppedProc.txt
fi
file=$(cat /home/milax/GSX/gestion_procesos/stoppedProc.txt)

procesos=$(ps -e --no-headers -o "%p/%x")
for line in $procesos;do
  if [ $(date --date="$(cut -f2 -d"/" <<< "$line")" +%s) -ge $(date --date="00:03:00" +%s) ]; then
    pid=$(echo "$line" | cut -f1 -d "/")
    findProc=$($file | grep "$pid")
    if [ "$findProc" = "" ]; then
      echo "$pid" >> /home/milax/GSX/gestion_procesos/stoppedProc.txt
      kill -SIGSTOP $pid
    fi
  fi
done

exit 0
