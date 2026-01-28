import json
import sys

# Umbrales para evaluar
MAX_FAILED = 0
MAX_RESPONSE_TIME = 0.150  # en segundos
MIN_AVAILABILITY = 99.0    # en %

# Verificación de argumentos
if len(sys.argv) != 2:
    print("Uso: python3 analizar_siege.py <archivo.log>")
    sys.exit(1)

archivo = sys.argv[1]

def analizar_siege(path):
    try:
        with open(path, "r") as f:
            contenido = f.read()

        # Buscar el JSON dentro del texto
        inicio = contenido.find("{")
        fin = contenido.rfind("}") + 1
        bloque_json = contenido[inicio:fin]
        datos = json.loads(bloque_json)

    except Exception as e:
        return f"Error leyendo o interpretando el archivo: {e}"

    # Extraer métricas
    total = datos.get("transactions", 0)
    failed = datos.get("failed_transactions", 0)
    availability = datos.get("availability", 0.0)
    response = datos.get("response_time", 0.0)

    # Mostrar resumen
    print("Análisis de la prueba con Siege:\n")
    print(f"  - Transacciones totales:       {total}")
    print(f"  - Transacciones fallidas:      {failed}")
    print(f"  - Tiempo medio de respuesta:   {response:.3f} s")
    print(f"  - Disponibilidad:              {availability:.2f} %\n")

    # Evaluación
    if failed > MAX_FAILED:
        return "Test fallido: hay transacciones con error."
    elif availability < MIN_AVAILABILITY:
        return f"Baja disponibilidad ({availability:.2f}%)."
    elif response > MAX_RESPONSE_TIME:
        return f"Test aceptable pero lento (respuesta media: {response:.3f} s)."
    else:
        return "Test aprobado: servicio disponible, rápido y sin errores."

# Ejecutar
veredicto = analizar_siege(archivo)
print(veredicto)