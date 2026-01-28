#!/bin/bash
cd ./tests/smoke-ab
docker-compose up -d

echo "Esperando a que los contenedores estén listos..."
sleep 10

cd ../../parser
echo "Parseando..."
docker-compose up -d