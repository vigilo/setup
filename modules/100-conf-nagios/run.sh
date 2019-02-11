# Copyright (C) 2006-2019 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Configuration de Nagios"

cfgpatch=nagios.$DISTRO.patch;
if [ -f "nagios.$DIST_TAG.patch" ]; then cfgpatch=nagios.$DIST_TAG.patch; fi

[ -f /etc/nagios/nagios.cfg.orig ] || patch -N -b /etc/nagios/nagios.cfg < $cfgpatch

if [ "$DISTRO" == "redhat" ]; then
    # Sur RedHat, les permissions du fichier de commandes externes ne permettent pas aux CGIs d'y écrire
    usermod -G nagios apache
fi

# Si la machine VigiConf a aussi un Nagios installé, il faut l'ajouter au
# groupe vigiconf pour qu'il puisse valider la configuration (qui se trouve
# dans /var/lib/vigiconf, accessible uniquement au groupe vigiconf.
getent group vigiconf > /dev/null && usermod -a -G vigiconf nagios || exit $?

if [ -f /etc/httpd/conf.d/nagios.conf ] && \
            grep -qs "deny from all" /etc/httpd/conf.d/nagios.conf; then
    sed -i -e "/^\s*deny from all/d" /etc/httpd/conf.d/nagios.conf
    service httpd reload
fi

if [ "$DISTRO" == "redhat" -a -f /usr/share/nagios/html/index.php ]; then
    install_pkg php
fi

if [ ! -f /etc/nagios/passwd.plaintext ]; then
    passwd=`dd if=/dev/urandom | tr -dc A-Za-z0-9 | head -c8`
    touch /etc/nagios/passwd.plaintext
    chmod 600 /etc/nagios/passwd.plaintext
    echo $passwd > /etc/nagios/passwd.plaintext
    htpasswd -c -b /etc/nagios/passwd nagios $passwd
    chmod 644 /etc/nagios/passwd
    sed -i -e "s/nagiosadmin/nagios/g" /etc/nagios/cgi.cfg
    # permet d'avoir des accents dans les messages de plugin
    sed -i -e "s/escape_html_tags=1/escape_html_tags=0/g" /etc/nagios/cgi.cfg
fi

# Optimisation: mettre le répertoire des résultats de Nagios en RAM
if [ "$DISTRO" == "redhat" ]; then
    crdir=/var/log/nagios/spool/checkresults
elif [ "$DISTRO" == "debian" ]; then
    crdir=/var/lib/nagios3/spool/checkresults
else
    crdir=/var/spool/nagios/checkresults
fi
if ! grep -qs $crdir /etc/fstab; then
    echo "tmpfs    $crdir    tmpfs   defaults    0 0" >> /etc/fstab
    mount $crdir
fi

# Lancement au boot
change_svc nagios on
