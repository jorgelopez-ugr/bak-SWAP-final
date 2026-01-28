#!/bin/bash

#script para control de acceso entre las redes red_web y red_servicios

#Limpio las que haya para evitar que se repitan
sudo iptables -F DOCKER-USER
echo "Se han limpiado las reglas actuales"

# imaginemos que sospechamos de una brecha de seguridad en el contenedor 8
# va a descartar todo el tráfico que entre o salga.
# aunque es un ejemplo básico, escalar este control de red
# mediante el uso de scripts y reglas más complejas sería
# relativamente sencillo.
sudo iptables -I DOCKER-USER -s 192.168.10.9 -j DROP
sudo iptables -I DOCKER-USER -s 192.168.20.9 -j DROP
sudo iptables -I DOCKER-USER -d 192.168.10.9 -j DROP
sudo iptables -I DOCKER-USER -d 192.168.20.9 -j DROP

# Mostramos las reglas que acabamos de añadir
sudo iptables -L DOCKER-USER -v -n