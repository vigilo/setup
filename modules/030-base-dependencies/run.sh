#!/bin/sh

pkglist=$DISTRO-$DIST_VER.pkgs

if [ ! -f $pkglist ]; then
    pkglist=$DISTRO.pkgs

    if [ ! -f $pkglist ]; then
        echo "Can't find the list of packages to install for your distribution ($DISTRO)"
        exit 1
    fi
fi

pkgs=`grep -v '^[[:space:]]*#' $pkglist | grep -v '^[[:space:]]*$'`
$PKG_INSTALLER $pkgs
