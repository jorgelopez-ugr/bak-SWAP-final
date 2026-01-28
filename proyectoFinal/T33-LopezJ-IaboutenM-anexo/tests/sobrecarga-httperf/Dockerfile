FROM debian:latest

# Instala httperf
RUN apt-get update
RUN apt-get install -y httperf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
