#!/bin/sh

echo "Configuration de SNMPd"

cfgpatch=snmpd.$DISTRO.patch

[ -f /etc/snmp/snmpd.conf.orig ] || patch -N -b /etc/snmp/snmpd.conf < $cfgpatch

