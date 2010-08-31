#!/bin/sh

echo "Patch /etc/ejabberd/ejabberd.cfg"
[ -f /etc/ejabberd/ejabberd.cfg.orig ] || patch -N -b /etc/ejabberd/ejabberd.cfg < ejabberd.cfg.patch
