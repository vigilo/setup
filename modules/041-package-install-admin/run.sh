#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur d'administration Centrale"
urpmi   $RPM_SIGNATURE_CHECK $AUTO_INSTALL \
        vigilo-connector-vigiboard \
        vigilo-correlator \
        vigilo-vigiboard \
        vigilo-vigiconf \
        vigilo-vigimap \
        vigilo-vigigraph \
        vigilo-vigiconf-local
