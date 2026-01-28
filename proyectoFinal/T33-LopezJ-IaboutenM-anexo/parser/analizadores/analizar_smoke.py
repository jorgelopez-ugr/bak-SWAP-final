import re
import sys
import os

# Umbrales configurables
MAX_FAILED_REQUESTS = 0
MAX_TIME_PER_REQUEST_MS = 100

# Comprobación de argumentos
if len(sys.argv) != 2:
    print("Uso: python3 analizar_ab.py <nombre_archivo.log>")
    print("Ejemplo: python3 analizar_ab.py smoke-20250607_145718.log")
    sys.exit(1)

archivo_salida = sys.argv[1]

def analizar_ab(path):
    try:
        with open(path, "r") as f:
            texto = f.read()
    except FileNotFoundError:
        return f"Archivo no encontrado: {path}"

    # Extraer datos con regex
    try:
        completadas = int(re.search(r"Complete requests:\s+(\d+)", texto).group(1))
        fallidas = int(re.search(r"Failed requests:\s+(\d+)", texto).group(1))
        tiempo_medio = float(re.search(r"Time per request:\s+([\d\.]+) \[ms\] \(mean\)", texto).group(1))
    except:
        return "Error analizando el contenido del archivo. Verifique que sea la salida de ApacheBench."

    # Mostrar resumen
    print("Análisis del test:\n")
    print(f"  - Peticiones completadas: {completadas}")
    print(f"  - Peticiones fallidas:    {fallidas}")
    print(f"  - Tiempo medio por req.:  {tiempo_medio} ms\n")

    # Veredicto
    if fallidas > MAX_FAILED_REQUESTS:
        return "Test fallido: hubo peticiones con error."
    elif tiempo_medio > MAX_TIME_PER_REQUEST_MS:
        return f"Test aceptable pero lento ({tiempo_medio:.2f} ms por petición)."
    else:
        return "Test aprobado: servicio rápido y sin errores."

# Ejecutar análisis
veredicto = analizar_ab(archivo_salida)
print(veredicto)