#!/bin/sh

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

service=vigilo-connector-nagios
change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    service $service restart || exit $?
else
    service $service start || exit $?
fi
