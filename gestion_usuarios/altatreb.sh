#! /bin/bash
# Marc García, Miguel Martínez, Nohemí Tomàs
#Date: 3 mar 2020
#Version 0.1
#Da de alta a trabajadores que pasamos por parámetro

if [ "$EUID" -ne 0 ] 2> /dev/null; then #Si no se esta ejecutando como root
  echo "ERROR: Permisos de root son necesarios para ejecutar el script" >&2
  exit 2
fi


if [ $# -lt 1 ]; then
  echo "ERROR: Hay que pasar un fichero por parámetro " >&2
  exit 1
fi

if [ $1 = "-h" ]; then
  echo "Uso: ./altausers.sh Fichero"
  echo "Formato Fichero:
  DNI:Apellido1 Apellido2,Nombre:Telefono:Departamento"
  echo "Da de alta a todos los trabajadores que pasamos por parametro"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  echo "Necesitamos permisos de root para dar de alta al usuario"
  exit 0
fi


IFS=$'\n'
if [ -d "/home/usuaris" ]; then
  echo "Ya existe el directorio usuaris"
else
  mkdir /home/usuaris
fi

for line in $(cat $1); do
  dni=$(cut -f1 -d ':' <<< $line )
  dep=$(echo $line | cut -f4 -d ":")
  nomComplet=$(echo $line | cut -f2 -d ":")
  nom=$(echo $nomComplet | cut -f2 -d ",")
  cognoms=$(echo $nomComplet | cut -f1 -d ",")
  telf=$(echo $line | cut -f3 -d ":")
  tmp=$(cat /etc/passwd | grep "$dni")
  pass=$(echo $telf | openssl passwd -1 -stdin )
  if [ "$tmp" = "" ]; then # el usuario no existe y por lo tanto lo creamos
    if [ -d "/home/usuaris/$dep" ]; then
      useradd $dni -m -d /home/usuaris/$dep/$dni --comment $nom,$cognoms -b /home/usuaris/$dep/$dni -p $pass -s /bin/bash
    else
      mkdir /home/usuaris/$dep
      useradd $dni -m -d /home/usuaris/$dep/$dni --comment $nom,$cognoms -b /home/usuaris/$dep/$dni -p $pass -s /bin/bash
    fi
  fi
done
