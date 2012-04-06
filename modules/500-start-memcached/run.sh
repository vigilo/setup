#!/bin/sh
# Copyright (C) 2011-2012 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Démarrage par supervisor
cp -a memcached.ini /etc/supervisord.d/
chkconfig memcached off
chkconfig supervisord on
service supervisord status >/dev/null 2>&1 || service supervisord start

