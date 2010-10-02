#!/bin/sh

if [ ! -f /etc/ejabberd/ejabberd.cfg.orig ]; then
    echo "Patch /etc/ejabberd/ejabberd.cfg"
    cfgpatch=ejabberd.$DISTRO.patch
    patch -N -b /etc/ejabberd/ejabberd.cfg < $cfgpatch
    chown root:ejabberd /etc/ejabberd/ejabberd.cfg
fi
