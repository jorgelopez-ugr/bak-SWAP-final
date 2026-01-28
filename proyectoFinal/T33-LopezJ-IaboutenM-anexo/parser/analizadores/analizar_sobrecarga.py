import re
import sys
import os

# Umbrales
MAX_RESPONSE_MS = 250
MAX_ERROR_TOTAL = 0
MIN_REQ_RATE = 300   # mínimo aceptable en req/s
MAX_USER_CPU = 90
MAX_SYSTEM_CPU = 90

if len(sys.argv) != 2:
    print("Uso: python3 analizar_httperf.py <archivo_log>")
    sys.exit(1)

archivo_log = sys.argv[1]

def analizar_httperf(path):
    try:
        with open(path, "r") as f:
            texto = f.read()
    except:
        return "No se pudo leer el archivo de salida de httperf."

    # Extraer datos con regex
    try:
        total_conns = int(re.search(r"connections\s+(\d+)", texto).group(1))
        req_rate = float(re.search(r"Request rate:\s+([\d\.]+)", texto).group(1))
        reply_time = float(re.search(r"Reply time \[ms\]: response ([\d\.]+)", texto).group(1))
        errors = int(re.search(r"Errors:\s+total\s+(\d+)", texto).group(1))
        cpu_user = float(re.search(r"user ([\d\.]+)%", texto).group(1))
        cpu_sys = float(re.search(r"system ([\d\.]+)%", texto).group(1))
    except:
        return "No se pudieron extraer métricas clave."

    # Mostrar resumen
    print("Análisis de sobrecarga con httperf:\n")
    print(f"  - Conexiones totales:       {total_conns}")
    print(f"  - Peticiones por segundo:   {req_rate}")
    print(f"  - Tiempo medio de respuesta:{reply_time} ms")
    print(f"  - Errores totales:          {errors}")
    print(f"  - CPU User:                 {cpu_user:.1f}%")
    print(f"  - CPU System:               {cpu_sys:.1f}%\n")

    # Evaluación
    if errors > MAX_ERROR_TOTAL:
        return "Test fallido: se produjeron errores durante la prueba."
    elif reply_time > MAX_RESPONSE_MS:
        return f"Respuesta lenta (> {MAX_RESPONSE_MS} ms)."
    elif req_rate < MIN_REQ_RATE:
        return "Bajo rendimiento: tasa de peticiones por segundo baja."
    elif cpu_user > MAX_USER_CPU or cpu_sys > MAX_SYSTEM_CPU:
        return "Advertencia: uso de CPU elevado."
    else:
        return "Test superado: sin errores, buena tasa de respuesta y CPU controlado."

# Ejecutar análisis
print(analizar_httperf(archivo_log))