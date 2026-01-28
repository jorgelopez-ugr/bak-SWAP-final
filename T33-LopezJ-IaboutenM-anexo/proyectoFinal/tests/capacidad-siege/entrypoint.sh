#!/bin/sh
set -e

# Parámetros (por env vars o valores por defecto)
TARGET=http://192.168.30.50/
CONCURRENCY=${CONCURRENCY:-50}
DURATION=${DURATION:-30s}

LOG_DIR=/logs
mkdir -p "$LOG_DIR"

OUT="$LOG_DIR/siege-$(date +%Y%m%d_%H%M%S).log"

echo "Siege Test: siege -c${CONCURRENCY} -t${DURATION} ${TARGET}"
siege -c"${CONCURRENCY}" -t"${DURATION}" "${TARGET}" > "$OUT" 2>&1

echo "Resultado en $OUT"
echo "Contenido de $LOG_DIR:"
ls -lh "$LOG_DIR"
