echo "llamando al script de creación de imágenes"

if [[ "$(docker images -q jorgelpz-apache-image:p4 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-apache-image:p4 -f ./P4-jorgelpz-apache/DockerFileApacheP4 .
fi

if [[ "$(docker images -q jorgelpz-nginx-image:p4 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-nginx-image:p4 -f ./P4-jorgelpz-nginx/DockerFileNginxP4 .
fi
