#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de collecte"
pkgs="
vigilo-collector
vigilo-collector-enterprise
vigilo-connector-nagios
vigilo-perfdata2vigilo
vigilo-vigiconf-local
"

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
