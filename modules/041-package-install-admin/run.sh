#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur d'administration Centrale"
pkgs="
vigilo-correlator
vigilo-correlator-enterprise
vigilo-perfdata2vigilo
vigilo-vigiboard
vigilo-vigiconf
vigilo-vigiconf-enterprise
vigilo-vigiconf-local
vigilo-connector-syncevents
vigilo-vigimap
vigilo-vigigraph
vigilo-vigigraph-enterprise
vigilo-vigiadmin
"
rpm -q mod_python &> /dev/null
if [ "$?" == "0" ] ; then
    echo "Conflit détecté: mod_python est installé (incompatible avec mod_wsgi)"
    exit 1
fi

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
