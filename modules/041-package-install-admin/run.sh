#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur d'administration Centrale"
pkgs="
vigilo-correlator
vigilo-perfdata2vigilo
vigilo-vigiboard
vigilo-vigiconf
vigilo-vigiconf-local
vigilo-vigimap
vigilo-vigigraph
"

$PKG_INSTALLER `echo $pkgs | tr '\n' ' '`
