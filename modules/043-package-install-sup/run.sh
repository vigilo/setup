#!/bin/sh

echo "Installation des paquets Vigilo pour un serveur de collecte"
urpmi   vigilo-collector \
        vigilo-collector-enterprise \
        vigilo-connector-nagios \
        vigilo-perfdata2vigilo \
        vigilo-vigirrd \
        vigilo-vigirrd-vigiconf

# configuration de vigiconf pour un serveur de collecte seul

# création utilisateur vigiconf
grep -qs ^vigiconf /etc/group || groupadd vigiconf
grep -qs ^vigiconf /etc/passwd || ( useradd -s /bin/bash -M -d /var/lib/vigilo/vigiconf -g vigiconf -c 'Vigilo VigiConf user' vigiconf && dd if=/dev/urandom bs=512 count=1 | base64| passwd --stdin vigiconf )
grep -qs ^vigiconf /etc/sudoers || echo 'vigiconf ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# création répertoire réception configuration
[ -d /etc/vigilo/vigiconf/     ] || mkdir  /etc/vigilo/vigiconf/
[ -d /etc/vigilo/vigiconf/new  ] || mkdir  /etc/vigilo/vigiconf/new
[ -d /etc/vigilo/vigiconf/old  ] || mkdir  /etc/vigilo/vigiconf/old
[ -d /etc/vigilo/vigiconf/prod ] || mkdir  /etc/vigilo/vigiconf/prod
echo "0" > /etc/vigilo/vigiconf/new/revisions.txt
echo "0" > /etc/vigilo/vigiconf/old/revisions.txt
echo "0" > /etc/vigilo/vigiconf/prod/revisions.txt
chown -R vigiconf:vigiconf /etc/vigilo/vigiconf/

# création répertoire utilisateur
[ -d /var/lib/vigilo/vigiconf      ] || mkdir -p /var/lib/vigilo/vigiconf
[ -d /var/lib/vigilo/vigiconf/.ssh ] || mkdir -p /var/lib/vigilo/vigiconf/.ssh

[ -e /var/lib/vigilo/vigiconf/.ssh/authorized_keys ] || ( \
echo "la Clef ssh du vigiconf du serveur d'amdinistration Centrale n'a pas encore été importée, vous devriez réaliser cette opération manuelle maintenant.
Emplacement de la clef /var/lib/vigilo/vigiconf/.ssh/authorized_keys" | fmt
echo "Appuyer sur ENTREZ pour continuer, ou Faite Ctrl-C pour arrêter le script" | fmt
read )
chown vigiconf:vigiconf -R /var/lib/vigilo/vigiconf/


