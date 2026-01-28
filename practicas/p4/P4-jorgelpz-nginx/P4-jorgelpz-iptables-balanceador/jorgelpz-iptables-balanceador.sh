#!/bin/bash
#"denegando implicitamente todo el trafico"
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

#"manejando el trafico de red de la propia maquina consigo misma"
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -o lo -j ACCEPT

#"manejando el trafico de red entrante basado en el estado de las conexiones"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#"bloqueando escaneos de puertos comunes"
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP # NULL scan
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP # Xmas scan
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j DROP # FIN scan
iptables -A INPUT -p tcp --tcp-flags ALL ACK -j DROP # ACK scan

#"bloqueando combinaciones anómalas que no parecen conexiones reales"
iptables -A INPUT -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP

#"Detectar y bloquear paquetes fragmentados"
iptables -A INPUT -f -j DROP

###"si pertenece a la lista de las que han abusado bloqueara cualquier intento de crear nuevas conexiones"
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --rcheck --name lista_ips_ddos -j REJECT
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --rcheck --name lista_ips_ddos -j REJECT

#"limitando el numero de conexiones simultaneas por IP a 3"
iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 --connlimit-mask 32 --connlimit-saddr -j REJECT
iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 3 --connlimit-mask 32 --connlimit-saddr -j REJECT

#"limitando la tasa de conexiones nuevas por IP a 5 por segundo"
iptables -A INPUT -p tcp --syn -m limit --limit 5/sec -j ACCEPT
iptables -A INPUT -p tcp --syn -j REJECT

##"rechazara las ips que traten de hacer mas de 10 peticiones por segundo"
iptables -A INPUT -p tcp --dport 80 -m hashlimit --hashlimit-above 10/sec --hashlimit-mode srcip -j REJECT
iptables -A INPUT -p tcp --dport 443 -m hashlimit --hashlimit-above 10/sec --hashlimit-mode srcip -j REJECT

###"comprueba si la conexión es abusiva y la añade a la lista negra. En cualquier otro caso sigue como si nada"
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --seconds 5 --hitcount 10 --name lista_ips_ddos --set -j REJECT
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --seconds 5 --hitcount 10 --name lista_ips_ddos --set -j REJECT

iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
