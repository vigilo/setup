#!/bin/sh

echo "Configuration de Nagios"

cfgpatch=nagios.$DISTRO.patch

[ -f /etc/nagios/nagios.cfg.orig ] || patch -N -b /etc/nagios/nagios.cfg < $cfgpatch
[ -f /etc/nagios/vigilo.cfg ] || cp nagios-vigilo.cfg /etc/nagios/vigilo.cfg

# Sur Red Hat, lLes plugins ne sont pas fournis avec leur fichier de conf
[ "$DISTRO" == "redhat" ] && cp -p plugin-commands.cfg /etc/nagios/

# Si la machine VigiConf a aussi un Nagios installé, il faut l'ajouter au
# groupe vigiconf pour qu'il puisse valider la configuration (qui se trouve
# dans /var/lib/vigiconf, accessible uniquement au groupe vigiconf.
getent group vigiconf > /dev/null && usermod -a -G vigiconf nagios
