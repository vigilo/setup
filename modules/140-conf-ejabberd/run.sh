#!/bin/sh

if [ -f /etc/ejabberd/ejabberd.cfg.orig ]; then
    echo "Patch /etc/ejabberd/ejabberd.cfg"
    patch -N -b /etc/ejabberd/ejabberd.cfg < ejabberd.cfg.patch
    chown root:ejabberd /etc/ejabberd/ejabberd.cfg
fi
