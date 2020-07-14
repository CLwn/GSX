#!/bin/bash
# Marc Garcia, Miguel Martínez, Nohemí Tomàs
#	Date: 11 feb 2020
#	Version 0.1
#	Vacia un fichero pasado por parametro	

#### 		CODE		####
if [ $# -lt 1 ]; then
	echo "This script requires 1 parameter (file name)." >&2
	exit 1
fi

if [ $1 = "-h" ]; then
	echo "Usage: ./bfit.sh [FILE]"
	echo "Remove the content from a given file."
	echo -e "Optional parameters:\n\t -h\tShow help."
	echo "This requires the permission to modify a given file."
  exit 0
fi


if [ -d $1 ]; then
	echo "A directory cannot be emptied." >&2
	exit 2
elif [ -f $1 ]; then
	>$1
else
	echo "ERROR: file doesn't exist" >&2
	exit 3
fi

exit 0
