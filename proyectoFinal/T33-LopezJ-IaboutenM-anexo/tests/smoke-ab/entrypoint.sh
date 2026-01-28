#!/usr/bin/env bash
set -e

# URL objetivo — por defecto en / (puedes apuntar a /health, /login…)
TARGET=http://192.168.30.50/

# Número de peticiones y concurrencia para smoke test
REQUESTS=10
CONCURRENCY=1

# Directorio donde volcamos resultados
RESULT_DIR=/logs
mkdir -p $RESULT_DIR

# Archivo de salida
OUT_FILE="$RESULT_DIR/smoke-$(date +%Y%m%d_%H%M%S).log"

echo "Smoke Test en $TARGET > $OUT_FILE"
ab -n $REQUESTS -c $CONCURRENCY $TARGET > $OUT_FILE 2>&1

echo "Smoke test terminado."
echo "Results disponibles en $OUT_FILE"
