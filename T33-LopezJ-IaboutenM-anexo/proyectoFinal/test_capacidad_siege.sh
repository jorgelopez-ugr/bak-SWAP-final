#!/bin/bash
cd ./tests/capacidad-siege
# Execute docker-compose
docker-compose up -d
echo "Esperando a que los servicios esten listos..."
sleep 10
echo "Parseando..."
cd ../../parser
docker-compose up -d
