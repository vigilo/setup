#!/bin/sh

urpmi   postgresql8.3-server \
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
        ejabberd \
        glibc-devel
# glibc-devel : pour eviter un choix interactif après


# Besoin de sqlalchemy >= 0.5
rpm -Uvh $VIGILO_DEPS_REPO/python-sqlalchemy-0.5.6-1mdvmes2009.0.noarch.rpm || :
# Besoin de python-webob < 0.9.8 pour rum
rpm -Uvh --oldpackage $VIGILO_DEPS_REPO/python-webob-0.9.6.1-1mdvmes2009.0.noarch.rpm \
                      $VIGILO_DEPS_REPO/python-repoze.what-quickstart-1.0-1mdvmes2009.0.noarch.rpm \
                      $VIGILO_DEPS_REPO/python-repoze.who-friendlyform-1.0-b3mdvmes2009.0.noarch.rpm ||:

