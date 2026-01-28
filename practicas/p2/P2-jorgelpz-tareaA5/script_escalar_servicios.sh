
CONF="nginx.conf" #tomamos el archivo nginx.conf que haya en ese momento

#formamos un vector con los contenedores activos en ese instante
declare -a NOMBRE_CONTENEDORES_ACTIVOS=()
mapfile -t NOMBRE_CONTENEDORES_ACTIVOS < <(docker ps --format "{{.Names}}" -f "name=web[1-8]$")

#comenzamos a crear desde cero nuestro archivo nuevo nginx.conf
#primeramente colocamos los parámetros que no cambian
cat > $CONF <<EOF
# nginx.conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    upstream backend_jorgelpz {
EOF
#completamos con los contenedores activos que obtuvimos antes
for id_activos in "${NOMBRE_CONTENEDORES_ACTIVOS[@]}"; do
    echo "        server ${id_activos};" >> $CONF
done
#continuamos rellenando con las configuraciones faltantes
cat >> $CONF <<EOF
    }
    server {
        listen 80;
        server_name nginx_jorgelpz;
        access_log /var/log/nginx/nginx_jorgelpz.access.log;
        error_log /var/log/nginx/nginx_jorgelpz.error.log;

        location / {
            proxy_pass http://backend_jorgelpz;
        }

        location /estadisticas_jorgelpz {
            stub_status on;
        }
    }
}
EOF
#sustituimos este nuevo archivo en su destino, cargandonos el anterior
cp $CONF ./nginx.conf
#sustituimos este nuevo archivo en el contenedor balanceador-nginx
docker cp $CONF balanceador-nginx:/etc/nginx/nginx.conf
#recargamos el balanceador
docker exec balanceador-nginx nginx -s reload
#mostramos un mensaje de confirmación
echo "Balanceador de carga reiniciado con la nueva configuración."

#esta comprobado que este script funciona