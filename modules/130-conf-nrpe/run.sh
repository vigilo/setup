#!/bin/sh

echo "Configuration de NRPE"
sed -i -e 's/^dont_blame_nrpe=0/dont_blame_nrpe=1/' /etc/nagios/nrpe.cfg

grep -qs "include_dir=/etc/nrpe.d" /etc/nagios/nrpe.cfg || \
    echo "include_dir=/etc/nrpe.d/" >> /etc/nagios/nrpe.cfg

