#!/bin/sh

urpmi   --auto $1 $2 \
        postgresql8.3-server \
        postgresql8.3 \
        python-psycopg2 \
        memcached \
        subversion \
        subversion-tools \
        patch \
        socat \
        nagios-check_nrpe \
        nagios-check_ntp \
        net-snmp \
        nrpe \
        vigilo-nagios-plugins-cpu \
        vigilo-nagios-plugins-raid \
        ejabberd \
        apache-mpm-prefork \
        glibc-devel
# apache-mpm-prefork : pour eviter un choix interactif après
# glibc-devel : pour eviter un choix interactif après



