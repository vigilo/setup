#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de collecte"
urpmi   vigilo-collector \
        vigilo-collector-enterprise \
        vigilo-connector-nagios \
        vigilo-perfdata2vigilo \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf \
        vigilo-vigiconf-local

