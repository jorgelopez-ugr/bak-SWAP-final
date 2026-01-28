#!/bin/sh
set -e

# Parámetros (por env vars o valores por defecto)
TARGET=http://192.168.30.50/
THREADS=${THREADS:-2}
CONNS=${CONNS:-50}
DURATION=${DURATION:-30s}

LOG_DIR=/logs
mkdir -p "$LOG_DIR"

OUT="$LOG_DIR/capacidad-$(date +%Y%m%d_%H%M%S).log"

echo "Test de capacidad: wrk -t $THREADS -c $CONNS -d $DURATION $TARGET"
wrk -t"$THREADS" -c"$CONNS" -d"$DURATION" "$TARGET" > "$OUT" 2>&1
cat "$OUT"
echo "Contenido del directorio de logs:"
ls -lh "$LOG_DIR"
echo "Resultado en $OUT"
