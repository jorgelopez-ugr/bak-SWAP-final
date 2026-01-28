echo "Limpieza de contenedores"
# Este script limpia los contenedores Docker que se están ejecutando.
for container in web1 web2 web3 web4 web5 web6 web7 web8; do
    if [[ "$(docker ps -a -q -f name=$container)" ]]; then
        docker stop $container
        docker rm $container
    fi
done

if [[ "$(docker ps -a -q -f name=balanceador-nginx-ssl)" ]]; then
    docker stop balanceador-nginx-ssl
    docker rm balanceador-nginx-ssl
fi