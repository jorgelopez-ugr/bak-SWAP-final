import re
import sys
import os

# Umbrales
MAX_LATENCIA_MS = 200
MIN_RPS = 100

# Verificar argumento
if len(sys.argv) != 2:
    print("Uso: python3 analizar_wrk.py <archivo_log.txt>")
    print("Ejemplo: python3 analizar_wrk.py wrk-20250607_184000.txt")
    sys.exit(1)

archivo = sys.argv[1]

def analizar_wrk(path):
    try:
        with open(path, "r") as f:
            texto = f.read()
    except:
        return "No se pudo leer el archivo."

    try:
        rps = float(re.search(r"Requests/sec:\s+([\d\.]+)", texto).group(1))
        latency = re.search(r"Latency\s+([\d\.]+)(ms|s|us)", texto)
        unit = latency.group(2)
        latency_val = float(latency.group(1))

        # Normalizar a milisegundos
        if unit == "s":
            latency_val *= 1000
        elif unit == "us":
            latency_val /= 1000

    except:
        return "Error al interpretar la salida de wrk."

    # Mostrar resumen
    print("Análisis wrk:\n")
    print(f"  - Peticiones/segundo: {rps}")
    print(f"  - Latencia media:     {latency_val:.2f} ms\n")

    # Evaluación
    if latency_val > MAX_LATENCIA_MS:
        return "Servicio responde pero lento (> 200 ms)."
    elif rps < MIN_RPS:
        return "Muy baja tasa de peticiones (< 100 RPS)."
    else:
        return "Servicio estable y rápido."

# Ejecutar
print(analizar_wrk(archivo))