#!/bin/bash
# Marc Garcia
# Configura una red con los valores pasados por parametro

if [ $1 = "-h" ]; then
	echo "Uso: ./aif.sh [NOMBRE_RED] [ADDRESS] [NETMASK] [NETWORK] [GATEWAY]"
	echo "Configura una nueva red con los valores pasados por parametro añadiendo la informacion al fichero de /etc/network/interfaces."
	echo -e "Opciones:\n\t -h\tAyuda para utilizar el script."
	echo "Necesitamos permisos de root para poder modificar el fichero de /etc/network/interfaces."
	exit 0
fi

if [ "$EUID" -ne 0 ]; then # Si no se esta ejecutando con permisos de root.
	echo "ERROR: This script requires root permisses." >&2
	exit 2
fi

if [ $# -lt 5 ]; then
	echo "ERROR: Faltan parametros." >&2
	exit 1
fi



if [[ $2 =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
if [[ $3 =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
if [[ $4 =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
if [[ $5 =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
echo "" >> /etc/network/interfaces
echo "auto $1" >> /etc/network/interfaces
echo "iface $1 inet static" >> /etc/network/interfaces
echo -e "\t address $2" >> /etc/network/interfaces
echo -e "\t netmask $3" >> /etc/network/interfaces
echo -e "\t network $4" >> /etc/network/interfaces
echo -e "\t gateway $5" >> /etc/network/interfaces
echo "Se ha configurado la red con exito."
exit 0
fi fi fi fi
echo "ERROR: Valores no validos" >&2
exit 3
