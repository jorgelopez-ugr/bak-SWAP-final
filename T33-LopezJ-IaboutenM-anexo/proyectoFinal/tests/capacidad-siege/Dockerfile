FROM ubuntu:latest

# Instala siege
RUN apt-get update && apt-get install -y siege

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
