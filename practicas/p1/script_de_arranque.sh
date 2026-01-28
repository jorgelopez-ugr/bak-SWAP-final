#!/usr/bin/bash

# Este script actualiza las imágenes y arranca los contenedores.
echo "Vamos a proceder a actualizar las imágenes y arrancar los contenedores."
# Ejecutar el script script_crea_redes.sh
echo "Script que crea las redes"
chmod +x script_crea_redes.sh
./script_crea_redes.sh

# Construir las imágenes Docker
docker build -t jorgelpz-apache-image:p1 -f DockerfileApache_jorgelpz .
docker build -t jorgelpz-nginx-image:p1 -f DockerfileNginx_jorgelpz .

docker-compose up -d

echo "Aplicando las restricciones en las redes"
chmod +x script_bloquea_web8.sh
./script_bloquea_web8.sh

#este script funciona