#!/usr/bin/bash
# Este script actualiza las imágenes y arranca los contenedores.

echo "Vamos a proceder a actualizar las imágenes y arrancar los contenedores."

# Construir las imágenes Docker
chmod +x script_crea_imagenes.sh
./script_crea_imagenes.sh

# Limpia los contenedores anteriores
chmod +x script_limpia_contenedores.sh
./script_limpia_contenedores.sh

# Crear las redes necesarias
chmod +x script_gestion_redes.sh
./script_gestion_redes.sh

docker compose -f docker-compose.yml up -d
docker compose -f P2-jorgelpz-nginx/docker-compose.yml up -d
docker compose -f P2-jorgelpz-haproxy/docker-compose.yml up -d
docker compose -f P2-jorgelpz-traefik/docker-compose.yml up -d

docker ps