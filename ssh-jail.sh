#!/bin/bash

# Generado con las instrucciones de https://es.linux-console.net/?p=1732

if [ -z $1 ]
then
        echo "Introduce la ruta en la que se enjaulará al usuario como primer argumento"
        exit 0
else
        if [ ${1: -1} == "/" ]
        then
                echo "La ruta no debe acabar en /"
                exit 0
        fi
fi

JAIL_PATH=$1

JAIL_USER=$2


echo "Creando carpetas..."
mkdir -vp ${JAIL_PATH}/{bin,dev,home/${JAIL_USER},lib,usr}
chown root:root ${JAIL_PATH}
chown ${JAIL_USER}:${JAIL_USER} ${JAIL_PATH}/home/${JAIL_USER}



cd ${JAIL_PATH}/dev

echo -e "\n\n\nCreando dispositivos virtuales..."
mknod -m 666 null c 1 3
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5
mknod -m 666 random c 1 8

cd ${JAIL_PATH}



echo -e "\n\n\nCopiando binarios y librerías..."
executables=(bash ls mkdir rm mv)

for executable in ${executables[@]}
do
        exec_path=$(which $executable)
        echo -e "\n\nCopiando las librerías del binario $executable"
        cp -v ${exec_path} ${JAIL_PATH}/bin

    ldd ${exec_path} | grep -oE '(\/.+?) ' | tr -d ' ' | xargs -I '{}' cp -v '{}' ${JAIL_PATH}/lib
done

echo -e "\n\n\nCopiando a usr..."
cp -vr ${JAIL_PATH}/bin/ ${JAIL_PATH}/usr/
