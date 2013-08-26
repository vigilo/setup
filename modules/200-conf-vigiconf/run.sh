# Copyright (C) 2006-2013 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

svnurl=${VIGICONF_SVN:-file:///var/lib/svn/vigiconf}

echo "Configuration de VigiConf"

if [ ! -d /etc/vigilo/vigiconf/conf.d ]; then
    echo "Vigiconf n'est pas installé, on passe à la suite..."
    exit 0
fi

[ -f /etc/vigilo/vigiconf/conf.d.example/hosts/localhost.xml ] || \
    cp -p localhost.xml /etc/vigilo/vigiconf/conf.d.example/hosts/

# SVN
if [ -d /etc/vigilo/vigiconf/conf.d/.svn ]; then
    echo "Le répertoire de configuration de Vigiconf est déjà sous SVN, on passe à la suite..."
    exit 0
fi

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
su -c 'svn import . $svnurl -m "Initial import"' vigiconf
cd ..
svn co $svnurl conf.d
svn propset svn:keywords Rev conf.d/general/apps.py
svn propset svn:ignore "*.pyc\n*.pyo\n" conf.d/general
chown vigiconf:vigiconf -R conf.d
popd

# settings.ini
if [ ! -f /etc/vigilo/vigiconf/settings.ini.orig ]; then
    cp  /etc/vigilo/vigiconf/settings.ini /etc/vigilo/vigiconf/settings.ini.orig
    sed -i -e 's,^\(svnrepository[[:space:]]*=[[:space:]]*\).*,\1'$svnurl',' \
        /etc/vigilo/vigiconf/settings.ini
fi

# permissions
chown vigiconf: /etc/vigilo/vigiconf/conf.d /etc/vigilo/vigiconf/settings.ini
