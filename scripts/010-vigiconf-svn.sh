#!/bin/bash

# See /etc/vigilo-vigiconf/conf.d/README.source for details

svnurl=${VIGIBOARD_SVN:-file:///var/lib/svn/vigiconf}

if [ ! -d /etc/vigilo-vigiconf/conf.d ]; then
    echo "Vigiconf not installed, skipping..."
    exit 0
fi

if [ -d /etc/vigilo-vigiconf/conf.d/.svn ]; then
    echo "Vigiconf config directory is already in SVN, skipping..."
    exit 0
fi

if [[ "$svnurl" =~ ^file:// ]]; then
    if ! which svnadmin >/dev/null 2>&1; then
        echo "Can't find svnadmin ! Abort."
        exit 1
    fi
    dir=`echo $svnurl | sed -e s,file://,,g`
    if [ ! -d $dir ]; then
        mkdir -p $dir
        svnadmin create $dir
        chown vigiconf:vigiconf -R $dir
    fi
fi

cd /etc/vigilo-vigiconf
if ! svn ls $svnurl/conf.d &> /dev/null; then
    svn import -m "Initial import" conf.d.example $svnurl/conf.d
fi
rm -rf conf.d
svn checkout $svnurl/conf.d
chown vigiconf:vigiconf -R conf.d
svn propset svn:keywords Rev conf.d/general/apps.py

