#!/bin/sh

echo "Configuration de memcached"

cfgpatch=memcached.$DISTRO.patch

[ -f /etc/sysconfig/memcached.orig ] || patch -N -b /etc/sysconfig/memcached < $cfgpatch

# Démarrage par supervisor
cp -a memcached.ini /etc/supervisord.d/
