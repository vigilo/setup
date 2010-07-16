#!/bin/sh

svnurl=${VIGIBOARD_SVN:-file:///var/lib/svn/vigiconf}

echo "Configuration de VigiConf"

if [ ! -d /etc/vigilo/vigiconf/conf.d ]; then
    echo "Vigiconf n'est pas installé, on passe à la suite..."
    exit 0
fi

if [ -d /etc/vigilo/vigiconf/conf.d/.svn ]; then
    echo "Le répertoire de configuration de Vigiconf est déjà sous SVN, on passe à la suite..."
    exit 0
fi

[ -d /etc/vigilo/vigiconf/conf.d/hosts/localhost.xml ] || \
    cp -p localhost.xml /etc/vigilo/vigiconf/conf.d/hosts/

if [[ "$svnurl" =~ ^file:// ]]; then
    if ! which svnadmin >/dev/null 2>&1; then
        echo "Impossible de trouver svnadmin ! Abandon."
        exit 1
    fi
    dir=`echo $svnurl | sed -e s,file://,,g`
    if [ ! -d $dir ]; then
        mkdir -p $dir
        svnadmin create $dir
        chown vigiconf:vigiconf -R $dir
    fi
fi

pushd /etc/vigilo/vigiconf/conf.d.example
svn import . $svnurl -m "Initial import"
cd ..
svn co $svnurl conf.d
svn propset svn:keywords Rev conf.d/general/apps.py
chown vigiconf:vigiconf -R conf.d
popd

# sudo
grep -qs ^vigiconf /etc/sudoers || echo 'vigiconf ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# serveur de supervision
sed -i -e 's/supserver.example.com/localhost/' /etc/vigilo/vigiconf/conf.d/general/appgroups-servers.py

# settings.ini
if [ ! -f /etc/vigilo/vigiconf/conf.d/settings.ini.orig ]; then
    cwd=`pwd`
    pushd /etc/vigilo/vigiconf
    patch -b -p4 -N < $cwd/vigiconf.patch || :
    popd
fi

# permissions
chown vigiconf: -R /etc/vigilo/vigiconf/conf.d /etc/vigilo/vigiconf/settings.ini

