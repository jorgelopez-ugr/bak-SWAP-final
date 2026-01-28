#!/bin/bash
cd ./tests/estres-k6
# Execute docker-compose
docker-compose up -d

echo "Esperando a que los servicios esten listos..."
sleep 90

# Execute parsea.sh script
echo "Parseando..."
cd ../../parser
docker-compose up -d