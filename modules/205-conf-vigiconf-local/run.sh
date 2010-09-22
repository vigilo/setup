#!/bin/sh

echo "Configuration de VigiConf-local"

# sudo
if ! grep -qs ^vigiconf /etc/sudoers; then
    echo '# VigiConf' >> /etc/sudoers
    echo 'Cmnd_Alias INIT = /etc/init.d/*' >> /etc/sudoers
    echo 'Cmnd_Alias VALID = /usr/sbin/nagios' >> /etc/sudoers
    echo 'Cmnd_Alias TRAP = /usr/sbin/snmptrapd' >> /etc/sudoers
    echo 'vigiconf ALL=(ALL) NOPASSWD: INIT, VALID, TRAP' >> /etc/sudoers
fi

# configuration de vigiconf pour un serveur de collecte seul

[ -e /var/lib/vigilo/vigiconf/.ssh/authorized_keys ] || ( \
echo "la Clef ssh vigiconf du serveur d'amdinistration Centrale n'a pas encore été importée, vous devriez réaliser cette opération manuelle maintenant.
Emplacement de la clef /var/lib/vigilo/vigiconf/.ssh/authorized_keys" | fmt
echo "Appuyer sur ENTREZ pour continuer, ou Faite Ctrl-C pour arrêter le script" | fmt
read )
chown vigiconf:vigiconf -R /var/lib/vigilo/vigiconf/


