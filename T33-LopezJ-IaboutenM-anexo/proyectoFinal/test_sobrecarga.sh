#!/bin/bash
cd ./tests/sobrecarga-httperf
docker-compose up -d

echo "Esperando a que los servicios esten listos..."
sleep 10

cd ../../parser
echo "Parseando..."
docker-compose up -d