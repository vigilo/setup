#!/bin/sh

urpmi   postgresql8.3-server \
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
        ejabberd \
        apache-mpm-prefork \
        glibc-devel
# apache-mpm-prefork : pour eviter un choix interactif après
# glibc-devel : pour eviter un choix interactif après


# Besoin de sqlalchemy >= 0.5
rpm -Uvh $VIGILO_DEPS_REPO/python-sqlalchemy-0.5.6-1mdvmes2009.0.noarch.rpm || :

