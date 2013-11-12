# Copyright (C) 2011-2013 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

if [ "$DISTRO" == "debian" ]; then
    cp -a memcached.conf /etc/supervisor/conf.d/
    service=supervisor
else
    cp -a memcached.ini /etc/supervisord.d/
    service=supervisord
fi

# Démarrage par supervisor plutôt qu'autonome.
change_svc memcached off
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service $service start || exit $?
fi
