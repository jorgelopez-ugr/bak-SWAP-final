#!/bin/bash

# Script: entrypoint.sh
./jorgelpz-iptables-balanceador.sh
exec "$@"