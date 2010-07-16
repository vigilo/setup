#!/bin/sh

echo "Configuration de Nagios"

[ -f /etc/nagios/nagios.cfg.orig ] || patch -N -b /etc/nagios/nagios.cfg < nagios.patch
if [ ! -f /etc/nagios/nagios-test.cfg ]; then
    cp -f /etc/nagios/nagios.cfg /etc/nagios/nagios-test.cfg
    patch -N -b /etc/nagios/nagios-test.cfg < nagios-test.patch
fi
[ -f /etc/nagios/vigilo.cfg ] || cp nagios-vigilo.cfg /etc/nagios/vigilo.cfg

