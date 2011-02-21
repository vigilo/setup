#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de stockage des données de métrologie"
pkgs="
vigilo-connector-metro
vigilo-connector-metro-vigiconf
vigilo-vigirrd
vigilo-vigirrd-vigiconf
vigilo-vigiconf-local
"

rpm -q mod_python &> /dev/null
if [ "$?" == "0" ] ; then
    echo "Conflit détecté: mod_python est installé (incompatible avec mod_wsgi)"
    exit 1
fi

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
