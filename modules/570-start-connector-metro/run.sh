# Copyright (C) 2011-2015 CS-SI
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

service=vigilo-connector-metro
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    service $service restart || exit $?
else
    service $service start || exit $?
fi
