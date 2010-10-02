#!/bin/sh

pkglist=$DISTRO.pkgs

if [ ! -f $pkglist ]; then
    echo "Can't find the list of packages to install for your distribution ($DISTRO)"
    exit 1
fi

pkgs=`grep -v '^[[:space:]]*#' $pkglist | grep -v '^[[:space:]]*$'`
$PKG_INSTALLER $pkgs
