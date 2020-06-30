# Copyright (C) 2011-2020 CS GROUP – France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

if [ "$DISTRO" == "debian" ]; then
    sed -ri 's/^ENABLE_MEMCACHED=.*$/ENABLE_MEMCACHED=yes/' /etc/default/memcached
else
    sed -ri 's/^PORT=.*$/PORT="11211"/;s/^OPTIONS=.*$/OPTIONS="-U 0"/' /etc/sysconfig/memcached
fi

change_svc memcached on
service memcached status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    :
else
    service memcached start || exit $?
fi
