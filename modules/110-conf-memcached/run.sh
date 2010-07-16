#!/bin/sh

echo "Configuration de memcached"
[ -f /etc/sysconfig/memcached.orig ] || patch -N -b /etc/sysconfig/memcached < memcached.patch

