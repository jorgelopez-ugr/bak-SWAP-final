#!/bin/bash
cd ./tests/capacidad-wrk
docker-compose up -d

echo "Esperando a que los servicios esten listos..."
sleep 10

echo "Parseando..."
cd ../../parser
docker-compose up -d