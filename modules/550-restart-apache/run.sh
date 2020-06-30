# Copyright (C) 2011-2020 CS GROUP - France
# License: GNU GPL v2 <http://www.gnu.org/licenses/gpl-2.0.html>

# Import de la couche de compatibilité.
. "`dirname $0`/../compat.sh"

service=httpd
check_svc "$service" || exit 0

change_svc $service on
service $service status &> /dev/null
RET=$?
if [ "$RET" == "0" ]; then
    apachectl configtest && service $service restart || exit $?
else
    apachectl configtest && service $service start || exit $?
fi
