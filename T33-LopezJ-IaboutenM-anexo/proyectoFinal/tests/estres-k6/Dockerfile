FROM grafana/k6:latest

USER root

COPY estres.js ./
COPY entrypoint.sh ./

RUN chmod +x entrypoint.sh

USER 65532

ENTRYPOINT ["./entrypoint.sh"]
