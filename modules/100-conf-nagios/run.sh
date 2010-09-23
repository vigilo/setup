#!/bin/sh

echo "Configuration de Nagios"

[ -f /etc/nagios/nagios.cfg.orig ] || patch -N -b /etc/nagios/nagios.cfg < nagios.patch
[ -f /etc/nagios/vigilo.cfg ] || cp nagios-vigilo.cfg /etc/nagios/vigilo.cfg

# Si la machine VigiConf a aussi un Nagios installé, il faut l'ajouter au
# groupe vigiconf pour qu'il puisse valider la configuration (qui se trouve
# dans /var/lib/vigiconf, accessible uniquement au groupe vigiconf.
getent group vigiconf > /dev/null && useradd -a -G vigiconf nagios
