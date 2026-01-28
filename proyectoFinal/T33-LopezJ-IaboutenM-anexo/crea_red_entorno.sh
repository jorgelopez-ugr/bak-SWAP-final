#!/bin/bash

# este script es completamente traido de la práctica 1.

#Script para gestionar la red_web
echo " - Script para la creación de la red_entorno "
echo "red_entorno: 192.168.30.0/24 gw: 192.168.30.1"

# Si la red existe la elimina para volverla a crear.
if docker network inspect red_entorno >/dev/null 2>&1; then
    echo "Volvemos a crear la red red_entorno"
    docker network rm red_entorno
fi

docker network create -d bridge --subnet 192.168.30.0/24 --gateway 192.168.30.1 red_entorno
docker network ls