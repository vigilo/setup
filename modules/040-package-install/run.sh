#!/bin/sh

echo "Installation des paquets Vigilo"
pkgs="
vigilo-collector
vigilo-collector-enterprise
vigilo-connector-nagios
vigilo-connector-metro
vigilo-connector-metro-vigiconf
vigilo-connector-diode
vigilo-connector-syncevents
vigilo-correlator
vigilo-perfdata2vigilo
vigilo-vigiboard
vigilo-vigiconf
vigilo-vigiconf-local
vigilo-vigimap
vigilo-vigigraph
vigilo-vigirrd
vigilo-vigirrd-vigiconf
"

rpm -q mod_python &> /dev/null
if [ "$?" == "0" ] ; then
    echo "Conflit détecté: mod_python est installé (incompatible avec mod_wsgi)"
    exit 1
fi

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
