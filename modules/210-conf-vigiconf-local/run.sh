# Copyright (C) 2006-2020 CS GROUP – France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

echo "Configuration de VigiConf-local"

# sudo
if ! grep -qs ^vigiconf /etc/sudoers; then
    echo '# VigiConf' >> /etc/sudoers
    echo 'Defaults:vigiconf !requiretty' >> /etc/sudoers
    echo 'Cmnd_Alias SVC_MGMT = /etc/init.d/*, /sbin/service, /usr/bin/systemctl' >> /etc/sudoers
    echo 'Cmnd_Alias VALID = /usr/sbin/nagios, /usr/sbin/nagios3' >> /etc/sudoers
    echo 'vigiconf ALL=(ALL) NOPASSWD: SVC_MGMT, VALID' >> /etc/sudoers
    echo 'vigiconf ALL=(nagios) NOPASSWD: /usr/bin/pkill' >> /etc/sudoers
fi
