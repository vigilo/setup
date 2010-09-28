#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de stockage des données de métrologie"
urpmi   --auto $1 $2 \
        vigilo-connector-metro \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf \
        vigilo-vigiconf-local
