#######################################################
#! /bin/bash															#
#	Authors:															#
#		Miguel Martínez													#
#		Nohemí Tomàs													#
#		Marc García 													#
#	Date: 3 mar 2020													#
#	Version 0.1															#
# Da de alta a trabajadores que pasamos por parámetro	#
#######################################################


###   CODE   ###

if [ "$EUID" -ne 0 ]; then #Si no se esta ejecutando como root
  echo "ERROR: Permisos de root son necesarios para ejecutar el script" >&2
  exit 2
fi

if [ $# -lt 1 ]; then
  echo "ERROR: Hay que pasar un fichero por parámetro " >&2
  exit 1
fi

if [ $# = "-h" ]; then
  echo "Uso: ./altausers.sh Fichero"
  echo "Formato Fichero:
  DNI:Apellido1 Apellido2:Nombre:Telefono:Departamento"
  echo "Da de alta a todos los trabajadores que pasamos por parametro"
  echo -e "Opciones:\n\t -h\tAyuda para utilizar el script"
  echo "Necesitamos permisos de root para dar de alta al usuario"
  exit 0
fi

if [ -d "/home/usuaris" ]; then
  echo "Ya existe el directorio usuaris"
else
  mkdir /home/usuaris
fi

for line in $(cat $1); do
  $dni=$(cut -f1 -d ":" <<< $line )
  $tmp=$(cat /etc/passwd | grep "$dni")
  if [[ $tmp = "" ]]; then # el usuario no existe y por lo tanto lo creamos
    $dep=$(cut -f5 -d ":" <<< $line )
    $telf=$(cut -f4 -d ":" <<< $line )
    $pass=$(openssl passwd -1 -stdin <<< $telf )
    if [[ -d "/home/usuaris/$dep" ]]; then
    useradd $dni -m -d /home/usuaris/$dep/$dni -b /home/usuaris/$dep/$dni -p $pass -s /bin/bash
    else
    mkdir /home/usuaris/$dep
    useradd $dni -m -d /home/usuaris/$dep/$dni -b /home/usuaris/$dep/$dni -p $pass -s /bin/bash
    fi
  fi
done
exit 0
