#!/bin/sh
set -e

# Parámetros (env vars o valores por defecto)
TARGET=http://192.168.30.50/
CONCURRENCY=${CONCURRENCY:-500}
RATE=${RATE:-0}          # conexiones/segundo (0 = tan rápido como pueda)
BURST=${BURST:-10000}    # número total de peticiones

LOG_DIR=/logs
mkdir -p "$LOG_DIR"

OUT="$LOG_DIR/overload-$(date +%Y%m%d_%H%M%S).log"

echo "Overload Test (httperf): httperf --server $(echo $TARGET|sed 's|http://||;s|/$||') \
    --num-conns $BURST --num-calls $BURST --rate $RATE \
    > $OUT"

httperf \
  --server "$(echo $TARGET | sed 's|http://||;s|https://||;s|/$||')" \
  --num-conns "$BURST" \
  --rate "$RATE" \
  --uri "/" > "$OUT" 2>&1

echo "Resultado guardado en $OUT"
echo "Contenido de /logs:"
ls -lh "$LOG_DIR"
