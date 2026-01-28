FROM python:3.12

WORKDIR /app

# Solo necesitas copiar el script y analizadores
COPY analizadores/ /analizadores
COPY parse_all_logs.py .

CMD ["python3", "parse_all_logs.py"]