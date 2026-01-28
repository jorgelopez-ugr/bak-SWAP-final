#!/bin/bash

# La idea es borrar los logs del contenedor.
#con ayuda de crontab hacer que esto se ejecute cada 24 horas.

rm /var/log/apache2/error.log

echo "Limpieza de logs rutinaria completada el $(date '+%Y-%m-%d %H:%M:%S')" >> /var/log/logs_del_script_de_limpieza.log