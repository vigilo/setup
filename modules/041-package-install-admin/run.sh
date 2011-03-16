#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur d'administration Centrale"
pkgs="
vigilo-correlator
vigilo-perfdata2vigilo
vigilo-vigiboard
vigilo-vigiconf
vigilo-vigiconf-local
vigilo-connector-syncevents
vigilo-vigimap
vigilo-vigigraph
vigilo-vigiadmin
vigilo-repoze.who.plugins.vigilo.kerberos
"
rpm -q mod_python &> /dev/null
if [ "$?" == "0" ] ; then
    echo "Conflit détecté: mod_python est installé (incompatible avec mod_wsgi)"
    exit 1
fi

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
