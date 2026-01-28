import re
import sys

MAX_LATENCIA_MS = 300  # Umbral máximo aceptable de latencia promedio

if len(sys.argv) != 2:
    print("Uso: python3 analizar_estres.py <archivo.log>")
    sys.exit(1)

archivo = sys.argv[1]

def analizar_estres(path):
    try:
        with open(path, "r") as f:
            texto = f.read()
    except Exception as e:
        return f"No se pudo leer el archivo: {e}"

    try:
        total_reqs = int(re.search(r"http_reqs.*?:\s+(\d+)", texto).group(1))

        # Solo extraer el número de iteraciones completas
        iteraciones = int(re.search(r"(\d+)\s+complete and\s+\d+\s+interrupted iterations", texto).group(1))

        # Latencia media
        match_latencia = re.search(r"http_req_duration.*?avg=([\d\.]+)(ms|s|µs)", texto)
        if match_latencia:
            valor = float(match_latencia.group(1))
            unidad = match_latencia.group(2)
            if unidad == "s":
                latencia_ms = valor * 1000
            elif unidad == "µs":
                latencia_ms = valor / 1000
            else:
                latencia_ms = valor
        else:
            latencia_ms = None

        errores = re.search(r"http_req_failed.*?([\d\.]+)%", texto)
        porcentaje_fallos = float(errores.group(1)) if errores else 0.0

    except Exception as e:
        return f"Error interpretando la salida de K6: {e}"

    print("Análisis del test de estrés con K6:\n")
    print(f"  - Peticiones totales:         {total_reqs}")
    print(f"  - Iteraciones completadas:   {iteraciones}")
    print(f"  - Porcentaje de fallos:      {porcentaje_fallos:.2f} %")
    if latencia_ms is not None:
        print(f"  - Latencia media:             {latencia_ms:.2f} ms\n")
    else:
        print("  - Latencia media no detectada.\n")

    if porcentaje_fallos > 0.0:
        return "Test fallido: hubo errores en las peticiones."
    elif latencia_ms and latencia_ms > MAX_LATENCIA_MS:
        return f"Test aceptable pero con alta latencia: {latencia_ms:.2f} ms."
    else:
        return "Test exitoso: sin errores y buena latencia."

# Ejecutar análisis
print(analizar_estres(archivo))