echo "llamando al script de creación de imágenes"

# Este script crea las imágenes Docker necesarias para el proyecto.
# Si ya existe procede a eliminarla y volverla a crear.

if [[ "$(docker images -q jorgelpz-apache-image:p2 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-apache-image:p2 -f DockerfileApache_jorgelpz .
fi

if [[ "$(docker images -q jorgelpz-nginx-image:p2 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-nginx-image:p2 -f P2-jorgelpz-nginx/DockerfileNginx_jorgelpz ./P2-jorgelpz-nginx
fi
if [[ "$(docker images -q jorgelpz-haproxy-image:p2 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-haproxy-image:p2 -f P2-jorgelpz-haproxy/DockerfileHAproxy_jorgelpz ./P2-jorgelpz-haproxy
fi

if [[ "$(docker images -q jorgelpz-traefik-image:p2 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-traefik-image:p2 -f P2-jorgelpz-traefik/DockerfileTraefik_jorgelpz ./P2-jorgelpz-traefik
fi
