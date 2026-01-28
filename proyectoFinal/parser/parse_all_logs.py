import os
import subprocess

LOGS_DIR = "../logs"
RESULTS_DIR = "../resultados"

ANALIZADORES = {
    "capacidad/wrk": "analizar_wrk.py",
    "capacidad/siege": "analizar_siege.py",
    "smoke": "analizar_smoke.py",
    "estres": "analizar_estres.py",
    "sobrecarga": "analizar_sobrecarga.py",
}

def detectar_tipo(path_relativo):
    path_relativo = path_relativo.replace("\\", "/")  # Por compatibilidad Windows/Linux
    for clave in ANALIZADORES:
        if clave in path_relativo:
            return clave
    return None

def analizar_logs():
    for carpeta_raiz, _, archivos in os.walk(LOGS_DIR):
        for archivo in archivos:
            if archivo.endswith((".log", ".txt", ".json")):
                ruta_log = os.path.join(carpeta_raiz, archivo)
                path_relativo = os.path.relpath(ruta_log, LOGS_DIR)

                tipo = detectar_tipo(path_relativo)
                if tipo is None:
                    print(f"[Ignorado] No se reconoce el tipo de test para {ruta_log}")
                    continue

                script = ANALIZADORES[tipo]
                ruta_resultado = carpeta_raiz.replace(LOGS_DIR, RESULTS_DIR)
                os.makedirs(ruta_resultado, exist_ok=True)
                archivo_salida = os.path.join(ruta_resultado, archivo.replace(".log", ".txt").replace(".json", ".txt"))

                print(f"Procesando {ruta_log} con {script}...")
                try:
                    resultado = subprocess.check_output(["python3", f"/analizadores/{script}", ruta_log], stderr=subprocess.STDOUT)
                    with open(archivo_salida, "wb") as f:
                        f.write(resultado)
                except subprocess.CalledProcessError as e:
                    print(f"[Error] Al analizar {archivo}: {e.output.decode()}")

if __name__ == "__main__":
    analizar_logs()