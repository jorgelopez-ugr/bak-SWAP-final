#!/bin/sh
set -e

# Variables de entorno o valores por defecto
TARGET=http://192.168.30.50/

OUTDIR=/logs
mkdir -p "$OUTDIR"

OUT="$OUTDIR/estres-$(date +%Y%m%d_%H%M%S).log"

echo "Ejecutando k6 run estres.js"
TARGET="$TARGET" k6 run estres.js | tee "$OUT"

echo "Resultado JSON en $OUT"
ls -lh "$OUTDIR"
