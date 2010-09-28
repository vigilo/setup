#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de stockage des données de métrologie"
urpmi   $RPM_SIGNATURE_CHECK $AUTO_INSTALL \
        vigilo-connector-metro \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf \
        vigilo-vigiconf-local
