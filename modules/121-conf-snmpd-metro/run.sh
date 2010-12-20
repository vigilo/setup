#!/bin/sh

echo "Configuration de l'extension SNMPd pour la métrologie"

grep -qs "^pass_persist .*/vigilo-snmpd-metro" /etc/snmp/snmpd.conf || \
    echo "pass_persist .1.3.6.1.4.1.14132 $PYTHON -u /usr/bin/vigilo-snmpd-metro" \
    >> /etc/snmp/snmpd.conf
