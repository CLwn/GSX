#! /bin/bash
# Marc García, Nohemí...
# Guarda el propietari, grup i permisos dels fitxers que passem

if [[ $# -lt 1 ]]; then
  echo "Error: Hay que pasar un fichero por parámetro" >&2
  exit 1
fi

if [[ $1 = "-h" ]]; then
  echo "Uso: ./gpgp.sh NombreFichero"
  echo "Muestra por pantalla el propietario, grupo y permisos de todos los ficheros
  o directorios indicados dentro del fichero que pasamos por parametro"
  echo -e "Opciones: \n\t -h\t Ayuda para utilizar el script"
  echo "Necesitaremos los permisos necesarios para poder leer el fichero pasado
  por parametro"
  exit 0
fi

IFS=$"\n" #Separa fichero por saltos de linea

if [[ ! -f $1 ]]; then
  echo "El archivo $1 no existe" >&2
  exit 1
fi

for file in $(cat $1); do
  stat"$file" > /dev/null 2> /dev/null
  if [[ $? == 0 ]]; then #Si el fichero existe
    echo -e ""
  fi

done
