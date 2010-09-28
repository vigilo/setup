#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur d'administration Centrale"
urpmi   --auto $1 $2 \
        vigilo-connector-vigiboard \
        vigilo-correlator \
        vigilo-vigiboard \
        vigilo-vigiconf \
        vigilo-vigimap \
        vigilo-vigigraph \
        vigilo-vigiconf-local
