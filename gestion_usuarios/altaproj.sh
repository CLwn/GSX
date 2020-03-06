#! /bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
#Date: 5 mar 2020
#Version 0.1
#Da de alta todos los proyectos pasados por un fichero

if [ "$EUID" -ne 0 ] 2> /dev/null; then #Si no se esta ejecutando como root
  echo "ERROR: Permisos de root son necesarios para ejecutar el script" >&2
  exit 2
fi


if [ $# -lt 1 ]; then
  echo "ERROR: Hay que pasar un fichero por parámetro " >&2
  exit 1
fi

if [ $1 = "-h" ]; then
  echo "Uso: ./altaproj.sh Fichero"
  echo -e "Formato Fichero:\nidentificador\ndescripcion del proyecto\ndni del jefe del proyecto\ndni trabajadores\n"
  echo "Da de alta a todos los trabajadores que pasamos por parametro"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  echo "Necesitamos permisos de root para dar de alta al usuario"
  exit 0
fi

IFS=$'\n'

if [ ! -d /home/projectes ]; then
  mkdir /home/projectes
fi

if [ ! -d /home/projectes/enestudi ]; then
  mkdir /home/projectes/enestudi
fi

if [ ! -d /home/projectes/encurs ]; then
  mkdir /home/projectes/encurs
fi

if [ ! -d /home/projectes/finalitzat ]; then
  mkdir /home/projectes/finalitzat
fi

i=$(wc -l $1 | cut -c1)

value=1
while [[ $value -lt $i+1 ]]; do
  id=$(awk 'NR == '$value $1)
  ((value++))
  desc=$(awk 'NR == '$value $1)
  ((value++))
  boss=$(awk 'NR == '$value $1)
  ((value++))
  workers=$(awk 'NR == '$value $1)
  ((value++))
  if [ ! -d "/home/projectes/enestudi/$id" ]; then
    mkdir /home/projectes/enestudi/$id
  else
    echo "el directorio /home/projectes/enestudi/$id ya existe"
  fi
  groupadd $id
  chgrp -R $id /home/projectes/enestudi/$id
  chmod g+s /home/projectes/enestudi/$id #para que futuros archivos en nuestro dir tengan los mismos permisos que esta
  echo $desc > /home/projectes/enestudi/$id/README
  usermod -a -G $id $boss
  IFS=',' read -a array <<< $workers
  for element in ${!array[@]}; do
    usermod -a -G $id ${array[element]} #usermod -a -G es para agregar nuevos grupos a los grupos ya existentes
  done
done
