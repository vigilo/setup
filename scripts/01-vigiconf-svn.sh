#!/bin/bash

# See /etc/vigilo-vigiconf/conf.d/README.source for details

svnurl=${VIGIBOARD_SVN:-file:///var/lib/svn/vigiconf}

if [[ "$svnurl" =~ ^file:// ]]; then
    if ! which svnadmin >/dev/null 2>&1; then
        echo "Can't find svnadmin ! Abort."
        exit 1
    fi
    dir=`echo $svnurl | sed -e s,file://,,g`
    mkdir -p $dir
    svnadmin create $dir
    chown vigiconf:vigiconf -R $dir
fi

cd /etc/vigilo-vigiconf
svn import -m "Initial import" conf.d.example $svnurl/conf.d
rm -rf conf.d
svn checkout $svnurl/conf.d
chown vigiconf:vigiconf -R conf.d
svn propset svn:keywords Rev conf.d/general/apps.py

