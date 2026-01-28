#!/bin/bash

# Ejecutar el script que crea las redes
./crea_red_entorno.sh

# Moverse al directorio targets/P5-granjaweb
cd targets/P5-granjaweb

# Ejecutar docker-compose
docker-compose up -d

# Volver al directorio inicial
cd ../../

# Llamar al script activa_monitoreo
./activa_monitoreo.sh