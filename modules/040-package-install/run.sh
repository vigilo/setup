#!/bin/sh

echo "Installation des paquets Vigilo"
pkgs="
vigilo-collector
vigilo-collector-enterprise
vigilo-connector-nagios
vigilo-connector-metro
vigilo-connector-metro-vigiconf
vigilo-connector-diode
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

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
