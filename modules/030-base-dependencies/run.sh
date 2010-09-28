#!/bin/sh

urpmi   --auto $1 $2 \
        postgresql8.3-server \
        postgresql8.3 \
        python-psycopg2 \
        nagios \
        nagios-www \
        memcached \
        subversion \
        subversion-tools \
        patch \
        nagios-check_nrpe \
        nagios-check_ntp \
        socat \
        net-snmp \
        nrpe \
        vigilo-nagios-plugins-cpu \
        vigilo-nagios-plugins-raid \
        ejabberd \
        glibc-devel
# glibc-devel : pour eviter un choix interactif après


