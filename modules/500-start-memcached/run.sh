#!/bin/sh

# Démarrage par supervisor
cp -a memcached.ini /etc/supervisord.d/
chkconfig memcached off
chkconfig supervisord on
service supervisord status >/dev/null 2>&1 || service supervisord start

