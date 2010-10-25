#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de stockage des données de métrologie"
pkgs="
vigilo-connector-metro
vigilo-connector-metro-vigiconf
vigilo-vigirrd
vigilo-vigirrd-vigiconf
vigilo-vigiconf-local
vigilo-nagios-plugins-rrd
"

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
