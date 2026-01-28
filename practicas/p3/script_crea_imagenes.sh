echo "llamando al script de creación de imágenes"

if [[ "$(docker images -q jorgelpz-apache-image:p3 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-apache-image:p3 -f ./P3-jorgelpz-apache/DockerFileApacheP3 .
fi

if [[ "$(docker images -q jorgelpz-nginx-image:p3 2> /dev/null)" == "" ]]; then
    docker build -t jorgelpz-nginx-image:p3 -f ./P3-jorgelpz-nginx/DockerFileNginxP3 .
fi
