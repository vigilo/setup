#!/bin/sh

echo "Configuration de SNMPd"
[ -f /etc/snmp/snmpd.conf.orig ] || patch -N -b /etc/snmp/snmpd.conf < snmpd.patch

