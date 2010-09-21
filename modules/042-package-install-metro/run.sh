#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de stockage des données de métrologie"
urpmi   vigilo-connector-metro \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf
