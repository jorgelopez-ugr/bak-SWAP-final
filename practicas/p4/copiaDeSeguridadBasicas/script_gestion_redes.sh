#!/bin/bash

# este script es completamente traido de la práctica 1.

#Script para gestionar la red_web
echo " - Script para la creación de red_web y red_servicios - "
echo "red_web: 192.168.10.0/24 gw: 192.168.10.1"
echo "red_servicios: 192.168.20.0/24 gw: 192.168.20.1"

# Si la red existe la elimina para volverla a crear.
if docker network inspect red_web >/dev/null 2>&1; then
    echo "Las redes ya existen, procedemos a eliminarla"
    docker network rm red_web
fi

if docker network inspect red_servicios >/dev/null 2>&1; then
    echo "Las redes ya existen, procedemos a eliminarla"
    docker network rm red_servicios 
fi

docker network create -d bridge --subnet 192.168.10.0/24 --gateway 192.168.10.1 red_web
docker network create -d bridge --subnet 192.168.20.0/24 --gateway 192.168.20.1 red_servicios

docker network ls