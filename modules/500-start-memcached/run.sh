#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Démarrage par supervisor
cp -a memcached.ini /etc/supervisord.d/
chkconfig memcached off
# démarrage
service=supervisord
chkconfig $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service start || exit $?
fi
