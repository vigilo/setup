#!/bin/sh

echo "Configuration de VigiConf-local"

# sudo
if ! grep -qs ^vigiconf /etc/sudoers; then
    echo '# VigiConf' >> /etc/sudoers
    echo 'Defaults:vigiconf !requiretty' >> /etc/sudoers
    echo 'Cmnd_Alias INIT = /etc/init.d/*' >> /etc/sudoers
    echo 'Cmnd_Alias VALID = /usr/sbin/nagios' >> /etc/sudoers
    echo 'vigiconf ALL=(ALL) NOPASSWD: INIT, VALID' >> /etc/sudoers
fi

# configuration de vigiconf pour un serveur recevant la configuration depuis l'exterieur
rpm -qa --queryformat "%{name}\n" | grep -q '^vigilo-vigiconf$'
if [ "$?" != "0" ] ; then
    if [ ! -s /var/lib/vigilo/vigiconf/.ssh/authorized_keys ] ; then
        echo "la Clef publique vigiconf du serveur d'amdinistration Centrale n'a pas encore été importée, vous devriez réaliser cette opération manuelle maintenant.
Emplacement de la clef publique sur le serveur d'Administration Centrale:
    - /etc/vigilo/vigiconf/ssh/vigiconf.key.pub
Emplacement de la clef publique sur le serveur de local:
    - /var/lib/vigilo/vigiconf/.ssh/authorized_keys" | fmt
        echo "Appuyer sur ENTREZ pour continuer, ou Faite Ctrl-C pour arrêter le script" | fmt
        [ -z "$DEFAULT_PASSWORD" ] && read || :
    fi
fi
